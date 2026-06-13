#### Role name:
    configure_chrony_user

#### Wazuh ID:
    35591

#### Title:
    Ensure chrony is running as user _chrony.

#### Description:
    The chrony package is installed with a dedicated user account _chrony. This account is granted the access required by the chronyd service.

#### Rationale:
    The chronyd service should run with only the required privlidges.

#### Remediation:
    Add or edit the user line to /etc/chrony/chrony.conf or a file ending in .conf in /etc/chrony/conf.d/: user _chrony  
    - OR -  
    If another time synchronization service is in use on the system, run the following command to remove chrony from the system:  
    `# apt purge chrony`  
    `# apt autoremove chrony`

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to install packages, modify system users/groups, and manage services)  
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` and package name `chrony`)  
    - Required Ansible modules: `ansible.builtin.package_facts`, `ansible.builtin.apt`, `ansible.builtin.user`, `ansible.builtin.group`, `ansible.builtin.file`, `ansible.builtin.lineinfile`, `ansible.builtin.systemd`, `ansible.builtin.stat`, `ansible.builtin.shell`, `ansible.builtin.debug`, `ansible.builtin.fail`  
    - No external collections required (all modules are `ansible.builtin`)  
    - `restrict_timesyncd` variable may be set to `true` to enforce disabling of `systemd-timesyncd`, but defaults to `false`

#### Variables

### defaults/main.yml

| Variable                | Default                   | Description                                               |
|-------------------------|---------------------------|-----------------------------------------------------------|
| `chrony_conf_d_dir`     | `/etc/chrony/conf.d`      | Directory for additional chrony configuration snippets.   |
| `chrony_conf_file`      | `/etc/chrony/chrony.conf` | Main chrony configuration file path.                      |
| `chrony_config_dir`     | `/etc/chrony`             | Main configuration directory for chrony.                  |
| `chrony_package_name`   | `chrony`                  | Package name to install via APT.                          |
| `chronyd_service_name`  | `chronyd`                 | Systemd service name for chrony.                          |
| `chrony_user`           | `_chrony`                 | System user account under which the chronyd service runs. |
| `restrict_timesyncd`    | `true`                    | to enforce disabling of `systemd-timesyncd`               |

### vars/main.yml

| Variable                  | Default             | Description                                                    |
|---------------------------|---------------------|----------------------------------------------------------------|
| `chrony_user_home`        | `/var/lib/chrony`   | Home directory for the chrony user.                            |
| `chrony_user_shell`       | `/usr/sbin/nologin` | Login shell for the chrony user (disabled shell for security). |
| `chrony_user_group`       | `_chrony`           | System group for the chrony user.                              |
| `chrony_user_system`      | `yes`               | System user account for chrony.                                |

#### Dependencies
    Handlers: `handlers/main.yml` — *not present* (no handlers defined in input; role relies on `changed_when` and `notify` in tasks, but no handler task is declared — this may cause a runtime warning if `notify` is triggered).  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: AU.L2-3.3.7  
    - FedRAMP: AU-7  
    - GDPR: Articles 32, 33  
    - HIPAA: 164.312(b), 164.308(a)(6)  
    - ISO 27001: A.12.4.1, A.12.4.2, A.12.4.3, A.16.1.2  
    - NIS2: 21.2.a, 23, 21.2.b  
    - NIST 800-171: 3.3.7  
    - NIST 800-53: AU-7  
    - PCI DSS: 10.4, 10.6  
    - TSC: CC4.1, CC5.2, CC7.1, CC7.2, CC7.3, CC7.4, CC7.5, CC4.2

#### Mitre
    - Tactics: TA0005 (Defense Evasion), TA0006 (Credential Access), TA0007 (Discovery)  
    - Techniques: T1562 (Impair Defenses), T1070 (Indicator Removal), T1059 (Command and Scripting Interpreter), T1040 (Network Sniffing)  
    - Sub-techniques: T1562.002 (Disable or Modify Tools), T1070.001 (Clear Linux or Mac System Logs), T1059.001 (Shell), T1040.001 (Network Traffic Capture)

#### Conditions
    all

#### Rules
    - `c:ps -ef -> r:_chrony.+chronyd`  
    - `not c:systemctl show systemd-timesyncd.service -> r:^LoadState=loaded\|^ActiveState=active`

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - configure_chrony_user
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
