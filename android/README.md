# Android Module: Debloating + Privacy (Beginner → Intermediate)

This module helps you reduce background telemetry and bloat on Android devices safely.

## What Is Android Debloating?

### Definition

**Android debloating** is the process of removing or disabling unwanted pre-installed applications and services from Android devices to improve privacy, reduce background telemetry, and free up system resources.

### Why Debloating Exists

**The problem:** Modern Android devices come with many pre-installed applications and services that:

- **Send telemetry data:** Collect usage statistics, diagnostics, and personal information
- **Consume resources:** Use CPU, battery, and network bandwidth in the background
- **Reduce privacy:** Track your behavior and send data to vendor servers
- **Can't be removed normally:** Many apps are "system apps" that can't be uninstalled through normal means

**The solution:** Debloating allows you to:

- **Remove unwanted apps:** Uninstall or disable apps you don't use
- **Stop telemetry:** Prevent background data collection
- **Improve privacy:** Reduce data sent to vendors
- **Save resources:** Free up CPU, battery, and storage

**Real-world analogy:**

- **Pre-installed apps = Bloatware** (like unwanted software on a new computer)
- **Debloating = Cleaning up** (removing what you don't need)
- **Result = Cleaner, faster, more private device**

### How Debloating Works

**Step-by-step process:**

1. **Identify unwanted apps:** Find apps/services sending telemetry or consuming resources
2. **Choose removal method:** Select safe removal method (disable vs uninstall)
3. **Execute removal:** Use ADB commands to remove/disable apps
4. **Verify results:** Confirm apps are removed and telemetry stopped
5. **Rollback if needed:** Restore apps if something breaks

**Key concept:** Debloating works **without root** by using Android's built-in package manager commands through ADB (Android Debug Bridge).

---

## Start here (recommended reading order)

### For Beginners (Structured Learning Path)

1. **Start here (module overview):** This README

   - Understand what debloating is and why it's needed
   - Learn key concepts and prerequisites

2. **ADB basics:** [`docs/adb.md`](docs/adb.md)

   - Learn what ADB is and how to use it
   - Understand ADB commands for debloating
   - Set up ADB connection

3. **Safety + rollback model:** [`docs/safety-rollback.md`](docs/safety-rollback.md)

   - Learn safe debloating methods
   - Understand rollback procedures
   - Prevent bricking your device

4. **Investigation workflow:** [`docs/investigation.md`](docs/investigation.md)

   - Learn how to trace telemetry to apps
   - Understand Pi-hole → ADB → package workflow
   - Master investigation techniques

5. **OEM domains + Pi-hole regex:** [`docs/oem-domains.md`](docs/oem-domains.md)
   - Learn about vendor telemetry domains
   - Understand Pi-hole blocking strategies
   - Apply regex deny rules

### For Quick Reference

- **Single-page version:** [`debloat.md`](debloat.md) (all-in-one comprehensive guide)

---

## What You'll Learn

After completing this module, you'll be able to:

### 1. Interpret "Mystery Domains" in Pi-hole Logs

**What this means:**

- See a domain in Pi-hole query log (e.g., `allawnos.com`)
- Don't know which app is causing it
- Need to trace it back to the responsible Android package

**How you'll learn:**

- Understand DNS resolution flow
- Use ADB to investigate network activity
- Map domains to packages using logs and UIDs

**Real-world example:**

- Pi-hole shows `heytapmobile.com` being queried frequently
- Use ADB to find which app is making these requests
- Identify `com.oppo.heycloud` as the culprit
- Remove or disable the app

### 2. Understand How Debloating Works Without Root

**What this means:**

- Remove apps without rooting your device
- Use Android's built-in package manager
- Understand why it's usually reversible

**How you'll learn:**

- Understand Android user profiles (user 0)
- Learn `pm uninstall --user 0` command
- Understand difference between system apps and user apps

**Real-world example:**

- App is installed as system app (can't remove normally)
- Use `pm uninstall --user 0` to remove for your user
- App still exists in system, but removed for you
- Can restore with `pm install-existing` if needed

### 3. Verify Background Traffic Actually Stopped

**What this means:**

- Confirm telemetry has stopped after debloating
- Verify no new connections to blocked domains
- Ensure device still works correctly

**How you'll learn:**

- Monitor Pi-hole query logs
- Use on-device tools (PCAPdroid, TrackerControl)
- Check ADB logs for network activity

**Real-world example:**

- Remove `com.oppo.analytics` app
- Monitor Pi-hole for 24 hours
- Confirm `allawnos.com` queries stopped
- Verify device still functions normally

---

## Quick Glossary

### ADB (Android Debug Bridge)

**What it is:** A command-line tool that allows you to communicate with Android devices from a computer.

**Why it exists:** Provides a way to debug, inspect, and control Android devices without physical access to the device screen.

**How it works:**

- Connects via USB or network
- Sends commands to Android device
- Receives output and logs from device
- Acts as a bridge between computer and phone

**Real-world analogy:** Like SSH for Android - remote access to your device's command line.

**Example:** `adb shell pm list packages` lists all installed packages on your device.

### Package Name

**What it is:** The internal identifier Android uses for applications (e.g., `com.vendor.analytics`).

**Why it exists:** Provides a unique identifier for each app, independent of display name.

**How it works:**

- Format: `com.company.appname` (reverse domain notation)
- System uses package name internally
- Display name can change, package name stays the same

**Real-world example:**

- Display name: "HeyTap Cloud"
- Package name: `com.oppo.heycloud`
- Use package name in ADB commands, not display name

### UID (User ID)

**What it is:** A numeric identity Android assigns to each app for security and resource management.

**Why it exists:** Allows Android to isolate apps and track resource usage per app.

**How it works:**

- Each app gets unique UID (e.g., `10145`)
- UID appears in logs and network connections
- Can map UID back to package name

**Real-world example:**

- See `UID=10145` in logcat output
- Use `pm list packages --uid 10145` to find which app
- Discover it's `com.oppo.analytics`

### Telemetry

**What it is:** Background data sent to vendor endpoints for analytics, diagnostics, and user tracking.

**Why it exists:** Vendors collect data to:

- Improve products (usage statistics)
- Diagnose issues (crash reports)
- Track users (advertising, analytics)
- Build user profiles (behavioral data)

**How it works:**

- Apps collect data in background
- Send to vendor servers periodically
- Often bypasses user awareness
- Can include personal information

**Real-world example:**

- App tracks which features you use
- Sends data to `tracking.vendor.com` every hour
- Includes device info, usage patterns, location
- Used for analytics and advertising

---

## How This Connects to Pi-hole

### The Connection

**Pi-hole shows you what domains a device tries to resolve.**

**What this means:**

- Pi-hole acts as DNS server for your network
- All DNS queries from Android device go through Pi-hole
- Pi-hole logs show which domains are being queried
- You can see telemetry domains in Pi-hole query log

**How it works:**

1. Android app wants to connect to `allawnos.com`
2. App queries DNS (goes to Pi-hole)
3. Pi-hole logs the query
4. You see `allawnos.com` in Pi-hole query log
5. Use ADB to find which app made the query
6. Remove/disable the app

**Real-world example:**

- Pi-hole query log shows `heytapmobile.com` queried 50 times/hour
- Use ADB investigation to find `com.oppo.heycloud` is responsible
- Remove app with `pm uninstall --user 0 com.oppo.heycloud`
- Verify queries stop in Pi-hole logs

### The Bypass Problem

**Android + apps can sometimes bypass Pi-hole via hardcoded DNS or DoH.**

**What this means:**

- Some apps use hardcoded DNS servers (bypass Pi-hole)
- Some apps use DNS-over-HTTPS (DoH) directly
- Pi-hole won't see these queries
- Need additional enforcement methods

**Why it happens:**

- Apps want to ensure connectivity
- Vendors want to bypass user DNS controls
- Privacy-focused users block telemetry
- Apps find ways around blocks

**Solutions:**

- Use firewall rules to block direct connections
- Configure router to redirect DNS
- Use on-device tools (PCAPdroid, TrackerControl)
- Block at network level, not just DNS

**Recommended reading:**

- **Enforcement patterns:** [`../pi-hole/docs/hardcoded-dns.md`](../pi-hole/docs/hardcoded-dns.md)
- **DNS fundamentals:** [`../networking/docs/dns.md`](../networking/docs/dns.md)

---

## Prerequisites

### What You Need Before Starting

**1. Android Device**

- Any Android device (phone, tablet)
- USB cable for connection
- Developer options enabled

**2. Computer**

- Linux, macOS, or Windows
- ADB installed (Android Debug Bridge)
- Terminal/command line access

**3. Basic Knowledge**

- Comfortable with command line
- Understanding of Android apps
- Basic networking concepts (DNS, IP addresses)

**4. Optional but Recommended**

- Pi-hole running on your network
- Understanding of DNS and networking
- Backup of important data

### Why Each Prerequisite Matters

**Android Device:**

- **Why needed:** Target device for debloating
- **What happens without:** Can't debloat anything
- **Real-world:** Your phone is what you're cleaning up

**Computer with ADB:**

- **Why needed:** ADB runs on computer, connects to phone
- **What happens without:** Can't send commands to phone
- **Real-world:** Like remote control for your phone

**Basic Knowledge:**

- **Why needed:** Understand what you're doing
- **What happens without:** Risk of breaking things
- **Real-world:** Need to understand commands before running them

**Pi-hole (Optional):**

- **Why helpful:** Shows telemetry domains
- **What happens without:** Harder to identify telemetry
- **Real-world:** Like a security camera showing what's happening

---

## Definition of Done (Checklist)

After completing this module, you should be able to:

### ✅ Basic Skills

- **Run `adb devices` successfully**

  - Connect phone to computer
  - Enable USB debugging
  - See device listed in ADB
  - **Why important:** Foundation for all debloating

- **Identify a suspicious domain in Pi-hole**
  - Find telemetry domains in query log
  - Understand what domains mean
  - Recognize vendor telemetry patterns
  - **Why important:** Know what to investigate

### ✅ Investigation Skills

- **Attribute domain to an app/package**
  - Use ADB to investigate network activity
  - Map domains to packages via logs/UIDs
  - Identify responsible apps
  - **Why important:** Know what to remove

### ✅ Debloating Skills

- **Debloat/disable packages safely**
  - Choose appropriate removal method
  - Execute commands correctly
  - Make one change at a time
  - **Why important:** Remove telemetry without breaking device

### ✅ Verification Skills

- **Verify traffic reduction**
  - Check Pi-hole logs show reduced queries
  - Use on-device tools to confirm
  - Verify device still works
  - **Why important:** Confirm debloating worked

---

## Next Steps

1. **New to ADB?** Start with [`docs/adb.md`](docs/adb.md)
2. **Want to understand safety?** Read [`docs/safety-rollback.md`](docs/safety-rollback.md)
3. **Ready to investigate?** Follow [`docs/investigation.md`](docs/investigation.md)
4. **Need quick reference?** See [`debloat.md`](debloat.md) (all-in-one guide)
