#!/bin/bash

#=================================================#
#   Automatic Installer for NyxObscura Toolkit
#=================================================#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${CYAN}${BOLD}Cloning installer repository...${RESET}"
git clone https://github.com/NyxObscura/installer.git > /dev/null 2>&1
cd installer 

echo -e "${CYAN}${BOLD}Updating packages and installing build tools...${RESET}"
sudo apt update && sudo apt install build-essential -y > /dev/null 2>&1

# Detect OS & architecture
ARCH=$(uname -m)
OS=$(uname)

echo -e "${CYAN}${BOLD}Detecting system architecture...${RESET}"
echo -e "${CYAN}OS: ${OS}, Architecture: ${ARCH}${RESET}"

# Select binary based on system
BINARY=""

if [[ "$OS" == "Linux" ]]; then
    case "$ARCH" in
        x86_64)
            BINARY="main_x86_64_linux.x"
            ;;
        aarch64)
            # Assumption: Android (Termux) or ARM64 Linux
            if [[ "$(uname -o 2>/dev/null)" == "Android" ]]; then
                BINARY="main_arm_64_android.x"
            else
                BINARY="main_arm_64_linux.x"  # If you ever add this
            fi
            ;;
        armv7l|armv6l)
            BINARY="main_arm_32_rpi.x"
            ;;
        *)
            echo -e "${RED}${BOLD}Unsupported architecture: ${ARCH}${RESET}"
            exit 1
            ;;
    esac
else
    echo -e "${RED}${BOLD}Unsupported OS: ${OS}${RESET}"
    exit 1
fi

# Run selected binary
if [[ -f "$BINARY" ]]; then
    echo -e "${CYAN}${BOLD}Giving execute permission to ${BINARY}...${RESET}"
    chmod +x "$BINARY"

    echo -e "${GREEN}${BOLD}Launching ${BINARY}...${RESET}"
    ./"$BINARY"
else
    echo -e "${RED}${BOLD}Error: ${BINARY} not found in current directory.${RESET}"
    exit 1
fi
