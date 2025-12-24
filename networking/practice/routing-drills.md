# Routing Drills (Understanding Forwarding Decisions)

Prerequisite reading:

- [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)
- [`../docs/ip-addressing.md`](../docs/ip-addressing.md)

---

## Drill R1: Read Routing Table and Predict Forwarding

**Scenario:** Router has the following routing table:

```
Destination        Gateway          Interface
192.168.0.0/24     -               eth0
192.168.50.0/24    -               wlan1
10.8.0.0/24        10.8.0.1         tun0
0.0.0.0/0          203.0.113.1      eth1
```

**Questions:**

1. Where will a packet to `192.168.0.42` be forwarded?

   - Answer: `eth0` (matches `/24` route, directly connected)

2. Where will a packet to `8.8.8.8` be forwarded?

   - Answer: `eth1` via gateway `203.0.113.1` (matches default route `/0`)

3. Where will a packet to `10.8.0.5` be forwarded?

   - Answer: `tun0` via gateway `10.8.0.1` (matches `/24` route)

4. Where will a packet to `192.168.50.20` be forwarded?
   - Answer: `wlan1` (matches `/24` route, directly connected)

**Key concept:** Longest prefix match - most specific route wins.

---

## Drill R2: Identify Why Packet Can't Reach Destination

**Scenario:** Laptop (`192.168.0.42`) cannot reach `192.168.1.100`

**Router routing table:**

```
Destination        Gateway          Interface
192.168.0.0/24     -               eth0
0.0.0.0/0          203.0.113.1      eth1
```

**Analysis:**

1. **Laptop checks routing:**

   - Destination: `192.168.1.100`
   - Not in `192.168.0.0/24` (laptop's subnet)
   - Matches default route → send to gateway `192.168.0.1`

2. **Router receives packet:**

   - Destination: `192.168.1.100`
   - Checks routing table:
     - Doesn't match `192.168.0.0/24` (LAN)
     - Matches default route `0.0.0.0/0` → forward to WAN

3. **Problem:**
   - Router forwards packet to internet (WAN)
   - But `192.168.1.100` is private IP (not routable on internet)
   - Packet will be dropped by ISP router

**Solution:** Add route for `192.168.1.0/24` if that network exists, or fix destination IP.

---

## Drill R3: Understand Default Route Behavior

**Scenario:** Device routing table:

```
Destination        Gateway          Interface
192.168.0.0/24     -               eth0
0.0.0.0/0          192.168.0.1      eth0
```

**Questions:**

1. Where does packet to `192.168.0.109` go?

   - Answer: Direct delivery via `eth0` (same subnet, no gateway needed)

2. Where does packet to `8.8.8.8` go?

   - Answer: Gateway `192.168.0.1` via `eth0` (default route)

3. What happens if gateway `192.168.0.1` is unreachable?

   - Answer: Packets to internet fail (cannot reach gateway)

4. What happens if gateway `192.168.0.1` is in different subnet?
   - Answer: ARP fails, packets cannot reach gateway, internet fails

**Key concept:** Default route is "catch-all" for destinations not matching specific routes.

---

## Drill R4: Multi-Hop Routing Path

**Scenario:** Trace packet path from home device to internet server

**Network topology:**

```
Home Device (192.168.0.42)
    ↓
Home Router (192.168.0.1)
    ↓
ISP Router (203.0.113.1)
    ↓
Internet (93.184.216.34)
```

**Questions:**

1. **Home device routing decision:**

   - Destination: `93.184.216.34`
   - Not in `192.168.0.0/24`
   - Default route → gateway `192.168.0.1`

2. **Home router routing decision:**

   - Destination: `93.184.216.34`
   - Not in local subnets
   - Default route → gateway `203.0.113.1` (WAN)

3. **ISP router routing decision:**
   - Uses internet routing tables
   - Forwards toward destination network

**Key concept:** Each router makes independent routing decision based on its own routing table.

---

## Drill R5: Gateway Selection Logic

**Scenario:** Device configuration

- Device IP: `192.168.0.42/24`
- Gateway: `192.168.1.1` (wrong - different subnet)

**Questions:**

1. Can device reach gateway?

   - Answer: No - gateway is in different subnet (`192.168.1.0/24`)

2. What happens when device tries to reach internet?

   - Answer: Device tries to send packet to gateway `192.168.1.1`
   - ARP fails (gateway not in same subnet)
   - Packet cannot be sent → internet fails

3. What should gateway be?
   - Answer: `192.168.0.1` (same subnet as device)

**Key concept:** Gateway must be in same subnet as device (for ARP to work).

---

## Drill R6: Routing vs Firewall Interaction

**Scenario:** Guest device (`192.168.50.20`) tries to reach Pi-hole (`192.168.0.109`)

**Router routing table:**

```
Destination        Gateway          Interface
192.168.0.0/24     -               eth0
192.168.50.0/24    -               wlan1
0.0.0.0/0          203.0.113.1      eth1
```

**Router firewall rules:**

- Allow guest → internet
- Block guest → LAN

**Questions:**

1. **Routing decision:**

   - Destination: `192.168.0.109`
   - Matches `192.168.0.0/24` route → forward to `eth0`

2. **Firewall decision:**

   - Source: `192.168.50.20` (guest)
   - Destination: `192.168.0.109` (LAN)
   - Rule: Block guest → LAN → **DROP**

3. **Result:**
   - Routing says "forward to LAN"
   - Firewall says "block"
   - **Packet dropped** (firewall overrides routing)

**Key concept:** Routing determines WHERE to forward, firewall determines IF forwarding is allowed.

---

## Next Steps

- Practice with real routing tables: [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)
- Understand VLANs: [`vlan-drills.md`](vlan-drills.md)
