## Role name: enforce_apparmor_profiles  
## Wazuh ID : 35539  
## Title    : Ensure AppArmor profiles are enforced  

## Description:
    This Ansible role ensures that all installed AppArmor profiles are loaded and enforced (in enforcing mode) to
    enhance system security by restricting program capabilities. This role addresses Wazuh/CIS rule **35539**.

## Rationale:
    AppArmor provides mandatory access control (MAC) by confining programs to a limited set of resources. Leaving
    profiles in complain mode (logging only) reduces security benefits, as violations are not blocked.

## Remediation:
    Run the following commands:
    # aa-enforce /etc/apparmor.d/*
    # systemctl reload apparmor

## Requirements
    - Ansible 2.16 or higher
    - Root/sudo privileges (`become: true`)
    - Ubuntu/Debian-based systems with AppArmor installed (`apparmor` package)
    - `aa-enforce` binary must be present (usually part of `apparmor` package)

## Variables

| Variable                            | Default                | Description                                 |
|-------------------------------------|------------------------|---------------------------------------------|
| `apparmor_profiles_enforce_enabled` | `true`                 | Enable enforcement of all AppArmor profiles |
| `apparmor_enforce_bin_path`         | `/usr/sbin/aa-enforce` | Path to the `aa-enforce` binary             |
| `apparmor_profiles_dir`             | `/etc/apparmor.d`      | Directory containing AppArmor profile files |

## Dependencies
    None — but requires `apparmor` package installed.

## Compliance mapping
    'cmmc': ['SI.L2-4.5.1', 'SI.L2-4.5.2'],  
    'fedramp': ['SI-4', 'SI-4-1'],  
    'gdpr': ['32'],  
    'hipaa': ['164.312(a)(1)', '164.312(b)'],  
    'iso_27001': ['A.12.1.1', 'A.12.2.1', 'A.14.2.5'],  
    'nist_800_171': ['3.5.1', '3.5.2', '3.13.1'],  
    'nist_800_53': ['SI-4', 'SI-4-1'],  
    'pci_dss': ['2.2.4', '6.4.2'],  
    'tsc': ['CC6.3', 'CC6.6', 'CC6.1']

## Mitre
    'tactic': ['TA0001', 'TA0005'],  
    'technique': ['T1068', 'T1548']

## Conditions
    - AppArmor must be installed  
    - System must be Ubuntu or Debian-based  
    - Only applies if `apparmor_profiles_enforce_enabled` is `true`

## Rules
    - "c:aa-status | grep -E '^[^ ]+ \([^)]+\) is [^e].* enforce' -> r:all profiles in enforcing mode"

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - enforce_apparmor_profiles
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
