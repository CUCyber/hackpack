## Linux Filesystem Hierarchy

* '/etc'
	- Should be backed up
	- Contains configuration files
	- Notable system files and directories
		+ 'passwd' - user table
		+ 'shadow' - password hash table
		+ 'group' - group table
		+ 'pam.d' - PAM configuration
		+ 'sudoers' - sudo configuration
		+ 'crontab' and 'cron.*' - cron configuration
	- Notable service files and directories
		+ 'sshd' - OpenSSH
		+ 'httpd' or 'apache2' - Apache
		+ 'nginx' - NGINX
		+ 'named' or 'bind' - BIND
* '/var'
	- Should be backed up
	- Contains changing permanent data (i.e. databases, logs, disk images, other service data)
	- Contains service home directories
	- Notable directories
		+ 'db' - databases
		+ 'lib' - service data
		+ 'log' - logs
		+ 'spool' - mail
		+ 'www' - web server files
		+ 'tmp' - temporary files that need to survive reboot
* '/tmp'
	- Temporary file that do not need to survive reboots
	- Sockets are often found here
		+ '.X11-unix' and '.ICE-unix' - places for X11 sockets and sessions (not found and should be deleted on a headless server!)
* '/home'
	- User data files
* '/root'
	- Root user data files
* '/bin'
	- Contains core executables for running the system (e.g. 'init', 'cp', 'ls', 'rm')
* '/opt'
	- Contains special programs and services
	- Usually for locally compiled programs
* `/usr`
	- Contains non-critical system programs
	- Has its own 'bin', 'lib', and 'libexec'
	- Notable directories
		+ 'share' - place for static program files that do not go in '/etc' or '/var'
* `/lib`
	- Core library files for running programs in 'bin'
	- Executables should not be here
* `/libexec`
	- Library executables that should not be run as standalone programs
	- Scripts should probably not be here
* `/proc`
	- Contains process information
	- Is not stored on the filesystem
	- Red teams often use this to find information about processes
	- A core system feature of Linux
* `/dev`
	- Contains device files representing physical devices on the system
	- Red teams will go here to see if they can manipulate devices
	- A core system feature of Linux
* `/sys`
	- Contains system interfaces to retrieve or change features of Linux or the underlying hardware
	- Red teams will likely not use this, but it can be used to get yourself out of a jam if system utilities are not working
	- A core system feature of Linux
