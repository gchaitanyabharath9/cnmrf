# CNMRF Markdown Linting Script
# Basic markdown validation (fallback linter for Windows)

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)

Write-Host "Linting Markdown Files..." -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()
$filesChecked = 0

# Find all markdown files
$markdownFiles = Get-ChildItem -Path $repoRoot -Filter "*.md" -Recurse | Where-Object {
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.FullName -notmatch '\\.git\\'
}

foreach ($file in $markdownFiles) {
    $filesChecked++
    $relativePath = $file.FullName.Replace($repoRoot, "").TrimStart('\')
    
    if ($Verbose) {
        Write-Host "Checking: $relativePath" -ForegroundColor Gray
    }
    
    $content = Get-Content $file.FullName -Raw
    $lines = Get-Content $file.FullName
    
    # Check 1: File should not be empty
    if ([string]::IsNullOrWhiteSpace($content)) {
        $errors += "${relativePath}: File is empty"
        continue
    }
    
    # Check 2: Should have at least one heading
    if ($content -notmatch '^#\s+.+' -and $content -notmatch '\n#\s+.+') {
        $warnings += "${relativePath}: No headings found"
    }
    
    # Check 3: Check for multiple top-level headings (should typically have one H1)
    $h1Count = ([regex]::Matches($content, '^#\s+.+', 'Multiline')).Count
    if ($h1Count -gt 1) {
        $warnings += "${relativePath}: Multiple H1 headings found ($h1Count)"
    }
    
    # Check 4: Check for trailing whitespace
    $lineNumber = 0
    foreach ($line in $lines) {
        $lineNumber++
        if ($line -match '\s+$') {
            $warnings += "${relativePath}:${lineNumber}: Trailing whitespace"
        }
    }
    
    # Check 5: Check for broken reference-style links
    $refLinks = [regex]::Matches($content, '\[([^\]]+)\]:\s*(.+)')
    $usedRefs = [regex]::Matches($content, '\[([^\]]+)\]\[([^\]]*)\]')
    
    foreach ($used in $usedRefs) {
        $refName = if ($used.Groups[2].Value) { $used.Groups[2].Value } else { $used.Groups[1].Value }
        $found = $refLinks | Where-Object { $_.Groups[1].Value -eq $refName }
        if (-not $found) {
            $errors += "${relativePath}: Undefined reference link: $refName"
        }
    }
    
    # Check 6: Check for common markdown issues
    if ($content -match '\]\s+\(') {
        $warnings += "${relativePath}: Space between ] and ( in link"
    }
    
    if ($content -match '\[([^\]]+)\]\(\s') {
        $warnings += "${relativePath}: Space after ( in link"
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Markdown Linting Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files Checked: $filesChecked" -ForegroundColor Cyan
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
    Write-Host "Markdown linting FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Note: This is a basic fallback linter." -ForegroundColor Gray
    Write-Host "For comprehensive linting, install markdownlint-cli:" -ForegroundColor Gray
    Write-Host "  npm install -g markdownlint-cli" -ForegroundColor Gray
    Write-Host "  markdownlint '**/*.md'" -ForegroundColor Gray
    exit 1
}
else {
    Write-Host "Markdown linting PASSED ✓" -ForegroundColor Green
    if ($warnings.Count -gt 0) {
        Write-Host "(with $($warnings.Count) warnings)" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Note: This is a basic fallback linter." -ForegroundColor Gray
    Write-Host "For comprehensive linting, consider installing markdownlint-cli." -ForegroundColor Gray
    exit 0
}
