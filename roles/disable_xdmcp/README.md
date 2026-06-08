#### Role name:
    disable_xdmcp

#### Wazuh ID:
    35560

#### Title:
    Ensure XDMCP is not enabled.

#### Description:
    X Display Manager Control Protocol (XDMCP) is designed to provide authenticated access to display management services for remote displays.

#### Rationale:
    XDMCP is inherently insecure. - XDMCP is not a ciphered protocol. This may allow an attacker to capture keystrokes entered by a user - XDMCP is vulnerable to man-in-the-middle attacks. This may allow an attacker to steal the credentials of legitimate users by impersonating the XDMCP server.

#### Remediation:
    Edit all files returned by the audit and remove or comment out the `Enable=true` line in the `[xdmcp]` block. Example file:  
    ```ini
    # GDM configuration storage
    # See /usr/share/gdm/gdm.schemas for a list of available options.
    [daemon]
    # Uncomment the line below to force the login screen to use Xorg
    #WaylandEnable=false
    # Enabling automatic login
    # AutomaticLoginEnable = true
    # AutomaticLogin = user1
    # Enabling timed login
    # TimedLoginEnable = true
    # TimedLogin = user1
    # TimedLoginDelay = 10
    [security]
    
    # Ensure XDMCP is not enabled in GDM3 Wazuh ID : 35560
    [xdmcp]
    # Enable=false  # <-- This line should be removed or commented out
    [chooser]
    [debug]
    # Uncomment the line below to turn on debugging
    # More verbose logs
    # Additionally lets the X server dump core if it crashes
    #Enable=true
    ```

#### Requirements
    - Ansible 2.16 or higher  
    - `become: yes` required (to modify system configuration files)  
    - OS: Debian/Ubuntu (inferred from `when: ansible_facts.os_family == "Debian" and ansible_facts.pkg_mgr == "apt"` in `tasks/main.yml`)  
    - Required Ansible modules: `ansible.builtin.stat`, `ansible.builtin.fail`, `ansible.builtin.copy`, `ansible.builtin.lineinfile`, `ansible.builtin.shell` (all from `ansible.builtin` collection)

#### Variables
| Variable                    | Default                      | Description                                                                         | Source              |
|-----------------------------|------------------------------|-------------------------------------------------------------------------------------|---------------------|
| `xdmcp_enable_line_pattern` | `^\s*Enable\s*=\s*true\s*$`  | Regular expression to match the `Enable=true` line (used for detection/remediation) | `vars/main.yml`     |
| `xdmcp_gdm3_config_dir`     | `/etc/gdm3`                  | Path to the GDM3 configuration directory                                            | `defaults/main.yml` |
| `xdmcp_gdm3_custom_conf`    | `/etc/gdm3/custom.conf`      | Path to the GDM3 custom configuration file (derived from `xdmcp_gdm3_config_dir`)   | `vars/main.yml`     |
| `xdmcp_section_name`        | `[xdmcp]`                    | The INI section header for XDMCP settings (used in pattern matching logic)          | `vars/main.yml`     |

#### Dependencies
    Handlers: `handlers/main.yml` *(not present — no handler tasks defined)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - **CMMC**: `CM.L2-3.4.7`, `CM.L2-3.4.8`, `SC.L2-3.13.6`  
    - **FedRAMP**: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - **GDPR**: `32`  
    - **HIPAA**: `164.308(a)(1)`  
    - **ISO 27001**: `A.12.1.1`, `A.12.1.2`, `A.14.2.1`  
    - **NIS2**: `21.2.e`, `21.2.a`  
    - **NIST 800-171**: `3.4.7`, `3.4.8`, `3.13.6`  
    - **NIST 800-53**: `CM-2`, `CM-3`, `CM-6`, `CM-7`  
    - **PCI DSS**: `1.1`, `1.2`, `2.2`, `6.4`  
    - **TSC**: `CC6.3`, `CC6.6`, `CC8.1`, `CC5.1`, `CC5.2`, `CC5.3`

#### Mitre
    - **Tactic**: `TA0005` (Defense Evasion)  
    - **Technique**: `T1036` (Masquerading), `T1564` (Hide Artifacts)

#### Conditions
    `any`

#### Rules
    - `not d:/etc/gdm3`  
    - `not d:/etc/gdm3 -> r:custom\\.conf`  
    - `not d:/etc/gdm3 -> r:custom\\.conf -> r:^\\s*\\t*Enable\\s*\\t*=\\s*\\t*true`

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - disable_xdmcp
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
