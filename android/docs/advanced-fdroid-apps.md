# Advanced F-Droid Apps Guide

**Goal:** Comprehensive guide to advanced F-Droid apps useful for Android privacy, security, networking, and system management.

## What This Guide Covers

### Definition

**Advanced F-Droid apps** are free and open-source Android applications that provide advanced functionality for privacy, security, networking, and system management beyond basic Android features.

### Why This Guide Exists

**The problem:** Many powerful privacy and security tools exist in F-Droid, but finding and understanding them can be challenging.

**The solution:** This guide provides:

- **Curated selection:** Hand-picked advanced apps
- **Usage instructions:** Step-by-step guides for each app
- **Use cases:** Real-world scenarios for each tool
- **Integration:** How apps work together

**Real-world analogy:**

- **Basic apps = Standard tools** (calculator, notes)
- **Advanced apps = Power tools** (network analyzers, firewalls, privacy tools)

### How to Use This Guide

**Reading path:**

1. **Start here:** Read this introduction
2. **Choose category:** Select category relevant to your needs
3. **Read app entry:** Learn about specific app
4. **Install and use:** Follow installation and usage instructions
5. **Combine tools:** Use multiple apps together for comprehensive protection

**Categories:**

- **Network Monitoring & Analysis:** Tools for analyzing network traffic
- **Firewall & Network Control:** Tools for controlling network access
- **VPN & Proxy Tools:** Tools for secure connections
- **System Tools & Utilities:** Tools for system management

---

## Prerequisites

### What You Need Before Starting

**1. F-Droid Installed**

