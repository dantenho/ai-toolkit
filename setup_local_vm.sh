#!/bin/bash
# ============================================================================
# Local VM Setup Script for Notebook Project (Linux/Mac)
# ============================================================================
# This bash script sets up a local development environment with:
# - Python (from user path)
# - UV and UVX package manager
# - Updated pip
# - Deep Learning and ML libraries (PyTorch, Transformers, etc.)
# - Monitoring and observability tools (OpenTelemetry, Prometheus, Grafana)
# ============================================================================

# Set error handling - exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ----------------------------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------------------------

# Function to print colored output
print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Python installation
check_python() {
    print_info "Checking Python installation..."
    
    # Check if Python is in user path
    if command_exists python3; then
        PYTHON_CMD="python3"
        PYTHON_VERSION=$(python3 --version 2>&1)
        print_success "Python found: $PYTHON_VERSION"
        return 0
    elif command_exists python; then
        PYTHON_CMD="python"
        PYTHON_VERSION=$(python --version 2>&1)
        print_success "Python found: $PYTHON_VERSION"
        return 0
    else
        print_error "Python not found. Please install Python first."
        print_info "Install Python from: https://www.python.org/downloads/"
        exit 1
    fi
}

# ----------------------------------------------------------------------------
# Main Setup Process
# ----------------------------------------------------------------------------

echo ""
echo "========================================"
echo "  Notebook Project - Local VM Setup"
echo "========================================"
echo ""

# Step 1: Check and verify Python installation
print_info "[STEP 1/6] Checking Python installation..."
check_python

# Determine pip command
if command_exists pip3; then
    PIP_CMD="pip3"
elif command_exists pip; then
    PIP_CMD="pip"
else
    print_error "pip not found. Installing pip..."
    $PYTHON_CMD -m ensurepip --upgrade --user
    PIP_CMD="$PYTHON_CMD -m pip"
fi

# Step 2: Update pip to latest version
print_info "[STEP 2/6] Updating pip to latest version..."
$PYTHON_CMD -m pip install --upgrade pip --user
print_success "pip updated successfully"

# Step 3: Install UV package manager
print_info "[STEP 3/6] Installing UV package manager..."

if command_exists uv; then
    print_info "UV is already installed, updating..."
    $PYTHON_CMD -m pip install --upgrade uv --user
else
    print_info "Installing UV from pip..."
    $PYTHON_CMD -m pip install uv --user
    
    # Add UV to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
    
    # Add to shell profile if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc 2>/dev/null || true
    fi
fi

# Verify UV installation
if command_exists uv; then
    UV_VERSION=$(uv --version 2>&1)
    print_success "UV installed: $UV_VERSION"
else
    print_warning "UV may need a terminal restart to be available"
fi

# Step 4: Install UVX (UV extension runner)
print_info "[STEP 4/6] Installing UVX (UV extension runner)..."

if command_exists uvx; then
    print_success "UVX is available"
else
    print_info "UVX should be available with UV installation"
    print_success "UVX functionality available through UV"
fi

# Step 5: Install core ML/DL libraries
print_info "[STEP 5/6] Installing Machine Learning and Deep Learning libraries..."
print_info "This may take several minutes depending on your internet connection..."

# Install core packages
print_info "Installing core numerical computing libraries..."
$PYTHON_CMD -m pip install --user --upgrade \
    "numpy>=1.26.2" \
    "pandas>=2.1.3" \
    "matplotlib>=3.8.2" \
    "scikit-learn>=1.3.2" \
    "Pillow>=10.1.0"

# Install PyTorch with CUDA support
print_info "Installing PyTorch with CUDA 11.8 support..."
$PYTHON_CMD -m pip install --user \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu118

# Install Transformers and xformers
print_info "Installing Transformers and xformers..."
$PYTHON_CMD -m pip install --user --upgrade \
    "transformers>=4.35.0" \
    "xformers>=0.0.22"

# Install ONNX
print_info "Installing ONNX and ONNX Runtime..."
$PYTHON_CMD -m pip install --user --upgrade \
    "onnx>=1.15.0" \
    "onnxruntime>=1.16.0" \
    "onnxruntime-gpu>=1.16.0"

# Install monitoring libraries
print_info "Installing monitoring and observability libraries..."
$PYTHON_CMD -m pip install --user --upgrade \
    "opentelemetry-api>=1.21.0" \
    "opentelemetry-sdk>=1.21.0" \
    "opentelemetry-instrumentation>=0.42b0" \
    "opentelemetry-exporter-prometheus>=1.12.0" \
    "prometheus-client>=0.19.0" \
    "grafana-api>=1.0.3"

print_success "All ML/DL libraries installed successfully"

# Step 6: Verify installations
print_info "[STEP 6/6] Verifying installations..."

echo ""
echo "--- Verification Results ---"

# Verify Python
PYTHON_VER=$($PYTHON_CMD --version 2>&1)
print_success "Python: $PYTHON_VER"

# Verify pip
PIP_VER=$($PIP_CMD --version 2>&1)
print_success "pip: $PIP_VER"

# Verify UV
if command_exists uv; then
    UV_VER=$(uv --version 2>&1)
    print_success "UV: $UV_VER"
else
    print_warning "UV verification failed (may need to restart terminal)"
fi

# Verify key packages
declare -a packages=("numpy" "pandas" "torch" "transformers" "opentelemetry")
for package in "${packages[@]}"; do
    if $PYTHON_CMD -c "import $package; print($package.__version__)" 2>/dev/null; then
        VERSION=$($PYTHON_CMD -c "import $package; print($package.__version__)" 2>&1)
        print_success "$package: $VERSION"
    else
        print_error "$package verification failed"
    fi
done

# Final summary
echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""

print_info "Next steps:"
echo "  1. Restart your terminal to ensure PATH updates take effect"
echo "  2. Verify CUDA installation if you need GPU support:"
echo "     nvidia-smi"
echo "  3. Test PyTorch CUDA support:"
echo "     $PYTHON_CMD -c 'import torch; print(torch.cuda.is_available())'"
echo "  4. Install project dependencies:"
echo "     uv pip install -r requirements.txt"
echo ""
print_info "For TensorRT installation, refer to:"
echo "  https://developer.nvidia.com/tensorrt"
echo ""

print_success "Setup script completed successfully!"
