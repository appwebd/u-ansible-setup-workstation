# Ansible Workstation Setup

![Static Badge](https://img.shields.io/badge/OS-Ubuntu%2024-red%3Flogo%3Dubuntu)
![Ansible](https://img.shields.io/badge/Ansible-2.x-black?logo=ansible)
![Hardening](https://img.shields.io/badge/Security-Hardening-green)

Este proyecto automatiza la preparación, hardening y personalización de una
estación de trabajo basada en **Ubuntu 24.04**.  

Se sigue la guía de hardening de *Lynis* y *Wazuh*, y se instala un conjunto
de herramientas críticas de auditoría, detección de intrusos y control de
acceso.

---

## 🚀 Instalación y uso

1. **Instalar Ansible**  
   Si no lo tienes ya instalado, ejecuta el script incluido:

```bash
    bash bin/install-ansible.sh
```

## Clonar el repositorio
```bash
   git clone https://github.com/appwebd/u-ansible-setup-workstation.git
   cd u-ansible-setup-workstation
```

## Configurar vault
Ansible utiliza ansible-vault para manejar las variables sensibles. En este caso se empleará para generar una contraseña para tripwire

```bash
   # Crear el vault y los archivos de variables
   cd roles/setup_tripwire/vars/
   ansible-vault create main.yml
```

Guarda la contraseña maestra que has empleado en ansible-vault en el archivo '.vault_password':

```bash
    echo "tu_contraseña_maestra" > .vault_password
    export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
```
esto se hace mas que nada para automatizar la revisión de ansible-lint para que no consulte la contraseña del rol que la está empleando.

## Estructura del proyecto

```text
.
├── bin/                     # Scripts auxiliares (install-ansible, wrappers, lint, etc.)
├── inventory/               # Archivos de inventario de Ansible
├── playbooks/               # Playbooks de alto nivel
│   ├── setup_workstation.yaml
│   ├── update_upgrade.yaml
│   ├── remove_bloatware_packages.yaml
│   ├── remove_unused_accounts_groups.yaml
│   ├── shutdown.yaml
├── roles/                   # Roles de Ansible
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
├── .ansible/                # Caché de Ansible
├── .vault_password          # Contraseña maestra para Ansible Vault
└── README.md
```

## Principales tareas en playbooks

| Tarea                                           | Script                                                   |
|-------------------------------------------------|----------------------------------------------------------|
| Asegurar que los playbooks siguen los estándares| `bash bin/run_ansible_lint.sh`                           |
| Actualizar paquetes en varios servidores        | `bash bin/run_update_upgrade.sh                          |
| Apagar varios servidores                        | `bash bin/run_shutdown.sh`                               |
| Limpieza de software bloatware en ubuntu        | `bash bin/run_remove_bloatware_packages.sh`              |
| Configurar SSH                                  | `bash bin/setup_ssh_key_authentication.sh`               |


## Principales roles

|  rol   | Propósito | Archivo clave |
|--------|-----------|---------------|
| `hardening_debian`  | Aplicar configuraciones de hardening de kernel, sysctl y appArmor | `tasks/main.yml` |
| `sshd` | Hardening de SSH (permitidos solo key‑based, port, banner, etc.) | `tasks/main.yml` |
| `sudo` | Configurar permisos de sudo y política de expiración | `tasks/main.yml` |
| `fail2ban` | Protección contra intentos de login fallidos | `tasks/main.yml` |
| `tripwire` | Instalación y configuración de Tripwire para detección de cambios | `tasks/main.yml` |
| `rkhunter` | Instalación y ejecución de Rootkit Hunter | `tasks/main.yml` |
| `auditd` | Configuración de auditd y reglas de auditoría | `tasks/main.yml` |
| `aide` | Instalación y configuración de AIDE | `tasks/main.yml` |
| `unattended_upgrades` | Automatizar parches de seguridad | `tasks/main.yml` |
| `gnome` | Configuración de escritorio (banners, wallpaper, etc.) | `tasks/main.yml` |
| `remove_bloatware_packages` | Eliminar paquetes innecesarios | `tasks/main.yml` |
| `remove_unused_accounts_groups` | Limpiar cuentas y grupos no usados | `tasks/main.yml` |
| `update_upgrade` | Ejecutar `apt update` y `apt upgrade | `tasks/main.yml` |


##  Revisión de sintaxis de ansible lint

Para asegurar que los playbooks siguen los estándares:

```bash
# Ejecutar ansible-lint sobre todos los playbooks
bash bin/run_ansible_lint.sh
```

## 📚 Recursos y documentación

- [Ansible Official Docs](https://docs.ansible.com/)
- [Lynis Hardening Guide](https://cisofy.com/lynis/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Debian Hardening](https://wiki.debian.org/SecureDebootstrap)
- [Ubuntu Security Standard](https://ubuntu.com/security/security-standards)
- [Ubuntu hardening](https://ubuntu.com/engage/a-guide-to-infrastructure-hardening)

## 📜 Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.
