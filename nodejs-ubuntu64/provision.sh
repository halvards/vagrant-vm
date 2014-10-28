#!/bin/bash

ANSIBLE_PLAYBOOK=$1
TEMP_HOSTS="/tmp/ansible_hosts"

if [ ! -f /vagrant/$ANSIBLE_PLAYBOOK ]; then
	echo "Cannot find Ansible playbook"
	exit 1
fi

if [ ! $(hash ansible-playbook 2> /dev/null) ]; then
  echo "Updating apt cache"
  apt-get update
  echo "Installing Ansible"
  apt-get install -y ansible
fi

echo "Running Ansible"
ansible-playbook /vagrant/${ANSIBLE_PLAYBOOK} --connection=local

