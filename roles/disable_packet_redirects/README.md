#### Role name:
    disable_packet_redirects

#### Wazuh ID:
    35609

#### Title:
    Ensure packet redirect sending is disabled.

#### Description:
    ICMP Redirects are used to send routing information to other hosts. As a host itself does not act as a router (in a host only configuration), there is no need to send redirects.

#### Rationale:
    An attacker could use a compromised host to send invalid ICMP redirects to other router devices in an attempt to corrupt routing and have users access a system set up by the attacker as opposed to a valid system.

#### Remediation:
    Set the following parameters in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.conf.all.send_redirects = 0 - net.ipv4.conf.default.send_redirects = 0 Example: # printf '%s\n' "net.ipv4.conf.all.send_redirects = 0" "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.conf.all.send_redirects=0 sysctl -w net.ipv4.conf.default.send_redirects=0 sysctl -w net.ipv4.route.flush=1 } Note: If these settings appear in a canonically later file, or later in the same file, these settings will be overwritten.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: e.g., `ansible.builtin.file`, `ansible.builtin.service`, `ansible.builtin.lineinfile`, `ansible.builtin.command`, etc., used explicitly in tasks
    
#### Variables

### defaults/main.yml

| Variable           | Default                                                                                                                      | Description                                   |
|--------------------|------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| sysctl_file_path   | /etc/sysctl.d/60-netipv4_sysctl.conf                                                                                         | Sysctl file path for network settings         |
| sysctl_parameters  | [{"name": "net.ipv4.conf.all.send_redirects", "value": "0"}, {"name": "net.ipv4.conf.default.send_redirects", "value": "0"}] | Sysctl parameters to disable packet redirects |

### vars/main.yml

| Variable          | Default | Description                                        |
|-------------------|---------|----------------------------------------------------|
| sysctl_file_owner | root    | Owner of the sysctl configuration file             |
| sysctl_file_group | root    | Group owner of the sysctl configuration file       |
| sysctl_file_mode  | '0644'  | File permissions for the sysctl configuration file |

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
    c:sysctl net.ipv4.conf.all.send_redirects -> r:=\s*\t*0$
    c:sysctl net.ipv4.conf.default.send_redirects -> r:=\s*\t*0$

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_packet_redirects
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-28_11:34:13
