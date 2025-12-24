# OEM Telemetry Domains + Pi-hole Regex Deny (Examples)

Use this as a starter set. Treat it like a hypothesis list:

- **Verify with Pi-hole Query Log / PCAPdroid before blocking:** Confirm domains are actually being queried
- **Understand what you might break:** Vendor cloud, OTA updates, app stores may stop working

## What Are OEM Domains?

### Definition

**OEM domains** are domain names used by device manufacturers (Original Equipment Manufacturers) for their services, telemetry, and cloud infrastructure.

### Why OEM Domains Exist

**The problem:** Vendors need to provide services and collect data, but users want privacy.

**Why vendors use domains:**

- **Cloud services:** Vendor cloud storage and sync
- **Telemetry:** Analytics and diagnostics data collection
- **OTA updates:** System update delivery
- **App stores:** Vendor-specific app distribution
- **Ecosystem lock-in:** Keep users in vendor ecosystem

**How domains work:**

- **Vendor controls domain:** Owns and operates domain
- **Apps connect to domain:** Vendor apps connect to vendor servers
- **Data transmission:** Data sent to vendor-controlled servers
- **User tracking:** Vendors can track users across services

**Real-world analogy:**

- **OEM domains = Vendor headquarters** (where vendor services live)
- **Apps = Employees** (connect to headquarters)
- **Data = Reports** (sent to headquarters)
- **Blocking = Cutting connection** (prevent data transmission)

### How Domain Blocking Works

**Step-by-step process:**

1. **Domain queried:** App tries to connect to `allawnos.com`
2. **DNS lookup:** Device queries DNS for domain IP address
3. **Pi-hole intercepts:** Pi-hole receives DNS query
4. **Blocking decision:** Pi-hole checks if domain is blocked
5. **Block or allow:** Pi-hole blocks (returns no IP) or allows (returns IP)
6. **Connection result:** App can't connect if blocked

**Pi-hole regex deny:**

- **Regex pattern:** Matches domain and subdomains
- **Format:** `(^|\\.)domain\\.tld$`
- **Effect:** Blocks `domain.tld` and all `*.domain.tld` subdomains
- **Result:** All connections to domain blocked

## OPPO / OnePlus / Realme (HeyTap Ecosystem)

### What Is HeyTap Ecosystem?

**HeyTap** is OPPO's ecosystem brand, used across OPPO, OnePlus, and Realme devices.

**Why it exists:**

- **Unified services:** Single ecosystem across brands
- **Cloud services:** Cloud storage and sync
- **App store:** Vendor app distribution
- **Telemetry:** Analytics and diagnostics

**Common domains you may see:**

**1. `heytapmobile.com`**

- **Purpose:** HeyTap mobile services, cloud sync, app store
- **What it does:** Handles cloud services, app store, user accounts
- **Telemetry:** Sends usage data, analytics
- **Impact:** Blocking may break cloud sync, app store

**2. `heytapdl.com`**

- **Purpose:** HeyTap download/CDN for updates and downloads
- **What it does:** Delivers app updates, system updates, downloads
- **Telemetry:** May send download statistics
- **Impact:** Blocking may break OTA updates, app downloads

**3. `allawnos.com`**

- **Purpose:** OPPO cloud services, weather, OTA updates, UX telemetry
- **What it does:** Cloud services, weather data, system updates, user experience tracking
- **Telemetry:** Sends extensive telemetry data
- **Impact:** Blocking may break cloud services, weather, updates

**Pi-hole "Regex deny" examples:**

**Block `heytapmobile.com` and all subdomains:**

```
(^|\\.)heytapmobile\\.com$
```

**What this matches:**

- `heytapmobile.com` ✅
- `api.heytapmobile.com` ✅
- `cloud.heytapmobile.com` ✅
- `store.heytapmobile.com` ✅

**Block `heytapdl.com` and all subdomains:**

```
(^|\\.)heytapdl\\.com$
```

**What this matches:**

- `heytapdl.com` ✅
- `cdn.heytapdl.com` ✅
- `download.heytapdl.com` ✅

**Block `allawnos.com` and all subdomains:**

```
(^|\\.)allawnos\\.com$
```

**What this matches:**

- `allawnos.com` ✅
- `api.allawnos.com` ✅
- `weather.allawnos.com` ✅
- `ota.allawnos.com` ✅

**Real-world example:**

**Pi-hole Query Log shows:**

```
Domain: allawnos.com (queried 50 times/hour)
Domain: api.allawnos.com (queried 30 times/hour)
Domain: weather.allawnos.com (queried 20 times/hour)
```

**Add regex deny:**

```
(^|\\.)allawnos\\.com$
```

**Result:**

- All `allawnos.com` queries blocked ✅
- All subdomain queries blocked ✅
- Telemetry stopped ✅

## Xiaomi / MIUI

### What Is MIUI?

**MIUI** is Xiaomi's custom Android skin, used on Xiaomi, Redmi, and POCO devices.

**Why it exists:**

