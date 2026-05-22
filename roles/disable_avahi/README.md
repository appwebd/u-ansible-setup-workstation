#### Role name:
    `disable_avahi`

#### Wazuh ID:
    `35562`

#### Title:
    Ensure avahi daemon services are not in use.

#### Description:
    Avahi is a free zeroconf implementation, including a system for multicast DNS/DNS-SD service discovery. Avahi allows programs to publish and discover services and hosts running on a local network with no specific configuration. For example, a user can plug a computer into a network and Avahi automatically finds printers to print to, files to look at and people to talk to, as well as network services running on the machine.

#### Rationale:
    Automatic discovery of network services is not normally required for system functionality. It is recommended to remove this package to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop avahi-daemon.socket and avahi-daemon.service and remove the avahi-daemon package  
    ```bash
    # systemctl stop avahi-daemon.socket avahi-daemon.service
    # apt purge avahi-daemon
    ```  
    OR IF the avahi-daemon package is required as a dependency:  
    Run the following commands to stop and mask the avahi-daemon.socket and avahi-daemon.service  
    ```bash
    # systemctl stop avahi-daemon.socket avahi-daemon.service
    # systemctl mask avahi-daemon.socket avahi-daemon.service
    ```

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to manage systemd services, modify `/etc/modprobe.d/`, and purge packages)  
    - OS: Debian/Ubuntu (inferred from use of `dpkg_status` and `apt` modules in `tasks/main.yml`)  
    - Required Ansible collections/modules: `ansible.builtin.dpkg_status`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.copy`  

#### Variables
| Variable                           | Default                                           | Description                                                                                | Source              |
|------------------------------------|---------------------------------------------------|--------------------------------------------------------------------------------------------|---------------------|
| `avahi_modprobe_blacklist_content` | `install avahi /bin/false\nblacklist avahi`       | Content to write to the modprobe blacklist file to prevent avahi kernel module loading.    | `defaults/main.yml` |
| `avahi_modprobe_conf_file`         | `/etc/modprobe.d/avahi.conf`                      | Path to the modprobe configuration file where the avahi kernel module will be blacklisted. | `defaults/main.yml` |
| `avahi_package_name`               | `avahi-daemon`                                    | Name of the APT package to purge if installed.                                             | `defaults/main.yml` |
| `avahi_service_names`              | `['avahi-daemon.service', 'avahi-daemon.socket']` | List of systemd service/socket unit names to stop and mask.                                | `defaults/main.yml` |
| `avahi_services_to_mask`           | `{{ avahi_service_names }}`                       | Internal variable used to iterate over services to stop and mask.                          | `vars/main.yml`     |
| `avahi_services_to_stop`           | `{{ avahi_service_names }}`                       | Internal variable used to iterate over services to verify status (check mode).             | `vars/main.yml`     |

#### Dependencies
    Handlers: `handlers/main.yml` is referenced in `tasks/main.yml` via `notify: "Purge unused dependencies"` and `notify: "Update initramfs"`, but its content is not provided — assumed to exist and contain handlers for `apt` cleanup and `update-initramfs`.  
    Dependencies on other roles: *none*  

#### Compliance mapping
    - CMMC: `CM.L2-3.4.7`, `CM.L2-3.4.8`, `SC.L2-3.13.6`  
    - FedRAMP: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - GDPR: `32`  
    - HIPAA: `164.308(a)(1)`  
    - ISO 27001: `A.12.1.1`, `A.12.1.2`, `A.14.2.1`  
    - NIS2: `21.2.e`, `21.2.a`  
    - NIST 800-171: `3.4.7`, `3.4.8`, `3.13.6`  
    - NIST 800-53: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - PCI DSS: `1.1`, `1.2`, `2.2`, `6.4`  
    - TSC: `CC6.3`, `CC6.6`, `CC8.1`, `CC5.1`, `CC5.2`, `CC5.3`  

#### Mitre
    - Tactic: `TA0005` (Defense Evasion)  
    - Technique: `T1036` (Masquerading), `T1564` (Hide Artifacts)  

#### Conditions
    `any`

#### Rules
    - `c:dpkg-query -s avahi-daemon -> r:package 'avahi-daemon' is not installed`  
    - `not c:systemctl show avahi-daemon.socket avahi-daemon.service -> r:^LoadState=loaded\|^ActiveState=active`  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_avahi
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
