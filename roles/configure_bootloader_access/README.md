## Role Name   : configure_bootloader_access
## Wazuh ID    : 35541 
## Title       : Ensure access to bootloader config is configured
## Description : The grub configuration file contains information on boot settings and passwords for unlocking boot options.

## Requirements            

    - Ansible 2.14 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu v24.04 family

## Variables

| Variable                        | Default                | Description                            |
|---------------------------------|------------------------|----------------------------------------|
| `boot_grub_cfg_path`            | `/boot/grub/grub.cfg`  | Path to the grub.cfg file              |

## Dependencies
    No dependencies

## Compliance mapping
    cis: 1.4.2
    cis_csc_v7: 14.6
    cis_csc_v8: 3.3
    cmmc_v2.0: AC.L1-3.1.1,AC.L1-3.1.2,AC.L2-3.1.3,AC.L2-3.1.5,MP.L2-3.8.2
    hipaa: 164.308(a)(3)(i),164.308(a)(3)(ii)(A),164.312(a)(1)
    iso_27001-2013: A.9.1.1
    mitre_mitigations: M1022
    mitre_tactics: TA0005,TA0007
    mitre_techniques: T1542
    nist_sp_800-53: AC-5,AC-6
    pci_dss_v3.2.1: 7.1,7.1.1,7.1.2,7.1.3
    pci_dss_v4.0: 1.3.1,7.1
    soc_2: CC5.2,CC6.1

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - configure_bootloader_access               
```

## License            
  Apache 2.0

## Author
Patricio Rojas Ortiz
