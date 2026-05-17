#### Role name:
    restrict_crontab_access

#### Wazuh ID: 
    35600

#### Title: 
    Ensure crontab is restricted to authorized users.

#### Description:
    This Ansible role ensures that access to the `crontab` command is restricted to authorized users by configuring `/etc/cron.allow` and/or `/etc/cron.deny` with appropriate ownership and permissions. It enforces the Wazuh/CIS security control **35600**.

#### Rationale:
    On many systems, only the system administrator is authorized to schedule cron jobs. Using the cron.allow file to control who can run cron jobs enforces this policy. It is easier to manage an allow list than a deny list. In a deny list, you could potentially add a user ID to the system and forget to add it to the deny files.

#### Remediation:
    - IF cron is installed on the system:  
      Run the following script to:  
      - Create `/etc/cron.allow` if it doesn't exist  
      - Change owner to user `root`  
      - Change group owner to group `root` or `crontab` (if the group exists)  
      - Change mode to `640` or more restrictive  
      ```bash
      #!/usr/bin/env bash
      {
        [ ! -e "/etc/cron.deny" ] && touch /etc/cron.allow
        chmod u-x,g-wx,o-rwx /etc/cron.allow
        if grep -Pq -- '^\h*crontab\:' /etc/group; then
          chown root:crontab /etc/cron.allow
        else
          chown root:root /etc/cron.allow
        fi
      }
      ```
    - IF `/etc/cron.deny` exists, run the following script to:  
      - Change owner to user `root`  
      - Change group owner to group `root` or `crontab` (if the group exists)  
      - Change mode to `640` or more restrictive  
      ```bash
      #!/usr/bin/env bash
      {
        if [ -e "/etc/cron.deny" ]; then
          chmod u-x,g-wx,o-rwx /etc/cron.deny
          if grep -Pq -- '^\h*crontab\:' /etc/group; then
            chown root:crontab /etc/cron.deny
          else
            chown root:root /etc/cron.deny
          fi
        fi
      }
      ```

#### Requirements
    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - Linux systems with `cron` installed (e.g., RHEL, CentOS, Ubuntu, Debian)  
    - `stat` command available (standard on most Linux systems)  
    - `grep` with PCRE support (`-P` flag) for group matching (available on most modern systems; fallback provided if not)

#### Variables

| Variable                    | Default           | Description                                                          | File              |
|-----------------------------|-------------------|----------------------------------------------------------------------|-------------------|
| `cron_allow_file`           | `/etc/cron.allow` | Path to the cron allow file                                          | vars/main.yml     |
| `cron_deny_file`            | `/etc/cron.deny`  | Path to the cron deny file                                           | vars/main.yml     |
| `cron_file_mode`            | `0640`            | File permissions for cron.allow/cron.deny                            | vars/main.yml     |
| `cron_group_name`           | `root`            | Preferred group owner (falls back to `root` if group does not exist) | vars/main.yml     |
| `restrict_crontab_enabled`  | `true`            | Enable or disable crontab                                            | defaults/main.yml | 

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']  
    - 'fedramp': ['AC-5', 'AC-6']  
    - 'gdpr': ['32', '25', '30']  
    - 'hipaa': ['164.312(a)(1)']  
    - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']  
    - 'nis2': ['21.2.g', '21.2.j', '21.2.i']  
    - 'nist_800_171': ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '8.1.2']  
    - 'nist_800_53': ['AC-3', 'AC-5', 'AC-6', 'AC-17', 'AC-22']  
    - 'pci_dss': ['7.1', '7.2', '7.3', '7.4']  
    - 'tsc': ['CC6.1', 'CC6.2', 'CC6.3', 'CC6.6', 'CC6.7', 'CC7.2']

#### Mitre
    - 'tactic': ['TA0001', 'TA0003', 'TA0005']  
    - 'technique': ['T1053.003', 'T1053.005', 'T1053.002', 'T1543.003', 'T1543.004']

#### Conditions
    - `ansible_os_family in ['RedHat', 'Debian']`  
    - `cron_package is defined and cron_package is installed`  
    - `restrict_crontab_enabled | default(true)`

#### Rules
    - "c:stat -c '%U:%G %a' /etc/cron.allow -> r:file '/etc/cron.allow' owner is 'root', group is 'root' or 'crontab', mode is '0640' or more restrictive"  
    - "c:stat -c '%U:%G %a' /etc/cron.deny -> r:file '/etc/cron.deny' owner is 'root', group is 'root' or 'crontab', mode is '0640' or more restrictive (if exists)"  
    - "c:grep -Pq '^\h*crontab\:' /etc/group -> r:group 'crontab' exists (used for group assignment fallback logic)"

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - restrict_crontab_access
```

Optionally override defaults:

```yaml
- hosts: servers
  become: true
  vars:
    restrict_crontab_mode: "0600"
    restrict_crontab_group: "wheel"
  roles:
    - restrict_crontab_access
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
