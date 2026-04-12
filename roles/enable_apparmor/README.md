## Role name: enable_apparmor
## Wazuh ID : 35537
## Title    : Enable AppArmor in bootloader configuration.

## Description:
This Ansible role enables AppArmor by modifying GRUB bootloader configuration to include the `apparmor=1` and `security=apparmor` kernel command-line parameters on Ubuntu 24.04 systems. This addresses security rule **35537** (Wazuh/CIS).

## Rationale:
AppArmor is a Linux Kernel security module that restricts programs' capabilities. It is recommended for Ubuntu systems to enforce mandatory access controls and reduce the impact of potential exploits.

## Remediation:
Edit `/etc/default/grub` to ensure the kernel command line includes `apparmor=1` and `security=apparmor`, then run `update-grub`.

## Requirements

- Ansible 2.16 or higher
- Root/sudo privileges (become: true)
- Ubuntu 24.04
- `grub` and `apparmor` packages must be available

## Variables

| Variable                        | Default                               | Description                                       |
|---------------------------------|---------------------------------------|---------------------------------------------------|
| `apparmor_grub_cmdline_params`  | `['apparmor=1', 'security=apparmor']` | List of AppArmor-related kernel parameters to add |
| `apparmor_grub_file`            | `/etc/default/grub`                   | GRUB configuration file path                      |
| `apparmor_grub_update_command`  | `/usr/sbin/update-grub`               | Command to regenerate GRUB config                 |

## Dependencies
None

## Compliance mapping
    'cis': ['5.2.1.1', '5.2.1.2', '5.2.1.3'], 
    'fedramp': ['SC-4', 'SC-5'], 
    'gdpr': ['32'], 
    'hipaa': ['164.308(a)(1)'], 
    'iso_27001': ['A.12.1.1', 'A.12.1.2', 'A.14.2.1'], 
    'nist_800_53': ['SC-4', 'SC-5'], 
    'pci_dss': ['1.3.1', '2.2.4', '6.4'], 
    'tsc': ['CC6.3', 'CC6.6', 'CC8.1']

## Mitre
    'tactic': ['TA0001', 'TA0005'], 
    'technique': ['T1548', 'T1037']

## Conditions
- Ubuntu 24.04 only

## Rules
- "c:grep -q 'apparmor=1' /proc/cmdline → r:exit code 0"
- "c:apparmor_parser -V → r:output contains 'AppArmor module loaded'"

## Usage

Include this role in your playbook:

```yaml
- hosts: ubuntu_2404_servers
  become: true
  roles:
    - enable_apparmor
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
