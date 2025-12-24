# KVM / QEMU Networking — Complete Guide & Troubleshooting

*(Arch / CachyOS host, Linux guests)*

This document explains **how KVM/QEMU networking actually works**, what **must be verified**, and how to **correctly configure networking** on both:

* the **host** (Arch / CachyOS)
* the **guest VM** (Ubuntu, Kali, Fedora, Arch, etc.)

It is written to prevent the most common mistakes:

* VM has no internet
* DHCP fails
* `apt update` times out but `ping` works
* Firewall silently blocks traffic
* Interface names differ across distros

---

## 1. Mental Model: How libvirt NAT Networking Works

Before touching commands, it’s critical to understand the data path.

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

Key properties:

* `virbr0` exists **only on the host**
* It is **not a physical interface**
* It uses **private RFC1918 IP space**
* Traffic is **NATed outbound only**
* No inbound internet traffic reaches the VM unless explicitly forwarded

This is **safe by default**.

---

## 2. Host Side: libvirt Network (Authoritative Source of Truth)

### 2.1 Verify the `default` network

On the **host**:

```bash
sudo virsh net-list --all
```

Expected:

```
Name      State    Autostart
------------------------------
default   active   yes
```

If `default` is **inactive or missing**, the VM will not get DHCP.

---

### 2.2 Recreate the `default` network (Arch-specific)

Arch-based distributions **do not ship** `default.xml`.
If the network was deleted, it must be recreated manually.

#### Create the network definition

```bash
nano /tmp/libvirt-default.xml
```

Paste:

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

Define and activate:

```bash
sudo virsh net-define /tmp/libvirt-default.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

Verify:

```bash
sudo virsh net-dumpxml default
```

Confirm:

* `<forward mode="nat">`
* `<dhcp>` range exists

---

## 3. Host Side: Firewall (UFW) — The Silent Breaker

### 3.1 Default UFW behavior (critical)

Typical UFW defaults:

```
deny (incoming)
allow (outgoing)
deny (routed)
```

VM traffic is **routed traffic**.

That means:

* `ping` may work
* DNS may resolve
* HTTP/HTTPS will fail silently

---

### 3.2 Required UFW rules for libvirt NAT

#### Allow VM ↔ host bridge traffic

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
```

#### Allow forwarded VM traffic to the internet

Replace `<HOST_IFACE>` with your actual interface (`wlan0`, `eth0`, etc.):

```bash
sudo ufw route allow in on virbr0 out on <HOST_IFACE>
```

Reload:

```bash
sudo ufw reload
```

---

### 3.3 Why this is safe

These rules:

* Do **not** open ports on the host
* Do **not** allow internet → host
* Do **not** allow internet → VM
* Only permit **egress traffic initiated by the VM**

`virbr0` is private and non-routable from the internet.

---

## 4. VM Hardware Configuration (virt-manager)

Inside **virt-manager → VM → NIC**:

* **Network source:** `Virtual network 'default' : NAT`
* **Device model:** `virtio`
* **Link state:** active

Avoid:

* Bridged networking (unless intentional)
* User-mode networking (slower, limited)

---

## 5. Guest Side: Interface Discovery (DO NOT SKIP)

### ⚠️ Critical Rule

> **Never assume the network interface name inside a VM.**
> Interface names are distro-dependent.

Examples:

* Ubuntu: `enp1s0`
* Kali: `eth0`
* Fedora: `ens3`
* Arch: `enp1s0`

---

### 5.1 Discover the interface name

Inside the VM:

```bash
ip -o link show | awk -F': ' '{print $2}'
```

or:

```bash
ip a
```

Identify the **non-loopback** interface.

---

## 6. Guest Side: NetworkManager DHCP Configuration

### 6.1 Remove conflicting profiles (optional but recommended)

```bash
sudo nmcli connection show
sudo nmcli connection delete "<existing-wired-connection>"
```

---

### 6.2 Create a DHCP profile (generic)

Replace `<VM_INTERFACE>` with the discovered name:

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <VM_INTERFACE> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

Bring it up:

```bash
sudo nmcli connection up kvm-dhcp
```

Verify:

```bash
ip a
```

You should now see an IPv4 address like:

```
192.168.122.x/24
```

---

## 7. IPv6 in NATed VMs (APT Timeouts Explained)

### Symptoms

* `ping google.com` works
* `apt update` times out
* Errors reference IPv6 addresses

### Cause

* NAT works reliably for IPv4
* IPv6 is partially available but not routed
* Package managers prefer IPv6

---

### 7.1 Recommended fix: Disable IPv6 in the VM

```bash
sudo nano /etc/sysctl.d/99-disable-ipv6.conf
```

Add:

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

Apply:

```bash
sudo sysctl --system
```

---

### Alternative (APT-only)

```bash
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```

---

## 8. QEMU Guest Agent (Required for Stability)

### Install inside the VM

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

Reboot once.

### What it provides

* Accurate IP reporting in virt-manager
* Clean shutdown/reboot
* Better clipboard & resize behavior
* Improved responsiveness

It does **not** affect networking or security.

---

## 9. Verification Checklist (Inside VM)

```bash
ip a
ping -c 3 8.8.8.8
ping -c 3 google.com
curl http://archive.ubuntu.com
sudo apt update
```

All should succeed without delay.

---

## 10. Common Failure Modes & Root Causes

| Symptom                      | Root Cause                         |
| ---------------------------- | ---------------------------------- |
| No IP address                | libvirt `default` network inactive |
| Ping works, apt fails        | UFW routed traffic blocked         |
| apt hangs                    | IPv6 broken in NAT                 |
| Interface mismatch           | Hardcoded interface name           |
| IP not shown in virt-manager | Guest agent missing                |

---

## 11. Security Posture Summary

This setup:

* Uses outbound-only NAT
* Does not expose host services
* Does not allow inbound internet traffic
* Is safe against port scanning
* Is suitable for learning and daily VM use

---

## 12. Final State Checklist

* [x] `default` libvirt network active
* [x] `virbr0` DHCP functioning
* [x] UFW allows routed VM traffic
* [x] Guest interface correctly detected
* [x] NetworkManager profile bound correctly
* [x] IPv6 handled appropriately
* [x] QEMU guest agent running
* [x] Package manager works reliably
