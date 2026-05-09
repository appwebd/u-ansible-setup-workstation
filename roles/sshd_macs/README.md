#### Role name:
    sshd_macs

#### Wazuh ID:
    35654

#### Title:
    Ensure sshd MACs are configured.

#### Description:
    This variable limits the types of MAC algorithms that SSH can use during communication. Notes: - Some organizations may have stricter requirements for approved MACs. - Ensure that MACs used are in compliance with site policy. - The only "strong" MACs currently FIPS 140 approved are: o HMAC-SHA1 o HMAC-SHA2-256 o HMAC-SHA2-384 o HMAC-SHA2-512.

#### Rationale:
    MD5 and 96-bit MAC algorithms are considered weak and have been shown to increase exploitability in SSH downgrade attacks. Weak algorithms continue to have a great deal of attention as a weak spot that can be exploited with expanded computing power. An attacker that breaks the algorithm could take advantage of a MiTM position to decrypt the SSH tunnel and capture credentials and information.

#### Remediation:
    Edit the /etc/ssh/sshd_config file and add/modify the MACs line to contain a comma separated list of the site unapproved (weak) MACs preceded with a - above any Include entries: Example: MACs -hmac-md5,hmac-md5-96,hmac-ripemd160,hmac-sha1-96,umac- 64@openssh.com,hmac-md5-etm@openssh.com,hmac-md5-96-etm@openssh.com,hmac- ripemd160-etm@openssh.com,hmac-sha1-96-etm@openssh.com,umac-64- etm@openssh.com,umac-128-etm@openssh.com - IF - CVE-2023-48795 has not been reviewed and addressed, the following etm MACs should be added to the exclude list: hmac-sha1-etm@openssh.com,hmac-sha2-256- etm@openssh.com,hmac-sha2-512-etm@openssh.com Note: First occurrence of an option takes precedence. If Include locations are enabled, used, and order of precedence is understood in your environment, the entry may be created in a file in Include location.

#### Requirements

- Ansible 2.9+
- Privilege escalation (`become: true`)
- OpenSSH server package installed (`openssh-server`)
- Target host must provide `sshd` binary and support `sshd -T`

#### Variables

### defaults/main.yml

| Variable                                       | Default                | Description                                                                |
|------------------------------------------------|------------------------|----------------------------------------------------------------------------|
| `sshd_macs_config_file`                        | `/etc/ssh/sshd_config` | Main SSH daemon config file                                                |
| `sshd_macs_manage_service`                     | `true`                 | If true, ensures SSH service is enabled/started                            |
| `sshd_macs_blacklist_base`                     | *(list)*               | Weak MACs required by control 35654 to exclude                             |
| `sshd_macs_include_cve202348795_etm_blacklist` | `true`                 | Include extra ETM MAC exclusions if CVE-2023-48795 not reviewed/remediated |
| `sshd_macs_blacklist_cve202348795_extra`       | *(list)*               | Additional ETM MACs tied to CVE recommendation                             |

### vars/main.yml

| Variable                       | Default           | Description                                                  |
|--------------------------------|-------------------|--------------------------------------------------------------|
| `sshd_package_name`            | `openssh-server`  | OpenSSH server package name                                  |
| `sshd_service_name_candidates` | `['ssh', 'sshd']` | Candidate service names used to detect effective SSH service |

#### Dependencies
    Handlers: `handlers/main.yml` *(if exists)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    - Wazuh Rule ID: 35654  
    - CIS Benchmark: 5.2.8 Ensure SSH MACs are configured  
    - NIST: SC-8 (Transmission Confidentiality), SC-28 (Protection of Information)  
    - PCI-DSS: 4.1, 6.5.5  
    - HIPAA: 164.312(e)(1)  

#### Mitre
    - T1190 (Exploit Public-Facing Application)  
    - T1136 (Create Account)  
    - T1021.004 (SSH)  
    - T1557 (Adversary-in-the-Middle)  

#### Conditions
    - Only applies to Debian-family systems (uses `apt`).  
    - Requires `sshd` to be installed and service manageable.  
    - If `sshd_macs_blacklist` or `sshd_macs_whitelist` are empty, corresponding tasks are skipped.  
    - Configuration is applied via `lineinfile` in `/etc/ssh/sshd_config`, and fallback blacklist via `/etc/ssh/sshd_config.d/01-macs-blacklist.conf`.  
    - If `sshd_macs_blacklist_string` is not defined (e.g., empty list), the blacklist config file is not created.

#### Rules
    - MACs directive must be present in `/etc/ssh/sshd_config`  
    - Weak MACs must be blacklisted via `Include`-compatible fallback config  
    - Configuration must be idempotent and backed up  
    - SSH service must be restarted after changes  

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - sshd_macs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
