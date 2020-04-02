#!/bin/bash
# wrapper for inserting galaxy_ng_prerequisites into the ansible-pulp CI
cd ..
if [ ! -e ansible-pulp ]; then
  git clone https://github.com/pulp/ansible-pulp
fi
cd ansible-pulp
if [ ! -e roles/pulp.galaxy_ng_prerequisites ]; then
  ln -s $GITHUB_WORKSPACE roles/pulp.galaxy_ng_prerequisites
fi

find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.source_dir \/var\/lib\/pulp\/devel\/galaxy_ng" \;
find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.git_repo https:\/\/github.com\/ansible\/galaxy_ng.git" \;
find ./molecule/*upgrade*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.upgrade true" \;
find ./molecule/*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.prereq_role pulp.galaxy_ng_prerequisites" \;
find ./molecule/*/group_vars/all -exec sed -i 's/pulp-file/pulp-ansible/g' {} \;
find ./molecule/*/group_vars/all -exec sed -i 's/pulp_file/pulp_ansible/g' {} \;


# For now, we will only run source scenarios
sudo rm -rf ./molecule/*upgrade*/
sudo rm -rf ./molecule/*default*/
sudo rm -rf ./molecule/dynamic/
sed -i '/-s default/d' tox.ini
sed -i '/-s dynamic/d' tox.ini

# Show modified vars
find ./molecule/*/group_vars/all -exec sh -c "echo; echo {}; cat {}" \;

tox
