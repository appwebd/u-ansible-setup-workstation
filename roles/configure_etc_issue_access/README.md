#### Role name: 
  configure_etc_issue_access

#### Wazuh ID : 
  35550

#### Title    : 
  Ensure access to /etc/issue is configured.

#### Description:
    This Ansible role ensures that the /etc/issue file has the correct access permissions (mode, owner, and group) configured to prevent unauthorized modification. The file contents are displayed to users before login on local terminals.

#### Rationale:
    If the /etc/issue file does not have the correct access configured, it could be modified by unauthorized users with incorrect or misleading information.

#### Remediation:
    Run the following commands to set mode, owner, and group on /etc/issue: 
    # chown root:root $(readlink -e /etc/issue) 
    # chmod u-x,go-wx $(readlink -e /etc/issue).

#### Requirements
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux-based operating systems (e.g., RHEL, CentOS, Debian, Ubuntu)
    - Presence of `/etc/issue` file (role handles creation if missing; otherwise configures existing file)

#### Variables

| Variable          | Default      | Description                                      | File              |
|-------------------|--------------|--------------------------------------------------|-------------------|
| `etc_issue_path`  | `/etc/issue` | Path to the /etc/issue file                      | defaults/main.yml |


#### Dependencies
    None

#### Compliance mapping
    - `cmmc`: ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
    - `fedramp`: ['AC-5', 'AC-6']
    - `gdpr`: ['32', '25', '30']
    - `hipaa`: ['164.312(a)(1)']
    - `iso_27001`: ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
    - `nis2`: ['21.2.g', '21.2.j', '21.2.i']
    - `nist_800_171`: ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']
    - `nist_800_53`: ['AC-5', 'AC-6']
    - `pci_dss`: ['7.1', '1.3']
    - `tsc`: ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
    - `tactic`: ['TA0009', 'TA0010']
    - `technique`: ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']
    - `subtechnique`: ['T1048.003', 'T1552.001']

#### Conditions
    all

#### Rules
    - `c:stat /etc/issue -> r:Access:\\s*\\(0644/-rw-r--r--\\)\\s*Uid:\\s*\\(\\s*0/\\s*root\\)\\s*\\t*Gid:\\s*\\(\\s*0/\\s*root\\)`

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_etc_issue_access
```

#### License
  Apache 2.0

#### Author
Patricio Rojas Ortiz
