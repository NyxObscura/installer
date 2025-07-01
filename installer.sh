#!/bin/bash

# =================================================================
# Installer Loader oleh NyxObscura
# Skrip ini memverifikasi integritas sebelum eksekusi.
# 2023 - 2025
# =================================================================

# --- KONFIGURASI ---

SCRIPT_URL="https://raw.githubusercontent.com/NyxObscura/installer/main/main.sh"
EXPECTED_HASH="42a898723bdc0f97325c8020dca2cd2cf3acc6d9b04febd3c5262445add9da5a" # <-- GANTI INI

# --- VARIABEL WARNA ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- LOGIKA UTAMA ---
echo -e "${CYAN}${BOLD}Mempersiapkan installer...${RESET}"


SCRIPT_CONTENT=$(curl -sL "$SCRIPT_URL")


if [ -z "$SCRIPT_CONTENT" ]; then
    echo -e "${RED}${BOLD}Gagal mengunduh skrip installer. Periksa koneksi internet atau URL.${RESET}"
    exit 1
fi


ACTUAL_HASH=$(echo -n "$SCRIPT_CONTENT" | sha256sum | awk '{print $1}')


if [[ "$ACTUAL_HASH" == "$EXPECTED_HASH" ]]; then
    echo -e "${GREEN}Verifikasi integritas berhasil.${RESET}"
    echo -e "${CYAN}Menjalankan skrip...${RESET}"
    echo 
    
    bash <(echo "$SCRIPT_CONTENT")
else
    echo -e "${RED}${BOLD}==================== PERINGATAN KEAMANAN ====================${RESET}"
    echo -e "${RED}Hash skrip tidak cocok! Eksekusi dibatalkan.${RESET}"
    echo -e "Ini bisa berarti skrip telah diubah atau rusak saat diunduh."
    echo -e "Hash yang Diharapkan: ${GREEN}$EXPECTED_HASH${RESET}"
    echo -e "Hash Aktual         : ${RED}$ACTUAL_HASH${RESET}"
    exit 1
fi
