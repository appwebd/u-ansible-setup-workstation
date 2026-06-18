#### Role name:
    disable_samba

#### Wazuh ID:
    35574

#### Title:
    Ensure samba file server services are not in use.

#### Description:
    The Samba daemon allows system administrators to configure their Linux systems to share file systems and directories with Windows desktops. Samba will advertise the file systems and directories via the Server Message Block (SMB) protocol. Windows desktop users will be able to mount these directories and file systems as letter drives on their systems.

#### Rationale:
    If there is no need to mount directories and file systems to Windows systems, then this service should be deleted to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop smbd.service and remove samba package:  
    `# systemctl stop smbd.service`  
    `# apt purge samba`  
    - OR -  
    IF the samba package is required as a dependency:  
    Run the following commands to stop and mask smbd.service:  
    `# systemctl stop smbd.service`  
    `# systemctl mask smbd.service`

#### Requirements
    - Ansible 2.16 or higher (required for reliable handling of `package_facts`, `systemd`, and complex conditionals)
    - `become: yes` required (to modify system packages, services, or configuration files via `apt`, `systemctl`)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` in tasks)
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.command`, `ansible.builtin.systemd`, `ansible.builtin.fail`

#### Variables

### defaults/main.yml

| Variable                  | Default | Description                                                                                                                                                     |
|---------------------------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| samba_service_name        | smbd    | Name of the primary Samba service to stop and mask; used in systemd operations (e.g., `smbd.service`)                                                           |
| samba_package_name        | samba   | Name of the Samba package to purge if not required as a dependency                                                                                              |
| samba_stop_and_mask_only  | false   | If true, only stop and mask services without purging the package; useful when Samba is installed as a dependency but file server functionality must be disabled |

### vars/main.yml
| Variable        | Default                | Description                                                                                                           |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------------------------|
| samba_services  | [smbd, nmbd, winbind]  | List of all Samba-related services to verify are not loaded after remediation; includes `smbd`, `nmbd`, and `winbind` |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but empty – no handlers required)*  
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
    c:dpkg-query -s samba -> r:package 'samba' is not installed  
    not c:systemctl show smbd.service -> r:^LoadState=loaded\|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_samba
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
