#### Role name:
    `remove_gdm`

#### Wazuh ID:
    `35552`

#### Title:
    Ensure GDM is removed.

#### Description:
    The GNOME Display Manager (GDM) is a program that manages graphical display servers and handles graphical user logins.

#### Rationale:
    If a Graphical User Interface (GUI) is not required, it should be removed to reduce the attack surface of the system.

#### Remediation:
    Run the following commands to uninstall gdm3 and remove unused dependencies:  
    ```bash
    # apt purge gdm3  
    # apt autoremove gdm3
    ```

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to execute `apt` with elevated privileges for package removal)  
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt`, `dpkg-query`, and `ansible_facts.os_family == "Debian"`)  
    - Required Ansible modules: `ansible.builtin.apt`, `ansible.builtin.shell`  

#### Variables
| Variable            | Default  | Description                                                                                                        | Source              |
|---------------------|----------|--------------------------------------------------------------------------------------------------------------------|---------------------|
| `gdm3_package_name` | `gdm3`   | Name of the GDM3 package to remove; used in `apt` purge and `dpkg-query` verification tasks.                       | `defaults/main.yml` |
| `gdm3_service_name` | `gdm3`   | Internal constant for the GDM3 service name; declared but not used in tasks (no service management tasks present). | `vars/main.yml`     |

#### Dependencies
    Handlers: `handlers/main.yml` *(not present — no handlers defined)*  
    Dependencies on other roles: *none*  

#### Compliance mapping
    - CMMC: `CM.L2-3.4.7`, `CM.L2-3.4.8`, `SC.L2-3.13.6`  
    - FedRAMP: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - GDPR: `32`  
    - HIPAA: `164.308(a)(1)`  
    - ISO/IEC 27001: `A.12.1.1`, `A.12.1.2`, `A.14.2.1`  
    - NIS2: `21.2.e`, `21.2.a`  
    - NIST 800-171: `3.4.7`, `3.4.8`, `3.13.6`  
    - NIST 800-53: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - PCI DSS: `1.1`, `1.2`, `2.2`, `6.4`  
    - TSC: `CC6.3`, `CC6.6`, `CC8.1`, `CC5.1`, `CC5.2`, `CC5.3`  

#### Mitre
    - Tactic: `TA0005` (Defense Evasion)  
    - Technique: `T1036` (Masquerading), `T1564` (Hide Artifacts)  

#### Conditions
    `all` — the role executes unconditionally on target hosts matching OS family `Debian`.

#### Rules
    `c:dpkg-query -s gdm3 -> r:package 'gdm3' is not installed`

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - remove_gdm
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
