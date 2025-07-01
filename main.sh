#!/bin/bash

#=================================================#
#               COLOR VARIABLES
#=================================================#
RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

#=================================================#
#                   FUNCTIONS
#=================================================#

# Function to display a progress bar
show_progress() {
    local percent=$1
    local message=$2
    local color

    if [ "$percent" -le 40 ]; then
        color=$RED
    elif [ "$percent" -le 70 ]; then
        color=$ORANGE
    else
        color=$GREEN
    fi

    clear
    echo -e "${CYAN}${BOLD}Process is running...${RESET}"
    echo -e "${color}${BOLD}$message${RESET}"
    local progress_bar=""
    for ((i=0; i<percent/2; i++)); do progress_bar+="="; done
    printf "[%-50s] %d%%\n" "$progress_bar" "$percent"
    sleep 2
}

# Confirmation function before execution
confirm_action() {
    local message=$1
    echo -e "${ORANGE}${BOLD}${message}${RESET}"
    echo -e "This action cannot be undone once started."
    read -p "Are you sure you want to continue? (y/n): " confirmation
    if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
        echo -e "${RED}Action cancelled by user.${RESET}"
        sleep 2
        return 1
    fi
    return 0
}

# --- MAIN PANEL & BLUEPRINT FUNCTIONS ---

