#### Role name:
    configure_secure_icmp_redirects

#### Wazuh ID:
    35613

#### Title:
    Ensure secure icmp redirects are not accepted.

#### Description:
    Secure ICMP redirects are the same as ICMP redirects, except they come from gateways listed on the default gateway list. It is assumed that these gateways are known to your system, and that they are likely to be secure.

#### Rationale:
    It is still possible for even known gateways to be compromised. Setting net.ipv4.conf.all.secure_redirects and net.ipv4.conf.default.secure_redirects to 0 protects the system from routing table updates by possibly compromised known gateways.

#### Remediation:
    Set the following parameters in /etc/sysctl.conf or a file in /etc/sysctl.d/ ending in .conf: - net.ipv4.conf.all.secure_redirects = 0 - net.ipv4.conf.default.secure_redirects = 0 Example: # printf '%s\n' "net.ipv4.conf.all.secure_redirects = 0" "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf Run the following script to set the active kernel parameters: #!/usr/bin/env bash { sysctl -w net.ipv4.conf.all.secure_redirects=0 sysctl -w net.ipv4.conf.default.secure_redirects=0 sysctl -w net.ipv4.route.flush=1 } Note: If these settings appear in a canonically later file, or later in the same file, these settings will be overwritten.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: ansible.builtin.assert, ansible.builtin.file, ansible.builtin.lineinfile, ansible.builtin.command, ansible.builtin.debug

#### Variables

### defaults/main.yml

| Variable           | Default                                                                                                                    | Description                                                                                     |
|--------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| sysctl_config_file | /etc/sysctl.d/60-secure-icmp-redirects.conf                                                                                | Path to the sysctl configuration file used to store secure ICMP redirect settings               |
| required_params    | [ { name: net.ipv4.conf.all.secure_redirects, value: "0" }, { name: net.ipv4.conf.default.secure_redirects, value: "0" } ] | List of sysctl parameters and their values to be configured for disabling secure ICMP redirects |

### vars/main.yml

| Variable                        | Default | Description |
|---------------------------------|---------|-------------|
| (No variables defined.)         |         |             |

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
    c:sysctl net.ipv4.conf.all.secure_redirects -> r:=\s*\t*0$
    c:sysctl net.ipv4.conf.default.secure_redirects -> r:=\s*\t*0$

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - configure_secure_icmp_redirects
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-07-08_17:57:51
