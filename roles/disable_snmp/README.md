#### Role name:
    disable_snmp

#### Wazuh ID:
    35575

#### Title:
    Ensure snmp services are not in use.

#### Description:
    Simple Network Management Protocol (SNMP) is a widely used protocol for monitoring the health and welfare of network equipment, computer equipment and devices like UPSs. Net-SNMP is a suite of applications used to implement SNMPv1 (RFC 1157), SNMPv2 (RFCs 1901-1908), and SNMPv3 (RFCs 3411-3418) using both IPv4 and IPv6. Support for SNMPv2 classic (a.k.a. "SNMPv2 historic" - RFCs 1441-1452) was dropped with the 4.0 release of the UCD-snmp package. The Simple Network Management Protocol (SNMP) server is used to listen for SNMP commands from an SNMP management system, execute the commands or collect the information and then send results back to the requesting system.

#### Rationale:
    The SNMP server can communicate using SNMPv1, which transmits data in the clear and does not require authentication to execute commands. SNMPv3 replaces the simple/clear text password sharing used in SNMPv2 with more securely encoded parameters. If the the SNMP service is not required, the snmpd package should be removed to reduce the attack surface of the system. Note: If SNMP is required: - The server should be configured for SNMP v3 only. User Authentication and Message Encryption should be configured. If SNMP v2 is absolutely necessary, modify the community strings' values.

#### Remediation:
    Run the following commands to stop snmpd.service and remove the snmpd package: # systemctl stop snmpd.service # apt purge snmpd - OR - If the package is required for dependencies: Run the following commands to stop and mask the snmpd.service: # systemctl stop snmpd.service # systemctl mask snmpd.service.

#### Requirements
    - Ansible 2.16 or higher (required for `package_facts` module behavior consistency)
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt`, `systemd`, and package names like `snmpd`)
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.apt`

#### Variables

### defaults/main.yml

| Variable          | Default    | Description                                                                                                            | Source            |
|-------------------|------------|------------------------------------------------------------------------------------------------------------------------|-------------------|
| snmp_service_name | `"snmpd"`  | Name of the SNMP service unit (used to construct systemd service name)                                                 | defaults/main.yml |
| snmp_package_name | `"snmpd"`  | Primary SNMP package name to target for removal/masking                                                                | defaults/main.yml |
| snmp_strategy     | `"remove"` | Strategy when SNMP is detected: `'remove'` purges packages; `'mask'` stops and masks service without removing packages | defaults/main.yml |

### vars/main.yml

| Variable             | Default                                     | Description                                                  | Source        |
|----------------------|---------------------------------------------|--------------------------------------------------------------|---------------|
| snmp_systemd_service | `{{ snmp_service_name }}.service`           | Fully qualified systemd service name (e.g., `snmpd.service`) | vars/main.yml |
| snmp_packages        | `["snmpd", "snmp", "snmp-mibs-downloader"]` | List of SNMP-related packages to remove or ensure absent     | vars/main.yml |

#### Dependencies
    Handlers: `handlers/main.yml`
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']
    fedramp: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    gdpr: ['32']
    hipaa: ['164.308(a)(1)']
    iso_27001: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']
    nis2: ['21.2.e', '21.2.a']
    nist_800_171: ['3.4.7', '3.4.8', '3.13.6']
    nist_800_53: ['CM-2', 'CM-3', 'CM-6', 'CM-7']
    pci_dss: ['1.1', '1.2', '2.2', '6.4']
    tsc: ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
    tactic: ['TA0005']
    technique: ['T1036', 'T1564']

#### Conditions
    any

#### Rules
    c:dpkg-query -s snmpd -> r:package 'snmpd' is not installed
    not c:systemctl show snmpd.service -> r:^LoadState=loaded|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_snmp
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
