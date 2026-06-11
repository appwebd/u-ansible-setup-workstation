#### Role name:
    disable_rds

#### Wazuh ID:
    35606

#### Title:
    Ensure rds kernel module is not available.

#### Description:
    The Reliable Datagram Sockets (RDS) protocol is a transport layer protocol designed to provide low-latency, high-bandwidth communications between cluster nodes. It was developed by the Oracle Corporation.

#### Rationale:
    - IF - the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.

#### Remediation:
    Run the following script to unload and disable the rds module:  
    - IF - the rds kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install rds /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist rds` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r rds 2>/dev/null; rmmod rds 2>/dev/null` to remove rds from the kernel  
    - IF - the rds kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary

#### Requirements
    - Ansible 2.16 or higher (inferred from modern syntax and `set -o pipefail` usage)
    - `become: yes` required (to modify `/etc/modprobe.d/`, manage kernel modules via `modprobe`/`rmmod`)
    - OS: Linux (inferred from `/etc/modprobe.d/`, `lsmod`, `modprobe`, and kernel module management)
    - Required Ansible collections/modules:
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                 | Default                                   | Description                                                                                                                  |
|--------------------------|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `rds_blacklist_content`  | `install rds /bin/false\nblacklist rds\n` | Content written to the modprobe configuration file to prevent loading of the RDS module via install directive and blacklist. |
| `rds_modprobe_conf_file` | `/etc/modprobe.d/rds.conf`                | Path to the modprobe configuration file used to disable the RDS kernel module.                                               |

### vars/main.yml

| Variable          | Default  | Description                                                                  |
|-------------------|----------|------------------------------------------------------------------------------|
| `rds_module_name` | `rds`    | Name of the kernel module to disable (used in shell commands for unloading). |

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
    all

#### Rules
    - `d:/etc/modprobe.d/ -> r:.+\\.conf$ -> r:^install\s*\t*rds\s*\t*/bin/false`  
    - `d:/etc/modprobe.d/ -> r:.+\\.conf$ -> r:^blacklist\s*\t*rds`  
    - `c:modprobe -n -v rds -> r:^install /bin/false`  
    - `not c:lsmod -> r:rds`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_rds
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz