# ADB Basics (The Minimum You Need)

ADB (Android Debug Bridge) is how you "look inside" your phone from a computer.

## What Is ADB?

### Definition

**ADB (Android Debug Bridge)** is a command-line tool that enables communication between a computer and an Android device, allowing you to execute commands, transfer files, and access device logs.

### Why ADB Exists

**The problem:** Android devices are designed for touch interaction, but developers and advanced users need:
- **Command-line access:** Execute commands directly
- **Debugging capabilities:** Access logs and system information
- **Automation:** Script device operations
- **Remote control:** Control device from computer

**The solution:** ADB provides a bridge between your computer and Android device, enabling:
- **Remote command execution:** Run commands on device from computer
- **Log access:** View system logs and application logs
- **Package management:** Install, uninstall, and manage apps
- **File transfer:** Copy files between computer and device

**Real-world analogy:**
- **ADB = SSH for Android** (remote access to device)
- **Computer = Your workstation** (where you run commands)
- **Android device = Remote server** (what you're controlling)
- **USB cable = Network connection** (how they communicate)

### How ADB Works

**Step-by-step communication:**

1. **Computer runs ADB command:** You type `adb shell pm list packages`
2. **ADB daemon on computer:** Processes command and sends to device
3. **USB/Network connection:** Transmits command to Android device
4. **ADB daemon on device:** Receives command and executes it
5. **Device executes command:** Runs `pm list packages` on device
6. **Output sent back:** Device sends output back to computer
7. **Computer displays output:** You see list of packages

**Key components:**
- **ADB client:** Runs on your computer (the `adb` command)
- **ADB daemon (adbd):** Runs on Android device (receives commands)
- **ADB server:** Manages connection between client and daemon
- **USB/Network:** Physical connection between computer and device

## Install ADB

### Why Installation Is Needed

**ADB is not built into Android devices** - you need to install it on your computer to use it.

**What installation provides:**
- **ADB executable:** The `adb` command you run
- **Device drivers:** Communication with Android devices
- **Fastboot tools:** For advanced operations (optional)

### Installation Methods

**Arch Linux:**
```bash
sudo pacman -S android-tools
```

**What this installs:**
- `adb` command-line tool
- `fastboot` tool (for bootloader operations)
- USB drivers for Android devices

**Debian/Ubuntu:**
```bash
sudo apt install adb fastboot
```

**What this installs:**
- Same as Arch, but via `apt` package manager
- Includes Android USB drivers

**Windows:**
- Download "SDK Platform Tools" from [Android Developer Site](https://developer.android.com/studio/releases/platform-tools)
- Extract ZIP file
- Open PowerShell/CMD in that folder
- Run `adb.exe` from that location

**What this provides:**
- `adb.exe` executable
- `fastboot.exe` executable
- USB drivers (may need separate installation)

### Verify Installation

**Check if ADB is installed:**
```bash
adb --version
```

**Expected output:**
```
Android Debug Bridge version 1.0.41
```

**If command not found:**
- ADB not installed or not in PATH
- Install using methods above
- Add to PATH if needed (Windows)

## Verify the Connection

### Why Verification Is Critical

**Before using ADB, you must verify the connection works** - otherwise commands won't reach your device.

**What verification does:**
- **Checks connection:** Confirms computer can talk to device
- **Lists devices:** Shows connected Android devices
- **Shows authorization status:** Indicates if device approved connection

### Connection Process

**Step 1: Enable USB Debugging on Device**

1. **Enable Developer Options:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Developer Options now available

2. **Enable USB Debugging:**
   - Go to Settings → Developer Options
   - Enable "USB Debugging"
   - Confirm warning dialog

**Why this is needed:**
- **Security:** Prevents unauthorized access to device
- **User control:** You must explicitly enable debugging
- **Protection:** Blocks malicious computers from accessing device

**Step 2: Connect Device to Computer**

1. **Connect USB cable:** Plug device into computer
2. **Select USB mode:** On device, select "File Transfer" or "PTP" mode
3. **Wait for drivers:** Computer may install drivers automatically

**Step 3: Verify Connection**

```bash
adb devices
```

**Expected output (authorized):**
```
List of devices attached
ABC123XYZ    device
```

**What this means:**
- **`ABC123XYZ`:** Device serial number (unique identifier)
- **`device`:** Device is connected and authorized ✅
- **Ready to use:** Can now run ADB commands

**If you see `unauthorized`:**
```
List of devices attached
ABC123XYZ    unauthorized
```

**What this means:**
- Device connected but not approved
- Need to authorize on device

**How to fix:**
1. **Unlock phone:** Unlock screen
2. **Look for prompt:** "Allow USB debugging?" dialog appears
3. **Check "Always allow":** Optional, prevents future prompts
4. **Tap "Allow":** Authorize connection
5. **Run `adb devices` again:** Should now show `device`

**Real-world example:**

**First time connecting:**
```bash
$ adb devices
List of devices attached
ABC123XYZ    unauthorized
```
- Phone shows "Allow USB debugging?" prompt
- Tap "Allow"
- Run `adb devices` again:
```bash
$ adb devices
List of devices attached
ABC123XYZ    device
```
- Now authorized and ready to use ✅

## Useful Commands (Copy/Paste)

### Command Categories

**These commands are essential for debloating** - they let you inspect and manage packages on your device.

### 1. Open Shell on Device

```bash
adb shell
```

**What it does:** Opens an interactive shell (command prompt) on your Android device.

**Why it's useful:**
- **Direct access:** Run commands directly on device
- **Faster:** No need to prefix every command with `adb shell`
- **Interactive:** Can navigate device filesystem

**How it works:**
- Connects to device shell
- Gives you command prompt on device
- Type `exit` to return to computer

**Real-world example:**
```bash
$ adb shell
$ pm list packages | grep analytics
com.oppo.analytics
com.vendor.tracking
$ exit
```

**When to use:** When you need to run multiple commands on device.

### 2. List Installed Packages

```bash
adb shell pm list packages
```

**What it does:** Lists all installed packages (apps) on your device.

**Why it's useful:**
- **See all apps:** Including system apps and user apps
- **Find packages:** Identify apps by package name
- **Inventory:** Know what's installed

**How it works:**
- `pm` = Package Manager (Android's app manager)
- `list packages` = List all installed packages
- Output shows package names (e.g., `com.android.chrome`)

**Real-world example:**
```bash
$ adb shell pm list packages
package:com.android.chrome
package:com.oppo.heycloud
package:com.oppo.analytics
package:com.google.android.gms
...
```

**When to use:** To see all installed apps, find specific packages.

### 3. Find Packages by Keyword

```bash
adb shell pm list packages | grep -i analytics
```

**What it does:** Searches for packages containing "analytics" (case-insensitive).

**Why it's useful:**
- **Find telemetry apps:** Search for analytics/tracking packages
- **Filter results:** Narrow down from hundreds of packages
- **Identify bloat:** Find vendor telemetry apps

**How it works:**
- `pm list packages` = List all packages
- `|` = Pipe output to next command
- `grep -i analytics` = Search for "analytics" (case-insensitive)

**Real-world example:**
```bash
$ adb shell pm list packages | grep -i analytics
package:com.oppo.analytics
package:com.vendor.analytics
package:com.google.analytics
```

**When to use:** To find specific types of apps (analytics, tracking, telemetry).

### 4. Map UID to Package

```bash
adb shell pm list packages --uid 10145
```

**What it does:** Finds which package(s) have UID 10145.

**Why it's useful:**
- **Investigation:** When logcat shows UID but not package name
- **Attribution:** Map network activity to specific app
- **Debugging:** Identify which app is causing issues

**How it works:**
- `pm list packages` = List packages
- `--uid 10145` = Filter by UID (User ID)
- Shows package name(s) with that UID

**Real-world example:**

**See UID in logcat:**
```
logcat: UID=10145 connecting to allawnos.com
```

**Find which app:**
```bash
$ adb shell pm list packages --uid 10145
package:com.oppo.heycloud
```

**Result:** `com.oppo.heycloud` is making the connection ✅

**When to use:** When investigating network activity and you see UID in logs.

## Why ADB Matters for Debloating

### The Investigation Chain

**Pi-hole shows you which domain was resolved.**

**What this means:**
- Pi-hole query log shows domains (e.g., `allawnos.com`)
- You see telemetry domains being queried
- But you don't know which app is causing it

**ADB helps you figure out which package caused it.**

**How ADB helps:**
- **Logs:** Use `logcat` to see which app connects to domain
- **UID mapping:** Map UID from logs to package name
- **Package lists:** Search packages to find telemetry apps
- **Network inspection:** See active connections per app

**Complete workflow:**

1. **Pi-hole shows domain:** `allawnos.com` queried frequently
2. **ADB investigation:** Use `logcat` to find UID making connection
3. **Map UID to package:** Use `pm list packages --uid` to find app
4. **Identify app:** Discover `com.oppo.heycloud` is responsible
5. **Remove app:** Use `pm uninstall --user 0` to remove
6. **Verify:** Check Pi-hole logs show queries stopped

**Real-world example:**

**Step 1: Pi-hole shows:**
```
Query Log: allawnos.com (queried 50 times/hour)
```

**Step 2: ADB investigation:**
```bash
$ adb shell "logcat | grep allawnos.com"
logcat: UID=10145 connecting to allawnos.com
```

**Step 3: Map UID to package:**
```bash
$ adb shell pm list packages --uid 10145
package:com.oppo.heycloud
```

**Step 4: Remove app:**
```bash
$ adb shell pm uninstall --user 0 com.oppo.heycloud
Success
```

**Step 5: Verify:**
- Check Pi-hole logs: `allawnos.com` queries stopped ✅

## Next Steps

- **Safety + rollback:** [`safety-rollback.md`](safety-rollback.md) - Learn safe debloating methods
- **Investigation workflow:** [`investigation.md`](investigation.md) - Master the Pi-hole → ADB → package workflow
