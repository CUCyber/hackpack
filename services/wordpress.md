## Wordpress

Wordpress is a PHP content management system. It has reasonable security in a new default install, but has a poor track record for remote execution exploits. The best way to secure Wordpress is to update it if possible and remove all unnecessary or old plugins.

See the [PHP](#php) section for more details of general PHP hardening.


### Setup

Download the latest tarball available at 'https://wordpress.org/latest.tar.gz' and untar it into the document root (i.e. '/var/www'). Create and configure the necessary using the following SQL commands.

```sql
CREATE USER wordpress@localhost IDENTIFIED BY 'password';
CREATE DATABASE wordpress;
GRANT SELECT,INSERT,UPDATE,DELETE ON wordpress.* TO wordpress@localhost;
FLUSH PRIVILEGES;
```

Navigate to the setup page at 'http://localhost/wordpress/' and follow the setup instructions. Proceed below with how to add a few extra layers of security to a Wordpress installation.


### Securing

* Make sure file permissions are restrictive
	- '/' needs to be writable only by the owning user account (e.g. 'www')
	- '/wp-content' needs to be writable by web server (e.g. 'apache')
	- '/wp-content/plugins' needs to be writable only by the owning user account (e.g. 'www')
* Remove unnecessary database permissions
	- reduce database permissions for the SQL user by running the following command, replacing `wordpress.*` with the Wordpress tables and `wordpress@localhost` with the Wordpress user if necessary.
	- `REVOKE ALL PRIVILEGES ON wordpress.* from wordpress@localhost;`
	- `GRANT SELECT,INSERT,UPDATE,DELETE ON wordpress.* TO wordpress@localhost; FLUSH PRIVILEGES;`
* Disable file editing from wp-admin
	- add `define('DISALLOW_FILE_EDIT', true);` to 'wp-config.php'
* Move 'wp-config.php' to the directory above the Wordpress root
* Add 'AskApache Password Protect' which enables HTTP authentication preventing wp-admin from being exploited
