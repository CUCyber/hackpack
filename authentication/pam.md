## PAM

PAM is short for Pluggable Authentication Module. It controls the authentication on Linux machines. By default, it reads the '/etc/shadow' file. It can also be configured to use LDAP or Kerberos for remote authentication.

In general the following should be configured:

* use `pam_cracklib retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1`
* use `pam_unix obscure sha512 remember=5`


### Configuration


#### /etc/pam.d/system-auth

```pam
auth required pam_env.so
auth required pam_unix.so try_first_pass likeauth nullokf
auth required /lib/security/\$ISA/pam_tally.so onerr=fail no_magic_root

account required pam_unix.so
account required /lib/security/\$ISA/pam_tally.so per_user_deny=5 no_magic_root reset

password required pam_cracklib.so retry=3 minlength=8 difok=3
password required pam_unix.so try_first_pass use_authtok sha512 shadow

session required pam_limits.so
session required pam_env.so
session required pam_unix.so
```
