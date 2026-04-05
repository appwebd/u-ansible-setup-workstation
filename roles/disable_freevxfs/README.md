## Role Name: 
    disable_freevxfs

## Wazuh ID: 
    35501
    
## Title:
    Ensure freevxfs kernel module is not available.
    
## Description:
    The freevxfs filesystem type is a free version of the Veritas type filesystem. This is the primary filesystem type for HP-UX operating systems. Removing support for unneeded filesystem types reduces the local attack surface of the system.

## Requirements            

    - Ansible 2.14 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu v24.04 family

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `modprobe_conf_file` | `/etc/modprobe.d/disable-freevxfs.conf` | Path to the modprobe configuration file to blacklist the freevxfs module |
| `blacklist_module` | `freevxfs` | Name of the kernel module to blacklist |

## Dependencies
    No dependencies

## Compliance mapping
    - CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6 (CMMC)
    - CM-2, CM-3, CM-6, CM-7 (FedRAMP)
    - GDPR 32
    - HIPAA 164.308(a)(1)
    - ISO/IEC 27001: A.12.1.1, A.12.1.2, A.14.2.1
    - NIS SP 800-52rev2 21.2.e, 21.2.a
    - NIST SP 800-171 3.4.7, 3.4.8, 3.13.6
    - NIST SP 800-53 CM-2, CM-3, CM-6, CM-7
    - PCI DSS 1.1, 1.2, 2.2, 6.4
    - TSC CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - disable_freevxfs               
```

## License            
  Apache 2.0

## Author
Patricio Rojas Ortiz
