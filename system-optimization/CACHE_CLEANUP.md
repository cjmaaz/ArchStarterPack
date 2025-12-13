# Cache Cleanup Guide

**Clean package manager caches, logs, and temporary files to reclaim disk space.**

This guide covers cleaning caches for `pacman`, `paru`, `flatpak`, systemd journals, and other temporary files on Arch/CachyOS systems.

---

## Understanding Caches

Caches store downloaded packages, build artifacts, and temporary data to speed up operations. Over time, these can consume significant disk space.

### Common Cache Locations

- **Pacman:** `/var/cache/pacman/pkg/` - Downloaded package files
- **Paru:** `~/.cache/paru/` - AUR build cache and cloned repositories
- **Flatpak:** `~/.var/app/` and `/var/lib/flatpak/` - Application data and runtimes
- **Systemd Journal:** `/var/log/journal/` - System logs
- **Temporary Files:** `/tmp/`, `~/.cache/` - Various application caches

---

## Pacman Cache Cleanup

Pacman stores downloaded packages in `/var/cache/pacman/pkg/` to allow reinstallation without re-downloading.

### Check Cache Size

```bash
# Check pacman cache size
du -sh /var/cache/pacman/pkg/

# List cache contents
ls -lh /var/cache/pacman/pkg/ | head -20

# Count cached packages
ls /var/cache/pacman/pkg/ | wc -l
```

### Clean Unused Packages (Recommended)

This removes packages that are not installed and not in the sync database:

```bash
# Clean unused packages (keeps last 2 versions of installed packages)
sudo pacman -Sc

# Review what will be removed first (dry-run)
sudo pacman -Sc --noconfirm --print
```

**What `pacman -Sc` does:**

- Removes packages not in sync database
- Removes old versions (keeps last 2)
- Keeps packages for currently installed software

### Clean All Cache (Dangerous!)

**Warning:** This removes ALL cached packages. You'll need to re-download everything on next update.

```bash
# Clean all cache (use with caution!)
sudo pacman -Scc

# This will prompt for confirmation
```

**When to use `-Scc`:**

- Desperate for disk space
- Cache is corrupted
- You have fast internet and don't mind re-downloading

### Keep Specific Number of Versions

Pacman doesn't have a built-in option to keep N versions, but you can manually clean:

```bash
# Keep only last version (more aggressive)
# This requires manual cleanup or a script
```

**Recommended:** Use `pacman -Sc` which keeps last 2 versions automatically.

---

## Paru Cache Cleanup

Paru (AUR helper) caches build directories and cloned repositories in `~/.cache/paru/`.

### Check Paru Cache Size

```bash
# Check paru cache size
du -sh ~/.cache/paru/

# List cache contents
ls -lh ~/.cache/paru/

# Check build cache
du -sh ~/.cache/paru/build/
```

### Clean Paru Cache

```bash
# Clean paru cache (removes build artifacts)
paru -Sc

# This removes:
# - Build directories for installed packages
# - Old build artifacts
# - Keeps source tarballs for currently installed packages
```

### Clean Paru Build Cache Manually

```bash
# Remove all build directories (safe if packages are installed)
rm -rf ~/.cache/paru/build/*

# Remove cloned repositories (will re-clone on next build)
rm -rf ~/.cache/paru/clone/*

# Remove everything in paru cache
rm -rf ~/.cache/paru/*
```

**Note:** Paru will re-clone and rebuild as needed, so this is safe.

### Clean Specific Package Cache

```bash
# Remove cache for specific package
rm -rf ~/.cache/paru/build/package-name
rm -rf ~/.cache/paru/clone/package-name
```

---

## Flatpak Cache Cleanup

Flatpak applications store data in `~/.var/app/` and system-wide data in `/var/lib/flatpak/`.

### Check Flatpak Usage

```bash
# Check Flatpak disk usage
du -sh ~/.var/app/
du -sh /var/lib/flatpak/

# List installed applications
flatpak list

# List installed runtimes
flatpak list --runtime
```

### Remove Unused Runtimes

Runtimes are shared libraries used by Flatpak applications. Unused runtimes can be safely removed:

```bash
# List unused runtimes
flatpak list --runtime --unused

# Remove unused runtimes
flatpak uninstall --unused

# Remove unused runtimes (dry-run)
flatpak uninstall --unused --dry-run
```

### Clean Flatpak Cache

```bash
# Repair Flatpak (fixes broken installations and cleans cache)
flatpak repair

# Clean application cache (removes temporary files)
# Note: This doesn't remove application data
```

### Remove Application Data

**Warning:** This removes application settings and data!

```bash
# Remove application and its data
flatpak uninstall --delete-data app-id

# Example:
flatpak uninstall --delete-data org.zen.browser
```

### Clean Specific Application Cache

