#Remove sample resources
rm -rf $CATALINA_HOME/webapps/{js-examples,servlet-example,webdav,tomcat-docs,balancer}
rm -rf $CATALINA_HOME/webapps/{ROOT/admin,examples}
rm -rf $CATALINA_HOME/server/webapps/{host-manager,manager}
rm -rf $CATALINA_HOME/conf/Catalina/localhost/{host-manager,manager}.xml

#Ensure that only needed connectors are configured remove unused connectors
grep "Connector" $CATALINA_HOME/conf/server.xml

#Edit the server properties string to hide properties
#tomcat 5.5
cd $CATALINA_HOME/server/lib
#tomcat 6.0
cd $CATALINA_HOME/lib
#both
jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
vim org/apache/catalina/util/ServerInfo.properties
jar uf catalina.jar

#Disable client facing stack traces
vim error.jsp #Create a error page with out useful information
vim $CATALINA_HOME/conf/web.xml
#add a section that looks like this in the <web-app> element
# <error-page>
#   <exception-type>java.lang.Throwable</exception-type>
#   <location>/path/to/error.jsp</location>
# </error-page>

#Configure LockOutRealms
vim $CATALINA_HOME/conf/server.xml
#add a section that looks like this wrapping the main realm
#  <Realm className="org.apache.catalina.realm.LockOutRealm" failureCount="3" 
#         lockOutTime="600" cacheSize="1000" cacheRemovalWarningTime="3600">
#    ... MAIN REALM ...
#  </Realm>

#Force SSL when accessing the manager application
vim $CATALINA_HOME/{server/,}webapps/manager/WEB-INF/web.xml
#Add lines that look like this
# <security-contraint>
#   <user-data-constraint>
#      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
#   </user-data-constraint>
# </security-contraint>


