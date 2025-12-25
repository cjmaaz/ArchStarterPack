# Pi-hole Blocklists and Whitelists Guide

**Goal:** Enhance Pi-hole's blocking capabilities with well-maintained blocklists and prevent false positives with curated whitelists.

## What Are Blocklists and Whitelists?

### Blocklists (Blacklists)

**Definition:** **Blocklists** are lists of domains that Pi-hole will block, preventing DNS resolution for those domains. When a device tries to access a blocked domain, Pi-hole returns `0.0.0.0` instead of the real IP address.

**Why blocklists matter:**

- **Ad blocking:** Blocks ad-serving domains
- **Tracking prevention:** Blocks tracking and analytics domains
- **Malware protection:** Blocks malicious domains
- **Privacy:** Prevents data collection by blocking tracking domains

### Whitelists

**Definition:** **Whitelists** are lists of domains that Pi-hole will always allow, even if they appear in blocklists. This prevents false positives where legitimate services are accidentally blocked.

**Why whitelists matter:**

- **Prevent false positives:** Ensures legitimate services work
- **Fix broken websites:** Unblocks accidentally blocked domains
- **Maintain functionality:** Keeps essential services working

---

## Top Well-Maintained Blocklist Repositories

### 1. ShadowWhisperer BlockLists

**Repository:** [`https://github.com/ShadowWhisperer/BlockLists`](https://github.com/ShadowWhisperer/BlockLists)

**What it is:** A comprehensive collection of blocklists organized by category, regularly maintained and updated.

**How to use:**

1. **Navigate to repository:** Go to [`https://github.com/ShadowWhisperer/BlockLists`](https://github.com/ShadowWhisperer/BlockLists)
2. **Browse RAW folder:** Click on the `RAW` folder in the repository
3. **Select blocklist:** Choose the blocklist file you want (e.g., `ads.txt`, `tracking.txt`, `malware.txt`)
4. **Get raw URL:** Click on the file, then click the **"Raw"** button (top right of the file view)
5. **Copy raw URL:** Copy the raw GitHub URL (e.g., `https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/RAW/ads.txt`)
6. **Add to Pi-hole:** Paste URL in Pi-hole Admin → Group Management → Adlists → Add

**Available lists:**

- **Ads:** Advertising domains
- **Tracking:** Tracking and analytics domains
- **Malware:** Malicious domains
- **Phishing:** Phishing domains
- **And more:** Various other categories

**Why this repository:**

- **Well-maintained:** Regularly updated
- **Organized:** Clear categorization
- **Multiple formats:** Available in different formats
- **Community-driven:** Active maintenance

**Example raw URL format:**

```
https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/RAW/ads.txt
```

**Important:** Always use the **Raw** button to get the direct file URL. The regular GitHub file view URL won't work with Pi-hole.

### 2. Firebog (The Big Blocklist Collection)

**Website:** [`https://firebog.net/`](https://firebog.net/)

**What it is:** A curated collection of blocklists from various maintainers, categorized by type (Suspicious, Advertising, Tracking & Telemetry, Malicious, etc.).

**How to use:**

1. **Visit Firebog:** Go to [`https://firebog.net/`](https://firebog.net/)
2. **Browse categories:** Review lists in different categories:
   - **Suspicious Lists:** Spam, suspicious domains
   - **Advertising Lists:** Ad-serving domains
   - **Tracking & Telemetry Lists:** Tracking and analytics
   - **Malicious Lists:** Malware, phishing, scams
3. **Check status:** Lists marked with ✅ (green checkmark) are least likely to cause false positives
4. **Avoid deprecated:** Lists with strikethrough are deprecated or have high false positives
5. **Copy URL:** Click on a list to get its URL
6. **Add to Pi-hole:** Paste URL in Pi-hole Admin → Group Management → Adlists → Add

**Recommended lists (Ticked - low false positives):**

**Suspicious Lists:**

- **PolishFiltersTeam KADhosts:** [`https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt`](https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt)
- **Someone Who Cares:** [`https://someonewhocares.org/hosts/zero/hosts`](https://someonewhocares.org/hosts/zero/hosts)
- **Winhelp2002 MVPS:** [`https://winhelp2002.mvps.org/hosts.txt`](https://winhelp2002.mvps.org/hosts.txt)

**Advertising Lists:**

- **AdAway:** [`https://adaway.org/hosts.txt`](https://adaway.org/hosts.txt)
- **Adguard DNS:** [`https://v.firebog.net/hosts/AdguardDNS.txt`](https://v.firebog.net/hosts/AdguardDNS.txt)
- **Easylist:** [`https://v.firebog.net/hosts/Easylist.txt`](https://v.firebog.net/hosts/Easylist.txt)
- **Peter Lowe's Adservers:** [`https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext`](https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext)

**Tracking & Telemetry Lists:**

- **Easyprivacy:** [`https://v.firebog.net/hosts/Easyprivacy.txt`](https://v.firebog.net/hosts/Easyprivacy.txt)
- **Perflyst's Android Trackers:** [`https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt`](https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt)
- **Perflyst's SmartTV Domains:** [`https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt`](https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt)

**Malicious Lists:**

- **Phishing Army's Extended Blocklist:** [`https://phishing.army/download/phishing_army_blocklist_extended.txt`](https://phishing.army/download/phishing_army_blocklist_extended.txt)
- **URLhaus Malicious URL blocklist:** [`https://urlhaus.abuse.ch/downloads/hostfile/`](https://urlhaus.abuse.ch/downloads/hostfile/)
- **RPiList Malware:** [`https://v.firebog.net/hosts/RPiList-Malware.txt`](https://v.firebog.net/hosts/RPiList-Malware.txt)
- **RPiList Phishing:** [`https://v.firebog.net/hosts/RPiList-Phishing.txt`](https://v.firebog.net/hosts/RPiList-Phishing.txt)

**Why Firebog:**

- **Curated:** Carefully selected lists
- **Categorized:** Easy to find what you need
- **Status indicators:** Shows which lists are safe to use
- **Comprehensive:** Covers all categories

**Note:** Firebog also provides URL-only and CSV versions for automation. See [`https://v.firebog.net/hosts/lists.php`](https://v.firebog.net/hosts/lists.php) for automated list management.

### 3. Pi-hole Optimized Blocklists (zachlagden)

**Repository:** [`https://github.com/zachlagden/Pi-hole-Optimized-Blocklists`](https://github.com/zachlagden/Pi-hole-Optimized-Blocklists)

**What it is:** Pre-optimized, deduplicated blocklists updated weekly via GitHub Actions.

**Available lists:**

- **all_domains.txt:** Everything combined (except NSFW) - 2,107,526 domains
- **advertising.txt:** Ad networks & services - 203,000 domains
- **tracking.txt:** Analytics & telemetry - 510,543 domains
- **malicious.txt:** Malware, phishing, scams - 1,124,324 domains
- **suspicious.txt:** Potentially unwanted - 72,918 domains
- **comprehensive.txt:** Curated multi-category - 594,204 domains
- **nsfw.txt:** Adult content (separate) - 4,892,525 domains

**How to use:**

1. **Choose list:** Select the list that fits your needs
2. **Get raw URL:** Use the raw GitHub URL format:
   ```
   https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/advertising.txt
   ```
3. **Add to Pi-hole:** Paste URL in Pi-hole Admin → Group Management → Adlists → Add

**Why this repository:**

- **Pre-optimized:** Already deduplicated and optimized
- **Regular updates:** Updated weekly automatically
- **Large lists:** Comprehensive coverage
- **Categorized:** Easy to choose what you need

**Recommendation:** Start with `comprehensive.txt` for a good balance, or `all_domains.txt` for maximum blocking (may cause false positives).

### 4. Tempest Solutions Blocklists

**Repository:** [`https://github.com/Tempest-Solutions-Company/pihole_blocklists`](https://github.com/Tempest-Solutions-Company/pihole_blocklists)

**What it is:** Automatically generated blocklists from multiple threat intelligence sources, updated every 24 hours.

**Available lists:**

- **Phishing:** 817,376 domains
- **Malware:** 25,176 domains
- **C2 Servers:** 51,755 domains
- **Banking Trojan:** 7,743 domains
- **All Malicious:** 888,429 domains (combined)

**How to use:**

1. **Get raw URL:** Use format:
   ```
   https://raw.githubusercontent.com/Tempest-Solutions-Company/pihole_blocklists/main/phishing.txt
   ```
2. **Add to Pi-hole:** Paste URL in Pi-hole Admin → Group Management → Adlists → Add

**Why this repository:**

- **Threat intelligence:** Based on real threat data
- **Frequent updates:** Updated every 24 hours
- **Low false positives:** <0.01% false positive rate
- **Security-focused:** Focuses on security threats

### 5. Block List Project

**Website:** [`https://blocklistproject.github.io/Lists/`](https://blocklistproject.github.io/Lists/)

**What it is:** Curated domain blocklists for various categories, available in multiple formats (Pi-hole, AdGuard, dnsmasq).

**Available lists:**

- **Ads:** Ad servers
- **Malware:** Malware hosts
- **Phishing:** Phishing sites
- **Tracking:** Tracking/analytics
- **Crypto:** Cryptojacking/crypto scams
- **And more:** 20+ categories

**How to use:**

1. **Visit website:** Go to [`https://blocklistproject.github.io/Lists/`](https://blocklistproject.github.io/Lists/)
2. **Choose list:** Select the list you want
3. **Get URL:** Use the "Original" link for Pi-hole format
4. **Add to Pi-hole:** Paste URL in Pi-hole Admin → Group Management → Adlists → Add

**Why this repository:**

- **Multiple formats:** Available in different formats
- **Well-maintained:** Regularly updated
- **Community-driven:** Community contributions
- **Categorized:** Clear organization

### 6. Other Well-Maintained Repositories

**r0xd4n3t/pihole-adblock-lists:**

- **Repository:** [`https://github.com/r0xd4n3t/pihole-adblock-lists`](https://github.com/r0xd4n3t/pihole-adblock-lists)
- **What it is:** Consolidated list of adblock lists, automatically updated daily
- **Raw URL:** `https://raw.githubusercontent.com/r0xd4n3t/pihole-adblock-lists/main/pihole_adlists.txt`

**stevejenkins/pi-hole-lists:**

- **Repository:** [`https://github.com/stevejenkins/pi-hole-lists`](https://github.com/stevejenkins/pi-hole-lists)
- **What it is:** Personal collection of blocklists, whitelists, and regex expressions
- **Note:** Includes blocklists, whitelists, and regex patterns

**ultimate-pihole-list/list:**

- **Repository:** [`https://github.com/ultimate-pihole-list/list`](https://github.com/ultimate-pihole-list/list)
- **What it is:** Collection of pihole lists (blacklist and whitelist)
- **Note:** Includes both blocklists and whitelists

---

## How to Add Blocklists to Pi-hole

### Method 1: Using Pi-hole Admin Web Interface

**Step-by-step:**

1. **Access admin interface:** Open `http://<pi-ip>/admin` in your browser
2. **Login:** Enter your admin password
3. **Navigate:** Go to **Group Management** → **Adlists**
4. **Add list:** Click **"Add"** button
5. **Enter URL:** Paste the raw blocklist URL
6. **Add comment (optional):** Add a comment to identify the list (e.g., "Firebog - Ads")
7. **Save:** Click **"Add"** to save
8. **Update Gravity:** Go to **Tools** → **Update Gravity** to download and apply the list

**What happens:**

- **Pi-hole downloads:** Pi-hole fetches the blocklist from the URL
- **Parses domains:** Extracts domain names from the list
- **Adds to database:** Adds domains to Pi-hole's blocklist database
- **Applies immediately:** Blocking takes effect after Gravity update

**Real-world example:**

**Adding Firebog AdAway list:**

1. **URL:** `https://adaway.org/hosts.txt`
2. **Comment:** "Firebog - AdAway"
3. **Add:** Click "Add"
4. **Update Gravity:** Tools → Update Gravity
5. **Result:** AdAway domains now blocked ✅

### Method 2: Using Command Line

**For advanced users:**

```bash
# Add blocklist URL
pihole -a -t <blocklist-url>

# Update Gravity (download and apply lists)
pihole -g
```

**What this does:**

- **`pihole -a -t`:** Adds blocklist URL to Pi-hole configuration
- **`pihole -g`:** Updates Gravity (downloads and applies blocklists)

**Example:**

```bash
pihole -a -t https://adaway.org/hosts.txt
pihole -g
```

**Note:** Command-line method is less common. Web interface is recommended for most users.

---

## Recommended Whitelists

### 1. anudeepND Whitelist (Most Popular)

**Repository:** [`https://github.com/anudeepND/whitelist`](https://github.com/anudeepND/whitelist)

**What it is:** A robust collection of commonly whitelisted websites, curated from Pi-hole subreddit, forum, and GitHub repository.

**Available files:**

- **whitelist.txt:** Safe domains (no tracking/ads) - 191 domains
- **referral-sites.txt:** Analytics/ad sites needed for referral services - 75 domains
- **optional-list.txt:** Service-specific domains - varies

**How to use:**

**Method 1: Automated script (recommended):**

```bash
# Clone repository
git clone https://github.com/anudeepND/whitelist.git

# Add whitelist.txt domains
sudo python3 whitelist/scripts/whitelist.py

# Add referral-sites.txt domains (if needed)
cd whitelist/scripts
sudo ./referral.sh
```

**What the script does:**

- **Reads domains:** Reads domains from whitelist file
- **Adds to Pi-hole:** Adds domains to Pi-hole whitelist
- **Adds comments:** Adds comments identifying the source
- **Unique identifier:** Uses `qjz9zk` identifier for easy removal

**Method 2: Manual addition:**

1. **Get raw URL:** Use raw GitHub URL:
   ```
   https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt
   ```
2. **Add to Pi-hole:** Pi-hole Admin → Group Management → Whitelist → Add
3. **Note:** Pi-hole doesn't support whitelist URLs directly. You'll need to add domains manually or use the script.

**Why this whitelist:**

- **Most popular:** 4.4k+ stars on GitHub
- **Well-maintained:** Regularly updated
- **Curated:** Carefully selected domains
- **Categorized:** Different files for different needs

**Uninstall:**

```bash
# Remove domains added by script
sudo python3 whitelist/scripts/uninstall.py
```

**What this does:**

- **Finds domains:** Finds domains with `qjz9zk` identifier
- **Removes:** Removes domains from Pi-hole whitelist
- **Safe:** Only removes domains added by the script

### 2. Firebog Whitelisting Suggestions

**Source:** [`https://firebog.net/`](https://firebog.net/) (Whitelisting Suggestions section)

**Common whitelist domains:**

**Link Shorteners (Openphish):**

- `t.ly`
- `www.bit.ly`
- `bit.ly`
- `ow.ly`
- `tinyurl.com`

**EA / Origin (AdAway):**

- `cdn.optimizely.com` (Used by Origin for content delivery)
- `split.io` (Used by EA Desktop - Missing download button fix)

**Blocked by various lists:**

- `s.shopify.com`

**How to add:**

**Using Pi-hole command line:**

```bash
# Add single domain
pihole -w domain.com

# Add multiple domains
pihole -w domain1.com domain2.com domain3.com
```

**Using web interface:**

1. **Navigate:** Pi-hole Admin → Group Management → Whitelist
2. **Add domain:** Enter domain name
3. **Add comment (optional):** Add comment explaining why
4. **Save:** Click "Add"

**Real-world example:**

**Fixing EA Desktop download button:**

```bash
pihole -w split.io
```

**Result:** EA Desktop download button now works ✅

### 3. Other Useful Whitelist Sources

**Commonly Whitelisted Domains (Pi-hole Forum):**

- **Source:** [`https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212`](https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212)
- **What it is:** Community-maintained list of commonly whitelisted domains
- **How to use:** Review forum post, add domains manually as needed

**rahilpathan/pihole-whitelist:**

- **Repository:** [`https://github.com/rahilpathan/pihole-whitelist`](https://github.com/rahilpathan/pihole-whitelist)
- **What it is:** Curated Pi-hole whitelist organized by priority
- **Files:** `1.LowWL.txt`, `2.MediumWL.txt`, `3.HighWL.txt`, `4.VeryHighWL.txt`

---

## Best Practices

### Blocklist Selection

**Start conservative:**

- **Begin with ticked lists:** Use Firebog's ticked (✅) lists first
- **Test gradually:** Add lists one at a time
- **Monitor:** Watch for false positives
- **Expand:** Add more lists as needed

**Recommended starting set:**

1. **Firebog ticked lists:** Start with these (low false positives)
2. **ShadowWhisperer:** Add specific categories as needed
3. **Pi-hole Optimized:** Use `comprehensive.txt` for balance

**Avoid:**

- **Deprecated lists:** Don't use strikethrough lists from Firebog
- **Too many lists:** Don't add everything at once
- **Unmaintained lists:** Check last update date

### Whitelist Management

**When to whitelist:**

- **False positives:** Legitimate sites blocked
- **Broken functionality:** Services not working
- **Essential services:** Critical services need access

**How to identify false positives:**

1. **Check query log:** Pi-hole Admin → Query Log
2. **Look for blocked:** Find blocked queries for legitimate sites
3. **Test:** Try accessing the site
4. **Whitelist:** Add domain to whitelist if needed

**Common false positive scenarios:**

- **YouTube history:** `s.youtube.com` needs whitelisting
- **Google services:** Various Google domains may need whitelisting
- **Microsoft services:** Windows/Office domains may need whitelisting
- **Gaming:** Some game telemetry domains may need whitelisting

---

## Common Whitelist Examples

**What this section provides:** Concrete examples of domains commonly whitelisted to fix broken functionality or prevent false positives.

**Why these examples matter:**

- **Real-world scenarios:** Based on actual user experiences
- **Common issues:** Addresses frequently encountered problems
- **Quick reference:** Easy to find and apply solutions

### Google Services

**YouTube Watch History:**

- **Domain:** `s.youtube.com`
- **Service:** YouTube watch history tracking
- **Why whitelist:** Without this, YouTube watch history doesn't work
- **Command:** `pihole -w s.youtube.com`

**YouTube Statistics:**

- **Domain:** `video-stats.l.google.com`
- **Service:** YouTube video statistics
- **Why whitelist:** YouTube needs this for video analytics
- **Command:** `pihole -w video-stats.l.google.com`

**Google Maps & YouTube:**

- **Domain:** `clients4.google.com`
- **Service:** Google Maps, YouTube, other Google services
- **Why whitelist:** Required for Google Maps and YouTube functionality
- **Command:** `pihole -w clients4.google.com`

**Google Play Updates:**

- **Domain:** `android.clients.google.com`
- **Service:** Google Play Store updates
- **Why whitelist:** Required for Android app updates
- **Command:** `pihole -w android.clients.google.com`

**Google Keep:**

- **Domains:** `reminders-pa.googleapis.com`, `firestore.googleapis.com`
- **Service:** Google Keep notes synchronization
- **Why whitelist:** Required for Google Keep to sync notes
- **Command:** `pihole -w reminders-pa.googleapis.com firestore.googleapis.com`

**Google Fonts:**

- **Domain:** `gstaticadssl.l.google.com`
- **Service:** Google Fonts loading
- **Why whitelist:** Required for websites using Google Fonts
- **Command:** `pihole -w gstaticadssl.l.google.com`

**Gmail:**

- **Domain:** `googleapis.l.google.com`
- **Service:** Gmail functionality
- **Why whitelist:** Required for Gmail to work properly
- **Command:** `pihole -w googleapis.l.google.com`

**Google Chrome Updates:**

- **Domain:** `dl.google.com`
- **Service:** Google Chrome browser updates
- **Why whitelist:** Required for Chrome to update on Linux/Ubuntu
- **Command:** `pihole -w dl.google.com`

**Android TV:**

- **Domain:** `redirector.gvt1.com`
- **Service:** Android TV content delivery
- **Why whitelist:** Required for Android TV apps to work
- **Command:** `pihole -w redirector.gvt1.com`

### Microsoft Services

**Windows Connectivity Check:**

- **Domain:** `www.msftncsi.com`
- **Service:** Windows internet connectivity verification
- **Why whitelist:** Windows uses this to verify internet connectivity
- **Command:** `pihole -w www.msftncsi.com`

**Outlook Web Access:**

- **Domain:** `outlook.office365.com`
- **Service:** Outlook web email access
- **Why whitelist:** Required for Outlook web to work
- **Command:** `pihole -w outlook.office365.com`

**Microsoft Account Login:**

- **Domain:** `login.live.com`
- **Service:** Microsoft account authentication
- **Why whitelist:** Required for Microsoft account login
- **Command:** `pihole -w login.live.com`

**Microsoft Office:**

- **Domain:** `officeclient.microsoft.com`
- **Service:** Microsoft Office applications
- **Why whitelist:** Required for Office apps to function
- **Command:** `pihole -w officeclient.microsoft.com`

**Windows Store:**

- **Domains:** `dl.delivery.mp.microsoft.com`, `geo-prod.do.dsp.mp.microsoft.com`, `displaycatalog.mp.microsoft.com`
- **Service:** Microsoft Store downloads
- **Why whitelist:** Required for Windows Store to download apps
- **Command:** `pihole -w dl.delivery.mp.microsoft.com geo-prod.do.dsp.mp.microsoft.com displaycatalog.mp.microsoft.com`

**Xbox Live:**

- **Domains:** `clientconfig.passport.net`, `xbox.ipv6.microsoft.com`, `device.auth.xboxlive.com`
- **Service:** Xbox Live gaming services
- **Why whitelist:** Required for Xbox Live sign-in and online gaming
- **Command:** `pihole -w clientconfig.passport.net xbox.ipv6.microsoft.com device.auth.xboxlive.com`

**Skype:**

- **Domains:** `s.gateway.messenger.live.com`, `ui.skype.com`, `sa.symcb.com`
- **Service:** Skype messaging and calls
- **Why whitelist:** Required for Skype to connect and make calls
- **Command:** `pihole -w s.gateway.messenger.live.com ui.skype.com sa.symcb.com`

### Apple Services

**Apple Music:**

- **Domain:** `itunes.apple.com`
- **Service:** Apple Music streaming
- **Why whitelist:** Required for Apple Music to work
- **Command:** `pihole -w itunes.apple.com`

**Apple ID:**

- **Domain:** `appleid.apple.com`
- **Service:** Apple ID authentication
- **Why whitelist:** Required for Apple ID login
- **Command:** `pihole -w appleid.apple.com`

**iOS Captive Portal:**

- **Domain:** `captive.apple.com`
- **Service:** iOS Wi-Fi connectivity check
- **Why whitelist:** Required for iOS devices to connect to Wi-Fi
- **Command:** `pihole -w captive.apple.com`

**iOS Weather App:**

- **Domain:** `gsp-ssl.ls.apple.com`
- **Service:** iOS Weather app data
- **Why whitelist:** Required for Weather app to show data
- **Command:** `pihole -w gsp-ssl.ls.apple.com`

### Gaming Platforms

**Grand Theft Auto Online:**

- **Domain:** `prod.telemetry.ros.rockstargames.com`
- **Service:** GTA Online telemetry
- **Why whitelist:** Blocking this causes GTA Online to crash
- **Command:** `pihole -w prod.telemetry.ros.rockstargames.com`

**PlayStation 5:**

- **Domain:** `telemetry-console.api.playstation.com`
- **Service:** PlayStation 5 trophies and recently played games
- **Why whitelist:** Required for PS5 to show trophies and game history
- **Command:** `pihole -w telemetry-console.api.playstation.com`

**Epic Games Store:**

- **Domain:** `tracking.epicgames.com`
- **Service:** Epic Games Store functionality
- **Why whitelist:** Required for Epic Games Store to work properly
- **Command:** `pihole -w tracking.epicgames.com`

**EA Origin:**

- **Domain:** `cdn.optimizely.com`
- **Service:** EA Origin content delivery
- **Why whitelist:** Required for Origin to download games
- **Command:** `pihole -w cdn.optimizely.com`

**EA Desktop:**

- **Domain:** `split.io`
- **Service:** EA Desktop download functionality
- **Why whitelist:** Fixes missing download button in EA Desktop
- **Command:** `pihole -w split.io`

### Streaming Services

**Spotify iOS:**

- **Domain:** `spclient.wg.spotify.com`
- **Service:** Spotify iOS app functionality
- **Why whitelist:** Spotify iOS app stops working without this
- **Command:** `pihole -w spclient.wg.spotify.com`

**Spotify TV:**

- **Domain:** `api-tv.spotify.com`
- **Service:** Spotify TV apps
- **Why whitelist:** Required for Spotify on smart TVs
- **Command:** `pihole -w api-tv.spotify.com`

**Plex Media Server:**

- **Domain:** `plex.tv`
- **Service:** Plex media server authentication
- **Why whitelist:** Required for Plex to authenticate and connect
- **Command:** `pihole -w plex.tv`

**Plex Metadata:**

- **Domains:** `thetvdb.com`, `themoviedb.com`
- **Service:** TV and movie metadata for Plex
- **Why whitelist:** Required for Plex to fetch show/movie information
- **Command:** `pihole -w thetvdb.com themoviedb.com`

### Link Shorteners

**Common link shorteners (if you use them):**

- **Domains:** `bit.ly`, `www.bit.ly`, `ow.ly`, `tinyurl.com`, `t.ly`
- **Service:** Link shortening services
- **Why whitelist:** Required if you click shortened links
- **Command:** `pihole -w bit.ly www.bit.ly ow.ly tinyurl.com t.ly`
- **Note:** These are often used for phishing, so only whitelist if necessary

### Regex Whitelist Examples

**Reddit (allow all Reddit domains):**

- **Pattern:** `(^|\\.)reddit\\.com$`
- **What it allows:** Reddit and all subdomains
- **Examples:** `reddit.com`, `www.reddit.com`, `old.reddit.com`, `i.reddit.com`
- **Command:** `pihole --white-regex "(^|\\.)reddit\\.com$"`

**WhatsApp (allow WhatsApp domains):**

- **Pattern:** `(^|\\.)whatsapp\\.(com|net)$`
- **What it allows:** WhatsApp and WhatsApp CDN domains
- **Examples:** `whatsapp.com`, `web.whatsapp.com`, `cdn.whatsapp.net`
- **Command:** `pihole --white-regex "(^|\\.)whatsapp\\.(com|net)$"`

**Reddit Media (allow Reddit media domains):**

- **Pattern:** `[a-z]\\.thumbs\\.redditmedia\\.com`
- **What it allows:** Reddit thumbnail images
- **Examples:** `a.thumbs.redditmedia.com`, `b.thumbs.redditmedia.com`
- **Command:** `pihole --white-regex "[a-z]\\.thumbs\\.redditmedia\\.com"`

### How to Add Whitelist Domains

**Using Pi-hole Admin Web Interface:**

1. **Navigate:** Pi-hole Admin → Group Management → Whitelist
2. **Add domain:** Click "Add" button
3. **Enter domain:** Type domain name (e.g., `s.youtube.com`)
4. **Add comment:** Add description (e.g., "YouTube watch history")
5. **Save:** Click "Add" to save

**Using Command Line:**

```bash
# Add single domain
pihole -w s.youtube.com

# Add multiple domains
pihole -w domain1.com domain2.com domain3.com

# Add regex whitelist
pihole --white-regex "(^|\\.)reddit\\.com$"
```

**What these commands do:**

- **`pihole -w`:** Adds exact domain to whitelist
- **`pihole --white-regex`:** Adds regex pattern to whitelist (allows domains matching pattern)

### Maintenance

**Regular updates:**

- **Update Gravity:** Run `pihole -g` regularly (or set up automatic updates)
- **Check lists:** Review list status periodically
- **Remove deprecated:** Remove deprecated lists
- **Monitor false positives:** Keep track of whitelist additions

**Automated updates:**

**Set up cron job:**

```bash
# Edit crontab
sudo crontab -e

# Add line for daily updates at 3 AM
0 3 * * * pihole -g
```

**What this does:**

- **Runs daily:** Updates blocklists every day at 3 AM
- **Automatic:** No manual intervention needed
- **Keeps current:** Ensures latest blocklists are used

---

## Troubleshooting

### Blocklist Not Updating

**Symptoms:**

- Blocklist shows old date
- New domains not blocked
- Update Gravity fails

**Solutions:**

**Check internet connection:**

```bash
# Test connectivity
ping -c 3 8.8.8.8
```

**Check blocklist URL:**

- **Verify URL:** Ensure URL is correct and accessible
- **Test URL:** Open URL in browser to verify it works
- **Check format:** Ensure URL is raw GitHub URL (not regular GitHub URL)

**Manual update:**

```bash
# Force Gravity update
sudo pihole -g
```

**Check logs:**

```bash
# View Pi-hole logs
sudo tail -f /var/log/pihole.log
```

### Too Many False Positives

**Symptoms:**

- Legitimate sites blocked
- Services not working
- Frequent whitelist additions needed

**Solutions:**

**Review blocklists:**

- **Remove aggressive lists:** Remove lists with high false positives
- **Use ticked lists:** Stick to Firebog's ticked lists
- **Start conservative:** Begin with fewer lists

**Add whitelist:**

- **Identify domain:** Find blocked domain in query log
- **Whitelist:** Add domain to whitelist
- **Test:** Verify service works

**Use anudeepND whitelist:**

- **Install whitelist:** Use anudeepND's whitelist script
- **Prevents issues:** Many common false positives already handled

### Performance Issues

**Symptoms:**

- Slow DNS queries
- High memory usage
- Pi-hole slow to respond

**Solutions:**

**Reduce blocklist size:**

- **Remove large lists:** Remove very large blocklists
- **Use optimized lists:** Use pre-optimized lists (zachlagden)
- **Stick to essentials:** Only use necessary lists

**Check Pi resources:**

```bash
# Check memory usage
free -h

# Check disk space
df -h

# Check CPU usage
top
```

**Optimize:**

- **Upgrade Pi:** Use more powerful Raspberry Pi model
- **Add RAM:** If using Pi-hole on other hardware
- **Reduce lists:** Use fewer, more efficient lists

---

## Summary

**Recommended starting configuration:**

**Blocklists:**

1. **Firebog ticked lists:** Start with these (low false positives)
2. **ShadowWhisperer:** Add specific categories as needed
3. **Pi-hole Optimized comprehensive:** Good balance

**Whitelists:**

1. **anudeepND whitelist:** Install using script
2. **Firebog suggestions:** Add as needed
3. **Manual additions:** Add domains as false positives occur

**Maintenance:**

1. **Automated updates:** Set up cron job for daily updates
2. **Monitor:** Check for false positives regularly
3. **Review:** Periodically review and optimize lists

**Resources:**

- **Firebog:** [`https://firebog.net/`](https://firebog.net/)
- **ShadowWhisperer:** [`https://github.com/ShadowWhisperer/BlockLists`](https://github.com/ShadowWhisperer/BlockLists)
- **anudeepND Whitelist:** [`https://github.com/anudeepND/whitelist`](https://github.com/anudeepND/whitelist)
- **Pi-hole Forum:** [`https://discourse.pi-hole.net/`](https://discourse.pi-hole.net/)

---

## Additional Notes

**Raw URL format:**

- **GitHub:** Always use the "Raw" button to get direct file URL
- **Format:** `https://raw.githubusercontent.com/user/repo/branch/path/file.txt`
- **Not:** Regular GitHub file view URL won't work

**List formats:**

- **Hosts format:** `0.0.0.0 domain.com` (most common)
- **Domain-only:** `domain.com` (some lists)
- **Adblock format:** `||domain.com^` (some lists)

**Pi-hole compatibility:**

- **Hosts format:** Fully supported
- **Domain-only:** Supported
- **Adblock format:** Supported (Pi-hole converts automatically)

**Testing blocklists:**

```bash
# Test if domain is blocked
nslookup doubleclick.net

# Should return 0.0.0.0 or Pi-hole IP
```

**Testing whitelists:**

```bash
# Test if domain is whitelisted
nslookup s.youtube.com

# Should return real IP (not 0.0.0.0)
```

---

## Related Documentation

**Advanced Pi-hole Topics:**

- **[Unbound Setup](unbound.md):** Set up local recursive DNS resolver. Blocklists work seamlessly with Unbound - Pi-hole checks blocklists before forwarding queries to Unbound for resolution.

- **[Hardcoded DNS Blocking](hardcoded-dns.md):** Prevent devices and applications from bypassing Pi-hole's blocklists by blocking hardcoded DNS and DoH/DoT. Essential for ensuring your blocklists are effective.

- **[IPv6 Setup](ipv6.md):** Deploy Pi-hole safely in IPv6 environments. Blocklists apply to both IPv4 and IPv6 queries, ensuring consistent blocking across all network protocols.

**Networking Fundamentals:**

- **[DNS Model](../../networking/docs/dns.md):** Understand how DNS resolution works, including recursion, caching, and how Pi-hole intercepts queries.

- **[DHCP Model](../../networking/docs/dhcp.md):** Learn how DHCP assigns DNS settings to devices, ensuring all clients use Pi-hole.

**Main Documentation:**

- **[Pi-hole README](../README.md):** Return to main Pi-hole documentation for setup and configuration.
