# Pterodactyl Panel Utility Script

[![Version](https://img.shields.io/badge/Version-2.0-blue.svg)](https://github.com/NyxObscura)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](https://github.com/NyxObscura)
[![Language](https://img.shields.io/badge/Language-Bash-green.svg)](https://github.com/NyxObscura)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive and robust Bash script designed to simplify the management, updating, and theming of your **Pterodactyl Panel**. Developed by **NyxObscura** to automate common but complex tasks through a simple, interactive menu.

![Script Menu Screenshot](https://cdn.obscuraworks.com/file/media_1751333873051.jpg)

---

## ► Key Features

-   ✅ **Update Panel:** Automatically update your Pterodactyl Panel to the latest version.
-   🛠️ **Blueprint Integration:** Install or re-install the Blueprint Framework, the extension manager for Pterodactyl.
-   🎨 **Blueprint Theme Management:** Easily install and uninstall Blueprint-based themes like **Nebula** and **Slate**.
-   ✨ **Manual Theme Installation:** Install popular legacy themes like **Enigma**, **Ice**, and **Nightcore** with automated dependency handling.
-   🔥 **Full Panel Reset:** A powerful utility to completely reset your panel's frontend, removing all themes and modifications to restore the default appearance.
-   ⚙️ **Robust & User-Friendly:** Interactive menu, progress bars for all operations, and critical action confirmations to prevent mistakes.

---

## ► Prerequisites

Before running this script, please ensure you have the following:

1.  A server running a Debian-based OS (**Ubuntu 20.04/22.04 recommended**).
2.  A working installation of **Pterodactyl Panel**.
3.  `root` or `sudo` privileges.

---

## ► Installation & Usage

Getting started is simple. Just download the script, make it executable, and run it with `sudo`.

# Download the script
```bash
wget https://raw.githubusercontent.com/NyxObscura/installer/main/main.sh)
```
# Make it executable
```bash
chmod +x main.sh
```
# Run the script with sudo privileges
```bash
sudo ./main.sh
```
# Or paste this to your terminal and you're all set ( Make sure you run as root/sudo privileges! )
```bash
bash <(curl -s https://raw.githubusercontent.com/NyxObscura/installer/refs/heads/main/main.sh)
```
► Menu Options Explained
The script provides a clear, numbered menu for all its functions:
| Option | Description | Notes |
|---|---|---|
| 1-2 | Panel & Blueprint | Core management functions for updating your panel or installing the Blueprint extension framework. |
| 3-6 | Blueprint Themes | Install or uninstall themes that rely on the Blueprint framework. Safe and easy to manage. |
| 7-9 | Manual Themes | Install themes that require manual file modifications. Warning: These may alter your system's Node.js version. |
| 10 | UNINSTALL ALL THEMES | ⚠️ Use with extreme caution! This is a full panel reset. It reverts all frontend changes to the Pterodactyl default. |
| 11 | Exit | Exits the script. |

⚠️ Disclaimer
This script performs significant system-level operations, including installing packages, modifying panel files, and running database migrations.
 * Use this script at your own risk.
 * Always create a full backup of your server (/var/www/pterodactyl directory and database) before using any of the installation or reset functions.
The authors are not responsible for any data loss or damage to your panel installation.

► Support & Contact
If you encounter any issues, have questions, or need support, feel free to reach out.
 * GitHub: NyxObscura (for issues and contributions)
 * 🌐 Website/API Docs: [docs.obscuraworks.com](https://docs.obscuraworks.com) 
 * 📧 Email: [service@obscuraworks.com](mailto:service@obscuraworks.com)
 * 💬 WhatsApp: [+62 851-8334-3636](https://wa.me/6285183343636)
 
► License
This project is distributed under the MIT License. See the LICENSE file for more information.

► Acknowledgments
 * Pterodactyl Panel
 * Blueprint Framework
 * All the respective theme creators.

---

# Thanks for using this script :>
