static-routes
=========

This role can be used to configure static routes

Requirements
------------

None

Role Variables
--------------

static_routes should contain the desired set of static routes

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      vars:
        static_routes:
          - "any net 10.16.0.0/16 gw {{ ansible_default_ipv4.gateway }}"
      roles:
         - kostyrevaa.static-routes

License
-------

BSD

Contributing
------------------
 When send PR make sure your changes are backward-compatible.

Author Information
------------------

Aleksandr Kostyrev
