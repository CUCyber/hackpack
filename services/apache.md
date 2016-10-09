## Apache

Apache is a one of the most popular web servers with a large variety of features.


### Installation

There is a large variety of steps that are important for securing Apache.

* Install Mod Security either from repos or from www.modsecurity.org
* Configure the Apache to use the Mod Security core rules from the repos or www.modsecurity.org
* Remove unnecessary options and text from Apache's httpd.conf file and /etc/httpd/conf.d (sometimes located at /etc/apache2/conf/extra)
* Remove all unnessisary modules entries from Apache's httpd.conf file
* Create an Apache user and group without a shell
* Configure Apache to run using this user and group
* Restrict access to the webserver via the Order allow,deny line in httpd.conf
* Prevent access to root file system
* Allow only read access to web directory /var/www/html
* Disable the following functionality if possible:
	- ExecCGI - Allow scripts to be run by apache from this directory.
	- FollowSymLinks - allow the server to follow symlinks
	- SymLinksIfOwnerMatch - has large performance costs.
	- Includes - permists the execution of server side includes
	- IncludesNOEXEC - same as above except prohibit executing scripts
	- Indexes - create an a directory listing in directories without an index.html
	- AllowOverride - allows overrides in '.htaccess' files
	- Multiviews - allows for the same request to ask for multiple files.
* Use RewriteEngine, RewriteCond, and RewriteRule to force HTTP 1.1
* Configure the web server to only server allowed file types.
* Configure to protect from DoS attacks
	- Timeout - set this to a low value like 10 seconds
	- KeepAlive - set this to on (unless RAM is a problem)
	- KeepAliveTimeout - set to 15
	- AcceptFilter http data - require content to open connection
	- AcceptFilter https data - require content to open connection
* Configure to protect against Buffer Overflows
	- LimitRequestBody 64000 - Limit requests to 10k in size
	- LimitRequestFeilds 32 - Limit number of request fields
	- LimitRequestFeildSize 8000 - Limit size of request lines
	- LimitRequestLine 4000 - Maximum size of the request line
* Use Mod\_SSL if possible (see openssl section for generating a sever certificate)
* Set ServerTokens to ProductOnly
* Use custom error pages via the ErrorDocument directive
* Remove default files and cgi-scripts
* Do not keep Apache Source after installation
* Ensure that web sever binaries are owned by root
* Allow only root to read the apache config or logs '/usr/lib/apache/{conf,logs}'
* Move apache to a chroot if possible - see below
* Use Mod\_Log\_Forensic


### Chrooting

```sh
#!/bin/sh
makedir -p /jail/apache/usr/local
cd /usr/local
mv apache /jail/apache/usr/local

echo "SecChrootDir /jail/apache" >> $HTTPD_CONF
/usr/local/apache/bin/apachectl startssl
```
