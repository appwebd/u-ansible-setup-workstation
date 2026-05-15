#### Role name:
    configure_cron_d_permissions

#### Wazuh ID:
    35599

#### Title:
    Ensure permissions on /etc/cron.d are configured.

#### Description:
    The /etc/cron.d directory contains system cron jobs that need to run in a similar manner to the hourly, daily weekly and monthly jobs from /etc/crontab, but require more granular control as to when they run. The files in this directory cannot be manipulated by the crontab command but are instead edited by system administrators using a text editor. The commands below restrict read/write and search access to user and group root, preventing regular users from accessing this directory.

#### Rationale:
    Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls.

#### Remediation:
    - IF - cron is installed on the system: Run the following commands to set ownership and permissions on the /etc/cron.d directory:  
      `# chown root:root /etc/cron.d/`  
      `# chmod og-rwx /etc/cron.d/`

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify directory ownership and permissions on system paths)  
    - OS: Linux (inferred from `/etc/cron.d` path and use of `stat` module for Unix permission checks)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.stat`, `ansible.builtin.fail`

#### Variables

| Variable           | Default       | Description                                                        | Source              |
|--------------------|---------------|--------------------------------------------------------------------|---------------------|
| `cron_d_directory` | `/etc/cron.d` | Path to the cron directory whose permissions are to be configured. | `defaults/main.yml` |
| `cron_d_owner`     | `root`        | Owner of the directory                                             | `vars/main.yml`     |
| `cron_d_group`     | `root`        | Group of the directory                                             | `vars/main.yml`     |
| `cron_d_mode`      | `0700`        | Permission Mode of the directory                                   | `vars/main.yml`     |

#### Dependencies
    Handlers: `handlers/main.yml` *(not present)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: AC.L2-3.1.1, AC.L2-3.1.2, AC.L2-3.1.5, AC.L2-3.1.3, MP.L2-3.8.2  
    - FedRAMP: AC-5, AC-6  
    - GDPR: Articles 32, 25, 30  
    - HIPAA: 164.312(a)(1)  
    - ISO 27001: A.8.2.3, A.8.3.1, A.8.3.2, A.10.1.1, A.13.2.1, A.18.1.4  
    - NIS2: 21.2.g, 21.2.j, 21.2.i  
    - NIST 800-171: 3.1.1, 3.1.2, 3.1.5, 3.1.3, 3.8.2  
    - NIST 800-53: AC-5, AC-6  
    - PCI DSS: 7.1, 1.3  
    - TSC: CC5.2, CC6.1, C1.1, C1.2, CC6.2, CC6.3, CC6.4, CC6.5, CC6.6, CC6.7, CC6.8, P1.1, P2.1, P3.1, P4.1, P5.1, P6.1, P7.1, P8.1

#### Mitre
    - Tactics: TA0009 (Collection), TA0010 (Exfiltration)  
    - Techniques: T1005 (Data from Local System), T1025 (Data from Removable Media), T1041 (Exfiltration Over C2 Channel), T1567 (Exfiltration Over Web Service), T1573 (Encrypted Channel)  
    - Subtechniques: T1048.003 (Exfiltration Over Unencrypted Non-C2 Protocol), T1552.001 (Unsecured Credentials: GPG Keys)

#### Conditions
    all

#### Rules
    `c:stat /etc/cron.d/ -> r:Access:\s*\t*\(0700/drwx------\)\s*\t*Uid:\s*\t*\(\s*\t*0/\s*\t*root\)\s*\t*Gid:\s*\t*\(\s*\t*0/\s*\t*root\)`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - configure_cron_d_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
