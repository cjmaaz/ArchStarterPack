# Optional Diagnostics Extensions

This document describes optional advanced diagnostics modules that can be integrated into the `diagnostics.sh` toolkit. These modules extend system inspection capability and provide deeper insights into GPU, storage, network, display server, and overall system health.

**Note:** The main `diagnostics.sh` script now displays each command before executing it, making it easier to understand what information is being gathered and learn useful diagnostic commands.

## What Are Optional Diagnostics?

### Why Optional Diagnostics Exist

**The problem:** Standard diagnostics cover basic system information, but sometimes you need deeper insights into specific subsystems.

**Why optional:**

- **Not always needed:** Most users don't need advanced diagnostics
- **Specialized:** Focus on specific subsystems (GPU, storage, network)
- **Advanced:** Require additional tools or knowledge
- **Extendable:** Can be added to main diagnostics script if needed

### What Optional Diagnostics Provide

**1. Deeper Insights:**

- More detailed information about specific subsystems
- Advanced troubleshooting capabilities
- Performance analysis

**2. Specialized Tools:**

- GPU-specific diagnostics (Vulkan, OpenGL)
- Storage health analysis (SMART)
- Network performance testing
- Display server logs

**3. Extended Coverage:**

- Areas not covered by standard diagnostics
- Advanced troubleshooting scenarios
- Performance optimization insights

### When to Use Optional Diagnostics

**1. Advanced Troubleshooting:**

- Standard diagnostics didn't find the issue
- Need deeper analysis of specific subsystem
- Performance optimization needed

**2. Specific Problems:**

- GPU performance issues → Use Vulkan/OpenGL diagnostics
- Storage problems → Use SMART diagnostics
- Network issues → Use network diagnostics

**3. System Optimization:**

- Want to optimize specific subsystem
- Need performance analysis
- Want to identify bottlenecks

---

## 1. Auto-Upload Output to Pastebin

### What It Does

Automatically uploads the diagnostics log to a paste service (e.g., paste.rs) for easy sharing.

### Why It Exists

**The problem:** Sharing large diagnostic logs is difficult (email, messaging, etc.)

**Why it's useful:**

- **Easy sharing:** Get shareable URL instantly
- **No file transfer:** No need to manually upload files
- **Quick support:** Share logs quickly for troubleshooting
- **Convenience:** Automated, no manual steps

### How It Works

**Step-by-step:**

1. Diagnostics script generates output file
2. Script uploads file to paste service (paste.rs)
3. Paste service returns shareable URL
4. URL can be shared for support/troubleshooting

**Example:**

```bash
curl -F "file=@${OUTPUT_FILE}" https://paste.rs
```

**What this does:**

- **`curl`:** Command-line tool for HTTP requests
- **`-F "file=@${OUTPUT_FILE}"`:** Upload file as form data
- **`https://paste.rs`:** Paste service URL
- **Result:** Returns shareable URL

### When to Use

**Use when:**

- **Need to share logs:** Sharing diagnostics with support/community
- **Quick troubleshooting:** Want instant shareable link
- **Automated workflow:** Want automatic upload after diagnostics

**Don't use when:**

- **Privacy concerns:** Logs contain sensitive information
- **Offline:** No internet connection
- **Small logs:** Can share directly (email, messaging)

### Integration Example

**Add to diagnostics.sh:**

```bash
# After diagnostics complete
if [ "$AUTO_UPLOAD" = "1" ]; then
    echo "[+] Uploading diagnostics to paste.rs..."
    URL=$(curl -F "file=@${OUTPUT_FILE}" https://paste.rs)
    echo "[✓] Diagnostics uploaded: $URL"
fi
```

**Usage:**

```bash
AUTO_UPLOAD=1 ./diagnostics.sh
```

---

## 2. Auto-Detect NVIDIA dmesg Errors

### What It Does

Scans kernel messages (`dmesg`) for NVIDIA-related errors and warnings.

### Why It Exists

**The problem:** NVIDIA driver issues can be buried in kernel logs, hard to find manually.

