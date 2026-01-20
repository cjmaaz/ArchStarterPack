📝 Installing & Maintaining Notion on CachyOS
This resource explains how to install the Notion note-taking desktop app on CachyOS using the manual Arch build process.
🏗️ Initial Installation
On CachyOS, the package named notion in the official repositories is a Window Manager. To get the actual note-taking application, we use the community-maintained Electron wrapper from the Arch User Repository (AUR).
1. Install Build Dependencies
Ensure your system has the tools necessary to compile and package AUR software:
bash
sudo pacman -S --needed base-devel git
Use code with caution.

2. Build and Install Notion
Run the following commands to clone the source and build the package:
bash
# Clone the repository
git clone https://aur.archlinux.org

# Navigate into the folder
cd notion-app-electron

# Build and Install
# -s: Installs required dependencies automatically
# -i: Installs the package to your system once built
makepkg -si
Use code with caution.

Once finished, Notion will appear in your KDE Application Launcher and will run correctly under Wayland via XWayland compatibility automatically.
🔄 How to Update Notion
Since this package was installed manually (without an AUR helper like yay), it will not be updated automatically when you run sudo pacman -Syu. You must manually update it when a new version is released.
Signs you need an update:
The app notifies you a new version is available.
Notion stops loading or shows a "Version Mismatch" error.
You see a notification from the AUR Package Page.
Steps to Update:
To update, you simply pull the latest build instructions and rebuild the package.
Navigate back to your local clone:
bash
cd ~/notion-app-electron
Use code with caution.

(If you deleted this folder, simply repeat the git clone step from the installation section.)
Pull the latest changes from the AUR:
bash
git pull
Use code with caution.

Rebuild and Install the new version:
bash
makepkg -si --noconfirm
Use code with caution.

The -si flags will detect that the version number has increased and overwrite the old installation with the new one.
🛠 Troubleshooting & Tips
Clear Cache
If the app behaves strangely after an update, clear the local Electron cache:
bash
rm -rf ~/.config/Notion
Use code with caution.

Manual Dependency Check
If makepkg -si fails due to a missing "dependency," look at the error message for the package name and install it manually using sudo pacman -S <package-name>, then try the makepkg command again.
