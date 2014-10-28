#!/bin/bash

ANSIBLE_PLAYBOOK=$1
TEMP_HOSTS="/tmp/ansible_hosts"

if [ ! -f /vagrant/$ANSIBLE_PLAYBOOK ]; then
	echo "Cannot find Ansible playbook"
	exit 1
fi

if [ ! -n $(which ansible-playbook) ]; then
  echo "Updating apt cache"
  apt-get update
  echo "Installing Ansible"
  apt-get install -y ansible python-apt python-pycurl
fi

echo "Running Ansible"
echo "127.0.0.1" > /tmp/ansible_localhost
ansible-playbook /vagrant/${ANSIBLE_PLAYBOOK} --inventory=/tmp/ansible_localhost --connection=local -vv
rm /tmp/ansible_localhost

