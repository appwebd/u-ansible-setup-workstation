#### Role name:
    remove_xserver_common

#### Wazuh ID:
    35580

#### Title:
    Ensure X window server services are not in use.

#### Description:
    The X Window System provides a Graphical User Interface (GUI) where users can have multiple windows in which to run programs and various add on. The X Windows system is typically used on workstations where users login, but not on servers where users typically do not login.

#### Rationale:
    Unless your organization specifically requires graphical login access via X Windows, remove it to reduce the potential attack surface.

#### Remediation:
    - IF - a Graphical Desktop Manager or X-Windows server is not required and approved by local site policy: Run the following command to remove the X Windows Server package: # apt purge xserver-common.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`)
    - Required Ansible collections/modules:
        - `ansible.builtin.assert`
        - `ansible.builtin.package_facts`
        - `ansible.builtin.set_fact`
        - `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable             | Default        | Description                                                        |
|----------------------|----------------|--------------------------------------------------------------------|
| xserver_package_name | xserver-common | Name of the X server package to remove (default: `xserver-common`) |

### vars/main.yml
    No variables defined.

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists handle removing unused dependencies)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: CM.L2-3.4.7, CM.L2-3.4.8, SC.L2-3.13.6  
    fedramp: CM-2, CM-3, CM-6, CM-7  
    gdpr: 32  
    hipaa: 164.308(a)(1)  
    iso_27001: A.12.1.1, A.12.1.2, A.14.2.1  
    nis2: 21.2.e, 21.2.a  
    nist_800_171: 3.4.7, 3.4.8, 3.13.6  
    nist_800_53: CM-2, CM-3, CM-6, CM-7  
    pci_dss: 1.1, 1.2, 2.2, 6.4  
    tsc: CC6.3, CC6.6, CC8.1, CC5.1, CC5.2, CC5.3

#### Mitre
    tactic: TA0005  
    technique: T1036, T1564

#### Conditions
    all

#### Rules
    c:dpkg-query -s xserver-common -> r:package 'xserver-common' is not installed

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - remove_xserver_common
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-22_17:32:08
