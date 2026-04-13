## Role name: install_apparmor  
## Wazuh ID : 35536  
## Title    : Ensure AppArmor is installed and active on Ubuntu 24.04

## Description:
    This Ansible role ensures that the AppArmor mandatory access control (MAC) system is installed, enabled, and active on Ubuntu 24.04. It addresses security rule **35536** (Wazuh/CIS), which requires MAC frameworks to be enabled to limit potential damage from compromised services.

## Rationale:
    AppArmor provides fine-grained access control by restricting programs to predefined operations. Leaving it uninstalled increases the system's attack surface and fails compliance requirements for Ubuntu 24.04.

## Remediation:
    Run the following commands:
    ```
    # apt install apparmor apparmor-utils
    # systemctl enable --now apparmor
    # modprobe apparmor
    # sysctl vm.unprivileged_userns_apparmor_policy=0
    ```

## Requirements
    - Ansible 2.16+
    - Root/sudo privileges (`become: true`)
    - Ubuntu 24.04 LTS (x86_64/arm64)
    - Kernel ≥ 5.4 (AppArmor modules loaded by default since 5.4)

## Variables

| Variable               | Default                          | Description                          |
|------------------------|----------------------------------|--------------------------------------|
| `apparmor_packages`    | `['apparmor', 'apparmor-utils']` | Packages to install                  |
| `apparmor_service_name`| `apparmor`                       | Name of the AppArmor systemd service |

## Dependencies
    None

## Compliance mapping
    'cis': ['5.2.1'],
    'cmmc': ['SC.L2-3.13.2'], 
    'fedramp': ['SC-4'], 
    'gdpr': ['32'], 
    'hipaa': ['164.308(a)(1)'], 
    'iso_27001': ['A.12.1.1', 'A.12.1.2', 'A.14.2.1'], 
    'nist_800_171': ['3.13.2'], 
    'nist_800_53': ['SC-4', 'SC-5'], 
    'pci_dss': ['1.1', '2.2', '6.4'], 
    'tsc': ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1']

## Mitre
    'tactic': ['TA0001', 'TA0005'], 
    'technique': ['T1548', 'T1037']

## Conditions
     all — role targets Ubuntu 24.04 only

## Rules
    - "c:dpkg-query -s apparmor -> r:package 'apparmor' is installed"
    - "c:systemctl is-enabled apparmor -> r:service 'apparmor' is enabled"
    - "c:cat /sys/module/apparmor/parameters/enabled -> r:file matches '^Y$'"

## Usage

Include this role in your playbook:

```yaml
- hosts: ubuntu_2404_servers
  become: true
  roles:
    - install_apparmor
```

## License
  Apache 2.0

## Author
Patricio Rojas Ortiz
