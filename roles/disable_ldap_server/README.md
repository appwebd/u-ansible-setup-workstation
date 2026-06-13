#### Role name:
    `disable_ldap_server`

#### Wazuh ID:
    `35567`

#### Title:
    Ensure ldap server services are not in use.

#### Description:
    The Lightweight Directory Access Protocol (LDAP) was introduced as a replacement for NIS/YP. It is a service that provides a method for looking up information from a central database.

#### Rationale:
    If the system will not need to act as an LDAP server, it is recommended that the software be removed to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop slapd.service and remove the slapd package:  
    `# systemctl stop slapd.service`  
    `# apt purge slapd`  
    - OR -  
    If the slapd package is required as a dependency:  
    Run the following commands to stop and mask slapd.service:  
    `# systemctl stop slapd.service`  
    `# systemctl mask slapd.service`

#### Requirements
    - Ansible 2.16 or higher (inferred from modern module syntax and features used)
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu (inferred from use of `apt`, `dpkg-query`, and systemd service management in tasks)
    - Required Ansible collections/modules: `ansible.builtin.apt`, `ansible.builtin.systemd`, `ansible.builtin.file`, `ansible.builtin.lineinfile`, `ansible.builtin.command`

#### Variables

### defaults/main.yml

| Variable                        | Default                                 | Description                                                                                                    |
|---------------------------------|-----------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `disable_ldap_server_enabled`   | `true`                                  | Controls whether the role enforces disabling of LDAP server services (enables/disables all remediation tasks). |
| `ldap_service_name`             | `slapd`                                 | Name of the LDAP service to manage; used for systemd and package operations.                                   |
| `ldap_modprobe_conf_dir`        | `/etc/modprobe.d`                       | Directory path where modprobe configuration files reside.                                                      |
| `ldap_modprobe_blacklist_file`  | `/etc/modprobe.d/slapd.conf` (derived)  | Full path to the modprobe blacklist file for slapd kernel module; derived from `ldap_modprobe_conf_dir`.       |

### vars/main.yml

| Variable                  | Default                    | Description                                                            |
|---------------------------|----------------------------|------------------------------------------------------------------------|
| `ldap_packages_to_check`  | `["slapd", "ldap-utils"]`  | List of packages to check for presence and manage during remediation.  |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but handler is disabled by default via `when: false`)*  
    Dependencies on other roles: *none*

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
    c:dpkg-query -s slapd -> r:package 'slapd' is not installed  
    not c:systemctl show slapd.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_ldap_server
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz