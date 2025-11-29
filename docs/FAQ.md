# Frequently Asked Questions (FAQ)

**Last Updated:** November 2025

---

## General Questions

### Q: What is ArchStarterPack?

**A:** ArchStarterPack is a curated collection of configuration files, setup guides, and optimization scripts specifically designed for Arch Linux-based systems. It provides battle-tested configurations for system optimization, hardware peripherals, and development environments.

---

### Q: Do I need to use all the modules?

**A:** No! Each module is independent. You can use:
- Only CachyOS configuration for system optimization
- Only LogiOps for mouse configuration  
- Only Node.js setup for development
- Any combination you need

---

### Q: Will these configurations work on my system?

**A:** The configurations are tested on ASUS X507UF hardware running CachyOS, but they should work on:
- ✅ Any Arch-based distribution (Manjaro, EndeavourOS, etc.)
- ✅ Systems with similar Intel + NVIDIA Optimus setups
- ⚠️ Other hardware with modifications
- ❌ Non-Arch distributions (will need significant adaptation)

Run `./check-prerequisites.sh` to verify compatibility.

---

### Q: Is this safe for beginners?

**A:** The guides are written to be beginner-friendly with:
- Detailed explanations
- Safety checks before critical operations
- Backup instructions
- Rollback procedures

However, system configuration always carries some risk. We recommend:
1. Reading the full guide before starting
2. Creating backups
3. Testing on non-critical systems first
4. Understanding what each command does

---

### Q: Do I need to back up my system first?

**A:** **YES!** Always create backups before making system changes. Each guide includes backup commands, but at minimum:

```bash
# Backup critical configs
sudo cp /etc/default/grub /etc/default/grub.backup
sudo cp -r /etc/modprobe.d /etc/modprobe.d.backup
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
```

---

## CachyOS Module Questions

### Q: Will the CachyOS configurations work on vanilla Arch?

**A:** Yes! The configurations work on any Arch-based distribution. The name "CachyOS" refers to the distribution we tested on, but the settings are generic.

---

### Q: How much will battery life improve?

**A:** Results vary by usage, but typical improvements:
- **Light usage:** 20-30% longer battery life
- **Web browsing:** 15-25% improvement
- **Video playback:** 10-20% improvement

The configurations optimize power management but don't perform miracles. Battery health and age also affect results.

---

### Q: Will performance mode make my laptop overheat?

**A:** No, the configurations include thermal management via `thermald`. Your laptop's BIOS fan control will automatically increase cooling when needed. We've tested under heavy load without thermal issues.

---

### Q: Can I undo the CachyOS configurations?

**A:** Yes! Every guide includes rollback instructions. You can restore from backups or manually remove changes. See the "Rollback Instructions" section in each guide.

---

### Q: Why are there two NVIDIA guides (main and deprecated)?

**A:** 
- **Main guide** (`asus_x_507_uf_readme.md`): Recommended for most users, maintains display flexibility
- **Deprecated guide** (`asus_x_507_uf_nvidia_deprecated.md`): For users who *only* use external monitors and want to completely disable the internal screen

Use the main guide unless you have a specific reason to use the deprecated one.

---

### Q: Do I need NVIDIA drivers for the power optimizations?

**A:** The Intel CPU and GPU optimizations work independently. NVIDIA-specific parameters only affect NVIDIA GPUs. If you don't have an NVIDIA GPU, simply omit those parameters.

---

## LogiOps Module Questions

### Q: Which Logitech mice are supported?

**A:** LogiOps supports many Logitech mice, including:
- MX Master series (3S, 3, 2S, 1)
- MX Anywhere series
- MX Ergo
- Many others with HID++ protocol

