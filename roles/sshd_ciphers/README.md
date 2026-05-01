#### Role name:
    sshd_ciphers

#### Wazuh ID: 
    35645

#### Title: 
    Ensure sshd Ciphers are configured.

#### Description:
    This variable limits the ciphers that SSH can use during communication. Notes: - Some organizations may have stricter requirements for approved ciphers. - Ensure that ciphers used are in compliance with site policy. - The only "strong" ciphers currently FIPS 140 compliant are: o aes256-gcm@openssh.com o aes128-gcm@openssh.com o aes256-ctr o aes192-ctr o aes128-ctr.

#### Rationale:
    Weak ciphers that are used for authentication to the cryptographic module cannot be relied upon to provide confidentiality or integrity, and system data may be compromised. - The Triple DES ciphers, as used in SSH, have a birthday bound of approximately four billion blocks, which makes it easier for remote attackers to obtain clear text data via a birthday attack against a long-duration encrypted session, aka a "Sweet32" attack. - Error handling in the SSH protocol; Client and Server, when using a block cipher algorithm in Cipher Block Chaining (CBC) mode, makes it easier for remote attackers to recover certain plain text data from an arbitrary block of cipher text in an SSH session via unknown vectors.

#### Remediation:
    Edit the /etc/ssh/sshd_config file and add/modify the Ciphers line to contain a comma separated list of the site unapproved (weak) Ciphers preceded with a - above any Include entries: Example: Ciphers -3des-cbc,aes128-cbc,aes192-cbc,aes256-cbc,chacha20-poly1305@openssh.com - IF - CVE-2023-48795 has been addressed, and it meets local site policy, chacha20-poly1305@openssh.com may be removed from the list of excluded ciphers. Note: First occurrence of an option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements            
    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - Linux systems with OpenSSH server installed
    - `/etc/ssh/sshd_config` file must exist and be writable
    - `openssh-server` package installed

#### Variables

| Variable                      | Default                                                                                          | Description                                                              | file              |
|-------------------------------|--------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|-------------------|
| `sshd_ciphers_blacklist`      | `["3des-cbc", "aes128-cbc", "aes192-cbc", "aes256-cbc"]`                                         | List of weak ciphers to explicitly disable (prefixed with `-`)           | defaults/main.yml |
| `sshd_ciphers_whitelist`      | `["aes256-gcm@openssh.com", "aes128-gcm@openssh.com", "aes256-ctr", "aes192-ctr", "aes128-ctr"]` | List of approved strong ciphers                                          | defaults/main.yml |
| `sshd_config_file`            | `/etc/ssh/sshd_config`                                                                           | Path to main sshd configuration file                                     | defaults/main.yml |
| `sshd_include_dir`            | `/etc/ssh/sshd_config.d`                                                                         | Directory for included sshd configuration snippets                       | defaults/main.yml |
| `sshd_config_include_enabled` | `false`                                                                                          | Whether to write configuration to an include file instead of main config | defaults/main.yml |
| `sshd_config_include_file`    | `/etc/ssh/sshd_config.d/99-wazuh-ciphers.conf`                                                   | Path to include file when `sshd_config_include_enabled` is true          | defaults/main.yml |
| `sshd_service_name`           | `sshd`                                                                                           | Name of the sshd service                                                 | vars/main.yml     |
| `sshd_package_name`           | `openssh-server`                                                                                 | Name of the sshd package                                                 | vars/main.yml     |`

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.17', 'AC.L2-3.1.13', 'IA.L2-3.5.10', 'SC.L2-3.13.11', 'SC.L2-3.13.8', 'SC.L2-3.13.15']
    - 'fedramp': ['SC-8']
    - 'gdpr': ['32', '25', '30']
    - 'hipaa': ['164.312(e)(1)']
    - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
    - 'nis2': ['21.2.g', '21.2.j', '21.2.i']
    - 'nist_800_171': ['3.1.17', '3.1.13', '3.5.10', '3.13.11', '3.13.8', '3.13.15']
    - 'nist_800_53': ['SC-8']
    - 'pci_dss': ['2.1', '4.1', '8.2', '2.2', '4.2', '8.3']
    - 'tsc': ['C1.1', 'C1.2', 'C1.3', 'C1.4', 'C1.5', 'C1.6', 'C1.7', 'C1.8', 'C1.9', 'C1.10', 'C2.1', 'C2.2', 'C2.3', 'C2.4', 'C2.5', 'C2.6', 'C2.7', 'C2.8', 'C2.9', 'C2.10', 'C3.1', 'C3.2', 'C3.3', 'C3.4', 'C3.5', 'C3.6', 'C3.7', 'C3.8', 'C3.9', 'C3.10', 'C4.1', 'C4.2', 'C4.3', 'C4.4', 'C4.5', 'C4.6', 'C4.7', 'C4.8', 'C4.9', 'C4.10', 'C5.1', 'C5.2', 'C5.3', 'C5.4', 'C5.5', 'C5.6', 'C5.7', 'C5.8', 'C5.9', 'C5.10', 'C6.1', 'C6.2', 'C6.3', 'C6.4', 'C6.5', 'C6.6', 'C6.7', 'C6.8', 'C6.9', 'C6.10', 'C7.1', 'C7.2', 'C7.3', 'C7.4', 'C7.5', 'C7.6', 'C7.7', 'C7.8', 'C7.9', 'C7.10', 'C8.1', 'C8.2', 'C8.3', 'C8.4', 'C8.5', 'C8.6', 'C8.7', 'C8.8', 'C8.9', 'C8.10', 'C9.1', 'C9.2', 'C9.3', 'C9.4', 'C9.5', 'C9.6', 'C9.7', 'C9.8', 'C9.9', 'C9.10', 'C10.1', 'C10.2', 'C10.3', 'C10.4', 'C10.5', 'C10.6', 'C10.7', 'C10.8', 'C10.9', 'C10.10']

#### Mitre
    - 'tactic': ['TA0001', 'TA0011']
    - 'technique': ['T1059', 'T1059.001', 'T1059.003', 'T1059.004', 'T1059.005', 'T1059.006', 'T1059.007', 'T1059.008', 'T1059.009', 'T1059.010']

#### Conditions
    - `ansible_os_family == "Debian"` or `ansible_os_family == "RedHat"`
    - `ansible_distribution_version is version('7.0', '>=')`
    - `sshd_config_file is file`

#### Rules
    - "c:grep -E '^\s*Ciphers\s+' /etc/ssh/sshd_config | grep -v '^\s*#' | wc -l -> r:1"
    - "c:grep -E '^\s*Ciphers\s+' /etc/ssh/sshd_config | grep -v '^\s*#' | grep -v '^\s*Ciphers\s+-3des-cbc,aes128-cbc,aes192-cbc,aes256-cbc' -> r:0"

#### Usage
    Include this role in your playbook:
    ```yaml
    - hosts: servers
      become: true
      roles:
        - sshd_ciphers
    ```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
