# WSL Installation and Ubuntu Setup Script
# This script updates WSL and installs Ubuntu on Windows
# State-of-the-art: Automated WSL2 installation with Ubuntu distribution

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges." -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host "=== WSL Installation and Ubuntu Setup ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Enable WSL feature
Write-Host "[1/4] Enabling WSL feature..." -ForegroundColor Yellow
try {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction Stop
    Write-Host "✓ WSL feature enabled" -ForegroundColor Green
} catch {
    Write-Host "✗ Error enabling WSL: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Enable Virtual Machine Platform (required for WSL2)
Write-Host "[2/4] Enabling Virtual Machine Platform..." -ForegroundColor Yellow
try {
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -ErrorAction Stop
    Write-Host "✓ Virtual Machine Platform enabled" -ForegroundColor Green
} catch {
    Write-Host "✗ Error enabling Virtual Machine Platform: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Update WSL to latest version
Write-Host "[3/4] Updating WSL to latest version..." -ForegroundColor Yellow
try {
    wsl --update
    Write-Host "✓ WSL updated successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Error updating WSL: $_" -ForegroundColor Red
    Write-Host "Continuing anyway..." -ForegroundColor Yellow
}

# Step 4: Set WSL2 as default version
Write-Host "Setting WSL2 as default version..." -ForegroundColor Yellow
try {
    wsl --set-default-version 2
    Write-Host "✓ WSL2 set as default version" -ForegroundColor Green
} catch {
    Write-Host "⚠ Warning: Could not set WSL2 as default. You may need to restart first." -ForegroundColor Yellow
}

# Step 5: Install Ubuntu
Write-Host "[4/4] Installing Ubuntu..." -ForegroundColor Yellow
try {
    # Check if Ubuntu is already installed
    $ubuntuInstalled = wsl --list --quiet | Select-String -Pattern "Ubuntu"
    
    if ($ubuntuInstalled) {
        Write-Host "✓ Ubuntu is already installed" -ForegroundColor Green
        Write-Host "Listing installed distributions:" -ForegroundColor Cyan
        wsl --list --verbose
    } else {
        Write-Host "Downloading and installing Ubuntu..." -ForegroundColor Yellow
        wsl --install -d Ubuntu
        Write-Host "✓ Ubuntu installation initiated" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: You may need to restart your computer for changes to take effect." -ForegroundColor Yellow
        Write-Host "After restart, Ubuntu will be available and you'll be prompted to create a user account." -ForegroundColor Yellow
    }
} catch {
    Write-Host "✗ Error installing Ubuntu: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "You can manually install Ubuntu by running:" -ForegroundColor Yellow
    Write-Host "  wsl --install -d Ubuntu" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or download from Microsoft Store:" -ForegroundColor Yellow
    Write-Host "  https://aka.ms/wslstore" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=== Installation Summary ===" -ForegroundColor Cyan
Write-Host "Current WSL distributions:" -ForegroundColor Yellow
wsl --list --verbose

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Restart your computer if prompted" -ForegroundColor Yellow
Write-Host "2. After restart, launch Ubuntu from Start Menu or run: wsl" -ForegroundColor Yellow
Write-Host "3. Create your Linux username and password when prompted" -ForegroundColor Yellow
Write-Host "4. Update Ubuntu packages: sudo apt update && sudo apt upgrade -y" -ForegroundColor Yellow

