# password_inactivity

**Author:** Patricio Rojas Ortiz
**Version:** 1.0.0  
**Description:**  


This role guarantees that the *default* password inactivity period is set to **45 days or less** and that all existing accounts that violate this policy are corrected.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `password_inactivity_default` | `45` | The maximum number of days a password may remain inactive.  The value must be **≤ 45**. |

## Tasks

1. **Set the default inactivity period**  
   `useradd -D -f 45` – this command updates the system‑wide default inactivity period.  
   The task is idempotent because the command will only change the value if it is larger than the desired value.

2. **Correct existing accounts**  
   The `awk` command scans `/etc/shadow` and runs `chage --inactive 45 <user>` for every account whose current inactivity value is greater than 45 or unset (`< 0`).  
   This guarantees that every user account complies with the policy.

## Usage

```yaml
- hosts: all
  become: true
  roles:
    - lock_inactive_password
