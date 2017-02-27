## Advanced Packaging Tool (apt)


### Archive Mirrors

If you are running a particularly old version of Debian, you should set up the archive mirrors to get a working package manager.


#### /etc/apt/sources.list

```apt
deb http://archive.debian.org/debian/ [version]/main
deb http://archive.debian.org/debian-security/ [version]/updates
deb http://archive.debian.org/debian-volatile/ [version]/volatile
```
