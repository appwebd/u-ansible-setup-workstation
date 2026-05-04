#### Role name:
    sshd_kexalgorithms

#### Wazuh ID:
    35651

#### Title:
    Ensure sshd KexAlgorithms is configured.

#### Description:
    Key exchange is any method in cryptography by which cryptographic keys are exchanged between two parties, allowing use of a cryptographic algorithm. If the sender and receiver wish to exchange encrypted messages, each must be equipped to encrypt messages to be sent and decrypt messages received Notes: - Kex algorithms have a higher preference the earlier they appear in the list - Some organizations may have stricter requirements for approved Key exchange algorithms - Ensure that Key exchange algorithms used are in compliance with site policy - The only Key Exchange Algorithms currently FIPS 140 approved are: o ecdh-sha2-nistp256 o ecdh-sha2-nistp384 o ecdh-sha2-nistp521 o diffie-hellman-group-exchange-sha256 o diffie-hellman-group16-sha512 o diffie-hellman-group18-sha512 o diffie-hellman-group14-sha256.

#### Rationale:
    Key exchange methods that are considered weak should be removed. A key exchange method may be weak because too few bits are used, or the hashing algorithm is considered too weak. Using weak algorithms could expose connections to man-in-the-middle attacks.

#### Remediation:
    Edit the /etc/ssh/sshd_config file and add/modify the KexAlgorithms line to contain a comma separated list of the site unapproved (weak) KexAlgorithms preceded with a - above any Include entries: Example: KexAlgorithms -diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie- hellman-group-exchange-sha1 Note: First occurrence of an option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to modify `/etc/ssh/sshd_config` and manage the `sshd` service)  
    - OS: Linux distributions using `sshd` (inferred from `tasks/main.yml` referencing `sshd` service and `/etc/ssh/sshd_config`)  
    - Required Ansible modules: `ansible.builtin.lineinfile`, `ansible.builtin.service`  

#### Variables

| Variable                            | Default                                                                                                                                                                                                         | Description                                                                                                     | Source                                                            |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| `sshd_config_dir`                   | `/etc/ssh`                                                                                                                                                                                                      | Directory containing SSH configuration files. *DECLARED BUT NOT USED*                                           | `vars/main.yml`                                                   |
| `sshd_kexalgorithms_blacklist_line` | `-diffie-hellman-group1-sha1,-diffie-hellman-group14-sha1,-diffie-hellman-group-exchange-sha1`                                                                                                                  | Comma-separated string of blacklisted algorithms prefixed with `-`, used to explicitly disable weak algorithms. | `defaults/main.yml` (derived from `sshd_kexalgorithms_blacklist`) |
| `sshd_kexalgorithms_blacklist`      | `['diffie-hellman-group1-sha1', 'diffie-hellman-group14-sha1', 'diffie-hellman-group-exchange-sha1']`                                                                                                           | List of weak key exchange algorithms to explicitly blacklist (prefixed with `-`).                               | `defaults/main.yml`                                               |
| `sshd_kexalgorithms_file`           | `/etc/ssh/sshd_config`                                                                                                                                                                                          | Path to the SSH daemon configuration file to be modified.                                                       | `defaults/main.yml`                                               |
| `sshd_kexalgorithms_line`           | `ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256`                       | Comma-separated string of whitelisted algorithms, used to construct the `KexAlgorithms` directive.              | `defaults/main.yml` (derived from `sshd_kexalgorithms_whitelist`) |
| `sshd_kexalgorithms_whitelist`      | `['ecdh-sha2-nistp256', 'ecdh-sha2-nistp384', 'ecdh-sha2-nistp521', 'diffie-hellman-group-exchange-sha256', 'diffie-hellman-group16-sha512', 'diffie-hellman-group18-sha512', 'diffie-hellman-group14-sha256']` | List of approved (strong) key exchange algorithms to enable.                                                    | `defaults/main.yml`                                               |
| `sshd_service_name`                 | `sshd`                                                                                                                                                                                                          | Name of the SSH daemon service (used to restart the service after configuration changes).                       | `vars/main.yml`                                                   |

#### Dependencies
    Handlers: `handlers/main.yml` *(not provided; no handlers defined in input)*  
    Dependencies on other roles: *none*  

#### Compliance mapping
    - CMMC: AC.L2-3.1.17, AC.L2-3.1.13, IA.L2-3.5.10, SC.L2-3.13.11, SC.L2-3.13.8, SC.L2-3.13.15  
    - FedRAMP: SC-8  
    - GDPR: 32, 25, 30  
    - HIPAA: 164.312(e)(1)  
    - ISO/IEC 27001: A.8.2.3, A.8.3.1, A.8.3.2, A.10.1.1, A.13.2.1, A.18.1.4  
    - NIS2: 21.2.g, 21.2.j, 21.2.i  
    - NIST 800-171: 3.1.17, 3.1.13, 3.5.10, 3.13.11, 3.13.8, 3.13.15  
    - NIST 800-53: AC-17 (2), SC-8, SC-8 (1), SC-8 (2), SC-8 (3), SC-13, SC-32, SC-32 (1), SC-32 (2), SC-39  
    - PCI-DSS: 2.3, 4.1, 6.5.10  
    - SOC 2: CC6.1, CC6.6, CC6.7  

#### Example Playbook

Include this role in your playbook:

```yaml
- hosts: all
  become: yes
  roles:
    - role: sshd_kexalgorithms
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
