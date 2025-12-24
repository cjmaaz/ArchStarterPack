# Flatpak Sandboxing Issues & Solutions

**Common problems with Flatpak applications losing settings, cookies, and customizations.**

---

## 🎯 Problem Overview

### What Is Sandboxing?

**Definition:** **Sandboxing** is a security mechanism that isolates applications from the rest of the system, restricting what resources they can access.

**Why sandboxing exists:**

- **Security:** Prevents apps from accessing system files or other apps
- **Privacy:** Limits what data apps can access
- **Stability:** Prevents apps from breaking system
- **Isolation:** Each app runs in its own isolated environment

**How sandboxing works:**

- **Container:** App runs in isolated container
- **Restricted access:** Can only access allowed resources
- **Permissions:** Must be granted access to resources
- **Isolation:** Can't access other apps or system files

**Real-world analogy:**

- **Sandbox = Playpen** (isolated space for app)
- **App = Child** (can only play in playpen)
- **Permissions = Toys** (what app can access)
- **System = House** (rest of system, app can't access)

### Why Flatpak Uses Sandboxing

**Flatpak applications run in sandboxed containers for security.**

**What this means:**

- **Isolated execution:** Each app runs in its own container
- **Restricted access:** Apps can't access everything
- **Permission-based:** Apps need permission for resources
- **Security benefit:** Prevents malicious apps from harming system

**Why it's important:**

- **Security:** Protects system from malicious apps
- **Privacy:** Prevents apps from accessing unauthorized data
- **Stability:** Prevents apps from breaking system
- **User control:** You control what apps can access

### The Sandboxing Problem

**Sometimes this sandboxing can cause applications (especially browsers) to lose:**

**1. Browser settings and preferences:**

- **What:** Custom settings, preferences, configurations
- **Why lost:** Sandbox can't write to expected locations
- **Impact:** Settings reset on each launch

**2. Cookies and session data:**

- **What:** Login sessions, cookies, authentication data
- **Why lost:** Sandbox can't persist data properly
- **Impact:** Have to log in repeatedly

**3. Extensions and customizations:**

- **What:** Browser extensions, themes, customizations
- **Why lost:** Sandbox can't save extension data
- **Impact:** Extensions don't persist

**4. Saved passwords and bookmarks:**

- **What:** Saved passwords, bookmarks, browsing data
- **Why lost:** Sandbox can't access password storage
- **Impact:** Have to re-enter passwords, lose bookmarks

**5. User data persistence:**

- **What:** Any user data that should persist
- **Why lost:** Sandbox can't write to persistent storage
- **Impact:** Data lost between sessions

**Real-world example:**

**Problem:** Browser loses all settings every time you close it

**Cause:** Sandbox can't write to home directory where settings stored

**Solution:** Grant sandbox access to home directory

---

## 🔍 Diagnosing Sandboxing Issues

### What Diagnosis Means

**Definition:** **Diagnosis** is the process of identifying why an application is losing data or not working correctly due to sandboxing.

**Why diagnosis is needed:**

- **Identify problem:** Know what's wrong
- **Find cause:** Understand why it's happening
- **Apply fix:** Know what to fix
- **Verify solution:** Confirm fix worked

### Check Application Information

**What this does:** Shows detailed information about the Flatpak application, including its sandbox configuration.

**Command:**

```bash
# View Flatpak application details
flatpak info <app-id>

# Example for a browser:
flatpak info org.zen.browser
# or
flatpak info org.mozilla.firefox
# or
flatpak info com.google.Chrome
```

**What output shows:**

- **Application ID:** Unique identifier for app
- **Version:** App version number
- **Runtime:** Base runtime used
- **Permissions:** What app can access
- **Sandbox configuration:** Sandbox settings

**Real-world example:**

**Check browser info:**

```bash
$ flatpak info org.zen.browser
Name: Zen Browser
ID: org.zen.browser
Version: 1.0.0
Runtime: org.freedesktop.Platform/x86_64/22.08
...
```

**Use this to:** Understand app configuration and identify potential issues.

### Check Current Overrides

**What this does:** Shows what permissions and overrides are currently set for the application.

**Command:**

```bash
# See what permissions/overrides are currently set
flatpak override --show <app-id>

# Example:
flatpak override --show org.zen.browser
```

**What output shows:**

- **Filesystem access:** What directories app can access
- **Network access:** Network permissions
- **Device access:** Hardware device permissions
- **Overrides:** Custom permission overrides

**Real-world example:**

**Check overrides:**

```bash
$ flatpak override --show org.zen.browser
[Context]
filesystems=home
...
```

**Use this to:** See what permissions app has and identify missing permissions.

### Check Sandbox Directory Permissions

**What this does:** Verifies that the sandbox directory exists and has correct permissions.

**Flatpak applications store data in `~/.var/app/<app-id>/`.**

**Why this matters:**

- **Data location:** This is where app stores its data
- **Permissions:** Directory must be writable
- **Ownership:** Must be owned by your user

**Check if the directory exists:**

```bash
# Check if the directory exists
ls -la ~/.var/app/<app-id>/

# Check permissions
ls -ld ~/.var/app/<app-id>/

# Example:
ls -la ~/.var/app/org.zen.browser/
```

**What to look for:**

- **Directory exists:** Should see directory listing
- **Permissions:** Should be writable by your user
- **Ownership:** Should be owned by your user

**Common Issues:**

**1. Directory doesn't exist:**

- **Problem:** Sandbox directory not created
- **Cause:** App never created directory or was deleted
- **Solution:** App will create on next launch, or create manually

**2. Directory not writable:**

- **Problem:** Can't write to directory
- **Cause:** Wrong permissions set
- **Solution:** Fix permissions with `chmod`

**3. Wrong ownership:**

- **Problem:** Directory owned by wrong user
- **Cause:** Ran app as different user or root
- **Solution:** Fix ownership with `chown`

**4. Sandbox can't write to persistent storage:**

- **Problem:** App can't save data
- **Cause:** Missing filesystem permissions
- **Solution:** Grant filesystem access with `flatpak override`

**Real-world example:**

**Check directory:**

```bash
$ ls -la ~/.var/app/org.zen.browser/
total 0
drwxr-xr-x 2 root root 4096 Jan 15 10:00 .
# Wrong ownership (root instead of user) ❌
```

**Fix ownership:**

```bash
$ sudo chown -R $USER:$USER ~/.var/app/org.zen.browser/
$ ls -la ~/.var/app/org.zen.browser/
total 0
drwxr-xr-x 2 user user 4096 Jan 15 10:00 .
# Correct ownership ✅
```

---

## ✅ Solutions

### Solution 1: Fix Directory Permissions

**What this does:** Fixes ownership and permissions on the sandbox directory so the app can write to it.

**Why it's needed:**

- **Wrong ownership:** Directory owned by root or wrong user
- **Wrong permissions:** Directory not writable by app
- **Can't save data:** App can't write to directory

**How it works:**

- **`chown`:** Changes ownership to your user
- **`chmod`:** Adds write permissions
- **Result:** App can now write to directory

**If the sandbox directory exists but has wrong permissions:**

```bash
# Fix ownership (replace <app-id> with your app)
sudo chown -R $USER:$USER ~/.var/app/<app-id>/

# Fix permissions
chmod -R u+w ~/.var/app/<app-id>/

# Example for Zen Browser:
sudo chown -R $USER:$USER ~/.var/app/org.zen.browser/
chmod -R u+w ~/.var/app/org.zen.browser/
```

**What each command does:**

**`sudo chown -R $USER:$USER ~/.var/app/<app-id>/`:**

- **`sudo`:** Run as root (needed to change ownership)
- **`chown`:** Change ownership command
- **`-R`:** Recursive (all files and subdirectories)
- **`$USER:$USER`:** Change to your user (user:group)
- **`~/.var/app/<app-id>/`:** Directory to fix
- **Result:** Directory owned by your user

**`chmod -R u+w ~/.var/app/<app-id>/`:**

- **`chmod`:** Change permissions command
- **`-R`:** Recursive (all files and subdirectories)
- **`u+w`:** Add write permission for user (owner)
- **`~/.var/app/<app-id>/`:** Directory to fix
- **Result:** Directory writable by your user

**Real-world example:**

**Before:**

```bash
$ ls -ld ~/.var/app/org.zen.browser/
drwxr-xr-x 2 root root 4096 Jan 15 10:00 ~/.var/app/org.zen.browser/
# Owned by root, not writable by user ❌
```

**Fix:**

```bash
$ sudo chown -R $USER:$USER ~/.var/app/org.zen.browser/
$ chmod -R u+w ~/.var/app/org.zen.browser/
```

**After:**

```bash
$ ls -ld ~/.var/app/org.zen.browser/
drwxrwxr-x 2 user user 4096 Jan 15 10:00 ~/.var/app/org.zen.browser/
# Owned by user, writable ✅
```

**When to use:** When directory exists but has wrong ownership or permissions.

### Solution 2: Grant Filesystem Access

**What this does:** Grants the Flatpak application permission to access specific directories on your filesystem.

**Why it's needed:**

- **Sandbox restriction:** Apps can't access filesystem by default
- **Need persistence:** Apps need to save data somewhere
- **Home directory:** Apps typically need home directory access

**How it works:**

- **`flatpak override`:** Overrides default sandbox permissions
- **`--user`:** Apply to user (not system-wide)
- **`--filesystem=home`:** Grant access to home directory
- **Result:** App can access specified directories

**Allow the application to access necessary directories:**

```bash
# Grant access to home directory (for settings persistence)
flatpak override --user --filesystem=home <app-id>

# Grant access to specific directories
flatpak override --user --filesystem=~/Documents <app-id>
flatpak override --user --filesystem=~/Downloads <app-id>

# Example:
flatpak override --user --filesystem=home org.zen.browser
```

**What each command does:**

**`flatpak override --user --filesystem=home <app-id>`:**

- **`flatpak override`:** Override sandbox permissions
- **`--user`:** Apply to current user only
- **`--filesystem=home`:** Grant access to home directory
- **`<app-id>`:** Application ID to override
- **Result:** App can access home directory

**`flatpak override --user --filesystem=~/Documents <app-id>`:**

- **`--filesystem=~/Documents`:** Grant access to Documents directory
- **Result:** App can access Documents directory

**Real-world example:**

**Before override:**

- Browser can't save settings (no home directory access)
- Settings lost on each launch ❌

**Apply override:**

```bash
$ flatpak override --user --filesystem=home org.zen.browser
```

**After override:**

- Browser can save settings (has home directory access)
- Settings persist between launches ✅

**When to use:** When app needs to save data but can't access filesystem.

### Solution 3: Disable Sandboxing (Not Recommended)

**⚠️ Warning:** This reduces security. Only use if other solutions don't work.

```bash
# Completely disable sandboxing (use with caution)
flatpak override --user --nofilesystem=home <app-id>
flatpak override --user --socket=fallback-x11 <app-id>
flatpak override --user --socket=wayland <app-id>
flatpak override --user --socket=pulseaudio <app-id>
flatpak override --user --device=all <app-id>
```

### Solution 4: Reset Application Data

If settings are corrupted, reset the application:

```bash
# Backup current data (optional)
cp -r ~/.var/app/<app-id> ~/.var/app/<app-id>.backup

# Remove application data
rm -rf ~/.var/app/<app-id>/

# Restart the application (it will recreate the directory)
```

### Solution 5: Check for Conflicting Overrides

Sometimes multiple overrides conflict:

```bash
# View all overrides
flatpak override --show <app-id>

# Remove all overrides and start fresh
flatpak override --user --reset <app-id>

# Then apply only necessary overrides
flatpak override --user --filesystem=home <app-id>
```

---

## 🔧 Browser-Specific Solutions

### For Any Browser (Generic)

**Problem:** Browser loses cookies, settings, extensions, or session data.

**Solution:**

```bash
# Step 1: Check current overrides
flatpak override --show org.zen.browser

# Step 2: Grant home directory access
flatpak override --user --filesystem=home org.zen.browser

# Step 3: Fix directory permissions
sudo chown -R $USER:$USER ~/.var/app/org.zen.browser/
chmod -R u+w ~/.var/app/org.zen.browser/

# Step 4: Restart browser
flatpak run org.zen.browser
```

### Common Browser App IDs

- **Zen Browser:** `org.zen.browser`
- **Firefox:** `org.mozilla.firefox`
- **Chrome:** `com.google.Chrome`
- **Chromium:** `org.chromium.Chromium`
- **Brave:** `com.brave.Browser`
- **Edge:** `com.microsoft.Edge`
- **Opera:** `com.opera.Opera`
- **Vivaldi:** `com.vivaldi.Vivaldi`

---

## 📋 Step-by-Step Troubleshooting

### Step 1: Identify the Problem

```bash
# What's happening?
# - Settings not saving?
# - Cookies being cleared?
# - Extensions not persisting?
# - Session data lost on restart?

# Check if it's a Flatpak app
flatpak list | grep <app-name>
```

### Step 2: Check Sandbox Status

```bash
# Get app ID
APP_ID=$(flatpak list | grep <app-name> | awk '{print $1}')

# Check overrides
flatpak override --show $APP_ID

# Check directory
ls -la ~/.var/app/$APP_ID/
```

### Step 3: Apply Fixes

```bash
# Fix permissions
sudo chown -R $USER:$USER ~/.var/app/$APP_ID/
chmod -R u+w ~/.var/app/$APP_ID/

# Grant filesystem access
flatpak override --user --filesystem=home $APP_ID

# Restart application
flatpak run $APP_ID
```

### Step 4: Verify Fix

1. Open the application
2. Change a setting
3. Close the application
4. Reopen the application
5. Verify setting persisted

---

## 🛡️ Best Practices

### For Applications That Need Persistent Data

```bash
# Always grant home directory access
flatpak override --user --filesystem=home <app-id>

# For browsers, also grant:
flatpak override --user --filesystem=~/Downloads <app-id>
flatpak override --user --filesystem=~/Documents <app-id>
```

### For Applications That Need Network Access

```bash
# Grant network access (usually enabled by default)
flatpak override --user --socket=network <app-id>
```

### For Applications That Need Device Access

```bash
# Grant access to specific devices
flatpak override --user --device=all <app-id>
# or specific device:
flatpak override --user --device=dri <app-id>  # GPU access
```

---

## 🔍 Advanced Diagnostics

### Check Sandbox Logs

```bash
# View Flatpak logs
journalctl --user -u flatpak

# View application-specific logs
journalctl --user | grep <app-id>
```

### Check Disk Space

```bash
# Check if sandbox directory has space
df -h ~/.var/app/<app-id>/

# Check directory size
du -sh ~/.var/app/<app-id>/
```

### Verify Sandbox Isolation

```bash
# Check what the sandbox can see
flatpak run --command=sh <app-id>
# Inside sandbox:
ls ~/
ls ~/.var/app/<app-id>/
exit
```

---

## ⚠️ When to Consider Alternatives

If Flatpak sandboxing continues to cause issues, consider:

1. **AppImage** - No sandboxing, portable

   - See [`README.md`](./README.md) for AppImage setup

2. **Native Package** - System integration

   - Install from Arch repositories or AUR

3. **Manual Installation** - Full control
   - Download and install manually

---

## 📚 Additional Resources

- **Flatpak Documentation:** https://docs.flatpak.org/
- **Flatpak Overrides Guide:** `man flatpak-override`
- **Sandboxing Documentation:** https://docs.flatpak.org/en/latest/sandbox-permissions.html

---

## 🎯 Quick Reference

**Browser losing settings?**

```bash
# Quick fix:
flatpak override --user --filesystem=home <app-id>
sudo chown -R $USER:$USER ~/.var/app/<app-id>/
chmod -R u+w ~/.var/app/<app-id>/
```

**Check what's wrong:**

```bash
flatpak override --show <app-id>
ls -la ~/.var/app/<app-id>/
```

**Reset and start fresh:**

```bash
flatpak override --user --reset <app-id>
rm -rf ~/.var/app/<app-id>/
flatpak override --user --filesystem=home <app-id>
```

---

**For AppImage setup and other package management guides, see [`README.md`](./README.md).**
