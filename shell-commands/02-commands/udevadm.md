# udevadm - Device Management Tool

**udevadm** is the primary tool for querying the `udev` database and controlling the `udev` daemon. It is essential for managing device events, debugging hardware detection, and configuring device permissions.

---

## 🚀 Basic Usage

```bash
udevadm [subcommand] [options]
```

### Common Subcommands

| Subcommand | Description |
|------------|-------------|
| `info`     | Query sysfs or the udev database for device information |
| `control`  | Modify the internal state of the running udev daemon |
| `monitor`  | Listen to the kernel and udev events |
| `trigger`  | Request device events from the kernel |
| `settle`   | Watch the udev event queue, and exit when all current events are handled |

---

## 🔍 Examples

### 1. Get Device Information
To write udev rules, you need to know a device's attributes (Vendor ID, Product ID, etc.).

```bash
# Get all attributes for a device path
udevadm info --attribute-walk --path=/sys/class/net/eth0

# Get properties for a specific device node
udevadm info --query=all --name=/dev/sda
```

### 2. Monitor Device Events
Watch what happens when you plug in a USB device.

```bash
udevadm monitor --environment --udev
```

### 3. Reload Rules
After editing a file in `/etc/udev/rules.d/`, you must reload the rules for them to take effect.

```bash
sudo udevadm control --reload-rules
```

### 4. Trigger Events
If you don't want to unplug/replug a device, you can manually trigger the events.

```bash
# Trigger add events for all devices
sudo udevadm trigger

# Trigger for a specific subsystem
sudo udevadm trigger --subsystem-match=net
```

---

## 📝 Udev Rules Syntax

Udev rules are defined in files located in `/etc/udev/rules.d/` (administrator) or `/usr/lib/udev/rules.d/` (system). Files must end in `.rules`.

### Structure
A rule consists of **match keys** and **assignment keys**.

```text
MATCH_KEY=="value", MATCH_KEY=="value", ASSIGNMENT_KEY="value"
```

### Common Match Keys
*   `SUBSYSTEM`: The subsystem of the device (e.g., `net`, `usb`, `hidraw`).
*   `ACTION`: The event action (e.g., `add`, `remove`).
*   `ATTR{attribute}`: Sysfs attribute (e.g., `ATTR{address}`).
*   `ATTRS{attribute}`: Attributes of parent devices (e.g., `ATTRS{idVendor}`).
*   `KERNEL`: The kernel name of the device (e.g., `sda1`).

### Common Assignment Keys
*   `NAME`: The name of the device node.
*   `SYMLINK`: Create a symbolic link to the device node.
*   `MODE`: Set permissions (e.g., `0666`).
*   `OWNER`: Set the device owner.
*   `GROUP`: Set the device group.
*   `TAG`: Attach a tag (e.g., `uaccess` for user session access).
*   `RUN`: Run a program when the rule matches.

### Example Rule
Allow non-root users to access a specific USB device (e.g., a keyboard):

```text
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="eb2d", MODE="0666", TAG+="uaccess"
```

---

## ⚠️ Best Practices

1.  **File Naming:** Prefix your rule files with a number (e.g., `99-custom.rules`). Rules are parsed in lexical order.
2.  **Use `+=` for TAGs:** When adding tags, use `+=` to append rather than `=` to overwrite.
3.  **Check Syntax:** One typo can prevent the rule from working.
4.  **Use `ATTRS` carefully:** `ATTRS` matches up the device tree. Ensure you are matching the correct parent device attributes.

---

## 📚 Resources
*   [Arch Wiki - udev](https://wiki.archlinux.org/title/Udev)
*   `man udev`
*   `man udevadm`
