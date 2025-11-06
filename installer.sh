#!/bin/bash
#=================================================#
#   Automatic Installer for NyxObscura Toolkit
#           -- Enhanced Edition (Linux+Termux)
#=================================================#

set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; RED='\033[0;31m'
ORANGE='\033[0;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'
CHECK="✅"; CROSS="❌"

is_android() { [[ "$(uname -o 2>/dev/null || echo Unknown)" == "Android" ]]; }
is_termux()  { is_android && [[ -n "${PREFIX:-}" ]] && [[ -d "$PREFIX" ]] && [[ "$PREFIX" == *"/com.termux/"* ]]; }
in_noexec_path() { [[ "$PWD" == /sdcard/* || "$PWD" == /storage/* || "$PWD" == /mnt/* ]]; }

print_header() {
  clear || true
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
  local msg=$1 cmd=$2 spin='-\|/' i=0
  echo -ne "  ${CYAN}${msg}... ${RESET}"
  bash -lc "$cmd" >/dev/null 2>&1 & local pid=$!
  while kill -0 $pid 2>/dev/null; do i=$(( (i+1) %4 )); echo -ne "\b${spin:$i:1}"; sleep 0.1; done
  wait $pid; local ec=$?
  if [[ $ec -eq 0 ]]; then echo -e "\b${GREEN}${BOLD}${CHECK} Done${RESET}"
  else echo -e "\b${RED}${BOLD}${CROSS} Failed${RESET}"; sleep 1; exit $ec; fi
}

install_deps_linux() {
  
  if command -v apt >/dev/null 2>&1; then
    run_task "Updating packages (apt)" "sudo apt update"
    run_task "Installing deps (apt)" "sudo apt install -y git build-essential ca-certificates"
  
  elif command -v dnf >/dev/null 2>&1; then
    run_task "Updating packages (dnf)" "sudo dnf -y update"
    run_task "Installing deps (dnf)" "sudo dnf -y install git make gcc"
  elif command -v yum >/dev/null 2>&1; then
    run_task "Installing deps (yum)" "sudo yum -y install git make gcc"
  else
    echo -e "${ORANGE}  Skipping package install: unknown package manager.${RESET}"
  fi
}

install_deps_termux() {
  # Termux environment: no sudo, no build-essential
  run_task "Updating packages (pkg)" "pkg update -y"
  run_task "Installing deps (pkg)" "pkg install -y git clang make binutils openssl"
}

select_binary() {
  local arch="$(uname -m)"
  if is_termux; then
    # Termux on Android
    case "$arch" in
      aarch64) echo "main_arm_64_android.x" ;;
      armv7l|armv8l|armv6l|arm) echo "main_arm_32_rpi.x" ;; 
      x86_64)  echo "main_x86_64_linux.x" ;; 
      *) echo ""; return 1 ;;
    esac
  else
    # Linux desktop/server
    case "$arch" in
      x86_64) echo "main_x86_64_linux.x" ;;
      aarch64) echo "main_arm_64_linux.x" ;;
      armv7l|armv6l) echo "main_arm_32_rpi.x" ;;
      *) echo ""; return 1 ;;
    esac
  fi
}

ensure_exec_path_ok() {
  if is_termux && in_noexec_path; then
    echo -e "  ${ORANGE}Filesystem ini noexec (${PWD}). Memindahkan repo ke \$HOME agar bisa dieksekusi...${RESET}"
    mkdir -p "$HOME/installer-tmp"
    cp -r . "$HOME/installer-tmp/installer" 2>/dev/null || true
    cd "$HOME/installer-tmp/installer"
  fi
}

# ================================================= #
#                   MAIN EXECUTION
# ================================================= #
print_header


if [[ ! -d installer ]]; then
  run_task "Cloning utility repository" "git clone https://github.com/NyxObscura/installer.git"
fi
cd installer


OS="$(uname)"
if is_termux; then
  echo -e "${CYAN}${BOLD}  Detected environment: Termux on Android${RESET}"
  install_deps_termux
else
  echo -e "${CYAN}${BOLD}  Detected environment: ${OS}${RESET}"
  install_deps_linux
fi

echo -e "\n${CYAN}${BOLD}  Detecting system environment...${RESET}"
ARCH="$(uname -m)"; KERN="$(uname -r)"
echo -e "  ${GREEN}${CHECK} Kernel: ${KERN}${RESET}"
echo -e "  ${GREEN}${CHECK} Arch:   ${ARCH}${RESET}"


BINARY="$(select_binary || true)"
if [[ -z "${BINARY:-}" ]]; then
  echo -e "  ${RED}${BOLD}${CROSS} Unsupported architecture or environment.${RESET}"
  echo -e "  ${ORANGE}If on Android/Termux, pastikan kamu punya build biner untuk Android (bionic), bukan glibc.${RESET}"
  exit 1
fi
echo -e "  ${GREEN}${CHECK} Selected binary: ${BINARY}${RESET}"


ensure_exec_path_ok


if [[ -f "$BINARY" ]]; then
  run_task "Setting execute permissions" "chmod +x '$BINARY'"
  echo -e "\n${GREEN}${BOLD}🚀 Launching Utility Script...${RESET}\n"
  sleep 1
  "./$BINARY"
else
  echo -e "\n${RED}${BOLD}Error: Binary '${BINARY}' not found.${RESET}"
  if is_termux; then
    echo -e "  ${ORANGE}Kamu di Termux. Binary Linux biasa (glibc) tidak akan jalan di Android.${RESET}"
    echo -e "  ${ORANGE}Solusi: build khusus Android (NDK) atau jalankan via proot Ubuntu (lihat catatan di bawah).${RESET}"
  fi
  exit 1
fi
