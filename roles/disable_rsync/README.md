#### Role name:
    disable_rsync

#### Wazuh ID:
    35573

#### Title:
    Ensure rsync services are not in use.

#### Description:
    The rsync service can be used to synchronize files between systems over network links.

#### Rationale:
    rsync.service presents a security risk as the rsync protocol is unencrypted. The rsync package should be removed to reduce the attack area of the system.

#### Remediation:
    Run the following commands to stop rsync.service, and remove the rsync package:  
    `# systemctl stop rsync.service`  
    `# apt purge rsync`  
    - OR -  
    IF the rsync package is required as a dependency:  
    Run the following commands to stop and mask rsync.service:  
    `# systemctl stop rsync.service`  
    `# systemctl mask rsync.service`

#### Requirements
    - Ansible 2.16 or higher (required for full compatibility with `ansible.builtin.systemd`, `ansible.builtin.apt`, and `package_facts`)
    - `become: yes` required (to stop/mask systemd services and purge packages)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` in tasks)
    - Required Ansible collections/modules:  
      `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.package_facts`

#### Variables

### defaults/main.yml

| Variable                        | Default   | Description                                                                                                                                                           |
|---------------------------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rsync_service_name`            | `rsync`   | Name of the rsync systemd service (used to construct service unit name). Inferred from task context and naming convention.                                            |
| `rsync_package_name`            | `rsync`   | Name of the rsync package to manage via APT. Inferred from task context and Wazuh remediation.                                                                        |
| `rsync_required_as_dependency`  | `false`   | Boolean flag indicating whether rsync is required as a dependency (i.e., installed for other packages). When true, only stop/mask service; when false, purge package. |

### vars/main.yml
| Variable        | Default             | Description                                                                                                                                                                                                                                                                                                                                                  |
|-----------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rsync_service` | `["rsync.service"]` | List of rsync systemd service unit names (derived from `rsync_service_name`). Used in looped systemd operations. DECLARED BUT NOT USED — *Note: Although defined, `rsync_service` is not referenced directly in tasks/main.yml; instead, `"{{ item }}"` loops over `rsync_service`, but the variable itself is only used via interpolation in the task loop.* |

#### Dependencies
    Handlers: `handlers/main.yml`
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
    c:dpkg-query -s rsync -> r:package 'rsync' is not installed  
    not c:systemctl show rsync.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_rsync
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz