#### Role name:
    disable_web_server_services

#### Wazuh ID:
    35578

#### Title:
    Ensure web server services are not in use.

#### Description:
    Web servers provide the ability to host web site content.

#### Rationale:
    Unless there is a local site approved requirement to run a web server service on the system, web server packages should be removed to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop httpd.socket, httpd.service, and nginx.service, and remove apache2 and nginx packages:  
    ```bash
    # systemctl stop apache2.socket apache2.service nginx.service  
    # apt purge apache2 nginx  
    ```  
    OR — IF a package is installed and is required for dependencies:  
    Run the following commands to stop and mask apache2.socket, apache2.service, and nginx.service:  
    ```bash
    # systemctl stop apache2.socket apache2.service nginx.service  
    # systemctl mask apache2.socket apache2.service nginx.service  
    ```  
    Note: Other web server packages may exist. If not required and authorized by local site policy, they should also be removed. If the package is required for a dependency, the service and socket should be stopped and masked.

#### Requirements
    - Ansible 2.16 or higher (inferred from use of `ansible.builtin.package_facts` with `manager: auto`, introduced in Ansible 2.15+; production best practice recommends ≥2.16)
    - `become: yes` required (to modify system packages, services, and configuration files via `apt` and `systemd`)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt`, absence of `yum/dnf`, and package names `apache2`, `nginx`, `lighttpd` typical on Debian-based systems)
    - Required Ansible collections/modules:  
      `ansible.builtin.package_facts`, `ansible.builtin.debug`, `ansible.builtin.systemd`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml
| Variable                  | Default                     | Description |
|---------------------------|-----------------------------|-------------|
| `web_service_packages`    | `[apache2, nginx, lighttpd]` | List of web server packages to stop and remove; inferred from task loop and Wazuh remediation guidance |

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
    - not c:dpkg-query -s apache2 nginx -> r:^Status: install ok installed  
    - not c:systemctl show apache2.socket apache2.service nginx.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_web_services
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz