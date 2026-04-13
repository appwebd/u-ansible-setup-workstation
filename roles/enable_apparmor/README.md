## Role name: enable_apparmor
## Wazuh ID : 35537
## Title    : Ensure AppArmor is enabled via kernel parameters.
    
## Description:
    This Ansible role ensures that the AppArmor kernel module is enabled by adding the required boot parameters 
    (`apparmor=1` and `security=apparmor`) to the GRUB configuration. This allows the system to enforce mandatory 
    access control policies at boot time. Addresses Wazuh/CIS rule **35537**.

## Rationale:
    AppArmor provides additional defense-in-depth by confining programs to a limited set of resources. Disabling 
    or not enabling AppArmor increases the system's exposure to compromise, especially if other security layers 
    fail.

## Remediation:
    Edit `/etc/default/grub`, append `apparmor=1 security=apparmor` to `GRUB_CMDLINE_LINUX`, then run `update-grub`.

## Requirements            
    - Ansible 2.16 or higher
    - Root/sudo privileges (become: true)
    - System using GRUB2 (e.g., Ubuntu ≥16.04, Debian ≥9)
    - `grub2` or `grub` package installed (typically `grub-pc` or `grub-efi`)
    - `update-grub` utility available

## Variables

| Variable                           | Default                               | Description                          |
|------------------------------------|---------------------------------------|--------------------------------------|
| `configure_grub_path_default_grub` | `/etc/default/grub`                   | GRUB configuration file path         |
| `apparmor_kernel_params`           | `["apparmor=1", "security=apparmor"]` | Kernel parameters to enable AppArmor |
| `apparmor_grub_update_command`     | `/usr/sbin/update-grub`               | Command to regenerate GRUB config    |

## Dependencies
    None. Compatible with standard GRUB2-based distributions.

## Compliance mapping
    'cmmc': ['AC.L2-3.1.20'], 
    'fedramp': ['AC-2', 'AC-2(4)', 'SC-30'], 
    'gdpr': ['32'], 
    'hipaa': ['164.308(a)(1)', '164.312(a)(1)'], 
    'iso_27001': ['A.8.2.3', 'A.12.1.1', 'A.14.2.1'], 
    'nis2': ['21.2.e', '21.2.a'], 
    'nist_800_171': ['3.13.1', '3.5.1'], 
    'nist_800_53': ['AC-2(4)', 'SC-30'], 
    'pci_dss': ['1.3.1', '6.4.2'], 
    'tsc': ['CC6.3', 'CC6.6', 'CC8.1']

## Mitre
    'tactic': ['TA0001', 'TA0005'], 
    'technique': ['T1548', 'T1564']

## Conditions
     all (Debian-based systems with GRUB2)

## Rules
    - "c:grub-config-query /etc/default/grub -> r:'apparmor=1' and 'security=apparmor' must be present in GRUB_CMDLINE_LINUX"

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - enable_apparmor
```

Optionally override variables in inventory:

```yaml
apparmor_grub_cmdline_value: "apparmor=1 security=apparmor quiet splash"
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
