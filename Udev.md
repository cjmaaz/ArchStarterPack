## Linux udev Setup for VIA/WebHID Devices

By default, Linux does not allow non-root applications (including browsers) to open raw HID devices such as keyboards. VIA’s web configurator uses the **WebHID API** in the browser, which still requires underlying access to `/dev/hidraw*` devices.

This section explains how to grant your user permission to access your keyboard *without* root, using **udev rules**.

---

### Why This Is Necessary

When you connect your keyboard on Linux and open VIA in the browser (Chrome/Chromium), you may see errors like:

```
NotAllowedError: Failed to open the device
Received invalid protocol version from device
```

The first part is almost always due to missing udev permissions.
Browsers (Chrome/Chromium) rely on libhid and underlying OS permissions to talk to USB HID devices. Without proper rules, VIA cannot open the USB HID interface.

---

## Step-by-Step: Add udev Rule

Create a udev rule that gives your user access to hidraw devices for your specific keyboard.

1. **Open a terminal.**

2. Create a new udev rules file:

   ```bash
   sudo nano /etc/udev/rules.d/99-via.rules
   ```

3. Add the following rule:

   ```text
   # Grant access to Lily58 (example) for VIA/WebHID
   SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="eb2d", MODE="0666", TAG+="uaccess"
   ```

   Replace the `idVendor` and `idProduct` values with your device’s USB IDs if they differ.

   Explanation of fields:

   * `SUBSYSTEM=="hidraw"`
     Matches hidraw devices (raw USB HID interfaces).
   * `ATTRS{idVendor}` / `ATTRS{idProduct}`
     Restricts the rule to your keyboard’s VID/PID.
   * `MODE="0666"`
     Makes the device readable/writable by all users.
   * `TAG+="uaccess"`
     Lets ConsoleKit/Polkit assign the device to the active session automatically.

---

## Reload and Activate the Rule

After saving the file:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Unplug and re-plug your keyboard so the new rule takes effect.

---

## Verify Device Permissions

Run:

```bash
ls -l /dev/hidraw*
```

You should see something like:

```
crw-rw-rw- 1 root root 241, 0 /dev/hidraw3
```

Or, if using `uaccess`, something like:

```
crw-rw---- 1 root INPUT 241, 0 Mar 10 12:34 /dev/hidraw3
```

Check that the device corresponding to your keyboard is now user-accessible.

---

## Browser Requirements

To use VIA with WebHID on Linux:

* Use **Google Chrome** or **Chromium**

  * Firefox does *not* support WebHID fully.
* Ensure the browser is not sandboxed in a way that blocks `hidraw` access (some Snap/Flatpak builds may be restricted).
* Open VIA at:
  [https://usevia.app/](https://usevia.app/)

When you click **“Authorize Device”**, the browser will prompt you to allow access to the keyboard.

---

## Common Pitfalls

* **Wrong udev file location or extension**
  Must be in `/etc/udev/rules.d/` and end with `.rules`.
* **Vendor/Product IDs**
  Use `lsusb` to verify the correct IDs for your board.
* **Snap/Flatpak browsers**
  These can block low-level device access; prefer a native package.
* **Session vs tty**
  The `TAG+="uaccess"` lets the active desktop session own the device. Without it, you may still get permission denied.

---

## Quick Reference

1. Create rule:

   ```text
   /etc/udev/rules.d/99-via.rules
   ```

   Example content:

   ```text
   SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="eb2d", MODE="0666", TAG+="uaccess"
   ```

2. Reload and replug:

   ```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ```

3. Launch browser (Chrome/Chromium) and open VIA.