**Why it's useful:**

- **Quick detection:** Automatically finds NVIDIA-related errors
- **Early warning:** Detects issues before they cause problems
- **Troubleshooting:** Helps identify NVIDIA driver problems
- **Convenience:** No need to manually search logs

### How It Works

**Step-by-step:**

1. Read kernel messages from `dmesg`
2. Filter for NVIDIA-related keywords (`nvidia`, `nvkm`, `nouveau`)
3. Show last 200 lines (most recent messages)
4. Highlight errors and warnings

**Command:**

```bash
dmesg | grep -iE "nvidia|nvkm|nouveau" | tail -200
```

**What this does:**

- **`dmesg`:** Display kernel messages
- **`grep -iE "nvidia|nvkm|nouveau"`:** Filter for NVIDIA-related messages (case-insensitive)
- **`tail -200`:** Show last 200 lines (most recent)
- **Result:** NVIDIA-related kernel messages

### What to Look For

**Common NVIDIA errors:**

**Driver loading errors:**

- **`nvidia: module verification failed`:** Driver signature issue
- **`nvidia: Unknown symbol`:** Driver/kernel mismatch
- **Solution:** Update NVIDIA driver, ensure kernel headers match

**GPU initialization errors:**

- **`nvidia: GPU initialization failed`:** GPU not detected
- **`nvidia: Failed to initialize`:** Driver initialization problem
- **Solution:** Check GPU hardware, verify driver installation

**Power management errors:**

- **`nvidia: Power management failed`:** Power management issue
- **`nvidia: Runtime PM error`:** Runtime power management problem
- **Solution:** Check power management settings, update driver

**Display errors:**

- **`nvidia: Display initialization failed`:** Display not working
- **`nvidia: Modeset failed`:** Kernel mode setting issue
- **Solution:** Check display connections, verify KMS support

### When to Use

**Use when:**

- **NVIDIA GPU issues:** Display problems, driver errors
- **Performance problems:** GPU performance issues
- **Boot problems:** System won't boot, suspect NVIDIA driver
- **Regular monitoring:** Want to catch issues early

**Integration Example:**

**Add to diagnostics.sh:**

```bash
log "NVIDIA Kernel Messages (Errors)"
dmesg | grep -iE "nvidia|nvkm|nouveau" | grep -iE "error|fail|warn" | tail -50 | tee -a "$OUTPUT_FILE"
```

---

## 3. Vulkan/OpenGL Info Collection

### What It Does

Gathers detailed information about graphics API support (Vulkan and OpenGL).

### Why It Exists

**The problem:** Applications need to know what graphics APIs and features are available.

**Why it's useful:**

- **API support:** Verify Vulkan/OpenGL support
- **Feature detection:** Check available graphics features
- **Troubleshooting:** Identify graphics API issues
- **Compatibility:** Verify application compatibility

### How It Works

**Vulkan information:**

```bash
vulkaninfo | sed -n '1,200p'
```

**What this does:**

- **`vulkaninfo`:** Vulkan API information tool
- **Shows:** Vulkan version, device capabilities, extensions
- **`sed -n '1,200p'`:** Show first 200 lines (limit output)
- **Result:** Vulkan API and device information

**OpenGL information:**

```bash
glxinfo -B
```

**What this does:**

- **`glxinfo`:** OpenGL information tool
- **`-B`:** Brief output (essential information only)
- **Shows:** OpenGL version, renderer, vendor
- **Result:** OpenGL API information

### What Information It Provides

**Vulkan info:**

- **Vulkan version:** API version supported
- **Physical devices:** Available GPUs
- **Device capabilities:** GPU features and limits
- **Extensions:** Available Vulkan extensions

**OpenGL info:**

- **OpenGL version:** API version supported
- **Renderer:** GPU name and driver
- **Vendor:** GPU manufacturer
- **Extensions:** Available OpenGL extensions

### When to Use

**Use when:**

- **Graphics application issues:** Games, 3D apps not working
- **API compatibility:** Verify application requirements
- **Performance troubleshooting:** Check graphics API support
- **Driver verification:** Verify graphics driver functionality

### Real-World Example

**Problem:** Game won't start, says "Vulkan not supported"

**Diagnostic:**

```bash
vulkaninfo | head -20
# Output: (empty or error - Vulkan not available!)
```

**Problem identified:** Vulkan not supported or not installed

**Solution:** Install Vulkan drivers (`vulkan-intel`, `vulkan-nvidia`, etc.)

### Integration Example

**Add to diagnostics.sh:**

```bash
log "Vulkan Information"
if command -v vulkaninfo &> /dev/null; then
    vulkaninfo | sed -n '1,200p' | tee -a "$OUTPUT_FILE"
else
    echo "vulkaninfo not installed" | tee -a "$OUTPUT_FILE"
fi

log "OpenGL Information"
if command -v glxinfo &> /dev/null; then
    glxinfo -B | tee -a "$OUTPUT_FILE"
else
    echo "glxinfo not installed" | tee -a "$OUTPUT_FILE"
fi
```

---

## 4. Network Diagnostic Suite

### What It Does

Comprehensive network diagnostics including interfaces, routing, DNS, and performance testing.

### Why It Exists

**The problem:** Network issues require multiple diagnostic commands, scattered across different tools.

**Why it's useful:**

- **Complete picture:** All network information in one place
- **Troubleshooting:** Identify network configuration issues
- **Performance testing:** Measure network speed
- **Convenience:** Single command for all network diagnostics

### How It Works

**Network interfaces:**

```bash
ip a
```

**What this does:**

- **`ip a`:** Show all network interfaces
- **Shows:** Interface names, IP addresses, MAC addresses, status
- **Result:** Complete interface information

**Routing:**

```bash
ip r
```

**What this does:**

- **`ip r`:** Show routing table
- **Shows:** Routes, gateways, network destinations
- **Result:** Network routing information

**DNS:**

```bash
resolvectl status
```

**What this does:**

- **`resolvectl`:** systemd-resolved DNS status tool
- **Shows:** DNS servers, domains, DNS configuration
- **Result:** DNS resolver information

**Speedtest:**

```bash
speedtest-cli
```

**What this does:**

- **`speedtest-cli`:** Network speed testing tool
- **Shows:** Download/upload speeds, latency
- **Result:** Network performance metrics

### What Information It Provides

**Interfaces:**

- **Interface names:** `wlan0`, `eth0`, etc.
- **IP addresses:** IPv4 and IPv6 addresses
- **MAC addresses:** Hardware addresses
- **Status:** Up/down, connected/disconnected

**Routing:**

- **Default route:** Default gateway
- **Network routes:** Routes to specific networks
- **Gateway addresses:** Router IP addresses

**DNS:**

- **DNS servers:** Configured DNS servers
- **Domains:** Search domains
- **Resolver status:** DNS resolver state

**Speedtest:**

- **Download speed:** Mbps download speed
- **Upload speed:** Mbps upload speed
- **Latency:** Ping time to server

### When to Use

**Use when:**

- **Network connectivity issues:** Can't connect to network
- **Slow network:** Network performance problems
- **DNS problems:** Can't resolve domain names
- **Configuration verification:** Verify network settings

### Real-World Example

**Problem:** Can't connect to internet

**Diagnostic:**

```bash
ip a
# Output: wlan0: state DOWN (interface down)
ip r
# Output: (no default route)
```

**Problem identified:** Network interface down, no default route

**Solution:** Bring interface up, configure network

### Integration Example

**Add to diagnostics.sh:**

```bash
log "Network Interfaces"
ip a | tee -a "$OUTPUT_FILE"

log "Routing Table"
ip r | tee -a "$OUTPUT_FILE"

log "DNS Configuration"
resolvectl status 2>/dev/null || echo "systemd-resolved not available" | tee -a "$OUTPUT_FILE"

log "Network Speed Test"
if command -v speedtest-cli &> /dev/null; then
    speedtest-cli --simple | tee -a "$OUTPUT_FILE"
else
    echo "speedtest-cli not installed" | tee -a "$OUTPUT_FILE"
fi
```

