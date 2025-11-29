-----------------------------------------
# BROTHER PRINTER SETUP — CACHYOS / ARCH LINUX
-----------------------------------------

**Last Updated:** November 2025  
**Tested On:** CachyOS, Arch Linux, Brother DCP-T820DW  
**Difficulty:** Beginner to Intermediate  
**Time Required:** 15-25 minutes

A fully detailed, production-grade setup guide for **Brother DCP-T820DW** and similar Brother printers on **CachyOS (Arch Linux)**.  

**What This Guide Covers:**
- Warning/Important blocks
- Deep technical notes
- Safe execution checks
- Network + USB workflows
- Troubleshooting blocks
- Verification commands
- Logs & driver integrity notes
- Photo management with digiKam


-----------------------------------------
# 1. REQUIREMENTS & BASE SYSTEM SETUP
-----------------------------------------

Install essential packages:

```bash
sudo pacman -S cups cups-pdf avahi nss-mdns system-config-printer
```

Enable required services:

```bash
sudo systemctl enable --now cups
sudo systemctl enable --now avahi-daemon
```

Update `/etc/nsswitch.conf`:

```
hosts: files mymachines mdns_minimal [NOTFOUND=return] dns
```


-----------------------------------------
# 2. INSTALLING THE BROTHER DRIVER (AUR)
-----------------------------------------

Install DCP-T820DW driver:

```bash
paru -S brother-dcpt820dw
```

List all Brother packages:

```bash
paru -Ss brother
```


-----------------------------------------
# 3. SECURITY & DRIVER INTEGRITY NOTES
-----------------------------------------

-----------------------------------------
⚠️  IMPORTANT — ABOUT USERNAME/PASSWORD PROMPT
-----------------------------------------
Brother blocks **direct browser downloads** of `.deb` files using anti-hotlink protection.  
This causes browsers to show a login popup.  
**This is expected and NOT a security issue.**  
AUR helpers (`paru`, `yay`, `makepkg`) download fine.


-----------------------------------------
⚠️  IMPORTANT — VERIFY DRIVER CHECKSUM
-----------------------------------------

Check SHA256:

```bash
makepkg -g
```

Confirm it matches PKGBUILD:

```
6ed43c54bfdcf8e56b6a7a62af6d72424908ea7b0d887d8a7e2c422fd4152434
```


-----------------------------------------
# 4. USB PRINTER SETUP
-----------------------------------------

Check detection:

```bash
lsusb | grep -i brother
```

Add printer via UI:

```bash
system-config-printer
```

Or via CUPS:

```
http://localhost:631/admin
```


-----------------------------------------
# 5. WIFI & NETWORK PRINTER SETUP
-----------------------------------------

-----------------------------------------
⚠️  IMPORTANT — REQUIREMENTS FOR WIFI MODE
-----------------------------------------
Ensure mDNS/Avahi is running:

```bash
systemctl status avahi-daemon
```


### 5.1 Detect printer

```bash
lpinfo -v
```

Typical entries:

```
ipp://BRWXXXX.local/ipp/print
ipp://192.168.1.25/ipp
```


### 5.2 Add IPP Everywhere printer

```bash
sudo lpadmin -p BrotherDCP -E -v "ipp://BRWXXXX.local/ipp/print" -m everywhere
```

If mDNS fails:

```bash
sudo lpadmin -p BrotherDCP -E -v "ipp://<PRINTER-IP>/ipp" -m everywhere
```


-----------------------------------------
# 6. SCANNER SETUP (SANE + BROTHER)
-----------------------------------------

Install scanning dependencies:

```bash
sudo pacman -S sane-airscan simple-scan
paru -S brscan5 brscan-skey
```

Register scanner:

```bash
brsaneconfig5 -a name="BrotherDCP" model=DCPT820DW ip=<IP>
```

Test scanner detection:

```bash
scanimage -L
```

Expected output:
```
device `brother5:net1;dev0' is a Brother DCP-T820DW
```


-----------------------------------------
# 6.1 PHOTO MANAGEMENT WITH DIGIKAM
-----------------------------------------

For advanced photo organization, editing, and management after scanning, **digiKam** is highly recommended.

**Why digiKam?**
- 📸 Professional photo management and organization
- 🏷️ Advanced tagging, rating, and face detection
- 🎨 Non-destructive editing with versioning
- 📁 Album organization and virtual collections
- 🔍 Powerful search and filtering
- 📊 Metadata management (EXIF, IPTC, XMP)
- 🌐 Export to social media and cloud services
- 📷 RAW format support
- 🖼️ Photo layouting and collage creation

**Installation:**

```bash
sudo pacman -S digikam
```

**Optional plugins and tools:**

```bash
# Image processing plugins
sudo pacman -S kipi-plugins

# RAW image support (if not included)
sudo pacman -S libraw

# Additional image format support
sudo pacman -S kimageformats qt5-imageformats

