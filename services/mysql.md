## MySQL

MySql is a quick database for small to medium size organizations.


### Installation

Install from the repositories then use the command `mysql_secure_installation`.


### Common Tasks

```sql
-----------------------------
-- Listing Databases and Tables:
-----------------------------

SHOW DATABASES; -- lists every db, make sure to DROP the ones you don't need
USE openemr; -- selects a certain database so future operations run on it
SHOW TABLES; -- displays every table in the current database


-----------------------------
-- Verify all database users:
-----------------------------

# mysql -u root -p -- Login with root
-- Type in root password in prompt. If root doesn't have a password, you should set one now:
UPDATE mysql.User SET Password=PASSWORD('new root password') WHERE User='root';
-- Get list of all users:
SELECT Host, User, Password from mysql.User;

--If there are users that shouldn't be there, delete
--them (remember that % and _ are wildcards, % means 0 or more
--characters and _ means exactly one character).

--Delete all bad users. This should include all anonymous users, and any user
--that has a Host OTHER than 'localhost' (especially root!)

DROP USER 'username'@'hostname';
-- repeat for each undesired user
FLUSH PRIVILEGES;
-- run this after you finish deleting users and/or changing user passwords


--If this is at the beginning of competition, you should delete all non
--root@localhost users and only add them back if you need to. Chances are the
--server is set up to allow an anonymous user or a user with root-like access
--and a weak password full control over the database(s), so the best way to
--prevent an intrusion from Red Team is to outright delete these users. You
--(probably) do not need to worry about copying down password hashes, as if
--some application is using MySQL the password will be stored in plaintext in
--that application, and if not then you should be able to submit a Memo to
--White Team to change a user's password. That said, it might be a good idea
--anyways as long as you store it somewhere that Red Team can't get at and it
--isn't against Policy.


-----------------------------
-- Creating new users:
-----------------------------
--You should only create users with specific access
--to a specific database (e.g. one user per application that uses a database).
--Additionally, you should restrict the Host as much as possible. If your
--webapp is running on the same box as the db server, make the host localhost,
--otherwise make the host the IP of the box running the webapp. ONLY IF REMOTE
--DATABASE ACCESS IS REQUIRED BY THE INJECT should you open up the host to
--something outside of your team's network (e.g. '%')

--Create the database first
CREATE DATABASE webapp_name;

--Now add a user to it with a secure password:
--With minimal write access (can add/delete records, but not add/drop tables or
--table structures)

GRANT INSERT, UPDATE, SELECT, DELETE ON webapp_name.* TO
	'database_user'@'hostname per above' IDENTIFIED BY 'password goes here';
--With full write access to the given database
GRANT ALL PRIVILEGES ON webapp_name.* TO
	'database_user'@'hostname per above' IDENTIFIED BY 'password goes here';


-----------------------------
-- Get a user's Perms:
-----------------------------
SHOW GRANTS FOR 'user'@'host';

SELECT * FROM mysql.User where User='user' and Host='host';
--If you see a lot of Y's and the user ISN'T root@localhost, something is wrong.


-----------------------------
-- Backing up and restoring the database:
-----------------------------
--This should be in your list of things to do at
--the beginning of competition, as well as semi-frequently throughout when you
--do installations of new webapps, etc. Each command will prompt you to type
--the root password into the terminal. This is safer than providing the
--password in the command line because it does not get saved in .bash_history
--and possibly other places.

-- # is beginning of shell (Linux):
--Backup:
-- # mysqldump --all-databases -u root -p > backup.sql
--Restore:
-- # mysql -u root -p < backup.sql


-----------------------------
-- Reset root password:
-----------------------------
--Stop MySQL
-- # mysqld -u mysql --skip-grant-tables
-- # mysql -u root --Connect as root

UPDATE mysql.User SET Password=PASSWORD('new root password') WHERE User='root';
FLUSH PRIVILEGES;

--to re-load the grant tables and make root and all other users
--have passwords again
```


#### Securing

* Make sure it is only listening on localhost unless remote access is required by an inject (or the scoring engine) or you are running the webapps on a different server
* Look for bind-address in the [mysqld] section and ensure it is set to 127.0.0.1 for allowing local connections only or 0.0.0.0 for allowing remote connections
* Disable the LOCAL INFILE queries, which allows someone (i.e. red team) to upload files from their computers into your database, by adding local-infile = 0 to the [mysqld] section of the conf file
* Restart MySQL after making any configuration changes
