# Prompt for u-ansible-setup-workstation

This repository automates the hardening and customization of an Ubuntu 24.04 workstation using Ansible.

   git clone https://github.com/appwebd/u-ansible-setup-workstation.git
   cd u-ansible-setup-workstation
   ```

2. **Install Ansible**

   ```bash
   bash bin/install-ansible.sh
   ```

3. **Configure Vault (optional)**

   ```bash
   cd roles/setup_tripwire/vars/
   ansible-vault create main.yml
   echo "your_master_password" > .vault_password
   chmod 600 .vault_password
   export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
   ```

4. **Run playbooks**

   ```bash
   # Update and upgrade packages
   bash bin/run_update_upgrade.sh

   # Harden the workstation
   ansible-playbook playbooks/setup_workstation.yaml

   # Disable bloatware
   bash bin/run_remove_bloatware_packages.sh

   # Apply hardening roles
   ansible-playbook playbooks/remove_unused_accounts_groups.yaml
   ```

5. **Linting**

   ```bash
   bash bin/run_ansible_lint.sh
   ```

6. **Shut down the host**

   ```bash
   bash bin/run_shutdown.sh
   ```

## Directory Structure

```
.
├── bin/                     # Helper scripts
├── inventory/               # Ansible inventory files
├── playbooks/               # High‑level playbooks
├── roles/                   # Ansible roles
└── README.md
```

## License

MIT © 2024 u-ansible-setup-workstation  
