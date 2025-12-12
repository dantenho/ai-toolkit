# WSL and Ubuntu Installation Guide

This guide helps you install Windows Subsystem for Linux (WSL) and Ubuntu on your Windows system.

## Quick Installation

### Option 1: PowerShell Script (Recommended)
1. Right-click `install-wsl-ubuntu.ps1`
2. Select "Run with PowerShell" (or run as Administrator)
3. Follow the prompts

### Option 2: Batch File
1. Right-click `install-wsl-ubuntu.bat`
2. Select "Run as administrator"
3. Follow the prompts

### Option 3: Manual Installation

#### Step 1: Enable WSL
Open PowerShell as Administrator and run:
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
```

#### Step 2: Enable Virtual Machine Platform
```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /norestart
```

#### Step 3: Update WSL
```powershell
wsl --update
```

#### Step 4: Set WSL2 as Default
```powershell
wsl --set-default-version 2
```

#### Step 5: Install Ubuntu
```powershell
wsl --install -d Ubuntu
```

## After Installation

1. **Restart your computer** if prompted
2. Launch Ubuntu from the Start Menu or run `wsl` in PowerShell
3. Create your Linux username and password when prompted
4. Update Ubuntu packages:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

## Useful WSL Commands

- List installed distributions: `wsl --list --verbose`
- Set default distribution: `wsl --set-default <DistributionName>`
- Launch specific distribution: `wsl -d <DistributionName>`
- Shutdown WSL: `wsl --shutdown`
- Update WSL: `wsl --update`

## Troubleshooting

### WSL2 requires Windows 10 version 1903 or higher
Check your Windows version:
```powershell
winver
```

### If Ubuntu doesn't appear after installation
1. Restart your computer
2. Check installed distributions: `wsl --list --verbose`
3. Manually install from Microsoft Store: https://aka.ms/wslstore

### If WSL2 is not available
Make sure:
- Virtual Machine Platform is enabled
- Your CPU supports virtualization (enabled in BIOS)
- Hyper-V is not conflicting (usually not an issue)

## System Requirements

- Windows 10 version 1903 or higher (or Windows 11)
- 64-bit processor with virtualization support
- Administrator privileges

## Additional Resources

- [WSL Documentation](https://docs.microsoft.com/windows/wsl/)
- [Ubuntu on WSL](https://ubuntu.com/wsl)
- [WSL GitHub](https://github.com/microsoft/WSL)

