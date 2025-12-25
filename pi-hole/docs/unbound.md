# Pi-hole + Unbound (Local Recursive DNS)

**Goal:** Run a validating, recursive resolver locally so Pi-hole forwards to your own Unbound instance instead of third-party DNS. This keeps queries on your network and improves privacy.

## What Is Unbound?

### Definition

**Unbound** is a validating, recursive DNS resolver that performs DNS resolution locally on your network instead of forwarding queries to third-party DNS servers like Google (`8.8.8.8`) or Cloudflare (`1.1.1.1`).

### Why Unbound Exists

**The problem:** Using third-party DNS has privacy concerns:

- **Query visibility:** Third-party DNS sees all your DNS queries
- **Data collection:** DNS providers may collect and analyze your queries
- **Privacy risk:** Your browsing habits revealed to DNS provider
- **Trust required:** Must trust DNS provider with your queries

**The solution:** Unbound:

- **Local resolution:** Resolves DNS queries locally on your network
- **No third-party:** Doesn't send queries to external DNS providers
- **Privacy:** DNS queries never leave your network
- **Control:** You control DNS resolution completely

**Real-world analogy:**

- **Third-party DNS = Using public phone book** (others see what you look up)
- **Unbound = Having your own phone book** (private, no one sees your lookups)
- **Privacy:** Your DNS queries stay private
- **Control:** You control DNS resolution

### How Unbound Works

**Step-by-step process:**

1. **Pi-hole receives query:** Device asks Pi-hole "What is IP of example.com?"
2. **Pi-hole checks blocklist:** Pi-hole checks if domain is blocked (see [Blocklists and Whitelists Guide](blocklists-whitelists.md) for managing blocklists)
3. **If blocked:** Pi-hole returns `0.0.0.0` (blocked)
4. **If allowed:** Pi-hole forwards query to Unbound (not public DNS)
5. **Unbound resolves:** Unbound queries root servers, TLD servers, authoritative servers
6. **Unbound validates:** Unbound validates DNS responses using DNSSEC
7. **Unbound responds:** Unbound returns IP address to Pi-hole
8. **Pi-hole responds:** Pi-hole returns IP to device

**Key difference:**

- **Without Unbound:** Pi-hole → Public DNS (Google/Cloudflare) → Internet
- **With Unbound:** Pi-hole → Unbound → Root servers → Internet

**Privacy benefit:**

- **Without Unbound:** Public DNS sees your queries
- **With Unbound:** Only root servers see your queries (anonymized)

---

## Prerequisites (Recommended)

**Why these prerequisites matter:**

- **Networking basics:** Understand IP addressing, subnets, gateways
- **DNS model:** Understand how DNS resolution works
- **DNS tools:** Know how to test DNS queries

**Prerequisites:**

- **Networking basics (IP/subnet/gateway):** [`../../networking/docs/ip-addressing.md`](../../networking/docs/ip-addressing.md)

  - **Why needed:** Understand network addressing for Pi-hole/Unbound setup
  - **What to know:** IP addresses, subnets, gateways, how devices communicate

- **DNS model (recursion, caching):** [`../../networking/docs/dns.md`](../../networking/docs/dns.md)

  - **Why needed:** Understand DNS resolution process
  - **What to know:** How DNS queries work, recursion, caching, TTL

- **DNS tool:** [`../../shell-commands/02-commands/dig.md`](../../shell-commands/02-commands/dig.md)
  - **Why needed:** Test DNS queries and verify Unbound is working
  - **What to know:** How to use `dig` command, interpret output

---

## Flow (Detailed Explanation)

### Network Architecture

```mermaid
flowchart LR
    Clients[Clients]
    Router[Router<br/>DHCP]
    PiHole[Pi-hole<br/>DNS + Blocklists]
    Unbound[Unbound<br/>Local Recursive]
    Root[Root/Upstream]

    Clients -->|DHCP DNS = Pi-hole| Router --> PiHole
    PiHole -->|127.0.0.1:5335| Unbound --> Root
```

### Step-by-Step Flow

**1. Clients send DNS queries:**

**What happens:**

- **Device queries:** Device asks "What is IP of example.com?"
- **Router forwards:** Router forwards query to Pi-hole (DHCP DNS)
- **Pi-hole receives:** Pi-hole gets DNS query

