#### Role name: 
  timesyncd_configuration

#### Wazuh ID : 
  35588

#### Title    : 
  Ensure systemd-timesyncd configured with authorized timeserver.

#### Description:
    This Ansible role ensures that systemd-timesyncd is properly configured with authorized NTP servers in accordance with organizational policy. It sets both the primary NTP and fallback NTP servers to site-approved time sources, as required by security rule **35588** (Wazuh).

#### Rationale:
    Time synchronization is important to support time sensitive security mechanisms and to ensure log files have consistent time records across the enterprise to aid in forensic investigations.

#### Remediation:
    Set NTP and/or FallbackNTP parameters to local site approved authoritative time server(s) in /etc/systemd/timesyncd.conf or a file in /etc/systemd/timesyncd.conf.d/ ending in .conf in the [Time] section:  
    Example file:  
    ```  
    [Time]  
    NTP=time.nist.gov  
    FallbackNTP=time-a-g.nist.gov time-b-g.nist.gov time-c-g.nist.gov  
    ```  
    Run the following command to update the parameters in the service:  
    ```bash  
    systemctl reload-or-restart systemd-journald  
    ```  
    Note: If this setting appears in a canonically later file, or later in the same file, the setting will be overwritten.

#### Requirements            
    - Ansible 2.9 or higher  
    - Root/sudo privileges (`become: true`)  
    - systemd-based Linux distributions (e.g., RHEL, CentOS, Ubuntu, Debian)  
    - `systemd` package installed  
    - `systemd-timesyncd` service available (not disabled by default on all distros; role handles enabling if needed)

#### Variables

| Variable | Default | Description | file |
|---------|---------|-------------|------|
| `timesyncd_enabled` | `true` | Enables or disables the timesyncd service configuration | defaults/main.yml |
| `timesyncd_ntp_servers` | `[]` | List of primary NTP servers. If empty, defaults to `default_ntp_servers` | defaults/main.yml |
| `timesyncd_fallback_ntp_servers` | `[]` | List of fallback NTP servers. If empty, defaults to `default_fallback_ntp_servers` | defaults/main.yml |
| `default_ntp_servers` | `["time.nist.gov"]` | Default primary NTP servers used when `timesyncd_ntp_servers` is empty | defaults/main.yml |
| `default_fallback_ntp_servers` | `["time-a-g.nist.gov", "time-b-g.nist.gov", "time-c-g.nist.gov"]` | Default fallback NTP servers used when `timesyncd_fallback_ntp_servers` is empty | defaults/main.yml |
| `timesyncd_main_conf_file` | `/etc/systemd/timesyncd.conf` | Path to the main timesyncd configuration file | vars/main.yml |
| `timesyncd_conf_dir` | `/etc/systemd/timesyncd.conf.d` | Directory for drop-in configuration files | vars/main.yml |
| `timesyncd_custom_conf_file` | `/etc/systemd/timesyncd.conf.d/60-timesyncd.conf` | Full path to the custom drop-in configuration file | defaults/main.yml |
| `timesyncd_service_name` | `systemd-timesyncd` | Name of the systemd service (internal constant) | vars/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cmmc': ['AU.L2-3.3.7'],  
    - 'fedramp': ['AU-7'],  
    - 'gdpr': ['32', '33'],  
    - 'hipaa': ['164.312(b)', '164.308(a)(6)'],  
    - 'iso_27001': ['A.12.4.1', 'A.12.4.2', 'A.12.4.3', 'A.16.1.2'],  
    - 'nis2': ['21.2.a', '23', '21.2.b'],  
    - 'nist_800_171': ['3.3.7'],  
    - 'nist_800_53': ['AU-7'],  
    - 'pci_dss': ['10.4', '10.6'],  
    - 'tsc': ['CC4.1', 'CC5.2', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5', 'CC4.2']

#### Mitre
    - 'tactic': ['TA0005', 'TA0006', 'TA0007'],  
    - 'technique': ['T1562', 'T1070', 'T1059', 'T1040'],  
    - 'subtechnique': ['T1562.002', 'T1070.001']

#### Conditions
    any

#### Rules
    - 'f:/etc/systemd/timesyncd.conf -> r:^NTP|^FallbackNTP'  
    - 'not c:systemctl show systemd-timesyncd.service -> r:^LoadState=loaded|^ActiveState=active'

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  vars:
    timesyncd_ntp_servers:
      - "time.internal.company.local"
    timesyncd_fallback_ntp_servers:
      - "pool.ntp.org"
  roles:
    - timesyncd_configuration
```

To use default NIST public servers (if no NTP servers are specified):

```code
- hosts: servers
  become: true
  roles:
    - timesyncd_configuration
```

#### License
  Apache 2.0

#### Author
Patricio Rojas Ortiz
