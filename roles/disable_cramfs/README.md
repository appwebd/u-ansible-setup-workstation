#### Role name:
    disable_cramfs

#### Wazuh ID:
    35500

#### Title:
    Ensure mounting of cramfs filesystems is disabled.

#### Description:
    The cramfs filesystem type is a compressed read-only Linux filesystem embedded in small footprint systems. A cramfs image can be used without having to first decompress the image.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the cramfs module:  
    - IF the cramfs kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install cramfs /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist cramfs` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r cramfs 2>/dev/null; rmmod cramfs 2>/dev/null` to remove cramfs from the kernel  
    - IF the cramfs kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify system configuration files and manage kernel modules)  
    - OS families: Debian/Ubuntu and RedHat/CentOS/Fedora (inferred from conditional tasks using `ansible_facts.os_family`)  
    - Required Ansible modules: `ansible.builtin.shell`, `ansible.builtin.file`, `ansible.builtin.copy`, `community.general.modprobe`, `ansible.builtin.lineinfile`  
    - Handler `Update initramfs` must be defined (in `handlers/main.yml`) for initramfs update on Debian/Ubuntu and RHEL-family systems.

#### Variables

### defaults/main.yml

| Variable                     | Default                                       | Description                                                                          |
|------------------------------|-----------------------------------------------|--------------------------------------------------------------------------------------|
| `cramfs_modprobe_conf_file`  | `/etc/modprobe.d/cramfs.conf`                 | Path to the modprobe configuration file used to blacklist the cramfs module.         |
| `disable_cramfs_enabled`     | `true`                                        | Boolean flag to enable or disable the role’s tasks.                                  |
| `modprobe_blacklist_content` | `install cramfs /bin/false\nblacklist cramfs` | Content written to the modprobe configuration file to disable cramfs module loading. |

### vars/main.yml

| Variable             | Default           | Description                                               |
|----------------------|-------------------|-----------------------------------------------------------|
| `cramfs_module_name` | `cramfs`          | Kernel module name for cramfs (used in `modprobe` tasks). |
| `modprobe_conf_dir`  | `/etc/modprobe.d` | Directory where modprobe configuration files are stored.  |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but content not provided; assumed to define `Update initramfs` handler based on task notifications)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    - FedRAMP: CM-2, CM-3, CM-6, CM-7  
    - GDPR: 32  
    - HIPAA: 164.308(a)(1)  
    - ISO 27001: A.12.1.1, A.12.1.2, A.14.2.1  
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
    - `c:modprobe -n -v cramfs -> r:install /bin/false\|install /bin/true\|Module cramfs not found`  
    - `not c:lsmod -> r:cramfs`  
    - `d:/etc/modprobe.d/ -> r:.*\.conf -> r:^blacklist\s+cramfs`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_cramfs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
