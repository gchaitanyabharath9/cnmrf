# CNMRF Structure Validation Script
# Validates that the repository structure matches expected layout

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)

Write-Host "Validating CNMRF Repository Structure..." -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()

# Function to check if path exists
function Test-PathExists {
    param(
        [string]$Path,
        [string]$Type,
        [bool]$Required = $true
    )
    
    $fullPath = Join-Path $repoRoot $Path
    $exists = Test-Path $fullPath
    
    if ($exists) {
        if ($Verbose) {
            Write-Host "  ✓ $Path" -ForegroundColor Green
        }
        return $true
    }
    else {
        if ($Required) {
            $script:errors += "Missing required $Type : $Path"
            Write-Host "  ✗ Missing: $Path" -ForegroundColor Red
        }
        else {
            $script:warnings += "Missing optional $Type : $Path"
            if ($Verbose) {
                Write-Host "  ⚠ Missing (optional): $Path" -ForegroundColor Yellow
            }
        }
        return $false
    }
}

# Check root files
Write-Host "Checking root files..." -ForegroundColor Yellow
Test-PathExists -Path "README.md" -Type "file" -Required $true
Test-PathExists -Path ".git" -Type "directory" -Required $true

# Check documentation structure
Write-Host "Checking documentation structure..." -ForegroundColor Yellow
Test-PathExists -Path "docs" -Type "directory" -Required $true
Test-PathExists -Path "docs\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\architecture" -Type "directory" -Required $true
Test-PathExists -Path "docs\architecture\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\architecture\reference-architecture.md" -Type "file" -Required $true
Test-PathExists -Path "docs\architecture\nfr-baseline.md" -Type "file" -Required $true
Test-PathExists -Path "docs\adr" -Type "directory" -Required $true
Test-PathExists -Path "docs\adr\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\adr\0000-adr-template.md" -Type "file" -Required $true
Test-PathExists -Path "docs\security" -Type "directory" -Required $true
Test-PathExists -Path "docs\security\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\resiliency" -Type "directory" -Required $true
Test-PathExists -Path "docs\resiliency\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\platform" -Type "directory" -Required $true
Test-PathExists -Path "docs\platform\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\cicd" -Type "directory" -Required $true
Test-PathExists -Path "docs\cicd\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\governance" -Type "directory" -Required $true
Test-PathExists -Path "docs\governance\README.md" -Type "file" -Required $true
Test-PathExists -Path "docs\governance\project-outline.md" -Type "file" -Required $true

# Check templates structure
Write-Host "Checking templates structure..." -ForegroundColor Yellow
Test-PathExists -Path "templates" -Type "directory" -Required $true
Test-PathExists -Path "templates\README.md" -Type "file" -Required $true
Test-PathExists -Path "templates\microservice-springboot" -Type "directory" -Required $true
Test-PathExists -Path "templates\microservice-springboot\README.md" -Type "file" -Required $true
Test-PathExists -Path "templates\microservice-dotnet" -Type "directory" -Required $true
Test-PathExists -Path "templates\microservice-dotnet\README.md" -Type "file" -Required $true
Test-PathExists -Path "templates\infra-helm" -Type "directory" -Required $true
Test-PathExists -Path "templates\infra-helm\README.md" -Type "file" -Required $true
Test-PathExists -Path "templates\gitops-argocd" -Type "directory" -Required $true
Test-PathExists -Path "templates\gitops-argocd\README.md" -Type "file" -Required $true

# Check examples structure
Write-Host "Checking examples structure..." -ForegroundColor Yellow
Test-PathExists -Path "examples" -Type "directory" -Required $true
Test-PathExists -Path "examples\README.md" -Type "file" -Required $true

# Check tools structure
Write-Host "Checking tools structure..." -ForegroundColor Yellow
Test-PathExists -Path "tools" -Type "directory" -Required $true
Test-PathExists -Path "tools\README.md" -Type "file" -Required $true
Test-PathExists -Path "tools\scripts" -Type "directory" -Required $true
Test-PathExists -Path "tools\scripts\README.md" -Type "file" -Required $true
Test-PathExists -Path "tools\scripts\run-all.ps1" -Type "file" -Required $true
Test-PathExists -Path "tools\scripts\verify-structure.ps1" -Type "file" -Required $true
Test-PathExists -Path "tools\scripts\lint-markdown.ps1" -Type "file" -Required $true
Test-PathExists -Path "tools\scripts\check-links.ps1" -Type "file" -Required $true

# Check for Project Outline (critical governance document)
Write-Host "Checking governance documents..." -ForegroundColor Yellow
$projectOutlinePath = Join-Path $repoRoot "docs\governance\project-outline.md"
if (Test-Path $projectOutlinePath) {
    $content = Get-Content $projectOutlinePath -Raw
    if ($content -match "Cloud-Native Modernization Reference Framework") {
        Write-Host "  ✓ Project Outline contains expected content" -ForegroundColor Green
    }
    else {
        $errors += "Project Outline exists but may be incomplete"
        Write-Host "  ⚠ Project Outline may be incomplete" -ForegroundColor Yellow
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Structure Validation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
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
    Write-Host "Structure validation FAILED" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "Structure validation PASSED ✓" -ForegroundColor Green
    if ($warnings.Count -gt 0) {
        Write-Host "(with $($warnings.Count) warnings)" -ForegroundColor Yellow
    }
    exit 0
}
