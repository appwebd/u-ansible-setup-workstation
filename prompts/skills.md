---
title: Ansible Role & Playbook Skill Set
description: Comprehensive Ansible roles and playbooks for Linux workstation provisioning and hardening
keywords: ansible, linux, security, hardening, automation, devops, workstation setup
version: 2.0.0
author: Ansible Team
last_updated: 2026
---

[TOC]

## 📋 Project Metadata

| Property         | Value                     |
|------------------|---------------------------|
| **Name**         | Ansible Setup Workstation |
| **Version**      | 2.0.0                     |
| **Author**       | Ansible Team              |
| **Last Updated** | 2026                      |
| **License**      | MIT                       |
| **Language**     | Ansible, YAML             |
| **Ansible**      | ≥ 2.16 (requires FQCN)    |

> **IMPORTANT** This project requires Ansible 2.16 or newer with Fully Qualified Collection Names (FQCN) for all modules.

## 🚀 Introduction

This repository contains a complete set of Ansible roles and playbooks designed for the provisioning, hardening, and maintenance of Linux workstations. It provides an automated solution to standardise development, production, and lab environments.

### Project Structure

```
project_root/
├── bin/                   # Helper scripts (install, lint, run wrappers)
├── inventory/             # Ansible inventory files (singular)
├── group_vars/            # Group variables
├── host_vars/             # Host-specific variables
├── roles/                 # Ansible roles
│   ├── my_role/
│   │   ├── defaults/      # Default variables (lowest priority)
│   │   ├── vars/          # Role-specific variables (higher priority)
│   │   ├── tasks/         # Main task definitions
│   │   ├── handlers/      # Handlers (notify-based)
│   │   ├── templates/     # Jinja2 templates
│   │   ├── files/         # Static files
│   │   ├── meta/          # Role metadata (dependencies, galaxy info)
│   │   └── README.md      # Role documentation (required)
│   └── ...
├── playbooks/             # High-level playbooks
│   ├── setup_workstation.yaml
│   ├── update_upgrade.yaml
│   └── ...
├── ansible.cfg            # Ansible configuration
└── requirements.yml       # Collections and roles dependencies
```

* Keep roles reusable - each role should be self-contained.
* Use `defaults/main.yml` for default variables and `vars/main.yml` for role-specific variables that override defaults.
* Keep playbooks short and delegating to roles.

### Prerequisites

1. Ansible 2.16+ installed
2. Python 3.8+ installed
3. SSH key authentication configured
4. Target hosts accessible via SSH

## 📦 System Roles

### Category: Security & Hardening

| Role                          | Description                                    | Dependencies     | Status     |
|-------------------------------|------------------------------------------------|------------------|------------|
| `hardening_debian`            | Basic security configuration for Debian/Ubuntu | `sshd`, `sudo`   | ✅         |
| `sshd`                        | Secure SSH configuration                       | `openssh-server` | ✅         |
| `sshd_privsep_fix`            | SSH privilege separation hardening             | `sshd`           | ✅         |
| `sudo`                        | Sudo configuration & access control            | `sudo`           | ✅         |
| `auditd`                      | System event auditing                          | `auditd`         | ✅         |
| `fail2ban`                    | DDoS & brute-force protection                  | `python`         | ✅         |
| `rkhunter`                    | Rootkit Hunter - malware detection             | `rkhunter`       | ✅         |
| `tripwire`                    | Integrity-based intrusion detection            | `openssl`        | ✅         |
| `aide`                        | File integrity monitoring                      | `aide`           | ✅         |
| `aide_audit_tools`            | AIDE audit tools configuration                 | `aide`           | ✅         |
| `configure_grub`              | GRUB configuration for boot security           | `grub-pc`        | ✅         |
| `grub_audit_backlog`          | GRUB audit backlog configuration               | `grub-pc`        | ✅         |
| `disable_kernel_modules`      | Disable unnecessary kernel modules             | `modprobe`       | ✅         |
| `sysctl_conf`                 | System parameter hardening                     | `sysctl`         | ✅         |
| `remove_prelink`              | Prelink security configuration                 | `prelink`        | ✅         |
| `at_security`                 | AT/DAT security configuration                  | `at`             | ✅         |
| `at_deny_accounts`            | Deny users from using AT/DAT                   | `at`             | ✅         |
| `disable_user_list_gdm`       | Disable user listing in GDM                    | `gdm3`           | ✅         |
| `disable_rsync`               | Disable rsync daemon                           | `rsync`          | ✅         |
| `disable_wireless`            | Disable wireless interfaces                    | `wireless-tools` | ✅         |
| `configure_bootloader_access` | Configure bootloader access control            | `grub-pc`        | ✅         |
| `lock_inactive_password`      | Lock inactive password accounts                | `passwd`         | ✅         |
| `shells_nologin`              | Set nologin shell for service accounts         | `bash`           | ✅         |
| `root_umask`                  | Configure root umask                           | N/A              | ✅         |
| `otpclient`                   | One-time password client configuration         | N/A              | ✅         |
> **NOTE** Security roles must run before configuration roles.