**Networking context:** See [`../../networking/docs/dhcp.md`](../../networking/docs/dhcp.md) for DHCP explanation.

**2. Pi-hole checks blocklists:**

**What Pi-hole does:**

- **Blocklist check:** Pi-hole checks if domain is blocked
- **Decision:**
  - **Blocked:** Returns `0.0.0.0` (blocked, stops here)
  - **Allowed:** Forwards to Unbound (continues)

**Key point:** Pi-hole still enforces blocklists.

**Why this matters:**

- **Blocking first:** Blocklists checked before resolution
- **Privacy preserved:** Blocked domains never queried
- **Efficiency:** Don't waste time resolving blocked domains

**Learn more:** See [Blocklists and Whitelists Guide](blocklists-whitelists.md) for managing and enhancing your blocklists.

**3. Pi-hole forwards to Unbound:**

**What happens:**

- **Forward query:** Pi-hole sends query to Unbound
- **Address:** `127.0.0.1:5335` (localhost, port 5335)
- **Unbound receives:** Unbound gets query from Pi-hole

**Why localhost (`127.0.0.1`):**

- **Same machine:** Unbound runs on same Pi as Pi-hole
- **Localhost:** `127.0.0.1` is loopback address (same machine)
- **Port 5335:** Unbound listens on port 5335 (not standard port 53)

**Why port 5335:**

- **Avoid conflict:** Pi-hole uses port 53, Unbound uses 5335
- **Both can run:** Both services can run simultaneously
- **Pi-hole forwards:** Pi-hole forwards to Unbound on 5335

**4. Unbound resolves query:**

**What Unbound does:**

- **Recursive resolution:** Unbound performs full DNS resolution
- **Root servers:** Queries root DNS servers
- **TLD servers:** Queries top-level domain servers (.com, .org, etc.)
- **Authoritative servers:** Queries authoritative DNS servers
- **DNSSEC validation:** Validates DNS responses

**Key point:** Unbound resolves directly from root servers (or your ISP if you prefer custom forwarders).

**How recursive resolution works:**

1. **Query root:** "Who handles .com?"
2. **Root responds:** "Ask .com TLD servers"
3. **Query TLD:** "Who handles example.com?"
4. **TLD responds:** "Ask example.com authoritative servers"
5. **Query authoritative:** "What is IP of example.com?"
6. **Authoritative responds:** Returns IP address

**5. Unbound returns to Pi-hole:**

**What happens:**

- **IP received:** Unbound gets IP address
- **Validated:** DNSSEC validation performed
- **Response sent:** Unbound sends IP to Pi-hole
- **Pi-hole caches:** Pi-hole stores answer for future queries

**6. Pi-hole returns to client:**

**What happens:**

- **IP received:** Pi-hole gets IP from Unbound
- **Response sent:** Pi-hole sends IP to client
- **Client connects:** Device connects to website

**Key point:** Keep Unbound on the same Pi for simplicity.

**Why same Pi:**

- **Simplicity:** Easier to manage, one machine
- **Performance:** No network latency between Pi-hole and Unbound
- **Reliability:** Fewer moving parts, less to break
- **Resource usage:** Pi can handle both services easily

**Real-world example:**

**Query flow:**

1. **Client:** "What is IP of example.com?"
2. **Pi-hole:** Checks blocklist → Not blocked → Forwards to Unbound
3. **Unbound:** Queries root → TLD → Authoritative → Gets IP
4. **Unbound:** Validates DNSSEC → Returns IP to Pi-hole
5. **Pi-hole:** Caches IP → Returns IP to client
6. **Client:** Connects to example.com ✅

**Privacy benefit:**

- **Without Unbound:** Google DNS sees "example.com" query
- **With Unbound:** Only root servers see query (anonymized)
- **Privacy improved:** Your queries stay more private ✅

---

## Install & Configure (Pi-hole Host)

### Installation

**What this does:** Installs Unbound DNS resolver on the same Pi running Pi-hole.

**Install Unbound:**

```bash
sudo apt update
sudo apt install -y unbound
```

**Command breakdown:**

**`sudo apt update`:**

- **`sudo`:** Run as administrator
- **`apt`:** Advanced Package Tool (Debian package manager)
- **`update`:** Updates package list from repositories
- **Result:** Gets latest package information ✅

