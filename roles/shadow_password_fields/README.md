#### Role name:
    shadow_password_fields

#### Wazuh ID:
    35772

#### Title:
    Ensure /etc/shadow password fields are not empty.

#### Description:
    An account with an empty password field means that anybody may log in as that user without providing a password.

#### Rationale:
    All accounts must have passwords or be locked to prevent the account from being used by an unauthorized user.

#### Remediation:
    If any accounts in the /etc/shadow file do not have a password, run the following command to lock the account until it can be determined why it does not have a password: # passwd -l <username> Also, check to see if the account is logged in and investigate what it is being used for to determine if it needs to be forced off.

#### Requirements

    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux-based systems with `/etc/shadow` file (e.g., RHEL, CentOS, Debian, Ubuntu, SUSE)
    - `passwd` utility installed (typically included in `shadow-utils` or `passwd` package)

#### Variables

| Variable                               | Default       | Description                                              | file              |
|----------------------------------------|---------------|----------------------------------------------------------|-------------------|
| `shadow_exclude_users`                 | `root`        | User Exclude to lock accounts with empty password fields | defaults/main.yml |
| `shadow_file_path`                     | `/etc/shadow` | Path to the shadow file                                  | vars/main.yml     |

#### Dependencies
    No dependencies

#### Compliance mapping
    - 'cmmc': ['IA.L2-3.5.7']
    - 'fedramp': ['AC-2', 'IA-2', 'IA-5', 'AC-11', 'AC-7', 'AU-6']
    - 'gdpr': ['32']
    - 'hipaa': ['164.308(a)(4)', '164.312(a)(1)', '164.312(d)', '164.312(b)']
    - 'iso_27001': ['A.9.2.1', 'A.9.2.2', 'A.9.2.5', 'A.9.2.6', 'A.9.2.4', 'A.9.4.2']
    - 'nis2': ['21.2.i', '21.2.k']
    - 'nist_800_171': ['3.5.7']
    - 'nist_800_53': ['AC-2', 'IA-2', 'IA-5', 'AC-11', 'AC-7', 'AU-6']
    - 'pci_dss': ['2.2', '8.3', '8.1', '8.2']
    - 'tsc': ['CC6.1', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5']

#### Mitre
    - 'tactic': ['TA0006', 'TA0003']
    - 'technique': ['T1078', 'T1098', 'T1110', 'T1136', 'T1556']
    - 'subtechnique': ['T1556.001', 'T1550.001', 'T1550.002']

#### Conditions
all

#### Rules
    - 'not f:/etc/shadow -> !r:^# && r:^[\\w@-]+::'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - shadow_password_fields
```
#### VERY IMPORTANT NOTES

| Action                 | Affected by `passwd -l` ?  | Note                                 |
|:-----------------------|:---------------------------|:-------------------------------------|
| **Password login**     | ❌ Blocked                  | Cannot log in.                       |
| **SSH key login**      | ✅ Allowed                  | Bypasses the password.               |
| **Existing session**   | ✅ Remains active           | The user is not logged out.          |
| **Cron jobs**          | ✅ Keep running             | The system executes them internally. |
| **Processes/Services** | ✅ Keep running             | The PID remains active.              |

### What to do if you want to COMPLETELY block the user?
If your goal is to ensure the user cannot do anything at all or enter the system in any way, consider these additional options:

1.  **Change the shell to nologin:**
    `sudo usermod -s /usr/sbin/nologin <user>`
    *(This prevents the user from obtaining a shell, even if they log in via SSH)*.
  
2. **Expire the account:**
    `sudo chage -E 0 <user>`
    *(This marks the account as expired)*.
  
3. **Kill their current processes:**
    `sudo killall -u <user>`
    *(To close their active sessions immediately)*.
  
4. **Lock the account:**
    `sudo passwd -l <user>`
    *(This locks the account and prevents the user from logging in)*.
 
5. or **Remove the user:**
    `sudo userdel <user>`
    *(This completely removes the user account)*.
 
#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
