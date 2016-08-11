#!/bin/bash

# Parse command-line arguments
# Source: http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
INSTALL_ANSIBLE="true"
CLONE_REPO="true"
EDIT_CONFIG="true"
RUN_PLAYBOOK="true"
while [[ $# -gt 0 ]]
do
  KEY="$1"
  case $KEY in
    -i|--install-ansible)
    INSTALL_ANSIBLE="true"
    ;;
    -I|--skip-install-ansible)
    INSTALL_ANSIBLE="false"
    ;;
    -c|--clone-repo)
    CLONE_REPO="true"
    ;;
    -C|--skip-clone-repo)
    CLONE_REPO="false"
    ;;
    -e|--edit-config)
    EDIT_CONFIG="true"
    ;;
    -E|--skip-edit-config)
    EDIT_CONFIG="false"
    ;;
    -p|--run-playbook)
    RUN_PLAYBOOK="true"
    ;;
    -P|--skip-run-playbook)
    RUN_PLAYBOOK="false"
    ;;
    *)
    # unknown option
    ;;
  esac
  shift # past argument or value
done

echo "INSTALL_ANSIBLE: $INSTALL_ANSIBLE"
echo "CLONE_REPO: $CLONE_REPO"
echo "EDIT_CONFIG: $EDIT_CONFIG"
echo "RUN_PLAYBOOK: $RUN_PLAYBOOK"

if [[ "$INSTALL_ANSIBLE" == "true" ]]
then
  echo "Installing Ansible"
  sudo apt-get --yes install software-properties-common
  sudo apt-add-repository --yes ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get --yes install ansible git
  sudo apt-add-repository --yes --remove ppa:ansible/ansible
fi

if [[ "$CLONE_REPO" == "true" ]]
then
  echo "Cloning git repository"
  git clone --depth=1 http://TODO.git
fi

cd ds-developer-machine/ansible

if [[ "$EDIT_CONFIG" == "true" ]]
then
  echo "Allowing user to edit the Ansible configuration"
  cp group_vars/server.yml.sample group_vars/server.yml
  nano group_vars/server.yml
fi

if [[ "$RUN_PLAYBOOK" == "true" ]]
then
  echo "Running Ansible playbook"
  ansible-playbook -i "hosts" site.yml --ask-sudo
fi
