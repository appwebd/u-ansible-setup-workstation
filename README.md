# Ansible Workstation Setup

![Ansible](https://img.shields.io/badge/Ansible-2.x-black?logo=ansible)
![Hardening](https://img.shields.io/badge/Security-Hardening-green)
![Static Badge](https://img.shields.io/badge/OS-Ubuntu%2024-red%3Flogo%3Dubuntu)
[![Development Status](https://img.shields.io/badge/Status-Development-yellow?style=for-the-badge&logo=github)](https://img.shields.io/badge/Status-Development-yellow?style=for-the-badge&logo=github)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project automates the preparation, hardening, and customization of a workstation based on **Ubuntu 24.04**.

It follows the hardening guides of *Lynis* and *Wazuh*, and installs a set of critical tools for auditing, intrusion detection, and access control.


## 🚀 Installation and Usage

1. **Install Ansible**  
   If you don't already have it installed, run the included script:

```bash
bash bin/install-ansible.sh
```

## Clone the Repository

```bash
git clone https://github.com/appwebd/u-ansible-setup-workstation.git
cd u-ansible-setup-workstation
```

## Configure Vault
Ansible uses `ansible-vault` to handle sensitive variables. Here it is used to generate a password for Tripwire.

```bash
# Create the vault and variable files
cd roles/setup_tripwire/vars/
ansible-vault create main.yml
```

Store the master password you used for `ansible-vault` in the `.vault_password` file:

```bash
echo "your_master_password" > .vault_password
chmod 600 .vault_password
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
```

This is primarily to automate the `ansible-lint` review so it doesn't prompt for the role's password.

## Project Structure

```text
.
├── bin/                     # Helper scripts (install-ansible, wrappers, lint, etc.)
├── inventory/               # Ansible inventory files
├── playbooks/               # High‑level playbooks
│   ├── setup_workstation.yaml
│   ├── update_upgrade.yaml
│   ├── remove_bloatware_packages.yaml
│   ├── remove_unused_accounts_groups.yaml
│   ├── shutdown.yaml
├── roles/                   # Ansible roles
│   ├── aide/
│   ├── auditd/
│   ├── configure-timezone/
│   ├── configure_local_login_banner/
│   ├── configure_login_defs/
│   ├── fail2ban/
│   ├── file_permission/
│   ├── gnome/
│   ├── grub_audit_backlog/
│   ├── hardening_debian/
│   ├── otpclient/
│   ├── remove_bloatware_packages/
│   ├── remove_unused_accounts_groups/
│   ├── rkhunter/
│   ├── sshd/
│   ├── sudo/
│   ├── suggested_software_packages/
│   ├── suggested_software_packages_desktop/
│   ├── sysstat/
│   ├── tripwire/
│   ├── unattended_upgrades/
│   └── update_upgrade/
├── .ansible/                # Ansible cache
├── .vault_password          # Master password for Ansible Vault
└── README.md
```

## Main Playbook Tasks

| Task                                | Script                                      |
|-------------------------------------|---------------------------------------------|
| Update packages on multiple servers | `bash bin/run_update_upgrade.sh`            |
| Shut down multiple servers          | `bash bin/run_shutdown.sh`                  |
| Ensure playbooks follow standards   | `bash bin/run_ansible_lint.sh`              |
| Configure SSH                       | `bash bin/setup_ssh_key_authentication.sh`  |
| Clean bloatware from Ubuntu         | `bash bin/run_remove_bloatware_packages.sh` |


## Core Roles

| Role | Purpose | Key File |
|------|---------|----------|
| `aide` | Install and configure AIDE | `tasks/main.yml` |
| `auditd` | Configure auditd and audit rules | `tasks/main.yml` |
| `fail2ban` | Protect against failed login attempts | `tasks/main.yml` |
| `gnome` | Configure desktop (banners, wallpaper, etc.) | `tasks/main.yml` |
| `hardening_debian` | Apply kernel, sysctl, and AppArmor hardening | `tasks/main.yml` |
| `remove_bloatware_packages` | Remove unnecessary packages | `tasks/main.yml` |
| `remove_unused_accounts_groups` | Clean unused accounts and groups | `tasks/main.yml` |
| `rkhunter` | Install and run Rootkit Hunter | `tasks/main.yml` |
| `sshd` | Harden SSH (key‑only access, port, banner, etc.) | `tasks/main.yml` |
| `sudo` | Configure sudo permissions and expiration policy | `tasks/main.yml` |
| `tripwire` | Install and configure Tripwire for change detection | `tasks/main.yml` |
| `unattended_upgrades` | Automate security patches | `tasks/main.yml` |
| `update_upgrade` | Run `apt update` and `apt upgrade` | `tasks/main.yml` |

## Ansible Lint Syntax Check

To ensure playbooks follow the standards:

```bash
# Run ansible-lint on all playbooks
bash bin/run_ansible_lint.sh
```
## Wazuh categories


### 1) Authentication and Access Control

| Wazuh ID  | Description                                                                | Target                                                                                                                                         |
|-----------|----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| 35676     | Ensure password failed attempts lockout is configured                      | /etc/security/faillock.conf                                                                                                                    |
| 35677     | Ensure password unlock time is configured                                  | /etc/security/faillock.conf                                                                                                                    |
| 35678     | Ensure password failed attempts lockout includes root account              | /etc/security/faillock.conf                                                                                                                    |
| 35679     | Ensure password number of changed characters is configured                 | /etc/security/pwquality.conf                                                                                                                   |
| 35680     | Ensure minimum password length is configured                               | /etc/security/pwquality.conf                                                                                                                   |
| 35681     | Ensure password complexity is configured                                   | /etc/security/pwquality.conf                                                                                                                   |
| 35682     | Ensure password same consecutive characters is configured                  | /etc/security/pwquality.conf                                                                                                                   |
| 35683     | Ensure password maximum sequential characters is configured                | /etc/security/pwquality.conf                                                                                                                   |
| 35684     | Ensure password dictionary check is enabled                                | /etc/security/pwquality.conf                                                                                                                   |
| 35685     | Ensure password quality checking is enforced                               | cat /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf                                                                         |
| 35686     | Ensure password quality is enforced for the root user                      | /etc/security/pwquality.conf                                                                                                                   |
| 35687     | Ensure password history remember is configured                             | /etc/pam.d/common-password                                                                                                                     |
| 35688     | Ensure password history is enforced for the root user                      | /etc/pam.d/common-password                                                                                                                     |
| 35689     | Ensure pam_pwhistory includes use_authtok                                  | /etc/pam.d/common-password                                                                                                                     |
| 35690     | Ensure pam_unix does not include nullok                                    | /etc/pam.d/common-password,/etc/pam.d/common-auth                                                                                              |
| 35691     | Ensure pam_unix does not include remember                                  | /etc/pam.d/common-password,/etc/pam.d/common-auth,/etc/pam.d/common-account,/etc/pam.d/common-session,/etc/pam.d/common-session-noninteractive |
| 35692     | Ensure pam_unix includes a strong password hashing algorithm               | /etc/pam.d/common-password                                                                                                                     |
| 35693     | Ensure pam_unix includes use_authtok                                       | /etc/pam.d/common-password                                                                                                                     |
| 35694     | Ensure password expiration is configured                                   | /etc/login.defs                                                                                                                                |
| 35695     | Ensure minimum password days is configured                                 | /etc/login.defs                                                                                                                                |
| 35696     | Ensure password expiration warning days is configured                      | /etc/login.defs,/etc/shadow                                                                                                                    |
| 35697     | Ensure strong password hashing algorithm is configured                     | /etc/login.defs                                                                                                                                |
| 35698     | Ensure inactive password lock is configured                                | /etc/shadow                                                                                                                                    |
| 35699     | Ensure root is the only UID 0 account                                      | /etc/passwd                                                                                                                                    |
| 35700     | Ensure root is the only GID 0 account                                      | /etc/passwd                                                                                                                                    |
| 35701     | Ensure group root is the only GID 0 group                                  | /etc/group                                                                                                                                     |
| 35702     | Ensure root account access is controlled                                   | passwd -S root                                                                                                                                 |
| 35704     | Ensure nologin is not listed in /etc/shells                                | /etc/shells                                                                                                                                    |
| 35705     | Ensure default user shell timeout is configured                            | cat /etc/bashrc /etc/profile /etc/profile.d/*.sh                                                                                               |
| 35668     | Ensure access to the su command is restricted                              | /etc/pam.d/su                                                                                                                                  |
| 35662     | Ensure sudo is installed                                                   | dpkg -s sudo                                                                                                                                   |
| 35663     | Ensure sudo commands use pty                                               | /etc/sudoers                                                                                                                                   |
| 35665     | Ensure users must provide password for privilege escalation                | /etc/sudoers                                                                                                                                   |
| 35666     | Ensure re-authentication for privilege escalation is not disabled globally | /etc/sudoers                                                                                                                                   |
| 35667     | Ensure sudo authentication timeout is configured correctly                 | /etc/sudoers                                                                                                                                   |
| 35664     | Ensure sudo log file exists                                                | /etc/sudoers                                                                                                                                   |
| 35669     | Ensure latest version of pam is installed                                  | libpam-runtime                                                                                                                                 |
| 35670     | Ensure libpam-modules is installed                                         | libpam-modules                                                                                                                                 |
| 35671     | Ensure libpam-pwquality is installed                                       | libpam-pwquality                                                                                                                               |
| 35672     | Ensure pam_unix module is enabled                                          | /etc/pam.d/common-*                                                                                                                            |
| 35673     | Ensure pam_faillock module is enabled                                      | /etc/pam.d/common-auth                                                                                                                         |
| 35674     | Ensure pam_pwquality module is enabled                                     | /etc/pam.d/common-password                                                                                                                     |
| 35675     | Ensure pam_pwhistory module is enabled                                     | /etc/pam.d/common-password                                                                                                                     |

### 2) File Integrity (FIM / Syscheck)
| Wazuh ID  | Description                                                                      | Target                                |
|-----------|----------------------------------------------------------------------------------|---------------------------------------|
| 35758     | Ensure AIDE is installed                                                         | dpkg-query -s aide                    |
| 35759     | Ensure filesystem integrity is regularly checked                                 | systemctl show dailyaidecheck.service |
| 35760     | Ensure cryptographic mechanisms are used to protect the integrity of audit tools | /etc/aide/aide.conf                   |

### 3) Malware / IOC / Threat Intelligence
- **(No IDs in your list)**

### 4) Command Execution and Processes
- *(No explicit IDs in your list)*

### 5) Privilege Escalation
| Wazuh ID  | Description                                                                | Target        |
|-----------|----------------------------------------------------------------------------|---------------|
| 35665     | Ensure users must provide password for privilege escalation                | /etc/sudoers  |
| 35666     | Ensure re-authentication for privilege escalation is not disabled globally | /etc/sudoers  |
| 35667     | Ensure sudo authentication timeout is configured correctly                 | /etc/sudoers  |
| 35668     | Ensure access to the su command is restricted                              | /etc/pam.d/su |


### 6) Persistence
| Wazuh ID  | Description                                            | Target             |
|-----------|--------------------------------------------------------|--------------------|
| 35593     | Ensure cron daemon is enabled and active               | cron.service       |
| 35594     | Ensure permissions on /etc/crontab are configured      | /etc/crontab       |
| 35595     | Ensure permissions on /etc/cron.hourly are configured  | /etc/cron.hourly/  |
| 35596     | Ensure permissions on /etc/cron.daily are configured   | /etc/cron.daily/   |
| 35597     | Ensure permissions on /etc/cron.weekly are configured  | /etc/cron.weekly/  |
| 35598     | Ensure permissions on /etc/cron.monthly are configured | /etc/cron.monthly/ |
| 35599     | Ensure permissions on /etc/cron.d are configured       | /etc/cron.d/       |
| 35600     | Ensure crontab is restricted to authorized users       | /etc/cron.allow    |
| 35601     | Ensure at is restricted to authorized users            | /etc/at.allow      |

### 7) Network and Communications

**Hardening of network and communications:**

| Wazuh ID  | Description                                        | Target                                            |
|-----------|----------------------------------------------------|---------------------------------------------------|
| 35608     | Ensure ip forwarding is disabled                   | sysctl net.ipv4.ip_forward                        |
| 35609     | Ensure packet redirect sending is disabled         | sysctl net.ipv4.conf.all.send_redirects           |
| 35610     | Ensure bogus icmp responses are ignored            | sysctl net.ipv4.icmp_ignore_bogus_error_responses |
| 35611     | Ensure broadcast icmp requests are ignored         | sysctl net.ipv4.icmp_echo_ignore_broadcasts       |
| 35612     | Ensure icmp redirects are not accepted             | sysctl net.ipv4/ipv6 accept_redirects             |
| 35613     | Ensure secure icmp redirects are not accepted      | sysctl net.ipv4.conf.all.secure_redirects         |
| 35614     | Ensure reverse path filtering is enabled           | sysctl net.ipv4.conf.all.rp_filter                |
| 35615     | Ensure source routed packets are not accepted      | sysctl accept_source_route                        |
| 35616     | Ensure suspicious packets are logged               | sysctl net.ipv4.conf.all.log_martians             |
| 35617     | Ensure tcp syn cookies is enabled                  | sysctl net.ipv4.tcp_syncookies                    |
| 35618     | Ensure ipv6 router advertisements are not accepted | sysctl net.ipv6.conf.all.accept_ra                |

**Firewall (UFW / nftables / iptables):**

| Wazuh ID  | Description                                              | Target                               |
|-----------|----------------------------------------------------------|--------------------------------------|
| 35619     | Ensure a single firewall configuration utility is in use | systemctl show ufw/nftables/iptables |
| 35620     | Ensure ufw is installed                                  | ufw                                  |
| 35621     | Ensure iptables-persistent is not installed with ufw     | ufw + iptables-persistent            |
| 35622     | Ensure ufw service is enabled                            | ufw.service                          |
| 35623     | Ensure ufw loopback traffic is configured                | ufw status verbose                   |
| 35624     | Ensure ufw default deny firewall policy                  | ufw status verbose                   |
| 35625     | Ensure nftables is installed                             | nftables                             |
| 35626     | Ensure ufw is uninstalled or disabled with nftables      | ufw + nftables                       |
| 35627     | Ensure iptables are flushed with nftables                | iptables -L                          |
| 35628     | Ensure a nftables table exists                           | nft list tables                      |
| 35629     | Ensure nftables base chains exist                        | nft list ruleset                     |
| 35630     | Ensure nftables default deny firewall policy             | nft list ruleset                     |
| 35631     | Ensure nftables service is enabled                       | systemctl is-enabled nftables        |
| 35632     | Ensure nftables rules are permanent                      | /etc/nftables.conf                   |
| 35633     | Ensure iptables packages are installed                   | iptables/iptables-persistent         |
| 35634     | Ensure nftables is not in use with iptables              | nftables                             |
| 35635     | Ensure ufw is not in use with iptables                   | ufw                                  |
| 35636     | Ensure iptables default deny firewall policy             | iptables -L                          |
| 35637     | Ensure iptables loopback traffic is configured           | iptables -L INPUT -v -n              |
| 35638     | Ensure ip6tables default deny firewall policy            | ip6tables -L                         |
| 35639     | Ensure ip6tables loopback traffic is configured          | ip6tables -L INPUT -v -n             |

** Network services/daemons that should not be in use (surface reduction):**

| Wazuh ID  | Description                                                  | Target                  |
|-----------|--------------------------------------------------------------|-------------------------|
| 35562     | Ensure avahi daemon services are not in use                  | avahi-daemon            |
| 35563     | Ensure dhcp server services are not in use                   | isc-dhcp-server         |
| 35564     | Ensure dns server services are not in use                    | bind9                   |
| 35565     | Ensure dnsmasq services are not in use                       | dnsmasq                 |
| 35566     | Ensure ftp server services are not in use                    | vsftpd                  |
| 35567     | Ensure ldap server services are not in use                   | slapd                   |
| 35568     | Ensure message access server services are not in use         | dovecot-*               |
| 35569     | Ensure network file system services are not in use           | nfs-kernel-server       |
| 35570     | Ensure nis server services are not in use                    | ypserv                  |
| 35571     | Ensure print server services are not in use                  | cups                    |
| 35572     | Ensure rpcbind services are not in use                       | rpcbind                 |
| 35573     | Ensure rsync services are not in use                         | rsync                   |
| 35574     | Ensure samba file server services are not in use             | samba                   |
| 35575     | Ensure snmp services are not in use                          | snmpd                   |
| 35576     | Ensure tftp server services are not in use                   | tftpd-hpa               |
| 35577     | Ensure web proxy server services are not in use              | squid                   |
| 35578     | Ensure web server services are not in use                    | apache2/nginx           |
| 35579     | Ensure xinetd services are not in use                        | xinetd                  |
| 35581     | Ensure mail transfer agent is configured for local-only mode | ss -lntu                |
| 35582     | Ensure NIS Client is not installed                           | nis                     |
| 35583     | Ensure rsh client is not installed                           | rsh-client              |
| 35584     | Ensure talk client is not installed                          | talk                    |
| 35585     | Ensure telnet client is not installed                        | telnet/inetutils-telnet |
| 35586     | Ensure ldap client is not installed                          | ldap-utils              |
| 35587     | Ensure ftp client is not installed                           | ftp/tnftp               |

### 8) Exploits / Web / Applications

```plain text
- *(There are no specific app controls)*
```


### 9) System and Configuration
**Kernel / módulos / boot / MAC:**

| Wazuh ID  | Description                                                  | Target                           |
|-----------|--------------------------------------------------------------|----------------------------------|
| 35500     | Ensure mounting of cramfs filesystems is disabled            | modprobe cramfs                  |
| 35501     | Ensure freevxfs kernel module is not available               | modprobe freevxfs                |
| 35502     | Ensure hfs kernel module is not available                    | modprobe hfs                     |
| 35503     | Ensure hfsplus kernel module is not available                | modprobe hfsplus                 |
| 35504     | Ensure jffs2 kernel module is not available                  | modprobe jffs2                   |
| 35505     | Ensure overlayfs kernel module is not available              | modprobe overlayfs               |
| 35506     | Ensure squashfs kernel module is not available               | modprobe squashfs                |
| 35507     | Ensure udf kernel module is not available                    | modprobe udf                     |
| 35508     | Ensure usb-storage kernel module is not available            | modprobe usb-storage             |
| 35509     | Ensure unused filesystems kernel modules are not available   | modprobe afs                     |
| 35604     | Ensure dccp kernel module is not available                   | modprobe dccp                    |
| 35605     | Ensure tipc kernel module is not available                   | modprobe tipc                    |
| 35606     | Ensure rds kernel module is not available                    | /etc/modprobe.d/                 |
| 35607     | Ensure sctp kernel module is not available                   | /etc/modprobe.d/                 |
| 35542     | Ensure address space layout randomization is enabled         | sysctl kernel.randomize_va_space |
| 35543     | Ensure core dumps are restricted                             | sysctl fs.suid_dumpable          |
| 35544     | Ensure prelink is not installed                              | prelink                          |
| 35536     | Ensure AppArmor is installed                                 | apparmor packages                |
| 35537     | Ensure AppArmor is enabled in the bootloader configuration   | /etc/default/grub                |
| 35538     | Ensure all AppArmor Profiles are in enforce or complain mode | apparmor_status                  |
| 35539     | Ensure all AppArmor Profiles are enforcing                   | apparmor_status                  |
| 35540     | Ensure bootloader password is set                            | /boot/grub/grub.cfg              |
| 35541     | Ensure access to bootloader config is configured             | /boot/grub/grub.cfg perms        |

**Partitioning / mount options:**

| Wazuh ID  | Description                                          | Target                 |
|-----------|------------------------------------------------------|------------------------|
| 35510     | Ensure /tmp is a separate partition                  | findmnt /tmp           |
| 35511     | Ensure nodev option set on /tmp partition            | findmnt /tmp           |
| 35512     | Ensure nosuid option set on /tmp partition           | findmnt /tmp           |
| 35513     | Ensure noexec option set on /tmp partition           | findmnt /tmp           |
| 35514     | Ensure /dev/shm is a separate partition              | findmnt /dev/shm       |
| 35515     | Ensure nodev option set on /dev/shm partition        | findmnt /dev/shm       |
| 35516     | Ensure nosuid option set on /dev/shm partition       | findmnt /dev/shm       |
| 35517     | Ensure noexec option set on /dev/shm partition       | findmnt /dev/shm       |
| 35518     | Ensure separate partition exists for /home           | findmnt /home          |
| 35519     | Ensure nodev option set on /home partition           | findmnt /home          |
| 35520     | Ensure nosuid option set on /home partition          | findmnt /home          |
| 35521     | Ensure separate partition exists for /var            | findmnt /var           |
| 35522     | Ensure nodev option set on /var partition            | findmnt /var           |
| 35523     | Ensure nosuid option set on /var partition           | findmnt /var           |
| 35524     | Ensure separate partition exists for /var/tmp        | findmnt /var/tmp       |
| 35525     | Ensure nodev option set on /var/tmp partition        | findmnt /var/tmp       |
| 35526     | Ensure nosuid option set on /var/tmp partition       | findmnt /var/tmp       |
| 35527     | Ensure noexec option set on /var/tmp partition       | findmnt /var/tmp       |
| 35528     | Ensure separate partition exists for /var/log        | findmnt /var/log       |
| 35529     | Ensure nodev option set on /var/log partition        | findmnt /var/log       |
| 35530     | Ensure nosuid option set on /var/log partition       | findmnt /var/log       |
| 35531     | Ensure noexec option set on /var/log partition       | findmnt /var/log       |
| 35532     | Ensure separate partition exists for /var/log/audit  | findmnt /var/log/audit |
| 35533     | Ensure nodev option set on /var/log/audit partition  | findmnt /var/log/audit |
| 35534     | Ensure nosuid option set on /var/log/audit partition | findmnt /var/log/audit |
| 35535     | Ensure noexec option set on /var/log/audit partition | findmnt /var/log/audit |

**Banners / critical file permissions / local accounts:**

| Wazuh ID  | Description                                                | Target                      |
|-----------|------------------------------------------------------------|-----------------------------|
| 35546     | Ensure message of the day is configured properly           | /etc/motd                   |
| 35547     | Ensure local login warning banner is configured properly   | /etc/issue                  |
| 35548     | Ensure remote login warning banner is configured properly  | /etc/issue.net              |
| 35549     | Ensure access to /etc/motd is configured                   | /etc/motd                   |
| 35550     | Ensure access to /etc/issue is configured                  | /etc/issue perms            |
| 35551     | Ensure access to /etc/issue.net is configured              | /etc/issue.net perms        |
| 35761     | Ensure permissions on /etc/passwd are configured           | /etc/passwd                 |
| 35762     | Ensure permissions on /etc/passwd- are configured          | /etc/passwd-                |
| 35763     | Ensure permissions on /etc/group are configured            | /etc/group                  |
| 35764     | Ensure permissions on /etc/group- are configured           | /etc/group-                 |
| 35765     | Ensure permissions on /etc/shadow are configured           | /etc/shadow                 |
| 35766     | Ensure permissions on /etc/shadow- are configured          | /etc/shadow-                |
| 35767     | Ensure permissions on /etc/gshadow are configured          | /etc/gshadow                |
| 35768     | Ensure permissions on /etc/gshadow- are configured         | /etc/gshadow-               |
| 35769     | Ensure permissions on /etc/shells are configured           | /etc/shells                 |
| 35770     | Ensure permissions on /etc/security/opasswd are configured | /etc/security/opasswd(.old) |
| 35771     | Ensure accounts in /etc/passwd use shadowed passwords      | /etc/passwd                 |
| 35772     | Ensure /etc/shadow password fields are not empty           | /etc/shadow                 |
| 35773     | Ensure all groups in /etc/passwd exist in /etc/group       | /etc/group                  |
| 35774     | Ensure shadow group is empty                               | /etc/group                  |
| 35775     | Ensure no duplicate UIDs exist                             | command                     |
| 35776     | Ensure no duplicate GIDs exist                             | command                     |
| 35777     | Ensure no duplicate user names exist                       | command                     |
| 35778     | Ensure no duplicate group names exist                      | command                     |

**Time / NTP:**

| Wazuh ID  | Description                                                    | Target                      |
|-----------|----------------------------------------------------------------|-----------------------------|
| 35588     | Ensure systemd-timesyncd configured with authorized timeserver | /etc/systemd/timesyncd.conf |
| 35589     | Ensure systemd-timesyncd is enabled and running                | systemd-timesyncd.service   |
| 35590     | Ensure chrony is configured with authorized timeserver         | /etc/chrony/chrony.conf     |
| 35591     | Ensure chrony is running as user _chrony                       | ps -ef                      |
| 35592     | Ensure chrony is enabled and running                           | chrony.service              |

**GUI / desktop:**

| Wazuh ID  | Description                                                                  | Target                           |
|-----------|------------------------------------------------------------------------------|----------------------------------|
| 35552     | Ensure GDM is removed                                                        | gdm3                             |
| 35553     | Ensure GDM login banner is configured                                        | /etc/gdm3/greeter.dconf-defaults |
| 35554     | Ensure GDM disable-user-list option is enabled                               | /etc/dconf/db/gdm.d              |
| 35555     | Ensure GDM screen locks cannot be overridden                                 | /etc/dconf/db/local.d/locks      |
| 35556     | Ensure GDM automatic mounting of removable media is disabled                 | /etc/dconf/db/local.d            |
| 35557     | Ensure GDM disabling automatic mounting of removable media is not overridden | /etc/dconf/db/local.d/locks      |
| 35558     | Ensure GDM autorun-never is enabled                                          | /etc/dconf/db/local.d            |
| 35559     | Ensure GDM autorun-never is not overridden                                   | /etc/dconf/db/local.d/locks      |
| 35560     | Ensure XDMCP is not enabled                                                  | /etc/gdm3                        |
| 35580     | Ensure X window server services are not in use                               | xserver-common                   |

**Devices / Wireless:**

| Wazuh ID  | Description                              | Target                  |
|-----------|------------------------------------------|-------------------------|
| 35602     | Ensure wireless interfaces are disabled  | nmcli radio wifi        |
| 35603     | Ensure bluetooth services are not in use | bluez/bluetooth.service |

**Umask:**

| Wazuh ID  | Description                             | Target                                          |
|-----------|-----------------------------------------|-------------------------------------------------|
| 35703     | Ensure root user umask is configured    | /root/.bash_profile,/root/.bashrc               |
| 35706     | Ensure default user umask is configured | /etc/profile,/etc/login.defs,/etc/default/login |

**Errors/crash reporting:**

| Wazuh ID  | Description                                     | Target            |
|-----------|-------------------------------------------------|-------------------|
| 35545     | Ensure Automatic Error Reporting is not enabled | apport.service    |

### 10) Compliance (PCI, HIPAA, GDPR, CIS, etc.)
- *(Your controls seem aligned with CIS, but they are not explicitly labeled as “compliance”; if you want, I can create an alternative view by “CIS section” if you tell me the exact benchmark.)*



### 11) Windows (if applicable)
- *(Not applicable / no IDs)*

### 12) Cloud / Containers (if applicable)
- *(Not applicable / no IDs)*

## 📚 Resources and Documentation

- [Ansible Official Docs](https://docs.ansible.com/)
- [Lynis Hardening Guide](https://cisofy.com/lynis/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Debian Hardening](https://wiki.debian.org/SecureDebootstrap)
- [Ubuntu Security Standards](https://ubuntu.com/security/security-standards)
- [Ubuntu Hardening](https://ubuntu.com/engage/a-guide-to-infrastructure-hardening)

## 📜 License
This project is licensed under the MIT License. See the `LICENSE` file for details.
