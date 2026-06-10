#### Role name:
    disable_overlayfs

#### Wazuh ID:
    35723

#### Title:
    Disable overlay and overlayfs kernel modules to enhance security posture

#### Description:
    This role disables the `overlay` and `overlayfs` kernel modules by blacklisting them via modprobe configuration, preventing their loading at boot or runtime. It ensures idempotent enforcement of module unavailability.

#### Rationale:
    Overlay filesystems (e.g., Docker’s overlay2) can introduce attack surface if not required; disabling unused modules reduces the system’s attack surface and mitigates potential exploitation via kernel-level vulnerabilities in these modules.

#### Remediation:
    Add `blacklist overlay` and `blacklist overlayfs` to modprobe configuration files (e.g., `/etc/modprobe.d/blacklist-overlay.conf`) or use `install /bin/true` directives. This role implements blacklisting via modprobe configuration and ensures modules are not loaded by removing them from initramfs if needed.

#### Requirements
    - Ansible 2.9 or higher  
    - `become: yes` required (to write to `/etc/modprobe.d/`, modify initramfs, and manage kernel modules)  
    - OS: Linux distributions using modprobe (e.g., RHEL/CentOS, Debian/Ubuntu, SUSE)  
    - Required Ansible modules: `ansible.builtin.shell`, `ansible.builtin.template`, `ansible.builtin.lineinfile`, `ansible.builtin.file`  

#### Variables

### defaults/main.yml
| Variable                           | Default                                | Description                                                                               |
|------------------------------------|----------------------------------------|-------------------------------------------------------------------------------------------|
| `disable_overlayfs_enabled`        | `true`                                 | Controls whether the role enforces module blacklisting. Set to `false` to skip execution. |
| `disable_overlayfs_modules`        | `['overlay', 'overlayfs']`             | List of kernel modules to blacklist.                                                      |
| `disable_overlayfs_blacklist_file` | `/etc/modprobe.d/disable-overlay.conf` | Path to the modprobe configuration file where blacklists will be written.                 |

### vars/main.yml
| Variable               | Default  | Description                |
|------------------------|----------|----------------------------|
| `overlay_module_name`  | overlay  | overlay kernel module name |


#### Dependencies
    None

#### Handlers
    None

#### Compliance mapping
    - CIS Benchmark: Controls related to kernel module restrictions (e.g., 1.5.1–1.5.4 on RHEL/CentOS)
    - NIST 800-53: SC-4(1) (Restriction of kernel modules), SI-2 (Flaw remediation)
    - PCI DSS: Requirement 6.2 (Vulnerability identification)

#### Mitre
    - T1547.006 (Kernel Modules and Extensions) — *Mitigation: Disable unnecessary kernel modules*
    - T1543.003 (Systemd Services) — *Not directly applicable, but module blacklisting serves similar control*

#### Conditions
    - Role executes only if `disable_overlayfs_enabled == true`
    - Module loading is prevented via modprobe configuration (`blacklist` or `install /bin/true`)
    - Idempotency ensured: no changes if modules already blacklisted and not loaded

#### Rules
    - `c:lsmod | grep overlay` → should return empty (module not loaded)
    - `c:cat /etc/modprobe.d/disable-overlay.conf` → must contain `blacklist overlay` and `blacklist overlayfs`
    - `c:grep -E '^(install|blacklist)\s+(overlay|overlayfs)' /etc/modprobe.d/*.conf` → must match expected directives

#### Usage

```yaml
- hosts: all
  become: yes
  roles:
    - disable_overlayfs
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas 