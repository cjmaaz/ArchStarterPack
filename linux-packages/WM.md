# Display Protocol Compatibility (Wayland / X11) — Guidance

Some pre-compiled executables — especially those using GPU-accelerated or native GUI toolkits — may fail to render a usable window on Linux desktops using **Wayland**. Instead of showing their interface, the application might open a blank or unresponsive window, log warnings about surfaces, or quit unexpectedly.

This document explains **why that happens**, what the difference between Wayland and X11 is, and how users can work around it.

## Why Executables Sometimes Fail on Wayland

Wayland and X11 are two different display protocols used on Linux desktops:

* **X11 (Xorg)** is the older protocol. It provides a stable, widely supported API and a compatibility layer that many toolkits and GPU backends understand.
* **Wayland** is a newer protocol designed to be simpler and more secure, but it requires explicit support from the application and its graphics backend.

Many GUI applications rely on underlying graphics libraries (OpenGL, Vulkan, EGL, SDL, GTK, etc.) that must be built with Wayland support. If an application is only tested or packaged against X11, or if its toolkit doesn’t fall back cleanly, then on Wayland the window may never initialize correctly.

When a Wayland compositor (like GNOME/Wayland, Sway, KDE/Wayland, etc.) presents a surface to an app that doesn’t fully support Wayland, you might see errors or warnings like:

```
interface 'wl_surface' has no event 2
Re-initializing GLES context due to Wayland window
Warning: disabling presentation
```

These indicate the app is trying to open a Wayland window but cannot complete graphics initialization.

## Common Symptoms

* A window appears but remains **blank or unresponsive**.
* The system reports the application is **not responding**.
* Terminal output shows warnings about Wayland surfaces or graphics backends.
* The GUI never renders even though the executable seems to start.

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

* Install appropriate Wayland development packages.
* Enable Wayland backends in graphics toolchains (EGL, Vulkan, etc.).
* Ensure that GUI toolkits (GTK, Qt) are configured to support Wayland.

### Try Alternative Builds

Some projects offer separate builds or flags for Wayland vs X11 support. Look for:

* A dedicated Wayland build.
* A flag to choose a rendering backend (OpenGL, Vulkan, software).
* Flatpak/Snap/AppImage builds that bundle proper dependencies.

### Use a Non-GUI Alternative

When a graphical frontend fails to run under Wayland and no fixes are available, using a **command-line interface (CLI)** or **headless** mode can be a reliable alternative that avoids the display stack entirely.

## Summary

Wayland is increasingly common on modern Linux desktops, but not all executables — particularly GPU/graphics-dependent ones — handle it by default. If you encounter a blank, unresponsive window:

* Try running under **X11**.
* Experiment with **environment variables** to force an X11 backend.
* Check whether the executable supports Wayland or needs extra dependencies.
* Use alternative interfaces (like CLI) when available.

Providing this guidance alongside your project helps users diagnose display compatibility issues without assuming a single display protocol.
