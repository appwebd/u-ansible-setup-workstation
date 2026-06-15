#### Role name:
    disable_nis_server

#### Wazuh ID:
    35570

#### Title:
    Ensure nis server services are not in use.

#### Description:
    The Network Information Service (NIS) (formally known as Yellow Pages) is a client-server directory service protocol for distributing system configuration files. The NIS server is a collection of programs that allow for the distribution of configuration files. The NIS client (ypbind) was used to bind a machine to an NIS server and receive the distributed configuration files.

#### Rationale:
    ypserv.service is inherently an insecure system that has been vulnerable to DOS attacks, buffer overflows and has poor authentication for querying NIS maps. NIS generally has been replaced by such protocols as Lightweight Directory Access Protocol (LDAP). It is recommended that ypserv.service be removed and other, more secure services be used.

#### Remediation:
    Run the following commands to stop ypserv.service and remove ypserv package:  
    `# systemctl stop ypserv.service`  
    `# apt purge ypserv`  
    - OR -  
    IF the ypserv package is required as a dependency:  
    Run the following commands to stop and mask ypserv.service:  
    `# systemctl stop ypserv.service`  
    `# systemctl mask ypserv.service`

#### Requirements
    - Ansible 2.16 or higher (required for full compatibility with `ansible.builtin.systemd`, `package_facts`, and modern module behavior)
    - `become: yes` required (to manage systemd services and manipulate system packages via `apt`)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` and `dpkg-query` in tasks)
    - Required Ansible collections/modules:  
      `ansible.builtin.package_facts`,  
      `ansible.builtin.systemd`,  
      `ansible.builtin.apt`,  
      `ansible.builtin.command`

#### Variables

### defaults/main.yml

| Variable                 | Default  | Description                                                                                                                                                                                    |
|--------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `nis_stop_and_mask_only` | `false`  | If `true`, only stop and mask the NIS service without purging the package (used when ypserv is required as a dependency but must be disabled); if `false`, attempt full removal of the package |

### vars/main.yml
| Variable           | Default          | Description                                                                                       |
|--------------------|------------------|---------------------------------------------------------------------------------------------------|
| `nis_service_name` | `ypserv.service` | Name of the systemd service unit for NIS server (inferred from task usage and Wazuh requirement)  |
| `nis_package_name` | `ypserv`         | Name of the APT package providing the NIS server (inferred from task usage and Wazuh requirement) |

#### Dependencies
    Handlers: `handlers/main.yml` *(present and invoked in current tasks)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    fedramp: CM-2, CM-3, CM-6, CM-7  
    gdpr: 32  
    hipaa: 164.308(a)(1)  
    iso_27001: A.12.1.1, A.12.1.2, A.14.2.1  
    nis2: 21.2.e, 21.2.a  
    nist_800_171: 3.4.7, 3.4.8, 3.13.6  
    nist_800_53: CM-2, CM-3, CM-6, CM-7  
    pci_dss: 1.1, 1.2, 2.2, 6.4  
    tsc: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

#### Mitre
    tactic: TA0005  
    technique: T1036, T1564

#### Conditions
    all

#### Rules
    c:dpkg-query -s ypserv -> r:package 'ypserv' is not installed  
    not c:systemctl show ypserv.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_nis_server
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz