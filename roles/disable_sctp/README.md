#### Role name:
    disable_sctp

#### Wazuh ID:
    35607

#### Title:
    Ensure sctp kernel module is not available.

#### Description:
    The Stream Control Transmission Protocol (SCTP) is a transport layer protocol used to support message oriented communication, with several streams of messages in one connection. It serves a similar function as TCP and UDP, incorporating features of both. It is message-oriented like UDP, and ensures reliable in-sequence transport of messages with congestion control like TCP.

#### Rationale:
    - IF - the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.

#### Remediation:
    Run the following script to unload and disable the sctp module:  
    - IF - the sctp kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install sctp /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist sctp` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r sctp 2>/dev/null; rmmod sctp 2>/dev/null` to remove sctp from the kernel  
    - IF - the sctp kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary

#### Requirements
    - Ansible 2.16 or higher (inferred from modern shell syntax and `set -o pipefail` usage)
    - `become: yes` required (to modify `/etc/modprobe.d/`, manage kernel modules via `modprobe`, `rmmod`)
    - OS: Linux (Debian/Ubuntu/RHEL-based inferred from use of `modprobe`, `lsmod`, `/etc/modprobe.d/`)
    - Required Ansible collections/modules:
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                        | Default                                                                 | Description |
|---------------------------------|-------------------------------------------------------------------------|-------------|
| `sctp_modprobe_conf_file`       | `/etc/modprobe.d/sctp.conf`                                             | Path to the modprobe configuration file used to blacklist/unload the sctp module. Inferred from task context and Wazuh remediation steps. |
| `sctp_blacklist_content`        | `install sctp /bin/false\nblacklist sctp` (multi-line string)           | Content written to the modprobe config file to prevent loading of the sctp kernel module. Inferred from content structure and Wazuh remediation requirements. |

### vars/main.yml
| Variable              | Default | Description |
|-----------------------|---------|-------------|
| `sctp_module_name`    | `sctp`  | Internal variable storing the name of the kernel module to disable. Used in shell commands (`modprobe`, `rmmod`). Declared but not used in tasks — *actually used* (see note below). |

> **Note**: Although `sctp_module_name` is declared only in `vars/main.yml`, it *is* used in `tasks/main.yml` via Jinja interpolation (`{{ sctp_module_name }}`) in two shell commands. Therefore, it is **not** "DECLARED BUT NOT USED". The instruction to mark variables as unused applies only if they are declared but never referenced in tasks.

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
    - `d:/etc/modprobe.d/ -> r:.+\\.conf$ -> r:^install\\s*\\t*sctp\\s*\\t*/bin/false`  
    - `d:/etc/modprobe.d/ -> r:.+\\.conf$ -> r:^blacklist\\s*\\t*sctp`  
    - `c:modprobe -n -v sctp -> r:^install /bin/false`  
    - `not c:lsmod -> r:sctp`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_sctp
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz