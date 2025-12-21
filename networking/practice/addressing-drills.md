# Addressing Drills (IP, Subnet, Gateway)

These drills make IP addressing feel concrete.

Prerequisite reading:

- [`../docs/ip-addressing.md`](../docs/ip-addressing.md)

---

## Drill A1: Find your IP and prefix/subnet

### Linux

Learn: [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)

```bash
ip -4 a
```

Goal: find `inet X.Y.Z.W/NN`.

### Windows

Learn: [`../../shell-commands/02-commands/ipconfig.md`](../../shell-commands/02-commands/ipconfig.md)

```bat
ipconfig /all
```

Goal: identify:

- IPv4 Address
- Subnet Mask

---

## Drill A2: Find your default gateway

### Linux

```bash
ip -4 r
```

Goal: find `default via <gateway>`.

### Windows

In `ipconfig /all`, find **Default Gateway**.

---

## Drill A3: Prove “same subnet” intuition

If your device is `192.168.0.42/24`, your “local neighborhood” is `192.168.0.0/24`.

Pick a local IP (router or Pi-hole) and test:

```bash
ping -c 1 192.168.0.1
```

If this fails on Wi‑Fi but works on Ethernet, you may be on a guest network.

See: [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)
