#### Role name:
    disable_vsftpd

#### Wazuh ID:
    35566

#### Title:
    Ensure ftp server services are not in use.

#### Description:
    The File Transfer Protocol (FTP) provides networked computers with the ability to transfer files. vsftpd is the Very Secure File Transfer Protocol Daemon.

#### Rationale:
    FTP does not protect the confidentiality of data or authentication credentials. It is recommended SFTP be used if file transfer is required. Unless there is a need to run the system as a FTP server (for example, to allow anonymous downloads), it is recommended that the package be deleted to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop vsftpd.service and remove the vsftpd package: 
    # systemctl stop vsftpd.service 
    # apt purge vsftpd 
    - OR - 
    - IF - the vsftpd package is required as a dependency: 
    Run the following commands to stop and mask the vsftpd.service: 
    # systemctl stop vsftpd.service 
    # systemctl mask vsftpd.service 
    Note: Other ftp server packages may exist. If not required and authorized by local site policy, they should also be removed. If the package is required for a dependency, the service should be stopped and masked.

#### Requirements
    - Ansible 2.9 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: `ansible.builtin.command`, `ansible.builtin.systemd`, `ansible.builtin.package`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable               | Default                                 | Description                                          | Source             |
|------------------------|-----------------------------------------|------------------------------------------------------|--------------------|
| vsftpd_package_name    | vsftpd                                  | The name of the vsftpd package                       | defaults/main.yml  |
| vsftpd_service_name    | vsftpd.service                          | The name of the vsftpd service                       | defaults/main.yml  |

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*
    Dependencies on other roles: none

#### Compliance mapping
    {'cmmc': ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6'], 'fedramp': ['CM-2', 'CM-3', 'CM-6', 'CM-7'], 'gdpr': ['32'], 'hipaa': ['164.308(a)(1)'], 'iso_27001': ['A.12.1.1', 'A.12.1.2', 'A.14.2.1'], 'nis2': ['21.2.e', '21.2.a'], 'nist_800_171': ['3.4.7', '3.4.8', '3.13.6'], 'nist_800_53': ['CM-2', 'CM-3', 'CM-6', 'CM-7'], 'pci_dss': ['1.1', '1.2', '2.2', '6.4'], 'tsc': ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']}

#### Mitre
    - Tactic: TA0005
    - Technique: T1036, T1564

#### Conditions
    any

#### Rules
    ["c:dpkg-query -s vsftpd -> r:package 'vsftpd' is not installed", 'not c:systemctl show vsftpd.service -> r:^LoadState=loaded|^ActiveState=active']

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_vsftpd
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
