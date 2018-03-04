## OpenSSH

SSH or Secure Shell is a remote administration protocol. It allows the user to send remote commands to Linux machines (and soon to versions of Windows 10 or later). It can be a vary powerful tool for system administration, but can also be a powerful exploit target if not secured. It is used with a variety of tools, including the backup tool rsnapshot for secure connections. In general there are a few best practices to follow for using ssh.


### Best Practices

* Disable root login.
* Disable password authentication (default).
* Disable host-based authentication (default).
* Ensure that ssh is not setuid to prevent host-based authentication.
* Use at least public key authentication and use 2-factor authentication where possible.
* During competition revoke all authorized keys except when required by the scoring engine.
* Use sandbox privilege separation to prevent privilege escalation attacks on the daemon (default).
* Use PAM (pluggable authentication module) (default).
* Block excessive connections to ssh at the firewall.
* Do not forward the SSH Agent to untrusted/compromised servers.


### Config Files

Important system level configuration directories and files:

* '/etc/sshd/sshd\_config' - daemon configuration
* '/etc/hosts.equiv' - used for insecure host based authentication; remove when found
* '/etc/shosts.equiv' - used for insecure host based authentication; remove when found
* '/etc/ssh/ssh\_known\_hosts' - system wide list of host keys
* '/etc/ssh/ssh\_host\_\*key' - private keys used for host-based authentication and fingerprints
* '/etc/ssh/sshrc' - commands that are executed when the user logs on

Important user level configuration directories and files:

* '~/.rhosts' - used for insecure host based authentication; remove when found
* '~/.shosts' - used for insecure host based authentication; remove when found
* '~/.ssh/known\_hosts' - list of hosts that are not already in /etc/ssh/ssh\_known\_hosts
* '~/.ssh/authorized\_keys' - list of keys that can be used to authenticate as this user
* '~/.ssh/config' - per user configuration options for ssh
* '~/.ssh/environment' - environment options for the user
* '~/.ssh/id\*.pub' - public key for the user
* '~/.ssh/id\*' - private key for the user


### Configuration


#### /etc/ssh/sshd\_config

```sshconf
PermitRootLogin no
UsePAM yes
UsePrivilegeSeparation sandbox
AcceptEnv LANG LC_*
ClientAliveInterval 300
ClientAliveCountMax 0
```


#### Purge User Keys

```sh
for key_dir in $(awk 'BEGIN { FS=":"} {print $6}' /etc/passwd); do
	if [ -d "$key_dir/.ssh" ]; then
		test -f "$key_dir/.ssh/authorized_keys" && \
			mv "$key_dir/.ssh/authorized_keys" "$key_dir/.ssh/authorized_keys~" &>/dev/null
		test -f "$key_dir/.ssh/rhosts" && \
			mv "$key_dir/.ssh/rhosts" "$key_dir/.ssh/rhosts~" &>/dev/null
		test -f "$key_dir/.ssh/shosts" && \
			mv "$key_dir/.ssh/shosts" "$key_dir/.ssh/shosts~" &>/dev/null
		ls "$key_dir/.ssh/id*" &> /dev/null && echo "found keys at $key_dir/.ssh"
	fi
done
```


#### Purge System Keys

```sh
test -f /etc/hosts.equiv && mv /etc/hosts.equiv /etc/hosts.equiv~ &> /dev/null
test -f /etc/shosts.equiv && mv /etc/shosts.equiv /etc/shosts.equiv~ &> /dev/null
```

Do not forget to restart sshd after configuration.
