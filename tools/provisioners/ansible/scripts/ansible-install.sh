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
