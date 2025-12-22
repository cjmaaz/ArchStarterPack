
```markdown
# 🛡️ Android Privacy & Bloatware Hunter

> **Take back control of your device.** A comprehensive guide and toolkit for identifying background telemetry, analyzing battery drain, and safely debloating Android devices (OxygenOS, ColorOS, MIUI, OneUI, etc.).

---

## 📖 Table of Contents
1. [The "Why": Understanding the Problem](#-the-why-understanding-the-problem)
2. [Prerequisites: Setting up ADB](#-prerequisites-setting-up-adb)
3. [Phase 1: Automated Debloating (The Easy Way)](#-phase-1-automated-debloating-the-easy-way)
4. [Phase 2: The Detective Work (Manual Investigation)](#-phase-2-the-detective-work-manual-investigation)
   - [Network Sniffing](#41-network-sniffing-finding-spies)
   - [Battery Drain Analysis](#42-battery-drain-analysis)
   - [Foreground & Service Inspection](#43-foreground--service-inspection)
5. [Phase 3: On-Device Monitoring Tools](#-phase-3-on-device-monitoring-tools)
6. [Known Telemetry Domains](#-known-telemetry-domains)

---

## 🧠 The "Why": Understanding the Problem

Modern Android skins are often packed with system services that run constantly in the background. While some are useful, many exist primarily for:
* **Telemetry:** Sending usage data to remote servers (e.g., `allawnos.com`, `heytapmobile.com`).
* **Ecosystem Lock-in:** Services like **Ubiquitous Manager Service** that constantly scan for proprietary accessories (watches, tablets).
* **Bloatware:** Pre-installed apps that consume battery and resources without adding value to you.

This repository helps you **identify** these connections, **understand** which app is responsible, and **remove** (debloat) them safely.

---

## ⚙️ Prerequisites: Setting up ADB

To communicate with your phone at a system level, you need **ADB (Android Debug Bridge)**.

### 1. Install ADB
**Arch Linux / Manjaro / EndeavourOS:**
```bash
sudo pacman -S android-tools

```

**Debian / Ubuntu / Pop!_OS:**

```bash
sudo apt install adb fastboot

```

**Windows:**

1. Download [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools).
2. Extract the folder.
3. Open CMD/PowerShell in that folder.

### 2. Prepare Your Phone

1. Go to **Settings > About Phone > Version**.
2. Tap **Build Number** 7 times until you see *"You are now a developer!"*.
3. Go to **Settings > System > Developer Options**.
4. Enable **USB Debugging**.
5. Connect your phone to your PC.
6. Run `adb devices` in your terminal.
7. **Check your phone screen** and tap "Allow" (Tick "Always allow from this computer").

---

## 🚀 Phase 1: Automated Debloating (The Easy Way)

The safest way to remove bloatware is using **Universal Android Debloater - Next Generation (UAD-ng)**. It uses community-maintained lists to prevent you from breaking your phone.

### How to use UAD-ng

1. **Download:** Get the latest release for your OS from [GitHub Releases](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases).
2. **Launch:**
* **Linux:** Open terminal in the download folder and run:
```bash
chmod +x uad-ng-linux-x86_64
./uad-ng-linux-x86_64

```




3. **Debloat:**
* The tool will auto-detect your phone model.
* **Stick to the "Recommended" list** initially.
* Search for specific packages you found suspicious (e.g., "OnePlus", "Analytics").
* Select and click **Uninstall Selection**.



> **Note:** This does not delete files from the System partition (which requires Root). It uninstalls them for `user 0`, effectively stopping them from ever running.

---

## 🕵️‍♂️ Phase 2: The Detective Work (Manual Investigation)

If you see suspicious activity (like Pi-hole blocks) and don't know which app causes it, use these manual commands.

### 4.1 Network Sniffing: Finding Spies

If you see pings to `allawnos.com`, find out WHO is doing it.

**Step A: See active connections**
Run this while the phone is active to see live connections:

```bash
adb shell netstat -tp

```

*Look for the IP/Domain in the "Foreign Address" column. The far-right column shows the PID/Program Name.*

**Step B: The "Logcat" Sniffer**
Stream system logs and filter for the domain name:

```bash
adb shell "logcat | grep 'allawnos.com'"

```

*Wait for a hit. It will look like: `UID=10145 connected to...*`

**Step C: Identify the App by UID**
If you found a UID (e.g., `10145`), find the app name:

```bash
adb shell pm list packages --uid 10145

```

### 4.2 Battery Drain Analysis

Figure out what is keeping your phone awake.

**Check Battery Stats:**

```bash
adb shell dumpsys battery

```

**Find "Wakelocks" (Apps preventing sleep):**
This command is advanced but powerful. It dumps all battery usage stats:

```bash
adb shell dumpsys batterystats > battery_log.txt

```

*Open `battery_log.txt` on your PC and search for "Wake lock".*

### 4.3 Foreground & Service Inspection

**Who is on screen RIGHT NOW?**
Great for finding invisible overlays or checking what app just opened.

```bash
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'

```

**List ALL running background services:**

```bash
adb shell dumpsys activity services

```

---

## 📱 Phase 3: On-Device Monitoring Tools

If you want to monitor traffic *on the phone itself* without a PC:

### 1. PCAPdroid (Network Monitor)

* **What it does:** acts as a local VPN to log all network connections.
* **Use case:** You can see exactly which app connects to which server in real-time. It can even decrypt HTTPS traffic if configured.
* [Download from F-Droid](https://f-droid.org/en/packages/com.emanuelef.remote_capture/)

### 2. TrackerControl

* **What it does:** Identifies and blocks trackers in apps using a massive database of known tracking signatures.
* **Use case:** Instantly see if your "Flashlight App" is trying to send data to Facebook or Google.
* [Download from F-Droid](https://f-droid.org/en/packages/net.kollnig.missioncontrol.fdroid/)

---

## 📝 Known Telemetry Domains

*(Add to your Pi-hole Blocklist)*

| Domain | Associated Service | Notes |
| --- | --- | --- |
| `allawnos.com` | OPPO/OnePlus Cloud | Unified OS telemetry (Weather, OTA, User Experience) |
| `heytapmobile.com` | HeyTap (OPPO) | Cloud sync, App Market, Browser services |
| `tracking.miui.com` | Xiaomi | MIUI Analytics |
| `data.mistat.xiaomi.com` | Xiaomi | User Experience Program |

---

## ⚠️ Disclaimer

* **Backup your data.**
* Removing "Expert" or "Unsafe" packages can cause boot loops.
* I am not responsible for bricked devices. **Always read what a package does before removing it.**
