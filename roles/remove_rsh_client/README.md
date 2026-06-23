#### Role name:
    remove_rsh_client

#### Wazuh ID:
    35583

#### Title:
    Ensure rsh client is not installed.

#### Description:
    The rsh-client package contains the client commands for the rsh services.

#### Rationale:
    These legacy clients contain numerous security exposures and have been replaced with the more secure SSH package. Even if the server is removed, it is best to ensure the clients are also removed to prevent users from inadvertently attempting to use these commands and therefore exposing their credentials. Note that removing the rsh-client package removes the clients for rsh , rcp and rlogin.

#### Remediation:
    Uninstall rsh: # apt purge rsh-client.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`)
    - Required Ansible collections/modules:
      - `ansible.builtin.assert`
      - `ansible.builtin.apt`
      - `ansible.builtin.package_facts`
      - `ansible.builtin.set_fact`
      - `ansible.builtin.systemd`

#### Variables

### defaults/main.yml

| Variable         | Default     | Description |
|------------------|-------------|-------------|
| rsh_package_name | rsh-client  | Name of the RSH client package to remove. Used in `tasks/main.yml` for package removal via `apt`. |
| rsh_service_list | [rsh.socket, rlogin.socket, rshd.service, rlogind.service] | Service list of rsh client |


### vars/main.yml
| Variable            | Default     | Description       |
|---------------------|-------------|-------------------|
| rsh_packages_state  |  absent     | status of package |
| rsh_services_state  |  stopped    | status of service |
| rsh_services_masked | true        | Mask package      |

#### Dependencies
    Handlers: `handlers/main.yml` *(exists but not used — no tasks notify this handler)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - cmmc: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6
    - fedramp: CM-2, CM-3, CM-6, CM-7
    - gdpr: 32
    - hipaa: 164.308(a)(1)
    - iso_27001: A.12.1.1, A.12.1.2, A.14.2.1
    - nis2: 21.2.e, 21.2.a
    - nist_800_171: 3.4.7, 3.4.8, 3.13.6
    - nist_800_53: CM-2, CM-3, CM-6, CM-7
    - pci_dss: 1.1, 1.2, 2.2, 6.4
    - tsc: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

#### Mitre
    - tactic: TA0005
    - technique: T1036, T1564

#### Conditions
    all

#### Rules
    c:dpkg-query -s rsh-client -> r:package 'rsh-client' is not installed

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - remove_rsh_client
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-23_17:49:30
