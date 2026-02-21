# Ansible Workstation Setup Documentation

This directory contains documentation for the Ansible-based workstation provisioning and hardening project.

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `skills.md` | **Role inventory and usage guide** - Complete catalog of 37+ roles organized by function |
| `ansible_best_practices.md` | **Best practices reference** - Coding standards, FQCN, handlers, testing, and security |
| `README.ai.md` | This file - Project overview and getting started guide |

## 📂 Project Structure

```
u-ansible-setup-workstation/
├── bin/                    # Helper scripts (install-ansible, lint wrappers, playbook runners)
│   ├── install-ansible.sh
│   ├── run_ansible_lint.sh
│   └── run_setup_workstation.sh
├── inventory/              # Ansible inventory files (singular)
│   ├── inventory.ini
│   └── inventory.ini.example
├── roles/                  # Reusable Ansible roles (37+ roles across 6 categories)
│   ├── aide/
│   ├── sshd/
│   ├── sudo/
│   └── ...
├── playbooks/              # High-level playbooks
│   ├── setup_workstation.yaml
│   ├── update_upgrade.yaml
│   └── ...
├── group_vars/             # Group-specific variables
├── host_vars/              # Host-specific variables
├── ansible.cfg             # Ansible configuration
├── ansible-lint.yaml       # Linting rules and exclusions
└── prompts/                # Documentation files
```

## 🎯 Documentation Overview

### Skills Documentation (`prompts/skills.md`)

The [skills.md](skills.md) file serves as the **primary role catalog and usage guide**. It includes:

- **37+ roles organized into 6 functional categories**:
  - Security & Hardening (14 roles)
  - System Configuration (7 roles)
  - PAM & Authentication Security (5 roles)
  - Package Management & Updates (5 roles)
  - Monitoring & Logging (2 roles)
  - Desktop & Workspace (2 roles)

- **Role status indicators** (`✅ Linted`, `⚠️ Missing meta`, `📝 No README`)
- **Prerequisites checklist** for running playbooks
- **Troubleshooting guide** with common issues and solutions
- **Glossary** of Ansible concepts (FQCN, handlers, notify, etc.)

### Best Practices (`prompts/ansible_best_practices.md`)

The [ansible_best_practices.md](ansible_best_practices.md) file contains **detailed guidance** on:

- **Fully Qualified Collection Names (FQCN)** - Required for Ansible 2.16+
- **Handler patterns** - Dynamic service detection, debouncing notifications
- **Idempotency best practices** - Using modules over shell commands
- **Variable management** - Scopes, precedence, and vault usage
- **Testing & linting** - ansible-lint, molecule, yamllint
- **Security** - Vault usage, no_log, and secure coding patterns

## 🚀 Getting Started

### Prerequisites

- Ansible ≥ 2.16
- Python ≥ 3.8
- Access to target systems via SSH or local connection

### Quick Start

1. **Review the inventory**
   ```bash
   git clone https://github.com/appwebd/u-ansible-setup-workstation
   cd u-ansible-setup-workstation/inventory
   mv inventory.ini.example inventory.ini
   cat inventory/inventory.ini
   ```

2. **Run a playbook**
   ```bash
   # Using the helper script
   ./bin/run_setup_workstation.sh

   # Or manually
   ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml -b -K
   ```

3. **Check for linting issues**
   ```bash
   ./bin/run_ansible_lint.sh
   ```

## 📋 Available Playbooks

| Playbook | Purpose |
|----------|---------|
| `setup_workstation.yaml` | Complete workstation setup with all Wazuh/Lynis recommendations |
| `update_upgrade.yaml` | Package updates and security patches |
| `remove_bloatware_packages.yaml` | Remove unwanted software packages |
| `remove_unused_accounts_groups.yaml` | Clean up unused system accounts and groups |
| `shutdown.yaml` | Graceful system shutdown |

## 🔧 Helper Scripts (`bin/`)

| Script | Purpose |
|--------|---------|
| `install-ansible.sh` | Install or update Ansible on the system |
| `run_ansible_lint.sh` | Run ansible-lint with project-specific configuration |
| `run_setup_workstation.sh` | Execute the main workstation setup playbook |
| `run_update_upgrade.sh` | Apply system updates and patches |

## 🏷️ Role Categories

### Security & Hardening (14 roles)
SSH, AIDE, auditd, fail2ban, rkhunter, tripwire, system hardening, and more.

### System Configuration (7 roles)
Timezone, GRUB, login banner, login_defs, sysctl, sysstat, and timezone.

### PAM & Authentication Security (5 roles)
PAM password history, pwquality, unix authentication, and PAM module configuration.

### Package Management & Updates (5 roles)
Unattended upgrades, suggested packages (server and desktop), and update management.

### Monitoring & Logging (2 roles)
Systemd journal upload and system monitoring configuration.

### Desktop & Workspace (2 roles)
GNOME settings and OTP client configuration.

## 🔍 Role Status

Some roles are missing required files:

| Role | Status |
|------|--------|
| `aide` | ⚠️ Missing `meta/main.yml` |
| `configure_timezone` | ⚠️ Missing `meta/main.yml` |
| `sudo` | ⚠️ Missing `defaults/main.yml` and `meta/main.yml` |
| `sshd` | ⚠️ Missing `README.md` |
| `pam_pwhistory` | ⚠️ Missing `meta/main.yml` |
| `pam_pwhistory_module_is_enable` | ⚠️ Missing `meta/main.yml` |

## 📝 Running Playbooks with Tags

```bash
# Run only security-related tasks
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml \
  --tags "security,hardening"

# Skip expensive operations
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml \
  --skip-tags "install-packages"

# Dry run (check mode)
ansible-playbook -i inventory/inventory.ini playbooks/setup_workstation.yaml \
  --check --diff
```

## 🔧 Configuration Files

| File | Description |
|------|-------------|
| `ansible.cfg` | Main Ansible configuration (inventory path, interpreter settings, SSH pipelining) |
| `ansible-lint.yaml` | Linting rules with strict mode, FQCN warnings, and path exclusions |

## 📖 Additional Resources

- [Ansible Official Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Wazuh Compliance Rules](https://documentation.wazuh.com/)
- [Lynis Security Hardening](https://cisofy.com/lynis/)

## 🤝 Contributing

1. Follow the patterns in `ansible_best_practices.md`
2. Use FQCN for all modules (`ansible.builtin.apt` not `apt`)
3. Document new roles with `README.md` and `meta/main.yml`
4. Test changes with `./bin/run_ansible_lint.sh`
5. Update `skills.md` when adding new roles

## 📄 License

MIT © 2024 The u-ansible-setup-workstation team