update_panel() {
    confirm_action "You are about to update the Pterodactyl Panel to the latest version." || return
    show_progress 10 "Entering Pterodactyl directory and disabling the panel..."
    cd /var/www/pterodactyl || exit
    php artisan down > /dev/null 2>&1
    show_progress 20 "Downloading and extracting the latest panel files..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv > /dev/null 2>&1
    show_progress 40 "Installing Composer & Yarn dependencies..."
    composer install --no-dev --optimize-autoloader --no-interaction > /dev/null 2>&1
    show_progress 60 "Clearing cache and running database migrations..."
    php artisan view:clear > /dev/null 2>&1
    php artisan config:clear > /dev/null 2>&1
    php artisan migrate --seed --force > /dev/null 2>&1
    show_progress 80 "Setting folder permissions and ownership..."
    chown -R www-data:www-data /var/www/pterodactyl/* > /dev/null 2>&1
    show_progress 100 "Update complete! Re-enabling the panel..."
    php artisan up > /dev/null 2>&1
    clear
    echo -e "${GREEN}${BOLD}Pterodactyl Panel updated successfully!${RESET}"
    sleep 3
}

install_blueprint() {
    confirm_action "You are about to install the Blueprint Framework." || return
    show_progress 10 "Checking and installing Node.js v20 (Blueprint requirement)..."
    if ! command -v node > /dev/null || [[ "$(node -v)" != "v20."* ]]; then
      curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
      sudo apt-get install -y nodejs > /dev/null 2>&1
    fi
    show_progress 25 "Installing Yarn globally..."
    npm i -g yarn > /dev/null 2>&1
    show_progress 40 "Downloading Blueprint Framework..."
    cd /var/www/pterodactyl || exit
    wget -q "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
    show_progress 55 "Extracting and preparing Blueprint..."
    yes | unzip release.zip
    touch .blueprintrc && rm release.zip
    echo 'WEBUSER="www-data";OWNERSHIP="www-data:www-data";USERSHELL="/bin/bash";' > .blueprintrc
    chmod +x blueprint.sh
    show_progress 70 "Running Blueprint Framework installation..."
    yes | bash blueprint.sh > /dev/null 2>&1
    clear
    echo -e "${GREEN}${BOLD}Blueprint Framework Installation Complete!${RESET}"
    sleep 3
}

# --- BLUEPRINT-BASED THEME FUNCTIONS ---

install_nebula() {
    confirm_action "You are about to install the Nebula theme (via Blueprint)." || return
    show_progress 50 "Downloading and installing Nebula Theme..."
    cd /var/www/pterodactyl || exit
    wget -q https://raw.githubusercontent.com/NyxObscura/nebula_blueprint/main/nebula.blueprint -O nebula.blueprint
    echo -e "\n\n" | blueprint -install nebula > /dev/null 2>&1
    rm nebula.blueprint
    show_progress 100 "Nebula Installation Complete!"
    clear; echo -e "${GREEN}${BOLD}Nebula Theme installed successfully!${RESET}"; sleep 3
}

uninstall_nebula() {
    confirm_action "You are about to REMOVE the Nebula theme (via Blueprint)." || return
    show_progress 50 "Uninstalling Nebula Theme..."
    cd /var/www/pterodactyl || exit
    yes | blueprint -remove nebula > /dev/null 2>&1
    show_progress 100 "Nebula Uninstallation Complete!"
    clear; echo -e "${GREEN}${BOLD}Nebula Theme uninstalled successfully!${RESET}"; sleep 3
}

install_slate() {
    confirm_action "You are about to install the Slate theme (via Blueprint)." || return
    show_progress 50 "Downloading and installing Slate Theme..."
    cd /var/www/pterodactyl || exit
    wget -q https://raw.githubusercontent.com/NyxObscura/slate_blueprint/main/slate.blueprint -O slate.blueprint
    blueprint -install slate > /dev/null 2>&1
    rm slate.blueprint
    show_progress 100 "Slate Installation Complete!"
    clear; echo -e "${GREEN}${BOLD}Slate Theme installed successfully!${RESET}"; sleep 3
}

uninstall_slate() {
    confirm_action "You are about to REMOVE the Slate theme (via Blueprint)." || return
    show_progress 50 "Uninstalling Slate Theme..."
    cd /var/www/pterodactyl || exit
    yes | blueprint -remove slate > /dev/null 2>&1
    show_progress 100 "Slate Uninstallation Complete!"
    clear; echo -e "${GREEN}${BOLD}Slate Theme uninstalled successfully!${RESET}"; sleep 3
}


# --- MANUAL THEME FUNCTIONS (LEGACY) ---

install_enigma() {
    confirm_action "You are about to install the Enigma theme (manual method)." || return
    show_progress 10 "Installing initial dependencies (git, unzip)..."
    apt-get install -y git unzip > /dev/null 2>&1
    show_progress 20 "Downloading and preparing theme files..."
    cd /var/www && git clone https://github.com/NyxObscura/enigma.git > /dev/null 2>&1
    mv /var/www/enigma/enigmaobs.zip /var/www/ && rm -rf enigma
    unzip -o enigmaobs.zip > /dev/null 2>&1
    show_progress 40 "Installing Node.js v16 and Yarn (theme requirements)..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y nodejs > /dev/null 2>&1
    npm i -g yarn > /dev/null 2>&1
    show_progress 70 "Building panel assets (production build)..."
    cd /var/www/pterodactyl
    yarn > /dev/null 2>&1
    yarn build:production > /dev/null 2>&1
    show_progress 100 "Installation complete!"
    rm /var/www/enigmaobs.zip
    clear; echo -e "${GREEN}${BOLD}Enigma Theme installed successfully!${RESET}"; sleep 3
}

install_ice() {
    confirm_action "You are about to install the Ice theme (manual method)." || return
    show_progress 10 "Creating current panel backup..."
    cd /var/www/ && tar -czf IceTheme_backup.tar.gz pterodactyl > /dev/null 2>&1
    show_progress 25 "Installing dependencies (Node.js v16, yarn)..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y nodejs > /dev/null 2>&1
    npm i -g yarn > /dev/null 2>&1
    show_progress 50 "Downloading and overwriting theme files..."
    cd /var/www/pterodactyl
    rm -rf IceMinecraftTheme
    git clone https://github.com/Angelillo15/IceMinecraftTheme.git > /dev/null 2>&1
    # Move files non-interactively
    \cp -r IceMinecraftTheme/resources/* resources/
    rm -rf IceMinecraftTheme
    show_progress 80 "Building panel assets (production build)..."
    yarn > /dev/null 2>&1
    yarn build:production > /dev/null 2>&1
    sudo php artisan optimize:clear > /dev/null 2>&1
    show_progress 100 "Installation complete!"
    clear; echo -e "${GREEN}${BOLD}Ice Theme installed successfully!${RESET}"; sleep 3
}

install_nightcore() {
    confirm_action "You are about to install the Nightcore theme (manual method)." || return
    show_progress 10 "Creating current panel backup..."
    cd /var/www/ && tar -czf Nightcore_backup.tar.gz pterodactyl > /dev/null 2>&1
    show_progress 25 "Installing dependencies (Node.js v16, yarn)..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y nodejs > /dev/null 2>&1
    npm i -g yarn > /dev/null 2>&1
    show_progress 50 "Downloading and overwriting theme files..."
    cd /var/www/pterodactyl
    rm -rf Pterodactyl_Nightcore_Theme
    git clone https://github.com/NoPro200/Pterodactyl_Nightcore_Theme.git > /dev/null 2>&1
    \cp -r Pterodactyl_Nightcore_Theme/index.tsx resources/scripts/index.tsx
    \cp -r Pterodactyl_Nightcore_Theme/Pterodactyl_Nightcore_Theme.css resources/scripts/Pterodactyl_Nightcore_Theme.css
    rm -rf Pterodactyl_Nightcore_Theme
    show_progress 80 "Building panel assets (production build)..."
    yarn > /dev/null 2>&1
    yarn build:production > /dev/null 2>&1
    sudo php artisan optimize:clear > /dev/null 2>&1
    show_progress 100 "Installation complete!"
    clear; echo -e "${GREEN}${BOLD}Nightcore Theme installed successfully!${RESET}"; sleep 3
}

# --- UNIVERSAL UNINSTALL FUNCTION ---

uninstall_all_themes() {
    clear
    echo -e "${RED}${BOLD}=================== SEVERE WARNING ===================${RESET}"
    echo -e "This option is not merely 'uninstalling themes', but will ${BOLD}RESET${RESET}"
    echo -e "your Pterodactyl panel to its standard (default) condition."
    echo ""
    echo -e "This action will:"
    echo -e "1. Remove all theme modifications."
    echo -e "2. Re-download the original Pterodactyl files."
    echo -e "3. Re-run the database migration process."
    echo ""
    echo -e "${ORANGE}This is a 'reset button'. Use it only if your panel is corrupted${RESET}"
    echo -e "${ORANGE}or if you want to completely revert to the default appearance.${RESET}"
    echo -e "${RED}${BOLD}========================================================${RESET}"
    read -p "To proceed, type 'SAYA YAKIN' (case-sensitive): " confirmation # Keep 'SAYA YAKIN' as requested

    if [ "$confirmation" != "SAYA YAKIN" ]; then
        echo -e "\n${GREEN}Action cancelled. No changes were made.${RESET}"
        sleep 3
        return
    fi

    show_progress 10 "Starting panel reset process..."
    cd /var/www/
    rm -f enigmaobs.zip IceTheme_backup.tar.gz Nightcore_backup.tar.gz
    show_progress 20 "Disabling the panel..."
    cd /var/www/pterodactyl || exit
    php artisan down > /dev/null 2>&1
    show_progress 40 "Re-downloading original Pterodactyl panel files..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv > /dev/null 2>&1
    show_progress 60 "Re-installing panel dependencies..."
    composer install --no-dev --optimize-autoloader > /dev/null 2>&1
    show_progress 80 "Clearing and migrating database..."
    php artisan view:clear && php artisan config:clear > /dev/null 2>&1
    php artisan migrate --seed --force > /dev/null 2>&1
    chown -R www-data:www-data /var/www/pterodactyl/* > /dev/null 2>&1
    show_progress 100 "Re-enabling the panel..."
    php artisan up > /dev/null 2>&1
    clear
    echo -e "${GREEN}${BOLD}Pterodactyl Panel successfully reset to its original state!${RESET}"
    sleep 4
}

#=================================================#
#                   MAIN EXECUTION
#=================================================#

while true; do
    clear
    echo -e "${CYAN}${BOLD}===========================================${RESET}"
    echo -e "${CYAN}${BOLD}     Pterodactyl Panel Utility Script      ${RESET}"
    echo -e "${CYAN}${BOLD}===========================================${RESET}"
    echo -e "Created by ${ORANGE}NyxObscura${RESET}"
    echo -e "${BLUE}Script Version: 2.0${RESET}"
    echo ""
    echo -e "${ORANGE}--- Panel & Blueprint Management ---${RESET}"
    echo -e "  1. Update Pterodactyl Panel"
    echo -e "  2. Install/Re-install Blueprint Framework"
    echo ""
    echo -e "${GREEN}--- Themes (Blueprint-based) ---${RESET}"
    echo -e "${RED}${BOLD}PENTING: Sebelum menginstal tema Nebula/Slate (Opsi 3 & 5), Anda HARUS menginstal Blueprint Framework terlebih dahulu (Opsi 2). Jika tidak, proses instalasi akan gagal.${RESET}"
    echo -e "  3. Install Nebula Theme"
    echo -e "  4. Uninstall Nebula Theme"
    echo -e "  5. Install Slate Theme"
    echo -e "  6. Uninstall Slate Theme"
    echo ""
    echo -e "${RED}--- Themes (Manual - Caution!) ---${RESET}"
    echo -e "${ORANGE}Warning: These options may change your Node.js version.${RESET}"
    echo -e "  7. Install Enigma Theme"
    echo -e "  8. Install Ice Theme"
    echo -e "  9. Install Nightcore Theme"
    echo ""
    echo -e "${RED}--- Important Utilities ---${RESET}"
    echo -e "  10. ${BOLD}UNINSTALL ALL THEMES (Reset Panel)${RESET}"
    echo -e "  11. Exit"
    echo -e "${CYAN}${BOLD}===========================================${RESET}"
    read -p "Enter your choice (1-11): " choice

    case $choice in
        1) update_panel ;;
        2) install_blueprint ;;
        3) install_nebula ;;
        4) uninstall_nebula ;;
        5) install_slate ;;
        6) uninstall_slate ;;
        7) install_enigma ;;
        8) install_ice ;;
        9) install_nightcore ;;
        10) uninstall_all_themes ;;
        11) clear; echo -e "${GREEN}Thank you for using this script!${RESET}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid choice. Please try again.${RESET}"; sleep 2 ;;
    esac
done
