# VM Networking

Complete guide for understanding and configuring KVM/QEMU networking. Explains how libvirt NAT networking works, what must be verified, and how to correctly configure networking on both host and guest.

---

## Prerequisites

Before reading this, you should understand:

- **IP addressing:** [`../../networking/docs/ip-addressing.md`](../../networking/docs/ip-addressing.md)
- **DHCP:** [`../../networking/docs/dhcp.md`](../../networking/docs/dhcp.md)
- **DNS:** [`../../networking/docs/dns.md`](../../networking/docs/dns.md)
- **NAT:** [`../../networking/docs/nat-firewalls.md`](../../networking/docs/nat-firewalls.md)

---

## Mental Model: How libvirt NAT Networking Works

Before touching commands, understand the data path and why NAT is the default.

### Why NAT is Default

**NAT (Network Address Translation) is the default** for good reasons:

**1. Safety:**

- **No inbound exposure:** Internet can't reach VMs directly
- **Isolated:** VMs can't be accessed from outside
- **Secure:** No ports open on host
- **Safe by default:** Can't accidentally expose services

**2. Works out of box:**

- **No configuration needed:** Just works
- **No host network changes:** Doesn't modify host network
- **No router changes:** Doesn't affect LAN
- **Plug and play:** Create VM, get network

**3. No host network changes:**

- **Doesn't modify host:** Host network unchanged
- **Doesn't require router:** Works with any network setup
- **Doesn't conflict:** Won't conflict with host IP
- **Isolated:** VM network separate from host network

**4. Isolates VMs from host network:**

- **Separate network:** VMs on different subnet
- **Can't access host directly:** Isolation boundary
- **Can't access other LAN devices:** Isolated from LAN
- **Safe testing:** Can't break host network

**Real-world analogy:**

