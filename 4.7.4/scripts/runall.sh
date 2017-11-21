/opt/karaf/bin/start
sleep 10
/opt/karaf/bin/client -f /root/karaf_service.script
/opt/karaf/bin/stop
ln -s /opt/karaf/bin/karaf-service /etc/init.d/
update-rc.d karaf-service defaults 
sed -i "s|#org.ops4j.pax.url.mvn.localRepository=|org.ops4j.pax.url.mvn.localRepository=~/.m2/repository|" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg
/opt/karaf/bin/start
sleep 60
/root/fedora_camel_toolbox.sh
/opt/karaf/bin/stop
sleep 30
/opt/karaf/bin/start
sleep 60
cd $CATALINA_HOME
catalina.sh run
