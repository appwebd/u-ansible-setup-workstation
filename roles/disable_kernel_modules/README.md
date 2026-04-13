## Role Name: 
    disable_kernel_modules

## Wazuh ID: 
     # 35500 Ensure mounting of cramfs filesystems is disabled.
     # 35501 Ensure freevxfs kernel module is not available.
     # 35502 Ensure hfs kernel module is not available.
     # 35503 Ensure hfsplus kernel module is not available.
     # 35504 Ensure jffs2 kernel module is not available.
     # 35505 Ensure overlayfs kernel module is not available.
     # 35506 Ensure squashfs kernel module is not available.
     # 35507 Ensure udf kernel module is not available.
     # 35508 Ensure usb-storage kernel module is not available.
     # 35509 Ensure unused filesystems afs kernel modules are not available.
     # 35604 Ensure dccp kernel module is not available.
     # 35605 Ensure tipc kernel module is not available.
     # 35606 Ensure rds kernel module is not available.
     # 35607 Ensure sctp kernel module is not available.
    
## Title:
    Ensure kernel module is not available.
    
## Description:
    Remove all kernel modules listed in wazuh recommendations.  
    Removing support for unneeded filesystem types reduces the local attack surface of the system.

## Requirements            

    - Ansible 2.14 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu v24.04 family

## Variables

| Variable                        | Default                                 | Description                                                 |
|---------------------------------|-----------------------------------------|-------------------------------------------------------------|
| `modprobe_conf_file`            | `/etc/modprobe.d/disable-freevxfs.conf` | Path to the modprobe configuration file to blacklist module |
| `disable_kernel_modules_list`   | list of kernel modules                  | Name of the kernel module to blacklist                      | 
| `unload_modules`                | `true`                                  | true / false                                                |
| `enforce_disable`               | `true`                                  | true / false                                                |
| `filesystem_module_exceptions`  | `[]`                                    | Array with filesystem exceptions                            |

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
