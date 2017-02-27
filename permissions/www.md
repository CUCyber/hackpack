## /var/www

The following command will fix permissions for all www files to reasonable defaults:

```sh
#!/bin/sh
find /var/www -type d -exec chmod 750 {} \;
find /var/www -type f -exec chmod 640 {} \;
chown -R root:apache /var/www
chmod 770 /var/www/[any directories that need to be writable by the web application]
```
