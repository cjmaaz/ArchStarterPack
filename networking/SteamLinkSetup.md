# 🌐 Networking, Firewalls & Steam Link on CachyOS

> Part of the **CachyOS Starter Pack** — a practical guide to understanding Linux networking fundamentals, firewalls, and configuring Steam Remote Play.

---

## Table of Contents

1. [Precursor — What Even Is a Network?](#1-precursor--what-even-is-a-network)
2. [Required Networking Concepts](#2-required-networking-concepts)
3. [How Data Actually Travels](#3-how-data-actually-travels)
4. [What Is a Firewall?](#4-what-is-a-firewall)
5. [UFW — The Firewall We Use](#5-ufw--the-firewall-we-use)
6. [Useful Commands Reference](#6-useful-commands-reference)
7. [Configuring the Firewall for Steam Link](#7-configuring-the-firewall-for-steam-link)

---

## 1. Precursor — What Even Is a Network?

A **network** is just a group of devices that can talk to each other. Your home has one — your PC, phone, iPad, smart TV, and router are all on it.

When your iPad wants to "talk" to your PC, it doesn't shout across the room. It sends **data packets** — small chunks of information — through your Wi-Fi router, which routes them to the right device.

Think of it like a postal system:
- Every device has an **address** (IP address) — like a house number.
- Data is split into **packets** — like individual letters.
- The **router** is the post office — it figures out where each letter goes.
- **Ports** are like apartment numbers — the address gets you to the building, the port gets you to the right room (application).

```
[ Your iPad ]  →→→  [ Wi-Fi Router ]  →→→  [ Your PC ]
  192.168.0.10            |                 192.168.0.240
                    (routes traffic)
```

---

## 2. Required Networking Concepts

### 2.1 IP Addresses

An **IP address** (Internet Protocol address) uniquely identifies a device on a network.

There are two kinds you'll encounter:

| Type | Example | Where it lives |
|------|---------|----------------|
| **Private / Local** | `192.168.0.240` | Inside your home network |
| **Public** | `203.0.113.45` | On the internet, assigned by your ISP |

Devices on your home network use **private IPs**. Your router has one private IP (facing inward) and one public IP (facing the internet).

**Common private IP ranges:**
```
192.168.0.0  –  192.168.255.255   ← most home routers
10.0.0.0     –  10.255.255.255    ← some ISPs and corporate networks
172.16.0.0   –  172.31.255.255    ← less common
```

**How to find your PC's local IP:**
```bash
ip a
```

Look for your network interface (`wlan0` for Wi-Fi, `eth0` for ethernet):
```
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.0.240/24 brd 192.168.0.255 scope global dynamic wlan0
```
Here `192.168.0.240` is your PC's local IP. The `/24` is the subnet mask (explained next).

---

### 2.2 Subnets and CIDR Notation

A **subnet** (subnetwork) defines a range of IP addresses that belong to the same local network. CIDR notation (`/24`, `/16`, etc.) is a compact way to express that range.

The number after `/` tells you how many bits are "fixed" (the network part). The remaining bits identify individual devices.

| CIDR | Subnet Mask | Number of Hosts | Example Range |
|------|-------------|-----------------|---------------|
| `/24` | `255.255.255.0` | 254 | `192.168.0.1` – `192.168.0.254` |
| `/16` | `255.255.0.0` | 65,534 | `192.168.0.1` – `192.168.255.254` |
| `/8` | `255.0.0.0` | 16 million+ | `10.0.0.1` – `10.255.255.254` |

**Example:** `192.168.0.0/24` means:
- All devices whose IP starts with `192.168.0.` are on the same network.
- Valid host addresses: `192.168.0.1` through `192.168.0.254`.
- `.0` is the network address, `.255` is the broadcast address (reserved, not usable).

**To see your subnet:**
```bash
ip route
```

Output:
```
default via 192.168.0.1 dev wlan0 proto dhcp src 192.168.0.240 metric 600
192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.240 metric 600
```
The line `192.168.0.0/24` tells you your subnet. Every device in `192.168.0.x` is on your local network.

---

### 2.3 Ports

If an IP address is a building's street address, a **port** is the apartment number inside that building. It tells your OS *which application* the incoming data belongs to.

Ports are numbered **0–65535**. Some are standardized:

| Port | Protocol | Used For |
|------|----------|---------|
| 22 | TCP | SSH (remote terminal) |
| 80 | TCP | HTTP (unencrypted web) |
| 443 | TCP | HTTPS (encrypted web) |
| 53 | UDP | DNS (domain name lookup) |
| 3000 | TCP | Common dev servers |
| 27036 | TCP/UDP | Steam Remote Play |

**Example:** When you open a website, your browser connects to `93.184.216.34:443` — the IP of the server, port 443 (HTTPS). Your PC knows to hand the data to your browser, not some other app, because it arrived on port 443.

---

### 2.4 TCP vs UDP

These are two different **transport protocols** — the rules for how data is sent.

| Feature | TCP | UDP |
|---------|-----|-----|
| **Full name** | Transmission Control Protocol | User Datagram Protocol |
| **Reliability** | Guaranteed delivery, ordered | Fire and forget, no guarantee |
| **Speed** | Slower (confirms each packet) | Faster (no confirmation) |
| **Use case** | Web, SSH, file transfer | Video streaming, gaming, DNS |
| **Analogy** | Registered mail (gets a receipt) | Dropping a flyer in a mailbox |

Steam Link uses **both**:
- TCP for control signals (reliable, must arrive).
- UDP for video/audio streaming (speed matters more than perfection).

---

### 2.5 DNS — Domain Name System

You type `google.com` but computers work with IPs. DNS is the phonebook that translates one to the other.

```
You type: google.com
    ↓
DNS Resolver: "What IP is google.com?"
    ↓
DNS Server: "142.250.80.46"
    ↓
Your browser connects to 142.250.80.46
```

**Quick DNS lookup example:**
```bash
dig google.com
# or
nslookup google.com
```

On your local network, your router often acts as the DNS resolver, forwarding requests to your ISP's or a public DNS (like `8.8.8.8` — Google's DNS, or `1.1.1.1` — Cloudflare's).

---

### 2.6 DHCP — Dynamic Host Configuration Protocol

When your device connects to Wi-Fi, it needs an IP address. **DHCP** is the protocol your router uses to automatically assign one.

Without DHCP, you'd have to manually set your IP on every device. With it:

```
[Your PC connects to Wi-Fi]
    ↓
PC: "Hey router, I just joined. Give me an IP!"
    ↓
Router: "Here's 192.168.0.240, your gateway is 192.168.0.1, use DNS 192.168.0.1"
    ↓
[PC sets these values automatically]
```

This is why your PC's IP might change if you restart your router — DHCP assigns a fresh lease. To avoid this, you can set a **static IP** in your router's admin panel (usually `192.168.0.1`) — lock a specific IP to your PC's MAC address.

---

## 3. How Data Actually Travels

Let's trace what happens when your iPad's Steam Link app tries to connect to your PC.

```
iPad (192.168.0.10)  →  Wi-Fi Router  →  PC (192.168.0.240)
       port: random          |              port: 27036
                         (same LAN, no NAT needed)
```

**Step by step:**

1. **Steam Link app** on iPad knows your PC's local IP (discovered via Steam's network scan or manually entered).
2. iPad sends a connection request packet: `src: 192.168.0.10:54321 → dst: 192.168.0.240:27036`.
3. The **Wi-Fi router** sees both devices are on the same subnet (`192.168.0.0/24`), so it delivers directly — no internet involved.
4. The packet arrives at your **PC's network interface** (`wlan0`).
5. The **kernel** checks: "Should I accept traffic on port 27036?" — This is where the **firewall** decides.
6. If allowed → Steam receives the connection → streaming begins.
7. If blocked → packet is dropped silently → iPad sees "connection failed".

---

## 4. What Is a Firewall?

A **firewall** is a gatekeeper for your network traffic. It inspects incoming and outgoing packets and decides whether to **allow** or **block** them based on rules you define.

### Why Do You Need One?

Even on a home network, a firewall protects you:
- Stops random services on your PC from being accessible to every device.
- Prevents malicious software from opening unexpected listening ports.
- On public Wi-Fi — critical. Without a firewall, anyone on the same café Wi-Fi could probe your open ports.

### How a Firewall Works

Rules are evaluated **top to bottom**. The first matching rule wins. If nothing matches, the **default policy** applies.

```
Incoming packet arrives at PC
          ↓
   Rule 1: Block port 23 (Telnet)?    → MATCH → DROP
   Rule 2: Allow from 192.168.0.0/24 port 27036? → MATCH → ACCEPT
   Rule 3: Allow port 22 (SSH)?       → ...
   ...
   Default Policy: DENY               → DROP everything else
```

### Types of Firewall Rules

| What you can filter on | Example |
|------------------------|---------|
| Source IP | Only allow traffic from `192.168.0.0/24` |
| Destination port | Only allow port 443 |
| Protocol | Only allow TCP, block UDP |
| Interface | Only allow on `wlan0`, block on `eth0` |
| Direction | Incoming (INPUT), outgoing (OUTPUT), forwarded (FORWARD) |

### The Linux Firewall Stack

On Linux, the firewall hierarchy looks like this:

```
Your Rules (ufw / firewalld)
        ↓
   iptables / nftables       ← the actual engine in the kernel
        ↓
  Netfilter (kernel module)  ← lowest level, inspects every packet
```

**UFW** (Uncomplicated Firewall) is a friendly frontend that generates `iptables` rules for you. You write human-readable commands; UFW translates them into `iptables` rules that the kernel understands.

---

## 5. UFW — The Firewall We Use

CachyOS uses **UFW** as the default firewall management tool.

### Check UFW Status
```bash
sudo ufw status verbose
```

Sample output:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
27036/tcp                  ALLOW IN    192.168.0.0/24
```

### Enable / Disable UFW
```bash
sudo ufw enable     # turn on the firewall
sudo ufw disable    # turn off (not recommended in production)
sudo ufw reload     # apply changes without full restart
```

### Default Policies

These are the most important settings:
```bash
sudo ufw default deny incoming    # block all inbound by default ✅ recommended
sudo ufw default allow outgoing   # allow all outbound by default ✅ recommended
```

This means your PC can freely connect to the internet, but nothing from outside can initiate a connection to your PC unless you explicitly allow it.

### Adding Rules

**Allow a port for everyone:**
```bash
sudo ufw allow 22/tcp           # SSH from anywhere
sudo ufw allow 80/tcp           # HTTP from anywhere
```

**Allow a port only from your local network (safer):**
```bash
sudo ufw allow from 192.168.0.0/24 to any port 22 proto tcp
```

**Allow a specific IP only:**
```bash
sudo ufw allow from 192.168.0.10 to any port 22 proto tcp
# Only the device at 192.168.0.10 can SSH into this PC
```

**Deny a port:**
```bash
sudo ufw deny 23/tcp   # block Telnet explicitly
```

### Deleting Rules
```bash
sudo ufw delete allow 22/tcp
sudo ufw delete allow from 192.168.0.0/24 to any port 27036 proto tcp
```

Or by rule number (safer for complex rules):
```bash
sudo ufw status numbered     # lists rules with numbers
sudo ufw delete 3            # deletes rule #3
```

### Logging
```bash
sudo ufw logging on     # enable logging
sudo ufw logging off    # disable logging

# View firewall logs
sudo journalctl -f | grep UFW
# or
sudo tail -f /var/log/ufw.log
```

---

## 6. Useful Commands Reference

### Network Inspection

```bash
# Show all network interfaces and their IPs
ip a

# Show routing table (find your subnet and gateway)
ip route

# Show active connections and listening ports
ss -tulnp

# Show only listening ports
ss -tlnp

# Check if a specific port is open/listening
ss -tlnp | grep 27036

# Ping a device to check connectivity
ping 192.168.0.10

# Trace the path packets take to a destination
traceroute google.com

# DNS lookup
dig google.com
nslookup google.com
```

### UFW Management

```bash
# Full status with rules
sudo ufw status verbose

# Numbered list of rules
sudo ufw status numbered

# Enable/disable
sudo ufw enable
sudo ufw disable
sudo ufw reload

# Allow/deny
sudo ufw allow 8080/tcp
sudo ufw deny 23/tcp
sudo ufw allow from 192.168.0.0/24 to any port 27036 proto tcp

# Delete rules
sudo ufw delete allow 8080/tcp
sudo ufw delete 3                     # by rule number

# Reset all rules (nuclear option)
sudo ufw reset
```

### Process & Port Debugging

```bash
# What is listening on what port? (shows PID and process name)
ss -tulnp

# Check if Steam is listening
ss -tulnp | grep steam

# Which process owns a specific port?
sudo lsof -i :27036

# Kill a process by PID
kill -9 <PID>
```

### Systemd Service Management

```bash
# Check firewall service status
systemctl status ufw

# Enable service to start on boot
sudo systemctl enable ufw

# Start/stop/restart
sudo systemctl start ufw
sudo systemctl stop ufw
sudo systemctl restart ufw
```

---

## 7. Configuring the Firewall for Steam Link

### Background

**Steam Remote Play** (formerly Steam In-Home Streaming) lets you stream games from your PC to another device — in this case, from a CachyOS PC to an iPad running Steam Link.

Both devices must be on the **same local network**. The iPad discovers your PC automatically using Steam's network scanner, but it still needs to establish a direct TCP/UDP connection to specific ports on your PC. If those ports are blocked by the firewall, the connection fails silently.

### Steam's Required Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 27036 | TCP | Initial connection / pairing |
| 27037 | TCP | Streaming data control |
| 27031 | UDP | Video/audio stream |
| 27036 | UDP | Discovery / stream data |

### Step 1 — Detect Your Active Firewall

```bash
systemctl status ufw
systemctl status firewalld
systemctl status iptables
```

The one showing **active (running)** is your firewall. On CachyOS the default is typically `ufw`.

### Step 2 — Find Your Local Subnet

```bash
ip route
```

Example output:
```
default via 192.168.0.1 dev wlan0 proto dhcp src 192.168.0.240 metric 600
192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.240 metric 600
```

Your subnet is `192.168.0.0/24` — this means your iPad (also on the same Wi-Fi) will have an IP like `192.168.0.x`, which is within this range.

### Step 3 — Add Firewall Rules (Subnet-Restricted)

> We restrict rules to your **local subnet only** (`192.168.0.0/24`). This means only devices on your home network can reach these ports — not the open internet.

```bash
sudo ufw allow from 192.168.0.0/24 to any port 27036 proto tcp
sudo ufw allow from 192.168.0.0/24 to any port 27037 proto tcp
sudo ufw allow from 192.168.0.0/24 to any port 27031 proto udp
sudo ufw allow from 192.168.0.0/24 to any port 27036 proto udp

sudo ufw reload
```

### Step 4 — Verify the Rules

```bash
sudo ufw status verbose
```

Expected output (relevant section):
```
To                                         Action      From
--                                         ------      ----
27036/tcp                                  ALLOW IN    192.168.0.0/24
27037/tcp                                  ALLOW IN    192.168.0.0/24
27031/udp                                  ALLOW IN    192.168.0.0/24
27036/udp                                  ALLOW IN    192.168.0.0/24
```

### Step 5 — Enable Remote Play in Steam

Open Steam on your PC:
```
Steam → Settings → Remote Play → ✅ Enable Remote Play
```

Optionally enable **Advanced Host Options** to tweak streaming quality and bandwidth.

### Step 6 — Connect from iPad

1. Open **Steam Link** on your iPad.
2. It should auto-detect your PC on the same network.
3. If not, tap **"Other Computer"** and enter your PC's IP manually (e.g., `192.168.0.240`).

### Troubleshooting

**Verify Steam is actually listening on those ports:**
```bash
ss -tulnp | grep steam
```
If no output — Steam isn't listening yet. Make sure Steam is open and Remote Play is enabled.

**Verify your iPad's IP is in the same subnet:**
On your iPad: Settings → Wi-Fi → tap your network → note the IP address. It should be `192.168.0.x`.

**Check your PC's IP hasn't changed:**
```bash
ip a | grep wlan0
```

If your PC's IP keeps changing (DHCP reassigning), consider setting a **DHCP reservation** in your router's admin panel — this locks your PC's MAC address to a fixed IP permanently.

---

### Why Subnet-Restricted Rules Are Better

| Rule Type | Example | Risk |
|-----------|---------|------|
| Open to everyone | `ufw allow 27036/tcp` | Anyone on any network can probe this port |
| Subnet-restricted | `ufw allow from 192.168.0.0/24 to any port 27036 proto tcp` | Only devices on your home Wi-Fi can reach it ✅ |
| IP-specific | `ufw allow from 192.168.0.10 to any port 27036 proto tcp` | Only your iPad can reach it ✅✅ (but breaks if iPad IP changes) |

The **subnet-restricted** approach is the sweet spot — secure enough for home use, and doesn't break if your iPad's IP changes slightly.

---

> **Tip:** If you ever want to nuke all rules and start clean:
> ```bash
> sudo ufw reset
> sudo ufw default deny incoming
> sudo ufw default allow outgoing
> sudo ufw enable
> ```
> Then re-add only what you need.

---

*Part of the [CachyOS Starter Pack](../README.md) — contributions welcome.*
