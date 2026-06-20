#### Role name:
    disable_xinetd

#### Wazuh ID:
    35579

#### Title:
    Ensure xinetd services are not in use.

#### Description:
    The eXtended InterNET Daemon (xinetd) is an open source super daemon that replaced the original inetd daemon. The xinetd daemon listens for well known services and dispatches the appropriate daemon to properly respond to service requests.

#### Rationale:
    If there are no xinetd services required, it is recommended that the package be removed to reduce the attack surface of the system. Note: If an xinetd service or services are required, ensure that any xinetd service not required is stopped and masked.

#### Remediation:
    Run the following commands to stop xinetd.service, and remove the xinetd package:  
    `# systemctl stop xinetd.service`  
    `# apt purge xinetd`  
    -OR-  
    If the xinetd package is required as a dependency:  
    `# systemctl stop xinetd.service`  
    `# systemctl mask xinetd.service`

#### Requirements
    - Ansible 2.16 or higher (required for full compatibility with `ansible.builtin.systemd`, `ansible.builtin.apt`, and `package_facts`)
    - `become: yes` required (to manage system services via systemd, modify package state via apt)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt`, `systemctl` commands in remediation, and task logic targeting dpkg/apt-based systems)
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable                 | Default  | Description |
|--------------------------|----------|-------------|
| `xinetd_service_name`    | `xinetd` | Name of the xinetd service unit (used to construct systemd unit names) |
| `xinetd_package_name`    | `xinetd` | Name of the xinetd package to manage via apt |
| `xinetd_enabled`         | `true`   | Boolean flag controlling whether the role enforces disabling/removal of xinetd (when `false`, no actions are taken) |
| `xinetd_remove_packages` | `false`  | When `true`, purges the xinetd package entirely; when `false`, only stops/masks the service without removing the package |

### vars/main.yml

| Variable            | Default                               | Description |
|---------------------|---------------------------------------|-------------|
| `xinetd_unit_names` | `['xinetd.service', 'xinetd.socket']` | List of systemd unit names (service and socket) to manage; derived from `xinetd_service_name` |

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
    c:dpkg-query -s xinetd -> r:package 'xinetd' is not installed  
    not c:systemctl show xinetd.service -> r:^LoadState=loaded\|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_xinetd
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