- F-Droid app installed on your Android device
- Download from [f-droid.org](https://f-droid.org/)

**2. IzzyOnDroid Repository (For Some Apps)**

- Required for PCAPdroid MITM addon and some advanced tools
- See [`fdroid-setup.md`](fdroid-setup.md) for setup instructions

**3. Android Device**

- Android 5.0+ (varies by app)
- Internet connection for app installation
- Storage space for apps

**4. Basic Knowledge**

- Understanding of Android app installation
- Basic networking concepts (helpful but not required)
- Privacy awareness (understanding why these tools matter)

---

## Network Monitoring & Analysis

### PCAPdroid

**What it is:** A privacy-friendly, no-root network monitor and traffic dump tool that logs connections and can export PCAP files for analysis.

**Why it exists:**

- **Privacy concerns:** Users want to see what apps are doing
- **Network debugging:** Developers need to debug network issues
- **Security analysis:** Security researchers need traffic analysis
- **No root required:** Works without root access

**How it works:**

- **VPN service:** Uses Android VPNService to intercept traffic
- **Local processing:** All data processed locally on device
- **Connection logging:** Logs all network connections
- **PCAP export:** Exports traffic dumps for analysis

**Features:**

- **Connection logging:** Logs all network connections made by apps
- **App attribution:** Shows which app made each connection
- **PCAP export:** Export traffic dumps for analysis in Wireshark
- **TLS decryption:** Decrypt HTTPS/TLS traffic with MITM addon
- **Filtering:** Filter connections by app, domain, protocol
- **Real-time monitoring:** Monitor connections in real-time
- **Country/ASN lookup:** Identify country and ASN of remote servers

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install PCAPdroid:** Search for "PCAPdroid" in F-Droid
3. **Install from F-Droid:** [PCAPdroid](https://f-droid.org/en/packages/com.emanuelef.remote_capture/)
4. **For TLS decryption:** Install PCAPdroid MITM addon from IzzyOnDroid repo (see [`fdroid-setup.md`](fdroid-setup.md))

**Basic Usage:**

1. **Launch app:** Open PCAPdroid
2. **Grant VPN permission:** Allow VPN permission when prompted
3. **Start capture:** Tap play button to start capturing
4. **View connections:** Browse connections in "Connections" tab
5. **Filter connections:** Use search/filter to find specific connections
6. **Export PCAP:** Stop capture and export PCAP file

**Advanced Usage - TLS Decryption:**

1. **Install MITM addon:** Install PCAPdroid MITM from IzzyOnDroid repo
2. **Enable TLS decryption:** Settings → Traffic inspection → TLS decryption
3. **Install certificate:** Follow setup wizard to install CA certificate
4. **Create decryption rules:** Define which apps/domains to decrypt
5. **Start capture:** Start capture with TLS decryption enabled
6. **View decrypted traffic:** See decrypted HTTP/HTTPS content

**Use Cases:**

- **Telemetry investigation:** See which apps connect to which domains
- **Traffic analysis:** Analyze network behavior of apps
- **Debugging:** Troubleshoot network issues
- **Privacy audit:** Check what data apps are sending
- **Security research:** Analyze app security

**Real-world Example:**

**Scenario:** Investigating telemetry from OPPO device

1. **Start PCAPdroid:** Launch app and start capture
2. **Use device normally:** Use phone for a few minutes
3. **Filter connections:** Search for "allawnos.com" in connections
4. **Find app:** See which app is connecting to allawnos.com
5. **Export PCAP:** Export PCAP file for detailed analysis
6. **Use TLS decryption:** Enable TLS decryption to see encrypted content

**Limitations:**

- **No root mode:** Only captures outgoing connections
- **Packet modifications:** May modify packet headers in non-root mode
- **Certificate pinning:** Some apps use certificate pinning (can't decrypt)
- **QUIC:** QUIC traffic not decryptable yet

**Links:**

- **Official website:** [emanuele-f.github.io/PCAPdroid](https://emanuele-f.github.io/PCAPdroid/)
- **GitHub:** [github.com/emanuele-f/PCAPdroid](https://github.com/emanuele-f/PCAPdroid)
- **F-Droid:** [f-droid.org/packages/com.emanuelef.remote_capture](https://f-droid.org/packages/com.emanuelef.remote_capture)

---

### PCAPdroid MITM

**What it is:** An addon for PCAPdroid that enables TLS/HTTPS decryption using mitmproxy.

**Why it exists:**

- **Encrypted traffic:** Most apps use HTTPS/TLS encryption
- **Privacy analysis:** Users want to see encrypted content
- **Security research:** Researchers need to analyze encrypted traffic
- **Debugging:** Developers need to debug encrypted connections

**How it works:**

- **Man-in-the-middle proxy:** Intercepts TLS connections
- **Certificate generation:** Generates CA certificate for device
- **Certificate installation:** Installs certificate in Android certificate store
- **Traffic decryption:** Decrypts TLS traffic using mitmproxy

**Features:**

- **TLS decryption:** Decrypt HTTPS/TLS traffic
- **HTTP inspection:** View HTTP requests and responses
- **SSLKEYLOGFILE export:** Export decryption keys for Wireshark
- **Custom rules:** Define which apps/domains to decrypt
- **Certificate management:** Manage CA certificate installation

**Installation:**

1. **Install IzzyOnDroid repo:** See [`fdroid-setup.md`](fdroid-setup.md)
2. **Install PCAPdroid:** Install PCAPdroid from F-Droid
3. **Install MITM addon:** Search for "PCAPdroid MITM" in F-Droid (IzzyOnDroid repo)
4. **Install from IzzyOnDroid:** [PCAPdroid MITM](https://apt.izzysoft.de/fdroid/index/apk/com.pcapdroid.mitm)

**Setup:**

1. **Enable TLS decryption:** PCAPdroid Settings → Traffic inspection → TLS decryption
2. **Setup wizard:** Follow setup wizard to install MITM addon
3. **Install certificate:** Install PCAPdroid CA certificate in Android settings
4. **Grant permissions:** Grant PCAPdroid permission to control MITM addon
5. **Create decryption rules:** Define which apps/domains to decrypt

**Usage:**

1. **Create decryption rule:** Long-press connection → Select decryption criteria
2. **Start capture:** Start PCAPdroid capture
3. **Use app:** Use target app normally
4. **View decrypted traffic:** See decrypted HTTP/HTTPS content
5. **Export keys:** Export SSLKEYLOGFILE for Wireshark analysis

**Use Cases:**

- **Privacy analysis:** See what encrypted data apps are sending
- **Security research:** Analyze encrypted app communications
- **Debugging:** Debug encrypted API calls
- **Telemetry investigation:** Decrypt telemetry traffic

**Real-world Example:**

**Scenario:** Decrypting telemetry traffic from vendor app

1. **Enable TLS decryption:** Enable in PCAPdroid settings
2. **Install certificate:** Install CA certificate
3. **Create rule:** Create decryption rule for target app
4. **Start capture:** Start PCAPdroid capture
5. **Use app:** Use vendor app normally
6. **View decrypted:** See decrypted telemetry data in PCAPdroid

**Limitations:**

- **Certificate pinning:** Apps with certificate pinning can't be decrypted
- **Root required:** Some apps require root for decryption
- **QUIC:** QUIC traffic not supported yet
- **STARTTLS:** STARTTLS not supported yet

**Troubleshooting:**

- **Decryption fails:** Check certificate installation, try root methods
- **App stops working:** Some apps detect MITM and stop working
- **Certificate errors:** Reinstall certificate, check Android version
- **Root methods:** See PCAPdroid docs for root-based solutions

**Links:**

- **GitHub:** [github.com/emanuele-f/PCAPdroid-mitm](https://github.com/emanuele-f/PCAPdroid-mitm)
- **IzzyOnDroid:** [apt.izzysoft.de/fdroid/index/apk/com.pcapdroid.mitm](https://apt.izzysoft.de/fdroid/index/apk/com.pcapdroid.mitm)
- **PCAPdroid docs:** [emanuele-f.github.io/PCAPdroid/tls_decryption](https://emanuele-f.github.io/PCAPdroid/tls_decryption.html)

---

### TrackerControl

**What it is:** An app that monitors and controls hidden data collection (tracking) in mobile apps.

**Why it exists:**

- **Privacy concerns:** Apps collect data without user knowledge
- **GDPR compliance:** Users have right to control data collection
- **Transparency:** Users want to know what trackers apps use
- **Selective blocking:** Users want to block specific trackers

**How it works:**

- **VPN service:** Uses Android VPNService to intercept traffic
- **Tracker detection:** Matches domains against tracker blocklists
- **Company attribution:** Identifies companies behind trackers
- **Selective blocking:** Blocks trackers per app

**Features:**

- **Tracker detection:** Identifies tracking domains using Disconnect blocklist and in-house analysis
- **Selective blocking:** Block tracking selectively per app
- **GDPR information:** Educates about data protection rights
- **Company attribution:** Shows which companies are behind tracking
- **Purpose identification:** Identifies tracking purposes (analytics, advertising, etc.)
- **Real-time monitoring:** Monitor tracker activity in real-time

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install TrackerControl:** Search for "TrackerControl" in F-Droid
3. **Install from F-Droid:** [TrackerControl](https://f-droid.org/packages/net.kollnig.missioncontrol.fdroid/)

**Usage:**

1. **Launch app:** Open TrackerControl
2. **Enable VPN:** Grant VPN permission when prompted
3. **Browse apps:** Browse installed apps to see tracker information
4. **Configure blocking:** Configure blocking rules per app
5. **Monitor activity:** Monitor tracker activity in real-time
6. **Export data:** Export tracker data for analysis

**Use Cases:**

- **Privacy audit:** See which apps use trackers
- **Tracker blocking:** Prevent data collection
- **Research:** Analyze tracking practices
- **GDPR compliance:** Understand data protection rights

**Real-world Example:**

**Scenario:** Auditing tracking in social media apps

1. **Enable TrackerControl:** Launch app and enable VPN
2. **Browse apps:** Find social media app in list
3. **View trackers:** See list of trackers used by app
4. **Check companies:** See which companies are tracking
5. **Block trackers:** Configure blocking rules
6. **Monitor:** Monitor blocked tracker attempts

**Limitations:**

- **VPN required:** Uses VPN slot (can't use other VPNs)
- **System apps:** System app analysis disabled by default
- **Certificate pinning:** Some trackers use certificate pinning

**Links:**

- **Official website:** [trackercontrol.org](https://trackercontrol.org/)
- **GitHub:** [github.com/TrackerControl/tracker-control-android](https://github.com/TrackerControl/tracker-control-android)
- **F-Droid:** [f-droid.org/packages/net.kollnig.missioncontrol.fdroid](https://f-droid.org/packages/net.kollnig.missioncontrol.fdroid)

---

## Firewall & Network Control

### NetGuard

**What it is:** A simple, no-root firewall that blocks internet access per application.

**Why it exists:**

- **Data saving:** Users want to control mobile data usage
- **Privacy:** Users want to prevent apps from connecting
- **Battery optimization:** Reduce background network activity
- **Firewall control:** Fine-grained network control

**How it works:**

- **VPN service:** Uses Android VPNService to intercept traffic
- **Per-app rules:** Creates rules for each app
- **Traffic filtering:** Filters traffic based on rules
- **Logging:** Logs traffic for analysis (PRO feature)

**Features:**

- **Per-app blocking:** Block apps from accessing WiFi and/or mobile data
- **Traffic logging:** Log all outgoing traffic (PRO feature)
- **Per-address rules:** Allow/block individual addresses per app (PRO)
- **PCAP export:** Export PCAP files for analysis (PRO)
- **No root required:** Works without root access
- **IPv4/IPv6 support:** Supports both IPv4 and IPv6

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install NetGuard:** Search for "NetGuard" in F-Droid
3. **Install from F-Droid:** [NetGuard](https://f-droid.org/packages/eu.faircode.netguard/)

**Usage:**

1. **Launch app:** Open NetGuard
2. **Enable VPN:** Grant VPN permission when prompted
3. **Configure rules:** Configure app rules (allow/block WiFi/mobile)
4. **Enable logging:** Enable traffic logging if needed (PRO)
5. **Monitor traffic:** Monitor network activity
6. **Export logs:** Export PCAP files for analysis (PRO)

**Use Cases:**

- **Data management:** Control which apps use mobile data
- **Privacy:** Block apps from internet access
- **Battery saving:** Reduce background network activity
- **Traffic analysis:** Log and analyze app connections

**Real-world Example:**

**Scenario:** Blocking telemetry apps from internet

1. **Enable NetGuard:** Launch app and enable VPN
2. **Find app:** Find telemetry app in list
3. **Block WiFi:** Block app from WiFi access
4. **Block mobile:** Block app from mobile data access
5. **Verify:** Verify app can't connect to internet
6. **Monitor:** Monitor blocked connection attempts

**Limitations:**

- **VPN required:** Uses VPN slot (can't use other VPNs)
- **PRO features:** Some features require PRO version
- **System apps:** System apps may bypass firewall

**Links:**

- **Official website:** [netguard.me](https://www.netguard.me/)
- **GitHub:** [github.com/M66B/NetGuard](https://github.com/M66B/NetGuard)
- **F-Droid:** [f-droid.org/packages/eu.faircode.netguard](https://f-droid.org/packages/eu.faircode.netguard)

---

### RethinkDNS

**What it is:** A comprehensive DNS + Firewall + VPN solution for Android.

**Why it exists:**

- **All-in-one:** Users want DNS, firewall, and VPN in one app
- **Privacy:** Users want encrypted DNS and firewall control
- **Security:** Users want malware blocking
- **Censorship:** Users want to bypass DNS-based censorship

**How it works:**

- **DNS server:** Uses custom DNS servers (300+ locations)
- **Firewall:** Blocks apps from internet access
- **WireGuard VPN:** Provides secure VPN connections
- **Malware blocking:** Blocks malicious domains

**Features:**

- **DNS customization:** Use custom DNS servers (300+ locations worldwide)
- **Firewall:** Block apps from internet access
- **WireGuard VPN:** Secure VPN connections
- **Malware blocking:** Block malicious domains
- **Traffic monitoring:** Monitor network activity
- **Data monitoring:** Track per-app data usage

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install RethinkDNS:** Search for "RethinkDNS" in F-Droid
3. **Install from F-Droid:** [RethinkDNS](https://f-droid.org/packages/com.celzero.bravedns/)

**Usage:**

1. **Launch app:** Open RethinkDNS
2. **Configure DNS:** Select DNS servers
3. **Set up firewall:** Configure firewall rules
4. **Configure VPN:** Set up WireGuard VPN if needed
5. **Enable protection:** Enable DNS, firewall, and VPN
6. **Monitor:** Monitor network activity

**Use Cases:**

- **Comprehensive network security:** DNS + firewall + VPN
- **Censorship circumvention:** Bypass DNS blocking
- **Privacy protection:** Encrypt DNS and block trackers
- **Malware protection:** Block malicious domains

**Real-world Example:**

**Scenario:** Comprehensive network protection

1. **Configure DNS:** Select privacy-focused DNS servers
2. **Set firewall:** Block telemetry apps from internet
3. **Enable VPN:** Connect to WireGuard VPN
4. **Enable protection:** Enable all protection features
5. **Monitor:** Monitor network activity and blocked connections

**Limitations:**

- **VPN required:** Uses VPN slot (can't use other VPNs)
- **Complex setup:** More complex than single-purpose apps
- **Resource usage:** May use more battery than simpler apps

**Links:**

- **Official website:** [rethinkdns.com](https://rethinkdns.com/)
- **GitHub:** [github.com/celzero/rethink-app](https://github.com/celzero/rethink-app)
- **F-Droid:** [f-droid.org/packages/com.celzero.bravedns](https://f-droid.org/packages/com.celzero.bravedns)

---

### De1984

**What it is:** A privacy-focused firewall and package manager for Android devices.

**Why it exists:**

- **Advanced firewall:** Users want kernel-level firewall control
- **Package management:** Users want to manage system apps
- **Privacy:** Users want comprehensive privacy control
- **Multiple backends:** Users want flexibility in firewall methods

**How it works:**

- **Multiple backends:** Uses iptables (root), ConnectivityManager (Android 13+), or VPN fallback
- **Firewall rules:** Creates firewall rules per app
- **Package management:** Manages app installation/uninstallation
- **Automatic selection:** Automatically selects best firewall method

**Features:**

- **Multiple firewall backends:** iptables (root/Shizuku), ConnectivityManager (Android 13+), VPN fallback
- **Automatic selection:** Automatically selects best firewall method
- **Package management:** Enable/disable, uninstall apps (with Shizuku/root)
- **Per-app rules:** Block apps from WiFi, mobile data, roaming
- **Global policies:** "Block All by Default" or "Allow All by Default"
- **Screen-off blocking:** Block apps when screen is off

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install De1984:** Search for "De1984" in F-Droid
3. **Install from F-Droid:** [De1984](https://f-droid.org/packages/io.github.dorumrr.de1984/)

**Requirements:**

- **Android 8.0+:** Requires Android 8.0 (API 26) or higher
- **For iptables:** Root access OR Shizuku in root mode
- **For ConnectivityManager:** Shizuku + Android 13+
- **For VPN:** VPN permission (no root required)

**Usage:**

1. **Launch app:** Open De1984
2. **Grant permissions:** Grant Shizuku/root permissions if available
3. **Configure firewall:** Configure firewall rules per app
4. **Manage packages:** Enable/disable or uninstall apps
5. **Set policies:** Configure global firewall policies
6. **Monitor:** Monitor firewall activity

**Use Cases:**

- **Advanced firewall control:** Kernel-level firewall with iptables
- **System app management:** Manage system apps without root
- **Privacy protection:** Comprehensive firewall control
- **Battery optimization:** Block apps when screen is off

**Real-world Example:**

**Scenario:** Advanced firewall with package management

1. **Grant Shizuku:** Grant Shizuku permissions
2. **Configure firewall:** Set up firewall rules for apps
3. **Block telemetry:** Block telemetry apps from internet
4. **Manage packages:** Disable unwanted system apps
5. **Set policies:** Configure "Block All by Default" policy
6. **Monitor:** Monitor blocked connections

**Limitations:**

- **Root/Shizuku:** Full features require root or Shizuku
- **Android version:** Some features require Android 13+
- **Complex setup:** More complex than simpler firewalls

**Links:**

- **GitHub:** [github.com/dorumrr/de1984](https://github.com/dorumrr/de1984)
- **F-Droid:** [f-droid.org/packages/io.github.dorumrr.de1984](https://f-droid.org/packages/io.github.dorumrr.de1984)

---

## VPN & Proxy Tools

### Xray

**What it is:** A GUI client for XTLS/Xray-core proxy protocol.

**Why it exists:**

- **Censorship:** Users want to bypass internet censorship
- **Privacy:** Users want secure proxy connections
- **Multiple protocols:** Users want protocol flexibility
- **Advanced routing:** Users want advanced routing rules

**How it works:**

- **Xray-core:** Uses Xray-core proxy engine
- **Protocol support:** Supports multiple proxy protocols
- **GUI interface:** Provides user-friendly interface
- **Routing rules:** Advanced routing and rule configuration

**Features:**

- **Multiple protocols:** Supports various proxy protocols
- **GUI interface:** User-friendly configuration interface
- **Advanced routing:** Complex routing rules
- **Connection management:** Manage multiple proxy servers

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install Xray:** Search for "Xray" in F-Droid
3. **Install from F-Droid:** [Xray](https://f-droid.org/packages/io.github.saeeddev94.xray/)

**Usage:**

1. **Launch app:** Open Xray
2. **Configure server:** Add proxy server configuration
3. **Set routing:** Configure routing rules
4. **Connect:** Connect to proxy server
5. **Monitor:** Monitor connection status

**Use Cases:**

- **Censorship circumvention:** Bypass internet censorship
- **Secure connections:** Secure proxy connections
- **Protocol flexibility:** Use various proxy protocols
- **Advanced routing:** Complex routing requirements

**Limitations:**

- **Server required:** Requires proxy server configuration
- **Technical knowledge:** Requires understanding of proxy protocols
- **Android 8.0+:** Requires Android 8.0 or higher

**Links:**

- **GitHub:** [github.com/SaeedDev94/Xray](https://github.com/SaeedDev94/Xray)
- **F-Droid:** [f-droid.org/packages/io.github.saeeddev94.xray](https://f-droid.org/packages/io.github.saeeddev94.xray)

---

### Calyx VPN

**What it is:** A free VPN service provided by The Calyx Institute.

**Why it exists:**

- **Free VPN:** Users want free VPN service
- **Privacy:** Users want anonymous VPN without logging
- **Open source:** Users want open-source VPN client
- **No accounts:** Users want VPN without user accounts

**How it works:**

- **WireGuard:** Uses WireGuard VPN protocol
- **No logging:** No user logging or data collection
- **Anonymous:** Provides anonymous IP addresses
- **Free service:** Completely free VPN service

**Features:**

- **Anonymous VPN:** No user accounts and no logging
- **Anonymous IP:** Anonymous IP addresses when connected
- **Free:** Completely free service
- **Open source:** 100% open-source client and server
- **No IPv6 leaks:** Prevents IPv6 leaks (requires root)
- **No DNS leaks:** Prevents DNS leaks

**Installation:**

1. **Install F-Droid:** Download from [f-droid.org](https://f-droid.org/)
2. **Install Calyx VPN:** Search for "Calyx VPN" in F-Droid
3. **Install from F-Droid:** [Calyx VPN](https://f-droid.org/packages/org.calyxinstitute.vpn/)

**Usage:**

1. **Launch app:** Open Calyx VPN
2. **Connect:** Tap connect button
3. **Wait for connection:** Wait for VPN connection to establish
4. **Verify:** Verify connection status
5. **Use internet:** Use internet through VPN

**Use Cases:**

- **Privacy protection:** Anonymous browsing
- **Secure connections:** Encrypt internet traffic
- **Free VPN:** Free VPN service
- **Open source:** Open-source VPN solution

**Limitations:**

- **Service dependency:** Depends on Calyx Institute service
- **Performance:** May have performance limitations
- **IPv6 leaks:** Requires root to prevent IPv6 leaks

**Links:**

- **Official website:** [calyxinstitute.org](https://calyxinstitute.org/)
- **F-Droid:** [f-droid.org/packages/org.calyxinstitute.vpn](https://f-droid.org/packages/org.calyxinstitute.vpn)

---

## System Tools & Utilities

### ADB Tools

**What they are:** Various ADB (Android Debug Bridge) utilities for Android device management without a computer.

**Why they exist:**

- **No computer:** Users want ADB functionality without computer
- **Device management:** Users want to manage devices directly
- **Debugging:** Users want debugging capabilities on device
- **Automation:** Users want to automate ADB operations

**Available Apps:**

- **ADB Clipboard:** Read/write Android clipboard using ADB
- **ADB Over Network:** Simple switch for ADB over network
- **ADB over WiFi:** Toggle ADB between USB and WiFi mode
- **ADB⚡OTG:** Run ADB commands without computer (no root needed)

**Installation:**

1. **Install F-Droid/IzzyOnDroid:** Some apps require IzzyOnDroid repo
2. **Search for app:** Search for specific ADB tool
3. **Install:** Install app from F-Droid or IzzyOnDroid

**Usage:**

- **ADB Clipboard:** Copy/paste clipboard content via ADB
- **ADB Over Network:** Enable ADB over network connection
- **ADB over WiFi:** Switch ADB to WiFi mode
- **ADB⚡OTG:** Run ADB commands directly on device

**Use Cases:**

- **Device management:** Manage Android device without computer
- **Debugging:** Debug apps directly on device
- **Automation:** Automate ADB operations
- **Clipboard access:** Access clipboard via ADB

**Links:**

- **F-Droid/IzzyOnDroid:** Search for specific ADB tool in F-Droid

---

## Best Practices

### Choosing the Right Tool

**Considerations:**

- **Purpose:** What do you want to achieve?
- **Root access:** Do you have root access?
- **Android version:** What Android version are you running?
- **Performance:** How much performance impact is acceptable?
- **Complexity:** How complex are you willing to configure?

**Tool Selection Guide:**

- **Network monitoring:** PCAPdroid (with MITM for TLS decryption)
- **Tracker blocking:** TrackerControl
- **Simple firewall:** NetGuard
- **Comprehensive solution:** RethinkDNS
- **Advanced firewall:** De1984 (with root/Shizuku)
- **VPN:** Calyx VPN or WireGuard
- **Proxy:** Xray

### Combining Tools Effectively

**Compatible combinations:**

- **PCAPdroid + TrackerControl:** Monitor and block trackers
- **NetGuard + RethinkDNS:** Firewall + DNS (use one at a time, both use VPN slot)
- **PCAPdroid + NetGuard:** Monitor and firewall (use one at a time)

**Incompatible combinations:**

- **Multiple VPN apps:** Can't run multiple VPN apps simultaneously
- **PCAPdroid + NetGuard:** Both use VPN slot (use one at a time)
- **TrackerControl + NetGuard:** Both use VPN slot (use one at a time)

**Best practices:**

- **Use one VPN app:** Only one VPN app can run at a time
- **Combine monitoring + blocking:** Use monitoring tool with blocking tool
- **Layer protection:** Use multiple non-VPN tools together
- **Test combinations:** Test tool combinations before relying on them

### Privacy Considerations

**What to consider:**

- **Data collection:** Do tools collect data?
- **Local processing:** Is data processed locally?
- **Open source:** Is source code available?
- **Permissions:** What permissions do tools request?

**Privacy best practices:**

- **Use open source:** Prefer open-source tools
- **Local processing:** Prefer tools that process data locally
- **Review permissions:** Review app permissions before installing
- **Check privacy policy:** Review privacy policies
- **Minimize data:** Use tools that minimize data collection

### Performance Impact

**What to expect:**

- **Battery usage:** VPN-based tools use more battery
- **CPU usage:** Traffic analysis uses CPU resources
- **Memory usage:** Logging uses memory
- **Network speed:** VPN may slow down network

**Optimization tips:**

- **Disable when not needed:** Disable tools when not in use
- **Limit logging:** Limit logging to reduce resource usage
- **Use efficient tools:** Use tools optimized for performance
- **Monitor resources:** Monitor battery and performance impact

### Troubleshooting Common Issues

**VPN conflicts:**

- **Problem:** Multiple VPN apps conflict
- **Solution:** Use only one VPN app at a time

**Certificate issues:**

- **Problem:** TLS decryption fails
- **Solution:** Reinstall certificate, check Android version

**Performance issues:**

- **Problem:** Battery drain or slow performance
- **Solution:** Disable tools when not needed, limit logging

**Connection issues:**

- **Problem:** Apps can't connect to internet
- **Solution:** Check firewall rules, verify VPN is working

---

## Related Documentation

**Setup guides:**

- **IzzyOnDroid setup:** [`fdroid-setup.md`](fdroid-setup.md)
- **ADB setup:** [`adb.md`](adb.md)

**Workflow guides:**

- **Investigation workflow:** [`investigation.md`](investigation.md)
- **Debloating guide:** [`../debloat.md`](../debloat.md)

**Main documentation:**

- **Android README:** [`../README.md`](../README.md)

---

## Summary

**What you learned:**

- **Advanced F-Droid apps:** Comprehensive guide to privacy and security tools
- **Network monitoring:** PCAPdroid, TrackerControl
- **Firewall tools:** NetGuard, RethinkDNS, De1984
- **VPN/Proxy tools:** Xray, Calyx VPN
- **System tools:** ADB utilities
- **Best practices:** Tool selection, combining tools, privacy, performance

**Key points:**

- ✅ **F-Droid required:** Install F-Droid for app access
- ✅ **IzzyOnDroid needed:** Some apps require IzzyOnDroid repository
- ✅ **VPN limitations:** Only one VPN app can run at a time
- ✅ **Privacy first:** Choose tools that respect privacy
- ✅ **Test combinations:** Test tool combinations before relying on them

**Next steps:**

1. **Set up IzzyOnDroid:** See [`fdroid-setup.md`](fdroid-setup.md)
2. **Install tools:** Install tools relevant to your needs
3. **Learn usage:** Follow usage guides for each tool
4. **Combine tools:** Use multiple tools together for comprehensive protection