```bash
# Application data is in ~/.var/app/<app-id>/
# Check size
du -sh ~/.var/app/org.zen.browser/

# Remove cache (keeps settings)
rm -rf ~/.var/app/org.zen.browser/cache/

# Remove all temporary files
find ~/.var/app/ -type d -name "cache" -exec rm -rf {} +
```

---

## Systemd Journal Cleanup

Systemd stores logs in `/var/log/journal/` which can grow large over time.

### Check Journal Size

```bash
# Check journal disk usage
journalctl --disk-usage

# Check journal location
journalctl --list-boots
```

### Clean Journal Logs

```bash
# Keep last 7 days of logs
sudo journalctl --vacuum-time=7d

# Keep last 100MB of logs
sudo journalctl --vacuum-size=100M

# Keep last 10 files
sudo journalctl --vacuum-files=10

# Clean all logs older than 3 days
sudo journalctl --vacuum-time=3d
```

### Set Journal Size Limit

Edit `/etc/systemd/journald.conf`:

```ini
[Journal]
SystemMaxUse=500M
SystemKeepFree=1G
SystemMaxFileSize=50M
```

Then restart journald:

```bash
sudo systemctl restart systemd-journald
```

---

## Temporary Files Cleanup

Various applications create temporary files that can accumulate.

### Common Temporary Locations

```bash
# System temporary directory
/tmp/

# User cache directory
~/.cache/

# User temporary directory
~/.tmp/  # (if exists)

# Browser caches (if applicable)
~/.cache/mozilla/
~/.cache/google-chrome/
~/.cache/chromium/
```

### Clean Temporary Files

```bash
# Clean /tmp (system cleans on reboot, but you can clean manually)
sudo rm -rf /tmp/*

# Clean user cache (be careful - removes application caches)
rm -rf ~/.cache/*

# Clean specific application cache
rm -rf ~/.cache/firefox/
rm -rf ~/.cache/chromium/
```

### Safe Cache Cleanup

Some caches are important to keep:

```bash
# Keep these caches:
# - ~/.cache/pip/ (Python packages)
# - ~/.cache/pacman/ (if using)
# - ~/.cache/paru/ (AUR helper)

# Safe to remove:
# - Browser caches (will rebuild)
# - Old application caches
# - Temporary download files
```

---

## Cache Cleanup Process

```mermaid
flowchart TD
    Start([Start Cache Cleanup]) --> CheckSpace[Check Disk Space<br/>df -h]
    CheckSpace --> CheckPacman[Check Pacman Cache<br/>du -sh /var/cache/pacman/pkg/]
    CheckPacman --> CleanPacman[Clean Pacman Cache<br/>pacman -Sc]
    CleanPacman --> CheckParu[Check Paru Cache<br/>du -sh ~/.cache/paru/]
    CheckParu --> CleanParu[Clean Paru Cache<br/>paru -Sc]
    CleanParu --> CheckFlatpak[Check Flatpak<br/>flatpak list --runtime --unused]
    CheckFlatpak --> CleanFlatpak[Remove Unused Runtimes<br/>flatpak uninstall --unused]
    CleanFlatpak --> CheckJournal[Check Journal Size<br/>journalctl --disk-usage]
    CheckJournal --> CleanJournal[Clean Journal<br/>journalctl --vacuum-time=7d]
    CleanJournal --> CheckTemp[Check Temp Files<br/>du -sh /tmp/]
    CheckTemp --> CleanTemp[Clean Temp Files<br/>rm -rf /tmp/*]
    CleanTemp --> Verify[Verify Space Freed<br/>df -h]
    Verify --> End([Cleanup Complete])

    style Start fill:#e1f5ff
    style CleanPacman fill:#fff3cd
    style CleanParu fill:#fff3cd
    style CleanFlatpak fill:#fff3cd
    style CleanJournal fill:#fff3cd
    style Verify fill:#d1ecf1
    style End fill:#c8e6c9
```

---

## Automated Cache Cleanup Script

Use the provided script for automated cleanup:

```bash
# Run cache cleanup script
./scripts/cleanup-cache.sh
```

The script will:

- Check cache sizes before cleanup
- Clean pacman cache (keeps last 2 versions)
- Clean paru cache
- Remove unused Flatpak runtimes
- Rotate journal logs
- Show space saved

---

## Step-by-Step Cleanup Process

### Step 1: Check Current Disk Usage

```bash
# Check overall disk usage
df -h

# Check cache sizes
echo "=== Cache Sizes ===" > cache-report.txt
echo "Pacman: $(du -sh /var/cache/pacman/pkg/ | cut -f1)" >> cache-report.txt
echo "Paru: $(du -sh ~/.cache/paru/ 2>/dev/null | cut -f1 || echo 'N/A')" >> cache-report.txt
echo "Flatpak: $(du -sh ~/.var/app/ 2>/dev/null | cut -f1 || echo 'N/A')" >> cache-report.txt
echo "Journal: $(journalctl --disk-usage 2>/dev/null | awk '{print $7}' || echo 'N/A')" >> cache-report.txt

cat cache-report.txt
```

