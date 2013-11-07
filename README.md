# Vagrant virtual machines for developers

This branch uses Vagrant 1.3 and Ansible for provisioning.

If your `~/.ssh/known_hosts` file contains an entry for 127.0.0.1
(likely), then you need to add the following entry to your
`~/.ssh/config` file for Ansible to SSH to the guest VM:

    Host 127.0.0.1
      StrictHostKeyChecking no
      UserKnownHostsFile=/dev/null

