# OEM telemetry domains + Pi-hole regex deny (examples)

Use this as a starter set. Treat it like a hypothesis list:

- verify with Pi-hole Query Log / PCAPdroid before blocking
- understand what you might break (vendor cloud, OTA updates, app stores)

## OPPO / OnePlus / Realme (HeyTap ecosystem)

Common domains you may see:

- `heytapmobile.com`
- `heytapdl.com`
- `allawnos.com`

Pi-hole “Regex deny” examples:

- `(^|\\.)heytapmobile\\.com$`
- `(^|\\.)heytapdl\\.com$`
- `(^|\\.)allawnos\\.com$`

## Xiaomi / MIUI

Common telemetry-style domains:

- `tracking.miui.com`
- `data.mistat.xiaomi.com`

Example regex deny:

- `(^|\\.)tracking\\.miui\\.com$`
- `(^|\\.)mistat\\.xiaomi\\.com$`

## Samsung / One UI (examples)

Samsung devices can include ads/analytics services. A commonly referenced domain family is:

- `samsungads.com`

Example regex deny:

- `(^|\\.)samsungads\\.com$`

Note: Samsung uses many `*.samsung.com` endpoints for legitimate services; don’t blanket-block `samsung.com`.

## “Can add more regex for other OEMs”

Method:

1. Find candidate domains in Pi-hole Query Log (or PCAPdroid).
2. Prefer blocking the base domain (and its subdomains) with:\n
   - `(^|\\.)domain\\.tld$`
3. Validate: query volume should drop; device should remain stable.

## Related reading

- Enforcement patterns / bypass prevention: `../../pi-hole/docs/hardcoded-dns.md`
- DNS fundamentals: `../../networking/docs/dns.md`
