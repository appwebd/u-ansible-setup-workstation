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
    - 'cmmc': 
            'AC.L2-3.1.1', 
            'AC.L2-3.1.2',
            'AC.L2-3.1.5',
            'AC.L2-3.1.3',
            'MP.L2-3.8.2'], 
    - 'fedramp': 
            'AC-5',
            'AC-6',
    - 'gdpr': 
            '32',
            '25',
            '30', 
    - 'hipaa': 
            '164.312(a)(1)'
    - 'iso_27001': 
            'A.8.2.3',
            'A.8.3.1',
            'A.8.3.2',
            'A.10.1.1',
            'A.13.2.1',
            'A.18.1.4', 
    - 'nis2': 
            '21.2.g',
            '21.2.j',
            '21.2.i', 
    - 'nist_800_171': 
            '3.1.1',
            '3.1.2',    
            '3.1.5',
            '3.1.3',
            '3.8.2', 
    - 'nist_800_53':
            'AC-5',
            'AC-6',
    - 'pci_dss': 
            '7.1',
            '1.3', 
    - 'tsc': 
            'CC5.2',
            'CC6.1',
            'C1.1',
            'C1.2',
            'CC6.2', 
            'CC6.3',
            'CC6.4', 
            'CC6.5',
            'CC6.6',
            'CC6.7',
            'CC6.8', 
            'P1.1', 
            'P2.1', 
            'P3.1', 
            'P4.1', 
            'P5.1',
            'P6.1',
            'P7.1',
            'P8.1'

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
