```text
project_root/
├─ inventories/            # Separate inventories per environment
├─ group_vars/             # Group variables
├─ host_vars/              # Host specific variables
├─ roles/
│  ├─ my_role/
│  │  ├─ tasks/
│  │  ├─ handlers/
│  │  ├─ templates/
│  │  ├─ files/
│  │  ├─ defaults/
│  │  ├─ vars/
│  │  ├─ meta/
│  │  └─ README.md
│  └─ ...
├─ playbooks/
│  ├─ site.yml
│  └─ other.yml
├─ ansible.cfg
└─ requirements.yml
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

* Handlers are triggered by tasks with `notify`.
* Keep handler names descriptive: `restart nginx`, `reload sshd`.
* Register a variable in a task and notify handler based on its value.

```yaml
- name: Update nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: reload nginx

- name: Restart SSH if config changed
  copy:
    src: sshd_config
    dest: /etc/ssh/sshd_config
  notify:
    - restart sshd
```

---

## 4. Idempotency

* Use modules instead of shell commands when possible.
* Modules have built‑in checks – they only apply changes when needed.
* Example: `apt` module with `state=latest` ensures the package is present.

```yaml
- name: Ensure nginx is latest
  apt:
    name: nginx
    state: latest
```

---

## 5. Conditional Execution

```yaml
- name: Install developer tools on Debian
  apt:
    name: "{{ dev_tools }}"
    state: present
  when: ansible_facts['os_family'] == 'Debian'
```

* Use `ansible_facts` to adapt playbooks to the target OS.
* Prefer `when` over `--skip-tags` in roles; tags are for selective runs.

---

## 6. Looping

* Prefer `loop` over `with_*` (deprecated).
* Use `loop_control` to control output.

```yaml
- name: Install packages
  apt:
    name: "{{ item }}"
    state: present
  loop: "{{ dev_packages }}"
  loop_control:
    label: "{{ item }}"
```

---

## 7. Tags

* Tag tasks that are expensive or rarely needed.
* Run with `--tags=install,configure`.

```yaml
- name: Install Docker
  apt:
    name: docker.io
    state: present
  tags:
    - install
```

---

## 8. File and Template Management

* Keep templates in `templates/` and files in `files/`.
* Use Jinja2 syntax; always escape user input with filters.
* Example template:

```jinja
# /etc/ssh/sshd_config
Port {{ ssh_port | default(22) }}
PasswordAuthentication {{ ssh_password_auth | default('no') }}
```

---

## 9. Error Handling

* Use `block`/`rescue`/`always` to manage failure scenarios.
* Log messages for debugging.

```yaml
- block:
    - name: Create user
      user:
        name: "{{ user_name }}"
        state: present
  rescue:
    - name: Fail with message
      fail:
        msg: "Could not create user {{ user_name }}"
```

---

## 10. Testing & Linting

| Tool           | Usage                              |
|----------------|------------------------------------|
| `ansible-lint` | `ansible-lint playbook.yml`        |
| `molecule`     | Test roles with containers or VMs. |
| `yamllint`     | `yamllint -c .yamllint .`          |

Add a `.ansible-lint` configuration to ignore known issues.

---

## 11. Security

* Use Ansible Vault for secrets (`ansible-vault encrypt_string`).
* Never expose passwords in playbooks or roles.
* Use `no_log: true` for sensitive output.

```yaml
- name: Retrieve API key
  uri:
    url: https://api.example.com/key
    method: GET
  no_log: true
```

---

## 12. Documentation

* Each role should have a `README.md` describing:
  * Purpose
  * Required variables
  * Example usage
  * Dependencies

* Keep playbooks short; refer to role README for details.

---

## 13. Performance

* Use `serial` to limit concurrency if the host group is large.
* Cache facts (`gather_facts: true`) only when necessary.

```yaml
- hosts: all
  gather_facts: true
  serial: 5
```

---

## 14. Common Pitfalls

1. **Using `shell` over modules** – leads to non‑idempotent behavior.
2. **Hard‑coding paths** – use `{{ ansible_env.HOME }}` or `{{ playbook_dir }}`.
3. **Missing `become`** – for privileged tasks.
4. **Not using `when` properly** – can cause tasks to run on unintended hosts.

---

## 15. Reference

* Ansible Official Docs: https://docs.ansible.com/ansible/latest/index.html
* Ansible Lint Rules: https://ansible-lint.readthedocs.io/en/latest/rules.html
* Molecule Testing: https://molecule.readthedocs.io/en/latest/