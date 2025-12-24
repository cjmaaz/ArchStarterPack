# usermod - Modify User Account

`usermod` modifies user account properties. For VM setup, this is used to add your user to the `libvirt` group so you can manage VMs without root access.

---

## 📋 Quick Reference

```bash
sudo usermod -aG <group> <username>  # Add user to group
sudo usermod -aG libvirt $(whoami)   # Add current user to libvirt group
```

---

## Add User to Group

**Most common use for VM setup:**

```bash
sudo usermod -aG libvirt $(whoami)
```

**What it does:**

- Adds current user to `libvirt` group
- `-a` = append (don't remove from other groups)
- `-G` = supplementary groups
- `$(whoami)` = current username

**After running this:**
⚠️ **You must log out and log back in** for the change to take effect.

---

## Add Specific User to Group

```bash
sudo usermod -aG libvirt username
```

**Example:**

```bash
sudo usermod -aG libvirt alice
```

**What it does:**

- Adds user `alice` to `libvirt` group
- User must log out and log back in

---

## Verify Group Membership

**After logging back in:**

```bash
groups
```

**Expected output:**

```
users wheel libvirt
```

Should show `libvirt` in the list.

**Or check specific group:**

```bash
groups | grep libvirt
```

---

## Why This Matters

**Without libvirt group:**

- Permission denied errors when managing VMs
- Cannot use virt-manager without root
- Cannot use virsh without root

**With libvirt group:**

- Can manage VMs as regular user
- No need for root/sudo for VM operations
- Safer (no root access required)

---

## VM Context

### Setup User Permissions

**Step 1: Add user to libvirt group**

```bash
sudo usermod -aG libvirt $(whoami)
```

**Step 2: Log out and log back in**

**Step 3: Verify**

```bash
groups | grep libvirt
```

**Step 4: Test**

```bash
virsh list --all
```

Should work without `sudo`.

---

## Other Common Uses

**Change user's home directory:**

```bash
sudo usermod -d /new/home/path username
```

**Change user's shell:**

```bash
sudo usermod -s /bin/bash username
```

**Lock user account:**

```bash
sudo usermod -L username
```

**Unlock user account:**

```bash
sudo usermod -U username
```

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **groups command:** [`groups.md`](groups.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