- **Custom interface:** Xiaomi's UI design
- **Xiaomi services:** Integrated Xiaomi cloud and services
- **Telemetry:** Extensive analytics and tracking

**Common telemetry-style domains:**

**1. `tracking.miui.com`**

- **Purpose:** MIUI analytics and tracking
- **What it does:** Collects usage data, analytics, user behavior
- **Telemetry:** Sends extensive tracking data
- **Impact:** Blocking stops analytics, device still works

**2. `data.mistat.xiaomi.com`**

- **Purpose:** Xiaomi User Experience Program data collection
- **What it does:** Collects user experience data, diagnostics, usage statistics
- **Telemetry:** Sends user experience program data
- **Impact:** Blocking stops UX program data, may break some features

**Example regex deny:**

**Block `tracking.miui.com` and all subdomains:**

```
(^|\\.)tracking\\.miui\\.com$
```

**Block `mistat.xiaomi.com` and all subdomains:**

```
(^|\\.)mistat\\.xiaomi\\.com$
```

**Note:** Block `mistat.xiaomi.com`, not `xiaomi.com` (too broad, breaks legitimate services).

## Samsung / One UI (Examples)

### What Is One UI?

**One UI** is Samsung's custom Android skin, used on Samsung Galaxy devices.

**Why it exists:**

- **Samsung design:** Samsung's UI and features
- **Samsung services:** Integrated Samsung cloud and services
- **Advertising:** Samsung includes ads in some apps

**Samsung devices can include ads/analytics services.**

**A commonly referenced domain family is:**

**`samsungads.com`**

- **Purpose:** Samsung advertising and ad measurement
- **What it does:** Serves ads, tracks ad performance, measures ad effectiveness
- **Telemetry:** Sends ad-related data, user behavior for ads
- **Impact:** Blocking stops ads, improves privacy

**Example regex deny:**

**Block `samsungads.com` and all subdomains:**

```
(^|\\.)samsungads\\.com$
```

**⚠️ Important Note:** Samsung uses many `*.samsung.com` endpoints for legitimate services; don't blanket-block `samsung.com`.

**Why not block `samsung.com`:**

- **Too broad:** Blocks legitimate Samsung services
- **Breaks functionality:** Samsung account, cloud, updates may break
- **Use specific domains:** Block only telemetry domains, not all Samsung domains

**Safe to block:**

- ✅ `samsungads.com` (advertising)
- ✅ `samsungcloudsolution.com` (if not using cloud)
- ❌ `samsung.com` (too broad, breaks services)

## "Can Add More Regex for Other OEMs"

### Method for Finding New Domains

**If you have a different OEM device, you can find and block their telemetry domains.**

**Step-by-step method:**

**1. Find candidate domains in Pi-hole Query Log (or PCAPdroid).**

**How to find:**

- **Pi-hole Query Log:** Check for frequent domain queries
- **PCAPdroid:** Monitor network connections on device
- **Look for patterns:** Vendor-specific domain patterns
- **Check frequency:** Domains queried frequently are likely telemetry

**What to look for:**

- **Vendor domains:** Domains matching vendor name
- **High frequency:** Queried many times per hour
- **Consistent pattern:** Happening regularly, not random
- **Unknown purpose:** Domains you don't recognize

**2. Prefer blocking the base domain (and its subdomains) with:**

```
(^|\\.)domain\\.tld$
```

**Why block base domain:**

- **Catches all subdomains:** Blocks `domain.tld` and `*.domain.tld`
- **Future-proof:** Blocks new subdomains automatically
- **Simpler:** One regex instead of many

**Format explanation:**

- **`(^|\\.)`:** Matches start of string or dot (for subdomains)
- **`domain\\.tld`:** The domain name (escaped dots)
- **`$`:** End of string

**3. Validate: query volume should drop; device should remain stable.**

**How to validate:**

- **Check Pi-hole:** Query volume should drop to near zero
- **Test device:** Verify device still works correctly
- **Check features:** Ensure important features still work
- **Monitor:** Watch for issues over time

**Real-world example:**

**Step 1: Find domains in Pi-hole:**

```
Domain: vendor-telemetry.com (queried 40 times/hour)
Domain: api.vendor-telemetry.com (queried 20 times/hour)
Domain: tracking.vendor-telemetry.com (queried 30 times/hour)
```

**Step 2: Add regex deny:**

```
(^|\\.)vendor-telemetry\\.com$
```

**Step 3: Validate:**

- ✅ Pi-hole shows queries dropped to 0/hour
- ✅ Device still works normally
- ✅ No broken features
- ✅ Telemetry stopped ✅

## Related Reading

- **Enforcement patterns / bypass prevention:** [`../../pi-hole/docs/hardcoded-dns.md`](../../pi-hole/docs/hardcoded-dns.md) - Learn how to prevent DNS bypass
- **DNS fundamentals:** [`../../networking/docs/dns.md`](../../networking/docs/dns.md) - Understand how DNS works
