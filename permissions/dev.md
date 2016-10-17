## /dev

The following command will fix permissions for all device files to reasonable defaults:

```sh
#!/bin/sh
# find devices with execute permissions and remove the execute permissions
find /dev \( -type c -or -type b -or -type f \) -perm -+x -exec chmod -x {} \;
```
