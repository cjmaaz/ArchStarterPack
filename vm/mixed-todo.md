# KVM / QEMU Networking & VM Performance

**A Practical, OS-Agnostic Troubleshooting and Configuration Guide**

This document explains **how KVM/QEMU networking actually works**, how to debug it when it fails, and how to configure both **host and guest (VM)** systems correctly.
It also covers **display, performance, and guest-agent optimizations**, with explanations for *what to choose, when, and why*.

---

## 1. Mental Model (Read This First)

Before commands, understand the architecture:

* **Host** runs:

  * `libvirtd`
  * A virtual bridge (`virbr0`)
  * A DHCP + DNS service (dnsmasq)
* **Guest VM**:

  * Sees a **virtual NIC** (virtio)
  * Requests IP via DHCP
* **NAT mode**:

  * Guest → virbr0 → host → real network
  * No inbound exposure by default

If **any one layer breaks**, symptoms look random:

* `ping` works but `apt update` fails
* IPv4 works, IPv6 breaks apps
* VM feels “slow” despite low CPU usage

This README is about restoring *alignment* between layers.

---

## 2. Host-Side: Verify libvirt NAT Network

### 2.1 Check default network exists and is active

```bash
sudo virsh net-list --all
```

You want:

* `default`
* State: `active`
* Autostart: `yes`

If missing or inactive:

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

---

### 2.2 Inspect the NAT network definition

```bash
sudo virsh net-dumpxml default
```

Expected concepts (values may differ):

* `forward mode='nat'`
* `bridge name='virbr0'`
* DHCP range (e.g. `192.168.122.0/24`)

If this looks sane, **DHCP exists** on the host.

---

## 3. Host Firewall: What Is Safe vs Dangerous

### 3.1 The critical question: “Does this expose my system?”

Rules like:

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
```

**DO NOT expose your host to the internet.**

Why:

* `virbr0` is **not routed publicly**
* It is a **host-local virtual bridge**
* Only VMs attached to it can see this traffic

You are allowing **VM ↔ host internal traffic**, not WAN access.

### 3.2 Why this rule is often required

Firewalls may block:

* DHCP replies
* DNS responses
* NAT forwarding

Symptoms without this:

* VM gets link-local IPv6 only
* IPv4 DHCP times out
* `apt update` fails but `ping` works

---

## 4. Guest VM: Network Interface Reality Check

### 4.1 Interface names are NOT portable

Never assume:

* `eth0`
* `enp1s0`

Always check:

```bash
ip a
```

Examples:

* Ubuntu: `enp1s0`
* Kali: `eth0`
* Other distros: varies

**This is why your Kali VM failed with the same README.**

---

## 5. Guest NetworkManager: Correct Way to Create a Connection

### 5.1 Delete broken or auto-generated profiles

```bash
nmcli connection show
sudo nmcli connection delete "<broken-connection-name>"
```

---

### 5.2 Create a connection bound to the *actual* interface

Replace `<iface>` with output from `ip a`.

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <iface> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

Then bring it up:

```bash
sudo nmcli connection up kvm-dhcp
```

---

### 5.3 Why IPv6 is disabled here

In NAT setups:

* IPv6 often partially works
* Some apps prefer IPv6 and hang
* `apt` is especially sensitive

Disabling IPv6 at the connection level:

* Forces clean IPv4 routing
* Prevents “Network unreachable” delays

This is **not a global IPv6 disable**, only per-interface.

---

## 6. DNS: Why Ping Works but apt Fails

### 6.1 Understand the symptom

* `ping google.com` ✅
* `apt update` ❌
* Errors mention:

  * `security.ubuntu.com:80`
  * timeouts
  * IPv6 addresses

Root causes:

* DNS replies blocked
* IPv6 preferred but broken
* Firewall blocking NAT DNS

---

### 6.2 Validate DNS inside VM

```bash
resolvectl status
```

You should see:

* A DNS server in the `192.168.122.1` range (host dnsmasq)

If missing:

* DHCP is not completing
* Firewall or virbr0 issue exists

---

## 7. VM Display & Graphics: Choosing the Right Model

### 7.1 QXL vs Virtio-GPU

| Model      | Use When              | Why                    |
| ---------- | --------------------- | ---------------------- |
| **QXL**    | Older desktops, SPICE | Stable, predictable    |
| **Virtio** | Modern Linux guests   | Faster, lower overhead |

### 7.2 3D Acceleration

Enable **only if**:

* Host GPU drivers are stable
* You need compositing / Wayland

Disable if:

* VM feels laggy
* Cursor stutters
* CPU usage is low but UI is slow

Animations hurt VMs more than raw compute.

---

## 8. VM Performance: CPU & Memory Done Right

### 8.1 CPU

Recommended:

* Enable **host-passthrough**
* Allocate fewer cores with higher clocks

Example:

* Host: 8 cores
* VM: 4 cores (passthrough)

This improves:

* Scheduler efficiency
* Cache locality

---

### 8.2 Memory

* Fixed allocation is safer
* Ballooning can cause stalls

Example:

* Host: 32 GiB
* VM: 8 GiB fixed

---

## 9. qemu-guest-agent: Should You Install It?

### 9.1 Yes — and here’s why

Install inside the VM:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

Benefits:

* Accurate IP reporting in VM manager
* Clean shutdown/reboot
* Better time sync
* Improved clipboard & filesystem hints

It does **not** affect networking directly, but makes debugging sane.

---

## 10. Why the VM “Felt Slow” Despite Low CPU

Common reasons:

* DNS timeouts blocking apps
* IPv6 fallback delays
* Software rendering
* Desktop animations

Fixes you applied:

* Firewall alignment
* IPv6 ignored
* Correct NIC binding
* Guest agent installed
* Display model tuned

This is why performance suddenly normalized.

---

## 11. Checklist for Any New VM (Ubuntu, Kali, Arch, etc.)

1. **Host**

   * `virbr0` exists
   * `default` network active
   * Firewall allows virbr0

2. **VM Manager**

   * NIC: NAT → default
   * Model: virtio
   * Display: virtio or QXL
   * CPU: host-passthrough

3. **Guest**

   * Identify real interface name
   * Create NM profile bound to it
   * IPv4 auto, IPv6 ignored
   * Install qemu-guest-agent

---

## 12. Key Takeaway

Most KVM “network bugs” are not bugs at all — they are **layer mismatches**:

* Interface names assumed
* Firewall unaware of virtual bridges
* IPv6 half-working
* Display stack misaligned

Once layers agree, KVM is boringly reliable — which is exactly what you want.

---

TODO:
* Mixed and has to be seggragated by settings/config type.
* A **second README** just for **GPU passthrough**
* Or a **minimal “known-good VM template”**
* Or a **diagnostic script that checks all of this automatically**
