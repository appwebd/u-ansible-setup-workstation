#### Role name:
    disable_ip_forwarding

#### Wazuh ID:
    35608

#### Title:
    Ensure ip forwarding is disabled.

#### Description:
    The net.ipv4.ip_forward and net.ipv6.conf.all.forwarding flags are used to tell the system whether it can forward packets or not.

#### Rationale:
    Setting net.ipv4.ip_forward and net.ipv6.conf.all.forwarding to 0 ensures that a system with multiple interfaces (for example, a hard proxy), will never be able to forward packets, and therefore, never serve as a router.

#### Remediation:
    Set the following parameter in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.ip_forward = 0 Example: # printf '%s\n' "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.ip_forward=0 sysctl -w net.ipv4.route.flush=1 } - IF - IPv6 is enabled on the system: Set the following parameter in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv6.conf.all.forwarding = 0 Example: # printf '%s\n' "net.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv6.conf.all.forwarding=0 sysctl -w net.ipv6.route.flush=1 } Note: If these settings appear in a canonically later file, or later in the same file, these settings will be overwritten.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: e.g., `ansible.builtin.file`, `ansible.builtin.service`, `ansible.builtin.lineinfile`, `ansible.builtin.command`, etc., used explicitly in tasks
    
#### Variables

### defaults/main.yml

| Variable                                                                  | Default | Description |
|---------------------------------------------------------------------------|---------|-------------|
| sysctl_ipv4_forward_file                                                  | /etc/sysctl.d/60-netipv4_sysctl.conf | Sysctl file path for IPv4 forwarding setting |
| sysctl_ipv6_forward_file                                                  | /etc/sysctl.d/60-netipv6_sysctl.conf | Sysctl file path for IPv6 forwarding setting |
| sysctl_ipv4_forward_content                                               |   | Content to disable IPv4 forwarding |
| sysctl_ipv6_forward_content                                               |   | Content to disable IPv6 forwarding |

### vars/main.yml
| Variable                                                              | Default | Description |
|-----------------------------------------------------------------------|---------|-------------|
| sysctl_ipv4_forward_setting                                           | net.ipv4.ip_forward |  |
| sysctl_ipv6_forward_setting                                           | net.ipv6.conf.all.forwarding |  |
| sysctl_flush_ipv4_route_cmd                                           | sysctl -w net.ipv4.route.flush=1 |  |
| sysctl_flush_ipv6_route_cmd                                           | sysctl -w net.ipv6.route.flush=1 |  |

#### Dependencies
    Handlers: `handlers/main.yml`
    Dependencies on other roles: none

#### Compliance mapping
    cmmc: ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']
    fedramp: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    gdpr: ['32']
    hipaa: ['164.308(a)(1)']
    iso_27001: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
    nis2: ['21.2.e', '21.2.a']
    nist_800_171: ['3.4.7', '3.4.8', '3.13.6']
    nist_800_53: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    pci_dss: ['1.1', '1.2', '2.2', '6.4']
    tsc: ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
    tactic: ['TA0005']
    technique: ['T1036', 'T1564']

#### Conditions
    all

#### Rules
    c:sysctl net.ipv4.ip_forward -> r:=\s*\t*0$
    c:sysctl net.ipv6.conf.all.forwarding -> r:=\s*\t*0$

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_ip_forwarding
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-28_11:33:16
