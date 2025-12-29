# F-Droid Repository Setup: IzzyOnDroid

**Goal:** Add the IzzyOnDroid repository to F-Droid to access advanced apps like PCAPdroid MITM addon and other tools not available in the main F-Droid repository.

## What Is IzzyOnDroid Repository?

### Definition

**IzzyOnDroid** is a third-party F-Droid-compatible repository that provides access to free and open-source Android apps. Unlike the main F-Droid repository which builds apps from source, IzzyOnDroid distributes developer-signed APKs directly from their source repositories (mostly GitHub, GitLab, Codeberg).

### Why IzzyOnDroid Exists

**The problem:** Some apps are not available in the main F-Droid repository due to:
- Build issues or complex build requirements
- Non-FLOSS dependencies (tolerated by IzzyOnDroid)
- Faster update cycles needed
- Apps that cannot be built by F-Droid's automated system

**The solution:** IzzyOnDroid provides these apps as developer-signed binaries, allowing access to tools like PCAPdroid MITM addon and other advanced applications.

**Real-world analogy:**
- **Main F-Droid = Official app store** (curated, built from source)
- **IzzyOnDroid = Additional app store** (developer-signed apps, faster updates)

### Why You Need It

**For Android debloating and privacy work:**

- **PCAPdroid MITM addon:** Required for TLS/HTTPS decryption in PCAPdroid
- **Advanced tools:** Access to networking, security, and privacy tools
- **Faster updates:** Apps updated within 24 hours of release
- **Developer-signed:** Apps signed by original developers

**What this means:**

- **TLS decryption:** Decrypt encrypted traffic to see what apps are sending
- **Advanced monitoring:** Use tools not available in main F-Droid
- **Privacy tools:** Access privacy-focused applications
- **System tools:** Get advanced system management apps

---

## Prerequisites

### What You Need Before Starting

**1. F-Droid Installed**

