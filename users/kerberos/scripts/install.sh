#if you can, use realmd (newer servers)
realm discover
realm join "realm_name"
realm permit -a

#Which roughly does the following on the backend

#####################################################################
##this section is roughly based on the ArchLinux Wiki documentation##
##Which is available under the GNU Free Document License           ##
#####################################################################
#first install and configure ntp and name resolution for the servers
#Next, configure the /etc/krb5.conf file as shown below

#Verify that you can now login
kinit administrator@EXAMPLE.COM
klist

#If there are errors regarding a missing pam_winbind make a file called
#pam_winbind.conf with the contents of the next section

#Configure Samba as specified in the Samba series section 

net ads join -U Administartor

#Start and enable the required services
systemctl start smbd nmbd winbindd

#Configure /etc/nsswitch.conf as shown below

#test winbind and nss(Windows Authentication service)
wbinfo -u 
wbinfo -g
getent passwd
getent group
net ads info
net ads lookup
net ads status -U administrator

#configure PAM with the following config.

#Modify applications as necessary to use Kerberos;  See the specific application for Documentation

#Finally Configure smb shares and keytabs if desired using the following
