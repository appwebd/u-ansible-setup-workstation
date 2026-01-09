# Ansible setup workstation

Prepare the workstation with defined properties:

* Time zone configuration
* Installation of software recommended by Lynis, Wazuh
* Hardening of Debian 13 (Kernel hardening, driver blacklisting) 
* Configuration of some auditd options
* General permissions configuration
* Installation of Aida
* Installation of Otpclient
* Installation of Rkhunter
* Installation of Sysstat
* Installation of Tripwire

## Configuration

Create your password variables in the folder roles/setup_tripwire/vars/main.yml

```
cd roles/setup_tripwire/vars/
ansible-vault create main.yml
```
example of file: roles/setup_tripwire/vars/main.yml

```
vault_tripwire_site_passphrase: "myPassword-1"
vault_tripwire_local_passphrase: "myPassword-2"
```

Save the password to access the vault in the root directory of your project named .vault_password and set it in your environment variable

```
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password 
```

this vault password is used too in the file:
* bin/run_setup_workstation.sh
* bin/run_ansible_lint.sh


