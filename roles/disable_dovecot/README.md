#### Role name:
    disable_dovecot

#### Wazuh ID:
    35568

#### Title:
    Ensure message access server services are not in use.

#### Description:
    dovecot-imapd and dovecot-pop3d are an open source IMAP and POP3 server for Linux based systems.

#### Rationale:
    Unless POP3 and/or IMAP servers are to be provided by this system, it is recommended that the package be removed to reduce the potential attack surface. Note: Several IMAP/POP3 servers exist and can use other service names. These should also be audited and the packages removed if not required.

#### Remediation:
    Run one of the following commands to remove dovecot-imapd and dovecot-pop3d:  
    Run the following commands to stop dovecot.socket and dovecot.service, and remove the dovecot-imapd and dovecot-pop3d packages:  
    `# systemctl stop dovecot.socket dovecot.service`  
    `# apt purge dovecot-imapd dovecot-pop3d`  
    - OR -  
    IF a package is installed and is required for dependencies:  
    Run the following commands to stop and mask dovecot.socket and dovecot.service:  
    `# systemctl stop dovecot.socket dovecot.service`  
    `# systemctl mask dovecot.socket dovecot.service`

#### Requirements
    - Ansible 2.16 or higher (inferred from modern module usage such as `ansible.builtin.systemd`)
    - `become: yes` required (to modify system packages and services)
    - OS: Debian/Ubuntu (inferred from use of `dpkg-query`, `apt`, and systemd service names)
    - Required Ansible collections/modules: `ansible.builtin.shell`, `ansible.builtin.systemd`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable                         | Default                               | Description                                                                                                           |
|----------------------------------|---------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| disable_dovecot_enabled          | true                                  | Controls whether the role tasks are executed; when false, no actions are taken.                                       |
| disable_dovecot_remove_packages  | true                                  | When true, removes dovecot packages after stopping/masking services; when false, only stops and masks services.       |
| disable_dovecot_mask_services    | false                                 | When true, ensures Dovecot services remain masked even if not installed (used to enforce state in idempotent checks). |
| dovecot_packages                 | ["dovecot-imapd", "dovecot-pop3d"]    | List of packages targeted for removal.                                                                                |
| dovecot_services                 | ["dovecot.socket", "dovecot.service"] | List of systemd services to stop and mask.                                                                            |

### vars/main.yml
| Variable                | Default                         | Description                                                                          |
|-------------------------|---------------------------------|--------------------------------------------------------------------------------------|
| dovecot_packages_query  | `"dovecot-imapd dovecot-pop3d"` | Concatenated string of package names for use in shell commands (e.g., `dpkg-query`). |

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*  
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
    not c:dpkg-query -s dovecot-imapd dovecot-pop3d -> r:^Status: install ok installed  
    not c:systemctl show dovecot-imapd.socket dovecot.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_dovecot
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz