#### Role name:
    disable_tipc

#### Wazuh ID:
    35605

#### Title:
    Ensure tipc kernel module is not available.

#### Description:
    The Transparent Inter-Process Communication (TIPC) protocol is designed to provide communication between cluster nodes.

#### Rationale:
    - IF - the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.

#### Remediation:
    Run the following script to unload and disable the tipc module:  
    - IF - the tipc kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install tipc /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist tipc` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r tipc 2>/dev/null; rmmod tipc 2>/dev/null` to remove tipc from the kernel  
    - IF - the tipc kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary

#### Requirements
    - Ansible 2.16 or higher (inferred from modern syntax and `set -o pipefail` usage)
    - `become: yes` required (to modify `/etc/modprobe.d/`, manage kernel modules via `modprobe`, and write system configuration files)
    - OS: Linux (inferred from use of `lsmod`, `modprobe`, `/etc/modprobe.d/`)
    - Required Ansible collections/modules:
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                   | Default                                                        | Description                                                                                                                                                                |
|----------------------------|----------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `tipc_modprobe_conf_file`  | `/etc/modprobe.d/tipc.conf`                                    | Path to the modprobe configuration file used to disable the tipc kernel module. Inferred from task context: destination path for blacklist/install directives.             |
| `tipc_blacklist_content`   | `install tipc /bin/false\nblacklist tipc` (multi-line string)  | Content written to the modprobe config file to prevent loading of the tipc module. Inferred from content used in `ansible.builtin.copy` task and remediation instructions. |

### vars/main.yml
| Variable           | Default  | Description                                                                                                                                                                                                           |
|--------------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `tipc_module_name` | `tipc`   | Internal variable storing the kernel module name. Used to parameterize shell commands for unloading (`modprobe -r`, `rmmod`). Declared but not used in `defaults/main.yml`; only defined once here and used in tasks. |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but empty — no handlers defined)*  
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
    `all`

#### Rules
    - `c:modprobe -n -v tipc -> r:^install /bin/false`  
    - `not c:lsmod -> r:tipc`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_tipc
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz