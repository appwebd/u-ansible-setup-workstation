#### Role name:
    configure_icmp_ignore_bogus_error_responses

#### Wazuh ID:
    35610

#### Title:
    Ensure bogus icmp responses are ignored.

#### Description:
    Setting net.ipv4.icmp_ignore_bogus_error_responses to 1 prevents the kernel from logging bogus responses (RFC-1122 non-compliant) from broadcast reframes, keeping file systems from filling up with useless log messages.

#### Rationale:
    Some routers (and some attackers) will send responses that violate RFC-1122 and attempt to fill up a log file system with many useless error messages.

#### Remediation:
    Set the following parameter in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.icmp_ignore_bogus_error_responses = 1 Example: # printf '%s\n' "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1 sysctl -w net.ipv4.route.flush=1 } Note: If these settings appear in a canonically later file, or later in the same file, these settings will be overwritten.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: e.g., `ansible.builtin.file`, `ansible.builtin.service`, `ansible.builtin.lineinfile`, `ansible.builtin.command`, etc., used explicitly in tasks
    
#### Variables

### defaults/main.yml

| Variable                                 | Default                                    | Description                    |
|------------------------------------------|--------------------------------------------|--------------------------------|
| icmp_ignore_bogus_error_responses_sysctl | net.ipv4.icmp_ignore_bogus_error_responses | Sysctl parameter to configure  |
| icmp_ignore_bogus_error_responses_value  | 1                                          | Value for the sysctl parameter |
| sysctl_config_file                       | /etc/sysctl.d/60-netipv4_sysctl.conf       | Configuration file path        |

### vars/main.yml

| Variable                | Default                            | Description                                |
|-------------------------|------------------------------------|--------------------------------------------|
| sysctl_config_file_dir  | {{ sysctl_config_file | dirname }} | Directory of the sysctl configuration file |

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
    c:sysctl net.ipv4.icmp_ignore_bogus_error_responses -> r:=\s*\t*1$

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - configure_icmp_ignore_bogus_error_responses
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-28_11:35:05
