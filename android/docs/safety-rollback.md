# Safety + Rollback Model (Don't Brick Your Phone)

Debloating can mean several different actions. Prefer safer ones first.

## What Is Safety in Debloating?

### Definition

**Safety in debloating** means using methods that:

- **Don't break your device:** Phone still works after debloating
- **Are reversible:** Can undo changes if something goes wrong
- **Don't require root:** Work with standard Android permissions
- **Minimize risk:** Lower chance of causing problems

### Why Safety Is Critical

**The problem:** Removing the wrong apps can:

- **Break system functions:** Phone features stop working
- **Cause boot loops:** Device won't start properly
- **Lose data:** Important information may be lost
- **Require factory reset:** Only way to fix some issues

**The solution:** Use safe debloating methods that:

- **Are reversible:** Can restore apps if needed
- **Don't modify system:** Leave system partition untouched
- **Work without root:** Use built-in Android features
- **Have low risk:** Minimal chance of breaking device

**Real-world analogy:**

- **Unsafe debloating = Removing engine parts** (might break car)
- **Safe debloating = Removing accessories** (car still works)
- **Rollback = Putting parts back** (restore if needed)

### How Safety Works

**Android user profiles:**

- **User 0:** Main user (you)
- **System apps:** Installed in system partition (shared)
- **User apps:** Installed for specific user (removable)

**Safe debloating principle:**

- **Remove for user, not system:** Remove app for your user only
- **System app stays:** App still exists in system partition
- **Can restore:** Can reinstall for your user if needed
- **System untouched:** System partition remains unchanged

## The Three "Levels" (Recommended Order)

### 1) Uninstall for User 0 (Recommended)

**What it does:** Removes the app for the main user but **does not delete the system APK**.

**Command:**

```bash
adb shell pm uninstall --user 0 <package>
```

**Why this is safe-ish:**

**Usually reversible without root:**

- App still exists in system partition
- Can reinstall with `pm install-existing`
- No root access needed
- Works on most Android devices

**Helps you remove bloat without touching the system partition:**

- System partition remains untouched
- Only removes app for your user
- Other users (if any) still have app
- System stability maintained

**How it works:**

1. **Command executed:** `pm uninstall --user 0 com.oppo.analytics`
2. **Android checks:** Is this a system app?
3. **If system app:** Removes for user 0 only (keeps system APK)
4. **If user app:** Removes completely
5. **Result:** App gone for you, but system APK preserved

**Real-world example:**

**Before:**

```bash
$ adb shell pm list packages | grep analytics
package:com.oppo.analytics
```

**Execute removal:**

```bash
$ adb shell pm uninstall --user 0 com.oppo.analytics
Success
```

**After:**

```bash
$ adb shell pm list packages | grep analytics
(empty - app removed for user 0)
```

**If needed, restore:**

```bash
$ adb shell cmd package install-existing com.oppo.analytics
Package com.oppo.analytics installed for user: 0
```

**When to use:** For most debloating - safest method, usually reversible.

### 2) Disable a Package

**What it does:** Prevents the app from launching/running for user 0.

**Command:**

```bash
adb shell pm disable-user --user 0 <package>
```

**Why this is safer:**

- **App still installed:** Not removed, just disabled
- **Easier to restore:** Just enable, no reinstall needed
- **Lower risk:** Can't break anything if app is disabled
- **Reversible:** Can enable anytime

**How it works:**

1. **Command executed:** `pm disable-user --user 0 com.oppo.analytics`
2. **Android disables app:** Sets app state to "disabled"
3. **App can't run:** Prevented from launching or running
4. **App still exists:** Still installed, just inactive
5. **Result:** App disabled, can enable later

**Real-world example:**

**Disable app:**

```bash
$ adb shell pm disable-user --user 0 com.oppo.analytics
Package com.oppo.analytics new state: disabled-user
```

**Verify disabled:**

```bash
$ adb shell pm list packages -d | grep analytics
package:com.oppo.analytics
```

**If needed, enable:**

```bash
$ adb shell pm enable com.oppo.analytics
Package com.oppo.analytics new state: enabled
```

**When to use:** When unsure about removing app - test disabling first.

### 3) Reduce Permissions (Keep the App, Reduce Data)

**What it does:** Keeps the app but reduces what data it can access.

**Method:** Use Android settings first. Advanced users can use `pm revoke`, but permissions vary by OS/vendor.

**Why this is safest:**

- **App still works:** App functions normally
- **Reduced data access:** Can't collect as much data
- **No removal risk:** Nothing removed, just restricted
- **Easier to undo:** Just restore permissions

**How it works:**

1. **Go to Settings:** Settings → Apps → [App Name]
2. **Permissions:** Tap "Permissions"
3. **Revoke permissions:** Turn off unnecessary permissions
4. **App restricted:** App can't access revoked permissions
5. **Result:** App works but collects less data

**Real-world example:**

**Before:** App has permissions:

- Location ✅
- Contacts ✅
- Storage ✅
- Camera ✅

**Revoke unnecessary permissions:**

- Location ❌ (revoked)
- Contacts ❌ (revoked)
- Storage ✅ (keep)
- Camera ❌ (revoked)

**Result:** App can still run but can't access location, contacts, or camera.

**When to use:** When you want to keep app but reduce data collection.

## Rollback / Restore Recipes

### What Is Rollback?

**Definition:** **Rollback** means undoing debloating changes to restore your device to a previous state.

**Why rollback exists:**

- **Mistakes happen:** Removed wrong app, device breaks
- **Need to restore:** Want app back
- **Testing:** Try removing app, restore if issues

