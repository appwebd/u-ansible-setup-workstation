#### Role name: 
    uninstall_prelink
#### Wazuh ID : 
    35544
#### Title    : 
    Ensure prelink is uninstalled.

#### Description:
    This Ansible role ensures that the `prelink` package is uninstalled from Debian/Ubuntu-based systems. The removal of `prelink` helps reduce the attack surface and avoids interference with file integrity monitoring tools such as AIDE. This role addresses security rule **35544** (Wazuh/CIS).

#### Rationale:
    Prelink modifies ELF binaries in advance to reduce startup time. However, this modification breaks the expected hash values used by file integrity monitoring (FIM) tools like AIDE, leading to false positives. Removing prelink ensures that binary files remain unchanged and compatible with integrity checks.

#### Remediation:
    Run the following command to uninstall the `prelink` package and remove unused dependencies:
    ```bash
    # apt purge prelink
    ```

#### Requirements
    - Ansible 2.16 or higher
    - Root/sudo privileges (`become: true`)
    - Debian/Ubuntu-based Linux distributions

#### Variables

| Variable               | Default   | Description                      |
|------------------------|-----------|----------------------------------|
| `prelink_package_name` | `prelink` | Name of the package to uninstall |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AC.L2-3.1.20', 'SI.L2-3.14.4']
    - 'fedramp': ['SI-4', 'SI-5']
    - 'gdpr': ['32']
    - 'hipaa': ['164.308(a)(1)']
    - 'iso_27001': ['A.12.1.1', 'A.12.1.2', 'A.12.6.1']
    - 'nis2': ['21.2.e', '21.2.a']
    - 'nist_800_171': ['3.5.1', '3.14.4']
    - 'nist_800_53': ['SI-4', 'SI-5']
    - 'pci_dss': ['1.1', '1.2', '6.4']
    - 'tsc': ['CC6.3', 'CC6.6', 'CC8.1']

#### Mitre
    - 'tactic': ['TA0005', 'TA0007']
    - 'technique': ['T1036', 'T1564']

#### Conditions
    - all (Debian/Ubuntu systems where `prelink` may be installed)

#### Rules
    - "c:dpkg-query -s prelink -> r:package 'prelink' is not installed"

#### Usage

    Include this role in your playbook:

    ```yaml
    - hosts: servers
      become: true
      roles:
        - uninstall_prelink
    ```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
