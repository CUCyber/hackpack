# Install the source
git clone git://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup

# or install from pip
sudo pip install ansible

# Install dependencies
sudo pip install paramiko PyYAML Jinja2 httplib2 six

# To manage Windows machines
pip install https://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm
pip install kerberos
