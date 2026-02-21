
```text
project_root/
├─ bin/                    # Helper scripts (install-ansible, wrappers, lint, etc.)
├─ inventory/              # Ansible inventory files (singular)
├─ group_vars/             # Group variables
├─ host_vars/              # Host specific variables
├─ roles/                  # Ansible roles
│  ├─ my_role/
│  │  ├─ defaults/         # Default variables (lowest priority)
│  │  ├─ vars/             # Role-specific variables (higher priority)
│  │  ├─ tasks/            # Main task definitions
│  │  ├─ handlers/         # Handlers (notify-based)
│  │  ├─ templates/        # Jinja2 templates
│  │  ├─ files/            # Static files
│  │  ├─ meta/             # Role metadata (dependencies, galaxy info)
│  │  └─ README.md         # Role documentation (required)
│  └─ ...
├─ playbooks/              # High-level playbooks
│  ├─ site.yml             # Main deployment playbook
│  ├─ update_upgrade.yml   # Updates/patches playbook
│  └─ other.yml            # Additional playbooks
├─ ansible.cfg             # Ansible configuration
└─ requirements.yml        # Collections and roles dependencies
```

* Keep roles reusable – each role should be self‑contained.
* Use `defaults/main.yml` for default variables and `vars/main.yml` for role‑specific variables that override defaults.
* Keep playbooks short and delegating to roles.

---

## 2. Variables

| Variable scope         | Priority                  | Example                            |
|------------------------|---------------------------|------------------------------------|
| `inventory` group_vars | Highest (after overrides) | `group_vars/webservers.yml`        |
| `host_vars`            | Same as group_vars        | `host_vars/host1.yml`              |
| `vars/main.yml`        | Role variables            | `roles/webapp/vars/main.yml`       |
| `default/main.yml`     | Role defaults             | `roles/webapp/defaults/main.yml`   |
| `extra-vars` (`-e`)    | Highest                   | `ansible-playbook -e "debug=true"` |

### Rules

1. Use descriptive names (`app_version`, `db_host`).
2. Avoid hard‑coding sensitive data – use Vault.
3. Prefer `{{ variable | default('value') }}` to avoid undefined errors.

---

## 3. Handlers

### Basic Handler Pattern
Handlers are triggered by tasks with `notify`. They run at the end of the play, even if multiple tasks notify them.

* The first letter of the handler name must be uppercase.
* Keep handler names descriptive using lowercase with underscores: `Restart_sshd`, `Reload_nginx`.
* Always use a `notify` handler pattern rather than running commands directly.

```yaml
- name: Update nginx config
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx

- name: Restart SSH if config changed
  ansible.builtin.copy:
    src: sshd_config
    dest: /etc/ssh/sshd_config
  notify:
    - Restart sshd
```

### Advanced Handler Patterns

#### Debounce Multiple Notifications
Multiple tasks can notify the same handler - it runs only once per play.

#### Dynamic Service Name Detection
Handles service name differences across distributions (sshd vs ssh):

```yaml
# handlers/main.yml
- name: Gather service facts
  ansible.builtin.service_facts:

- name: Restart sshd
  ansible.builtin.service:
    name: "{{ ssh_service_name }}"
    state: restarted

# In your role variable detection task:
- name: Detect SSH service name
  ansible.builtin.set_fact:
    ssh_service_name: >-
      {{ 'sshd' if 'sshd.service' in ansible_facts.services
         else 'ssh' }}
```

#### Conditional Handler Execution
```yaml
- name: Update configuration
  ansible.builtin.template:
    src: config.conf.j2
    dest: /etc/app/config.conf
  notify: Restart app

- name: Restart application (only if changed)
  ansible.builtin.service:
    name: "{{ app_service_name }}"
    state: restarted
  notify: Restart app
  when: config_changed | changed
```

---

## 4. Idempotency

* Use modules instead of shell commands when possible.
* Modules have built‑in checks – they only apply changes when needed.
* Example: `apt` module with `state=latest` ensures the package is present.

