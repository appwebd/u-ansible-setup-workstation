#### Role name: 
    set_grub_password
#### Wazuh ID : 
    35540
#### Title    : 
    Ensure bootloader password is set.

#### Description:
    Setting the boot loader password will require that anyone rebooting the system must enter a password before being able to set command line boot parameters.

#### Rationale:
    Requiring a boot password upon execution of the boot loader will prevent an unauthorized user from entering boot parameters or changing the boot partition. This prevents users from weakening security (e.g. turning off AppArmor at boot time).

#### Remediation:

    Create an encrypted password with grub-mkpasswd-pbkdf2:
  
        ```bash
        # grub-mkpasswd-pbkdf2 --iteration-count=600000 --salt=64 
            Enter password: <password> 
            Reenter password: <password>
        ```             
  
    PBKDF2 hash of your password is <encrypted-password>

    Add the following into a custom /etc/grub.d configuration file: 
  
    ```bash
            cat <<EOF 
                exec tail -n +2 $0 set superusers="<username>" password_pbkdf2 <username> <encrypted-password> 
            EOF
    ```         
      The superuser/user information and password should not be contained in the /etc/grub.d/00_header file as this file could be overwritten in a package update. 
      If there is a requirement to be able to boot/reboot without entering the password, edit /etc/grub.d/10_linux and add --unrestricted to the line CLASS= 
  
    Example:
        ```bash
            CLASS="--class gnu-linux --class gnu --class os --unrestricted" 
            
            Run the following command to update the grub2 configuration: 
            # update-grub.
        ```

#### Requirements

    - Ansible 2.16 or higher  
    - Root/sudo privileges (`become: true`)  
    - `grub2` package installed  
    - Physical or console access required to test (security-critical: changes must be verified manually)  
    - `grub-mkpasswd-pbkdf2` available (part of `grub2-common` or `grub2-tools` depending on distro)

#### Variables

| Variable              | Default                  | Description                                                                       |
|-----------------------|--------------------------|-----------------------------------------------------------------------------------|
| `grub_superuser`      | `"admin"`                | GRUB superuser name (must match in `superusers=` and `password_pbkdf2`)           |
| `grub_password_hash`  | `""`                     | PBKDF2 hash generated via `grub-mkpasswd-pbkdf2` — *required for full compliance* |
| `grub_grub_cfg_path`  | `"/boot/grub/grub.cfg"`  | Path to GRUB configuration file                                                   |
| `grub_backup_enabled` | `true`                   | Whether to back up GRUB config before changes                                     |
| `grub_backup_path`    | `"/etc/grub.cfg.backup"` | Backup file location                                                              |

> **⚠️ Important**: The `grub_password_hash` must be generated **before** running the role. Example:
> ```bash
> grub-mkpasswd-pbkdf2
> # Enter password, then copy the long PBKDF2 hash
> ```

#### Dependencies
    None

#### Compliance mapping
    'cmmc': ['AC.L2-3.5.1', 'SI.L2-3.19.2'],  
    'fedramp': ['AC-3', 'AC-6', 'SI-4'],  
    'gdpr': ['32'],  
    'hipaa': ['164.308(a)(1)', '164.312(a)(1)', '164.312(e)(1)'],  
    'iso_27001': ['A.9.2.1', 'A.12.1.1', 'A.12.5.1'],  
    'nis2': ['21.2.a', '21.2.d'],  
    'nist_800_171': ['3.5.1', '3.13.12'],  
    'nist_800_53': ['AC-3', 'AC-6', 'SI-4'],  
    'pci_dss': ['2.2', '7.1', '7.2'],  
    'tsc': ['CC6.1', 'CC6.6', 'CC8.1', 'CC6.8']

#### Mitre

    - 'tactic': ['TA0001', 'TA0005'],  
    - 'technique': ['T1542.003', 'T1542.004', 'T1542.011']

#### Risk
    - High: Incorrect GRUB configuration can render the system unbootable.
    - Always test in a non-production environment first.
    - Ensure physical/console access is available to recover if needed.

#### References
    - [CIS Benchmark for RHEL 8/9 - 5.2.2](https://www.cisecurity.org/benchmark/red_hat_enterprise_linux/)
    - [Wazuh Rule 35757](https://www.wazuh.com/blog/wazuh-rule-35757-enforce-grub-superuser-password/)
    - [GNU GRUB Manual - 2.2.2 User accounts](https://www.gnu.org/software/grub/manual/grub/grub.html#User-accounts)

#### License
    Apache License 2.0
  
#### Author Information
    Patricio Rojas Ortiz  