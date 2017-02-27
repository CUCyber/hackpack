## VSFTPD

When an FTP server needs to be created or migrating to a more secure box, the FTP server of choice is vsftpd. Apply the following changes to the configuration file to reduce privileges and spoof the banner as the Windows FTP server. If migrating the server, copy all of the FTP files from the old server to '/home/ftp' using the `ftp` command.


##### /etc/vsftpd.conf

```conf
nopriv_user=ftp
ftpd-banner=Windows FTP Server
