# Running AppImages on Arch / CachyOS (KDE Plasma)

This document explains **which Linux package format to choose**, **how to run AppImages on Arch-based systems**, and **how to properly integrate them into the KDE Application Launcher**.

It is written for:

* Arch Linux & Arch-based distros (CachyOS, EndeavourOS, etc.)
* KDE Plasma desktop
* Users downloading apps that offer **`.AppImage` and `.deb`** formats

---

## Choosing the Correct Package Format

If an application provides the following options:

* Linux (`.AppImage`)
* Linux (`.deb`)

### ✅ Recommended: **AppImage**

**Do not use `.deb` on Arch-based systems.**

Reasons:

* `.deb` is for Debian/Ubuntu (`apt`)
* Arch uses `pacman` and does not support `.deb` natively
* Converting `.deb` packages is fragile and error-prone

### Why AppImage Works Well on Arch

* Distro-agnostic
* Bundles its own dependencies
* No system installation required
* Works reliably on rolling-release systems

---

## Running an AppImage on Arch

### Step 1: Make the AppImage executable

From a terminal:

```bash
chmod +x MyApp-x86_64.AppImage
```

Or via KDE:

* Right-click → Properties → Permissions
* Enable **“Is executable”**

---

### Step 2: Install required dependency (FUSE)

Many AppImages require **FUSE v2**, which is not installed by default on Arch.

Install it once:

```bash
sudo pacman -S fuse2
```

Without this, AppImages may silently fail when launched.

---

### Step 3: Run the AppImage

```bash
./MyApp-x86_64.AppImage
```

If it launches successfully, the AppImage itself is working correctly.

---

## Placing the AppImage in a Stable Location

Do **not** leave AppImages in the `Downloads` directory.

Recommended location:

```bash
mkdir -p ~/.local/bin
mv MyApp-x86_64.AppImage ~/.local/bin/myapp
chmod +x ~/.local/bin/myapp
```

This ensures:

* Stable paths
* No accidental deletion
* Cleaner desktop integration

---

## Adding the AppImage to KDE Application Launcher

AppImages do not automatically appear in the app menu.
To integrate them properly, create a `.desktop` file.

### Step 1: Create the applications directory (if missing)

```bash
mkdir -p ~/.local/share/applications
```

---

### Step 2: Create a desktop entry

Create a file named `myapp.desktop`:

```bash
nano ~/.local/share/applications/myapp.desktop
```

Paste the following (generic template):

```ini
[Desktop Entry]
Type=Application
Name=MyApp
Comment=Application Description
Exec=/home/USER/.local/bin/myapp
Icon=utilities-terminal
Terminal=false
Categories=Development;Utility;
```

⚠️ Replace:

* `/home/USER` with your actual home path
* `myapp` with the AppImage filename

---

### Step 3: Refresh KDE application cache

```bash
kbuildsycoca6
```

The application will now appear in:

* KDE Application Launcher
* Search
* Favorites / Task Manager (if pinned)

---

## Optional: Automatic Integration with AppImageLauncher

If you use multiple AppImages, **AppImageLauncher** can automate menu integration.

### Install (AUR)

Using an AUR helper:

```bash
paru -S appimagelauncher-bin
```

Recommended choice:

* `appimagelauncher-bin` → precompiled, stable, fastest install

### What AppImageLauncher Does

* Detects AppImages on first run
* Offers **“Integrate and run”**
* Automatically creates menu entries and icons
* Moves AppImages to a managed location

This is optional but convenient.

---

## Summary

### Best Practices on Arch/KDE

* Prefer **AppImage** over `.deb`
* Install `fuse2`
* Store AppImages in `~/.local/bin`
* Use `.desktop` files for menu integration
* Use AppImageLauncher if managing many AppImages

### Mental Model

* AppImage = portable executable
* `.desktop` file = menu integration
* FUSE = runtime requirement

Once set up, AppImages behave like native applications without touching system packages.

---

This README is suitable for:

* Personal reference
* Public repositories
* New Linux users learning Arch/KDE workflows

TODO:
* Reorganize Repo, move things to correct folder
* Icon extraction & theming
* AppImage updates
* Security considerations
* Flatpak vs AppImage comparison
