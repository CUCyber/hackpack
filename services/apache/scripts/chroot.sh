makedir -p /jail/apache/usr/local
cd /usr/local
mv apache /jail/apache/usr/local
ln -s /jail/apache/usr/local/apache

echo "SecChrootDir /jail/apache" >> $HTTPD_CONF
/usr/local/apache/bin/apachectl startssl
