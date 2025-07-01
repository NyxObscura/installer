#!/bin.bash

# =================================================================
# Installer Loader oleh NyxObscura
# Skrip ini memverifikasi integritas sebelum eksekusi.
# 2023 - 2025
# =================================================================

# --- KONFIGURASI ---

SCRIPT_URL="https://raw.githubusercontent.com/NyxObscura/installer/main/main.sh"
EXPECTED_HASH="42a898723bdc0f97325c8020dca2cd2cf3acc6d9b04febd3c5262445add9da5a"

# --- VARIABEL WARNA ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- LOGIKA UTAMA ---
echo -e "${CYAN}${BOLD}Mempersiapkan installer...${RESET}"

# Buat file sementara yang aman untuk menampung skrip
# Opsi --tmpdir memastikan file dibuat di lokasi yang umum seperti /tmp
TMP_FILE=$(mktemp -t installer.XXXXXX.sh)

# Pastikan file sementara dihapus saat skrip selesai (baik berhasil maupun gagal)
trap 'rm -f "$TMP_FILE"' EXIT

# Unduh skrip ke file sementara dan periksa status unduhan
if ! curl -sL "$SCRIPT_URL" -o "$TMP_FILE"; then
    echo -e "${RED}${BOLD}Gagal mengunduh skrip installer. Periksa koneksi internet atau URL.${RESET}"
    exit 1
fi

# Hitung hash dari file yang sudah diunduh
ACTUAL_HASH=$(sha256sum "$TMP_FILE" | awk '{print $1}')

# Bandingkan hash
if [[ "$ACTUAL_HASH" == "$EXPECTED_HASH" ]]; then
    echo -e "${GREEN}Verifikasi integritas berhasil.${RESET}"
    echo -e "${CYAN}Menjalankan skrip...${RESET}"
    echo

    # Jalankan skrip dari file sementara
    bash "$TMP_FILE"
else
    echo -e "${RED}${BOLD}==================== PERINGATAN KEAMANAN ====================${RESET}"
    echo -e "${RED}Hash skrip tidak cocok! Eksekusi dibatalkan.${RESET}"
    echo -e "Ini bisa berarti skrip telah diubah atau rusak saat diunduh."
    echo -e "Hash yang Diharapkan: ${GREEN}$EXPECTED_HASH${RESET}"
    echo -e "Hash Aktual         : ${RED}$ACTUAL_HASH${RESET}"
    exit 1
fi
