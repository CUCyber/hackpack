## Sudo

Sudo is short for super user do. It allows for non-root users to request elevated privileges on linux systems. Sudo has a variety of options that can be configured.

Here are some basic suggestions for managing systems that use sudo:

* Limit users permissions where possible, users should not have `ALL = (ALL) ALL`
* Avoid using groups with root permissions

The '/etc/sudoers' file should be edited as root using the `visudo` command which verifies the syntax before making changes. There are also other configuration files that can be found in '/etc/sudoers.d/'. These can be edited using `visudo -f <filename>`.


### Configuration

The following script will create a sane configuration for sudo.

```sh
#!/bin/sh
cp -Ra /etc/sudoers.d /etc/sudoers.d~
groupdel wheel && groupadd wheel
cp -a /etc/sudoers /etc/sudoers~
cat >/etc/sudoers <<- EOF
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
EOF

chown root:root /etc/sudoers
chmod 600 /etc/sudoers

# be sure to add administrators back to 'wheel' and
# merge stuff from '/etc/sudoers~' and '/etc/sudoers.d~/'
```
