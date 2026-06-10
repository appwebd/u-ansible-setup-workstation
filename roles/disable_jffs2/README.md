#### Role name:
    disable_jffs2

#### Wazuh ID:
    35504

#### Title:
    Ensure jffs2 kernel module is not available.

#### Description:
    The jffs2 (journaling flash filesystem 2) filesystem type is a log-structured filesystem used in flash memory devices.

#### Rationale:
    Removing support for unneeded filesystem types reduces the local attack surface of the system. If this filesystem type is not needed, disable it.

#### Remediation:
    Run the following script to unload and disable the jffs2 module:  
    - IF - the jffs2 kernel module is available in ANY installed kernel:  
      - Create a file ending in .conf with `install jffs2 /bin/false` in the `/etc/modprobe.d/` directory  
      - Create a file ending in .conf with `blacklist jffs2` in the `/etc/modprobe.d/` directory  
      - Run `modprobe -r jffs2 2>/dev/null; rmmod jffs2 2>/dev/null` to remove jffs2 from the kernel  
    - IF - the jffs2 kernel module is not available on the system, or pre-compiled into the kernel, no remediation is necessary.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify system configuration files and manage kernel modules)  
    - OS: Debian/Ubuntu or RedHat/CentOS/Fedora (inferred from `tasks/main.yml` conditional logic)  
    - Required Ansible modules: `ansible.builtin.file`, `ansible.builtin.copy`, `ansible.builtin.command`, `ansible.builtin.fail`  
    - No external collections required (uses only `ansible.builtin`)

#### Variables

### defaults/main.yml

| Variable                   | Default                                                    | Description                                                                                                           |
|----------------------------|------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| `jffs2_modprobe_conf_dir`  | `/etc/modprobe.d`                                          | Path to the modprobe configuration directory where module blacklisting files are placed.                              |
| `jffs2_modprobe_conf_file` | `/etc/modprobe.d/jffs2.conf` (inferred from interpolation) | Full path to the modprobe configuration file used to disable the jffs2 module.                                        |
| `jffs2_modprobe_content`   | `install jffs2 /bin/false\nblacklist jffs2`                | Content written to the modprobe configuration file to prevent loading of the jffs2 module.                            |
| `jffs2_unload_if_loaded`   | `true`                                                     | Whether to attempt to unload the jffs2 module if it is currently loaded.                                               |    

### vars/main.yml

| Variable          | Default  | Description                           |
|-------------------|----------|---------------------------------------|
| jffs2_module_name | `jffs2`  | Name of the jffs2 module to disable.  |

#### Dependencies
    Handlers: `handlers/main.yml` — *not present*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - CMMC: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    - FedRAMP: CM-2, CM-3, CM-6, CM-7  
    - GDPR: 32  
    - HIPAA: 164.308(a)(1)  
    - ISO 27001: A.12.1.1, A.12.1.2, A.14.2.1  
    - NIS2: 21.2.e, 21.2.a  
    - NIST 800-171: 3.4.7, 3.4.8, 3.13.6  
    - NIST 800-53: CM-2, CM-3, CM-6, CM-7  
    - PCI DSS: 1.1, 1.2, 2.2, 6.4  
    - TSC: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

#### Mitre
    - Tactic: TA0005 (Defense Evasion)  
    - Technique: T1036 (Masquerading), T1564 (Hide Artifacts)

#### Conditions
    any

#### Rules
    - `c:modprobe -n -v jffs2 -> r:install /bin/false|install /bin/true|/bin/false`  
    - `c:lsmod | grep -w jffs2 -> r:0` (should not be loaded)  
    - `c:modprobe -r jffs2 -> r:0` (if loaded and removable)

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_jffs2
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
