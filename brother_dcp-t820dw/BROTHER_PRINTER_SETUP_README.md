---

# BROTHER PRINTER SETUP — CACHYOS / ARCH LINUX

---

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

---

# 1. REQUIREMENTS & BASE SYSTEM SETUP

---

## What Is Printer Setup?

### Definition

**Printer setup** is the process of installing drivers, configuring print services, and connecting your printer to your Linux system so you can print documents.

### Why Printer Setup Exists

**The problem:** Printers don't work out-of-the-box on Linux:

- **No drivers:** Linux doesn't have printer drivers by default
- **Service needed:** Print services must be configured
- **Network discovery:** Network printers need discovery setup
- **Configuration:** Printer must be added to system

**The solution:** Printer setup:

- **Installs drivers:** Provides printer-specific drivers
- **Configures services:** Sets up print services (CUPS)
- **Enables discovery:** Allows network printer discovery
- **Adds printer:** Connects printer to system

**Real-world analogy:**

- **Printer setup = Installing printer driver** (like installing driver for new hardware)
- **CUPS = Print manager** (handles all printing)
- **Driver = Translator** (translates print jobs for printer)
- **Result = Can print** (printer works with system)

### How Printer Setup Works

**Step-by-step process:**

1. **Install packages:** Install print services and tools
2. **Enable services:** Start print services
3. **Configure discovery:** Set up network discovery
4. **Install drivers:** Install printer-specific drivers
5. **Add printer:** Connect printer to system
6. **Test printing:** Verify printer works

## Install Essential Packages

**What these packages do:** Provide the foundation for printing on Linux.

**Why each package is needed:**

**Install essential packages:**

```bash
sudo pacman -S cups cups-pdf avahi nss-mdns system-config-printer
```

**Package explanations:**

**1. `cups` (Common Unix Printing System):**

- **What:** Print service daemon (handles all printing)
- **Why needed:** Core printing system, required for printing
- **What it does:** Manages print jobs, queues, printers
- **Real-world:** Like a print manager that handles all printing

**2. `cups-pdf`:**

- **What:** PDF printer driver (prints to PDF files)
- **Why needed:** Allows "printing" to PDF files
- **What it does:** Creates PDF files instead of physical printing
- **Real-world:** Like a virtual printer that creates PDFs

**3. `avahi` (Zeroconf/Bonjour):**

- **What:** Network service discovery daemon
- **Why needed:** Discovers network printers automatically
- **What it does:** Finds printers on network without manual configuration
- **Real-world:** Like a network scanner that finds printers

**4. `nss-mdns` (mDNS name resolution):**

- **What:** Name resolution for mDNS (multicast DNS)
- **Why needed:** Resolves network printer names (.local domains)
- **What it does:** Allows resolving printer.local names
- **Real-world:** Like a phone book for network printers

**5. `system-config-printer`:**

- **What:** GUI tool for printer configuration
- **Why needed:** Easy way to configure printers
- **What it does:** Provides graphical interface for printer setup
- **Real-world:** Like a control panel for printers

**Real-world example:**

**Without these packages:**

- Can't print (no print service)
- Can't discover network printers (no discovery)
- Can't configure printers easily (no GUI tool) ❌

**With these packages:**

- Can print (CUPS running)
- Can discover network printers (Avahi working)
- Can configure printers easily (GUI tool available) ✅

## Enable Required Services

**What services do:** Run in background to handle printing and discovery.

**Why enable services:**

- **CUPS:** Must run for printing to work
- **Avahi:** Must run for network discovery
- **Auto-start:** Services start automatically on boot

**Enable required services:**

```bash
sudo systemctl enable --now cups
sudo systemctl enable --now avahi-daemon
```

**What each command does:**

**`sudo systemctl enable --now cups`:**

