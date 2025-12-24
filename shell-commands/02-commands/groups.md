# groups - Show Group Memberships

`groups` displays the groups that the current user (or specified user) belongs to. For VM setup, this is used to verify you're in the `libvirt` group.

---

## 📋 Quick Reference

```bash
groups                # Current user's groups
groups <username>     # Specific user's groups
groups | grep libvirt # Check for libvirt group
```

---

## Show Current User's Groups

```bash
groups
```

**Output:**

```
users wheel libvirt
```

**What it shows:**

- All groups current user belongs to
- Primary group first
- Supplementary groups after

---

## Show Specific User's Groups

```bash
groups username
```

**Example:**

```bash
groups alice
```

**Output:**

```
alice : users wheel libvirt
```

---

## Check for Specific Group

**For VM setup, check libvirt group:**

```bash
groups | grep libvirt
```

**Expected output:**

```
libvirt
```

**If nothing appears:**

- User not in libvirt group
- Add user: `sudo usermod -aG libvirt $(whoami)`
- Log out and log back in

---

## VM Context

### Verify libvirt Group Membership

**After adding user to libvirt group:**

```bash
# Check groups
groups

# Or check specifically
groups | grep libvirt
```

**If libvirt appears:**

- User has correct permissions
- Can manage VMs without root

**If libvirt doesn't appear:**

- User not in group
- Need to add: `sudo usermod -aG libvirt $(whoami)`
- Need to log out and log back in

---

## Troubleshooting

**Problem:** Added user to libvirt group but `groups` doesn't show it

**Solution:**

1. Verify command was correct: `sudo usermod -aG libvirt $(whoami)`
2. **Log out and log back in** (required!)
3. Check again: `groups | grep libvirt`

**Problem:** Permission denied when using virsh

**Solution:**

1. Check groups: `groups | grep libvirt`
2. If not in group, add: `sudo usermod -aG libvirt $(whoami)`
3. Log out and log back in
4. Try again: `virsh list --all`

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **usermod command:** [`usermod.md`](usermod.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
