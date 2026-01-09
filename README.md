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
Create your password variable in vault_tripwire_password in the folder group_vars/all/vault.yml

```
cd group_vars/all/
ansible-vault create vault.yml
```

 