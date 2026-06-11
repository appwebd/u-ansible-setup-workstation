#### Role name:
    disable_dccp

#### Wazuh ID:
    35604

#### Title:
    Ensure dccp kernel module is not available.

#### Description:
    The Datagram Congestion Control Protocol (DCCP) is a transport layer protocol that supports streaming media and telephony. DCCP provides a way to gain access to congestion control, without having to do it at the application layer, but does not provide in-sequence delivery.

#### Rationale:
    - IF - the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface.

#### Remediation:
    Run the following script to unload and disable the dccp module:  
    - IF - the dccp kernel module is available in ANY installed kernel:  
      - Create a file ending in `.conf` with `install dccp /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in `.conf` with `blacklist dccp` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r dccp 2>/dev/null; rmmod dccp 2>/dev/null` to remove dccp from the kernel  
    - IF - the dccp kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary

#### Requirements
    - Ansible 2.16 or higher (inferred from modern syntax and `set -o pipefail` usage)
    - `become: yes` required (to modify `/etc/modprobe.d/`, manage kernel modules via `modprobe`/`rmmod`)
    - OS: Linux (inferred from use of `lsmod`, `modprobe`, `/etc/modprobe.d/`)
    - Required Ansible collections/modules:
      - `ansible.builtin.shell`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                                      | Default                                                                 | Description |
|-----------------------------------------------|-------------------------------------------------------------------------|-------------|
| `dccp_modprobe_conf_file`                     | `/etc/modprobe.d/dccp.conf`                                             | Path to the modprobe configuration file used to disable the DCCP kernel module. |
| `dccp_modprobe_blacklist_content`             | `install dccp /bin/false\nblacklist dccp\n` (multi-line string)         | Content written to the modprobe configuration file to prevent loading of the DCCP module via install directive and blacklist. |

### vars/main.yml
| Variable              | Default | Description |
|-----------------------|---------|-------------|
| `dccp_module_name`    | `dccp`  | Name of the kernel module to disable (used in shell commands for unloading). |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but no handlers defined — only header comment)*  
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
    - `c:modprobe -n -v dccp -> r:^install /bin/false`  
    - `not c:lsmod -> r:dccp`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_dccp
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz