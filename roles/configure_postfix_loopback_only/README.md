#### Role name:
    configure_postfix_loopback_only

#### Wazuh ID:
    35581

#### Title:
    Ensure mail transfer agent is configured for local-only mode.

#### Description:
    Mail Transfer Agents (MTA), such as sendmail and Postfix, are used to listen for incoming mail and transfer the messages to the appropriate user or mail server. If the system is not intended to be a mail server, it is recommended that the MTA be configured to only process local mail.

#### Rationale:
    The software for all Mail Transfer Agents is complex and most have a long history of security issues. While it is important to ensure that the system can process local mail messages, it is not necessary to have the MTA's daemon listening on a port unless the server is intended to be a mail server that receives and processes mail from other systems.

#### Remediation:
    Edit /etc/postfix/main.cf and add the following line to the RECEIVING MAIL section. If the line already exists, change it to look like the line below: inet_interfaces = loopback-only Run the following command to restart postfix: # systemctl restart postfix Note: - This recommendation is designed around the postfix mail server. - Depending on your environment you may have an alternative MTA installed such as exim4. If this is the case consult the documentation for your installed MTA to configure the recommended state.

#### Requirements
    - Ansible 2.16 or higher
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu family (inferred from `tasks/main.yml`)
    - Required Ansible collections/modules:
      - `ansible.builtin.assert`
      - `ansible.builtin.package_facts`
      - `ansible.builtin.fail`
      - `ansible.builtin.file`
      - `ansible.builtin.copy`
      - `ansible.builtin.lineinfile`
      - `ansible.builtin.systemd`
      - `ansible.builtin.shell`

#### Variables

### defaults/main.yml

| Variable                        | Default                | Description                                                                                            |
|---------------------------------|------------------------|--------------------------------------------------------------------------------------------------------|
| `postfix_main_cf_path`          | `/etc/postfix/main.cf` | Path to the Postfix main configuration file.                                                           |
| `postfix_inet_interfaces_value` | `loopback-only`        | Value for `inet_interfaces` directive in Postfix configuration to restrict listening to loopback only. |

### vars/main.yml

| Variable                       | Default   | Description                                                                |
|--------------------------------|-----------|----------------------------------------------------------------------------|
| `postfix_restart_service_name` | `postfix` | Name of the systemd service to restart when Postfix configuration changes. |

#### Dependencies
    Handlers: `handlers/main.yml`
      - Defines handler "Restart Postfix" which is invoked conditionally in `tasks/main.yml` via `notify` (implicitly through `when: inet_interfaces_result.changed`)
    Dependencies on other roles: none

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
    all

#### Rules
    not c:ss -lntu -> r::25\\s|:465\\s|:587\\s && r:\\s+127\\.0\\.0\\.\\d+:|\\s+\\[::1\\]:

#### Usage

```yaml
- hosts: servers
  become: yes
  roles:
    - configure_postfix_loopback_only
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz

### Date
    2026-06-22_17:33:32