### Category: System Configuration

| Role                                   | Description                           | Dependencies         | Status     |
|----------------------------------------|---------------------------------------|----------------------|------------|
| `configure_timezone`                   | Time-zone configuration               | `tzdata`             | ⚠️ Missing meta |
| `configure_login_defs`                 | login_defs configuration              | `logindefs`          | ✅         |
| `configure_local_login_banner`         | Local login banner                    | `banner`             | ✅         |
| `configure_remote_login_banner`        | Remote login banner                   | `banner`             | ✅         |
| `configure_motd`                       | Message of the day configuration      | `motd`               | ✅         |
| `remove_unused_accounts_groups`        | Cleanup orphan accounts & groups      | `passwd`, `groupadd` | ✅         |
| `shells_nologin`                       | Disable interactive shells            | `usermod`            | ✅         |
| `at_security`                          | AT daemon security configuration      | `at`                 | ✅         |
| `at_deny_accounts`                     | AT access control                     | `at`                 | ✅         |
| `root`                                 | Root account hardening                | `passwd`             | ✅         |
| `root_umask`                           | Root user umask configuration         | `useradd`            | ✅         |
| `configure_cron_daily_permissions`     | Configure daily cron permissions      | `cron`               | ✅         |
| `configure_cron_hourly_permissions`    | Configure hourly cron permissions     | `cron`               | ✅         |
| `configure_cron_monthly_permissions`   | Configure monthly cron permissions    | `cron`               | ✅         |
| `configure_cron_weekly_permissions`    | Configure weekly cron permissions     | `cron`               | ✅         |
| `configure_cron_d_permissions`         | Configure cron.d permissions          | `cron`               | ✅         |
| `configure_crontab_permissions`        | Configure crontab permissions         | `cron`               | ✅         |
| `configure_grub`                       | GRUB bootloader security              | `grub`               | ✅         |
| `configure_bootloader_access`          | Bootloader access configuration       | `grub`               | ✅         |
| `configure_rsyslog_creation_mode`      | Rsyslog creation mode configuration   | `rsyslog`            | ✅         |
| `enable_systemd_timesyncd`             | Enable systemd-timesyncd service      | `systemd`            | ✅         |
| `disable_kernel_modules`               | Disable unnecessary kernel modules    | `modprobe`           | ✅         |
| `disable_rsync`                        | Disable rsync service                 | `rsync`              | ✅         |
| `disable_user_list_gdm`                | Disable user list in GDM              | `gdm`                | ✅         |
| `disable_wireless`                     | Disable wireless functionality        | `network`            | ✅         |
| `enable_rsyslog`                       | Enable rsyslog service                | `rsyslog`            | ✅         |
| `file_permission`                      | File permission configuration         | `chmod`, `chown`     | ✅         |
| `ensure_login_defs_pass_min_days`      | Password minimum days requirement     | `logindefs`          | ✅         |
| `ensure_shadows`                       | Ensure proper shadow file permissions | `shadow`             | ✅         |
| `sysctl_conf`                          | Sysctl kernel parameters configuration | `sysctl`            | ✅         |


### Category: PAM & Authentication Security

| Role                                       | Description                                | Dependencies | Status     |
|--------------------------------------------|-------------------------------------------|--------------|------------|
| `pam_pwhistory`                            | Password history enforcement              | `pam`        | ⚠️ Shell commands |
| `pam_pwhistory_module_is_enable`           | PAM module enablement                     | `pam`        | ✅         |
| `pam_pwquality`                            | Password quality enforcement              | `pam`        | ✅         |
| `pam_unix_remove_nullok`                   | Remove null OK authentication             | `pam`        | ✅         |
| `pam_unix_remove_nullok_in_pam.d`          | PAM.d null OK removal                     | `pam`        | ✅         |
| `otpclient`                                | Install otpclient                         |     N/A      | ✅         |
| `lock_inactive_password`                   | Password and Shadow lock inactive         |     N/A      | ✅         |

### Category: Package Management & Updates

| Role                                  | Description                          | Dependencies          | Status     |
|--------------------------------------|-------------------------------------|-----------------------|------------|
| `update_upgrade`                      | System update                      | `apt`, `aptitude`     | ✅         |
| `unattended_upgrades`                 | Automatic unattended upgrades      | `unattended-upgrades` | ✅         |
| `remove_bloatware_packages`           | Remove unnecessary packages        | `apt`, `dpkg`         | ✅         |
| `suggested_software_packages`         | Suggested software packages        | `apt`                 | ✅         |
| `suggested_software_packages_desktop` | Suggested desktop packages         | `apt`, `gnome`        | ✅         |

### Category: Monitoring & Logging

| Role              | Description                          | Dependencies | Status     |
|-------------------|-------------------------------------|--------------|------------|
| `sysstat`         | System resource monitoring          | `sysstat`    | ✅         |
| `file_permission` | File permission configuration       | `chmod`, `chown` | ✅         |

### Category: Desktop & Workspace

| Role                                  | Description                | Dependencies    | Status     |
|---------------------------------------|---------------------------|-----------------|------------|
| `gnome`                               | GNOME configuration        | `gnome`, `gdm3` | ✅         |
| `otpclient`                           | OTP client for 2FA         | `libsecret-1-0` | ✅         |

## ▶️ Automation Playbooks

| Playbook                             | Purpose                         | Roles Used                              | Estimated Duration  |
|--------------------------------------|---------------------------------|-----------------------------------------|---------------------|
| `setup_workstation.yaml`             | Full workstation bootstrap      | All roles                               | 15-30 min           |
| `update_upgrade.yaml`                | System and package updates      | `update_upgrade`, `unattended_upgrades` | 5-10 min            |
| `remove_bloatware_packages.yaml`     | Remove unnecessary packages     | `remove_bloatware_packages`             | 2-5 min             |
| `remove_unused_accounts_groups.yaml` | Remove orphan accounts & groups | `remove_unused_accounts_groups`         | 1-2 min             |
| `shutdown.yaml`                      | Graceful system shutdown        | N/A                                     | 1-2 min             |

## 🔧 How to Use

### Full Bootstrap Execution

```bash
# Provision the entire workstation
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml

# Verbose output
ansible-playbook -vvv -i inventory/inventory.ini playbooks/setup_workstation.yaml

# Check mode (dry-run)
ansible-playbook -C -i inventory/inventory.ini playbooks/setup_workstation.yaml

# Run with tags
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml \
  --tags "security,packages"

# Skip tags
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml \
  --skip-tags "desktop"
```

### Execute Individual Playbooks

```bash
# Update system
ansible-playbook -i inventory/inventory.ini playbooks/update_upgrade.yaml

# Remove unnecessary packages
ansible-playbook -i inventory/inventory.ini playbooks/remove_bloatware_packages.yaml

# Remove orphan accounts and groups
ansible-playbook -i inventory/inventory.ini playbooks/remove_unused_accounts_groups.yaml

# Shutdown
ansible-playbook -i inventory/inventory.ini playbooks/shutdown.yaml
```

### Example Inventory

```ini
# inventory/inventory.ini
[workstations]
workstation1.example.com ansible_user=root ansible_become=true
workstation2.example.com ansible_user=ansible ansible_become=true

[workstations:vars]
ansible_python_interpreter=/usr/bin/python3
```

### Using bin/ Helper Scripts

```bash
# Install Ansible
./bin/install-ansible.sh

# Run linter
./bin/run_ansible_lint.sh

# Execute setup
./bin/run_setup_workstation.sh

# Execute updates
./bin/run_update_upgrade.sh
```

## 🏗️ System Architecture

```mermaid
graph TD
    A[Main Playbook] --> B[Security & Hardening Roles]
    A --> C[PAM & Authentication Roles]
    A --> D[Configuration Roles]
    A --> E[Package & Update Roles]
    A --> F[Monitoring & Logging Roles]
    A --> G[Desktop & Workspace Roles]
    
    B --> B1[hardening_debian]
    B --> B2[rkhunter]
    B --> B3[tripwire]
    B --> B4[sshd]
    B --> B4b[sshd_privsep_fix]
    B --> B5[sudo]
    B --> B6[auditd]
    B --> B7[fail2ban]
    B --> B8[grub_audit_backlog]
    B --> B9[aide]
    B --> B9b[aide_audit_tools]
    B --> B10[configure_grub]
    B --> B11[configure_bootloader_access]
    B --> B12[disable_kernel_modules]
    B --> B13[sysctl_conf]
    B --> B14[remove_prelink]
    B --> B15[at_security]
    B --> B16[at_deny_accounts]
    B --> B17[disable_user_list_gdm]
    B --> B18[disable_rsync]
    B --> B19[disable_wireless]
    B --> B20[lock_inactive_password]
    B --> B21[root_umask]
    B --> B22[configure_timezone]
    B --> B23[configure_login_defs]
    B --> B24[configure_local_login_banner]
    B --> B25[configure_remote_login_banner]
    B --> B26[configure_motd]
    B --> B27[root]
    B --> B28[configure_cron_daily_permissions]
    B --> B29[configure_cron_hourly_permissions]
    B --> B30[configure_cron_monthly_permissions]
    B --> B31[configure_cron_weekly_permissions]
    B --> B32[configure_cron_d_permissions]
    B --> B33[configure_crontab_permissions]
    B --> B34[configure_rsyslog_creation_mode]
    B --> B35[enable_systemd_timesyncd]
    B --> B36[enable_rsyslog]
    B --> B37[ensure_login_defs_pass_min_days]
    B --> B38[ensure_shadows]
    
    C --> C1[pam_pwhistory]
    C --> C2[pam_pwhistory_module_is_enable]
    C --> C3[pam_pwquality]
    C --> C4[pam_unix_remove_nullok]
    C --> C5[pam_unix_remove_nullok_in_pam.d]
    C --> C6[otpclient]
    C --> C7[lock_inactive_password]
    
    D --> D1[configure_timezone]
    D --> D2[configure_login_defs]
    D --> D3[configure_local_login_banner]
    D --> D4[configure_remote_login_banner]
    D --> D5[configure_motd]
    D --> D6[remove_unused_accounts_groups]
    D --> D7[shells_nologin]
    D --> D8[at_security]
    D --> D9[at_deny_accounts]
    D --> D10[root]
    D --> D11[root_umask]
    D --> D12[configure_cron_daily_permissions]
    D --> D13[configure_cron_hourly_permissions]
    D --> D14[configure_cron_monthly_permissions]
    D --> D15[configure_cron_weekly_permissions]
    D --> D16[configure_cron_d_permissions]
    D --> D17[configure_crontab_permissions]
    D --> D18[configure_grub]
    D --> D19[configure_bootloader_access]
    D --> D20[configure_rsyslog_creation_mode]
    D --> D21[enable_systemd_timesyncd]
    D --> D22[disable_kernel_modules]
    D --> D23[disable_rsync]
    D --> D24[disable_user_list_gdm]
    D --> D25[disable_wireless]
    D --> D26[enable_rsyslog]
    D --> D27[file_permission]
    D --> D28[ensure_login_defs_pass_min_days]
    D --> D29[ensure_shadows]
    
    E --> E1[update_upgrade]
    E --> E2[unattended_upgrades]
    E --> E3[remove_bloatware_packages]
    E --> E4[suggested_software_packages]
    E --> E5[suggested_software_packages_desktop]
    
    F --> F1[sysstat]
    F --> F2[file_permission]
    
    G --> G1[gnome]
    G --> G2[otpclient]
    
    H[Specific Playbooks] --> H1[setup_workstation.yaml]
    H --> H2[update_upgrade.yaml]
    H --> H3[remove_bloatware_packages.yaml]
    H --> H4[remove_unused_accounts_groups.yaml]
    H --> H5[shutdown.yaml]

```

## 📋 Use Cases

### 1. Development (DevOps) Environment

**Goal**: Standardise developer workstations

```bash
ansible-playbook -i inventory/dev playbooks/setup_workstation.yaml
```

**Key Roles**: `sshd`, `fail2ban`, `update_upgrade`, `suggested_software_packages`.

### 2. Production Environment

**Goal**: Full hardening of production workstations

```bash
ansible-playbook -i inventory/production playbooks/setup_workstation.yaml
```

**Key Roles**: All security roles, `auditd`, `unattended_upgrades`.

### 3. Lab / Home Lab

**Goal**: Rapid, custom configuration

```bash
# Run only necessary roles
ansible-playbook -i inventory/lab playbooks/remove_bloatware_packages.yaml
ansible-playbook -i inventory/lab playbooks/suggested_software_packages.yaml
```

