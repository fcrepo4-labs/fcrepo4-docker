FROM tomcat:8.0-jre8

LABEL maintainer="Yinlin Chen <ylchen@vt.edu>"

RUN apt-get update && apt-get -y upgrade

# Install Fedora 5
ARG FEDORA_TAG=
ARG FedoraConfig=
ARG ModeshapeConfig=file-simple
ARG JDBCConfig=

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir /mnt/ingest

RUN sed -i '$i<role rolename="fedoraUser"/>$i<role rolename="fedoraAdmin"/>$i<role rolename="manager-gui"/>$i<user username="testuser" password="password1" roles="fedoraUser"/>$i<user username="adminuser" password="password2" roles="fedoraUser"/>$i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>$i<user username="fedora4" password="fedora4" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml

RUN echo 'JAVA_OPTS="$JAVA_OPTS -Dfcrepo.modeshape.configuration=classpath:/config/'$ModeshapeConfig'/repository.json '$JDBCConfig' -Dfcrepo.home=/mnt/ingest -Dfcrepo.audit.container=/audit"' > $CATALINA_HOME/bin/setenv.sh \
	&& chmod +x $CATALINA_HOME/bin/setenv.sh

RUN cd /tmp \
	&& curl -fSL https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-$FEDORA_TAG/fcrepo-webapp-$FEDORA_TAG.war -o fcrepo.war \
	&& cp fcrepo.war /usr/local/tomcat/webapps/fcrepo.war


# Install Solr
ENV SOLR_VERSION 4.10.3
ENV SOLR_HOME /usr/local/tomcat/solr

RUN cd /tmp \
	&& curl -fSL https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz -o solr-$SOLR_VERSION.tgz \
	&& curl -fSL https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar -o commons-logging-1.1.2.jar \
	&& mkdir -p "$SOLR_HOME" \
	&& mkdir -p /var/lib/tomcat/ \
	&& tar -xzf solr-"$SOLR_VERSION".tgz \
	&& cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war /usr/local/tomcat/webapps/solr.war \
	&& chown root:root /usr/local/tomcat/webapps/solr.war \
	&& cp "commons-logging-1.1.2.jar" /usr/local/tomcat/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/slf4j* /usr/local/tomcat/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/log4j* /usr/local/tomcat/lib \
	&& chown -hR root:root /usr/local/tomcat/lib \
	&& cp -Rv /tmp/solr-"$SOLR_VERSION"/example/solr/* $SOLR_HOME \
	&& chown -hR root:root $SOLR_HOME \
	&& touch /var/lib/tomcat/velocity.log \
	&& chown root:root /var/lib/tomcat/velocity.log

COPY config/schema.xml $SOLR_HOME/collection1/conf/

RUN chown -hR root:root $SOLR_HOME


# Install Fuseki
ENV FUSEKI_VERSION 2.3.1
ENV FUSEKI_BASE /etc/fuseki
ENV FUSEKI_DEPLOY /usr/local/tomcat/webapps

RUN cd && mkdir -p "$FUSEKI_BASE" \ 
	&& mkdir -p "$FUSEKI_BASE"/configuration \
	&& chown -hR root:root $FUSEKI_BASE \
	&& cd /tmp \
	&& curl -fSL https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz -o apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& tar -xzvf apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& mv apache-jena-fuseki-"$FUSEKI_VERSION" jena-fuseki1-"$FUSEKI_VERSION" \
	&& cd jena-fuseki1-"$FUSEKI_VERSION" \
	&& mv -v fuseki.war $FUSEKI_DEPLOY \
	&& chown -hR root:root $FUSEKI_DEPLOY/fuseki.war

COPY config/shiro.ini /root/
COPY config/test.ttl /root/

RUN cp /root/shiro.ini  /etc/fuseki/. \
&& cp /root/test.ttl /etc/fuseki/configuration/.


# Install Apache Karaf
ENV KARAF_VERSION 4.0.5

COPY config/karaf_service.script /root/

RUN cd /tmp \
	&& wget -q -O "apache-karaf-$KARAF_VERSION.tar.gz" "https://archive.apache.org/dist/karaf/"$KARAF_VERSION"/apache-karaf-"$KARAF_VERSION".tar.gz" \
	&& tar -zxvf apache-karaf-$KARAF_VERSION.tar.gz \
	&& mv /tmp/apache-karaf-$KARAF_VERSION /opt \
	&& ln -s "/opt/apache-karaf-$KARAF_VERSION" /opt/karaf

RUN sed -i "s/http:\/\/repo1.maven.org/https:\/\/repo1.maven.org/g" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg


# Fedora Camel Toolbox
COPY config/fedora_camel_toolbox.script /root/
COPY scripts/fedora_camel_toolbox.sh /root/
COPY scripts/hawtio.sh /root/
COPY scripts/runall.sh /root/

WORKDIR /usr/local/tomcat

EXPOSE 8080
EXPOSE 8181

CMD sh /root/runall.sh
