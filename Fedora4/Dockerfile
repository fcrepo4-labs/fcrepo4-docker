FROM tomcat:8.0-jre8

MAINTAINER Yinlin Chen "ylchen@vt.edu"

ARG FedoraConfig=
ARG ModeshapeConfig=file-simple

# Install essential packages
RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y \
	build-essential \
	curl \
	maven \
	openssh-server \
	software-properties-common \
	vim \
	wget \
	htop tree zsh fish

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Make the ingest directory
RUN mkdir /mnt/ingest

VOLUME /mnt/ingest

# Install Fedora4
ENV FEDORA_VERSION 4.7.5
ENV FEDORA_TAG 4.7.5

RUN sed -i '$i<role rolename="fedoraUser"/>$i<role rolename="fedoraAdmin"/>$i<role rolename="manager-gui"/>$i<user username="testuser" password="password1" roles="fedoraUser"/>$i<user username="adminuser" password="password2" roles="fedoraUser"/>$i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>$i<user username="fedora4" password="fedora4" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml

RUN echo 'JAVA_OPTS="$JAVA_OPTS -Dfcrepo.modeshape.configuration=classpath:/config/'$ModeshapeConfig'/repository.json '$JDBCConfig' -Dfcrepo.home=/mnt/ingest -Dfcrepo.audit.container=/audit"' > $CATALINA_HOME/bin/setenv.sh \
	&& chmod +x $CATALINA_HOME/bin/setenv.sh

RUN cd /tmp \
	&& curl -fSL https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-$FEDORA_TAG/fcrepo-webapp-plus-$FedoraConfig$FEDORA_VERSION.war -o fcrepo.war \
	&& cp fcrepo.war /usr/local/tomcat/webapps/fcrepo.war

# Install Solr
ENV SOLR_VERSION 4.10.3
ENV SOLR_HOME /usr/local/tomcat/solr

RUN cd /tmp \
	&& mkdir -p /var/lib/tomcat/fcrepo4-data \
	&& chmod g-w /var/lib/tomcat/fcrepo4-data \
	&& curl -fSL http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz -o solr-$SOLR_VERSION.tgz \
	&& curl -fSL http://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar -o commons-logging-1.1.2.jar \
	&& mkdir -p "$SOLR_HOME" \
	&& tar -xzf solr-"$SOLR_VERSION".tgz \
	&& cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war /usr/local/tomcat/webapps/solr.war \
	&& cp "commons-logging-1.1.2.jar" /usr/local/tomcat/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/slf4j* /usr/local/tomcat/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/log4j* /usr/local/tomcat/lib \
	&& cp -Rv /tmp/solr-"$SOLR_VERSION"/example/solr/* $SOLR_HOME \
	&& touch /var/lib/tomcat/velocity.log

COPY config/schema.xml $SOLR_HOME/collection1/conf/

# Install Fuseki
ENV FUSEKI_VERSION 2.3.1
ENV FUSEKI_BASE /etc/fuseki
ENV FUSEKI_DEPLOY /usr/local/tomcat/webapps

RUN cd && mkdir -p "$FUSEKI_BASE" \ 
	&& mkdir -p "$FUSEKI_BASE"/configuration \
	&& cd /tmp \
	&& curl -fSL http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz -o apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& tar -xzvf apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& mv apache-jena-fuseki-"$FUSEKI_VERSION" jena-fuseki1-"$FUSEKI_VERSION" \
	&& cd jena-fuseki1-"$FUSEKI_VERSION" \
	&& mv -v fuseki.war $FUSEKI_DEPLOY

COPY config/shiro.ini /root/
COPY config/test.ttl /root/

RUN cp /root/shiro.ini  /etc/fuseki/. \
	&& cp /root/test.ttl  /etc/fuseki/configuration/.

# Install Apache Karaf
ENV KARAF_VERSION 4.0.5

COPY config/karaf_service.script /root/

RUN cd /tmp \
	&& wget -q -O "apache-karaf-$KARAF_VERSION.tar.gz" "http://archive.apache.org/dist/karaf/"$KARAF_VERSION"/apache-karaf-"$KARAF_VERSION".tar.gz" \
	&& tar -zxvf apache-karaf-$KARAF_VERSION.tar.gz \
	&& mv /tmp/apache-karaf-$KARAF_VERSION /opt \
	&& ln -s "/opt/apache-karaf-$KARAF_VERSION" /opt/karaf

# Fedora Camel Toolbox
COPY config/fedora_camel_toolbox.script /root/
COPY scripts/fedora_camel_toolbox.sh /root/

COPY scripts/runall.sh /root/

EXPOSE 8080
EXPOSE 9080

WORKDIR $CATALINA_HOME

CMD sh /root/runall.sh

