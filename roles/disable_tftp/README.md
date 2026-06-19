#### Role name:
    disable_tftp

#### Wazuh ID:
    35576

#### Title:
    Ensure tftp server services are not in use.

#### Description:
    Trivial File Transfer Protocol (TFTP) is a simple protocol for exchanging files between two TCP/IP machines. TFTP servers allow connections from a TFTP Client for sending and receiving files.

#### Rationale:
    Unless there is a need to run the system as a TFTP server, it is recommended that the package be removed to reduce the potential attack surface. TFTP does not have built-in encryption, access control or authentication. This makes it very easy for an attacker to exploit TFTP to gain access to files.

#### Remediation:
    Run the following commands to stop tftpd-hpa.service, and remove the tftpd-hpa package:  
    ```bash
    # systemctl stop tftpd-hpa.service
    # apt purge tftpd-hpa
    ```  
    - OR -  
    IF the tftpd-hpa package is required as a dependency: Run the following commands to stop and mask tftpd-hpa.service:  
    ```bash
    # systemctl stop tftpd-hpa.service
    # systemctl mask tftpd-hpa.service
    ```

#### Requirements
    - Ansible 2.16 or higher (required for full `systemd` module functionality, including `masked` parameter)
    - `become: yes` required (to manage system services and packages via `apt`, `systemd`)
    - OS: Debian/Ubuntu (inferred from use of `dpkg-query`, `apt`, and `tftpd-hpa` package name in tasks/main.yml)
    - Required Ansible collections/modules:  
      `ansible.builtin.shell`, `ansible.builtin.systemd`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable                              | Default       | Description                                                                                                        |
|---------------------------------------|---------------|--------------------------------------------------------------------------------------------------------------------|
| `tftp_service_name`                   | `"tftpd-hpa"` | Name of the TFTP service unit (used to construct service/socket names).                                            |
| `tftp_package_name`                   | `"tftpd-hpa"` | Name of the TFTP server package to manage.                                                                         |
| `mask_service_if_dependency_required` | `true`        | If `true`, mask the TFTP service instead of removing the package when dependencies require it to remain installed. |

### vars/main.yml
| Variable        | Default                                                      | Description                                                                     |
|-----------------|--------------------------------------------------------------|---------------------------------------------------------------------------------|
| `tftp_services` | [{{tftp_service_name}}.service,{{tftp_service_name}}.socket] | List of systemd units derived from `tftp_service_name` (`.service`, `.socket`). |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but empty – no handlers defined)*  
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
    - c:dpkg-query -s tftpd-hpa -> r:package 'tftpd-hpa' is not installed  
    - not c:systemctl show tftpd-hpa.service -> r:^LoadState=loaded\|^ActiveState=active  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_tftp
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz