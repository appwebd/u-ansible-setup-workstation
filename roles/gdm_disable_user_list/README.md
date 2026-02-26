# gdm_disable_user_list

This role enforces the CIS/Wazuh requirement to disable the user list on GNOME Display Manager (GDM) by configuring dconf system-wide.

## Requirements

- `dconf` must be installed (`dconf-cli` or `dconf-service`, depending on distro).
- GDM must be installed and managed via systemd.

## Role Variables

| Variable | Default | Description |
|---------|--------|-------------|
| `gdm_dconf_profile_path` | `/etc/dconf/profile/gdm` | Path to dconf profile for GDM |
| `gdm_dconf_db_dir` | `/etc/dconf/db/gdm.d` | Directory for GDM-specific dconf databases |
| `gdm_dconf_keyfile` | `{{ gdm_dconf_db_dir }}/00-login-screen` | Keyfile path |
| `gdm_disable_user_list_enabled` | `true` | Toggle enforcement |

## Example Playbook

```yaml
- hosts: desktops
  become: yes
  roles:
    - role: gdm_disable_user_list
