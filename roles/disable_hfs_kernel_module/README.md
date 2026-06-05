#### Role name:
    disable_hfs_kernel_module

#### Wazuh ID:
    35502

#### Title:
    Ensure hfs kernel module is not available.

#### Description:
    The hfs filesystem type is a hierarchical filesystem that allows you to mount Mac OS filesystems.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the hfs module:  
    - IF - the hfs kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install hfs /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist hfs` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r hfs 2>/dev/null; rmmod hfs 2>/dev/null` to remove hfs from the kernel.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify system configuration files and manage kernel modules)  
    - OS: Linux (inferred from use of `modprobe`, `lsmod`, and `/etc/modprobe.d/`)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.command`, `community.general.modprobe`  
    - `check_mode: false` used in one task (module loading check), so idempotency relies on state management in other tasks  
    - Handler notification: `Update initramfs` (requires `handlers/main.yml` to be present and define this handler)

#### Variables

### defaults/main.yml

| Variable                 | Default                                                           | Description                                                                                     |
|--------------------------|-------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| `hfs_modprobe_conf_dir`  | `/etc/modprobe.d`                                                 | Path to the modprobe configuration directory where module blacklisting files are stored.        |
| `hfs_modprobe_conf_file` | `/etc/modprobe.d/hfs.conf` (derived from `hfs_modprobe_conf_dir`) | Full path to the modprobe configuration file used to disable the hfs module.                    |
| `hfs_modprobe_content`   | `install hfs /bin/false\nblacklist hfs`                           | Content written to the modprobe configuration file to prevent loading of the hfs module.        |
| `hfs_remove_if_loaded`   | `true`                                                            | Boolean flag indicating whether to attempt removal of the hfs module if it is currently loaded. |

### vars/main.yml
| Variable          | Default  | Description                                                                              |
|-------------------|----------|------------------------------------------------------------------------------------------|
| `hfs_module_name` | `hfs`    | Internal variable storing the kernel module name; used to reference the module in tasks. |

#### Dependencies
    Handlers: `handlers/main.yml` *(declared via `notify: Update initramfs` in `tasks/main.yml`; must define handler `Update initramfs` to regenerate initramfs after modprobe configuration changes)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: `CM.L2-3.4.7`, `CM.L2-3.4.8`, `SC.L2-3.13.6`  
    - FedRAMP: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - GDPR: `32`  
    - HIPAA: `164.308(a)(1)`  
    - ISO 27001: `A.12.1.1`, `A.12.1.2`, `A.14.2.1`  
    - NIS2: `21.2.e`, `21.2.a`  
    - NIST 800-171: `3.4.7`, `3.4.8`, `3.13.6`  
    - NIST 800-53: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - PCI DSS: `1.1`, `1.2`, `2.2`, `6.4`  
    - TSC: `CC6.3`, `CC6.6`, `CC8.1`, `CC5.1`, `CC5.2`, `CC5.3`

#### Mitre
    - Tactic: `TA0005` (Defense Evasion)  
    - Technique: `T1036` (Masquerading), `T1564` (Hide Artifacts)

#### Conditions
    - `any` (i.e., any of the following conditions must be met for the rule to trigger)  
    - Condition 1: `modprobe -n -v hfs` output matches `install /bin/false`, `install /bin/true`, or `Module hfs not found`  
    - Condition 2: `lsmod` output does **not** contain `hfs`  
    - Condition 3: Files in `/etc/modprobe.d/` ending in `.conf` contain a line matching `^blacklist\s+hfs`

#### Rules
    - `c:modprobe -n -v hfs -> r:install /bin/false|install /bin/true|Module hfs not found`  
    - `not c:lsmod -> r:hfs`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+hfs`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_hfs_kernel_module
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
