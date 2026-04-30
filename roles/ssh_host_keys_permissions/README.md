#### Role name:
    configure_ssh_host_keys_permissions

#### Wazuh ID: 
    35641

#### Title: 
    Ensure permissions on SSH private host key files are configured.

#### Description:
    An SSH private key is one of two files used in SSH public key authentication. In this authentication method, the possession of the private key is proof of identity. Only a private key that corresponds to a public key will be able to authenticate successfully. The private keys need to be stored and handled carefully, and no copies of the private key should be distributed.

#### Rationale:
    If an unauthorized user obtains the private SSH host key file, the host could be impersonated.

#### Remediation:
    Run the following script to set mode, ownership, and group on the private SSH host key files:  
    ```bash
    #!/usr/bin/env bash
    { a_output=(); a_output2=(); l_ssh_group_name="$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)" f_file_access_fix() { while IFS=: read -r l_file_mode l_file_owner l_file_group; do a_out2=() [ "$l_file_group" = "$l_ssh_group_name" ] && l_pmask="0137" || l_pmask="0177" l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )" if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then a_out2+=(" Mode: \"$l_file_mode\" should be mode: \"$l_maxperm\" or more restrictive" " updating to mode: \:$l_maxperm\"") if [ "l_file_group" = "$l_ssh_group_name" ]; then chmod u-x,g-wx,o-rwx "$l_file" else chmod u-x,go-rwx "$l_file" fi fi if [ "$l_file_owner" != "root" ]; then a_out2+=(" Owned by: \"$l_file_owner\" should be owned by \"root\"" " Changing ownership to \"root\"") chown root "$l_file" fi if [[ ! "$l_file_group" =~ ($l_ssh_group_name|root) ]]; then [ -n "$l_ssh_group_name" ] && l_new_group="$l_ssh_group_name" || l_new_group="root" a_out2+=(" Owned by group \"$l_file_group\" should be group owned by: \"$l_ssh_group_name\" or \"root\"" " Changing group ownership to \"$l_new_group\"") chgrp "$l_new_group" "$l_file" fi if [ "${#a_out2[@]}" -gt "0" ]; then a_output2+=(" - File: \"$l_file\"" "${a_out2[@]}") else a_output+=(" - File: \"$l_file\"" "Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured") fi done < <(stat -Lc '%#a:%U:%G' "$l_file") } while IFS= read -r -d $'\0' l_file; do if ssh-keygen -lf &>/dev/null "$l_file"; then file "$l_file" | grep -Piq -- '\bopenssh\h+([^#\n\r]+\h+)?private\h+key\b' && f_file_access_fix fi done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null) if [ "${#a_output2[@]}" -le "0" ]; then printf '%s\n' "" " - No access changes required" "" else printf '%s\n' "" " - Remediation results:" "${a_output2[@]}" "" fi }
    ```

#### Requirements
    - Ansible 2.9 or higher
    - Root/sudo privileges (`become: true`)
    - Linux systems with OpenSSH installed
    - `stat`, `find`, `chmod`, `chown`, `chgrp`, `ssh-keygen`, and `file` utilities available

#### Variables

| Variable                                   | Default                                                                                                                      | Description                                                                                    | File              |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|-------------------|
| `ssh_public_key_files`                     | `["/etc/ssh/ssh_host_rsa_key", "/etc/ssh/ssh_host_ecdsa_key", "/etc/ssh/ssh_host_ed25519_key", "/etc/ssh/ssh_host_dsa_key"]` | List of paths to SSH private host key files to audit and remediate                             | vars/main.yml     |
| `ssh_host_keys_permissions_group`          | `"ssh_keys"`                                                                                                                 | Desired group for SSH private host key files (falls back to `root` if group not found)         | defaults/main.yml |
| `ssh_host_keys_permissions_mode`           | `"0600"`                                                                                                                     | Desired file mode for SSH private host key files                                               | defaults/main.yml |
| `ssh_host_keys_permissions_owner`          | `"root"`                                                                                                                     | Desired owner for SSH private host key files                                                   | defaults/main.yml |

#### Dependencies
    None

#### Compliance mapping
    - 'cis': ['5.2.10'],
    - 'cis_csc': ['5.1'],
    - 'cmmc': ['SC.L2-3.13.6'],
    - 'fedramp': ['AC-6', 'SC-4'],
    - 'gdpr': ['32'],
    - 'hipaa': ['164.308(a)(1)'],
    - 'iso_27001': ['A.10.1.1', 'A.12.1.2'],
    - 'nist_800_171': ['3.5.1', '3.13.6'],
    - 'nist_800_53': ['AC-6', 'SC-4'],
    - 'pci_dss': ['1.3.1', '2.2.4', '6.4.2'],
    - 'tsc': ['CC6.6', 'CC6.3', 'CC8.1']

#### Mitre
    - 'tactic': ['TA0001', 'TA0005'],
    - 'technique': ['T1552', 'T1552.004', 'T1021.004']

#### Conditions
    all

#### Rules
    - "c:stat -Lc '%a:%U:%G' /etc/ssh/ssh_host_*_key -> r:mode '0600', owner 'root', group 'ssh_keys' or 'root'"
    - "c:stat -Lc '%a:%U:%G' /etc/ssh/ssh_host_*_key -> r:mode not containing '7', '6', '3', '2', '1' in any position except first"
    - "c:stat -Lc '%a:%U:%G' /etc/ssh/ssh_host_*_key -> r:owner 'root'"
    - "c:stat -Lc '%a:%U:%G' /etc/ssh/ssh_host_*_key -> r:group 'ssh_keys' or 'root'"

#### Usage

Include this role in your playbook:

```yaml
- hosts: servers
  become: true
  roles:
    - configure_ssh_host_keys_permissions
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