- F-Droid app installed on your Android device
- If not installed: Download from [f-droid.org](https://f-droid.org/)

**2. Android Device**

- Any Android device (phone, tablet)
- Internet connection
- F-Droid app permissions granted

**3. Basic Knowledge**

- Understanding of Android app installation
- Comfortable with F-Droid interface
- Basic security awareness (fingerprint verification)

---

## Step-by-Step Setup Instructions

### Step 1: Open F-Droid

**What this does:** Launches the F-Droid app on your device.

**How to do it:**

1. **Find F-Droid:** Locate F-Droid icon in app drawer
2. **Tap to open:** Open F-Droid app
3. **Wait for load:** Wait for F-Droid to load (may take a moment)

**Real-world example:**

- Tap F-Droid icon → App opens → Main screen appears

### Step 2: Navigate to Repositories

**What this does:** Opens the repository management screen where you can add new repositories.

**How to do it:**

1. **Open menu:** Tap the hamburger menu (☰) in top-left corner
2. **Select "Repositories":** Tap on "Repositories" option in menu
3. **View repositories:** You'll see list of enabled repositories

**Real-world example:**

- Tap menu (☰) → Tap "Repositories" → See list of repositories

**What you'll see:**

- Main F-Droid repository (enabled by default)
- Any other repositories you've added
- Options to add new repository

### Step 3: Add New Repository

**What this does:** Opens the dialog to add a new repository URL.

**How to do it:**

1. **Tap "+" button:** Look for "+" or "Add" button (usually top-right)
2. **Repository dialog opens:** Dialog appears asking for repository URL
3. **Ready to enter URL:** Cursor in URL field

**Real-world example:**

- Tap "+" button → Dialog opens → URL field ready for input

### Step 4: Enter Repository URL

**What this does:** Adds the IzzyOnDroid repository URL to F-Droid.

**How to do it:**

1. **Enter URL:** Type or paste: `https://apt.izzysoft.de/fdroid/repo`
2. **Verify URL:** Double-check the URL is correct
3. **Optional fingerprint:** You can add fingerprint for verification (see Step 5)

**Repository URL:**

```
https://apt.izzysoft.de/fdroid/repo
```

**What this URL does:**

- **`https://apt.izzysoft.de/fdroid/repo`:** Points to IzzyOnDroid repository server
- **F-Droid compatible:** Uses standard F-Droid repository format
- **Secure:** Uses HTTPS for encrypted connection

**Real-world example:**

- Paste URL → Verify it's correct → Ready for fingerprint (optional)

### Step 5: Add Fingerprint (Optional but Recommended)

**What this does:** Verifies the repository authenticity using cryptographic fingerprint.

**Why fingerprint matters:**

- **Security:** Ensures repository hasn't been tampered with
- **Verification:** Confirms you're connecting to the real IzzyOnDroid repository
- **DNS protection:** Protects against DNS spoofing attacks

**How to do it:**

1. **Find fingerprint field:** Look for "Fingerprint" or "Repository fingerprint" field
2. **Enter fingerprint:** Type or paste: `3BF0D6ABFEAE2F401707B6D966BE743BF0EEE49C2561B9BA39073711F628937A`
3. **Verify fingerprint:** Double-check it matches exactly

**Fingerprint:**

```
3BF0D6ABFEAE2F401707B6D966BE743BF0EEE49C2561B9BA39073711F628937A
```

**What this fingerprint does:**

- **Cryptographic hash:** SHA-256 hash of repository signing key
- **Verification:** F-Droid verifies repository matches this fingerprint
- **Security:** Prevents man-in-the-middle attacks

**Real-world example:**

- Paste fingerprint → Verify it matches → Ready to add repository

**Note:** Fingerprint verification is optional but highly recommended for security.

### Step 6: Add Repository

**What this does:** Adds IzzyOnDroid repository to F-Droid and begins initial sync.

**How to do it:**

1. **Tap "Add" or "OK":** Tap the button to add repository
2. **F-Droid validates:** F-Droid validates URL and fingerprint (if provided)
3. **Repository added:** Repository appears in repositories list
4. **Initial sync:** F-Droid begins downloading repository index

**Real-world example:**

- Tap "Add" → Validation occurs → Repository added → Sync begins

**What happens:**

- **Repository added:** IzzyOnDroid appears in repositories list
- **Index download:** F-Droid downloads app list and metadata
- **Ready to use:** Repository ready after sync completes

### Step 7: Refresh Repository

**What this does:** Ensures repository index is up-to-date and downloads latest app information.

**How to do it:**

1. **Wait for sync:** Let initial sync complete (may take a minute)
2. **Manual refresh (optional):** Tap refresh icon if needed
3. **Verify apps:** Check that apps from IzzyOnDroid are available

**Real-world example:**

- Wait for sync → See "Updating..." message → Sync completes → Apps available

**How to verify:**

- **Check repositories:** IzzyOnDroid should show as enabled
- **Search apps:** Search for "PCAPdroid MITM" - should find it
- **Browse apps:** Browse IzzyOnDroid apps in F-Droid

---

## Verification Steps

### Verify Repository Is Added

**What this checks:** Confirms IzzyOnDroid repository is properly added and enabled.

**How to verify:**

1. **Open F-Droid:** Launch F-Droid app
2. **Go to Repositories:** Menu → Repositories
3. **Check list:** IzzyOnDroid should appear in list
4. **Check status:** Should show as enabled/active

**What to look for:**

- ✅ **Repository listed:** IzzyOnDroid appears in repositories
- ✅ **Status enabled:** Repository is enabled/active
- ✅ **Last updated:** Shows recent update timestamp

### Verify Apps Are Available

**What this checks:** Confirms apps from IzzyOnDroid are accessible.

**How to verify:**

1. **Search for app:** Search for "PCAPdroid MITM" in F-Droid
2. **Check results:** Should find PCAPdroid MITM addon
3. **Browse repository:** Browse IzzyOnDroid apps
4. **Install test app:** Try installing PCAPdroid MITM addon

**What to look for:**

- ✅ **Apps found:** Can find apps from IzzyOnDroid
- ✅ **Install works:** Can install apps successfully
- ✅ **Updates available:** Updates show for IzzyOnDroid apps

### Verify Fingerprint (If Added)

**What this checks:** Confirms fingerprint verification is working.

**How to verify:**

1. **Check repository details:** Tap on IzzyOnDroid repository
2. **View fingerprint:** Should show fingerprint you entered
3. **Verify match:** Fingerprint should match expected value

**What to look for:**

- ✅ **Fingerprint shown:** Repository shows fingerprint
- ✅ **Matches expected:** Fingerprint matches `3BF0D6ABFEAE2F401707B6D966BE743BF0EEE49C2561B9BA39073711F628937A`
- ✅ **No warnings:** No security warnings displayed

---

## Troubleshooting Common Issues

### Issue: Repository Not Found

**Symptoms:** F-Droid can't find or connect to repository.

**Possible causes:**

- **Incorrect URL:** URL mistyped or incorrect
- **Network issues:** No internet connection
- **Server down:** IzzyOnDroid server temporarily unavailable

**Solutions:**

1. **Check URL:** Verify URL is exactly `https://apt.izzysoft.de/fdroid/repo`
2. **Check internet:** Ensure device has internet connection
3. **Try again:** Wait a few minutes and try again
4. **Check status:** Visit [IzzyOnDroid website](https://apt.izzysoft.de/fdroid/) to check server status

### Issue: Fingerprint Verification Failed

**Symptoms:** F-Droid shows fingerprint mismatch error.

**Possible causes:**

- **Incorrect fingerprint:** Fingerprint mistyped
- **Extra spaces:** Spaces in fingerprint
- **Case sensitivity:** Fingerprint case mismatch

**Solutions:**

1. **Check fingerprint:** Verify fingerprint is exactly `3BF0D6ABFEAE2F401707B6D966BE743BF0EEE49C2561B9BA39073711F628937A`
2. **Remove spaces:** Ensure no spaces before/after fingerprint
3. **Copy exactly:** Copy fingerprint character-by-character
4. **Try without fingerprint:** Remove fingerprint and add repository (less secure)

### Issue: Apps Not Showing Up

**Symptoms:** Repository added but apps not visible.

**Possible causes:**

- **Sync not complete:** Repository index still downloading
- **Repository disabled:** Repository accidentally disabled
- **Cache issues:** F-Droid cache needs refresh

**Solutions:**

1. **Wait for sync:** Wait a few minutes for sync to complete
2. **Check enabled:** Verify repository is enabled in settings
3. **Refresh manually:** Pull down to refresh or tap refresh icon
4. **Clear cache:** Clear F-Droid cache and restart app
5. **Re-add repository:** Remove and re-add repository

### Issue: Can't Install Apps

**Symptoms:** Apps found but installation fails.

**Possible causes:**

- **Unknown sources:** Installation from unknown sources not allowed
- **Storage space:** Insufficient storage space
- **App conflicts:** Conflicting app already installed

**Solutions:**

1. **Enable unknown sources:** Allow installation from F-Droid in Android settings
2. **Check storage:** Ensure sufficient storage space available
3. **Uninstall conflicts:** Uninstall conflicting apps first
4. **Check permissions:** Grant F-Droid necessary permissions

---

## Security Considerations

### Repository Trust

**What this means:** Understanding the security implications of adding third-party repositories.

**IzzyOnDroid security:**

- **Developer-signed:** Apps signed by original developers
- **Malware scanning:** APKs scanned with VirusTotal
- **Transparency:** Binary transparency logs available
- **Reproducible builds:** Some apps verified with reproducible builds

**Best practices:**

- **Use fingerprint:** Always add fingerprint for verification
- **Verify apps:** Check app signatures and permissions
- **Keep updated:** Keep F-Droid and repositories updated
- **Review permissions:** Review app permissions before installing

### Fingerprint Verification

**Why it matters:**

- **Prevents MITM:** Protects against man-in-the-middle attacks
- **DNS protection:** Prevents DNS spoofing attacks
- **Repository authenticity:** Ensures repository is legitimate

**How it works:**

- **Cryptographic hash:** Fingerprint is SHA-256 hash of signing key
- **F-Droid verification:** F-Droid verifies repository matches fingerprint
- **Mismatch detection:** F-Droid warns if fingerprint doesn't match

**Real-world example:**

- **Without fingerprint:** Vulnerable to DNS spoofing
- **With fingerprint:** Protected against spoofing attacks

### App Security

**What to check:**

- **App permissions:** Review permissions before installing
- **Developer reputation:** Check developer's reputation
- **Source code:** Verify source code is available
- **Updates:** Ensure app receives regular updates

**Red flags:**

- ❌ **Excessive permissions:** App requests unnecessary permissions
- ❌ **No source code:** Source code not available
- ❌ **No updates:** App hasn't been updated in years
- ❌ **Suspicious behavior:** App behaves suspiciously

---

## Next Steps

After setting up IzzyOnDroid repository:

1. **Install PCAPdroid MITM:** Install PCAPdroid MITM addon for TLS decryption
2. **Explore apps:** Browse IzzyOnDroid apps in F-Droid
3. **Learn more:** See [`advanced-fdroid-apps.md`](advanced-fdroid-apps.md) for comprehensive guide
4. **Use tools:** Start using advanced tools for Android privacy and security

**Related documentation:**

- **Advanced apps guide:** [`advanced-fdroid-apps.md`](advanced-fdroid-apps.md)
- **Investigation workflow:** [`investigation.md`](investigation.md)
- **Debloating guide:** [`../debloat.md`](../debloat.md)
- **Main README:** [`../README.md`](../README.md)

---

## Summary

**What you learned:**

- **IzzyOnDroid repository:** Third-party F-Droid repository for advanced apps
- **Setup process:** Step-by-step instructions for adding repository
- **Security:** Fingerprint verification and security considerations
- **Troubleshooting:** Common issues and solutions

**Key points:**

- ✅ **Repository URL:** `https://apt.izzysoft.de/fdroid/repo`
- ✅ **Fingerprint:** `3BF0D6ABFEAE2F401707B6D966BE743BF0EEE49C2561B9BA39073711F628937A` (optional but recommended)
- ✅ **Purpose:** Access to PCAPdroid MITM and other advanced tools
- ✅ **Security:** Always use fingerprint for verification

**Next:** Install PCAPdroid MITM addon and explore advanced F-Droid apps!
