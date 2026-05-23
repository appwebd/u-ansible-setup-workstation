#### Role name:
    disable_dhcp_server

#### Wazuh ID:
    35563

#### Title:
    Ensure dhcp server services are not in use.

#### Description:
    The Dynamic Host Configuration Protocol (DHCP) is a service that allows machines to be dynamically assigned IP addresses. There are two versions of the DHCP protocol DHCPv4 and DHCPv6. At startup the server may be started for one or the other via the -4 or -6 arguments.

#### Rationale:
    Unless a system is specifically set up to act as a DHCP server, it is recommended that this package be removed to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop isc-dhcp-server.service and isc-dhcp-server6.service and remove the isc-dhcp-server package:  
    ```bash
    # systemctl stop isc-dhcp-server.service isc-dhcp-server6.service
    # apt purge isc-dhcp-server
    ```  
    OR  
    - IF the isc-dhcp-server package is required as a dependency:  
    Run the following commands to stop and mask isc-dhcp-server.service and isc-dhcp-server6.service:  
    ```bash
    # systemctl stop isc-dhcp-server.service isc-dhcp-server6.service
    # systemctl mask isc-dhcp-server isc-dhcp-server6.service
    ```

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to manage systemd services, modify `/etc/modprobe.d/`, and purge packages)  
    - OS: Debian/Ubuntu (inferred from use of `apt` module and `dpkg`-style package naming in Wazuh rules)  
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.set_fact`, `ansible.builtin.shell`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.copy`

#### Variables 
| Variable                         | Default                                                   | Description                                                                                                   | Source              |
|----------------------------------|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|---------------------|
| `dhcp_server_modprobe_conf_path` | `"/etc/modprobe.d/dhcp-server-blacklist.conf"`            | Path to the modprobe configuration file used to blacklist DHCP kernel modules.                                | `vars/main.yml`     |
| `dhcp_server_modprobe_content`   | (multiline string)                                        | Content to write to modprobe config: blacklists `dhclient` and prevents its loading via `install /bin/false`. | `vars/main.yml`     |
| `dhcp_server_package_name`       | `"isc-dhcp-server"`                                       | Name of the DHCP server package to be removed; used in `apt` purge task.                                      | `defaults/main.yml` |
| `dhcp_server_services`           | `["isc-dhcp-server.service", "isc-dhcp-server6.service"]` | List of systemd service units corresponding to DHCPv4 and DHCPv6 servers; used to stop and mask services.     | `defaults/main.yml` |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided in input — assumed absent)*  
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
    - `any`  
    - Condition 1: `c:dpkg-query -s isc-dhcp-server -> r:package 'isc-dhcp-server' is not installed`  
    - Condition 2: `not c:systemctl show isc-dhcp-server.service isc-dhcp-server6.service -> r:^LoadState=loaded|^ActiveState=active`

#### Rules
    - `c:dpkg-query -s isc-dhcp-server -> r:package 'isc-dhcp-server' is not installed`  
    - `not c:systemctl show isc-dhcp-server.service isc-dhcp-server6.service -> r:^LoadState=loaded|^ActiveState=active`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_dhcp_server
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
