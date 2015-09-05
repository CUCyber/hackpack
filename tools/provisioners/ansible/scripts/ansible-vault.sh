# ansible-vault edit group_vars/windows.yml
# be sure to specifiy --ask-vault-pass when running ansible

# Will use AD if user name is like username@realm and you are signed into kerberos
ansible_ssh_user: WindowsAdministratorUsername
ansible_ssh_pass: WindowsAdministratorPassword
ansible_ssh_port: 5986
ansible_connection: winrm
