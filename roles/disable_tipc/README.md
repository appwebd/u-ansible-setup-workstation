#### Role name:
    disable_tipc

#### Wazuh ID:
    35605

#### Title:
    Ensure tipc kernel module is not available.

#### Description:
    The Transparent Inter-Process Communication (TIPC) protocol is designed to provide communication between cluster nodes.

#### Rationale:
    IF - the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.

#### Remediation:
    Run the following script to unload and disable the tipc module: - IF - the tipc kernel module is available in ANY installed kernel: - Create a file ending in .conf with install tipc /bin/false in the /etc/modprobe.d/ directory - Create a file ending in .conf with blacklist tipc in the /etc/modprobe.d/ directory - Run modprobe -r tipc 2>/dev/null; rmmod tipc 2>/dev/null to remove tipc from the kernel - IF - the tipc kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary #!/usr/bin/env.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: inferred from `tasks/main.yml` (e.g., Debian/Ubuntu)
    - Required Ansible collections/modules: ansible.builtin.assert, ansible.builtin.file, ansible.builtin.template, ansible.builtin.modprobe, ansible.builtin.shell, ansible.builtin.command, ansible.builtin.debug

#### Variables

### defaults/main.yml

| Variable                | Default                   | Description                                                  |
|-------------------------|---------------------------|--------------------------------------------------------------|
| tipc_modprobe_conf_path | /etc/modprobe.d/tipc.conf | Path to the modprobe configuration file for TIPC module      |
| tipc_install_line       | install tipc /bin/false   | Line to be written in modprobe config to disable TIPC module |

### vars/main.yml

| Variable                                                              | Default | Description |
|-----------------------------------------------------------------------|---------|-------------|
| No variables defined.                                                 |         |             |

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
    all

#### Rules
    c:modprobe -n -v tipc -> r:^install /bin/false
    not c:lsmod -> r:tipc

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_tipc_module
```
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-08-28_17:20:04
