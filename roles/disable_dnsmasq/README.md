#### Role name:
    disable_dnsmasq

#### Wazuh ID:
    35565

#### Title:
    Ensure dnsmasq services are not in use.

#### Description:
    dnsmasq is a lightweight tool that provides DNS caching, DNS forwarding and DHCP (Dynamic Host Configuration Protocol) services.

#### Rationale:
    Unless a system is specifically designated to act as a DNS caching, DNS forwarding and/or DHCP server, it is recommended that the package be removed to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop dnsmasq.service and remove dnsmasq package: # systemctl stop dnsmasq.service # apt purge dnsmasq - OR - - IF - the dnsmasq package is required as a dependency: Run the following commands to stop and mask the dnsmasq.service: # systemctl stop dnsmasq.service # systemctl mask dnsmasq.service.

#### Requirements
    - Ansible 2.9 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.package`, `ansible.builtin.debug`

#### Variables

### defaults/main.yml

| Variable               | Default          | Description                                     | Source              |
|------------------------|------------------|-------------------------------------------------|---------------------|
| dnsmasq_package_name   | dnsmasq          | The name of the dnsmasq package to be managed.  | `defaults/main.yml` |
| dnsmasq_service_name   | dnsmasq.service  | The name of the dnsmasq service to be managed.  | `defaults/main.yml` |

### vars/main.yml
No variables defined.

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*
    Dependencies on other roles: *none*

#### Compliance mapping
- **cmmc**: ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']
- **fedramp**: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
- **gdpr**: ['32']
- **hipaa**: ['164.308(a)(1)']
- **iso_27001**: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
- **nis2**: ['21.2.e', '21.2.a']
- **nist_800_171**: ['3.4.7', '3.4.8', '3.13.6']
- **nist_800_53**: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
- **pci_dss**: ['1.1', '1.2', '2.2', '6.4']
- **tsc**: ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
- **Tactic**: ['TA0005']
- **Technique**: ['T1036', 'T1564']

#### Conditions
    any

#### Rules
    ["c:dpkg-query -s dnsmasq -> r:package 'dnsmasq' is not installed", 'not c:systemctl show dnsmasq.service -> r:^LoadState=loaded|^ActiveState=active']

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_dnsmasq
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
