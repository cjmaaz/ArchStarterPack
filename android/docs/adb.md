# ADB basics (the minimum you need)

ADB (Android Debug Bridge) is how you “look inside” your phone from a computer.

## Install

- **Arch:** `sudo pacman -S android-tools`
- **Debian/Ubuntu:** `sudo apt install adb fastboot`
- **Windows:** install “SDK Platform Tools” and run `adb.exe` from that folder.

## Verify the connection

```bash
adb devices
```

Expected:

- You see a device ID and `device`
- If you see `unauthorized`, unlock the phone and approve the prompt.

## Useful commands (copy/paste)

```bash
# Open a shell on the phone
adb shell

# List installed packages
adb shell pm list packages

# Find packages by keyword (example: anything containing “analytics”)
adb shell pm list packages | grep -i analytics

# Map UID → packages (when logcat shows UID=10xxx)
adb shell pm list packages --uid 10145
```

## Why ADB matters for debloating

- Pi-hole can show you **which domain** was resolved.
- ADB helps you figure out **which package** caused it (via logs/UID/package lists).

Next:

- Safety + rollback: `safety-rollback.md`
- Workflow: `investigation.md`
