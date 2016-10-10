## Ansible

Ansible is a lightweight agent-less provisioner that uses Python 2.x and OpenSSH as a backend. It is configured using Playbooks which are files written in a dialect of YAML.


### Setting it Up


#### Managed Windows Machines

Ansible can also manage Windows machines running PowerShell 3.0 or later. For windows machines, you will also need to create an encrypted `host_vars` or `group_vars` file on the control machine that contains the following information:

```yaml
# run 'ansible-vault edit group_vars/windows.yml'
# be sure to specifiy --ask-vault-pass when running ansible

# Will use AD if user name is like username@realm and you are signed into kerberos
# If you are using Ansible 1.x, the ansible_{user,pass,port} were called
# ansible_ssh_{user,pass,port}
ansible_user: WindowsAdministratorUsername
ansible_pass: WindowsAdministratorPassword
ansible_port: 5986
ansible_connection: winrm
```

It is also required to run the 'ConfigureRemotingForAnsible.ps1' from the Ansible source code script on the Windows machines that will be managed.


#### Managed Linux Machines

Ansible is agent-less, this means that only one machine must have Ansible installed on it. For Linux or BSD managed machines, all you have to have is OpenSSH and Python 2.x. For some Linux distributions where Python 3.x is the default or python is installed in an non-standard location, you may need to set `ansible_python_interpetor = /usr/bin/python2`. For best performance, SFTP must be enabled in '/etc/ssh/sshd\_config' as a subsystem with the path to the 'sftp-server' binary


#### Control Machine

The control machine must have a few more pieces of software. On most distributions, it can be installed from package repositories. It can also be installed from source:

```sh
#!/bin/sh
# Install the source
git clone git://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup

# For really broken machines such as Metaspoitable, install python27 from source
# You may even have to disable certificate checking (-k) but don't do that if you
# don't have to;  You will also need to set ansible_python_interpertor for these machines
curl -LO https://www.python.org/ftp/python/2.7/Python-2.7.tgz
tar -xzvf ./Python-2.7.tgz
cd ./Python-2.7
./configure && make && make install

#For CentOS
sudo yum install epel-release
sudo yum install autoconf gcc python-devel

# or install from pip
sudo pip install ansible

# Install dependencies if installing Ansible from github
sudo pip install paramiko PyYAML Jinja2 httplib2 six

# To manage Windows machines
pip install https://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm
pip install kerberos
```


### Inventory Management
The collections of machines that are managed via Ansible are called the inventory.  Here is an example inventory file:

```ansible
[web:children]
webservers
databases

[webservers]
192.168.0.2
192.168.0.[10:20]

[databases]
foo.bar.com
sue.bar.com

[secureservers]
foobar@10.0.0.2:23

[local]
localhost ansible_connection=local
```

In this example we demonstrate,

* A set of hosts specified by a range of ip addresses
* A set of hosts specified by domain name
* A host using a different user and default port.
* Targeting the localhost
* Four groups of hosts called web, webservers, databases, and local
* A group of groups called web that contains all the hosts in webservers and databases.

NOTE, group variables and host variables can also be specified in the hosts file as shown with the `ansible_connection` example, but this format is discouraged because it does not follow a separation of concerns.


### Sample Playbooks

Repositories containing Ansible playbooks  are generally arranged out as follows:

* 'site.yml' - the primary playbook
* 'hosts' - the primary host inventory
* 'group\_vars/' - directory containing encrypted group variables
* 'host\_vars/' - directory containing encrypted host variables
* 'roles/' - directory containing roles that will be applied

Here is an example playbook:

```yaml
---
- host: webservers # run this on the webserver group
  become: yes # escalate this play from remote user to super user
              # A user can also be specified via "become_user:"

  # varibles needed in the httpd.conf template
  vars:
    http_port: 80
    max_clients: 200

  # tasks that will be run run on the server
  tasks:

    # demonstrates iteration
    - name: create admins
      user: name={{item.name}} shell={{item.shell}} groups=wheel append=yes
      with_items:
          - { name: 'matthew', shell: '/bin/bash'}
          - { name: 'mark', shell: '/bin/zsh'}
          - { name: 'luke', shell:'/bin/fish'}

    # demonstrates conditionals
    - name: install apache for CentOS
      yum: name=httpd state=latest
      when: ansible_distribution == 'CentOS'

    - name: install apache for Debian
      apt: name=lighttpd state=latest
      when: ansible_os_family == 'Debian'

    # demonstrates handlers and templates
    - name: update the apache config file
      template: src=httpd.j2 dest=/etc/httpd.conf
      notify:
        - restart apache

    # demonstrates starting a service
    - name: ensure apache is running
      service: name=httpd state=started enabled=yes

  # tasks that need to be run when other tasks are run
  handlers:
      - name: restart apache
        service: name=httpd state=restarted
```

