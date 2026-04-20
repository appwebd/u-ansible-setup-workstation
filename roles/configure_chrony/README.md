#### Role name: 
  configure_chrony

#### Wazuh ID : 
  35590

#### Title    : 
    Ensure chrony is configured with authorized timeserver.

#### Description:
    The server directive specifies an NTP server which can be used as a time source. The client-server relationship is strictly hierarchical: a client might synchronize its system time to that of the server, but the server's system time will never be influenced by that of a client. o This directive can be used multiple times to specify multiple servers. o The directive is immediately followed by either the name of the server, or its IP address. - pool o The syntax of this directive is similar to that for the server directive, except that it is used to specify a pool of NTP servers rather than a single NTP server. The pool name is expected to resolve to multiple addresses which might change over time. o This directive can be used multiple times to specify multiple pools. o All options valid in the server directive can be used in this directive too.

#### Rationale:
    Time synchronization is important to support time sensitive security mechanisms and to ensure log files have consistent time records across the enterprise to aid in forensic investigations.

#### Remediation:
    Edit /etc/chrony/chrony.conf or a file ending in .sources in /etc/chrony/sources.d/ and add or edit server or pool 
lines as appropriate according to local site policy: Edit the Chrony configuration and add or edit the server and/or pool 
lines returned by the Audit Procedure as appropriate according to local site policy <[server|pool]> <[remote-server|remote-pool]>
Example script to add a drop-in configuration for the pool directive: 
#!/usr/bin/env bash { 
[ ! -d "/etc/chrony/sources.d/" ] && mkdir /etc/chrony/sources.d/ 
    printf '%s\n' "" "#The maxsources option is unique to the pool directive" \ 
                     "pool time.nist.gov iburst maxsources 4" >> /etc/chrony/sources.d/60-sources.sources 
    chronyc reload sources &>/dev/null 
} Example script to add a drop-in configuration for the server directive: 

#!/usr/bin/env bash { [ ! -d "/etc/chrony/sources.d/" ] && mkdir /etc/chrony/sources.d/ 
printf '%s\n' "" "server time-a-g.nist.gov iburst" 
                 "server 132.163.97.3 iburst" \ 
                 "server time-d-b.nist.gov iburst" >> /etc/chrony/sources.d/60-sources.sources 
chronyc reload sources &>/dev/null 
} 

Run the following command to reload the chronyd config: 

# systemctl reload-or-restart chronyd.

#### Requirements            

    - Ansible 2.9 or higher
    - Root/sudo privileges (become: true)
    - chrony package installed

#### Variables

| Variable                   | Default                                                                                                | Description                                     | file               |
|----------------------------|--------------------------------------------------------------------------------------------------------|-------------------------------------------------|--------------------|
| `chrony_config_dir`        | `/etc/chrony/sources.d/`                                                                               | Directory for chrony configuration files        | defaults/main.yml  |
| `chrony_pool_directives`   | `["pool time.nist.gov iburst maxsources 4"]`                                                           | List of pool directives to configure            | defaults/main.yml  |
| `chrony_server_directives` | `["server time-a-g.nist.gov iburst", "server 132.163.97.3 iburst", "server time-d-b.nist.gov iburst"]` | List of server directives to configure          | defaults/main.yml  |
| `chrony_conf_file`         | `/etc/chrony/chrony.conf`                                                                              | Main chrony configuration file                  | defaults/main.yml  |
| `sources_filename`         | `"60-sources.sources"`                                                                                 | Name of the sources file in sources.d directory | defaults/main.yml  |
| `chrony_service_name`      | `chronyd`                                                                                              | Name of the chrony service                      | vars/main.yml      |
| `chrony_package_name`      | `chrony`                                                                                               | Name of the chrony package                      | vars/main.yml      |
| `chrony_reload_command`    | `systemctl reload-or-restart chronyd`                                                                  | Command to reload chrony configuration          | vars/main.yml      |

#### Dependencies
    No dependencies

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
    - 'tsc': ['CC4.1', 'CC5.2', 'CC7.1', 'CC7.2', 'CC7.3', 'CC7.4', 'CC7.5', 'CC7.6']

#### Mitre
    - 'tactic': ['TA0005'], 
    - 'technique': ['T1036', 'T1564']

#### Conditions
     all

#### Rules
    - "c:dpkg-query -s chrony -> r:package 'chrony' is installed"

#### Usage

Include this role in your playbook:

```code
- hosts: servers
  become: true
  roles:
    - configure_chrony               
```

#### License
  Apache 2.0

#### Author
Patricio Rojas Ortiz