```yaml
- name: Ensure nginx is latest
  ansible.builtin.apt:
    name: nginx
    state: latest
```

---

## 5. Conditional Execution

```yaml
- name: Install developer tools on Debian
  ansible.builtin.apt:
    name: "{{ dev_tools }}"
    state: present
  when: ansible_facts['os_family'] == 'Debian'
```

* Use `ansible_facts` to adapt playbooks to the target OS.
* Prefer `when` over `--skip-tags` in roles; tags are for selective runs.

---

## 6. Looping

* Prefer `loop` over `with_*` (deprecated - `with_items`, `with_list`, etc.).
* Always use `loop_control` with `label` for cleaner output in large loops.
* For nested loops, use `index_var` to track iteration.

```yaml
# Simple loop with label
- name: Install packages
  ansible.builtin.apt:
    name: "{{ item }}"
    state: present
  loop: "{{ dev_packages }}"
  loop_control:
    label: "{{ item }}"

# Nested loop with index tracking
- name: Create users with SSH keys
  ansible.builtin.user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.groups }}"
  loop: "{{ users }}"
  loop_control:
    index_var: user_index
    label: "{{ item.name }}"

# With loop_var for clarity
- name: Install services
  ansible.builtin.service:
    name: "{{ svc_name }}"
    state: started
  loop: "{{ services }}"
  loop_control:
    loop_var: svc_name
    label: "{{ svc_name }}"
```

---

## 7. Tags

* Tag tasks that are expensive (long-running) or rarely needed.
* Use descriptive tag names following kebab-case: `install-packages`, `configure-firewall`.
* Use `--tags` for selective runs, `--skip-tags` to exclude.

```yaml
# Basic tag
- name: Install Docker
  ansible.builtin.apt:
    name: docker.io
    state: present
  tags:
    - install-packages

# Multiple tags
- name: Configure firewall rules
  ansible.builtin.iptables:
    chain: INPUT
    protocol: tcp
    destination_port: "{{ item }}"
    jump: ACCEPT
  loop:
    - 22
    - 80
    - 443
  tags:
    - configure-firewall
    - security

# Using tags in practice:
# ansible-playbook play.yml --tags "install-packages,configure-firewall"
# ansible-playbook play.yml --skip-tags "test-only"
```

---

## 8. File and Template Management

### Best Practices:
* Keep templates in `templates/` and static files in `files/`
* Use `ansible_managed` header in templates to show they're managed by Ansible
* Always escape user input with Jinja2 filters: `| quote`, `| to_json`, `| to_nice_json`
* Use `default()` filter to avoid undefined variable errors

### Template Headers (Add to all templates):
```jinja
# {{ ansible_managed }}
# Role: {{ role_name | default('unknown') }}
# Modified: {{ ansible_date_time.iso8601 | default('unknown') }}
```

### Example: SSH config template
```jinja
# {{ ansible_managed }}
# SSH Configuration - Managed by Ansible
# Wazuh Compliance: Rules 35640-35661

Port {{ ssh_port | default(22) }}
PasswordAuthentication {{ ssh_password_auth | default('no') | lower }}
PermitRootLogin {{ ssh_permit_root | default('no') | lower }}
MaxAuthTries {{ ssh_max_auth_tries | default(4) }}
```

---

## 9. Error Handling

### Use block/rescue/always for failure management:
* **block**: Tasks that might fail
* **rescue**: What to do when block fails
* **always**: Always run, even if block succeeds

```yaml
- block:
    - name: Create user account
      ansible.builtin.user:
        name: "{{ user_name }}"
        state: present
        groups: "{{ user_groups | default('users') }}"
    
    - name: Set user password
      ansible.builtin.user:
        name: "{{ user_name }}"
        password: "{{ user_password | password_hash('sha512') }}"
  rescue:
    - name: Log error and cleanup
      ansible.builtin.debug:
        msg: "User creation failed for {{ user_name }}"
    
    - name: Remove partial user creation
      ansible.builtin.user:
        name: "{{ user_name }}"
        state: absent
        remove: yes
      when: user_name is defined
  always:
    - name: Record task completion
      ansible.builtin.debug:
        msg: "User management task completed for {{ user_name }}"
```

