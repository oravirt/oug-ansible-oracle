host-config-storage
=========

Paritions and creates ASMlib label on devices.


Dependencies
--------------
The 'asm_diskgroups' structure is used by a number of other roles, and should always be present under group_vars/<environment>


Role Variables
--------------

The following is needed for the attributes to be picked up properly

```
gi_versions:
  12102-2017-08:
    version: 12.1.0.2
```

This is the structure for managing disks and diskgroups
**The following is just an example**

```
asm_diskgroups:
  - diskgroup: crs
    properties:
      - {redundancy: normal, ausize: 4}
    attributes:
      - {name: compatible.rdbms, value: 12.1.0.2}
      - {name: compatible.asm, value: "{{ gi_versions[gi_version]['version'] }}"}
    disk:
      - {device: /dev/mapper/12398748192398740123, asmlabel: crs01}
      - {device: /dev/mapper/12398748192398740a21, asmlabel: crs02}
      - {device: /dev/mapper/1239874819239cqw3740, asmlabel: crs03}
  - diskgroup: data
    properties:
      - {redundancy: external, ausize: 4}
    attributes:
      - {name: compatible.rdbms, value: 12.1.0.2}
      - {name: compatible.asm, value: "{{ gi_versions[gi_version]['version'] }}"}
    disk:
      - {device: /dev/sdf, asmlabel: data01}
      - {device: /dev/sdg, asmlabel: data02}
  - diskgroup: fra
    properties:
      - {redundancy: external, ausize: 4}
    attributes:
      - {name: compatible.rdbms, value: 12.1.0.2}
      - {name: compatible.asm, value: "{{ gi_versions[gi_version]['version'] }}"}
    disk:
      - {device: /dev/sdh, asmlabel: fra01}
```

Example Playbook
----------------


```
    - hosts: oc3swe1
      become: True
      become_user: root
      roles:
         - { role: host-config-storage}
```
Author Information
------------------
Mikael Sandström, mikael.sandstrom@kindredgroup.com