**Why needed:** Must update package list before installing packages.

**`sudo apt install -y unbound`:**

- **`apt install`:** Install package
- **`-y`:** Automatically answer "yes" to prompts
- **`unbound`:** Unbound DNS resolver package
- **Result:** Unbound installed ✅

**What gets installed:**

- **Unbound daemon:** DNS resolver service
- **Configuration files:** Default configuration in `/etc/unbound/`
- **DNSSEC keys:** Root trust anchor for DNSSEC validation
- **Documentation:** Unbound documentation and examples

**Real-world example:**

**Installation output:**

```
Reading package lists... Done
Building dependency tree... Done
The following NEW packages will be installed:
  unbound
0 upgraded, 1 newly installed, 1 to remove, 0 not upgraded.
Need to get 1,234 kB of archives.
After this operation, 2,345 kB of additional disk space will be used.
Get:1 http://archive.raspberrypi.org/debian bookworm/main arm64 unbound arm64 1.18.0-2 [1,234 kB]
Fetched 1,234 kB in 2s (617 kB/s)
Selecting previously unselected package unbound.
Preparing to unpack .../unbound_1.18.0-2_arm64.deb ...
Unpacking unbound (1.18.0-2) ...
Setting up unbound (1.18.0-2) ...
Processing triggers for systemd (252.5-3) ...
```

**After installation:**

- **Unbound installed:** Package installed successfully
- **Not running yet:** Service not started (needs configuration)
- **Ready to configure:** Can now create configuration file ✅

### Configuration

**What this does:** Creates Unbound configuration file optimized for Pi-hole integration.

**Create `/etc/unbound/unbound.conf.d/pi-hole.conf`:**

**Why this location:**

- **`/etc/unbound/`:** Unbound configuration directory
- **`unbound.conf.d/`:** Directory for additional configuration files
- **`pi-hole.conf`:** Configuration file for Pi-hole integration
- **Modular:** Keeps Pi-hole config separate from default config

**Configuration file:**

