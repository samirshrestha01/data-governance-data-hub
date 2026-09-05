# ============================================================
# Airbyte Environment Check
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Airbyte Environment Check" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow

try {
    docker version | Out-Null
    Write-Host "Docker: OK" -ForegroundColor Green
}
catch {
    Write-Host "Docker: NOT AVAILABLE" -ForegroundColor Red
    Write-Host "Please start Docker Desktop."
    exit 1
}

# Check abctl
Write-Host ""
Write-Host "Checking abctl..." -ForegroundColor Yellow

$abctl = Get-Command abctl -ErrorAction SilentlyContinue

if (-not $abctl) {
    Write-Host "abctl: NOT FOUND" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install abctl before continuing."
    exit 1
}

Write-Host "abctl: OK" -ForegroundColor Green
abctl version

# Check Airbyte
Write-Host ""
Write-Host "Checking Airbyte..." -ForegroundColor Yellow

abctl local status

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " Airbyte environment check completed." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

# If Airbyte is not installed, Manually install Airbyte by running `abctl local install`
# If Airbyte is installed, but not running, start Airbyte by running `abctl local start`