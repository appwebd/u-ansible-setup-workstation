# Role name:
    ensure_reauth_privilege

#### Wazuh ID:
    35666

#### Title:
    Ensure re-authentication for privilege escalation is not disabled globally.

#### Description:
    The operating system must be configured so that users must re-authenticate for privilege escalation.

#### Rationale:
    Without re-authentication, users may access resources or perform tasks for which they do not have authorization. When operating systems provide the capability to escalate a functional capability, it is critical the user re-authenticate.

#### Requirements
    - Ansible 2.9 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: `ansible.builtin.file`, `ansible.builtin.service`, `ansible.builtin.lineinfile`, `ansible.builtin.command`, etc., used explicitly in tasks
    
#### Variables

### defaults/main.yml
| Variable        | Default                            | Description                                    | Source              |
|-----------------|------------------------------------|------------------------------------------------|---------------------|
| sudoers_file    | `/etc/sudoers`                     | Path to the sudoers file.                      | `defaults/main.yml` |
| sudoers_files   | `/etc/sudoers`, `/etc/sudoers.d/*` | List of paths to check for !authenticate tags. | `vars/main.yml`     |
| tags_to_remove  | `['!authenticate']`                | Tags to remove from sudoers files.             | `defaults/main.yml` |

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*
    Dependencies on other roles: *none / list*

#### Compliance mapping
    - CMMC: ['AC.L2-3.1.5', 'AC.L2-3.1.6', 'AC.L2-3.1.7', 'SC.L2-3.13.3']
    - FedRAMP: ['AC-6']
    - GDPR: ['32']
    - HIPAA: ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']
    - ISO 27001: ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']
    - NIS 2: ['21.2.i', '21.2.k']
    - NIST 800-171: ['3.1.5', '3.1.6', '3.1.7', '3.13.3']
    - NIST 800-53: ['AC-6']
    - PCI DSS: ['7.1']
    - TSC: ['CC6.1', 'CC6.3', 'CC6.2', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    - Tactic: ['TA0006', 'TA0003']
    - Technique: ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']
    - Subtechnique: ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
    None specified.

#### Rules
    - `f:/etc/sudoers -> r:^\\s*\\t*!authenticate`
    - `d:/etc/sudoers.d -> r:.* -> r:^\\s*\\t*!authenticate`

#### Usage
```code
- hosts: servers
  become: yes
  roles:
    - ensure_reauth_privilege
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