### Best Practices:
* Use `ignore_errors: true` sparingly - only when you expect and handle failures
* Use `failed_when` for custom failure conditions
* Use `changed_when` to control reported state
* Always log errors with descriptive messages

### Example: Custom failure condition
```yaml
- name: Check if service is running
  ansible.builtin.command: systemctl is-active {{ service_name }}
  register: service_check
  failed_when: service_check.rc not in [0, 3]  # 0=active, 3=inactive
  changed_when: false
```

---

## 17. Fully Qualified Collection Names (FQCN)

* Always use FQCN for modules: `ansible.builtin.apt` instead of `apt`
* Ensures compatibility across Ansible versions
* Makes it clear which collection a module belongs to
* Required for future-proofing as Ansible evolves

### Examples:
```yaml
# ❌ OLD: Short names (deprecated style)
- name: Install package
  apt:
    name: nginx
    state: present

# ✅ NEW: Fully Qualified Collection Names
- name: Install package
  ansible.builtin.apt:
    name: nginx
    state: present

# Collections must be installed first
- name: Install collection
  ansible-galaxy collection install community.general

# Using community.general modules
- name: Set timezone
  community.general.timezone:
    name: "{{ timezone }}"
```

---

## 10. Testing & Linting

| Tool           | Usage                                            |
|----------------|--------------------------------------------------|
| `ansible-lint` | `ansible-lint playbook.yml`                      |
| `molecule`     | Test roles with containers or VMs.               |
| `yamllint`     | `yamllint -c .yamllint .`                        |
| `ansible-test` | Integration testing with `ansible-test sanity`   |

### Best Practices:
* Run `ansible-lint` in CI/CD pipelines with strict mode
* Use `molecule` for role-level testing with scenarios
* Configure `.ansible-lint.yaml` in your project root
* Add `--parseable` flag for CI integration

Example `.ansible-lint.yaml`:
```yaml
profile: production
strict: true
exclude_paths:
  - .idea/
  - .vscode/
  - tmp/
skip_list:
  - yaml[line-length]
warn_list:
  - experimental
  # - fqcn-builtins  # Enable when all modules use FQCN
```

---

## 11. Security

### Ansible Vault
* Use `ansible-vault encrypt_string` for inline secrets
* Use `ansible-vault edit secrets.yml` for encrypted files
* Store vault password in `VAULT_PASSWORD_FILE` or `.vault_password`
* Never commit unencrypted secrets to version control

### Best Practices:
* Use `no_log: true` for tasks with sensitive output
* Use `no_log: true` with `register:` variables containing secrets
* Use `changed_when: false` for fact-gathering tasks to reduce noise
* Run with `--ask-vault-pass` or use `VAULT_PASSWORD_FILE` environment variable

```yaml
# Secure vault usage
- name: Get database password from vault
  ansible.builtin.set_fact:
    db_password: "{{ vault_db_password }}"
  vars:
    vault_db_password: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      66386439313934663165313232666532...

# Hiding sensitive output
- name: Set password (hide in logs)
  ansible.builtin.debug:
    msg: "User {{ username }} created with password {{ temp_password }}"
  no_log: true

# Using environment variable for vault password
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_password
ansible-playbook play.yml
```

---

## 12. Documentation

### Role README.md Template
Each role **MUST** include a `README.md` with:

```markdown
# Role Name

## Description
Short description of what this role does.

## Requirements
Any special system requirements or dependencies.

## Role Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `example_var` | `value` | What this variable does |

## Dependencies
List of other roles this role depends on.

## Example Playbook
```yaml
- hosts: servers
  roles:
    - { role: example-role, when: ansible_facts['os_family'] == 'Debian' }
