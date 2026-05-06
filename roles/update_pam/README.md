#### Role name:
    update_pam

#### Wazuh ID:
    35669

#### Title:
    Ensure latest version of pam is installed.

#### Description:
    Updated versions of PAM include additional functionality.

#### Rationale:
    To ensure the system has full functionality and access to the options covered by this Benchmark the latest version of libpam-runtime should be installed on the system.

#### Remediation:
    Run the following command to update to the latest version of PAM: # apt upgrade libpam-runtime.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to execute `apt` and `dpkg-query` commands with elevated privileges)  
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` and `dpkg-query` in tasks)  
    - Required Ansible collections/modules: `ansible.builtin.apt`, `ansible.builtin.command`  

#### Variables
| Variable           | Default          | Description                                                                                                                       | Source          |
|--------------------|------------------|-----------------------------------------------------------------------------------------------------------------------------------|-----------------|
| `pam_package_name` | `libpam-runtime` | Internal constant specifying the PAM runtime package name used for installation and verification. Not intended for user override. | `vars/main.yml` |

#### Dependencies
    Handlers: *not present*  
    Dependencies on other roles: *none*  

#### Compliance mapping
    - CMMC: CM.L2-3.4.1, CA.L2-3.12.4  
    - FedRAMP: CM-8  
    - GDPR: 30, 32  
    - HIPAA: 164.308(a)(4), 164.312(a)(1)  
    - ISO 27001: A.8.1.1, A.8.1.2  
    - NIS2: 21.2.j, 21.2.a  
    - NIST 800-171: 3.4.1, 3.12.4  
    - NIST 800-53: CM-8  
    - PCI DSS: 2.4, 9.1, 9.2, 9.3, 11.1, 9.5, 11.2, 12.5  
    - TSC: CC6.1, CC3.2, CC5.1, CC5.2, CC5.3, CC6.2, CC6.3, CC6.4, CC6.5, CC6.6, CC6.7, CC6.8  

#### Mitre
    - Tactic: TA0007  
    - Technique: T1595, T1046, T1087  

#### Conditions
    all  

#### Rules
    c:dpkg-query -s libpam-runtime -> r:^Status: install ok installed  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - update_pam
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
