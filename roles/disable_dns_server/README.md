#### Role name:
    disable_dns_server

#### Wazuh ID:
    35564

#### Title:
    Ensure dns server services are not in use.

#### Description:
    The Domain Name System (DNS) is a hierarchical naming system that maps names to IP addresses for computers, services and other resources connected to a network. Note: bind9 is the package and bind.service is the alias for named.service.

#### Rationale:
    Unless a system is specifically designated to act as a DNS server, it is recommended that the package be deleted to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop named.service and remove the bind9 package:  
    ```bash
    # systemctl stop named.service
    # apt purge bind9
    ```  
    OR  
    If the bind9 package is required as a dependency:  
    ```bash
    # systemctl stop named.service
    # systemctl mask named.service
    ```

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to manage services, modify system configuration files, and purge packages)  
    - OS: Debian/Ubuntu (inferred from use of `package_facts`, `apt`)  
    - Required Ansible modules: `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.command`  

#### Variables
| Variable                   | Default                              | Description                                                                     | Source              |
|----------------------------|--------------------------------------|---------------------------------------------------------------------------------|---------------------|
| `dns_server_package`       | `bind9`                              | Name of the DNS server package to be removed (used in package management tasks) | `defaults/main.yml` |
| `dns_server_service_names` | `["named.service", "bind9.service"]` | List of service names to stop and mask (used in systemd tasks)                  | `vars/main.yml`     |


#### Dependencies
    Handlers: `handlers/main.yml` *(not provided; not used in tasks — no handlers declared in `tasks/main.yml`)*  
    Dependencies on other roles: *none*  

#### Compliance mapping
    - CMMC: `CM.L2-3.4.7`, `CM.L2-3.4.8`, `SC.L2-3.13.6`  
    - FedRAMP: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - GDPR: `32`  
    - HIPAA: `164.308(a)(1)`  
    - ISO 27001: `A.12.1.1`, `A.12.1.2`, `A.14.2.1`  
    - NIS2: `21.2.e`, `21.2.a`  
    - NIST 800-171: `3.4.7`, `3.4.8`, `3.13.6`  
    - NIST 800-53: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - PCI DSS: `1.1`, `1.2`, `2.2`, `6.4`  
    - TSC: `CC6.3`, `CC6.6`, `CC8.1`, `CC5.1`, `CC5.2`, `CC5.3`  

#### Mitre
    - Tactic: `TA0005` (Defense Evasion)  
    - Technique: `T1036` (Masquerading), `T1564` (Hide Artifacts)  

#### Conditions
    `any`

#### Rules
    - `c:dpkg-query -s bind9 -> r:package 'bind9' is not installed`  
    - `not c:systemctl show named.service -> r:^LoadState=loaded\|^ActiveState=active`  

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_dns_server
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
