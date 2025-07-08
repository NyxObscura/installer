#!/bin/bash

#=================================================#
#   Automatic Installer for NyxObscura Toolkit
#           -- Enhanced Edition --
#=================================================#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'
CHECK="✅"
CROSS="❌"

print_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo '╔══════════════════════════════════════════════════════════════╗'
    echo '║             🚀  PTERODACTYL UTILITY SCRIPT  🚀               ║'
    echo '╟──────────────────────────────────────────────────────────────╢'
    echo -e "║ ${RESET}${BOLD}Created by: ${ORANGE}NyxObscura${CYAN}${BOLD}                                       ║"
    echo -e "║ ${RESET}GitHub     : ${BLUE}https://github.com/NyxObscura/installer${CYAN}${BOLD}         ║"
    echo -e "║ ${RESET}License    : © 2023–2025 NyxObscura. All rights reserved.    ${CYAN}${BOLD}║"
    echo -e "║ ${RESET}API Docs   : ${BLUE}https://docs.obscuraworks.com${CYAN}${BOLD}                   ║"
    echo '╚══════════════════════════════════════════════════════════════╝'
    echo -e "${RESET}"
}


run_task() {
    local msg=$1
    local cmd=$2
    local spin='-\|/'
    local i=0

    
    echo -n -e "  ${CYAN}${msg}... ${RESET}"
    
    
    eval "$cmd" > /dev/null 2>&1 &
    local pid=$!

    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        echo -n -e "\b${spin:$i:1}"
        sleep 0.1
    done

    
    wait $pid
    local exit_code=$?

    
    if [ $exit_code -eq 0 ]; then
        echo -e "\b${GREEN}${BOLD}${CHECK} Done${RESET}"
    else
        echo -e "\b${RED}${BOLD}${CROSS} Failed${RESET}"
        
        sleep 3
        exit 1
    fi
}

# ================================================= #
#                   MAIN EXECUTION
# ================================================= #

print_header
run_task "Cloning utility repository" "git clone https://github.com/NyxObscura/installer.git"
cd installer

run_task "Updating packages & dependencies" "sudo apt update && sudo apt install -y build-essential"
echo -e "\n${CYAN}${BOLD}  Detecting system environment...${RESET}"
ARCH=$(uname -m)
OS=$(uname)
echo -e "  ${GREEN}${CHECK} OS: ${OS}, Architecture: ${ARCH}${RESET}"


BINARY=""
echo -n -e "  ${CYAN}Selecting appropriate binary... ${RESET}"
if [[ "$OS" == "Linux" ]]; then
    case "$ARCH" in
        x86_64)
            BINARY="main_x86_64_linux.x"
            ;;
        aarch64)
            if [[ "$(uname -o 2>/dev/null)" == "Android" ]]; then
                BINARY="main_arm_64_android.x"
            else
                BINARY="main_arm_64_linux.x"
            fi
            ;;
        armv7l|armv6l)
            BINARY="main_arm_32_rpi.x"
            ;;
        *)
            echo -e "${RED}${BOLD}${CROSS} Failed${RESET}"
            echo -e "  ${RED}Unsupported architecture: ${ARCH}${RESET}"
            sleep 3
            exit 1
            ;;
    esac
else
    echo -e "${RED}${BOLD}${CROSS} Failed${RESET}"
    echo -e "  ${RED}Unsupported OS: ${OS}${RESET}"
    sleep 3
    exit 1
fi
echo -e "${GREEN}${BOLD}${CHECK} Found: ${BINARY}${RESET}"


if [[ -f "$BINARY" ]]; then
    run_task "Setting execute permissions" "chmod +x '$BINARY'"
    
    echo -e "\n${GREEN}${BOLD}🚀 Launching Utility Script...${RESET}\n"
    
    sleep 3
    
    ./"$BINARY"
else
    echo -e "\n${RED}${BOLD}Error: Binary '${BINARY}' not found.${RESET}"
    
    sleep 3
    exit 1
fi