```

## License
MIT

## Author Information
Your name/team
```

### Best Practices:
* Keep playbooks short and delegating to roles
* Document all variables with defaults and descriptions
* Include example usage for common scenarios
* List required Ansible version in `meta/main.yml`

---

## 13. Performance

### Fact Gathering
* Use `gather_facts: false` when facts aren't needed
* Use `gather_subset: ['min']` for minimal facts when possible
* Cache facts with `cache_facts: true` for large inventories

### Concurrency
* Use `serial: N` to process hosts in batches
* Use `max_fail_pct: N` to stop when failure threshold reached

### Best Practices:
```yaml
# Disable facts when not needed
- hosts: all
  gather_facts: false

# Minimal facts
- hosts: all
  gather_facts: true
  gather_subset:
    - min
    - network

# Batch processing with serial
- hosts: all
  gather_facts: true
  serial: 5  # Process 5 hosts at a time
  max_fail_pct: 25  # Stop if >25% fail

# Cached facts for large inventories
- hosts: all
  gather_facts: true
  cache_facts: true
  facts_inventory:
    - all
```

---

## 14. Common Pitfalls

### Anti-Patterns and Solutions

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Using `shell`/`command` | Non-idempotent, platform-specific | Use Ansible modules (`apt`, `yum`, `copy`, `template`) |
| Hard-coding paths | Fails on different systems | Use `{{ ansible_env.HOME }}`, `{{ playbook_dir }}`, `{{ role_path }}` |
| Missing `become` | Privilege escalation fails | Add `become: true` or `become_user: user` |
| Incorrect `when` logic | Tasks run on wrong hosts | Use `ansible_facts` variables with `when` |
| Direct service management | Service name varies by distro | Use dynamic service name detection |

### Examples:
```yaml
# ❌ BAD: Using shell for package management
- name: Install package (non-idempotent)
  ansible.builtin.shell: apt-get install -y nginx

# ✅ GOOD: Using apt module
- name: Install nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

# ❌ BAD: Hard-coded path
- name: Create file in home
  ansible.builtin.copy:
    content: "data"
    dest: /home/user/data.txt

# ✅ GOOD: Using ansible_env
- name: Create file in home
  ansible.builtin.copy:
    content: "data"
    dest: "{{ ansible_env.HOME }}/data.txt"

# ❌ BAD: Service without become
- name: Restart nginx
  ansible.builtin.service:
    name: nginx
    state: restarted

# ✅ GOOD: With become
- name: Restart nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
  become: true
```

---

## 15. Reference

* Ansible Official Docs: https://docs.ansible.com/ansible/latest/index.html
* Ansible Lint Rules: https://ansible-lint.readthedocs.io/en/latest/rules.html
* Molecule Testing: https://molecule.readthedocs.io/en/latest/

---

## 16. Quick Start Checklist

### Before Running Playbooks
- [ ] `ansible-lint playbook.yml` passes with 0 errors
- [ ] `ansible-playbook --syntax-check playbook.yml` succeeds
- [ ] `ansible-playbook -C playbook.yml` (dry-run) shows expected changes
- [ ] All roles have `meta/main.yml` with dependencies listed
- [ ] All roles have `README.md` documenting variables and usage

### Role Development Checklist
- [ ] Role has `defaults/main.yml` with default values
- [ ] Role has `vars/main.yml` if hardcoded values needed (rare)
- [ ] All tasks use FQCN (e.g., `ansible.builtin.apt`)
- [ ] All templates in `templates/`, all static files in `files/`
- [ ] All handlers in `handlers/main.yml` with descriptive names
- [ ] Role has `meta/main.yml` with `galaxy_info` and `dependencies`
- [ ] README.md includes: purpose, variables, dependencies, usage example

### Performance Tips
- Use `serial: N` for large host groups to limit concurrency
- Set `gather_facts: false` if facts not needed
- Use `cache_facts: true` for large fact collections
- Use `--diff` flag to see file changes clearly