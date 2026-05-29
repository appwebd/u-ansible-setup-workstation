#### Role name:
    install_sudo

#### Wazuh ID:
    35662

#### Title:
    Ensure sudo is installed.

#### Description:
    This role ensures the `sudo` package is installed on Debian/Ubuntu systems. It uses `ansible.builtin.apt` to install the `sudo` package (configurable via `sudo_package_name`) with cache refresh, and then verifies installation status using `dpkg -s`. If the package is not in `install ok installed` state, the role fails with a clear message. The role targets only Debian-family OSes (`ansible_facts.os_family == "Debian"`), and does not handle Red Hat-family systems (no `yum`/`dnf` tasks present).

#### Rationale:
    sudo supports a plug-in architecture for security policies and input/output logging. Third parties can develop and distribute their own policy and I/O logging plug-ins to work seamlessly with the sudo front end. The default security policy is sudoers, which is configured via the file /etc/sudoers and any entries in /etc/sudoers.d. The security policy determines what privileges, if any, a user has to run sudo. The policy may require that users authenticate themselves with a password or another authentication mechanism. If authentication is required, sudo will exit if the user's password is not entered within a configurable time limit. This limit is policy-specific.

#### Remediation:
    First determine if LDAP functionality is required. If so, then install sudo-ldap, else install sudo. Example: # apt install sudo.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to run `apt` and `dpkg` commands with elevated privileges)  
    - OS: Debian/Ubuntu (inferred from `when: ansible_facts.os_family == "Debian"`)  
    - Required Ansible collections/modules: `ansible.builtin.apt`, `ansible.builtin.shell`, `ansible.builtin.fail`  

#### Variables
| Variable                 | Default                 | Description                                                                                                            | Source     |
|--------------------------|-------------------------|------------------------------------------------------------------------------------------------------------------------|------------|
| `sudo_package_name`      | `"sudo"`                | Name of the primary sudo package to install (used in `apt` task and verification)                                      | `defaults` |
| `sudo_package_state`     | `"present"`             | Desired state of the sudo package (e.g., `present`, `latest`)                                                          | `defaults` |

#### Dependencies
    Handlers: `handlers/main.yml` *(not present in input)*  
    Dependencies on other roles: *none*  

#### Compliance mapping
    cmmc: ['AC.L2-3.1.5', 'AC.L2-3.1.6', 'AC.L2-3.1.7', 'SC.L2-3.13.3']  
    fedramp: ['AC-6']  
    gdpr: ['32']  
    hipaa: ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']  
    iso_27001: ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']  
    nis2: ['21.2.i', '21.2.k']  
    nist_800_171: ['3.1.5', '3.1.6', '3.1.7', '3.13.3']  
    nist_800_53: ['AC-6']  
    pci_dss: ['7.1']  
    tsc: ['CC6.1', 'CC6.3', 'CC6.2', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    tactic: ['TA0006', 'TA0003']  
    technique: ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']  
    subtechnique: ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
    any

#### Rules
    c:dpkg -s sudo -> r:install ok installed  
    c:dpkg -s sudo-ldap -> r:install ok installed

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - install_sudo
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
