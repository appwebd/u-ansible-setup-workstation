#### Role name:
    disable_usb_storage

#### Wazuh ID:
    35508

#### Title:
    Ensure usb-storage kernel module is not available.

#### Description:
    USB storage provides a means to transfer and store files ensuring persistence and availability of the files independent of network connection status. Its popularity and utility has led to USB-based malware being a simple and common means for network infiltration and a first step to establishing a persistent threat within a networked environment.

#### Rationale:
    Restricting USB access on the system will decrease the physical attack surface for a device and diminish the possible vectors to introduce malware.

#### Remediation:
    Run the following script to unload and disable the usb-storage module:  
    - IF the usb-storage kernel module is available in ANY installed kernel:  
      &nbsp;&nbsp;– Create a file ending in `.conf` with `install usb-storage /bin/false` in `/etc/modprobe.d/`  
      &nbsp;&nbsp;– Create a file ending in `.conf` with `blacklist usb-storage` in `/etc/modprobe.d/`  
      &nbsp;&nbsp;– Run `modprobe -r usb-storage 2>/dev/null; rmmod usb-storage 2>/dev/null` to remove usb-storage from the kernel  
    - IF the usb-storage kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary.

#### Requirements
    - Ansible 2.16 or higher (inferred from modern syntax and `check_mode: false`, `failed_when`, etc.)
    - `become: yes` required (to modify `/etc/modprobe.d/`, run `rmmod`, and execute `update-initramfs`)
    - OS: Debian/Ubuntu (inferred from use of `update-initramfs` handler; tasks assume `modprobe`, `rmmod`, and `/etc/modprobe.d/` exist)
    - Required Ansible collections/modules:
      - `ansible.builtin.command`
      - `ansible.builtin.copy`
      - `ansible.builtin.debug`

#### Variables

### defaults/main.yml

| Variable                          | Default                                                   | Description                                                                                                                                                               |
|-----------------------------------|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `usb_storage_modprobe_conf_dir`   | `/etc/modprobe.d`                                         | Path to the directory containing modprobe configuration files. Inferred from standard Linux modprobe conventions.                                                         |
| `usb_storage_modprobe_conf_file`  | `/etc/modprobe.d/usb-storage.conf`                        | Path to the modprobe configuration file used to disable the usb-storage module. Inferred from task context (used in `copy` task) and standard Linux modprobe conventions. |
| `usb_storage_blacklist_content`   | `install usb-storage /bin/false\nblacklist usb-storage\n` | Multi-line string containing the modprobe directives to prevent loading of the usb-storage kernel module. Inferred from content and Wazuh remediation steps.              |

### vars/main.yml
| Variable                   | Default        | Description                                                                                                                                                                               |
|----------------------------|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `usb_storage_module_name`  | `usb-storage`  | Internal variable storing the name of the kernel module to disable. Used in tasks for dynamic command construction. Declared but not used in `defaults/main.yml`; only defined once here. |

#### Dependencies
    Handlers: `handlers/main.yml` *(exists and is notified by the modprobe configuration task)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: MP.L2-3.8.7  
    - FedRAMP: SI-3, SI-4, AU-12  
    - GDPR: 32  
    - HIPAA: 164.310(d)(1)  
    - ISO/IEC 27001: A.12.2.1, A.12.4.1  
    - NIS2: 21.2.f, 21.2.a  
    - NIST 800-171: 3.8.7  
    - NIST 800-53: SI-3, SI-4, AU-12  
    - PCI DSS: 5.1, 5.2, 5.3, 5.4, 10.2  
    - TSC: CC7.1, CC7.2, CC7.3, CC7.4, CC7.5, CC4.1, CC4.2  

#### Mitre
    - Sub-techniques: T1562.001 (Disable or Modify Tools), T1562.002 (Disable System Firewall), T1070.004 (Clear Command History)
    - Tactics: TA0002 (Execution), TA0005 (Defense Evasion)  
    - Techniques: T1562 (Impair Defenses), T1070 (Indicator Removal), T1059 (Command and Scripting Interpreter), T1105 (Ingress Tool Transfer)  

#### Conditions
    `any` — The role executes remediation steps if the usb-storage module is detected as available; otherwise, it skips configuration changes.

#### Rules
    - `c:modprobe -n -v usb-storage -> r:install /bin/false|install /bin/true|Module usb-storage not found`  
    - `not c:lsmod -> r:usb-storage`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+usb-storage`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_usb_storage
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz