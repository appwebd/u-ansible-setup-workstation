#### Role name:
    disable_hfsplus

#### Wazuh ID:
    35503

#### Title:
    Ensure hfsplus kernel module is not available.

#### Description:
    The hfsplus filesystem type is a hierarchical filesystem designed to replace hfs that allows you to mount Mac OS filesystems.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the hfsplus module:  
    - IF - the hfsplus kernel module is available in ANY installed kernel:  
      - Create a file ending in .conf with `install hfsplus /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in .conf with `blacklist hfsplus` in the `/etc/modprobe.d/` directory.

#### Requirements
    - Ansible 2.16 or higher  
    - `become: yes` required (to modify system configuration files under `/etc/modprobe.d/`, `/etc/modules-load.d/`, and manage kernel modules)  
    - OS: Debian/Ubuntu (inferred from `ansible_facts.os_family == "Debian"` conditions and use of `update-initramfs`)  
    - Required Ansible modules: `ansible.builtin.shell`, `community.general.modprobe`, `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.lineinfile`, `ansible.builtin.command`  
    - `check_mode: false` used in one task (module loading check), so idempotency relies on state checks in subsequent tasks  
    - `ignore_errors: true` used in module unloading task to tolerate non-critical failures (e.g., module not present)

#### Variables

### defaults/main.yml

| Variable                     | Default                                         | Description                                                                                                          |
|------------------------------|-------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| `hfsplus_modprobe_conf_dir`  | `/etc/modprobe.d`                               | Path to the modprobe configuration directory where module blacklisting files are stored.                             |
| `hfsplus_modprobe_conf_file` | `/etc/modprobe.d/hfsplus.conf`                  | Path to the modprobe configuration file used to disable the hfsplus module via `install` and `blacklist` directives. |
| `hfsplus_modprobe_content`   | `install hfsplus /bin/false\nblacklist hfsplus` | Content written to the modprobe configuration file to prevent loading of the hfsplus kernel module.                  |
| `hfsplus_unload_if_loaded`   | `true`                                          | Boolean flag indicating whether to attempt unloading the hfsplus module if it is currently loaded.                   |

### vars/main.yml
| Variable              | Default   | Description                                                                                         |
|-----------------------|-----------|-----------------------------------------------------------------------------------------------------|
| `hfsplus_module_name` | `hfsplus` | Internal variable storing the kernel module name; used to reference the module in `modprobe` tasks. |

#### Dependencies
    Handlers: `handlers/main.yml` — *not present* (no handler defined in provided files; `notify: Update initramfs` in `tasks/main.yml` would require a handler, but none is included in the input — this may cause runtime failure if `update-initramfs` is triggered and no handler exists).  
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
    - `c:modprobe -n -v hfsplus -> r:install /bin/false|install /bin/true|Module hfsplus not found`  
    - `not c:lsmod -> r:hfsplus`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+hfsplus`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_hfsplus
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
