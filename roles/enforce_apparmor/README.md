## Role name: apparmor_enforce
## Wazuh ID : 35760
## Title    : Enforce or set AppArmor profiles to complain mode.

## Description:
    This Ansible role enforces AppArmor security profiles system-wide or switches them to complain mode. It supports both
    Debian/Ubuntu and RHEL-based systems, ensuring compliance with Wazuh rule **35760**.

## Rationale:
    AppArmor provides mandatory access control (MAC) to limit the capabilities of programs. Enforcing profiles reduces the
    attack surface, while complain mode allows testing without blocking operations.

## Remediation:
    To enforce AppArmor profiles:  
    ```bash
    # apparmor_parser -r -W /etc/apparmor.d/PROFILE_NAME
    ```  
    To switch to complain mode:  
    ```bash
    # apparmor_parser -r /etc/apparmor.d/PROFILE_NAME
    ```  
    Restart AppArmor: `systemctl reload apparmor`

## Requirements            
    - Ansible 2.16 or higher  
    - Root/sudo privileges (`become: true`)  
    - Ubuntu/Debian (AppArmor installed by default) or RHEL-based (requires `apparmor` package)  
    - Linux kernel with AppArmor support enabled (v2.6+)

## Variables

| Variable                     | Default           | Description                                                  |
|------------------------------|-------------------|--------------------------------------------------------------|
| `apparmor_profile_mode`      | `enforce`         | Mode to set profiles: `'enforce'` or `'complain'`            |
| `apparmor_profiles_dir`      | `/etc/apparmor.d` | Path to AppArmor profiles directory                          |
| `apparmor_reload_profiles`   | `true`            | Whether to reload AppArmor after profile changes             |
| `apparmor_enforce_profiles`  | `[]`              | List of specific profiles to enforce (optional)              |
| `apparmor_complain_profiles` | `[]`              | List of specific profiles to set to complain mode (optional) |

## Dependencies  
    None

## Compliance mapping
    'cmmc': ['AC.L2-3.1.20', 'SI.L2-3.14.4'],  
    'fedramp': ['AC-6', 'SI-4'],  
    'gdpr': ['32'],  
    'hipaa': ['164.308(a)(1)(ii)(D)'],  
    'iso_27001': ['A.12.1.2', 'A.12.5.1'],  
    'nist_800_171': ['3.5.1', '3.13.11'],  
    'nist_800_53': ['AC-6', 'SI-4'],  
    'pci_dss': ['2.2.4', '6.4.2'],  
    'tsc': ['CC6.6', 'CC6.3']

## Mitre
    'tactic': ['TA0001', 'TA0005'],  
    'technique': ['T1055', 'T1542']

## Conditions
    all Debian/Ubuntu or RHEL-based Linux hosts with AppArmor support

## Rules
    - "c:ls /sys/kernel/security/apparmor/profiles -> r:profiles exist"  
    - "c:cat /sys/kernel/security/apparmor/profiles | grep -q '^enforce'"  
    - "r:apparmor_parser returns zero exit code"

## Usage

```yaml
- hosts: all
  become: true
  roles:
    - apparmor_enforce
```

To set specific profiles to complain mode:

```yaml
- hosts: all
  become: true
  vars:
    apparmor_profile_mode: complain
  roles:
    - apparmor_enforce
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
