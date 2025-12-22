# Ansible-setup-workstation

Prepare workstation Debian 13, with defined properties:

## Suggested Software Packages install:

- acpi-call-dkms
- ansible
- ansible-lint
- apg
- apparmor
- apparmor-utils
- apt-config-auto-update
- apt-listbugs       #  Install apt-listbugs to display a list of critical bugs prior to each APT installation.
- apt-listchanges
- apt-show-versions  # Install package apt-show-versions for patch management purposes [PKGS-7394]
- apt-transport-https
- audispd-plugins
- auditd
- bogofilter
- auditd             # Enable auditd to collect audit information [ACCT-9628]
- bsd-mailx
- clamav
- clamav-daemon
- ca-certificates
- chromium
- curl
- debsums           # Install debsums utility for the verification of packages with known good database. [PKGS-7370]
- fail2ban
- feh
- ffmpeg
- gedit
- git
- gnome-shell-extension-manager
- gnome-shell-extension-desktop-icons-ng
- gnome-shell-extension-dashtodock
- gnome-shell-extension-prefs
- gnome-shell-extensions
- gnome-shell-extension-appindicator
- gnupg2
- gparted
- htop
- iptables
- iptables-persistent
- jq
- keepassxc
- libcrack2
- libpam-passwdqc # AUTH-9262|Install a PAM module for password strength testing like pam_cracklib or pam_passwdqc
- libpam-pwquality
- libpam-tmpdir
- mc
- needrestart
- netfilter-persistent
- nftables
- otpclient
- remmina
- rkhunter # (install and configure)
- rsyslog
- sysstat  # Enable sysstat to collect accounting (no results) [ACCT-9626]
- systemd-timesyncd
- terminator
- thunderbird
- tp-smapi-dkms
- tripwire # Install a file integrity tool (packages alternatives Wazuh, AIDE, Samhain or Tripwire) [FINT-4350]
- tweak
- ufw

