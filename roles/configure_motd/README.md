#### Role name: 
    configure_motd

#### Wazuh ID : 
    35546

#### Title    : 
    Ensure message of the day is configured properly.

#### Description:
    This Ansible role ensures that the contents of the `/etc/motd` file conform to organizational security policy. It removes potentially hazardous system information (e.g., machine architecture, OS release, vendor, version) and eliminates references to the OS platform, thereby reducing the risk of information disclosure to attackers. This role addresses security rule **35546** (Wazuh).

#### Rationale:
    Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the "uname -a" command once they have logged in.

#### Remediation:
    Edit the `/etc/motd` file with the appropriate contents according to your site policy, remove any instances of `\m`, `\r`, `\s`, `\v` or references to the OS platform — OR — if the motd is not used, this file can be removed. Run the following command to remove the motd file: `# rm /etc/motd`.

#### Requirements
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Unix-based systems (Linux, BSD) with `/etc/motd`

#### Variables

| Variable                   | Default     | Description                                                                                              | file              |
|----------------------------|-------------|----------------------------------------------------------------------------------------------------------|-------------------|
| `motd_file_path`           | `/etc/motd` | Path to the MOTD file                                                                                    | defaults/main.yml |
| `motd_content_default`     | `""`        | Default content to use if `motd_state: present` and no custom template provided                          | defaults/main.yml |
| `motd_state`               | `absent`    | Whether to ensure the file is `present` or `absent`                                                      | defaults/main.yml |
| `motd_template_source`     | `motd.j2`   | Jinja2 template file to render for `present` state                                                       | defaults/main.yml |
| `motd_ensure_content_safe` | `true`      | When `true`, automatically sanitize content to remove `\m`, `\r`, `\s`, `\v`, and OS platform references | defaults/main.yml |   
| `motd_org_name `           | ""          | Organization name to display in the MOTD file                                                            | defaults/main.yml |
| `motd_monitoring_policy`   | ""          | Monitoring policy to display in the MOTD file                                                            | defaults/main.yml | 

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['CM.L2-3.4.1', 'CA.L2-3.12.4']
    - 'fedramp': ['CM-8']
    - 'gdpr': ['30', '32']
    - 'hipaa': ['164.308(a)(4)', '164.312(a)(1)']
    - 'iso_27001': ['A.8.1.1', 'A.8.1.2']
    - 'nis2': ['21.2.j', '21.2.a']
    - 'nist_800_171': ['3.4.1', '3.12.4']
    - 'nist_800_53': ['CM-8']
    - 'pci_dss': ['2.4', '9.1', '9.2', '9.3', '11.1', '9.5', '11.2', '12.5']
    - 'tsc': ['CC6.1', 'CC3.2', 'CC5.1', 'CC5.2', 'CC5.3', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8']

#### Mitre
    - 'tactic': ['TA0007']
    - 'technique': ['T1595', 'T1046', 'T1087']

#### Conditions
    any

#### Rules
    - `not f:/etc/motd -> r:\\v|\\r|\\m|\\s|Debian|Ubuntu`
    - `not f:/etc/motd`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_motd
```

By default, the role removes `/etc/motd` (`motd_state: absent`). To customize the MOTD content:

```code
- hosts: servers
  become: true
  roles:
    - role: configure_motd
      motd_state: present
      motd_content_default: |
        WARNING: Authorized access only.
        All activities are monitored and recorded.
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
