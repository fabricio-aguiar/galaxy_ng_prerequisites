![Pulp CI](https://github.com/fabricio-aguiar/galaxy_ng_prerequisites/workflows/Galaxy%20CI/badge.svg)

Galaxy NG prerequisites
===============================

This role installs prerequisites for galaxy-ng plugin use, when installed by
ansible-pulp.

Requirements
------------

Each currently supported operating system has a matching file in the "vars"
directory.

Installation
------------

Install in the [ansible role search path](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-search-path)
as the foldername `pulp.galaxy_ng_prerequisites`, by either:
*. `ansible-galaxy install pulp.galaxy_ng_prerequisites -p ./roles/`
*. Cloning this repo, and symlinking it as pulp.galaxy_ng_prerequisites

Example Playbook
----------------

Here's an example playbook for using galaxy_ng_prerequisites as part of ansible-pulp.

    ---
    - hosts: all
      vars:
        pulp_default_admin_password: password
        pulp_settings:
          secret_key: secret
        pulp_install_plugins:
          galaxy-ng:
            prereq_role: "pulp.galaxy_ng_prerequisites"
      roles:
        - pulp-database
        - pulp-workers
        - pulp-resource-manager
        - pulp-webserver
        - pulp-content
      environment:
        DJANGO_SETTINGS_MODULE: pulpcore.app.settings

License
-------

GPLv2+

Author Information
------------------

Pulp Team
