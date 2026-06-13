#### Role name:
    disable_nfs

#### Wazuh ID:
    35569

#### Title:
    Ensure network file system services are not in use.

#### Description:
    The Network File System (NFS) is one of the first and most widely distributed file systems in the UNIX environment. It provides the ability for systems to mount file systems of other servers through the network.

#### Rationale:
    If the system does not export NFS shares, it is recommended that the nfs-kernel-server package be removed to reduce the remote attack surface.

#### Remediation:
    Run the following command to stop nfs-server.service and remove nfs-kernel- server package: # systemctl stop nfs-server.service # apt purge nfs-kernel-server - OR - - IF - the nfs-kernel-server package is required as a dependency: Run the following commands to stop and mask the nfs-server.service: # systemctl stop nfs-server.service # systemctl mask nfs-server.service.

#### Requirements
    - Ansible 2.16 or higher (inferred from modern module usage such as `ansible.builtin.systemd` with `masked` parameter)
    - `become: yes` required (to modify system packages, services, and configuration files via `apt`, `systemd`, and file operations)
    - OS: Debian/Ubuntu (inferred from use of `dpkg-query`, `apt`, and `nfs-kernel-server` package name in tasks)
    - Required Ansible collections/modules: `ansible.builtin.shell`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.file`, `ansible.builtin.copy`

#### Variables

### defaults/main.yml

| Variable                    | Default                                                                      | Description                                                                                                       |
|-----------------------------|------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| nfs_service_name            | `nfs-server.service`                                                         | Name of the NFS server systemd service to stop and mask                                                           |
| nfs_package_name            | `nfs-kernel-server`                                                          | Name of the NFS kernel server package to remove (if enabled)                                                      |
| nfs_modprobe_conf_dir       | `/etc/modprobe.d`                                                            | Directory path for modprobe configuration files                                                                   |
| nfs_modprobe_blacklist_file | `/etc/modprobe.d/blacklist-nfs.conf`                                         | Path to the modprobe blacklist file for NFS modules (derived from `nfs_modprobe_conf_dir`)                        |
| nfs_blacklist_content       | Multi-line string with `install sunrpc /bin/false`, `blacklist sunrpc`, etc. | Content to write in the modprobe blacklist file to prevent loading of NFS-related kernel modules                  |
| remove_nfs_package          | `true`                                                                       | Boolean flag controlling whether to purge the `nfs-kernel-server` package (if installed) or only mask the service |

### vars/main.yml

| Variable                      | Default                      | Description                                                                                                                        |
|-------------------------------|------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| nfs_packages_to_check         | `["{{ nfs_package_name }}"]` | List of packages to check for presence; used internally in compliance checks (not directly referenced in tasks)                    |
| nfs_services_to_stop_and_mask | `["{{ nfs_service_name }}"]` | List of systemd services to stop and mask; used internally (not directly referenced in tasks)                                      |
| nfs_modprobe_modules          | `[sunrpc, nfsv3, nfsv4]`     | List of NFS-related kernel modules to blacklist; declared but not used in tasks (only `nfs_blacklist_content` is written directly) |

#### Dependencies
    Handlers: `handlers/main.yml`
    Dependencies on other roles: none

#### Compliance mapping
    cmmc: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    fedramp: CM-2, CM-3, CM-6, CM-7  
    gdpr: 32  
    hipaa: 164.308(a)(1)  
    iso_27001: A.12.1.1, A.12.1.2, A.14.2.1  
    nis2: 21.2.e, 21.2.a  
    nist_800_171: 3.4.7, 3.4.8, 3.13.6  
    nist_800_53: CM-2, CM-3, CM-6, CM-7  
    pci_dss: 1.1, 1.2, 2.2, 6.4  
    tsc: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3  

#### Mitre
    tactic: TA0005  
    technique: T1036, T1564  

#### Conditions
    any  

#### Rules
    c:dpkg-query -s nfs-kernel-server -> r:package 'nfs-kernel-server' is not installed  
    not c:systemctl show nfs-server.service -> r:^LoadState=loaded\|^ActiveState=active  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_nfs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz