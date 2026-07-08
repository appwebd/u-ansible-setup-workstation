#### Role name:
    disable_icmp_redirects

#### Wazuh ID:
    35612

#### Title:
    Ensure icmp redirects are not accepted.

#### Description:
    ICMP redirect messages are packets that convey routing information and tell your host (acting as a router) to send packets via an alternate path. It is a way of allowing an outside routing device to update your system routing tables.

#### Rationale:
    ICMP redirect messages are packets that convey routing information and tell your host (acting as a router) to send packets via an alternate path. It is a way of allowing an outside routing device to update your system routing tables. By setting net.ipv4.conf.all.accept_redirects, net.ipv4.conf.default.accept_redirects, net.ipv6.conf.all.accept_redirects, and net.ipv6.conf.default.accept_redirects to 0, the system will not accept any ICMP redirect messages, and therefore, won't allow outsiders to update the system's routing tables.

#### Remediation:
    Set the following parameters in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.conf.all.accept_redirects = 0 - net.ipv4.conf.default.accept_redirects = 0 Example: # printf '%s\n' "net.ipv4.conf.all.accept_redirects = 0" "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.d/60- netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.conf.all.accept_redirects=0 sysctl -w net.ipv4.conf.default.accept_redirects=0 } become: yes - Set the following parameters in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv6.conf.all.accept_redirects = 0 - net.ipv6.conf.default.accept_redirects = 0 Example: # printf '%s\n' "net.ipv6.conf.all.accept_redirects = 0" "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv6.conf.all.accept_redirects=0 sysctl -w net.ipv6.conf.default.accept_redirects=0 } become: yes

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: e.g., `ansible.builtin.file`, `ansible.posix.sysctl`, `ansible.builtin.copy`, `ansible.builtin.shell`, `ansible.builtin.set_fact`, etc., used explicitly in tasks

#### Variables

### defaults/main.yml

| Variable                    | Default                              | Description                                                          |
|-----------------------------|--------------------------------------|----------------------------------------------------------------------|
| ipv4_accept_redirects_value | 0                                    | Value to set for IPv4 ICMP redirect settings                         |
| ipv4_all_conf_file_path     | /etc/sysctl.d/60-netipv4_sysctl.conf | Path to the sysctl.d file for net.ipv4.conf.all.accept_redirects     |
| ipv4_default_conf_file_path | /etc/sysctl.d/60-netipv4_sysctl.conf | Path to the sysctl.d file for net.ipv4.conf.default.accept_redirects |
| ipv6_accept_redirects_value | 0                                    | Value to set for IPv6 ICMP redirect settings                         |
| ipv6_all_conf_file_path     | /etc/sysctl.d/60-netipv6_sysctl.conf | Path to the sysctl.d file for net.ipv6.conf.all.accept_redirects     |
| ipv6_default_conf_file_path | /etc/sysctl.d/60-netipv6_sysctl.conf | Path to the sysctl.d file for net.ipv6.conf.default.accept_redirects |
| check_ipv6_enabled          | true                                 | Whether to check if IPv6 is enabled before applying settings         |

### vars/main.yml

| Variable                  | Default                                | Description                                         |
|---------------------------|----------------------------------------|-----------------------------------------------------|
| ipv4_all_sysctl_param     | net.ipv4.conf.all.accept_redirects     | System parameter for all IPv4 redirect settings     |
| ipv4_default_sysctl_param | net.ipv4.conf.default.accept_redirects | System parameter for default IPv4 redirect settings |
| ipv6_all_sysctl_param     | net.ipv6.conf.all.accept_redirects     | System parameter for all IPv6 redirect settings     |
| ipv6_default_sysctl_param | net.ipv6.conf.default.accept_redirects | System parameter for default IPv6 redirect settings |

#### Dependencies
    Handlers: `handlers/main.yml`
    Dependencies on other roles: none

#### Compliance mapping
    - cce:23019-7
    - cis_level_1_server
    - cis_level_1_workstation
    - pci_dss:2.2.4
    - nist_800_53:CM-7
    - tsc:CC6.1,CC6.2,CC6.3,CC6.4

#### Mitre
    - attack.id: T1068
    - attack.tactic: privilege_escalation

#### Conditions
    - os_family: Debian
    - ansible_distribution: Ubuntu or Debian

#### Rules
    - rule: net.ipv4.conf.all.accept_redirects = 0
    - rule: net.ipv4.conf.default.accept_redirects = 0
    - rule: net.ipv6.conf.all.accept_redirects = 0
    - rule: net.ipv6.conf.default.accept_redirects = 0

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_icmp_redirects
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-07-04_10:33:53
