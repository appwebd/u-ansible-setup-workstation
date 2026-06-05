#### Role name:
    disable_freevxfs_kernel_module

#### Wazuh ID:
    35501

#### Title:
    Ensure freevxfs kernel module is not available.

#### Description:
    The freevxfs filesystem type is a free version of the Veritas type filesystem. This is the primary filesystem type for HP-UX operating systems.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following steps to unload and disable the freevxfs module, if available. If the freevxfs kernel module is present in any installed kernel Create a configuration file in the /etc/modprobe.d/ directory.

#### Requirements
    - Ansible 2.9 or higher
    - `become: yes` required (to modify system configuration files and manage kernel modules)
    - OS: Linux (inferred from use of `modprobe`, `/etc/modprobe.d`, and `lsmod`)
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.command`, `community.general.modprobe`, `ansible.builtin.fail`
    - No external collections required beyond `ansible.builtin`

#### Variables

### defaults/main.yml

| Variable                      | Default                                           | Description                                                                    |
|-------------------------------|---------------------------------------------------|--------------------------------------------------------------------------------|
| `freevxfs_enforce_blacklist`  | `true`                                            | Whether to create/update the modprobe blacklist configuration file.            |
| `freevxfs_modprobe_conf_file` | `/etc/modprobe.d/freevxfs.conf`                   | Path to the modprobe configuration file used to blacklist the freevxfs module. |
| `freevxfs_modprobe_content`   | `install freevxfs /bin/false\nblacklist freevxfs` | Content written to the modprobe configuration file to disable the module.      |
| `freevxfs_unload_if_loaded`   | `true`                                            | Whether to attempt unloading the module if it is currently loaded.             |

### vars/main.yml

| Variable               | Default    | Description                                                                              |
|------------------------|------------|------------------------------------------------------------------------------------------|
| `freevxfs_module_name` | `freevxfs` | Internal variable storing the kernel module name; used in tasks to reference the module. |

#### Dependencies
    Handlers: `handlers/main.yml` — *not present* (no handler defined; task includes `notify` but handler is missing — may cause warning at runtime)
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
    - `c:modprobe -n -v freevxfs -> r:install /bin/false|install /bin/true|Module freevxfs not found`  
    - `not c:lsmod -> r:freevxfs`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+freevxfs`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_freevxfs_kernel_module
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
