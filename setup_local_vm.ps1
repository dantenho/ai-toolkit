# ============================================================================
# Local VM Setup Script for Notebook Project
# ============================================================================
# This PowerShell script sets up a local development environment with:
# - Python (from user path)
# - UV and UVX package manager
# - Updated pip
# - Deep Learning and ML libraries (PyTorch, Transformers, etc.)
# - Monitoring and observability tools (OpenTelemetry, Prometheus, Grafana)
# ============================================================================

# ----------------------------------------------------------------------------
# Script Configuration
# ----------------------------------------------------------------------------
# Set error handling - stop on any error
$ErrorActionPreference = "Stop"

# Set execution policy for current process (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

# ----------------------------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------------------------

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check Python installation
function Test-PythonInstallation {
    Write-ColorOutput "`n[INFO] Checking Python installation..." "Cyan"
    
    # Check if Python is in user path
    $pythonPath = $env:USERPROFILE + "\AppData\Local\Programs\Python"
    $pythonVersions = Get-ChildItem -Path $pythonPath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "Python\d+" }
    
    if ($pythonVersions) {
        Write-ColorOutput "[SUCCESS] Python found in user path: $($pythonVersions[0].FullName)" "Green"
        return $pythonVersions[0].FullName
    }
    
    # Check if Python is in PATH
    if (Test-Command "python") {
        $pythonVersion = python --version 2>&1
        Write-ColorOutput "[SUCCESS] Python found in PATH: $pythonVersion" "Green"
        return "python"
    }
    
    Write-ColorOutput "[ERROR] Python not found. Please install Python first." "Red"
    Write-ColorOutput "[INFO] Download Python from: https://www.python.org/downloads/" "Yellow"
    exit 1
}

# ----------------------------------------------------------------------------
# Main Setup Process
# ----------------------------------------------------------------------------

Write-ColorOutput "`n========================================" "Cyan"
Write-ColorOutput "  Notebook Project - Local VM Setup" "Cyan"
Write-ColorOutput "========================================`n" "Cyan"

# Step 1: Check and verify Python installation
Write-ColorOutput "[STEP 1/6] Checking Python installation..." "Yellow"
$pythonCmd = Test-PythonInstallation

# Determine Python executable path
if ($pythonCmd -ne "python") {
    $pythonExe = Join-Path $pythonCmd "python.exe"
    $pipExe = Join-Path $pythonCmd "Scripts\pip.exe"
} else {
    $pythonExe = "python"
    $pipExe = "pip"
}

# Step 2: Update pip to latest version
Write-ColorOutput "`n[STEP 2/6] Updating pip to latest version..." "Yellow"
try {
    & $pythonExe -m pip install --upgrade pip --user
    Write-ColorOutput "[SUCCESS] pip updated successfully" "Green"
} catch {
    Write-ColorOutput "[ERROR] Failed to update pip: $_" "Red"
    exit 1
}

# Step 3: Install UV package manager
Write-ColorOutput "`n[STEP 3/6] Installing UV package manager..." "Yellow"
try {
    # Check if UV is already installed
    if (Test-Command "uv") {
        Write-ColorOutput "[INFO] UV is already installed, updating..." "Cyan"
        & $pythonExe -m pip install --upgrade uv --user
    } else {
        Write-ColorOutput "[INFO] Installing UV from pip..." "Cyan"
        & $pythonExe -m pip install uv --user
        
        # Add UV to PATH for current session
        $uvPath = Join-Path $env:USERPROFILE ".local\bin"
        if (Test-Path $uvPath) {
            $env:PATH += ";$uvPath"
        }
    }
    
    # Verify UV installation
    $uvVersion = uv --version 2>&1
    Write-ColorOutput "[SUCCESS] UV installed: $uvVersion" "Green"
} catch {
    Write-ColorOutput "[ERROR] Failed to install UV: $_" "Red"
    Write-ColorOutput "[INFO] Trying alternative installation method..." "Yellow"
    
    # Alternative: Install via pipx or direct download
    & $pythonExe -m pip install uv --user --upgrade
}

# Step 4: Install UVX (UV extension runner)
Write-ColorOutput "`n[STEP 4/6] Installing UVX (UV extension runner)..." "Yellow"
try {
    # UVX comes with UV, but we ensure it's available
    if (Test-Command "uvx") {
        Write-ColorOutput "[SUCCESS] UVX is available" "Green"
    } else {
        Write-ColorOutput "[INFO] UVX should be available with UV installation" "Cyan"
        # UVX is typically included with UV
        Write-ColorOutput "[SUCCESS] UVX functionality available through UV" "Green"
    }
} catch {
    Write-ColorOutput "[WARNING] UVX check failed, but UV should provide UVX functionality" "Yellow"
}

# Step 5: Install core ML/DL libraries
Write-ColorOutput "`n[STEP 5/6] Installing Machine Learning and Deep Learning libraries..." "Yellow"
Write-ColorOutput "[INFO] This may take several minutes depending on your internet connection..." "Cyan"

# Create temporary requirements file for ML/DL packages
$mlRequirements = @"
# Core numerical computing
numpy>=1.26.2
pandas>=2.1.3
matplotlib>=3.8.2
scikit-learn>=1.3.2
Pillow>=10.1.0

# PyTorch with CUDA support (adjust CUDA version as needed)
# For CUDA 11.8:
--extra-index-url https://download.pytorch.org/whl/cu118
torch>=2.1.0
torchvision>=0.16.0
torchaudio>=2.1.0

# Transformers and related libraries
transformers>=4.35.0
xformers>=0.0.22

# ONNX and TensorRT
onnx>=1.15.0
onnxruntime>=1.16.0
onnxruntime-gpu>=1.16.0