- **`systemctl enable`:** Start service on boot (persistent)
- **`--now`:** Start service immediately (don't wait for reboot)
- **`cups`:** CUPS print service
- **Result:** CUPS starts now and on every boot ✅

**`sudo systemctl enable --now avahi-daemon`:**

- **`systemctl enable`:** Start service on boot (persistent)
- **`--now`:** Start service immediately
- **`avahi-daemon`:** Avahi network discovery service
- **Result:** Avahi starts now and on every boot ✅

**Why both are needed:**

- **CUPS:** Handles printing (required)
- **Avahi:** Discovers network printers (needed for network setup)

**Real-world example:**

**Without services enabled:**

- Services not running
- Can't print
- Can't discover printers ❌

**With services enabled:**

- Services running
- Can print
- Can discover printers ✅

## Update `/etc/nsswitch.conf`

**What this file does:** Controls how system resolves hostnames (including network printers).

**Why update it:**

- **mDNS support:** Allows resolving .local printer names
- **Network discovery:** Enables automatic printer discovery
- **Name resolution:** System can find printers by name

**Update `/etc/nsswitch.conf`:**

**What to change:**

```
hosts: files mymachines mdns_minimal [NOTFOUND=return] dns
```

**What this line means:**

- **`hosts:`:** Hostname resolution configuration
- **`files`:** Check `/etc/hosts` file first
- **`mymachines`:** Check systemd mymachines
- **`mdns_minimal`:** Use mDNS for .local names (printer discovery)
- **`[NOTFOUND=return]`:** Stop if not found in mDNS
- **`dns`:** Use DNS as fallback

**Why this order:**

- **Files first:** Check local hosts file (fastest)
- **mDNS for .local:** Resolve printer.local names
- **DNS fallback:** Use DNS if mDNS fails

**Real-world example:**

**Without mDNS:**

- Can't resolve `printer.local`
- Must use IP address
- Manual configuration needed ❌

**With mDNS:**

- Can resolve `printer.local`
- Automatic discovery works
- Easy configuration ✅

---

# 2. INSTALLING THE BROTHER DRIVER (AUR)

---

## What Are Printer Drivers?

### Definition

**Printer drivers** are software that translates print jobs from your computer into commands your printer understands.

### Why Printer Drivers Exist

**The problem:** Printers speak different "languages" than computers:

- **Computer format:** Print jobs in standard formats (PostScript, PDF)
- **Printer format:** Printers need specific commands
- **Translation needed:** Must convert between formats
- **Each printer different:** Each printer model needs its own driver

**The solution:** Printer drivers:

- **Translate:** Convert print jobs to printer commands
- **Model-specific:** Each printer has its driver
- **Enable printing:** Makes printing possible
- **Handle features:** Supports printer-specific features

**Real-world analogy:**

- **Printer driver = Translator** (translates computer language to printer language)
- **Print job = Document** (what you want to print)
- **Printer commands = Printer language** (what printer understands)
- **Driver = Translation service** (makes communication possible)

### How Printer Drivers Work

**Step-by-step process:**

1. **Application sends print job:** Document sent to print system
2. **Driver receives job:** Driver gets print job
3. **Driver translates:** Converts to printer commands
4. **Commands sent to printer:** Printer receives commands
5. **Printer prints:** Printer executes commands

## Install DCP-T820DW Driver

**What this does:** Installs the specific driver for Brother DCP-T820DW printer.

**Why from AUR:**

- **Not in official repos:** Brother drivers not in Arch official repos
- **AUR has drivers:** AUR (Arch User Repository) has Brother drivers
- **Community maintained:** Maintained by Arch community
- **Easy installation:** AUR helpers make installation easy

**Install DCP-T820DW driver:**

```bash
paru -S brother-dcpt820dw
```

**What this command does:**

**`paru -S brother-dcpt820dw`:**

- **`paru`:** AUR helper (installs packages from AUR)
- **`-S`:** Install package
- **`brother-dcpt820dw`:** Brother DCP-T820DW driver package
- **Result:** Driver installed and configured ✅

**How it works:**

1. **Downloads package:** Fetches driver from AUR
2. **Downloads driver files:** Gets driver files from Brother
3. **Installs files:** Places driver files in system
4. **Configures system:** Sets up driver for CUPS
5. **Ready to use:** Printer driver ready

**Real-world example:**

**Before driver installation:**

- Printer not recognized
- Can't print
- Driver missing ❌

**After driver installation:**

- Printer recognized
- Can print
- Driver installed ✅

## List All Brother Packages

**What this does:** Shows all available Brother printer packages in AUR.

**Why it's useful:**

- **Find drivers:** See what Brother drivers are available
- **Check versions:** See available versions
- **Other models:** Find drivers for other Brother printers
- **Related packages:** See related Brother packages

**List all Brother packages:**

```bash
paru -Ss brother
```

**What this command does:**

**`paru -Ss brother`:**

- **`paru`:** AUR helper
- **`-Ss`:** Search AUR repositories
- **`brother`:** Search term (finds Brother packages)
- **Result:** List of all Brother packages ✅

**What you'll see:**

- **Driver packages:** `brother-dcpt820dw`, `brother-dcpt720dw`, etc.
- **Utility packages:** `brother-cups-wrapper`, etc.
- **Package descriptions:** What each package does
- **Version info:** Available versions

**Real-world example:**

**Search results:**

```
aur/brother-dcpt820dw 1.0.0-1
    Brother DCP-T820DW driver

aur/brother-dcpt720dw 1.0.0-1
    Brother DCP-T720DW driver

aur/brother-cups-wrapper 1.0.0-1
    Brother CUPS wrapper
```

**Use:** Find driver for your specific Brother printer model.

---

# 3. SECURITY & DRIVER INTEGRITY NOTES

---

---

## ⚠️ IMPORTANT — ABOUT USERNAME/PASSWORD PROMPT

## What Is Anti-Hotlink Protection?

### Definition

**Anti-hotlink protection** is a security measure that prevents direct downloads of files from websites when accessed through browsers.

### Why This Happens

**The problem:** Brother blocks **direct browser downloads** of `.deb` files using anti-hotlink protection.

**What this means:**

- **Direct downloads:** Downloading files directly from browser
- **Anti-hotlink:** Protection against unauthorized downloads
- **Blocks browsers:** Browser downloads are blocked
- **Allows tools:** AUR helpers can still download

**This causes browsers to show a login popup.**

**What happens:**

- **Browser tries download:** You click download link in browser
- **Protection triggers:** Anti-hotlink protection activates
- **Login popup:** Browser shows username/password prompt
- **Can't download:** Browser download fails

**This is expected and NOT a security issue.**

**Why it's not a problem:**

- **Expected behavior:** This is how Brother's protection works
- **Not malicious:** Not a security threat
- **AUR works:** AUR helpers bypass this protection
- **Normal:** This is normal behavior

**AUR helpers (`paru`, `yay`, `makepkg`) download fine.**

**Why AUR helpers work:**

- **Different method:** AUR helpers use different download method
- **Bypasses protection:** Not affected by anti-hotlink protection
- **Automatic:** Downloads happen automatically
- **No popup:** No login prompt needed

**Real-world analogy:**

- **Browser download = Front door** (blocked by security)
- **AUR helper = Back door** (allowed access)
- **Anti-hotlink = Security guard** (blocks unauthorized access)
- **Result = Use AUR helper** (bypasses protection)

**What to do:**

- **Don't worry:** Login popup is normal
- **Use AUR helper:** Use `paru` or `yay` instead
- **No action needed:** AUR helper handles it automatically ✅

---

## ⚠️ IMPORTANT — VERIFY DRIVER CHECKSUM

## What Is a Checksum?

### Definition

**Checksum** is a cryptographic hash value that verifies file integrity and authenticity.

### Why Verify Checksums

**The problem:** Downloaded files can be:

- **Corrupted:** Damaged during download
- **Tampered:** Modified by attackers
- **Wrong file:** Different file than expected
- **Unsafe:** May contain malware

**The solution:** Checksum verification:

- **Verifies integrity:** Confirms file not corrupted
- **Verifies authenticity:** Confirms file is genuine
- **Detects tampering:** Finds if file was modified
- **Ensures safety:** Confirms file is safe to use

**Real-world analogy:**

- **Checksum = Fingerprint** (unique identifier for file)
- **Verification = Checking ID** (confirm file is correct)
- **Mismatch = Wrong file** (file doesn't match expected)
- **Match = Correct file** (file is genuine) ✅

### How Checksum Verification Works

**Step-by-step process:**

1. **Download file:** Get file from source
2. **Calculate checksum:** Generate hash of downloaded file
3. **Compare checksums:** Compare with expected checksum
4. **Verify match:** Confirm checksums match
5. **Use file:** Safe to use if checksums match

## Check SHA256 Checksum

**What this does:** Generates SHA256 checksum of downloaded driver files.

**Why it's important:**

- **Security:** Verifies driver files are genuine
- **Integrity:** Confirms files not corrupted
- **Safety:** Ensures safe installation
- **Trust:** Confirms files from trusted source

**Check SHA256:**

```bash
makepkg -g
```

**What this command does:**

**`makepkg -g`:**

- **`makepkg`:** Arch package building tool
- **`-g`:** Generate checksums for source files
- **Result:** Shows SHA256 checksums ✅

**How it works:**

1. **Finds source files:** Locates downloaded driver files
2. **Calculates checksums:** Generates SHA256 hash for each file
3. **Displays checksums:** Shows checksum values
4. **Ready to compare:** Can compare with expected values

**What you'll see:**

```
sha256sums=('6ed43c54bfdcf8e56b6a7a62af6d72424908ea7b0d887d8a7e2c422fd4152434')
```

## Confirm It Matches PKGBUILD

**What this does:** Compares generated checksum with expected checksum from PKGBUILD.

**Why it matters:**

- **Verification:** Confirms file is correct
- **Security:** Ensures file not tampered
- **Trust:** Confirms file from trusted source

**Confirm it matches PKGBUILD:**

**Expected checksum:**

```
6ed43c54bfdcf8e56b6a7a62af6d72424908ea7b0d887d8a7e2c422fd4152434
```

**What to do:**

1. **Run `makepkg -g`:** Generate checksum
2. **Compare values:** Check if generated matches expected
3. **Match = Safe:** If matches, file is safe ✅
4. **Mismatch = Problem:** If different, don't use ❌

**Real-world example:**

**Generated checksum:**

```
6ed43c54bfdcf8e56b6a7a62af6d72424908ea7b0d887d8a7e2c422fd4152434
```

**Expected checksum:**

```
6ed43c54bfdcf8e56b6a7a62af6d72424908ea7b0d887d8a7e2c422fd4152434
```

**Result:** ✅ **Match** - File is safe to use

**If mismatch:**

- ❌ **Don't install:** File may be corrupted or tampered
- **Re-download:** Get file again
- **Check source:** Verify download source
- **Contact maintainer:** Report issue if persists

---

# 4. USB PRINTER SETUP

---

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

---

# 5. WIFI & NETWORK PRINTER SETUP

---

---

## ⚠️ IMPORTANT — REQUIREMENTS FOR WIFI MODE

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

---

# 6. SCANNER SETUP (SANE + BROTHER)

---

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

---

# 6.1 PHOTO MANAGEMENT WITH DIGIKAM

---

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

---

# 7. VERIFICATION

---

Check printer:

```bash
lpstat -p
lpstat -t
```

Test page:

```bash
lp /usr/share/cups/data/testprint
```

---

# 8. TROUBLESHOOTING

---

---

## ⚠️ FILTER FAILED

Install missing dependencies:

```bash
sudo pacman -S ghostscript gsfonts
sudo systemctl restart cups
```

---

## ⚠️ PRINTER NOT FOUND ON WIFI

```bash
ping BRWXXXX.local
```

If mDNS blocked → use direct IP.

---

## ⚠️ SCANNER NOT DETECTED

```bash
brsaneconfig5 -a name=Brother model=DCPT820DW ip=<IP>
sudo systemctl restart cups
```

---

# 9. DRIVER PATHS & LOG LOCATIONS

---

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

---

# 10. ADDITIONAL RECOMMENDATIONS

---

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

---

# 11. UNINSTALL

---

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

---

# 12. TROUBLESHOOTING - DIGIKAM SPECIFIC

---

---

## ⚠️ DIGIKAM SLOW PERFORMANCE

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

---

## ⚠️ DIGIKAM NOT DETECTING SCANNER

digiKam can import directly from scanner:

```
Import → Import from Scanner
```

If scanner not detected:

1. Ensure SANE is configured (`scanimage -L`)
2. Restart digiKam
3. Use Simple Scan as fallback, then import files

---

## ⚠️ RAW FILES NOT OPENING

Install additional RAW support:

```bash
sudo pacman -S libraw dcraw
```

---

# END OF DOCUMENT

---
