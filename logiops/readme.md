# LogiOps Configuration for MX Master 3S

Clone the repo:
```bash
git clone https://github.com/PixlOne/logiops.git
```

CD into directory:
```bash
cd logiops
```

## Dependencies

This project requires a C++20 compiler, `cmake`, `libevdev`, `libudev`, `glib`, and `libconfig`.
For popular distributions:

**Arch Linux:** `sudo pacman -S base-devel cmake libevdev libconfig systemd-libs glib2`

**Debian/Ubuntu:** `sudo apt install build-essential cmake pkg-config libevdev-dev libudev-dev libconfig++-dev libglib2.0-dev`

**Fedora:** `sudo dnf install cmake libevdev-devel systemd-devel libconfig-devel gcc-c++ glib2-devel`

**Gentoo Linux:** `sudo emerge dev-libs/libconfig dev-libs/libevdev dev-libs/glib dev-util/cmake virtual/libudev`

**Solus:** `sudo eopkg install cmake libevdev-devel libconfig-devel libgudev-devel glib2-devel`

**openSUSE:** `sudo zypper install cmake libevdev-devel systemd-devel libconfig-devel gcc-c++ libconfig++-devel libudev-devel glib2-devel`

## Building

To build the project:
```bash
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

## Additional Notes & Warnings

### ⚠️ Hardware & System Safety Checks
- **Check your device compatibility** before building LogiOps. Unsupported Logitech devices may behave unpredictably.
- **Ensure your USB/Bluetooth receiver is stable**. Unreliable connections can cause erratic behaviour during config testing.
- **Do not enable the daemon** until you’ve validated your config with `logid -v`.
- If the daemon fails to start, check the logs:
```bash
journalctl -u logid -b
```
- If `logid -v` shows *"device not found"* or *"no matching HID nodes"*: ensure the mouse is powered on and paired.

### 📁 Configuration File Info
LogiOps uses the config file at:
```
/etc/logid.cfg
```
Always validate your config syntax before enabling the service:
```bash
sudo logid -t
```

If validation fails, do **not** start the service—fix errors first.

## Install/Run/Debug
```bash
sudo make install
```

Debug hardware keys (ensure service is stopped first):
```bash
sudo logid -v
```

Enable and start the daemon:
```bash
sudo systemctl enable --now logid
```


## Common Issues & Fixes

### ❌ Issue: `logid` fails to start
**Fix:**
- Check permissions on `/etc/logid.cfg`.
- Validate configuration using:
```bash
sudo logid -t
```

### ❌ Issue: Buttons or gestures not working
**Fix:**
- Run:
```bash
sudo logid -v
```
  and check which event codes the mouse is emitting.

### ❌ Issue: Build fails due to missing dependencies
**Fix:** Reinstall required packages depending on distro (listed above).

---
## Tips for Creating Advanced Configurations
- The MX Master 3S supports **multiple gesture layers** using the gesture button.
- Sensitivity and DPI settings can be controlled via the HID++ interface.
- Complex actions (e.g., sending key sequences, running shell commands) are supported.

For full configuration examples, refer to the official repo.

