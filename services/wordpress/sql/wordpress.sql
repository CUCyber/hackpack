CREATE USER wordpress@localhost IDENTIFIED BY 'password';
CREATE DATABASE wordpress;
GRANT SELECT,INSERT,UPDATE,DELETE ON wordpress.* TO wordpress@localhost;
FLUSH PRIVILEGES;
