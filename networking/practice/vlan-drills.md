# VLAN Drills (Understanding Isolation)

Prerequisite reading:

- [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)
- [`../docs/nat-firewalls.md`](../docs/nat-firewalls.md)

---

## Drill V1: Identify VLAN Membership from Network Config

**Scenario:** Router configuration

```
Interface: eth0 (LAN)
VLAN ID: 10
Subnet: 192.168.0.0/24
Gateway: 192.168.0.1

Interface: wlan1 (Guest Wi-Fi)
VLAN ID: 50
Subnet: 192.168.50.0/24
Gateway: 192.168.50.1
```

**Questions:**

1. What VLAN is device `192.168.0.42` in?

   - Answer: VLAN 10 (matches `192.168.0.0/24` subnet)

2. What VLAN is device `192.168.50.20` in?

   - Answer: VLAN 50 (matches `192.168.50.0/24` subnet)

3. Can `192.168.0.42` directly communicate with `192.168.50.20`?
   - Answer: No - different VLANs (different subnets)

**Key concept:** VLAN membership determined by subnet/IP address assignment.

---

## Drill V2: Predict Isolation Behavior

**Scenario:** Network setup

- **LAN:** VLAN 10, `192.168.0.0/24`
- **Guest:** VLAN 50, `192.168.50.0/24`
- **Pi-hole:** `192.168.0.109` (LAN)

**Firewall rules:**

- Allow LAN → LAN
- Allow guest → internet
- Block guest → LAN

**Questions:**

1. **LAN device (`192.168.0.42`) → Pi-hole (`192.168.0.109`):**

   - Same VLAN? Yes (both VLAN 10)
   - Same subnet? Yes (`192.168.0.0/24`)
   - Firewall rule? Allow LAN → LAN
   - **Result:** ✅ Allowed

2. **Guest device (`192.168.50.20`) → Internet (`8.8.8.8`):**

   - Same VLAN? No (guest is VLAN 50, internet is external)
   - Same subnet? No (`192.168.50.0/24` vs internet)
   - Firewall rule? Allow guest → internet
   - **Result:** ✅ Allowed

3. **Guest device (`192.168.50.20`) → Pi-hole (`192.168.0.109`):**
   - Same VLAN? No (guest is VLAN 50, Pi-hole is VLAN 10)
   - Same subnet? No (`192.168.50.0/24` vs `192.168.0.0/24`)
   - Firewall rule? Block guest → LAN
   - **Result:** ❌ Blocked

**Key concept:** VLAN isolation enforced by firewall rules (routing allows, firewall blocks).

---

## Drill V3: Understand Guest Network Limitations

**Scenario:** Guest device on Wi-Fi network "GuestWiFi"

**Device configuration:**

- IP: `192.168.50.20/24`
- Gateway: `192.168.50.1`
- DNS: `192.168.0.109` (Pi-hole on LAN)

**Questions:**

1. **Can guest device reach internet?**

   - Answer: ✅ Yes - firewall allows guest → internet
   - Routing: Default route forwards to WAN

2. **Can guest device reach Pi-hole DNS?**

   - Answer: ❌ No - firewall blocks guest → LAN
   - Even though DNS is configured, packets are blocked

3. **What happens when guest device tries DNS query?**

   - Device sends DNS query to `192.168.0.109:53`
   - Router receives packet (guest → LAN)
   - Firewall checks: Block guest → LAN → **DROP**
   - DNS query fails (timeout)

4. **How to fix?**
   - Option 1: Move Pi-hole to guest network (not recommended)
   - Option 2: Allow guest → Pi-hole firewall rule (if router supports)
   - Option 3: Use guest network DNS that's accessible (not Pi-hole)

**Key concept:** Guest network isolation prevents access to LAN services (by design).

---

## Drill V4: VLAN Tag Flow (Access vs Trunk Ports)

**Scenario:** Network topology

```
Laptop (VLAN 10)
    ↓
Access Port (untagged)
    ↓
Switch
    ↓
Trunk Port (tagged)
    ↓
Router
```

**Questions:**

1. **Laptop sends frame:**

   - Frame: Untagged (normal Ethernet)
   - Switch receives on access port (VLAN 10)
   - Switch adds VLAN tag (VID=10) internally
   - **Result:** Frame tagged with VID=10

2. **Frame crosses trunk port:**

   - Switch forwards tagged frame (VID=10) to trunk port
   - Router receives tagged frame
   - Router reads VLAN tag (VID=10)
   - **Result:** Router knows frame belongs to VLAN 10

3. **Frame returns to laptop:**
   - Router sends tagged frame (VID=10) to trunk port
   - Switch receives tagged frame
   - Switch forwards to VLAN 10 access port
   - Switch removes VLAN tag before sending
   - **Result:** Laptop receives untagged frame

**Key concept:** Access ports add/remove tags, trunk ports preserve tags.

---

## Drill V5: Multiple VLANs on Same Physical Network

**Scenario:** Router with multiple VLANs

```
Physical Interface: eth0
    ├── VLAN 10 (LAN): 192.168.0.0/24
    ├── VLAN 20 (IoT): 192.168.20.0/24
    └── VLAN 50 (Guest): 192.168.50.0/24
```

**Firewall rules:**

- Allow LAN → IoT
- Block IoT → LAN
- Block guest → LAN
- Block guest → IoT

**Questions:**

1. **LAN device (`192.168.0.42`) → IoT device (`192.168.20.10`):**

   - Different VLANs? Yes (VLAN 10 vs VLAN 20)
   - Firewall rule? Allow LAN → IoT
   - **Result:** ✅ Allowed

2. **IoT device (`192.168.20.10`) → LAN device (`192.168.0.42`):**

   - Different VLANs? Yes (VLAN 20 vs VLAN 10)
   - Firewall rule? Block IoT → LAN
   - **Result:** ❌ Blocked

3. **Guest device (`192.168.50.20`) → IoT device (`192.168.20.10`):**
   - Different VLANs? Yes (VLAN 50 vs VLAN 20)
   - Firewall rule? Block guest → IoT
   - **Result:** ❌ Blocked

**Key concept:** Multiple VLANs on same physical interface, isolation enforced by firewall.

---

## Drill V6: Troubleshooting VLAN Isolation Issues

**Scenario:** Device `192.168.0.42` cannot reach `192.168.0.109`

**Possible causes:**

1. **Same VLAN, same subnet:**

   - Check: `ip -4 a` (both should be `192.168.0.0/24`)
   - If yes: Should work (direct delivery)
   - If no: Different subnets → routing issue

2. **Different VLANs:**

   - Check: Device IPs and subnets
   - If different VLANs: Check firewall rules
   - Firewall may block inter-VLAN communication

3. **Firewall blocking:**

   - Check router firewall rules
   - Verify inter-VLAN rules allow communication
   - Test: `ping` from one device to other

4. **Routing issue:**
   - Check router routing table
   - Verify routes exist for both VLANs
   - Check gateway configuration

**Diagnostic steps:**

```bash
# Check device IP and subnet
ip -4 a

# Test reachability
ping -c 1 <destination-ip>

# Check routing table
ip route

# Check firewall rules (if accessible)
# Router UI or CLI
```

**Key concept:** VLAN isolation issues can be routing, firewall, or configuration problems.

---

## Next Steps

- Understand routing: [`routing-drills.md`](routing-drills.md)
- Learn firewall concepts: [`../docs/nat-firewalls.md`](../docs/nat-firewalls.md)
