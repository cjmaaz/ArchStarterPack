# Display Protocol Compatibility (Wayland / X11) — Guidance

Some pre-compiled executables — especially those using GPU-accelerated or native GUI toolkits — may fail to render a usable window on Linux desktops using **Wayland**. Instead of showing their interface, the application might open a blank or unresponsive window, log warnings about surfaces, or quit unexpectedly.

This document explains **why that happens**, what the difference between Wayland and X11 is, and how users can work around it.

## What Are Wayland and X11?

### Definitions

**X11 (X Window System):**

- **What it is:** The traditional display server protocol for Linux/Unix systems
- **Age:** Developed in 1980s, widely used for decades
- **Purpose:** Provides windowing system and display management
- **Status:** Mature, stable, widely supported

**Wayland:**

- **What it is:** A modern display server protocol designed to replace X11
- **Age:** Developed in 2000s, gaining adoption
- **Purpose:** Simpler, more secure alternative to X11
- **Status:** Modern, secure, requires application support

### Why Two Protocols Exist

**Historical context:**

- **X11 is old:** Developed when computing was very different
- **Legacy issues:** X11 has security and complexity problems
- **Wayland created:** To address X11's limitations
- **Transition period:** Both protocols coexist during migration

**Real-world analogy:**

- **X11 = Old language** (widely spoken, but has problems)
- **Wayland = New language** (better, but not everyone speaks it yet)
- **Applications = People** (some speak old language, some speak new)
- **Problem = Language barrier** (can't communicate if languages don't match)

## Why Executables Sometimes Fail on Wayland

### The Compatibility Problem

**Wayland and X11 are two different display protocols used on Linux desktops:**

**X11 (Xorg) is the older protocol:**

- **Stable:** Been around for decades, well-tested
- **Widely supported:** Most applications support X11
- **Compatibility layer:** Many toolkits understand X11
- **GPU backends:** Graphics libraries work well with X11

**Wayland is a newer protocol:**

- **Simpler:** Designed to be simpler than X11
- **More secure:** Better security model than X11
- **Requires support:** Applications must explicitly support Wayland
- **Graphics backend:** Needs Wayland-compatible graphics libraries

### How Compatibility Works

**Many GUI applications rely on underlying graphics libraries** (OpenGL, Vulkan, EGL, SDL, GTK, etc.) **that must be built with Wayland support.**

**What this means:**

- **Graphics libraries:** Applications use libraries for graphics rendering
- **Wayland support:** Libraries must be compiled with Wayland support
- **If not supported:** Application can't create Wayland windows
- **Result:** Application fails to display window

**If an application is only tested or packaged against X11, or if its toolkit doesn't fall back cleanly, then on Wayland the window may never initialize correctly.**

**What happens:**

1. **Application starts:** Tries to create window
2. **Wayland compositor:** Presents Wayland surface to app
3. **App doesn't support:** App can't handle Wayland surface
4. **Initialization fails:** Window never initializes correctly
5. **Result:** Blank window, unresponsive, or crashes

### Common Error Messages

**When a Wayland compositor (like GNOME/Wayland, Sway, KDE/Wayland, etc.) presents a surface to an app that doesn't fully support Wayland, you might see errors or warnings like:**

```
interface 'wl_surface' has no event 2
Re-initializing GLES context due to Wayland window
Warning: disabling presentation
```

**What these mean:**

**`interface 'wl_surface' has no event 2`:**

- **What:** Wayland surface interface error
- **Meaning:** App trying to use Wayland feature that doesn't exist
- **Cause:** App expects different Wayland version or API
- **Result:** Window initialization fails

**`Re-initializing GLES context due to Wayland window`:**

- **What:** Graphics context reinitialization
- **Meaning:** App trying to adapt to Wayland but failing
- **Cause:** Graphics backend doesn't support Wayland properly
- **Result:** Window may not render correctly

**`Warning: disabling presentation`:**

- **What:** Presentation mode disabled
- **Meaning:** App can't use Wayland presentation features
- **Cause:** Wayland compositor doesn't support feature or app incompatible
- **Result:** Window may work but with reduced functionality

**These indicate the app is trying to open a Wayland window but cannot complete graphics initialization.**

## Common Symptoms

- A window appears but remains **blank or unresponsive**.
- The system reports the application is **not responding**.
- Terminal output shows warnings about Wayland surfaces or graphics backends.
- The GUI never renders even though the executable seems to start.

## What You Can Do

There are several strategies to improve compatibility or work around issues on Wayland systems:

### Use an X11 (Xorg) Session

Many Linux desktop environments let you choose **X11 instead of Wayland** at the login screen. If the executable is built with X11 support, running it under an Xorg session often fixes rendering issues.

### Force X11 Compatibility

You can sometimes coax applications into using an X11 backend using environment variables, depending on how the application was built. For example:

```bash
GDK_BACKEND=x11 ./your-app
```

or

```bash
SDL_VIDEODRIVER=x11 ./your-app
```

This doesn’t work for every build, but it can help when the executable supports X11 fallbacks.

### Check for Wayland Support or Dependencies

If you’re building the software yourself or packaging it, make sure the build includes Wayland support:

- Install appropriate Wayland development packages.
- Enable Wayland backends in graphics toolchains (EGL, Vulkan, etc.).
- Ensure that GUI toolkits (GTK, Qt) are configured to support Wayland.

### Try Alternative Builds

Some projects offer separate builds or flags for Wayland vs X11 support. Look for:

- A dedicated Wayland build.
- A flag to choose a rendering backend (OpenGL, Vulkan, software).
- Flatpak/Snap/AppImage builds that bundle proper dependencies.

### Use a Non-GUI Alternative

When a graphical frontend fails to run under Wayland and no fixes are available, using a **command-line interface (CLI)** or **headless** mode can be a reliable alternative that avoids the display stack entirely.

## Summary

Wayland is increasingly common on modern Linux desktops, but not all executables — particularly GPU/graphics-dependent ones — handle it by default. If you encounter a blank, unresponsive window:

- Try running under **X11**.
- Experiment with **environment variables** to force an X11 backend.
- Check whether the executable supports Wayland or needs extra dependencies.
- Use alternative interfaces (like CLI) when available.

Providing this guidance alongside your project helps users diagnose display compatibility issues without assuming a single display protocol.