---

## 5. SMART Disk Health Reports

### What It Does

Gathers SMART (Self-Monitoring, Analysis, and Reporting Technology) health information from storage devices.

### Why It Exists

**The problem:** Storage devices can fail without warning, losing data.

**Why it's useful:**

- **Early warning:** Detect storage problems before failure
- **Health monitoring:** Track storage device health over time
- **Data protection:** Identify failing drives before data loss
- **Preventive maintenance:** Replace drives before failure

### How It Works

**SMART information:**

```bash
sudo smartctl -a /dev/sda
sudo smartctl -a /dev/nvme0n1
```

**What this does:**

- **`smartctl`:** SMART disk health tool
- **`-a`:** Show all SMART information
- **`/dev/sda`:** SATA/IDE disk device
- **`/dev/nvme0n1`:** NVMe SSD device
- **Result:** Complete SMART health information

### What Information It Provides

**SMART attributes:**

- **Health status:** Overall drive health (PASS/FAIL)
- **Temperature:** Drive temperature
- **Power-on hours:** How long drive has been powered on
- **Reallocated sectors:** Bad sectors replaced with spare sectors
- **Read/write errors:** Error counts
- **Wear leveling:** SSD wear information (NVMe)

**Key indicators:**

**Health status:**

- **PASS:** Drive is healthy ✅
- **FAIL:** Drive is failing ❌
- **Action:** Replace failing drive immediately

**Reallocated sectors:**

- **Low count:** Normal (some sectors fail over time)
- **High count:** Drive failing (many bad sectors)
- **Action:** Monitor, consider replacing drive

**Temperature:**

- **Normal:** 30-50°C (cool)
- **Warm:** 50-60°C (acceptable)
- **Hot:** >60°C (may cause issues)
- **Action:** Improve cooling if too hot

### When to Use

**Use when:**

- **Storage problems:** Slow disk, errors, crashes
- **Regular monitoring:** Check drive health periodically
- **Before data loss:** Detect problems early
- **Performance issues:** Slow disk performance

### Real-World Example

**Problem:** System crashes, suspect failing disk

**Diagnostic:**

```bash
sudo smartctl -a /dev/sda
# Output:
# SMART overall-health self-assessment test result: FAILED!
# Reallocated_Sector_Ct: 5000 (high - drive failing!)
```

**Problem identified:** Drive failing, many reallocated sectors

**Solution:** Backup data immediately, replace drive

### Integration Example

**Add to diagnostics.sh:**

```bash
log "SMART Disk Health (SATA/IDE)"
for disk in /dev/sd[a-z] /dev/hd[a-z]; do
    if [ -b "$disk" ]; then
        echo "--- $disk ---" | tee -a "$OUTPUT_FILE"
        sudo smartctl -a "$disk" 2>/dev/null | tee -a "$OUTPUT_FILE"
    fi
done

log "SMART Disk Health (NVMe)"
for disk in /dev/nvme[0-9]n[0-9]; do
    if [ -b "$disk" ]; then
        echo "--- $disk ---" | tee -a "$OUTPUT_FILE"
        sudo smartctl -a "$disk" 2>/dev/null | tee -a "$OUTPUT_FILE"
    fi
done
```

---

## 6. System Health Scoring

Simple scoring based on:

- Temps
- Disk health
- GPU driver load
- Kernel errors
- Battery condition

Script computes weighted score from 0–100.

---

## 7. Arch PKGBUILD (Optional Packaging)

PKGBUILD skeleton to package diagnostics toolkit into Arch package.

---

## 8. Wayland/X11 Logs

### Wayland:

```
journalctl --user -u pipewire -b
journalctl --user -u xdg-desktop-portal -b
```

### X11:

```
cat ~/.local/share/xorg/Xorg.0.log
```