```
server:
    verbosity: 0
    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    prefetch: yes
    num-threads: 2
    cache-min-ttl: 60
    cache-max-ttl: 86400
    so-reuseport: yes
    edns-buffer-size: 1232
    harden-glue: yes
    harden-dnssec-stripped: yes
    qname-minimisation: yes
    aggressive-nsec: yes
    hide-identity: yes
    hide-version: yes

    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

**Configuration options explained:**

**`verbosity: 0`:**

- **What:** Logging verbosity level
- **0:** Minimal logging (quiet)
- **Higher:** More detailed logging
- **Why:** Reduces log noise, improves performance

**`interface: 127.0.0.1`:**

- **What:** IP address Unbound listens on
- **`127.0.0.1`:** Localhost (same machine)
- **Why:** Only Pi-hole needs to access Unbound (on same Pi)
- **Security:** Not accessible from network (more secure)

**`port: 5335`:**

- **What:** Port Unbound listens on
- **`5335`:** Non-standard port
- **Why:** Pi-hole uses port 53, Unbound uses 5335 (avoid conflict)
- **Pi-hole forwards:** Pi-hole forwards queries to port 5335

**`do-ip4: yes`:**

- **What:** Enable IPv4 support
- **`yes`:** IPv4 enabled
- **Why:** Most DNS queries use IPv4

**`do-udp: yes`:**

- **What:** Enable UDP protocol
- **`yes`:** UDP enabled
- **Why:** DNS primarily uses UDP (faster)

**`do-tcp: yes`:**

- **What:** Enable TCP protocol
- **`yes`:** TCP enabled
- **Why:** TCP used for large responses (fallback)

**`prefetch: yes`:**

- **What:** Prefetch DNS records before they expire
- **`yes`:** Prefetching enabled
- **Why:** Improves response time, reduces queries

**`num-threads: 2`:**

- **What:** Number of threads Unbound uses
- **`2`:** Two threads
- **Why:** Good balance for Raspberry Pi (not too many, not too few)

**`cache-min-ttl: 60`:**

- **What:** Minimum time to cache DNS records (seconds)
- **`60`:** 60 seconds minimum
- **Why:** Prevents excessive caching, ensures freshness

**`cache-max-ttl: 86400`:**

- **What:** Maximum time to cache DNS records (seconds)
- **`86400`:** 24 hours maximum
- **Why:** Limits cache size, ensures reasonable freshness

**`so-reuseport: yes`:**

- **What:** Enable SO_REUSEPORT socket option
- **`yes`:** Enabled
- **Why:** Improves performance, allows multiple sockets

**`edns-buffer-size: 1232`:**

- **What:** EDNS buffer size (bytes)
- **`1232`:** 1232 bytes
- **Why:** Optimal size for most networks, prevents fragmentation

**`harden-glue: yes`:**

- **What:** Harden glue record validation
- **`yes`:** Enabled
- **Why:** Security feature, prevents DNS spoofing

**`harden-dnssec-stripped: yes`:**

- **What:** Harden against DNSSEC-stripped responses
- **`yes`:** Enabled
- **Why:** Security feature, ensures DNSSEC validation

**`qname-minimisation: yes`:**

- **What:** Minimize query names for privacy
- **`yes`:** Enabled
- **Why:** Privacy feature, reveals less information

**`aggressive-nsec: yes`:**

- **What:** Aggressive NSEC caching
- **`yes`:** Enabled
- **Why:** Performance optimization, reduces queries

**`hide-identity: yes`:**

- **What:** Hide Unbound identity in responses
- **`yes`:** Enabled
- **Why:** Privacy feature, doesn't reveal server identity

**`hide-version: yes`:**

- **What:** Hide Unbound version in responses
- **`yes`:** Enabled
- **Why:** Security feature, doesn't reveal version information

**`auto-trust-anchor-file: "/var/lib/unbound/root.key"`:**

- **What:** DNSSEC root trust anchor file
- **`/var/lib/unbound/root.key`:** Path to root key file
- **Why:** Enables DNSSEC validation, ensures DNS security

**How to create file:**

**Method 1: Using text editor:**

```bash
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```

**What this does:**

- **`sudo`:** Administrator privileges needed
- **`nano`:** Text editor
- **`/etc/unbound/unbound.conf.d/pi-hole.conf`:** File path
- **Result:** Opens file for editing ✅

**Method 2: Using cat:**

```bash
sudo tee /etc/unbound/unbound.conf.d/pi-hole.conf > /dev/null << 'EOF'
server:
    verbosity: 0
    interface: 127.0.0.1
    port: 5335
    # ... (paste full config)
