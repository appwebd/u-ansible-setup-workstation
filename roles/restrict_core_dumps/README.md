## Role name: restrict_core_dumps
## Wazuh ID : 35771
## Title    : Ensure core dump generation is restricted.
    
## Description:
    This Ansible role disables or restricts core dump generation on the system to prevent potential leakage of sensitive information (e.g., memory contents, credentials). Core dumps may contain highly privileged process memory, including secrets. This role addresses security rule **35771** (Wazuh/CIS).

## Rationale:
    Core dumps can expose memory contents—including passwords, encryption keys, or internal application data—to any user with access to the core dump file. Disabling them reduces the attack surface.

## Remediation:
    Add the following to `/etc/security/limits.conf`:
    ```text
    * hard core 0
    * soft core 0
    ```
    Apply kernel parameters:
    ```bash
    # sysctl -w fs.suid_dumpable=0
    # sysctl -w kernel.core_pattern="|/bin/false"
    ```
    Disable systemd-coredump service:
    ```bash
    # systemctl mask systemd-coredump.socket
    # systemctl stop systemd-coredump.socket
    ```

## Requirements            
    - Ansible 2.16 or higher
    - Access to root on target host (become: true)

## Default Variables:
| Variable                                      | Default                                            | Description                                  |
|-----------------------------------------------|----------------------------------------------------|----------------------------------------------|
| `restrict_core_dumps_packages_debian`         | `["systemd-coredump", "gdb"]`                      | Packages to install on Debian/Ubuntu systems |
| `restrict_core_dumps_packages_rhel`           | `["systemd", "gdb"]`                               | Packages to install on RHEL-based systems    |
| `restrict_core_dumps_sysctl_file`             | `/etc/sysctl.d/99-restrict-coredump.conf`          | Path to sysctl configuration file            |
| `restrict_core_dumps_limits_conf`             | `/etc/security/limits.d/99-restrict-coredump.conf` | Path to limits configuration file            |
| `restrict_core_dumps_systemd_conf`            | `/etc/systemd/coredump.conf`                       | Path to systemd core dump configuration file |
| `restrict_core_dumps_systemd_limits_conf`     | `/etc/systemd/limits.conf`                         | Path to systemd limits file                  |
| `restrict_core_dumps_systemd_service_name`    | `systemd-coredump`                                 | Name of systemd service                      |
| `restrict_core_dumps_systemd_socket_name`     | `systemd-coredump.socket`                          | Name of systemd socket                       |
| `restrict_core_dumps_sysctl_fs_suid_dumpable` | `0`                                                | Value of `fs.suid_dumpable` sysctl parameter |
| `restrict_core_dumps_sysctl_reload_command`   | `sysctl -p`                                        | Command to reload sysctl settings            |
| `restrict_core_dumps_sysctl_reload`           | `true`                                             | Whether to reload sysctl settings            |

## Parameters
    N/A

## Dependencies
    None

## Example Playbook:
```yaml
- hosts: all
  become: true
  roles:
    - role: restrict_core_dumps
```

## License
    Apache 2.0

## Author
    Patricio Rojas Ortiz