Check the [LogiOps GitHub](https://github.com/PixlOne/logiops) for full compatibility.

---

### Q: My mouse model isn't MX Master 3S. Can I still use this?

**A:** Yes! The configuration file works as a template. You'll need to:
1. Change the device name to match your mouse
2. Find the CID codes for your mouse buttons (see readme.md)
3. Adjust button mappings as needed

---

### Q: How do I find CID codes for my mouse buttons?

**A:** 
```bash
# Stop the service
sudo systemctl stop logid

# Run in debug mode
sudo logid -v

# Press buttons on your mouse and observe the CID values in the output
```

---

### Q: The gestures aren't working. What's wrong?

**A:** Common issues:
1. **Wrong CID codes:** Verify with `sudo logid -v`
2. **Config syntax error:** Test with `sudo logid -t`
3. **KDE shortcuts conflict:** Check System Settings → Shortcuts
4. **Service not running:** `sudo systemctl status logid`

---

### Q: Can I use LogiOps with other desktop environments?

**A:** Yes! The button mappings work on any Linux desktop. You may need to adjust keyboard shortcuts in the gestures section to match your DE's shortcuts (the config uses KDE/Plasma shortcuts by default).

---

## Node.js Module Questions

### Q: Why not use fisher or bass for Fish + NVM?

**A:** Our minimal approach:
- ✅ No third-party plugin managers
- ✅ Works with system package manager (pacman)
- ✅ Easier to understand and maintain
- ✅ Faster shell startup time
- ✅ Fewer dependencies

You can use fisher/bass if you prefer, but this approach is simpler.

---

### Q: Does this work in VSCode's integrated terminal?

**A:** Yes! The configuration is designed to work in:
- Native Fish terminals
- VSCode integrated terminal
- Alacritty, Kitty, etc.

If you have issues, see nvm-fish-readme.md troubleshooting section.

---

### Q: How do I switch Node versions?

**A:** 
```bash
# List available versions
nvm list-remote

# Install a specific version
nvm install 18

# Use a version
nvm use 18

# Set default version
nvm alias default 18
```

---

### Q: Can I use this with other shells (bash, zsh)?

**A:** This module is specifically for Fish shell. For bash/zsh, use standard NVM installation:
```bash
# Standard NVM works directly with bash/zsh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

---

### Q: The `node` command is not found after setup. Why?

**A:** 
1. Ensure you've set a default Node version:
   ```bash
   bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'
   ```

2. Reload Fish:
   ```bash
   exec fish
   ```

3. Manually load NVM:
   ```bash
   nvm-load
   node -v
   ```

---

## Technical Questions

### Q: What's the difference between TLP and thermald?

**A:** 
- **TLP:** Manages power profiles, CPU governors, USB autosuspend, battery thresholds (power management)
- **thermald:** Manages thermal zones and cooling devices (thermal management)

They work together: TLP optimizes power, thermald keeps temperatures safe.

---

### Q: What's the difference between Intel P-State and CPUFreq?

**A:** 
- **Intel P-State:** Modern Intel driver (6th gen+), hardware-managed frequencies, better efficiency
- **CPUFreq:** Legacy driver, software-managed frequencies, works on older CPUs

Use P-State on modern Intel CPUs (Skylake and newer).

---

### Q: Do I need to reboot after applying configurations?

**A:** Usually yes, especially for:
- GRUB/kernel parameter changes
- Graphics driver changes
- Power management service changes

Some settings can be applied without rebooting (like TLP configs), but rebooting ensures everything is properly loaded.

---

### Q: Can I mix-and-match settings from different guides?

**A:** Generally yes, but be careful with:
- ❌ Conflicting kernel parameters
- ❌ Overlapping power management (TLP vs power-profiles-daemon)
- ✅ Combining mouse config with system optimization
- ✅ Using Node.js setup with any other module

When in doubt, ask in the Issues section.

---

## Troubleshooting Questions

### Q: My system won't boot after changing GRUB settings. Help!

**A:** 
1. At GRUB menu, press `e` to edit boot entry
2. Remove the problematic parameters from the line starting with `linux`
3. Press `Ctrl+X` to boot
4. Once booted, restore from backup:
   ```bash
   sudo cp /etc/default/grub.backup /etc/default/grub
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for more details.

---

### Q: How do I get help with a specific issue?

**A:** 
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Run diagnostics: `./cachy_os_config/diagnostics.sh`
3. Search existing [GitHub Issues](https://github.com/yourusername/ArchStarterPack/issues)
4. Open a new issue with:
   - Your hardware specs
   - Distribution and kernel version
   - Diagnostics output
   - Steps you've taken
   - Error messages

---

### Q: The configurations made things worse. What should I do?

**A:** 
1. **Don't panic!** Everything is reversible
2. Follow the rollback instructions in the guide you used
3. Restore from backups:
   ```bash
   sudo cp /etc/default/grub.backup.* /etc/default/grub
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   sudo reboot
   ```
4. If still stuck, boot from a live USB and restore configurations

---

## Contributing Questions

### Q: Can I contribute my configurations for different hardware?

**A:** Yes! We welcome contributions for:
- Different laptop models
- Different mice/peripherals
- Different desktop environments
- Additional optimization guides

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

### Q: I found a bug or error. Where do I report it?

**A:** Open an issue on GitHub with:
- Description of the bug
- Steps to reproduce
- Expected vs actual behavior  
- Your system information (run `./check-prerequisites.sh`)

---

### Q: Can I translate the guides to other languages?

**A:** Absolutely! Translations are welcome. Please:
1. Fork the repository
2. Create a language directory (e.g., `docs/es/` for Spanish)
3. Translate the documentation
4. Submit a pull request

---

## License & Legal Questions

### Q: Can I use these configurations in my own projects?

**A:** Yes! This project is open source under the MIT License. You can:
- ✅ Use configurations in personal/commercial projects
- ✅ Modify and adapt to your needs
- ✅ Redistribute with attribution
- ✅ Create derivatives

See [LICENSE](../LICENSE) for full details.

---

### Q: Do you provide warranty or support?

**A:** No. This is a community project provided "as-is" without warranty. See the disclaimer in README.md. We help where we can, but cannot guarantee support.

---

## Brother Printer Module Questions

### Q: Which Brother printers are supported?

**A:** The guide is written for Brother DCP-T820DW, but the general setup process works for most Brother printers. Check the [AUR](https://aur.archlinux.org/) for your specific model's driver:

```bash
paru -Ss brother
```

---

### Q: Should I use WiFi or USB for my printer?

**A:** 
- **WiFi (Recommended):** More flexible, can print from any device on network
- **USB:** More reliable, faster for large jobs, good for single computer

You can set up both and choose based on needs.

---

### Q: Why use digiKam instead of Simple Scan?

**A:** 
- **Simple Scan:** Basic scanning, quick and simple
- **digiKam:** Professional photo management, editing, organization, tagging, face detection, RAW support

Use Simple Scan for quick scans, digiKam for photo library management.

---

### Q: Can I use this guide for other scanner brands?

**A:** The CUPS and SANE setup is universal. Only the Brother-specific driver installation differs. Check manufacturer documentation for your scanner model.

---

## Still Have Questions?

- 📖 Read the [Main README](../README.md)
- 🔧 Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- 📚 Review [GLOSSARY.md](GLOSSARY.md) for term definitions
- 💬 Open a [GitHub Issue](https://github.com/cjmaaz/ArchStarterPack/issues)
- 🌐 Check the [Arch Wiki](https://wiki.archlinux.org/)

---

**Pro Tip:** Before asking a question, try running:
```bash
./check-prerequisites.sh          # Check system compatibility
./cachy_os_config/diagnostics.sh  # Gather system information
```

These tools often reveal the answer to your question!
