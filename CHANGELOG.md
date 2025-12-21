# Changelog

All notable changes to ArchStarterPack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- **Pi-hole Network DNS Module** (`pi-hole/`) with quick start guide, router/DHCP wiring, and advanced docs for Unbound, IPv6-safe setup, and hardcoded DNS/DoH blocking.
- **Brother Printer Setup Module** - Complete guide for Brother DCP-T820DW
  - USB and WiFi network printing setup
  - Scanner configuration with SANE
  - digiKam photo management integration
  - Photo layouting and editing recommendations
  - Document management tools
  - Troubleshooting for printer and scanner issues
- **DRM and power diagnostics script** (`drm-power-diagnostics.sh`) - Specialized DRM/power/USB troubleshooting
  - DRM connector and EDID analysis
  - USB device and power management diagnostics
  - PCI graphics device information
  - TLP and runtime PM configuration
  - systemd/udev logs
  - Multiple organized output files
  - Command visibility for transparency
  - `--redact` flag to mask personal information (IPs, MACs, hostnames, serials, SSIDs, UUIDs)
- **TLP custom configuration example** (`01-custom.conf`) with hardware detection instructions
- Comprehensive FAQ document
- Troubleshooting guide with solutions to common issues
- Glossary of technical terms
- GRUB kernel parameters detailed explanation guide
- Prerequisites checker script (`check-prerequisites.sh`)
- System diagnostics script (`diagnostics.sh`) with command visibility
- Backup and rollback instructions in all guides
- Enhanced inline comments in configuration files
- Difficulty level and time estimates for each module
- GitHub issue and PR templates
- Learning resources document with curated materials

### Changed

- Renamed `asus_x_507_uf_nvidia_depricated.md` to `asus_x_507_uf_nvidia_deprecated.md` (fixed typo)
- Added deprecation warning banner to external monitor-only NVIDIA guide
- Updated main README with proper section anchors and links
- Fixed `gksudo` → `sudo` in CachyOS configuration guide (gksudo is deprecated)
- Enhanced NVM Fish functions with detailed comments
- Improved LogiOps configuration with comprehensive CID explanations
- Added metadata (Last Updated, Difficulty, Time Required) to major guides

### Fixed

- Broken table of contents links in main README
- Missing rollback instructions in NVIDIA configuration guide
- Incomplete troubleshooting steps in deprecated NVIDIA guide

---

## [1.0.0] - 2025-11-28

### Added

- Initial release
- CachyOS performance and power optimization guide for ASUS X507UF
- External monitor-only NVIDIA Optimus configuration guide
- Hardware diagnostics toolkit documentation with privacy redaction feature
- Optional diagnostics extensions guide
- GRUB configuration file with optimized kernel parameters
- LogiOps setup guide and MX Master 3S configuration
- Minimal NVM setup for Fish shell (no fisher/bass dependencies)
- Comprehensive README with module descriptions
- Project structure documentation
- Privacy-focused diagnostic scripts with `--redact` flag

### Hardware Support

- ASUS X507UF (Intel i5-8250U + Intel UHD 620 + NVIDIA MX130)
- Logitech MX Master 3S mouse
- Generic Arch-based system optimization

### Configurations

- TLP for AC/battery power management
- thermald for thermal management
- Intel P-State CPU governor optimization
- NVIDIA dynamic power management for Optimus
- Intel GuC/HuC firmware loading
- SmartShift and gesture configuration for Logitech mice
- Fish shell NVM integration

---

## Version History

- **1.0.0** (2025-11-28): Initial public release
- **Unreleased**: Major documentation improvements and tooling additions

---

## How to Read This Changelog

- **Added**: New features, files, or functionality
- **Changed**: Changes to existing features or documentation
- **Deprecated**: Features that will be removed in future versions
- **Removed**: Features that have been removed
- **Fixed**: Bug fixes and corrections
- **Security**: Security-related changes

---

## Future Plans

### Planned for Next Release

- Learning resources document with curated educational materials
- Quick start guide for absolute beginners
- Alternative configuration examples for different use cases
- Validation scripts for configuration testing
- System health check script

### Under Consideration

- Support for additional hardware models
- Configurations for other desktop environments
- Additional peripheral configurations
- Automated installation script
- Video tutorials

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this project and help expand the changelog.
