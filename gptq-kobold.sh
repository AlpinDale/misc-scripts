#!/bin/bash

set -e

# Detect the Linux distribution
if [ -f /etc/arch-release ]; then
    installer="sudo pacman -S"
    python_command="python"
elif [ -f /etc/debian_version ]; then
    installer="sudo apt install"
    python_command="python3"
elif [ -f /etc/redhat-release ]; then
    installer="sudo yum install"
    python_command="python"
else
    echo "Unsupported distribution"
    exit 1
fi

# Check if required packages are already installed
if ! command -v git &> /dev/null; then
    $installer git
fi
if ! command -v clang &> /dev/null; then
    $installer clang
fi

git clone https://github.com/0cc4m/KoboldAI -b latestgptq --recurse-submodules && cd KoboldAI

chmod +x ./install_requirements.sh
./install_requirements.sh

chmod +x ./commandline.sh
./commandline.sh

cd repos/gptq

# Use the $python_command variable to run the appropriate version of Python
$python_command setup_cuda.py install
conda deactivate

cd ../..
./play.sh
