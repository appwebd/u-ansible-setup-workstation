#### Role name: 
    ensure_issue_net_permissions

#### Wazuh ID : 
    35551

#### Title: 
    Ensure access to /etc/issue.net is configured.

#### Description:
    The contents of the /etc/issue.net file are displayed to users prior to login for remote connections from configured services. This Ansible role ensures the file has correct ownership and permissions to prevent unauthorized modification.

#### Rationale:
    If the /etc/issue.net file does not have the correct access configured, it could be modified by unauthorized users with incorrect or misleading information.

#### Remediation:
    Run the following commands to set mode, owner, and group on /etc/issue.net: # chown root:root $(readlink -e /etc/issue.net) # chmod u-x,go-wx $(readlink -e /etc/issue.net)

#### Requirements

  - Ansible 2.9 or higher
  - Root/sudo privileges (become: true)
  - Linux-based operating systems (where /etc/issue.net is used)

#### Variables

| Variable                  | Default                                     | Description                                                | file              |
|---------------------------|---------------------------------------------|------------------------------------------------------------|-------------------|
| `issue_net_path`          | `/etc/issue.net`                            | Path to the issue.net file                                 | defaults/main.yml |

#### Dependencies
    None

#### Compliance mapping
  - 'cmmc': ['AC.L2-3.1.1', 'AC.L2-3.1.2', 'AC.L2-3.1.5', 'AC.L2-3.1.3', 'MP.L2-3.8.2']
  - 'fedramp': ['AC-5', 'AC-6']
  - 'gdpr': ['32', '25', '30']
  - 'hipaa': ['164.312(a)(1)']
  - 'iso_27001': ['A.8.2.3', 'A.8.3.1', 'A.8.3.2', 'A.10.1.1', 'A.13.2.1', 'A.18.1.4']
  - 'nis2': ['21.2.g', '21.2.j', '21.2.i']
  - 'nist_800_171': ['3.1.1', '3.1.2', '3.1.5', '3.1.3', '3.8.2']
  - 'nist_800_53': ['AC-5', 'AC-6']
  - 'pci_dss': ['7.1', '1.3']
  - 'tsc': ['CC5.2', 'CC6.1', 'C1.1', 'C1.2', 'CC6.2', 'CC6.3', 'CC6.4', 'CC6.5', 'CC6.6', 'CC6.7', 'CC6.8', 'P1.1', 'P2.1', 'P3.1', 'P4.1', 'P5.1', 'P6.1', 'P7.1', 'P8.1']

#### Mitre
  - 'tactic': ['TA0009', 'TA0010']
  - 'technique': ['T1005', 'T1025', 'T1041', 'T1567', 'T1573']
  - 'subtechnique': ['T1048.003', 'T1552.001']

#### Conditions
    all

#### Rules
  - "c:stat /etc/issue.net -> r:Access:\\s*\\(0644/-rw-r--r--\\)\\s*Uid:\\s*\\(\\s*0/\\s*root\\)\\s*\\t*Gid:\\s*\\(\\s*0/\\s*root\\)"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - ensure_issue_net_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