### 4. Security Auditing

**Goal**: Verify security configurations

```bash
ansible-playbook -C -i inventory/audit playbooks/setup_workstation.yaml
```

### 5. Partial Runs with Tags

**Goal**: Run only specific tasks

```bash
# Only configure SSH
ansible-playbook -i inventory/workstations playbooks/setup_workstation.yaml \
  --tags "sshd"

# Install packages only
ansible-playbook -i inventory/workstations playbooks/setup_workstation.yaml \
  --tags "packages"
```

## 🔍 Troubleshooting

### Issue: Playbook fails with "Permission denied"

```bash
ansible-playbook -i inventory/workstations playbooks/setup_workstation.yaml --become
```

### Issue: Automatic upgrades not applied

* Verify that `unattended_upgrades` ran successfully.
* Check logs: `journalctl -u unattended-upgrades.service`.

### Issue: SSH cannot connect after hardening

* Verify `sshd` configuration in the role.
* Check firewall: `iptables -L -n` or `ufw status`.
* Ensure `sshd_privsep_fix` role is included for proper configuration.

### Issue: Security roles block system access

* SSH into the machine using configured keys.
* Create a rescue account: `useradd rescue`.
* Review `sudo` configuration for special accounts.

### Useful Debug Commands

```bash
# Ping all hosts
ansible all -m ping

# Check syntax
ansible-playbook --syntax-check playbooks/setup_workstation.yaml

# Lint check
ansible-lint playbooks/setup_workstation.yaml

# Preview changes
ansible-playbook -C -v playbooks/setup_workstation.yaml

# Detailed output
ansible-playbook -vvvv playbooks/setup_workstation.yaml

# See what files changed
ansible-playbook --diff playbooks/setup_workstation.yaml
```

## 📚 Glossary

| Term                    | Definition                                                          |
|-------------------------|---------------------------------------------------------------------|
| **Ansible**             | Configuration automation system written in Python                   |
| **Playbook**            | YAML file that defines Ansible task sequences                       |
| **Role**                | Reusable component that groups variables, tasks, and files          |
| **FQCN**                | Fully Qualified Collection Name (e.g., `ansible.builtin.apt`)      |
| **Hardening**           | Process of strengthening system security                            |
| **Unattended Upgrades** | Automatic system upgrades without user intervention                 |
| **Auditd**              | System event auditing tool                                          |
| **Rootkit**             | Hidden software that installs on a system to gain privileged access |
| **Fail2ban**            | Protection against brute-force attacks                              |
| **Bloatware**           | Unnecessary or wasteful software that consumes system resources     |
| **Handler**             | Task that runs only when notified by another task                   |
| **Notify**              | Mechanism to trigger handlers after task changes                    |

## 🛠️ Future Improvements

| Status   | Suggestion                                  | Priority |
|----------|---------------------------------------------|----------|
| 📝       | Complete role metadata (meta/main.yml)      | High     |
| 📝       | Document all roles with README.md           | High     |
| 📝       | Migrate short module names to FQCN          | High     |
| 📝       | Add Molecule tests for critical roles       | Medium   |
| 📝       | CI/CD pipeline with ansible-lint, yamllint  | Medium   |
| 📝       | Implement vault password management         | Medium   |
| 🧪       | Unit tests for roles                        | Low      |
| 📊       | Security compliance metrics                 | Low      |
| 🌍       | Translation to other languages              | Low      |

## 📖 Additional Resources

* [Official Ansible Documentation](https://docs.ansible.com/)
* [Ansible Best Practices](prompts/ansible_best_practices.md)
* [Ansible Community](https://community.ansible.com/)
* [Ansible Lint Documentation](https://ansible-lint.readthedocs.io/)

### Configuration Files

* `.ansible-lint.yaml` - Linting configuration
* `ansible.cfg`        - Ansible main configuration
* `requirements.yml`   - Collection dependencies

## 📝 License

This project is licensed under the MIT license. See the `LICENSE` file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 Changes

### Version 2.0.0 (2026)
* Updated to Ansible 2.16+ with FQCN requirements
* Reorganised roles by functional categories
* Added PAM security roles section
* Added helper scripts from bin/ directory
* Updated troubleshooting section with latest fixes
* Added tag-based partial run examples

### Version 1.0.0
* Initial structured documentation
* Role categorisation introduced
* Architecture diagram added

