# Android Module: Debloating + Privacy (Beginner → Intermediate)

This module helps you reduce background telemetry and bloat on Android devices safely.

---

## Start here (recommended reading order)

1. **Structured docs (recommended):** `android/docs/README.md`
   - ADB basics
   - Safety + rollback
   - Investigation workflow
   - OEM domains + Pi-hole regex examples
2. **Single-page version:** `android/debloat.md` (all-in-one)

---

## What you’ll learn

- How to interpret “mystery domains” in Pi-hole logs and trace them back to an Android package
- How debloating works without root (and why it’s usually reversible)
- How to verify whether background traffic actually stopped

---

## Quick glossary

- **ADB**: Android Debug Bridge, a tool for inspecting packages/logs and issuing commands.
- **Package name**: the internal identifier (e.g., `com.vendor.analytics`).
- **UID**: the numeric identity Android assigns to an app; can appear in logs.
- **Telemetry**: background data sent to vendor endpoints (analytics/diagnostics).

---

## How this connects to Pi-hole

- Pi-hole shows you **what domains** a device tries to resolve.
- Android + apps can sometimes bypass Pi-hole via **hardcoded DNS** or **DoH**.

Recommended reading:

- Enforcement patterns: `../pi-hole/docs/hardcoded-dns.md`
- DNS fundamentals: `../networking/docs/dns.md`

---

## Definition of done (checklist)

- You can run `adb devices` successfully.
- You can identify a suspicious domain in Pi-hole and attribute it to an app/package.
- You debloat/disable the responsible package safely (one change at a time).
- You verify traffic reduction (Pi-hole logs / PCAPdroid / logs).
