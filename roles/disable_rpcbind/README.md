#### Role name:
    disable_rpcbind

#### Wazuh ID:
    35572

#### Title:
    Ensure rpcbind services are not in use.

#### Description:
    The rpcbind utility maps RPC services to the ports on which they listen. RPC processes notify rpcbind when they start, registering the ports they are listening on and the RPC program numbers they expect to serve. The client system then contacts rpcbind on the server with a particular RPC program number. The rpcbind.service redirects the client to the proper port number so it can communicate with the requested service. Portmapper is an RPC service, which always listens on tcp and udp 111, and is used to map other RPC services (such as nfs, nlockmgr, quotad, mountd, etc.) to their corresponding port number on the server. When a remote host makes an RPC call to that server, it first consults with portmap to determine where the RPC server is listening.

#### Rationale:
    A small request (~82 bytes via UDP) sent to the Portmapper generates a large response (7x to 28x amplification), which makes it a suitable tool for DDoS attacks. If rpcbind is not required, it is recommended to remove rpcbind package to reduce the potential attack surface.

#### Remediation:
    Run the following commands to stop rpcbind.socket and rpcbind.service, and remove the rpcbind package:  
    `# systemctl stop rpcbind.socket rpcbind.service`  
    `# apt purge rpcbind`  
    - OR -  
    If the rpcbind package is required as a dependency:  
    Run the following commands to stop and mask rpcbind.socket and rpcbind.service:  
    `# systemctl stop rpcbind.socket rpcbind.service`  
    `# systemctl mask rpcbind.socket rpcbind.service`

#### Requirements
    - Ansible 2.16 or higher (required for robust `package_facts` and systemd module behavior)
    - `become: yes` required (to modify system packages, services, or configuration files)
    - OS: Debian/Ubuntu (inferred from use of `ansible.builtin.apt` in tasks)
    - Required Ansible collections/modules: `ansible.builtin.package_facts`, `ansible.builtin.systemd`, `ansible.builtin.apt`, `ansible.builtin.command`, `ansible.builtin.fail`

#### Variables

### defaults/main.yml

| Variable          | Default  | Description                                                                                                                  |
|-------------------|----------|------------------------------------------------------------------------------------------------------------------------------|
| `rpcbind_enabled` | `false`  | If `true`, only stop and mask rpcbind services (leaving package installed); if `false`, remove the rpcbind package entirely. |

### vars/main.yml
| Variable                | Default                                 | Description                                                                                         |
|-------------------------|-----------------------------------------|-----------------------------------------------------------------------------------------------------|
| `rpcbind_packages`      | `["rpcbind"]`                           | List of package names to manage; used for detection and removal logic.                              |
| `rpcbind_services`      | `["rpcbind.socket", "rpcbind.service"]` | List of systemd service/socket units to stop and mask when rpcbind is not enabled or after removal. |
| `rpcbind_service_name`  | `rpcbind`                               | Name of the rpcbind service to manage                                                               |

#### Dependencies
    Handlers: `handlers/main.yml` *(present but empty — no handlers defined)*  
    Dependencies on other roles: *none*

#### Compliance mapping
    cmmc: ['CM.L2-3.4.7', 'CM.L2-3.4.8', 'SC.L2-3.13.6']  
    fedramp: ['CM-2', 'CM-3', 'CM-6', 'CM-7']  
    gdpr: ['32']  
    hipaa: ['164.308(a)(1)']  
    iso_27001: ['A.12.1.1', 'A.12.1.2', 'A.14.2.1']  
    nis2: ['21.2.e', '21.2.a']  
    nist_800_171: ['3.4.7', '3.4.8', '3.13.6']  
    nist_800_53: ['CM-2', 'CM-3', 'CM-6', 'CM-7']  
    pci_dss: ['1.1', '1.2', '2.2', '6.4']  
    tsc: ['CC6.3', 'CC6.6', 'CC8.1', 'CC5.1', 'CC5.2', 'CC5.3']

#### Mitre
    tactic: ['TA0005']  
    technique: ['T1036', 'T1564']

#### Conditions
    any

#### Rules
    c:dpkg-query -s rpcbind -> r:package 'rpcbind' is not installed  
    not c:systemctl show rpcbind.socket rpcbind.service -> r:^LoadState=loaded\|^ActiveState=active

#### Usage

```code
- hosts: servers
  become: yes
  roles:
    - disable_rpcbind
```

#### License
    Apache 2.0

#### Author
    Patricio Rojas Ortiz