EOF
```

**What this does:**

- **`sudo tee`:** Write to file with sudo
- **`> /dev/null`:** Suppress output
- **`<< 'EOF'`:** Here document (multiline input)
- **Result:** Creates file with content ✅

**Real-world example:**

**Create configuration:**

```bash
$ sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
# Paste configuration, save (Ctrl+O, Enter, Ctrl+X)
```

**Verify file created:**

```bash
$ ls -l /etc/unbound/unbound.conf.d/pi-hole.conf
-rw-r--r-- 1 root root 567 Dec 15 10:30 /etc/unbound/unbound.conf.d/pi-hole.conf
```

**File created:** Configuration file ready ✅

### Start and Enable Unbound

**What this does:** Starts Unbound service and enables it to start on boot.

**Start and enable:**

```bash
sudo systemctl enable --now unbound
sudo systemctl status unbound
```

**Command breakdown:**

**`sudo systemctl enable --now unbound`:**

- **`systemctl enable`:** Enable service to start on boot
- **`--now`:** Start service immediately (don't wait for reboot)
- **`unbound`:** Unbound service name
- **Result:** Unbound starts now and on every boot ✅

**`sudo systemctl status unbound`:**

- **`systemctl status`:** Show service status
- **`unbound`:** Unbound service name
- **Result:** Shows if Unbound is running ✅

**What to look for:**

**Expected output:**

```
● unbound.service - Unbound DNS resolver
     Loaded: loaded (/lib/systemd/system/unbound.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2025-12-15 10:30:00 UTC; 5s ago
       Docs: man:unbound(8)
   Main PID: 1234 (unbound)
      Tasks: 2 (limit: 4915)
     Memory: 5.2M
        CPU: 45ms
     CGroup: /system.slice/unbound.service
             └─1234 /usr/sbin/unbound -d
```

**What this means:**

- **Loaded:** Service loaded ✅
- **Active:** Service running ✅
- **Enabled:** Service enabled on boot ✅

**If not running:**

- **Check logs:** `sudo journalctl -u unbound -n 50`
- **Check config:** `sudo unbound-checkconf`
- **Fix issues:** Resolve configuration errors

**Real-world example:**

**Start Unbound:**

```bash
$ sudo systemctl enable --now unbound
Created symlink /etc/systemd/system/multi-user.target.wants/unbound.service → /lib/systemd/system/unbound.service.

$ sudo systemctl status unbound
● unbound.service - Unbound DNS resolver
     Active: active (running) ✅
```

**Unbound running:** Service started successfully ✅

---

## Wire Pi-hole to Unbound

### What This Does

**Definition:** This step configures Pi-hole to use Unbound as its upstream DNS server instead of public DNS servers.

**Why this is needed:**

- **Pi-hole needs upstream:** Pi-hole forwards queries it can't answer
- **Default upstream:** Pi-hole uses public DNS by default (Google, Cloudflare)
- **Change upstream:** Need to change to Unbound for privacy
- **Integration:** Connects Pi-hole and Unbound together

### Step-by-Step Configuration

**Step 1: In Pi-hole Admin → Settings → DNS:**

**How to access:**

- **Open admin UI:** `http://<pi-ip>/admin`
- **Login:** Enter admin password
- **Navigate:** Settings → DNS
- **Find:** Upstream DNS Servers section

**What to configure:**

**Upstream DNS Servers → **Custom 1 (IPv4):** `127.0.0.1#5335`**

**What this means:**

- **Custom 1 (IPv4):** First custom upstream DNS server (IPv4)
- **`127.0.0.1`:** Localhost (Unbound on same Pi)
- **`#5335`:** Port number (Unbound listens on port 5335)
- **Format:** `IP#PORT` format for custom upstreams

**Why this format:**

- **IP address:** `127.0.0.1` (Unbound's address)
- **Port separator:** `#` separates IP from port
- **Port number:** `5335` (Unbound's port)
- **Pi-hole understands:** Pi-hole parses this format

**Disable other upstreams.**

**What this means:**

- **Other upstreams:** Google (`8.8.8.8`), Cloudflare (`1.1.1.1`), etc.
- **Disable:** Uncheck or remove other upstream DNS servers
- **Why:** Only use Unbound, don't use public DNS

**How to disable:**

- **Uncheck boxes:** Uncheck other upstream DNS servers
- **Or remove:** Remove other upstream entries
- **Keep only:** Keep only `127.0.0.1#5335` enabled

**Real-world example:**

**Before configuration:**

- **Upstream DNS:** Google (`8.8.8.8`), Cloudflare (`1.1.1.1`)
- **Queries go to:** Public DNS servers
- **Privacy:** Public DNS sees your queries ❌

**After configuration:**

- **Upstream DNS:** Unbound (`127.0.0.1#5335`)
- **Queries go to:** Unbound (local)
- **Privacy:** Queries stay on your network ✅

**Step 2: Apply changes.**

**What this does:**

- **Saves configuration:** Pi-hole saves new upstream DNS settings
- **Restarts service:** Pi-hole restarts to apply changes
- **New upstream active:** Pi-hole now uses Unbound

**How to apply:**

- **Click "Save" or "Apply":** Button in Pi-hole admin UI
- **Wait:** Wait for Pi-hole to restart (few seconds)
- **Confirmation:** Should see success message

**What happens:**

- **Config saved:** Settings saved to Pi-hole config file
- **Service restarts:** Pi-hole-FTL service restarts
- **Unbound used:** Pi-hole now forwards to Unbound

**Step 3: Test**

**What this does:** Verifies Unbound is working and Pi-hole can reach it.

**Test:**

```bash
dig google.com @127.0.0.1 -p 5335
```

**Command breakdown:**

**`dig google.com @127.0.0.1 -p 5335`:**

- **`dig`:** DNS lookup tool
- **`google.com`:** Domain to look up
- **`@127.0.0.1`:** Query Unbound directly (localhost)
- **`-p 5335`:** Use port 5335 (Unbound's port)
- **Result:** Should return IP address ✅

**What to expect:**

**Successful query:**

```
; <<>> DiG 9.18.1-1ubuntu1.3-Ubuntu <<>> google.com @127.0.0.1 -p 5335
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		300	IN	A	172.217.164.110

;; Query time: 45 msec
;; SERVER: 127.0.0.1#5335(127.0.0.1)
;; WHEN: Mon Dec 15 10:35:00 UTC 2025
;; MSG SIZE  rcvd: 55
```

**What this means:**

- **Status: NOERROR:** Query successful ✅
- **ANSWER: 1:** Got IP address ✅
- **IP: 172.217.164.110:** Google's IP address ✅
- **SERVER: 127.0.0.1#5335:** Queried Unbound ✅

**If SERVFAIL:**

- **Status: SERVFAIL:** Query failed
- **Possible causes:** DNSSEC validation failed, domain doesn't exist
- **Expected:** Only for truly failing domains (not normal domains)

**Additional tests:**

**Test from Pi-hole:**

```bash
# On Pi
dig example.com @127.0.0.1 -p 5335
```

**Test Pi-hole integration:**

```bash
# On client
dig example.com @192.168.0.109
# Should go: Client → Pi-hole → Unbound → Root
```

**Verify Pi-hole using Unbound:**

- **Check Pi-hole logs:** `sudo tail -f /var/log/pihole.log`
- **Look for:** Queries going to `127.0.0.1:5335`
- **Expected:** See Unbound queries in logs ✅

**Real-world example:**

**Test Unbound directly:**

```bash
$ dig google.com @127.0.0.1 -p 5335
# Returns IP address ✅
```

**Test through Pi-hole:**

```bash
$ dig google.com @192.168.0.109
# Goes: Client → Pi-hole → Unbound → Root
# Returns IP address ✅
```

**Verify integration:**

- **Pi-hole logs:** Show queries to `127.0.0.1:5335` ✅
- **Unbound logs:** Show queries from Pi-hole ✅
- **Integration working:** Pi-hole using Unbound ✅

**Troubleshooting:**

**Unbound not responding:**

- **Check status:** `sudo systemctl status unbound`
- **Check logs:** `sudo journalctl -u unbound -n 50`
- **Check config:** `sudo unbound-checkconf`

**Pi-hole not using Unbound:**

- **Check settings:** Verify upstream DNS is `127.0.0.1#5335`
- **Restart Pi-hole:** `sudo systemctl restart pihole-FTL`
- **Check logs:** `sudo tail -f /var/log/pihole.log`

**Learn more:** See [`../../shell-commands/02-commands/dig.md`](../../shell-commands/02-commands/dig.md) for detailed dig usage.

---

## Notes & Tips

### Important Reminders

**Keep router DHCP DNS pointing to Pi-hole (unchanged).**

**What this means:**

- **Router DHCP:** Router's DHCP DNS setting
- **Should point to:** Pi-hole IP (e.g., `192.168.0.109`)
- **Not Unbound:** Don't point router DNS to Unbound directly
- **Why:** Pi-hole handles blocklists, Unbound is just upstream

**Why this matters:**

- **Pi-hole first:** All queries go through Pi-hole first
- **Blocklists applied:** Pi-hole checks blocklists before forwarding (see [Blocklists and Whitelists Guide](blocklists-whitelists.md) for enhancing blocking)
- **Unbound second:** Unbound only resolves allowed domains
- **Architecture:** Clients → Pi-hole → Unbound (not Clients → Unbound)

**Real-world example:**

**Correct setup:**

- **Router DHCP DNS:** `192.168.0.109` (Pi-hole)
- **Pi-hole upstream:** `127.0.0.1#5335` (Unbound)
- **Flow:** Client → Pi-hole → Unbound ✅

**Incorrect setup:**

- **Router DHCP DNS:** `192.168.0.109` (Unbound directly)
- **Problem:** Blocklists not applied, ads not blocked ❌

### Manual Root Key Updates

**If you want root priming updates manually: `sudo unbound-anchor -a "/var/lib/unbound/root.key"`.**

**What this does:**

- **Updates root key:** Downloads latest DNSSEC root trust anchor
- **Manual update:** Manually updates root key file
- **Why needed:** Root key changes occasionally (rarely)

**Command breakdown:**

**`sudo unbound-anchor -a "/var/lib/unbound/root.key"`:**

- **`sudo`:** Administrator privileges
- **`unbound-anchor`:** Unbound root anchor tool
- **`-a`:** Update anchor file
- **`/var/lib/unbound/root.key`:** Path to root key file
- **Result:** Root key updated ✅

**When to use:**

- **DNSSEC failures:** If DNSSEC validation starts failing
- **Manual update:** If you want to manually update root key
- **Troubleshooting:** If DNSSEC issues occur

**How it works:**

- **Downloads key:** Fetches latest root trust anchor from IANA
- **Updates file:** Writes new key to `/var/lib/unbound/root.key`
- **Unbound uses:** Unbound uses updated key for validation

**Real-world example:**

**Update root key:**

```bash
$ sudo unbound-anchor -a "/var/lib/unbound/root.key"
success: the anchor file is updated
```

**Root key updated:** DNSSEC validation uses latest key ✅

### Logging Configuration

**For logging, add `verbosity: 1` temporarily; keep at 0 for performance.**

**What this means:**

- **Verbosity level:** Controls how much Unbound logs
- **0:** Minimal logging (quiet, good for production)
- **1:** More detailed logging (good for debugging)
- **Higher:** Even more logging (verbose, slow)

**How to enable logging:**

**Edit configuration:**

```bash
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```

**Change:**

```
server:
    verbosity: 1  # Changed from 0 to 1
    # ... rest of config
```

**Restart Unbound:**

```bash
sudo systemctl restart unbound
```

**Check logs:**

```bash
sudo journalctl -u unbound -f
```

**What you'll see:**

- **Query logs:** DNS queries being processed
- **Resolution steps:** How queries are resolved
- **Errors:** Any errors or issues

**When to use:**

- **Debugging:** When troubleshooting DNS issues
- **Learning:** To understand how Unbound works
- **Temporary:** Keep at 0 for production (performance)

**Real-world example:**

**Enable logging:**

```bash
$ sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
# Change verbosity: 0 to verbosity: 1
$ sudo systemctl restart unbound
$ sudo journalctl -u unbound -f
# See detailed query logs
```

**Disable logging (after debugging):**

```bash
$ sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
# Change verbosity: 1 back to verbosity: 0
$ sudo systemctl restart unbound
# Back to quiet mode ✅
```

### Multi-Pi Redundancy

**For multi-Pi redundancy, run Unbound on each Pi-hole and keep DHCP pointing at one Pi-hole; use Pi-hole's conditional forwarding or peer sync if desired.**

**What this means:**

- **Multiple Pi-holes:** Run multiple Pi-hole instances for redundancy
- **Unbound on each:** Install Unbound on each Pi-hole
- **DHCP points to one:** Router DHCP points to one Pi-hole (primary)
- **Failover:** If primary fails, switch DHCP to secondary

**Why this setup:**

- **Redundancy:** If one Pi fails, other takes over
- **High availability:** Network always has DNS service
- **Load distribution:** Can distribute load across Pi-holes

**How it works:**

- **Primary Pi-hole:** Router DHCP points to this Pi-hole
- **Secondary Pi-hole:** Backup Pi-hole (not in DHCP)
- **Failover:** If primary fails, change DHCP to secondary
- **Both have Unbound:** Each Pi-hole has its own Unbound instance

**Alternative approaches:**

**Pi-hole conditional forwarding:**

- **What:** Pi-hole forwards queries to other Pi-hole
- **Use case:** Load balancing, redundancy
- **Configuration:** Pi-hole admin UI → Settings → DNS

**Pi-hole peer sync:**

- **What:** Sync blocklists between Pi-holes
- **Use case:** Keep blocklists consistent
- **Configuration:** Pi-hole admin UI → Settings → Teleporter

**Real-world example:**

**Setup:**

- **Pi-hole 1:** `192.168.0.109` (primary, in DHCP)
- **Pi-hole 2:** `192.168.0.110` (secondary, backup)
- **Both have Unbound:** Each runs Unbound locally
- **Router DHCP:** Points to `192.168.0.109`

**If primary fails:**

- **Change DHCP:** Point router DHCP to `192.168.0.110`
- **Renew leases:** Devices get new DNS setting
- **Service continues:** Network still has DNS service ✅

**Learn more:** See [Pi-hole documentation](https://docs.pi-hole.net/) for advanced redundancy setups.
