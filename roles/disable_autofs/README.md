#### Role name:
    disable_autofs

#### Wazuh ID:
    35561

#### Title:
    Ensure autofs services are not in use.

#### Description:
    autofs allows automatic mounting of devices, typically including CD/DVDs and USB drives.

#### Rationale:
    With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in the filesystem even if they lacked permissions to mount it themselves.

#### Remediation:
    Run the following commands to stop autofs.service and remove the autofs package:  
    `# systemctl stop autofs.service`  
    `# apt purge autofs`  
    - OR -  
    IF the autofs package is required as a dependency:  
    Run the following commands to stop and mask autofs.service:  
    `# systemctl stop autofs.service`  
    `# systemctl mask autofs.service`

#### Requirements
    - Ansible 2.16 or higher  
    - `become: yes` required (to modify system packages, services, or configuration files)  
    - OS: Debian/Ubuntu (inferred from use of `dpkg_status`, `apt`, and `/etc/modprobe.d/` path in tasks)  
    - Required Ansible collections/modules: `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.command`

#### Variables
| Variable                     | Default                                       | Description                                                                                          | Source              |
|------------------------------|-----------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------|
| `autofs_modprobe_conf_file`  | `/etc/modprobe.d/autofs.conf`                 | Path to the modprobe configuration file where the autofs kernel module will be blacklisted.          | `defaults/main.yml` |
| `autofs_modprobe_dir`        | `/etc/modprobe.d`                             | Directory path where modprobe configuration files reside.                                            | `vars/main.yml`     |
| `autofs_package_name`        | `autofs`                                      | Name of the autofs package to check, stop, and remove via APT.                                       | `defaults/main.yml` |
| `autofs_systemd_services`    | `[autofs.service]`                            | List of systemd service names to stop and mask.                                                      | `vars/main.yml`     |
| `modprobe_blacklist_content` | `install autofs /bin/false\nblacklist autofs` | Content to write to the modprobe configuration file to prevent loading of the autofs kernel module.  | `defaults/main.yml` |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided in input; not declared in tasks, so assumed absent)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: MP.L2-3.8.7  
    - FedRAMP: SI-3, SI-4, AU-12  
    - GDPR: 32  
    - HIPAA: 164.310(d)(1)  
    - ISO 27001: A.12.2.1, A.12.4.1  
    - NIS2: 21.2.f, 21.2.a  
    - NIST 800-171: 3.8.7  
    - NIST 800-53: SI-3, SI-4, AU-12  
    - PCI DSS: 5.1, 5.2, 5.3, 5.4, 10.2  
    - TSC: CC7.1, CC7.2, CC7.3, CC7.4, CC7.5, CC4.1, CC4.2

#### Mitre
    - Tactics: TA0002, TA0005  
    - Techniques: T1562, T1070, T1059, T1105  
    - Sub-techniques: T1562.001, T1562.002, T1070.004

#### Conditions
    any

#### Rules
    - `c:dpkg-query -s autofs -> r:package 'autofs' is not installed`  
    - `not c:systemctl show autofs.service -> r:^LoadState=loaded\|^ActiveState=active`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_autofs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