# Video thumbnail support
sudo pacman -S ffmpegthumbs
```

**First-time setup:**

1. Launch digiKam
2. Create or select a photo library location
3. Import scanned photos from Simple Scan output directory (usually `~/Documents`)
4. Configure collections: Settings → Configure digiKam → Collections
5. Enable face detection: Settings → Configure digiKam → Views → People

**Recommended workflow for scanned photos:**

1. **Scan** with Simple Scan → Save to temporary folder
2. **Import** to digiKam library
3. **Tag & Rate** images (5-star system)
4. **Edit** if needed (Tools → Image Editor)
5. **Create albums** or collections
6. **Export** for sharing or printing

**Photo layouting and collage creation:**

digiKam includes powerful layout tools:

```
Tools → Create → HTML Gallery    # Web galleries
Tools → Create → Calendar        # Photo calendars  
Tools → Create → Panorama        # Stitch photos
Tools → Print → Photo Layouts    # Print layouts
```

**Advanced features:**

- **Batch processing:** Tools → Batch Queue Manager
- **Metadata editing:** Right-click → Edit Metadata
- **Duplicate finder:** Tools → Find Duplicates
- **Geolocation:** Map view for geotagged photos
- **Timeline view:** Browse by date
- **Label management:** Color labels, pick labels, tags

**Performance tips:**

- Enable thumbnail caching for faster browsing
- Use MySQL/MariaDB backend for large collections (10,000+ photos)
- Configure preview generation settings for optimal performance

**See also:**
- [digiKam Documentation](https://docs.kde.org/stable5/en/digikam-doc/digikam/)
- [digiKam Tutorials](https://www.digikam.org/documentation/)


-----------------------------------------
# 7. VERIFICATION
-----------------------------------------

Check printer:

```bash
lpstat -p
lpstat -t
```

Test page:

```bash
lp /usr/share/cups/data/testprint
```


-----------------------------------------
# 8. TROUBLESHOOTING
-----------------------------------------

-----------------------------------------
⚠️  FILTER FAILED
-----------------------------------------
Install missing dependencies:

```bash
sudo pacman -S ghostscript gsfonts
sudo systemctl restart cups
```


-----------------------------------------
⚠️  PRINTER NOT FOUND ON WIFI
-----------------------------------------

```bash
ping BRWXXXX.local
```

If mDNS blocked → use direct IP.


-----------------------------------------
⚠️  SCANNER NOT DETECTED
-----------------------------------------

```bash
brsaneconfig5 -a name=Brother model=DCPT820DW ip=<IP>
sudo systemctl restart cups
```


-----------------------------------------
# 9. DRIVER PATHS & LOG LOCATIONS
-----------------------------------------

Brother driver files:

```
/opt/brother/Printers/dcpt820dw/
/opt/brother/scanner/
```

Logs:

```
/tmp/dcpt820dw.log
/var/log/cups/error_log
```


-----------------------------------------
# 10. ADDITIONAL RECOMMENDATIONS
-----------------------------------------

### Photo Editing Alternatives

If digiKam is too heavy or you need specific features:

**GIMP** - Advanced photo editing
```bash
sudo pacman -S gimp
```

**Darktable** - Professional RAW workflow
```bash
sudo pacman -S darktable
```

**RawTherapee** - RAW converter and processor
```bash
sudo pacman -S rawtherapee
```

**Krita** - Digital painting and illustration
```bash
sudo pacman -S krita
```

### Document Management

For scanned documents (PDFs, OCR):

**Paperwork** - Personal document manager with OCR
```bash
paru -S paperwork
```

**Tesseract** - OCR engine for text recognition
```bash
sudo pacman -S tesseract tesseract-data-eng
```

**PDF Tools**
```bash
sudo pacman -S okular          # KDE PDF viewer
sudo pacman -S pdfarranger     # PDF page manipulation
```


-----------------------------------------
# 11. UNINSTALL
-----------------------------------------

Remove printer drivers:

```bash
paru -Rns brother-dcpt820dw
```

Remove scanner drivers:

```bash
paru -Rns brscan5 brscan-skey
```

Remove CUPS (if no longer needed):

```bash
sudo systemctl disable --now cups
sudo pacman -Rns cups cups-pdf
```

Remove digiKam (if installed):

```bash
sudo pacman -Rns digikam kipi-plugins
```


-----------------------------------------
# 12. TROUBLESHOOTING - DIGIKAM SPECIFIC
-----------------------------------------

-----------------------------------------
⚠️  DIGIKAM SLOW PERFORMANCE
-----------------------------------------

**Solution 1:** Enable MySQL backend for large libraries

```bash
sudo pacman -S mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb

# Configure in digiKam:
# Settings → Configure digiKam → Database → Use MySQL
```

**Solution 2:** Adjust thumbnail settings

```
Settings → Configure digiKam → Views → Reduce preview size
```

-----------------------------------------
⚠️  DIGIKAM NOT DETECTING SCANNER
-----------------------------------------

digiKam can import directly from scanner:

```
Import → Import from Scanner
```

If scanner not detected:
1. Ensure SANE is configured (`scanimage -L`)
2. Restart digiKam
3. Use Simple Scan as fallback, then import files


-----------------------------------------
⚠️  RAW FILES NOT OPENING
-----------------------------------------

Install additional RAW support:

```bash
sudo pacman -S libraw dcraw
```


-----------------------------------------
# END OF DOCUMENT
-----------------------------------------
