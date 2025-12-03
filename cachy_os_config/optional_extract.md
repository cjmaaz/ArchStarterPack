# Optional Diagnostics Extensions

This document describes optional advanced diagnostics modules that can be integrated into the `diagnostics.sh` toolkit. These modules extend system inspection capability and provide deeper insights into GPU, storage, network, display server, and overall system health.

**Note:** The main `diagnostics.sh` script now displays each command before executing it, making it easier to understand what information is being gathered and learn useful diagnostic commands.

---

## 1. Auto-Upload Output to Pastebin

Automatically uploads the diagnostics log to a paste service (e.g., paste.rs).

### Example:
```bash
curl -F "file=@${OUTPUT_FILE}" https://paste.rs
```

---

## 2. Auto-Detect NVIDIA dmesg Errors

Scan `dmesg` for NVIDIA-related issues:
```bash
dmesg | grep -iE "nvidia|nvkm|nouveau" | tail -200
```

---

## 3. Vulkan/OpenGL Info Collection

Gather graphics API info:
```bash
vulkaninfo | sed -n '1,200p'
glxinfo -B
```

---

## 4. Network Diagnostic Suite

Includes:
- Interfaces
- Routing
- DNS
- Speedtest

```bash
ip a
ip r
resolvectl status
speedtest-cli
```

---

## 5. SMART Disk Health Reports

```bash
sudo smartctl -a /dev/sda
sudo smartctl -a /dev/nvme0n1
```

---

## 6. System Health Scoring

Simple scoring based on:
- Temps
- Disk health
- GPU driver load
- Kernel errors
- Battery condition

Script computes weighted score from 0–100.

---

## 7. Arch PKGBUILD (Optional Packaging)

PKGBUILD skeleton to package diagnostics toolkit into Arch package.

---

## 8. Wayland/X11 Logs

### Wayland:
```
journalctl --user -u pipewire -b
journalctl --user -u xdg-desktop-portal -b
```

### X11:
```
cat ~/.local/share/xorg/Xorg.0.log
```