These playbooks can also be split into separate sections in what are called roles.
Here is how a sample role, in this case a webserver are stored:

* 'roles/webserver' - directory where the webserver role is stored.
* 'roles/webserver/files' - files that would be referenced via copy commands in the role.
* 'roles/webserver/tempates' - templates that would be referenced via template commands in the role.
* 'roles/webserver/tasks' - where tasks for the webserver role are stored.
* 'roles/webserver/handlers' - where handlers that kickoff post processing tasks for the webserver role are stored.
* 'roles/webserver/vars' - where role specific variables for the webserver role are stored.
* 'roles/webserver/defaults' - where role specific default values variables for the webserver role are stored.
* 'roles/webserver/meta' - where role specific meta data for the webserver role are stored such as dependencies could be listed.


#### Ansible Vault

Ansible has a means of creating AES encrypted files for use of storing configuration. To create a file use `ansible-vault create <filename>` To edit a file use `ansible-vault edit <filename>` which will open the file un-encrypted in the user's `EDITOR` and re-encrypt it after editing. It can be used for file containing variables and files that are part of roles.


#### Extending Ansible

Somethings Ansible is just not good at, string parsing for instance. You can write modules in Python that do this heavy lifting. Here is a sample module that checks for the sshd version, and sets a variable with the output:

```python2
"""
Fundamentally, ansible modules simply accept a JSON string as input, do work,
and return a JSON string as output to stdout.  At no time should anything be
printed that is not the final JSON output, or exceptions be returned
This if this module was called site_facts can be included via a play like so:
---
- name: Gather facts
  action: site_facts
  tags:
    - always
"""
import re
import functools

def ssh_facts(module):
    """
    Collect facts for the ssh installations
    """
    #Prior to Python 3, there was not a good subprocess module
    #So ansible includes their own with the necessary options set
    rc, out, err = module.run_command(args=['ssh', '-V'])
    if rc == 0:
        ssh_version = str(err).split(',')[0]
        ssh_version = ssh_version[8:]
    else:
        ssh_version = '0.0p0'

    try:
        major_version, minor_version, patch_version = \
                re.match(r'(\d+)\.(\d+)p(\d+)', ssh_version).groups()
    except AttributeError:
        ssh_version = '0.0p0'
        major_version, minor_version, patch_version = (0, 0, 0)

    return {
        "ssh_version": ssh_version,
        "ssh_major_version": major_version,
        "ssh_minor_version": minor_version,
        "ssh_patch_version": patch_version,
    }

FACTS = {
    "ssh": ssh_facts,
}

def main():
    """
    This is the main method, to extend this module, add an entry to FACTS
    and write a function that gathers the necessary information
    """

    #Here are where the arguments to the module are examined
    #The quotes around str are important
    module = AnsibleModule(argument_spec=dict(
        name=dict(type='str', default='*'),
    ))

    name = module.params['name']
    results = []

    if name == "*":
        results = [FACTS[fact](module) for fact in FACTS]
    else:
        results = [FACTS[name](module)]

    #Unify the dictionaries returned from each command into a single dictionary
    facts = dict(functools.reduce(set.union, map(set, map(dict.items, results))))

    module.exit_json(changed=False, ansible_facts=facts)

from ansible.module_utils.basic import *
if __name__ == '__main__':
    main()
```


#### Documentation

For each of the ansible modules, there is documentation that is installed. It can be viewed using the `ansible-doc` command. Use `ansible-doc -l` to get a list of all the available modules and a short description.

Ansible uses Jinja2 for Templates. To access the list of filters as well as extensive examples, run `pydoc jinja2.filters`. These templates can also be used for variables, see `ansible all -m setup` for a list of available facts.
