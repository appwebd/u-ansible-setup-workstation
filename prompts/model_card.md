# u-ansible-setup-workstation Model Card

## 1. Overview

The **u-ansible-setup-workstation** repository is a comprehensive toolkit designed to automate the provisioning, hardening, and maintenance of Linux workstations using Ansible. The project serves as a reference implementation for secure workstation setup, ensuring consistent configuration across environments while simplifying the workflow for system administrators and developers.

## 2. Scope

- **Workstation Provisioning**: Install base OS packages, desktop environments, and developer tools.
- **Security Hardening**: Apply OS hardening best practices, configure firewall rules, SSH settings, audit logs, and monitoring tools.
- **Package Management**: Keep systems up‑to‑date with unattended upgrades and customizable package lists.
- **Role Reusability**: Each role is isolated, with clear inputs/outputs, enabling reuse in other projects or environments.

## 3. Features

| Feature               | Description                                                                   | Example                                             |
|-----------------------|-------------------------------------------------------------------------------|-----------------------------------------------------|
| **Declarative**       | Infrastructure as code using Ansible playbooks and roles.                     | `ansible-playbook playbooks/setup_workstation.yaml` |
| **Idempotent**        | Tasks are safe to run repeatedly; state is maintained.                        | `apt: state=latest`                                 |
| **Role‑based**        | Modular design encourages reuse and composability.                            | `roles/sudo`, `roles/hardening_debian`              |
| **Security Focus**    | Implements best practices for authentication, logging, and package integrity. | `fail2ban`, `rkhunter`, `tripwire`                  |
| **Extensibility**     | Easy to add new roles or modify existing ones via `vars` and `defaults`.      | `roles/suggested_software_packages`                 |
| **Testing & Linting** | Built‑in support for `ansible-lint`, `yamllint`, and Molecule testing.        | `ansible-lint playbooks/setup_workstation.yaml`     |

## 4. Installation & Usage

```bash
# Clone the repository
git clone https://github.com/your-org/u-ansible-setup-workstation.git
cd u-ansible-setup-workstation

# Create an inventory file or use the provided sample
cp inventory/sample inventory/production

# Run the main playbook
ansible-playbook -i inventory/production playbooks/setup_workstation.yaml
```

## 5. Configuration

- **Variables** – Set at the inventory level (`group_vars`, `host_vars`) or override with `--extra-vars`.
- **Vault** – Encrypt secrets with Ansible Vault (`ansible-vault encrypt_string`).
- **Roles** – Enable or disable roles in `playbooks/setup_workstation.yaml`.

## 6. Best Practices

1. **Keep Roles Small** – Each role should perform a single responsibility.
2. **Use `defaults` over `vars`** – Provides a fallback that can be overridden.
3. **Avoid `shell`** – Prefer modules for idempotency.
4. **Tagging** – Tag tasks for selective execution.
5. **Logging** – Use `no_log` for sensitive information.

## 7. Contribution

Feel free to open pull requests to add new roles, improve documentation, or fix bugs. Follow the style guidelines and run `ansible-lint` before submitting changes.

## 8. License

MIT © 2024 The u-ansible-setup-workstation team