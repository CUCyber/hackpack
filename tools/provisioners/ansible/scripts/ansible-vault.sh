# ansible-vault edit group_vars/windows.yml
# be sure to specifiy --ask-vault-pass when running ansible

# Will use AD if user name is like username@realm and you are signed into kerberos
# If you are using Ansible 1.X, the ansible_{user,pass,port} were called 
# ansible_ssh_{user,pass,port}
ansible_user: WindowsAdministratorUsername
ansible_pass: WindowsAdministratorPassword
ansible_port: 5986
ansible_connection: winrm
