#### Role name:
    ensure_libpam_modules_installed

#### Wazuh ID:
    35670

#### Title:
    Ensure libpam-modules is installed.

#### Description:
    Pluggable Authentication Modules for PAM.

#### Rationale:
    To ensure the system has full functionality and access to the PAM options covered by this Benchmark.

#### Remediation:
    Run the following command to update to the latest version of PAM: # apt upgrade libpam-modules.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to execute `apt` with elevated privileges)  
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` and package name `libpam-modules`, which is specific to Debian-based systems)  
    - Required Ansible modules: `ansible.builtin.apt`  

#### Variables
| Variable                      | Default          | Description                                                                                                         | Source              |
|-------------------------------|------------------|---------------------------------------------------------------------------------------------------------------------|---------------------|
| `libpam_modules_package_name` | `libpam-modules` | Name of the PAM modules package to install; used to ensure the correct package is targeted on Debian-based systems. | `defaults/main.yml` |

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
    c:dpkg -s libpam-modules -> r:install ok installed  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - ensure_libpam_modules_installed
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