**How rollback works:**

- **Different methods:** Depends on how app was removed
- **Restore app:** Reinstall or enable app
- **Verify device:** Check device works correctly
- **Test functionality:** Ensure features still work

### Re-install an App You Uninstalled for User 0

**Command:**

```bash
adb shell cmd package install-existing <package>
```

**What it does:** Reinstalls an app that was uninstalled for user 0 (but still exists in system).

**Why it works:**

- **System APK exists:** App still in system partition
- **Reinstall for user:** Just reinstalls for your user
- **No download needed:** Uses existing system APK
- **Quick restore:** Faster than downloading app

**How it works:**

1. **Command executed:** `cmd package install-existing com.oppo.analytics`
2. **Android finds system APK:** Locates app in system partition
3. **Reinstalls for user 0:** Restores app for your user
4. **App restored:** App available again

**Real-world example:**

**App was removed:**

```bash
$ adb shell pm list packages | grep analytics
(empty)
```

**Restore app:**

```bash
$ adb shell cmd package install-existing com.oppo.analytics
Package com.oppo.analytics installed for user: 0
```

**Verify restored:**

```bash
$ adb shell pm list packages | grep analytics
package:com.oppo.analytics
```

**When to use:** When you removed app with `pm uninstall --user 0` and want it back.

### Re-enable a Package You Disabled

**Command:**

```bash
adb shell pm enable <package>
```

**What it does:** Re-enables a package that was disabled.

**Why it works:**

- **App still installed:** Just disabled, not removed
- **Enable command:** Simply changes state from disabled to enabled
- **Instant restore:** App immediately available
- **No reinstall needed:** App already there

**How it works:**

1. **Command executed:** `pm enable com.oppo.analytics`
2. **Android enables app:** Changes state from disabled to enabled
3. **App can run:** App can now launch and run
4. **App restored:** App functional again

**Real-world example:**

**App was disabled:**

```bash
$ adb shell pm list packages -d | grep analytics
package:com.oppo.analytics
```

**Enable app:**

```bash
$ adb shell pm enable com.oppo.analytics
Package com.oppo.analytics new state: enabled
```

**Verify enabled:**

```bash
$ adb shell pm list packages | grep analytics
package:com.oppo.analytics
```

**When to use:** When you disabled app and want to enable it again.

### "I Forgot What I Changed"

**Command:**

```bash
# List packages, including uninstalled-for-user ones
adb shell pm list packages -u
```

**What it does:** Lists all packages, including those uninstalled for user 0.

**Why it's useful:**

- **See removed apps:** Shows apps you uninstalled
- **Track changes:** Know what you've removed
- **Restore planning:** See what can be restored
- **Audit trail:** Review your debloating history

**How it works:**

- `pm list packages` = List packages
- `-u` = Include uninstalled packages
- Shows both installed and uninstalled packages
- Uninstalled packages marked differently

**Real-world example:**

**See all packages (including removed):**

```bash
$ adb shell pm list packages -u | grep analytics
package:com.oppo.analytics
```

**If app shows up:** It was removed but can be restored.

**If app doesn't show:** It was never installed or was completely removed.

**When to use:** To see what apps you've removed and can restore.

## Safety Rules of Thumb

### Rule 1: Make One Change at a Time

**Why:** If something breaks, you know exactly what caused it.

**How:**

- Remove one app
- Test device
- If OK, remove next app
- If broken, restore that app

**Real-world example:**

- ❌ **Bad:** Remove 10 apps at once, device breaks, don't know which caused it
- ✅ **Good:** Remove one app, test, remove next, test, etc.

### Rule 2: Reboot After a Batch of Changes

**Why:** So you catch breakage early, before making more changes.

**How:**

- Make a few changes (3-5 apps)
- Reboot device
- Test functionality
- If OK, continue
- If broken, restore last batch

**Real-world example:**

- Remove 5 apps
- Reboot phone
- Check if phone works correctly
- If issues, restore those 5 apps
- If OK, continue removing more

### Rule 3: Avoid "Expert/Unsafe" Removals

**Why:** Unless you understand dependencies, you might break critical system functions.

**What "Expert/Unsafe" means:**

- **System-critical apps:** Apps needed for device to function
- **Framework apps:** Core Android functionality
- **Dependency apps:** Apps other apps depend on

**How to identify:**

- Community lists mark apps as "Unsafe"
- Apps with "system" or "framework" in name
- Apps you don't recognize and can't research

**Real-world example:**

- ❌ **Bad:** Remove `com.android.systemui` (breaks phone UI)
- ✅ **Good:** Remove `com.oppo.analytics` (just telemetry)

### Rule 4: Keep a Simple Rollback Log

**Why:** Track what you changed so you can restore if needed.

**Format:** `package → action → date`

**Example log:**

```
com.oppo.analytics → uninstall --user 0 → 2024-01-15
com.oppo.heycloud → disable → 2024-01-15
com.vendor.tracking → uninstall --user 0 → 2024-01-16
```

**How to use:**

- Write down each change
- Include package name, action, date
- If device breaks, restore from log
- Keep log safe (backup)

**Real-world example:**

**Log entry:**

```
2024-01-15: Removed com.oppo.analytics (uninstall --user 0)
2024-01-15: Disabled com.oppo.heycloud
2024-01-16: Removed com.vendor.tracking (uninstall --user 0)
```

**If device breaks:**

- Check log for recent changes
- Restore recent apps one by one
- Find which app caused issue

## Next Steps

- **Investigation workflow:** [`investigation.md`](investigation.md) - Learn how to trace telemetry to apps
