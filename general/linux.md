## Linux Checklist

This checklist is designed for the first 30 minutes of competition.

For each system:

* Change the password for the root account
* Check for improper ssh config
* Check for improper sshd config
* Check the crontab (s) for running tasks
* Check with files with wider permissions and setuid
* Create a report of running services and processes and disable unnecessary processes
* Create a report of open ports
* Audit user, groups for invalid entries
* Check mount/nfs if it is running
* Install updates
* Run a full system backup
* Check/Configure '/etc/sudoers' and '/etc/sudoers.d/*'
* Harden the service for your machine
* Install/Configure a firewall
* Write an audit report containing changes made

For all systems:

* Scan the subnet for running servers
* Configure a provisioner such as Salt/Ansible