### Step 2: Clean Pacman Cache

```bash
# Check what will be removed
sudo pacman -Sc --noconfirm --print

# Clean cache (keeps last 2 versions)
sudo pacman -Sc

# Verify cache size reduced
du -sh /var/cache/pacman/pkg/
```

### Step 3: Clean Paru Cache

```bash
# Clean paru cache
paru -Sc

# Or manually clean build cache
rm -rf ~/.cache/paru/build/*

# Verify
du -sh ~/.cache/paru/
```

### Step 4: Clean Flatpak

```bash
# List unused runtimes
flatpak list --runtime --unused

# Remove unused runtimes
flatpak uninstall --unused

# Repair if needed
flatpak repair

# Verify
flatpak list --runtime
```

### Step 5: Clean Journal Logs

```bash
# Check current size
journalctl --disk-usage

# Clean (keep last 7 days)
sudo journalctl --vacuum-time=7d

# Verify
journalctl --disk-usage
```

### Step 6: Clean Temporary Files

```bash
# Clean /tmp (safe, system recreates on reboot)
sudo rm -rf /tmp/*

# Clean user cache (be selective)
# Remove browser caches if needed
rm -rf ~/.cache/firefox/
rm -rf ~/.cache/chromium/
```

### Step 7: Verify Space Freed

```bash
# Check disk usage again
df -h

# Compare with initial report
```

---

## Maintenance Schedule

### Weekly

- Clean temporary files (`/tmp/`)
- Check journal size

### Monthly

- Clean pacman cache (`pacman -Sc`)
- Clean paru cache (`paru -Sc`)
- Remove unused Flatpak runtimes

### Quarterly

- Review Flatpak applications
- Deep clean if needed (`pacman -Scc` - use with caution)

---

## Troubleshooting

### "Permission denied" when cleaning pacman cache

**Error:**

```
error: cannot open cache directory: Permission denied
```

**Solution:**

- Use `sudo` for pacman cache: `sudo pacman -Sc`
- Pacman cache is system-wide and requires root

### "Paru cache still large after cleanup"

**Solution:**

- Check for large source tarballs: `du -sh ~/.cache/paru/clone/*`
- Manually remove if needed: `rm -rf ~/.cache/paru/clone/package-name`
- Paru will re-clone on next build

### "Flatpak uninstall --unused doesn't free space"

**Solution:**

- Check application data: `du -sh ~/.var/app/*`
- Application data is separate from runtimes
- Remove unused applications: `flatpak uninstall app-id`

### "Journal still large after vacuum"

**Solution:**

- Check journal limits: `cat /etc/systemd/journald.conf`
- Set lower limits and restart: `sudo systemctl restart systemd-journald`
- Check for specific large logs: `journalctl --disk-usage`

---

## Best Practices

1. **Regular Cleanup:** Clean caches monthly
2. **Keep Recent Versions:** Use `pacman -Sc` (keeps last 2)
3. **Monitor Journal:** Set size limits in journald.conf
4. **Backup Before Deep Clean:** Before `pacman -Scc`
5. **Check Space Before Cleanup:** Know how much space you'll free
6. **Automate:** Use scripts for regular maintenance

---

## Quick Reference

```bash
# Check cache sizes
du -sh /var/cache/pacman/pkg/
du -sh ~/.cache/paru/
du -sh ~/.var/app/

# Clean pacman cache (keeps last 2)
sudo pacman -Sc

# Clean paru cache
paru -Sc

# Remove unused Flatpak runtimes
flatpak uninstall --unused

# Clean journal (keep last 7 days)
sudo journalctl --vacuum-time=7d

# Clean temporary files
sudo rm -rf /tmp/*
```

---

## Expected Space Savings

Typical space freed:

- **Pacman cache:** 500MB - 5GB (depends on installed packages)
- **Paru cache:** 100MB - 2GB (depends on AUR packages)
- **Flatpak runtimes:** 200MB - 1GB (depends on unused runtimes)
- **Journal logs:** 100MB - 2GB (depends on log retention)
- **Temporary files:** 50MB - 500MB

**Total:** Often 1-10GB depending on system usage.

---

**Next Steps:**

- After cleaning caches, remove unused packages: [Package Cleanup Guide](PACKAGE_CLEANUP.md)
- Optimize memory: [Memory Optimization Guide](MEMORY_OPTIMIZATION.md)
- Automate cleanup: [Maintenance Scripts Guide](MAINTENANCE_SCRIPTS.md)
