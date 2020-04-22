#!/bin/bash
# wrapper for inserting galaxy_ng_prerequisites into the pulp_installer CI
set -x
# COMMIT_MSG is only set if a PR
export PULP_ROLES_PR_NUMBER=$(echo $COMMIT_MSG | grep -oP 'Required\ PR:\ https\:\/\/github\.com\/pulp\/pulp_installer\/pull\/(\d+)' | awk -F'/' '{print $7}')

cd ..
if [ ! -e pulp_installer ]; then
  git clone https://github.com/pulp/pulp_installer
  if [ -n "$PULP_ROLES_PR_NUMBER" ]; then
    cd pulp_installer
    git fetch --depth=1 origin pull/$PULP_ROLES_PR_NUMBER/head:$PULP_ROLES_PR_NUMBER
    git checkout $PULP_ROLES_PR_NUMBER
    cd ..
  fi
fi
cd pulp_installer
if [ ! -e roles/pulp.galaxy_ng_prerequisites ]; then
  ln -s $GITHUB_WORKSPACE roles/pulp.galaxy_ng_prerequisites
fi

find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.source_dir \/var\/lib\/pulp\/devel\/galaxy_ng" \;
find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.git_repo https:\/\/github.com\/ansible\/galaxy_ng.git" \;
find ./molecule/*upgrade*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.upgrade true" \;
find ./molecule/*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.galaxy-ng.prereq_role pulp.galaxy_ng_prerequisites" \;
find ./molecule/*/group_vars/all -exec sed -i 's/pulp-file/pulp-ansible/g' {} \;
find ./molecule/*/group_vars/all -exec sed -i 's/pulp_file/pulp_ansible/g' {} \;
find ./molecule/*release*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-ansible.version 0.2.0b11" \;
find ./molecule/*release*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp_version.version 3.2.1" \;
find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-ansible.git_commitish 0.2.0b11" \;
find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_git_commitish 3.2" \;

# Show modified vars
find ./molecule/source-{static,dynamic}/group_vars/all -exec sh -c "echo; echo {}; cat {}" \;

tox
