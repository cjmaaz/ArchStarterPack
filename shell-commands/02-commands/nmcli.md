# nmcli - NetworkManager Command-Line Interface

`nmcli` is the command-line interface for NetworkManager. For VM setup, this is used to configure network connections inside guest VMs.

---

## 📋 Quick Reference

```bash
nmcli connection show              # List connections
nmcli connection show <name>      # Show connection details
nmcli connection add ...          # Create connection
nmcli connection delete <name>    # Delete connection
nmcli connection up <name>        # Activate connection
nmcli connection down <name>      # Deactivate connection
nmcli device status               # Show device status
```

---

## List Connections

```bash
nmcli connection show
```

**Output:**

```
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  abc12345-1234-1234-1234-123456789abc  ethernet  enp1s0
kvm-dhcp            def67890-5678-5678-5678-567890123def  ethernet  --
```

**What it shows:**

- Connection name
- UUID
- Type (ethernet, wifi, etc.)
- Device (interface name)

---

## Show Connection Details

```bash
nmcli connection show <connection-name>
```

**Example:**

```bash
nmcli connection show "Wired connection 1"
```

**Output:**

```
connection.id:                          Wired connection 1
connection.uuid:                        abc12345-1234-1234-1234-123456789abc
connection.type:                        802-3-ethernet
connection.interface-name:              enp1s0
ipv4.method:                           auto
ipv4.dns:                              192.168.122.1
ipv4.addresses:                        --
...
```

---

## Create Ethernet Connection

**For VM networking (most common use):**

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <interface-name> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**Example:**

```bash
sudo nmcli connection add \
  type ethernet \
  ifname enp1s0 \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**What it does:**

- Creates new ethernet connection
- Binds to specific interface (`ifname`)
- Uses DHCP for IPv4 (`ipv4.method auto`)
- Disables IPv6 (`ipv6.method ignore`)

**Why disable IPv6:**

- NAT IPv6 often broken
- Prevents package manager hangs
- See [`../../vm/docs/networking.md`](../../vm/docs/networking.md)

---

## Activate Connection

```bash
sudo nmcli connection up <connection-name>
```

**Example:**

```bash
sudo nmcli connection up kvm-dhcp
```

**What it does:**

- Activates the connection
- Requests DHCP (if configured)
- Brings interface up

**Verify:**

```bash
ip a
```

Should show IP address.

---

## Deactivate Connection

```bash
sudo nmcli connection down <connection-name>
```

**Example:**

```bash
sudo nmcli connection down kvm-dhcp
```

**What it does:**

- Deactivates the connection
- Brings interface down

---

## Delete Connection

```bash
sudo nmcli connection delete <connection-name>
```

**Example:**

```bash
sudo nmcli connection delete "Wired connection 1"
```

**What it does:**

- Deletes connection profile
- Does not affect the interface itself

**Useful for:**

- Removing conflicting profiles
- Cleaning up old connections

---

## Show Device Status

```bash
nmcli device status
```

**Output:**

```
DEVICE  TYPE      STATE      CONNECTION
enp1s0  ethernet  connected  kvm-dhcp
lo      loopback  unmanaged   --
```

**What it shows:**

- Device (interface) name
- Type
- State (connected, disconnected, etc.)
- Active connection

---

## Modify Connection

**Change IPv4 method:**

```bash
sudo nmcli connection modify <name> ipv4.method auto
```

**Set static IP:**

```bash
sudo nmcli connection modify <name> ipv4.method manual
sudo nmcli connection modify <name> ipv4.addresses 192.168.1.100/24
sudo nmcli connection modify <name> ipv4.gateway 192.168.1.1
```

**Set DNS:**

```bash
sudo nmcli connection modify <name> ipv4.dns "8.8.8.8 8.8.4.4"
```

---

## VM Context

### Configure Guest VM Networking

**Step 1: Discover interface name**

Inside VM:

```bash
ip -o link show | awk -F': ' '{print $2}'
```

**Step 2: Delete conflicting profile (if needed)**

```bash
sudo nmcli connection show
sudo nmcli connection delete "<existing-profile>"
```

**Step 3: Create DHCP profile**

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <VM_INTERFACE> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**Step 4: Activate**

```bash
sudo nmcli connection up kvm-dhcp
```

**Step 5: Verify**

```bash
ip a
resolvectl status
```

---

## Common Patterns

**List all devices:**

```bash
nmcli device
```

**Show device details:**

```bash
nmcli device show <device-name>
```

**Reload connections:**

```bash
sudo nmcli connection reload
```

**Restart NetworkManager:**

```bash
sudo systemctl restart NetworkManager
```

---

## Learn More

- **VM networking:** [`../../vm/docs/networking.md`](../../vm/docs/networking.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/networking-drills.md`](../../vm/practice/networking-drills.md)
