## Role Name: 
disable_cramfs

## Wazuh ID: 
35500
    
## Title:
Ensure mounting of cramfs filesystems is disabled.
    
## Description:
This Ansible role ensures that the cramfs filesystem type is disabled to reduce the local attack surface of the system. This role addresses security rule **35500** (Wazuh).

## Requirements            

- Ansible 2.14 or higher
- Root/sudo privileges (become: true)
- Ubuntu v24.04

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `cramfs_modprobe_conf_file` | `/etc/modprobe.d/cramfs.conf` | Path to the modprobe configuration file for cramfs |
| `modprobe_blacklist_content` | `install cramfs /bin/false\nblacklist cramfs` | Content of the modprobe blacklist configuration |

## Dependencies
No dependencies

## Compliance mapping 
- **CMCMMC**: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6
- **FedRAMP**: CM-2, CM-3, CM-6, CM-7
- **GDPR**: 32
- **HIPAA**: 164.308(a)(1)
- **ISO/IEC 27001**: A.12.1.1, A.12.1.2, A.14.2.1
- **NIS2**: 21.2.e, 21.2.a
- **NIST SP 800-171**: 3.4.7, 3.4.8, 3.13.6
- **NIST SP 800-53**: CM-2, CM-3, CM-6, CM-7
- **PCI DSS**: 1.1, 1.2, 2.2, 6.4
- **TSC**: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - disable_cramfs               
```

## License            
Apache 2.0

## Author
Patricio Rojas Ortiz
