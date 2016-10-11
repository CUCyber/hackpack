## Linux

Here are some of the worst things that they can do, and how to hopefully recover.


### Invalid Password

The red team has changed the password to the root account.

1. Reboot and hold shift
2. Press 'e' at the grub prompt to edit the kernel command line
3. Add the option `init=/bin/bash` to the line that says linux
4. Mount the root filesystem, `mount -o remout,rw /`
5. Use 'vi' to edit the `/etc/passwd` file and remove the 'x' between the 2nd and 3rd colon on the root user
6. Write the file
7. Use 'passwd' to create a new root password
7. Reboot


### Chmod Not Executable

While this initially might not seem like it is too bad, there is a problem where bash does not provide a built-in to fix this. This can be particularly devious if the entire root directory is marked not executable. If the entire file system is not executable, you are looking at a live CD or a slave mounted drive.

There are a few options here roughly sorted by time to fix:

* Use a programming language like python, perl, or C to write your own chmod command to fix chmod
* Use the linker directly by running `/lib/ld-*.so /bin/chmod 755 /bin/chmod` as root
* Use a shell like busybox, zsh, or ksh that provides a built-in chmod
* Reinstall chmod from repos or a working machine
* Dump the bits of the binary and manually edit the permission bits
* Use a live CD
* Power off the machine, remove the hard drive, slave mount it to a different machine that has a working chroot, mount the drive, and fix it


#### Chmod Examples


##### C

```c
#include<sys/stat.h>

int main(int argc, char *argv[]) {
	chmod("/bin/chmod", S_IRWXU);
	return 0;
}
```


##### Perl

```sh
#!/bin/sh
perl -e 'chmod 0755, "/bin", "/bin/chmod"'
```


##### Python

```python
import os
os.chmod('/bin/chmod', 0755)
```
