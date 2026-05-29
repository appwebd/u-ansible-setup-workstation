#### Role name:
    sudo_pty

#### Wazuh ID:
    35663

#### Title:
    Ensure sudo commands use pty.

#### Description:
    This role ensures that sudo commands are executed only from a pseudo-terminal (pty) by enforcing the `Defaults use_pty` setting in both the main `/etc/sudoers` file and in `/etc/sudoers.d/` files. It creates or updates a dedicated configuration file (`/etc/sudoers.d/99-pty-enforcement`) when enabled, removes any `!use_pty` negations from all sudoers files, and validates the configuration using `visudo -c`. The role uses `ansible.builtin.file`, `ansible.builtin.lineinfile`, `ansible.builtin.copy`, `ansible.builtin.find`, and `ansible.builtin.command` modules, and requires `become: yes` due to system-level file modifications. A handler (`Validate sudoers configuration`) is invoked after each configuration change, and a rollback handler (`Rollback sudoers on failure`) is triggered on validation failure.

#### Rationale:
    Attackers can run a malicious program using sudo which would fork a background process that remains even when the main program has finished executing. Enforcing `use_pty` mitigates this by ensuring sudo sessions are bound to a terminal, preventing detached background execution.

#### Remediation:
    Edit the file `/etc/sudoers` with `visudo` or a file in `/etc/sudoers.d/` with `visudo -f <PATH TO FILE>` and add the line: `Defaults use_pty`. Remove any occurrence of `!use_pty`. Note: Files in `/etc/sudoers.d/` are parsed in lexical order; avoid filenames with `.` or ending in `~`.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify `/etc/sudoers`, `/etc/sudoers.d/`, and run `visudo -c`)  
    - OS: Linux distributions with `sudo` installed (tested on Red Hat/CentOS, Debian/Ubuntu families)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.lineinfile`, `ansible.builtin.copy`, `ansible.builtin.find`, `ansible.builtin.command`, `ansible.builtin.fail`  
    - `visudo` must be available on the target host  

#### Variables
| Variable | Default | Description | Source |
|--|--|--|--|
| `sudo_pty_enabled` | `true` | Controls whether to enforce `use_pty` by creating/modifying the sudoers.d file. When `false`, the role skips writing the enforcement file but still removes `!use_pty` from existing files. | `defaults` |
| `sudoers_d_dir` | `/etc/sudoers.d` | Path to the sudoers drop-in directory. | `defaults` |
| `sudoers_d_file` | `/etc/sudoers.d/99-pty-enforcement` | Full path to the sudoers.d file used to enforce `use_pty`. | `defaults` |
| `sudoers_main_file` | `/etc/sudoers` | Internal path to the main sudoers file. | `vars` |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided in input; assumed absent unless referenced in tasks — tasks reference `notify: Validate sudoers configuration` and `notify: Rollback sudoers on failure`, but no handler definitions are included in input. Thus: handlers exist implicitly but are not specified here.)*  
    Dependencies on other roles: none  

#### Compliance mapping
    {'cmmc': ['AC.L2-3.1.5', 'AC.L2-3.1.6', 'AC.L2-3.1.7', 'SC.L2-3.13.3'], 'fedramp': ['AC-6'], 'gdpr': ['32'], 'hipaa': ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)'], 'iso_27001': ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2'], 'nis2': ['21.2.i', '21.2.k'], 'nist_800_171': ['3.1.5', '3.1.6', '3.1.7', '3.13.3'], 'nist_800_53': ['AC-6'], 'pci_dss': ['7.1'], 'tsc': ['CC6.1', 'CC6.3', 'CC6.2', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']}

#### Mitre
    {'tactic': ['TA0006', 'TA0003'], 'technique': ['T1078', 'T1098', 'T1110', 'T1136', 'T1556'], 'subtechnique': ['T1556.001', 'T1550.001', 'T1550.002']}

#### Conditions
    any

#### Rules
    ['f:/etc/sudoers -> r:^\\s*\\t*Defaults\\s*\\t*use_pty', 'd:/etc/sudoers.d -> r:.* -> r:^\\s*\\t*Defaults\\s*\\t*use_pty']

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - sudo_pty
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
