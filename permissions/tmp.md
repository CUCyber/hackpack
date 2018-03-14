## /tmp

Remount '/tmp', '/var/tmp', and '/dev/shm' with `nodev`, `nosuid`, and `noexec` to prevent executables or device files from being dropped into a globally writable directory and used maliciously.

```sh
#!/bin/sh
# remount with nodev, nosuid, and noexec
mount -o remount,nodev,nosuid,noexec /tmp
mount -o remount,nodev,nosuid,noexec /var/tmp
mount -o remount,nodev,nosuid,noexec /dev/shm
```
