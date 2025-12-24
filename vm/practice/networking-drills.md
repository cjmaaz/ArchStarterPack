# Networking Troubleshooting Drills

Hands-on exercises for diagnosing and fixing VM networking issues.

---

## Prerequisites

- At least one VM created and running
- Basic understanding of networking (see [`../docs/networking.md`](../docs/networking.md))

---

## Drill 1: Inspect Default Network

**Command:**

```bash
sudo virsh net-dumpxml default
```

**What to look for:**

- `<forward mode="nat">` ← NAT mode enabled
- `<bridge name="virbr0">` ← Bridge name
- `<dhcp>` range ← DHCP range defined

**If network missing:**

- See [`../docs/networking.md`](../docs/networking.md) for recreation steps

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

## Drill 2: Check virbr0 Interface

**Command:**

```bash
ip a show virbr0
```

**Expected output:**

```
3: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
    inet 192.168.122.1/24 brd 192.168.122.255 ...
```

**What to verify:**

- Interface exists
- Has IP address (typically `192.168.122.1`)
- State is `UP`

**If interface missing:**

```bash
sudo virsh net-start default
```

**Learn more:** [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)

---

## Drill 3: Verify Firewall Rules

**Command:**

```bash
sudo ufw status verbose
```

**What to look for:**

- Rules allowing `virbr0` traffic
- Route rules for VM traffic

**If rules missing:**

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
sudo ufw route allow in on virbr0 out on <HOST_IFACE>
sudo ufw reload
```

**Learn more:**

- [`../../shell-commands/02-commands/ufw.md`](../../shell-commands/02-commands/ufw.md)
- [`../docs/networking.md`](../docs/networking.md)

---

## Drill 4: Test Guest DHCP (Inside VM)

**Step 1: Discover interface name**

Inside the VM:

```bash
ip -o link show | awk -F': ' '{print $2}'
```

**Expected:** Should show non-loopback interface (e.g., `enp1s0`, `eth0`, `ens3`)

**Step 2: Check IP address**

```bash
ip a
```

**Expected:** Should show IP address in `192.168.122.x/24` range

**If no IP:**

- Check default network: `virsh net-list --all` (on host)
- Check firewall rules (on host)
- See [`../docs/networking.md`](../docs/networking.md)

**Learn more:** [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)

---

## Drill 5: Verify DNS (Inside VM)

**Command:**

```bash
resolvectl status
```

**Expected:** Should show DNS server (typically `192.168.122.1`)

**If DNS missing:**

- DHCP not completing
- Check firewall rules (on host)
- Check default network (on host)

**Learn more:** [`../../shell-commands/02-commands/resolvectl.md`](../../shell-commands/02-commands/resolvectl.md)

---

## Drill 6: Test Connectivity (Inside VM)

**Step 1: Ping IP address**

```bash
ping -c 3 8.8.8.8
```

**Expected:** Should receive replies

**If fails:**

- Check firewall rules (on host)
- Check default network (on host)

**Step 2: Ping domain name**

```bash
ping -c 3 google.com
```

**Expected:** Should resolve and receive replies

**If fails:**

- DNS issue (check `resolvectl status`)
- Firewall blocking DNS

**Step 3: Test HTTP**

```bash
curl http://archive.ubuntu.com
```

**Expected:** Should download content

**If fails:**

- Firewall blocking HTTP/HTTPS
- Check UFW routed traffic rules

**Learn more:**

- [`../../shell-commands/02-commands/ping.md`](../../shell-commands/02-commands/ping.md)
- [`../../shell-commands/02-commands/curl.md`](../../shell-commands/02-commands/curl.md)

---

## Drill 7: Test Package Manager (Inside VM)

**Command:**

```bash
sudo apt update
```

**Expected:** Should update package lists without hanging

**If hangs:**

- IPv6 issue (common in NAT)
- See [`../docs/networking.md`](../docs/networking.md) for IPv6 fix

**If fails with timeouts:**

- Firewall blocking HTTP/HTTPS
- Check UFW routed traffic rules

---

## Drill 8: Create NetworkManager Profile (Inside VM)

**Step 1: List existing profiles**

```bash
nmcli connection show
```

**Step 2: Delete conflicting profile (if needed)**

```bash
sudo nmcli connection delete "<existing-profile>"
```

**Step 3: Create new profile**

Replace `<VM_INTERFACE>` with actual interface name:

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <VM_INTERFACE> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**Step 4: Activate profile**

```bash
sudo nmcli connection up kvm-dhcp
```

**Step 5: Verify**

```bash
ip a
```

Should show IP address.

**Learn more:**

- [`../../shell-commands/02-commands/nmcli.md`](../../shell-commands/02-commands/nmcli.md)
- [`../docs/networking.md`](../docs/networking.md)

---

## Verification Checklist

After completing all drills, verify:

- [ ] Default network active and configured correctly
- [ ] virbr0 interface exists and has IP
- [ ] Firewall rules allow VM traffic
- [ ] Guest VM gets IP via DHCP
- [ ] DNS resolves correctly
- [ ] Internet connectivity works
- [ ] Package manager works without hanging

**If all checks pass:** Your VM networking is configured correctly!

**If any check fails:** See [`../docs/troubleshooting.md`](../docs/troubleshooting.md)

---

## Next Steps

- **Performance issues?** → [`performance-drills.md`](performance-drills.md)
- **Want to master virsh?** → [`virsh-drills.md`](virsh-drills.md)
