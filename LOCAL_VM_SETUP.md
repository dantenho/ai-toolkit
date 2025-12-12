# Local VM Setup Guide

## Overview

This guide provides step-by-step instructions for setting up a local development environment with Python, UV/UVX, and all required Machine Learning and Deep Learning libraries.

## Prerequisites

- **Operating System**: Windows, Linux, or macOS
- **Python**: 3.11 or higher (installed in user path)
- **Internet Connection**: Required for downloading packages
- **GPU (Optional)**: NVIDIA GPU with CUDA support for accelerated training/inference

## Quick Start

### Windows

1. Open PowerShell as Administrator (or regular user with execution policy set)
2. Navigate to project directory
3. Run the setup script:
   ```powershell
   .\setup_local_vm.ps1
   ```

### Linux/macOS

1. Open terminal
2. Navigate to project directory
3. Make script executable and run:
   ```bash
   chmod +x setup_local_vm.sh
   ./setup_local_vm.sh
   ```

## Manual Installation Steps

### Step 1: Verify Python Installation

Check if Python is installed and accessible:

**Windows:**
```powershell
python --version
# or
python3 --version
```

**Linux/macOS:**
```bash
python3 --version
```

If Python is not installed, download from [python.org](https://www.python.org/downloads/) and ensure "Add Python to PATH" is checked during installation.

### Step 2: Update pip

```bash
python -m pip install --upgrade pip --user
# or
python3 -m pip install --upgrade pip --user
```

### Step 3: Install UV and UVX

UV is a fast Python package installer and resolver:

```bash
python -m pip install uv --user --upgrade
```

UVX comes bundled with UV and allows running Python applications in isolated environments.

**Add UV to PATH:**

**Windows:**
- Add `%USERPROFILE%\.local\bin` to your PATH environment variable

**Linux/macOS:**
- Add `$HOME/.local/bin` to your PATH in `~/.bashrc` or `~/.zshrc`:
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```

Verify installation:
```bash
uv --version
uvx --version
```

### Step 4: Install GPU Support (Optional but Recommended)

#### Install CUDA Toolkit

1. **Download CUDA Toolkit** from [NVIDIA Developer](https://developer.nvidia.com/cuda-downloads)
   - Recommended version: CUDA 11.8 or 12.1
   - Select your operating system and follow installation instructions

2. **Install cuDNN** from [NVIDIA cuDNN](https://developer.nvidia.com/cudnn)
   - Extract the archive
   - Copy files to your CUDA installation directory
   - Typically: `C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8` (Windows)
   - Or: `/usr/local/cuda/` (Linux)

3. **Verify CUDA Installation:**
   ```bash
   nvidia-smi
   ```

#### Install PyTorch with CUDA Support

**For CUDA 11.8:**
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

**For CUDA 12.1:**
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

**For CPU only:**
```bash
pip install torch torchvision torchaudio
```

### Step 5: Install ML/DL Libraries

#### Option A: Using the Setup Scripts (Recommended)

The setup scripts (`setup_local_vm.ps1` for Windows or `setup_local_vm.sh` for Linux/macOS) will automatically install all required packages.

#### Option B: Manual Installation

**Install core ML libraries:**
```bash
pip install --user --upgrade \
    numpy>=1.26.2 \
    pandas>=2.1.3 \
    matplotlib>=3.8.2 \
    scikit-learn>=1.3.2 \
    Pillow>=10.1.0
```

**Install Transformers and related libraries:**
```bash
pip install --user --upgrade \
    transformers>=4.35.0 \
    xformers>=0.0.22 \
    tokenizers>=0.15.0 \
    accelerate>=0.25.0
```

**Install ONNX:**
```bash
pip install --user --upgrade \
    onnx>=1.15.0 \
    onnxruntime>=1.16.0 \
    onnxruntime-gpu>=1.16.0
```

**Install monitoring libraries:**
```bash
pip install --user --upgrade \
    opentelemetry-api>=1.21.0 \
    opentelemetry-sdk>=1.21.0 \
    opentelemetry-instrumentation>=0.42b0 \
    opentelemetry-exporter-prometheus>=1.12.0 \
    prometheus-client>=0.19.0 \
    grafana-api>=1.0.3
```

#### Option C: Using Requirements Files

**Install all project dependencies:**
```bash
uv pip install -r requirements.txt
```

**Install ML/DL specific dependencies:**
```bash
uv pip install -r requirements-ml.txt
```

### Step 6: Install TensorRT (Optional, for Advanced GPU Acceleration)

TensorRT provides optimized inference for NVIDIA GPUs:

1. **Download TensorRT** from [NVIDIA TensorRT](https://developer.nvidia.com/tensorrt)
2. **Extract and install:**
   ```bash
   # Extract TensorRT archive
   # Navigate to extracted directory
   pip install python/tensorrt-*.whl
   ```
3. **Verify installation:**
   ```python
   import tensorrt
   print(tensorrt.__version__)
   ```

## Verification

### Verify Python and pip
```bash
python --version
pip --version
```

### Verify UV
```bash
uv --version
uvx --version
```

### Verify PyTorch and CUDA
```python
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
```

### Verify Transformers
```python
from transformers import pipeline
print("Transformers installed successfully")
```

### Verify ONNX
```python
import onnx
import onnxruntime
print(f"ONNX version: {onnx.__version__}")
print(f"ONNX Runtime version: {onnxruntime.__version__}")
```

### Verify Monitoring Libraries
```python
from opentelemetry import trace
from prometheus_client import Counter
print("OpenTelemetry and Prometheus installed successfully")
```

## Troubleshooting

### Python Not Found

**Windows:**
- Ensure Python is added to PATH during installation
- Or add manually: `%USERPROFILE%\AppData\Local\Programs\Python\Python3XX`

**Linux/macOS:**
- Install Python via package manager: `sudo apt install python3` (Ubuntu/Debian)
- Or use Homebrew: `brew install python3` (macOS)

### CUDA Not Detected

1. Verify NVIDIA drivers are installed: `nvidia-smi`
2. Check CUDA installation: `nvcc --version`
3. Ensure PyTorch CUDA version matches installed CUDA version
4. Reinstall PyTorch with correct CUDA index URL

### UV Not Found After Installation

1. Restart terminal/command prompt
2. Verify PATH includes UV installation directory
3. Manually add to PATH if needed

### Package Installation Failures

1. **Upgrade pip first:**
   ```bash
   python -m pip install --upgrade pip
   ```

2. **Use --user flag:**
   ```bash
   pip install --user <package>
   ```

3. **Clear pip cache:**
   ```bash
   pip cache purge
   ```

4. **Install packages individually** to identify problematic packages

### GPU Memory Issues

- Reduce batch size in training scripts
- Use mixed precision training
- Clear GPU cache: `torch.cuda.empty_cache()`

## Next Steps

After successful installation:

1. **Install project dependencies:**
   ```bash
   uv pip install -r requirements.txt
   ```

2. **Set up virtual environment (recommended):**
   ```bash
   uv venv
   source .venv/bin/activate  # Linux/macOS
   # or
   .venv\Scripts\activate  # Windows
   ```

3. **Run tests to verify setup:**
   ```bash
   pytest tests/
   ```

4. **Start development:**
   - Review project documentation
   - Check `Agens.MD` for coding standards
   - Follow Git workflow guidelines

## Additional Resources

- [PyTorch Installation Guide](https://pytorch.org/get-started/locally/)
- [CUDA Installation Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)
- [UV Documentation](https://github.com/astral-sh/uv)
- [Transformers Documentation](https://huggingface.co/docs/transformers)
- [ONNX Documentation](https://onnx.ai/onnx/)

## Support

For issues or questions:
1. Check existing GitHub issues
2. Review project documentation
3. Create a new issue with detailed error information
