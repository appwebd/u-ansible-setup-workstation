#### Role Name:
    configure_bootloader_access

#### Wazuh ID:
    35541

#### Title:
    Ensure access to bootloader config is configured

#### Description:
    The GRUB configuration file contains critical boot settings and passwords for unlocking boot options. This role enforces strict file permissions (0600) and ownership (root:root) on the GRUB configuration file to prevent unauthorized users from reading or modifying boot parameters. Modifying boot parameters could allow privilege escalation, kernel boot option tampering, or bypassing of security controls.

    Additionally, this role secures the `/boot/grub` directory with 0700 permissions to prevent unauthorized enumeration of boot configuration files.

#### Why It's Not Applicable to Containers
    Containers typically do not have a traditional bootloader (like GRUB) or a persistent `/boot` partition. The `/boot` directory in containers is often ephemeral or absent. This role gracefully handles this by detecting GRUB availability and providing informative messages when the bootloader is not available.

#### Requirements

    - Ansible 2.16 or higher
    - Root/sudo privileges (become: true)
    - Ubuntu v24.04 family (BIOS or UEFI)
    - GRUB bootloader installed

#### Variables

| Variable                   | Default                      | Description                                      |
|----------------------------|------------------------------|--------------------------------------------------|
| `grub_binary_path`         | `/usr/sbin/grub-mkconfig`    | Path to the GRUB configuration binary            |
| `boot_grub_cfg_path`       | `/boot/grub/grub.cfg`        | Path to the GRUB config file (BIOS systems)      |
| `boot_grub_efi_cfg_path`   | `/boot/efi/grub.cfg`         | Path to the GRUB config file (UEFI systems)      |
| `boot_grub_dir_path`       | `/boot/grub`                 | Path to the /boot/grub directory                 |

#### Dependencies
    No dependencies

#### Compliance Mapping

| Framework                  | Mapping                                                    |
|----------------------------|------------------------------------------------------------|
| CIS Ubuntu 24.04           | 1.4.2                                                      |
| CIS CSC v7                 | 14.6                                                       |
| CIS CSC v8                 | 3.3                                                        |
| CMMC v2.0                  | AC.L1-3.1.1, AC.L1-3.1.2, AC.L2-3.1.3, AC.L2-3.1.5, MP.L2-3.8.2 |
| HIPAA                      | 164.308(a)(3)(i), 164.308(a)(3)(ii)(A), 164.312(a)(1)     |
| ISO 27001-2013             | A.9.1.1                                                    |
| MITRE (Tactics)            | TA0005 (Defense Evasion), TA0007 (Discovery)              |
| MITRE (Techniques)         | T1542 (Bootloader)                                         |
| NIST SP 800-53             | AC-5 (Deny All), AC-6 (Least Privilege)                   |
| PCI DSS v3.2.1             | 7.1, 7.1.1, 7.1.2, 7.1.3                                  |
| PCI DSS v4.0               | 1.3.1, 7.1                                                 |
| SOC 2                      | CC5.2, CC6.1                                               |

#### Remediation

Run the following commands manually to set permissions:

```bash
# Set ownership
chown root:root /boot/grub/grub.cfg

# Set permissions (owner read/write only, remove execute, group/other no access)
chmod u-x,go-rwx /boot/grub/grub.cfg
```

#### Usage

**Basic usage:**

```yaml
- hosts: servers
  become: true
  roles:
    - configure_bootloader_access
```

**Custom paths:**

```yaml
- hosts: servers
  become: true
  vars:
    grub_binary_path: "/usr/sbin/grub-mkconfig"
    boot_grub_cfg_path: "/boot/grub/grub.cfg"
    boot_grub_efi_cfg_path: "/boot/efi/grub.cfg"
  roles:
    - configure_bootloader_access
```

**Conditional execution (skip on containers):**

```yaml
- hosts: servers
  become: true
  roles:
    - configure_bootloader_access
```

#### Troubleshooting

**GRUB config file not found:**
```
"Bootloader (GRUB) is not configured on this system."
```
This is expected on UEFI systems where GRUB may be in `/boot/efi/`, in containers, or in WSL environments. The role will skip gracefully.

**UEFI systems:**
On UEFI systems, verify the GRUB config is at `/boot/efi/grub.cfg`. The role automatically detects this path.

**Permissions still not 0600:**
Ensure no other roles or scripts are overriding the permissions after this role runs. Verify with:
```bash
stat -c "%a %U:%G" /boot/grub/grub.cfg
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz