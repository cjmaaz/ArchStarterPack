# Flatpak Sandboxing Issues & Solutions

**Common problems with Flatpak applications losing settings, cookies, and customizations.**

---

## 🎯 Problem Overview

Flatpak applications run in sandboxed containers for security. Sometimes this sandboxing can cause applications (especially browsers) to lose:

- Browser settings and preferences
- Cookies and session data
- Extensions and customizations
- Saved passwords and bookmarks
- User data persistence

---

## 🔍 Diagnosing Sandboxing Issues

### Check Application Information

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

### Check Current Overrides

```bash
# See what permissions/overrides are currently set
flatpak override --show <app-id>

# Example:
flatpak override --show org.zen.browser
```

### Check Sandbox Directory Permissions

Flatpak applications store data in `~/.var/app/<app-id>/`. Check if this directory exists and is writable:

```bash
# Check if the directory exists
ls -la ~/.var/app/<app-id>/

# Check permissions
ls -ld ~/.var/app/<app-id>/

# Example:
ls -la ~/.var/app/org.zen.browser/
```

**Common Issues:**

- Directory doesn't exist
- Directory not writable
- Wrong ownership
- Sandbox can't write to persistent storage

---

## ✅ Solutions

### Solution 1: Fix Directory Permissions

If the sandbox directory exists but has wrong permissions:

```bash
# Fix ownership (replace <app-id> with your app)
sudo chown -R $USER:$USER ~/.var/app/<app-id>/

# Fix permissions
chmod -R u+w ~/.var/app/<app-id>/

# Example for Zen Browser:
sudo chown -R $USER:$USER ~/.var/app/org.zen.browser/
chmod -R u+w ~/.var/app/org.zen.browser/
```

### Solution 2: Grant Filesystem Access

Allow the application to access necessary directories:

```bash
# Grant access to home directory (for settings persistence)
flatpak override --user --filesystem=home <app-id>

# Grant access to specific directories
flatpak override --user --filesystem=~/Documents <app-id>
flatpak override --user --filesystem=~/Downloads <app-id>

# Example:
flatpak override --user --filesystem=home org.zen.browser
```

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
