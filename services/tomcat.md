## Apache Tomcat

Apache Tomcat is a web server designed to serve Java Server Page (JSP) web applications.


### Installation

* Avoid running tomcat with other services
* Remove the sample server files
* Do not reveal excess information
	- Do not advertise version information
	- Disable X-Powered-By HTTP header by setting `xpoweredBy="false"` in the Connectors
	- Disable Allow Trace HTTP header by setting `allowTrace="false"` in the Connectors
	- Disable Client facing Stack Traces
* Protect shutdown port by either disable by setting port to -1 or setting shutdown value to a random value
* Ensure that file permissions are correct
	- Make `$CATALINA_HOME` owned by `tomcat_admin:tomcat` with permissons 750
	- Make `$CATALINA_BASE` owned by `tomcat_admin:tomcat` with permissons 750
	- Make `$CATALINA_HOME/conf` owned by `tomcat_admin:tomcat` with permissons 770
	- Make `$CATALINA_HOME/logs` owned by `tomcat_admin:tomcat` with permissons 770
	- Make `$CATALINA_HOME/temp` owned by `tomcat_admin:tomcat` with permissons 770
	- Make `$CATALINA_HOME/bin` owned by `tomcat_admin:tomcat` with permissons 750
	- Make `$CATALINA_HOME/webapps` owned by `tomcat_admin:tomcat` with permissons 750
	- Make `$CATALINA_HOME/conf/catalina.policy` owned by `tomcat_admin:tomcat` with permissons 600
	- Make `$CATALINA_HOME/conf/catalina.properties` owned by `tomcat_admin:tomcat` with permissons 600
	- Make `$CATALINA_HOME/conf/logging.properties` owned by `tomcat_admin:tomcat` with permissons 600
	- Make `$CATALINA_HOME/conf/server.xml` owned by `tomcat_admin:tomcat` with permissons 600
	- Make `$CATALINA_HOME/conf/tomcat-users.xml` owned by `tomcat_admin:tomcat` with permissons 600
	- Make `$CATALINA_HOME/conf/web.xml` owned by `tomcat_admin:tomcat` with permissons 600
* Use better authentication
	- Configure Realms to not use MemoryRealm in server.xml
	- Configure Realms to use LockOutRealms
	- If possible use Client-Cert Authentication by setting `clientAuth="True"` in server.xml
* Use SSL where possible
	- Ensure that SSLEnabled is set to True for Sensitive Connectors in server.xml
	- Set the scheme to "https" in connectors in server.xml
	- Ensure that secure is set to false on connectors that are not using SSL in sever.xml.
	- Ensure that the sslProtocol is "TLS" for all connectors using SSLEngine in server.xml.
* Configure Logging
	- Ensure the following lines are in logging.properties `handlers=org.apache.juli.FileHandler, java.util.logging.ConsoleHandler`
	- Ensure the following lines are in logging.properties `org.apache.juli.FileHandler.level=FINEST`
	- Ensure that `className` is set to `org.apache.catalina.valves.FastCommonAccessLogValve` in `$CATALINA_BASE/<app name>/META-INF/context.xml`
	- Ensure that directory is set to `$CATALINA_HOME/logs` in `$CATALINA_BASE/<app name>/META-INF/context.xml`
	- Ensure that pattern is set to `"%t % U %a %A %m %p %q %s"` in `$CATALINA_BASE/<app name>/META-INF/context.xml`
* Prevent unexpected code execution
	- Set `package.access` to `sun., org.apache.catalina., org.apache.coyote., org.apache.tomcat., org.apache.jasper.` in conf/catalina.properties
	- Ensure that Tomcat is started with `-security`
	- Ensure that `autoDeploy="false"` in server.xml
	- Ensure that `deployOnStartup="false"` in server.xml
* Protect the manager application
	- Ensure that the valves with the class RemoteAddrValve is set to allow on `127.0.0.1` only in server.xml
	- Ensure that the valves with the class RemoteAddrValve is set to allow on `127.0.0.1` only in "webapps/host-manager/manager.xml" if it must be used
	- Force SSL to access manager if it must be used
	- Rename the manager application by renaming the xml file and moving the app to a new corresponding directory
* Disable insecure startup settings
	- Ensure that `-Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true` is set in startup script
	- Ensure that `-Dorg.apache.catalina.connector.RECYCLE_FACADES=false` is set in startup script
	- Ensure that `-Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=false` is set in startup script
	- Ensure that `-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=false` is set in startup script
	- Ensure that `-Dorg.apache.coyote.USE_CUSTOM_STATUS_MSG_IN_HEADER=false` is set in startup script
* Do not allow symbolic linking in context.xml by setting `allowLinking="false"`
* Do not run applications as privileged in context.xml by setting `privileged="false"`
* Do not allow cross context requests in context.xml by setting `crossContext="false"`
* Do not allow resolving hosts on logging Valves by setting `resolveHosts="false"`


### Configuration

```sh
# remove sample resources
rm -rf $CATALINA_HOME/webapps/{js-examples,servlet-example,webdav,tomcat-docs,balancer}
rm -rf $CATALINA_HOME/webapps/{ROOT/admin,examples}
rm -rf $CATALINA_HOME/server/webapps/{host-manager,manager}
rm -rf $CATALINA_HOME/conf/Catalina/localhost/{host-manager,manager}.xml

# ensure that only needed connectors are configured remove unused connectors
grep "Connector" $CATALINA_HOME/conf/server.xml

# edit the server properties string to hide properties
#tomcat 5.5
cd $CATALINA_HOME/server/lib
#tomcat 6.0
cd $CATALINA_HOME/lib
#both
jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
vim org/apache/catalina/util/ServerInfo.properties
jar uf catalina.jar

# disable client facing stack traces
vim error.jsp
# create a error page with out useful information
vim $CATALINA_HOME/conf/web.xml
# add a section that looks like this in the <web-app> element
# <error-page>
#   <exception-type>java.lang.Throwable</exception-type>
#   <location>/path/to/error.jsp</location>
# </error-page>

# configure LockOutRealms
vim $CATALINA_HOME/conf/server.xml
# add a section that looks like this wrapping the main realm
#  <Realm className="org.apache.catalina.realm.LockOutRealm" failureCount="3"
#         lockOutTime="600" cacheSize="1000" cacheRemovalWarningTime="3600">
#    ... MAIN REALM ...
#  </Realm>

# force SSL when accessing the manager application
vim $CATALINA_HOME/{server/,}webapps/manager/WEB-INF/web.xml
# add lines that look like this
# <security-contraint>
#   <user-data-constraint>
#      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
#   </user-data-constraint>
# </security-contraint>
```
