FROM ubuntu:14.04

MAINTAINER Yinlin Chen "ylchen@vt.edu"

ARG FedoraConfig=
ARG ModeshapeConfig=file-simple

# Install essential packages
RUN apt-get update && apt-get install -y \
	build-essential \
	curl \
	maven \
	openssh-server \
	software-properties-common \
	vim \
	wget \
	htop tree zsh fish


# Install Java 8
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN add-apt-repository -y ppa:webupd8team/java \
	&& apt-get update -y \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get install -y oracle-java8-installer \
	&& update-java-alternatives -s java-8-oracle \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/oracle-jdk8-installer


# Install Tomcat 7.
ENV CATALINA_HOME /usr/local/tomcat7
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.72
ENV TOMCAT_TGZ_URL http://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN mkdir -p "$CATALINA_HOME" \
	&& cd $CATALINA_HOME \
	&& set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz* \
	&& useradd -ms /bin/bash tomcat7 \
	&& sed -i '$i<role rolename="fedoraUser"/>$i<role rolename="fedoraAdmin"/>$i<role rolename="manager-gui"/>$i<user username="testuser" password="password1" roles="fedoraUser"/>$i<user username="adminuser" password="password2" roles="fedoraUser"/>$i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>$i<user username="fedora4" password="fedora4" roles="manager-gui"/>' /usr/local/tomcat7/conf/tomcat-users.xml

RUN echo 'JAVA_OPTS="$JAVA_OPTS -Dfcrepo.modeshape.configuration=classpath:/config/'$ModeshapeConfig'/repository.json -Dfcrepo.home=/mnt/ingest -Dfcrepo.audit.container=/audit"' > $CATALINA_HOME/bin/setenv.sh \
	&& chmod +x $CATALINA_HOME/bin/setenv.sh


# Make the ingest directory
RUN mkdir /mnt/ingest \
	&& chown -R tomcat7:tomcat7 /mnt/ingest

VOLUME /mnt/ingest


# Install Fedora4
ENV FEDORA_VERSION 4.7.4
ENV FEDORA_TAG 4.7.4

RUN mkdir -p /var/lib/tomcat7/fcrepo4-data \
	&& chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data \
	&& chmod g-w /var/lib/tomcat7/fcrepo4-data \
	&& cd /tmp \
	&& curl -fSL https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-$FEDORA_TAG/fcrepo-webapp-plus-$FedoraConfig$FEDORA_VERSION.war -o fcrepo.war \
	&& cp fcrepo.war /usr/local/tomcat7/webapps/fcrepo.war \
	&& chown tomcat7:tomcat7 /usr/local/tomcat7/webapps/fcrepo.war 


# Install Solr
ENV SOLR_VERSION 4.10.3
ENV SOLR_HOME /usr/local/tomcat7/solr

RUN cd /tmp \
	&& curl -fSL http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz -o solr-$SOLR_VERSION.tgz \
	&& curl -fSL http://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar -o commons-logging-1.1.2.jar \
	&& mkdir -p "$SOLR_HOME" \
	&& tar -xzf solr-"$SOLR_VERSION".tgz \
	&& cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war /usr/local/tomcat7/webapps/solr.war \
	&& chown tomcat7:tomcat7 /usr/local/tomcat7/webapps/solr.war \
	&& cp "commons-logging-1.1.2.jar" /usr/local/tomcat7/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/slf4j* /usr/local/tomcat7/lib \
	&& cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/log4j* /usr/local/tomcat7/lib \
	&& chown -hR tomcat7:tomcat7 /usr/local/tomcat7/lib \
	&& cp -Rv /tmp/solr-"$SOLR_VERSION"/example/solr/* $SOLR_HOME \
	&& chown -hR tomcat7:tomcat7 $SOLR_HOME \
	&& touch /var/lib/tomcat7/velocity.log \
	&& chown tomcat7:tomcat7 /var/lib/tomcat7/velocity.log

COPY config/schema.xml $SOLR_HOME/collection1/conf/

RUN chown -hR tomcat7:tomcat7 $SOLR_HOME

# Install Fuseki
ENV FUSEKI_VERSION 2.3.1
ENV FUSEKI_BASE /etc/fuseki
ENV FUSEKI_DEPLOY /usr/local/tomcat7/webapps

RUN cd && mkdir -p "$FUSEKI_BASE" \ 
	&& mkdir -p "$FUSEKI_BASE"/configuration \
	&& chown -hR tomcat7:tomcat7 $FUSEKI_BASE \
	&& cd /tmp \
	&& curl -fSL http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz -o apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& tar -xzvf apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
	&& mv apache-jena-fuseki-"$FUSEKI_VERSION" jena-fuseki1-"$FUSEKI_VERSION" \
	&& cd jena-fuseki1-"$FUSEKI_VERSION" \
	&& mv -v fuseki.war $FUSEKI_DEPLOY \
	&& chown -hR tomcat7:tomcat7 $FUSEKI_DEPLOY/fuseki.war

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