- **NAT = Private apartment building network**
- **Host network = Public street**
- **VMs = Apartments** (can go out, but can't be reached from outside)
- **virbr0 = Building's private network** (isolated from street)

### How libvirt NAT Networking Works

**Data path:**

```
[ Guest VM ]
     |
     |  (virtual NIC, e.g. eth0 / enp1s0 / ens3)
     |
[ virbr0 ]  ← libvirt software bridge (private)
     |
     |  (NAT + forwarding)
     |
[ Host physical interface ]  (wlan0 / eth0)
     |
[ Internet ]
```

### virbr0 Explained Deeply

**What is virbr0?**

**virbr0** is a **virtual bridge** created by libvirt for VM networking.

**What is a virtual bridge?**

- **Bridge:** Network device that connects multiple network segments
- **Virtual:** Software-based (not physical hardware)
- **Purpose:** Connects VMs to each other and to host network

**Why it's not a physical interface:**

- **Software-only:** Created by libvirt, not hardware
- **Virtual:** Exists only in software
- **Host-only:** Only exists on host, not on network
- **Managed:** Created/destroyed by libvirt

**How it creates private network:**

- **Private IP range:** Uses `192.168.122.0/24` (RFC 1918 private)
- **DHCP server:** dnsmasq provides IPs to VMs
- **NAT gateway:** Translates VM IPs to host IP
- **Isolated:** Not routable from internet

**How NAT translation works:**

- **Outbound:** VM IP → Host IP (translation)
- **Inbound:** Host IP → VM IP (reverse translation)
- **Translation table:** Tracks which VM gets which response
- **Port mapping:** Uses ports to distinguish VMs

**Key properties:**

- `virbr0` exists **only on the host**
- It is **not a physical interface**
- It uses **private RFC1918 IP space** (typically `192.168.122.0/24`)
- Traffic is **NATed outbound only**
- No inbound internet traffic reaches the VM unless explicitly forwarded

This is **safe by default**.

### Packet Flow Explained Step-by-Step

**Outbound packet (VM → Internet):**

**Step 1: VM sends packet**

- VM wants to visit `example.com`
- Packet: Source `192.168.122.50` → Destination `93.184.216.34`
- Sent to virtual NIC (eth0/enp1s0)

**Step 2: virbr0 receives packet**

- Packet arrives at virbr0 bridge
- Bridge sees destination is not local (not `192.168.122.x`)
- Bridge forwards to NAT gateway

**Step 3: NAT translates source IP**

- NAT changes source: `192.168.122.50` → Host IP (e.g., `192.168.0.42`)
- NAT assigns port mapping (e.g., `192.168.122.50:54321` → `192.168.0.42:49152`)
- NAT records translation in table

**Step 4: Packet forwarded to host interface**

- Translated packet sent to host physical interface (wlan0/eth0)
- Host forwards packet to internet (via router)

**Step 5: Response comes back**

- Internet responds: `93.184.216.34` → `192.168.0.42:49152`
- Host receives response

**Step 6: NAT translates back**

- NAT looks up translation table: `192.168.0.42:49152` → `192.168.122.50:54321`
- NAT changes destination: `192.168.0.42:49152` → `192.168.122.50:54321`

**Step 7: Packet forwarded to VM**

- Translated packet sent to virbr0
- Bridge forwards to VM's virtual NIC
- VM receives response

**Visual flow:**

```
VM (192.168.122.50) → virbr0 → NAT → Host (192.168.0.42) → Internet
                                                              ↓
VM (192.168.122.50) ← virbr0 ← NAT ← Host (192.168.0.42) ← Internet
```

**Key insight:** NAT translates between VM's private IP and host's IP, allowing VMs to access internet while remaining isolated.

---

## Host Side: libvirt Network

### Verify the `default` Network

On the **host**:

```bash
sudo virsh net-list --all
```

**Expected:**

```
Name      State    Autostart
------------------------------
default   active   yes
```

If `default` is **inactive or missing**, the VM will not get DHCP.

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

### Recreate the `default` Network (Arch-specific)

Arch-based distributions **do not ship** `default.xml`. If the network was deleted, recreate it:

**Create network definition:**

```bash
nano /tmp/libvirt-default.xml
```

**Paste:**

```xml
<network>
  <name>default</name>
  <forward mode="nat"/>
  <bridge name="virbr0" stp="on" delay="0"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
```

**Define and activate:**

```bash
sudo virsh net-define /tmp/libvirt-default.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

**Verify:**

```bash
sudo virsh net-dumpxml default
```

**Confirm:**

- `<forward mode="nat">`
- `<dhcp>` range exists

---

## Host Side: Firewall (UFW) — The Silent Breaker

### Why UFW Blocks VM Traffic

**The problem:**

- UFW (Uncomplicated Firewall) blocks **routed traffic** by default
- VM traffic is **routed traffic** (packets forwarded between interfaces)
- Default UFW policy: Block routed traffic
- Result: VMs can't access internet

**What is routed traffic?**

- **Routed traffic:** Packets forwarded between network interfaces
- **VM traffic:** Packets from virbr0 → host interface → internet
- **Forwarding:** Host forwards packets between virbr0 and host interface
- **UFW blocks:** Default policy blocks forwarding

**Why UFW blocks routed traffic by default:**

- **Security:** Prevents unauthorized forwarding
- **Default safe:** Blocks everything, allow explicitly
- **Prevents attacks:** Stops packet forwarding attacks
- **Standard practice:** Secure default configuration

**What happens without firewall rules:**

- **ping may work:** ICMP sometimes bypasses firewall
- **DNS may resolve:** DNS queries might work
- **HTTP/HTTPS fails:** Web traffic blocked silently
- **No error messages:** Fails silently (confusing)

### Default UFW Behavior (Critical)

Typical UFW defaults:

```
deny (incoming)
allow (outgoing)
deny (routed)  ← This blocks VM traffic!
```

VM traffic is **routed traffic**. That means:

- `ping` may work (ICMP sometimes bypasses)
- DNS may resolve (UDP sometimes works)
- HTTP/HTTPS will fail silently (TCP blocked)

**Why some things work:**

- **ICMP (ping):** Sometimes handled differently
- **UDP (DNS):** May bypass firewall in some cases
- **TCP (HTTP/HTTPS):** Always blocked by routed policy

**The real problem:**

- **Inconsistent behavior:** Some things work, some don't
- **Silent failures:** No error messages
- **Confusing:** Hard to diagnose
- **Solution:** Explicitly allow VM traffic

---

### Required UFW Rules for libvirt NAT

**Rule 1: Allow VM ↔ host bridge traffic**

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
```

**What these rules do:**

- **`allow in on virbr0`:** Allows packets INTO virbr0 bridge
- **`allow out on virbr0`:** Allows packets OUT OF virbr0 bridge
- **Purpose:** Enables communication between VMs and bridge
- **Why needed:** Without this, VMs can't communicate with bridge

**Rule 2: Allow forwarded VM traffic to the internet**

Replace `<HOST_IFACE>` with your actual interface (`wlan0`, `eth0`, etc.):

```bash
sudo ufw route allow in on virbr0 out on <HOST_IFACE>
```

**What this rule does:**

- **`route allow`:** Allows forwarding (routed traffic)
- **`in on virbr0`:** Packets coming IN on virbr0
- **`out on <HOST_IFACE>`:** Packets going OUT on host interface
- **Purpose:** Allows VM traffic to be forwarded to internet
- **Why needed:** Without this, VM traffic can't reach internet

**How to find your interface:**

```bash
ip link show
# or
ip a
```

Look for interface connected to internet (usually `wlan0` for Wi-Fi, `eth0` for Ethernet)

**Reload:**

```bash
sudo ufw reload
```

**Verify rules:**

```bash
sudo ufw status verbose
```

Should show rules for `virbr0` and routing.

**Learn more:** [`../../shell-commands/02-commands/ufw.md`](../../shell-commands/02-commands/ufw.md)

---

### Why This Is Safe

**These rules are safe because:**

**1. Do not open ports on the host:**

- No inbound ports opened
- Host services not exposed
- No listening ports created
- Only forwarding allowed

**2. Do not allow internet → host:**

- Internet can't reach host
- No inbound connections allowed
- Host remains protected
- Only outbound traffic

**3. Do not allow internet → VM:**

- Internet can't reach VMs directly
- No inbound connections to VMs
- VMs remain isolated
- Only outbound-initiated traffic

**4. Only permit egress traffic initiated by the VM:**

- VMs can initiate outbound connections
- Responses allowed back (stateful)
- No unsolicited inbound traffic
- Safe outbound-only access

**Why virbr0 is safe:**

- **Private network:** `192.168.122.0/24` (not routable from internet)
- **RFC 1918:** Private IP range (not on public internet)
- **Isolated:** Can't be reached from outside
- **NAT-only:** Only outbound traffic, no inbound

**Security model:**

- **Outbound-initiated:** VMs can connect out
- **Stateful:** Responses allowed back
- **No inbound:** No unsolicited connections
- **Isolated:** VMs can't be reached from internet

`virbr0` is private and non-routable from the internet.

---

## VM Hardware Configuration (virt-manager)

Inside **virt-manager → VM → NIC**:

- **Network source:** `Virtual network 'default' : NAT`
- **Device model:** `virtio`
- **Link state:** active

**Avoid:**

- Bridged networking (unless intentional — see [`advanced.md`](advanced.md))
- User-mode networking (slower, limited)

---

## Guest Side: Interface Discovery (DO NOT SKIP)

### ⚠️ Critical Rule

> **Never assume the network interface name inside a VM.**
> Interface names are distro-dependent.

**Examples:**

- Ubuntu: `enp1s0`
- Kali: `eth0`
- Fedora: `ens3`
- Arch: `enp1s0`

---

### Discover the Interface Name

Inside the VM:

```bash
ip -o link show | awk -F': ' '{print $2}'
```

or:

```bash
ip a
```

Identify the **non-loopback** interface.

**Learn more:** [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)

---

## Guest Side: NetworkManager DHCP Configuration

### Remove Conflicting Profiles (Optional but Recommended)

```bash
sudo nmcli connection show
sudo nmcli connection delete "<existing-wired-connection>"
```

---

### Create a DHCP Profile

Replace `<VM_INTERFACE>` with the discovered name:

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <VM_INTERFACE> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**Bring it up:**

```bash
sudo nmcli connection up kvm-dhcp
```

**Verify:**

```bash
ip a
```

You should now see an IPv4 address like:

```
192.168.122.x/24
```

**Learn more:** [`../../shell-commands/02-commands/nmcli.md`](../../shell-commands/02-commands/nmcli.md)

---

## IPv6 in NATed VMs (APT Timeouts Explained)

### Symptoms

- `ping google.com` works
- `apt update` times out
- Errors reference IPv6 addresses

### Cause

- NAT works reliably for IPv4
- IPv6 is partially available but not routed
- Package managers prefer IPv6

---

### Recommended Fix: Disable IPv6 in the VM

```bash
sudo nano /etc/sysctl.d/99-disable-ipv6.conf
```

**Add:**

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

**Apply:**

```bash
sudo sysctl --system
```

---

### Alternative (APT-only)

```bash
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```

---

## QEMU Guest Agent (Required for Stability)

### Install Inside the VM

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

**Reboot once.**

### What It Provides

- Accurate IP reporting in virt-manager
- Clean shutdown/reboot
- Better clipboard & resize behavior
- Improved responsiveness

It does **not** affect networking or security.

**Learn more:** [`performance.md`](performance.md)

---

## Verification Checklist (Inside VM)

```bash
ip a
ping -c 3 8.8.8.8
ping -c 3 google.com
curl http://archive.ubuntu.com
sudo apt update
```

All should succeed without delay.

**Practice:** [`../practice/networking-drills.md`](../practice/networking-drills.md)

---

## Common Failure Modes & Root Causes

| Symptom                      | Root Cause                         |
| ---------------------------- | ---------------------------------- |
| No IP address                | libvirt `default` network inactive |
| Ping works, apt fails        | UFW routed traffic blocked         |
| apt hangs                    | IPv6 broken in NAT                 |
| Interface mismatch           | Hardcoded interface name           |
| IP not shown in virt-manager | Guest agent missing                |

---

## Security Posture Summary

This setup:

- Uses outbound-only NAT
- Does not expose host services
- Does not allow inbound internet traffic
- Is safe against port scanning
- Is suitable for learning and daily VM use

---

## Bridged Networking Overview

By default, libvirt uses NAT. **Bridged networking** puts the VM on the same network as the host:

- VM gets its own IP from the LAN
- Appears as a separate machine on the network
- Useful for servers, labs, and services

**For details:** See [`advanced.md`](advanced.md)

---

## Next Steps

- **VM performance issues?** → [`performance.md`](performance.md)
- **Need bridged networking?** → [`advanced.md`](advanced.md)
- **Troubleshooting?** → [`troubleshooting.md`](troubleshooting.md)

---

## Learn More

- **Networking fundamentals:** [`../../networking/docs/`](../../networking/docs/)
- **Practice drills:** [`../practice/networking-drills.md`](../practice/networking-drills.md)
