# Safety + rollback model (don’t brick your phone)

Debloating can mean several different actions. Prefer safer ones first.

## The three “levels” (recommended order)

### 1) Uninstall for user 0 (recommended)

This removes the app for the main user but **does not delete the system APK**.

```bash
adb shell pm uninstall --user 0 <package>
```

Why this is safe-ish:

- Usually reversible without root
- Helps you remove bloat without touching the system partition

### 2) Disable a package

Prevents the app from launching/running for user 0.

```bash
adb shell pm disable-user --user 0 <package>
```

### 3) Reduce permissions (keep the app, reduce data)

Use Android settings first. Advanced users can use `pm revoke`, but permissions vary by OS/vendor.

## Rollback / restore recipes

### Re-install an app you uninstalled for user 0

```bash
adb shell cmd package install-existing <package>
```

### Re-enable a package you disabled

```bash
adb shell pm enable <package>
```

### “I forgot what I changed”

```bash
# List packages, including uninstalled-for-user ones
adb shell pm list packages -u
```

## Safety rules of thumb

- Make one change at a time.
- Reboot after a batch of changes (so you catch breakage early).
- Avoid “Expert/Unsafe” removals unless you understand dependencies.
- Keep a simple rollback log (package → action → date).

Next:

- Investigation workflow: `investigation.md`
