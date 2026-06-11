#### Role name:
    disable_squashfs

#### Wazuh ID:
    35506

#### Title:
    Ensure squashfs kernel module is not available.

#### Description:
    The squashfs filesystem type is a compressed read-only Linux filesystem embedded in small footprint systems. A squashfs image can be used without having to first decompress the image.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the squashfs module:  
    - IF the squashfs kernel module is available in ANY installed kernel:  
      &nbsp;&nbsp;– Create a file ending in `.conf` with `install squashfs /bin/false` in the `/etc/modprobe.d/` directory  
      &nbsp;&nbsp;– Create a file ending in `.conf` with `blacklist squashfs` in the `/etc/modprobe.d/` directory  
      &nbsp;&nbsp;– Run `modprobe -r squashfs 2>/dev/null; rmmod squashfs 2>/dev/null` to remove squashfs from the kernel  
    - IF the squashfs kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary.

#### Requirements
    - Ansible 2.16 or higher (inferred from modern `ansible.builtin.*` usage and syntax)
    - `become: yes` required (to modify `/etc/modprobe.d/`, unload kernel modules via `modprobe`/`rmmod`)
    - OS: Linux (Debian/Ubuntu/RHEL-based inferred from use of `lsmod`, `modprobe`, `/etc/modprobe.d/`)
    - Required Ansible collections/modules:
      - `ansible.builtin.command`
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                       | Default                                                                 | Description                                                                                   |
|--------------------------------|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| `squashfs_modprobe_conf_file`  | `/etc/modprobe.d/squashfs.conf`                                         | Path to the modprobe configuration file used to disable the squashfs module.                  |
| `squashfs_blacklist_content`   | `install squashfs /bin/false\nblacklist squashfs\n` (multi-line string) | Content written to the modprobe config file to prevent loading of the squashfs kernel module. |

### vars/main.yml
| Variable               | Default    | Description                                                                                                     |
|------------------------|------------|-----------------------------------------------------------------------------------------------------------------|
| `squashfs_module_name` | `squashfs` | Internal variable storing the name of the kernel module to disable; used in `modprobe -r` and `rmmod` commands. |

#### Dependencies
    Handlers: *not present* (`handlers/main.yml` not provided)  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    - FedRAMP: CM-2, CM-3, CM-6, CM-7  
    - GDPR: 32  
    - HIPAA: 164.308(a)(1)  
    - ISO/IEC 27001: A.12.1.1, A.12.1.2, A.14.2.1  
    - NIS2: 21.2.e, 21.2.a  
    - NIST 800-171: 3.4.7, 3.4.8, 3.13.6  
    - NIST 800-53: CM-2, CM-3, CM-6, CM-7  
    - PCI DSS: 1.1, 1.2, 2.2, 6.4  
    - TSC: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3  

#### Mitre
    - Tactic: TA0005 (Defense Evasion)  
    - Technique: T1036 (Masquerading), T1564 (Hide Artifacts)

#### Conditions
    any

#### Rules
    - `c:modprobe -n -v squashfs -> r:install /bin/false|install /bin/true|Module squashfs not found`  
    - `not c:lsmod -> r:squashfs`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+squashfs`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_squashfs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
