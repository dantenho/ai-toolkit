@echo off
REM Quick WSL and Ubuntu Installation Batch Script
REM State-of-the-art: Simple one-click WSL2 and Ubuntu installation

echo ========================================
echo WSL and Ubuntu Installation
echo ========================================
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires Administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo [1/4] Enabling WSL feature...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart

echo [2/4] Enabling Virtual Machine Platform...
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /norestart

echo [3/4] Updating WSL...
wsl --update

echo [4/4] Setting WSL2 as default...
wsl --set-default-version 2

echo Installing Ubuntu...
wsl --install -d Ubuntu

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo IMPORTANT: You may need to restart your computer.
echo After restart, launch Ubuntu and create your user account.
echo.
echo Current WSL distributions:
wsl --list --verbose

pause

