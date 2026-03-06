# Ansible Role: Wazuh Rsyslog Rule

This role ensures that the rsyslog service is enabled and started on boot, complying with Wazuh's logging requirements.

## Requirements

- Ansible 2.9 or higher

## Role Variables

None by default.

## Dependencies

No dependencies.

## Example Playbook

```yaml
- hosts: all
  roles:
    - ansible-role-wazuh-rules****
