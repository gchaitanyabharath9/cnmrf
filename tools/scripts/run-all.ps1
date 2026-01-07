# CNMRF Quality Gates - Run All Validation Scripts
# This script runs all quality gate validations in sequence

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CNMRF Quality Gates" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$failedGates = @()
$passedGates = @()

# Function to run a quality gate script
function Invoke-QualityGate {
    param(
        [string]$Name,
        [string]$ScriptPath
    )
    
    Write-Host "Running: $Name" -ForegroundColor Yellow
    Write-Host "----------------------------------------"
    
    $result = & $ScriptPath
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host "✓ PASSED: $Name" -ForegroundColor Green
        $script:passedGates += $Name
    } else {
        Write-Host "✗ FAILED: $Name" -ForegroundColor Red
        $script:failedGates += $Name
    }
    
    Write-Host ""
    return $exitCode
}

# Change to repository root
Push-Location $repoRoot

try {
    # Run quality gates
    Invoke-QualityGate -Name "Structure Validation" -ScriptPath "$scriptPath\verify-structure.ps1"
    Invoke-QualityGate -Name "Markdown Linting" -ScriptPath "$scriptPath\lint-markdown.ps1"
    Invoke-QualityGate -Name "Link Checking" -ScriptPath "$scriptPath\check-links.ps1"
    
    # Summary
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Quality Gates Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Passed: $($passedGates.Count)" -ForegroundColor Green
    foreach ($gate in $passedGates) {
        Write-Host "  ✓ $gate" -ForegroundColor Green
    }
    Write-Host ""
    
    if ($failedGates.Count -gt 0) {
        Write-Host "Failed: $($failedGates.Count)" -ForegroundColor Red
        foreach ($gate in $failedGates) {
            Write-Host "  ✗ $gate" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "Some quality gates failed. Please fix the issues and try again." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "All quality gates passed! ✓" -ForegroundColor Green
        exit 0
    }
    
} finally {
    Pop-Location
}
