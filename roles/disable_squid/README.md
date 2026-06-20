#### Role name:
    squid_proxy

#### Wazuh ID:
    35577

#### Title:
    Ensure web proxy server services are not in use.

#### Description:
    Squid is a standard proxy server used in many distributions and environments.

#### Rationale:
    Unless a system is specifically set up to act as a proxy server, it is recommended that the squid package be removed to reduce the potential attack surface. Note: Several HTTP proxy servers exist. These should be checked and removed unless required.

#### Remediation:
    Run the following commands to stop squid.service and remove the squid package:  
    `# systemctl stop squid.service # apt purge squid`  
    - OR -  
    If the squid package is required as a dependency: Run the following commands to stop and mask squid.service:  
    `# systemctl stop squid.service # systemctl mask squid.service`

#### Requirements
    - Ansible 2.16 or higher (required for reliable `package_facts` and systemd module behavior)
    - `become: yes` required (to manage system packages, services, and configuration directories)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` in tasks)
    - Required Ansible collections/modules:  
      `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.file`

#### Variables

### defaults/main.yml

| Variable           | Default    | Description                                                                                                                                       |
|--------------------|------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| squid_service_name | squid      | Name of the systemd service managing the Squid proxy server                                                                                       |
| squid_package_name | squid      | Name of the APT package to install or remove                                                                                                      |
| squid_config_dir   | /etc/squid | Path to the Squid configuration directory                                                                                                         |
| squid_enabled      | false      | Boolean flag controlling whether Squid should be installed/enabled (true) or removed (false); default enforces removal per compliance requirement |

### vars/main.yml
    No variables defined.

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
    any

#### Rules
    c:dpkg-query -s squid -> r:package 'squid' is not installed  
    not c:systemctl show squid.service -> r:^LoadState=loaded\|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - squid_proxy
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
