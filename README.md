# Pterodactyl Panel Utility Script

[![Version](https://img.shields.io/badge/Version-2.0-blue.svg)](https://github.com/NyxObscura)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](https://github.com/NyxObscura)
[![Language](https://img.shields.io/badge/Language-Bash-green.svg)](https://github.com/NyxObscura)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive and robust Bash script designed to simplify the management, updating, and theming of your **Pterodactyl Panel**. Developed by **NyxObscura** to automate common but complex tasks through a simple, interactive menu.

---

## Key Features

-   ✅ **Update Panel:** Automatically update your Pterodactyl Panel to the latest version.
-   🛠️ **Blueprint Integration:** Install or re-install the Blueprint Framework, the extension manager for Pterodactyl.
-   🎨 **Blueprint Theme Management:** Easily install and uninstall Blueprint-based themes like **Nebula** and **Slate**.
-   ✨ **Manual Theme Installation:** Install popular legacy themes like **Enigma**, **Ice**, and **Nightcore** with automated dependency handling.
-   🔥 **Full Panel Reset:** A powerful utility to completely reset your panel's frontend, removing all themes and modifications to restore the default appearance.
-   ⚙️ **Robust & User-Friendly:** Interactive menu, progress bars for all operations, and critical action confirmations to prevent mistakes.

---

## Prerequisites

Before running this script, please ensure you have the following:

1.  A server running a Debian-based OS (**Ubuntu 20.04/22.04 recommended**).
2.  A working installation of **Pterodactyl Panel**.
3.  `root` or `sudo` privileges.

---

## Installation & Usage

Getting started is simple. Just paste this command. Make sure u run as `sudo` or `root` privilege.


# Clone the repo
```bash
git clone https://github.com/NyxObscura/installer.git
cd installer
```
# Install build essential
```bash
sudo apt update && sudo apt install build-essential -y
```
# Give permission
```bash
chmod +x main.x
```
# Run it
```bash
./main.x
```

# 🖥️ Supported Operating Systems

| OS / Distro | Version | Architecture | Status |
|---|---|---|---|
| Ubuntu | 20.04 / 22.04 | x86_64 | ✅ Tested |
| Debian | 10 / 11 / 12 | x86_64 | ✅ Tested | 
| Debian | 10+ | ARM64 | ⚠️ Partial (compile required) |
| AlmaLinux / Rocky | 8+ | x86_64 | ✅ Tested |
| CentOS	7 / 8 | x86_64 | ✅ Tested |
| Termux (Android) | N/A | ARM64 | ✅ (must compile with Termux shc) |
| Arch Linux | Rolling | x86_64 | ✅ Untested but expected to work |

# Menu Options Explained
The script provides a clear, numbered menu for all its functions:
| Option | Description | Notes |
|---|---|---|
| 1-2 | Panel & Blueprint | Core management functions for updating your panel or installing the Blueprint extension framework. |
| 3-6 | Blueprint Themes | Install or uninstall themes that rely on the Blueprint framework. Safe and easy to manage. |
| 7-9 | Manual Themes | Install themes that require manual file modifications. Warning: These may alter your system's Node.js version. |
| 10 | UNINSTALL ALL THEMES | ⚠️ Use with extreme caution! This is a full panel reset. It reverts all frontend changes to the Pterodactyl default. |
| 11 | Exit | Exits the script. |

## ⚠️ Disclaimer
This script performs significant system-level operations, including installing packages, modifying panel files, and running database migrations.
 * Use this script at your own risk.
 * Always create a full backup of your server (/var/www/pterodactyl directory and database) before using any of the installation or reset functions.
The authors are not responsible for any data loss or damage to your panel installation.

# Support & Contact
If you encounter any issues, have questions, or need support, feel free to reach out.
 * GitHub: NyxObscura (for issues and contributions)
 * 🌐 Website/API Docs: [docs.obscuraworks.com](https://docs.obscuraworks.com) 
 * 📧 Email: [service@obscuraworks.com](mailto:service@obscuraworks.com)
 * 💬 WhatsApp: [+62 851-8334-3636](https://wa.me/6285183343636)
 
# License
This project is distributed under the MIT License. See the LICENSE file for more information.

# Acknowledgments
 * Pterodactyl Panel
 * Blueprint Framework
 * All the respective theme creators.

---

# Thanks for using this script :>
