#### Role name:
    disable_udf

#### Wazuh ID:
    35507

#### Title:
    Ensure udf kernel module is not available.

#### Description:
    The udf filesystem type is the universal disk format used to implement ISO/IEC 13346 and ECMA-167 specifications. This is an open vendor filesystem type for data storage on a broad range of media. This filesystem type is necessary to support writing DVDs and newer optical disc formats.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the udf module:  
    - IF - the udf kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install udf /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist udf` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r udf 2>/dev/null; rmmod udf 2>/dev/null` to remove udf from the kernel  
    - IF - the udf kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary.

#### Requirements
    - Ansible 2.16 or higher (inferred from modern `ansible.builtin.*` module usage and syntax)
    - `become: yes` required (to modify `/etc/modprobe.d/`, run `modprobe`, and write system configuration files)
    - OS: Linux (inferred from kernel module management via `lsmod`, `modprobe`)
    - Required Ansible collections/modules:
      - `ansible.builtin.command`
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`
    - System must have `lsmod` and `modprobe` utilities available
    - Microsoft Azure environments are explicitly excluded from remediation (role skips execution on Azure)

#### Variables

### defaults/main.yml

| Variable                 | Default                                   | Description                                                                                                                                                                                                       |
|--------------------------|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `udf_enabled`            | `false`                                   | Controls whether the role should enforce disabling of the udf module regardless of detection results. When `true`, remediation is applied even if module not detected as present (e.g., for proactive hardening). |
| `udf_modprobe_conf_file` | `/etc/modprobe.d/udf.conf`                | Path to the modprobe configuration file used to disable the udf kernel module via install/blacklist directives.                                                                                                   |
| `udf_blacklist_content`  | `install udf /bin/false\nblacklist udf\n` | Content written to the modprobe config file to prevent loading of the udf module. Contains both `install` and `blacklist` directives as required by remediation.                                                  |

### vars/main.yml
| Variable          | Default  |  Description                                                                                                                                                                         |
|-------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `udf_module_name` | `udf`    | Internal constant storing the kernel module name. Used for consistency and future extensibility, though currently unused in tasks (declared but not referenced in `tasks/main.yml`). |

#### Dependencies
    Handlers: *not defined* (`handlers/main.yml` not present)  
    Dependencies on other roles: *none*

#### Compliance mapping
    - cis: 1.1.1.8
    - cis_csc_v7: 9.2
    - cis_csc_v8: 4.8
    - cmmc_v2.0: CM.L2-3.4.7,CM.L2-3.4.8,SC.L2-3.13.6
    - iso_27001-2013: A.13.1.3
    - pci_dss_v3.2.1: 1.1.6,1.2.1,2.2.2,2.2.5
    - pci_dss_v4.0: 1.2.5,2.2.4,6.4.1
    - soc_2: CC6.3,CC6.6

#### Mitre
    - Tactic: TA0005 (Defense Evasion)  
    - Technique: T1036 (Masquerading), T1564 (Hide Artifacts)
    - Mitigation: M1050 (Use Alternate Binary) 

#### Conditions
    any

#### Rules
    - `c:modprobe -n -v udf -> r:install /bin/false|install /bin/true|Module udf not found`  
    - `not c:lsmod -> r:udf`  
    - `d:/etc/modprobe.d/ -> r:.*\\.conf -> r:^blacklist\\s+udf`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_udf
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz