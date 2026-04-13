## Role name: enable_aslr
## Wazuh ID : 35542
## Title    : Ensure Address Space Layout Randomization is Enabled

## Description:
This Ansible role ensures that Address Space Layout Randomization (ASLR) is enabled at the kernel level to mitigate memory corruption exploits. It writes a sysctl configuration file and reloads the kernel parameter. This role addresses security rule **35542** (Wazuh/CIS).

## Rationale:
ASLR randomizes the memory locations of key data areas, making it significantly harder for attackers to predict target addresses for exploits. Disabling or reducing ASLR increases system vulnerability to buffer overflow and code-execution attacks.

## Remediation:
Set the kernel parameter `kernel.randomize_va_space` to `2` (aggressive randomization) in `/etc/sysctl.d/60-aslr.conf`, then reload sysctl.

## Requirements            
- Ansible 2.16 or higher  
- Root/sudo privileges (`become: true`)  
- Linux kernel ≥ 2.6.31 (all modern distros)  
- write access to `/etc/sysctl.d/`

## Variables

| Variable                   | Default | Description |
|---------------------------|---------|-------------|
| `aslr_mode`               | `2`     | ASLR level: 0=off, 1=conservative, 2=aggressive |
| `aslr_sysctl_file`        | `/etc/sysctl.d/60-aslr.conf` | Path to sysctl drop-in file |
| `aslr_sysctl_reload`      | `true`  | Whether to reload sysctl immediately after change |
| `aslr_sysctl_name`        | (internal) | Kernel param name (exposed for debug) |
| `aslr_sysctl_value`       | (internal) | Value to apply (exposed for debug) |

## Dependencies  
None

## Compliance mapping
- `cmmc`: ['SC.L2-3.13.6']
- `fedramp`: ['SC-4']
- `gdpr`: ['32']
- `hipaa`: ['164.308(a)(1)']
- `iso_27001`: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
- `nist_800_171`: ['3.13.6']
- `nist_800_53`: ['SC-4', 'SC-8']
- `pci_dss`: ['2.2', '6.4']

## Mitre
- `tactic`: ['TA0001', 'TA0005']
- `technique`: ['T1055', 'T1036']

## Conditions  
All Linux systems where `/proc/sys/kernel/randomize_va_space` is writable (i.e., not locked via lockdown or immutable bit).

## Rules  
- `"c:cat /proc/sys/kernel/randomize_va_space -> r:value equals 2"`  
- `"c:grep -q '^kernel.randomize_va_space = 2' /etc/sysctl.d/60-aslr.conf -> r:config file present and correct"`

## Usage  
```yaml
- hosts: all
  become: true
  roles:
    - enable_aslr
```

## License  
Apache 2.0

## Author  
Patricio Rojas Ortiz