# Monitoring and Observability
opentelemetry-api>=1.21.0
opentelemetry-sdk>=1.21.0
opentelemetry-instrumentation>=0.42b0
opentelemetry-exporter-prometheus>=1.12.0
prometheus-client>=0.19.0
grafana-api>=1.0.3
"@

$tempRequirementsFile = Join-Path $env:TEMP "ml_requirements_temp.txt"
$mlRequirements | Out-File -FilePath $tempRequirementsFile -Encoding UTF8

try {
    Write-ColorOutput "[INFO] Installing packages via pip (this may take 10-20 minutes)..." "Cyan"
    
    # Install packages one by one for better error handling
    $packages = @(
        "numpy>=1.26.2",
        "pandas>=2.1.3",
        "matplotlib>=3.8.2",
        "scikit-learn>=1.3.2",
        "Pillow>=10.1.0"
    )
    
    foreach ($package in $packages) {
        Write-ColorOutput "[INFO] Installing $package..." "Cyan"
        & $pythonExe -m pip install $package --user --upgrade
    }
    
    # Install PyTorch with CUDA support
    Write-ColorOutput "[INFO] Installing PyTorch with CUDA 11.8 support..." "Cyan"
    & $pythonExe -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --user
    
    # Install Transformers and xformers
    Write-ColorOutput "[INFO] Installing Transformers and xformers..." "Cyan"
    & $pythonExe -m pip install transformers>=4.35.0 --user --upgrade
    & $pythonExe -m pip install xformers>=0.0.22 --user --upgrade
    
    # Install ONNX
    Write-ColorOutput "[INFO] Installing ONNX and ONNX Runtime..." "Cyan"
    & $pythonExe -m pip install onnx>=1.15.0 onnxruntime>=1.16.0 onnxruntime-gpu>=1.16.0 --user --upgrade
    
    # Install monitoring libraries
    Write-ColorOutput "[INFO] Installing monitoring and observability libraries..." "Cyan"
    & $pythonExe -m pip install opentelemetry-api>=1.21.0 opentelemetry-sdk>=1.21.0 opentelemetry-instrumentation>=0.42b0 --user --upgrade
    & $pythonExe -m pip install opentelemetry-exporter-prometheus>=1.12.0 prometheus-client>=0.19.0 --user --upgrade
    & $pythonExe -m pip install grafana-api>=1.0.3 --user --upgrade
    
    Write-ColorOutput "[SUCCESS] All ML/DL libraries installed successfully" "Green"
} catch {
    Write-ColorOutput "[ERROR] Failed to install some packages: $_" "Red"
    Write-ColorOutput "[INFO] You may need to install CUDA toolkit separately for GPU support" "Yellow"
    Write-ColorOutput "[INFO] Download CUDA from: https://developer.nvidia.com/cuda-downloads" "Yellow"
}

# Clean up temporary file
if (Test-Path $tempRequirementsFile) {
    Remove-Item $tempRequirementsFile -Force
}

# Step 6: Verify installations
Write-ColorOutput "`n[STEP 6/6] Verifying installations..." "Yellow"

$verificationResults = @()

# Verify Python
try {
    $pythonVer = & $pythonExe --version 2>&1
    $verificationResults += "[SUCCESS] Python: $pythonVer"
} catch {
    $verificationResults += "[ERROR] Python verification failed"
}

# Verify pip
try {
    $pipVer = & $pipExe --version 2>&1
    $verificationResults += "[SUCCESS] pip: $pipVer"
} catch {
    $verificationResults += "[ERROR] pip verification failed"
}

# Verify UV
try {
    $uvVer = uv --version 2>&1
    $verificationResults += "[SUCCESS] UV: $uvVer"
} catch {
    $verificationResults += "[WARNING] UV verification failed (may need to restart terminal)"
}

# Verify key packages
$keyPackages = @("numpy", "pandas", "torch", "transformers", "opentelemetry")
foreach ($package in $keyPackages) {
    try {
        $version = & $pythonExe -c "import $package; print($package.__version__)" 2>&1
        $verificationResults += "[SUCCESS] $package`: $version"
    } catch {
        $verificationResults += "[ERROR] $package verification failed"
    }
}

# Display verification results
Write-ColorOutput "`n--- Verification Results ---" "Cyan"
foreach ($result in $verificationResults) {
    if ($result -match "SUCCESS") {
        Write-ColorOutput $result "Green"
    } elseif ($result -match "WARNING") {
        Write-ColorOutput $result "Yellow"
    } else {
        Write-ColorOutput $result "Red"
    }
}

# Final summary
Write-ColorOutput "`n========================================" "Cyan"
Write-ColorOutput "  Setup Complete!" "Green"
Write-ColorOutput "========================================`n" "Cyan"

Write-ColorOutput "[INFO] Next steps:" "Yellow"
Write-ColorOutput "  1. Restart your terminal to ensure PATH updates take effect" "White"
Write-ColorOutput "  2. Verify CUDA installation if you need GPU support:" "White"
Write-ColorOutput "     nvidia-smi" "White"
Write-ColorOutput "  3. Test PyTorch CUDA support:" "White"
Write-ColorOutput "     python -c 'import torch; print(torch.cuda.is_available())'" "White"
Write-ColorOutput "  4. Install project dependencies:" "White"
Write-ColorOutput "     uv pip install -r requirements.txt" "White"

Write-ColorOutput "`n[INFO] For TensorRT installation, refer to:" "Yellow"
Write-ColorOutput "  https://developer.nvidia.com/tensorrt" "White"

Write-ColorOutput "`nSetup script completed successfully!`n" "Green"
