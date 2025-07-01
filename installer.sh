#!/bin/bash

#=================================================#
#   Automatic Installer for NyxObscura Toolkit
#=================================================#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${CYAN}${BOLD}Cloning installer repository...${RESET}"
git clone https://github.com/NyxObscura/installer.git
cd installer

echo -e "${CYAN}${BOLD}Updating packages and installing build tools...${RESET}"
sudo apt update && sudo apt install build-essential -y

echo -e "${CYAN}${BOLD}Giving execute permission to main.x...${RESET}"
chmod +x main.x

echo -e "${GREEN}${BOLD}Launching installer...${RESET}"
./main.x
