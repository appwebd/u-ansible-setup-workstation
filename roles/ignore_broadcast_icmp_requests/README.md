#### Role name:
    ignore_broadcast_icmp_requests

#### Wazuh ID:
    35611

#### Title:
    Ensure broadcast icmp requests are ignored.

#### Description:
    Setting net.ipv4.icmp_echo_ignore_broadcasts to 1 will cause the system to ignore all ICMP echo and timestamp requests to broadcast and multicast addresses.

#### Rationale:
    Accepting ICMP echo and timestamp requests with broadcast or multicast destinations for your network could be used to trick your host into starting (or participating) in a Smurf attack. A Smurf attack relies on an attacker sending large amounts of ICMP broadcast messages with a spoofed source address. All hosts receiving this message and responding would send echo-reply messages back to the spoofed address, which is probably not routable. If many hosts respond to the packets, the amount of traffic on the network could be significantly multiplied.

#### Remediation:
    Set the following parameter in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.icmp_echo_ignore_broadcasts = 1 Example: # printf '%s\n' "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 sysctl -w net.ipv4.route.flush=1 } Note: If these settings appear in a canonically later file, or later in the same file, these settings will be overwritten.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: ansible.builtin.assert, ansible.builtin.file, ansible.builtin.blockinfile, ansible.builtin.shell, ansible.builtin.debug, ansible.posix.sysctl

#### Variables

### defaults/main.yml

| Variable                           | Default                              | Description                                                        |
|------------------------------------|--------------------------------------|--------------------------------------------------------------------|
| icmp_echo_ignore_broadcasts_sysctl | net.ipv4.icmp_echo_ignore_broadcasts | Sysctl parameter name for ICMP broadcast echo ignore setting       |
| icmp_echo_ignore_broadcasts_value  | "1"                                  | Value to set for the ICMP broadcast echo ignore parameter          |
| sysctl_config_file                 | /etc/sysctl.d/60-netipv4_sysctl.conf | Path to the sysctl configuration file where the setting is applied |
| sysctl_d_confir_dir                | /etc/sysctl.d                        | Path to the sysctl.d configuration                                 |

### vars/main.yml

| Variable               | Default                                                                            | Description                                                   |
|------------------------|------------------------------------------------------------------------------------|---------------------------------------------------------------|
| sysctl_config_content  | {{ icmp_echo_ignore_broadcasts_sysctl }} = {{ icmp_echo_ignore_broadcasts_value }} | Formatted content to write into the sysctl configuration file |

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
    c:sysctl net.ipv4.icmp_echo_ignore_broadcasts -> r:=\s*\t*1$

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - ignore_broadcast_icmp_requests
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-07-04_10:33:13
