## OpenSSL

OpenSSL is a toolkit for the TLS protocol and a general purpose cryptography library.


### Generate TLS Certificates

Below is a command to generate a key file and TLS certificate for use in Apache or other server. Copy the generated files to the appropriate place (e.g. '/etc/httpd/conf/ssl.key' and '/etc/httpd/conf/ssl.crt') and make them writable only by root and readable by the web server group (e.g. `chown -R root:httpd /etc/httpd/conf/ssl.{key,crt} && chmod 640 /etc/httpd/conf/ssl.{key,crt}`). The output files are `example.pem`, the key, and `example.crt`, the certificate.

```sh
#!/bin/sh
openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 365 -keyout example.pem -out example.crt -subj '/O=Example, Inc./CN=example.com'
```
