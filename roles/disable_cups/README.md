#### Role name:
    disable_cups

#### Wazuh ID:
    35571

#### Title:
    Ensure print server services are not in use.

#### Description:
    The Common Unix Print System (CUPS) provides the ability to print to both local and network printers. A system running CUPS can also accept print jobs from remote systems and print them to local printers. It also provides a web based remote administration capability.

#### Rationale:
    If the system does not need to print jobs or accept print jobs from other systems, it is recommended that CUPS be removed to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop cups.socket and cups.service, and remove the cups package:  
    `systemctl stop cups.socket cups.service`  
    `apt purge cups`  
    - OR -  
    IF the cups package is required as a dependency:  
    Run the following commands to stop and mask the cups.socket and cups.service:  
    `systemctl stop cups.socket cups.service`  
    `systemctl mask cups.socket cups.service`

#### Requirements
    - Ansible 2.16 or higher (required for `dpkg_status` module availability and modern systemd behavior)
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.dpkg_status`, `apt`, and `systemctl`)
    - Required Ansible collections/modules: `ansible.builtin.dpkg_status`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.shell`, `ansible.builtin.assert`, `ansible.builtin.debug`

#### Variables

### defaults/main.yml

| Variable           | Default        | Description                                                                                                                                                   |
|--------------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cups_service_name  | "cups.service" | Name of the primary CUPS systemd service unit; used to construct the list of services to manage. Inferred from variable naming and usage in `tasks/main.yml`. |
| cups_package_name  | "cups"         | Name of the CUPS package to be purged or checked for installation status. Inferred from task context (`dpkg_status`, `apt`).                                  |

### vars/main.yml
| Variable       | Default          | Description                                                                                                             |
|----------------|------------------|-------------------------------------------------------------------------------------------------------------------------|
| cups_services  | [cups.services]  | Declared as a list containing `cups.service`. The variable is referenced in `tasks/main.yml` via `{{ cups_services }}`  |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but empty; no handlers defined)*  
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
    all

#### Rules
    c:dpkg-query -s cups -> r:package 'cups' is not installed  
    not c:systemctl show cups.socket cups.service -> r:^LoadState=loaded\|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_cups
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz