#### Role name:
    disable_unsafe_filesystem_modules

#### Wazuh ID:
    35509

#### Title:
    Ensure unused filesystems kernel modules are not available.

#### Description:
    Filesystem kernel modules are pieces of code that can be dynamically loaded into the Linux kernel to extend its filesystem capabilities, or so-called base kernel, of an operating system. Filesystem kernel modules are typically used to add support for new hardware (as device drivers), or for adding system calls.

#### Rationale:
    While loadable filesystem kernel modules are a convenient method of modifying the running kernel, this can be abused by attackers on a compromised system to prevent detection of their processes or files, allowing them to maintain control over the system. Many rootkits make use of loadable filesystem kernel modules in this way. Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it. The following filesystem kernel modules have known CVE's and should be made unavailable if no dependencies exist:  
    - `afs` – CVE-2022-37402  
    - `ceph` – CVE-2022-0670  
    - `cifs` – CVE-2022-29869  
    - `exfat` – CVE-2022-29973  
    - `ext` – CVE-2022-1184  
    - `fat` – CVE-2022-22043  
    - `fscache` – CVE-2022-3630  
    - `fuse` – CVE-2023-0386  
    - `gfs2` – CVE-2023-3212  
    - `nfs_common` – CVE-2023-6660  
    - `nfsd` – CVE-2022-43945  
    - `smbfs_common` – CVE-2022-2585  

#### Remediation:
    - IF the module is available in the running kernel:  
      1. Unload the filesystem kernel module from the kernel  
      2. Create a file ending in `.conf` with `install <filesystem_kernel_module> /bin/false` in `/etc/modprobe.d/`  
      3. Create a file ending in `.conf` with `deny list <filesystem_kernel_module>` in `/etc/modprobe.d/`  
    WARNING: unloading, disabling or denylisting filesystem modules that are in use on the system may be FATAL. It is extremely important to thoroughly review the filesystems returned by the audit before following the remediation procedure.

#### Requirements
    - Ansible 2.16 or higher (inferred from modern module usage and syntax)
    - `become: yes` required (to modify `/etc/modprobe.d/`, unload kernel modules, and update initramfs)
    - OS: Linux; specifically tested for Debian-family (via handler condition on `ansible_facts.os_family == "Debian"`)
    - Required Ansible collections/modules:
      - `ansible.builtin.assert`
      - `ansible.builtin.file`
      - `ansible.builtin.command`
      - `ansible.builtin.copy`
      - `ansible.builtin.debug`

#### Variables

### defaults/main.yml

| Variable                                    | Default                                                                                                                                          | Description                                                              |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `disable_unsafe_filesystem_modules_enabled` | `true` (implicit boolean)                                                                                                                        | Controls whether the role is executed; set to `false` to skip execution. |
| `filesystem_modules_to_disable`             | List of 12 CVE-motivated modules (`afs`, `ceph`, `cifs`, `exfat`, `ext`, `fat`, `fscache`, `fuse`, `gfs2`, `nfs_common`, `nfsd`, `smbfs_common`) | Modules to disable by preventing load and unloading if active.           |
| `modprobe_conf_dir`                         | `/etc/modprobe.d`                                                                                                                                | Directory where modprobe configuration files are placed.                 |

### vars/main.yml

| Variable                             | Default                                    | Description                                                                             |
|--------------------------------------|--------------------------------------------|-----------------------------------------------------------------------------------------|
| `filesystem_modules_to_disable_list` | `{{ filesystem_modules_to_disable|list }}` | Internal variable ensuring the modules list is explicitly a list (idempotency).         |




#### Dependencies
    Handlers: `handlers/main.yml`  
    - `Update initramfs`: Triggers `/usr/sbin/update-initramfs -u` on Debian-family systems after config changes.  
    Dependencies on other roles: *none*

#### Compliance mapping
    - cis: 1.1.1.10
    - cis_csc_v7: 9.2
    - cis_csc_v8: 4.8
    - cmmc_v2.0: CM.L2-3.4.7,CM.L2-3.4.8,SC.L2-3.13.6
    - iso_27001-2013: A.13.1.3
    - pci_dss_v3.2.1: 1.1.6,1.2.1,2.2.2,2.2.5
    - pci_dss_v4.0: 1.2.5,2.2.4,6.4.1
    - soc_2: CC6.3,CC6.6

#### Mitre
    - **Tactic**: Defense Evasion  
      - **Technique**: T1542.003 – Component Software: Firmware  
        *(indirectly via initramfs update, though primary focus is kernel module loading prevention)*  
    - **Tactic**: Impact  
      - **Technique**: T1485 – Data Destruction  
        *(preventing malicious modules from loading helps avoid system compromise/impact)*

#### Conditions
    - Role executes only if `disable_unsafe_filesystem_modules_enabled` evaluates to `true`.
    - Module unloading attempts are non-fatal (`failed_when: false`) — safe for modules not currently loaded.
    - Initramfs update runs only on Debian-family systems (`ansible_facts.os_family == "Debian"`).
    - Verification step (`lsmod` check) is skipped if kernel facts unavailable.

#### Rules
    - `install afs /bin/false`
    - `blacklist afs`
    - `install ceph /bin/false`
    - `blacklist ceph`
    - `install cifs /bin/false`
    - `blacklist cifs`
    - `install exfat /bin/false`
    - `blacklist exfat`
    - `install ext /bin/false`
    - `blacklist ext`
    - `install fat /bin/false`
    - `blacklist fat`
    - `install fscache /bin/false`
    - `blacklist fscache`
    - `install fuse /bin/false`
    - `blacklist fuse`
    - `install gfs2 /bin/false`
    - `blacklist gfs2`
    - `install nfs_common /bin/false`
    - `blacklist nfs_common`
    - `install nfsd /bin/false`
    - `blacklist nfsd`
    - `install smbfs_common /bin/false`
    - `blacklist smbfs_common`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_unsafe_filesystem_modules
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz