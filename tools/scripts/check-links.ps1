# CNMRF Link Checking Script
# Validates internal markdown links

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)

Write-Host "Checking Internal Links..." -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()
$filesChecked = 0
$linksChecked = 0

# Find all markdown files
$markdownFiles = Get-ChildItem -Path $repoRoot -Filter "*.md" -Recurse | Where-Object {
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.FullName -notmatch '\\.git\\'
}

foreach ($file in $markdownFiles) {
    $filesChecked++
    $relativePath = $file.FullName.Replace($repoRoot, "").TrimStart('\')
    $fileDir = Split-Path $file.FullName -Parent
    
    if ($Verbose) {
        Write-Host "Checking links in: $relativePath" -ForegroundColor Gray
    }
    
    $content = Get-Content $file.FullName -Raw
    
    # Find all markdown links [text](url)
    $links = [regex]::Matches($content, '\[([^\]]+)\]\(([^)]+)\)')
    
    foreach ($link in $links) {
        $linkText = $link.Groups[1].Value
        $linkUrl = $link.Groups[2].Value
        $linksChecked++
        
        # Skip external links (http, https, mailto, etc.)
        if ($linkUrl -match '^https?://' -or $linkUrl -match '^mailto:' -or $linkUrl -match '^#') {
            continue
        }
        
        # Handle anchor links within same file
        if ($linkUrl -match '^#(.+)$') {
            # For now, skip anchor validation (would require parsing headings)
            continue
        }
        
        # Handle relative links
        $targetPath = $linkUrl -replace '#.*$', ''  # Remove anchor
        
        if ([string]::IsNullOrWhiteSpace($targetPath)) {
            continue
        }
        
        # Resolve relative path
        $fullTargetPath = Join-Path $fileDir $targetPath
        $fullTargetPath = [System.IO.Path]::GetFullPath($fullTargetPath)
        
        # Check if target exists
        if (-not (Test-Path $fullTargetPath)) {
            $errors += "${relativePath}: Broken link to '$linkUrl'"
            if ($Verbose) {
                Write-Host "  ✗ Broken: $linkUrl" -ForegroundColor Red
            }
        }
        else {
            if ($Verbose) {
                Write-Host "  ✓ Valid: $linkUrl" -ForegroundColor Green
            }
        }
    }
    
    # Find reference-style links [text][ref] and [ref]: url
    $refLinks = @{}
    $refDefinitions = [regex]::Matches($content, '^\[([^\]]+)\]:\s*(.+)', 'Multiline')
    
    foreach ($refDef in $refDefinitions) {
        $refName = $refDef.Groups[1].Value
        $refUrl = $refDef.Groups[2].Value.Trim()
        $refLinks[$refName] = $refUrl
    }
    
    $refUsages = [regex]::Matches($content, '\[([^\]]+)\]\[([^\]]*)\]')
    
    foreach ($refUsage in $refUsages) {
        $refName = if ($refUsage.Groups[2].Value) { $refUsage.Groups[2].Value } else { $refUsage.Groups[1].Value }
        
        if ($refLinks.ContainsKey($refName)) {
            $linkUrl = $refLinks[$refName]
            $linksChecked++
            
            # Skip external links
            if ($linkUrl -match '^https?://' -or $linkUrl -match '^mailto:' -or $linkUrl -match '^#') {
                continue
            }
            
            # Check relative link
            $targetPath = $linkUrl -replace '#.*$', ''
            if ([string]::IsNullOrWhiteSpace($targetPath)) {
                continue
            }
            
            $fullTargetPath = Join-Path $fileDir $targetPath
            $fullTargetPath = [System.IO.Path]::GetFullPath($fullTargetPath)
            
            if (-not (Test-Path $fullTargetPath)) {
                $errors += "${relativePath}: Broken reference link [$refName] to '$linkUrl'"
            }
        }
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Link Checking Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files Checked: $filesChecked" -ForegroundColor Cyan
Write-Host "Links Checked: $linksChecked" -ForegroundColor Cyan
Write-Host ""

if ($warnings.Count -gt 0) {
    Write-Host "Warnings: $($warnings.Count)" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  ⚠ $warning" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($errors.Count -gt 0) {
    Write-Host "Errors: $($errors.Count)" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  ✗ $error" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Link checking FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Note: This script checks internal relative links only." -ForegroundColor Gray
    Write-Host "External links (http/https) are not validated." -ForegroundColor Gray
    exit 1
}
else {
    Write-Host "Link checking PASSED ✓" -ForegroundColor Green
    if ($warnings.Count -gt 0) {
        Write-Host "(with $($warnings.Count) warnings)" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Note: External links (http/https) were not validated." -ForegroundColor Gray
    exit 0
}
