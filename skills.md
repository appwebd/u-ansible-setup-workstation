# Ansible Role & Playbook Skill Set

This repository encapsulates a comprehensive set of Ansible roles and playbooks aimed at provisioning, hardening, and maintaining Linux workstations. Below is a high‑level overview of the skills and capabilities exposed by the roles and playbooks.

## Core Role Categories

| Role Category                     | Key Focus                                         | Representative Roles                                                                                                                       |
|-----------------------------------|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| **Security Hardening**            | System hardening, intrusion detection, auditing   | `hardening_debian`, `rkhunter`, `tripwire`, `sshd`, `sudo`, `auditd`, `fail2ban`, `grub_audit_backlog`                                     |
| **System Configuration**          | Timezone, login, user & group management          | `configure-timezone`, `configure_login_defs`, `configure_local_login_banner`, `remove_unused_accounts_groups`                              |
| **Package & Update Management**   | OS upgrades, unattended upgrades, package removal | `update_upgrade`, `unattended_upgrades`, `remove_bloatware_packages`, `suggested_software_packages`, `suggested_software_packages_desktop` |
| **Monitoring & Logging**          | System monitoring, logging, resource usage        | `sysstat`, `file_permission`, `auditd`                                                                                                     |
| **Desktop & Desktop Environment** | Gnome configuration, desktop packages             | `gnome`, `suggested_software_packages_desktop`                                                                                             |
| **Miscellaneous**                 | OTP client, AIDE (Integrity)                      | `otpclient`, `aide`                                                                                                                        |

## Playbooks

| Playbook                             | Purpose                                                                                                                              |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `setup_workstation.yaml`             | Full workstation bootstrap – installs OS packages, applies hardening, configures users, sets up services, and finalizes environment. |
| `update_upgrade.yaml`                | Performs system upgrades and package updates.                                                                                        |
| `remove_bloatware_packages.yaml`     | Strips out unnecessary packages for a lean environment.                                                                              |
| `remove_unused_accounts_groups.yaml` | Cleans up orphaned users and groups.                                                                                                 |
| `shutdown.yaml`                      | Gracefully shuts down the machine after provisioning.                                                                                |

## How to Use

```bash
# Run the full workstation provisioning
ansible-playbook -i inventory/your_inventory playbooks/setup_workstation.yaml

# Run specific role or playbook as needed
ansible-playbook -i inventory/your_inventory playbooks/update_upgrade.yaml
```

## Skill Summary

- **System Hardening**: Enforce SELinux/AppArmor policies, secure SSH, set login restrictions, audit trails.
- **Automated Updates**: Keep the system current with unattended upgrades and manual update playbooks.
- **Package Management**: Install essential dev tools, remove bloatware, manage desktop environment.
- **Logging & Monitoring**: Enable `sysstat`, audit logs, and integrity checks with AIDE.
- **User & Group Policies**: Automate user creation, group cleanup, password policy enforcement.
- **Time & Locale Configuration**: Standardize timezone, NTP, and locale settings across all hosts.

Feel free to extend the roles or create new ones to fit your environment. Happy provisioning!