FROM ubuntu:14.04

MAINTAINER Yinlin Chen "ylchen@vt.edu"

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
ENV TOMCAT_VERSION 7.0.64
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

# Make the ingest directory
RUN mkdir /mnt/ingest \
	&& chown -R tomcat7:tomcat7 /mnt/ingest

VOLUME /mnt/ingest

# Install Fedora 4.2.0
ENV FEDORA_VERSION 4.2.0
ENV FEDORA_TAG 4.2.0

RUN mkdir -p /var/lib/tomcat7/fcrepo4-data \
	&& chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data \
	&& chmod g-w /var/lib/tomcat7/fcrepo4-data \
	&& cd /tmp \
	&& curl -fSL https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-$FEDORA_TAG/fcrepo-webapp-$FEDORA_VERSION.war -o fcrepo.war \
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

COPY schema.xml $SOLR_HOME/collection1/conf/

# Install Fedora Camel Toolbox
ENV SOLR_URL_ARG "localhost:8080/solr/collection1"
ENV CATALINA_OPTS "${CATALINA_OPTS} -Dsolr.base.url=${SOLR_URL_ARG}"

RUN cd /tmp \
	&& curl -fSL https://github.com/fcrepo4-labs/fcrepo-camel-toolbox/releases/download/fcrepo-camel-toolbox-${FEDORA_TAG}/fcrepo-camel-webapp-at-is-it-${FEDORA_VERSION}.war -o "fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war" \
	&& cp "fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war" /usr/local/tomcat7/webapps/fcrepo-camel-webapp.war \
	&& chown tomcat7:tomcat7 /usr/local/tomcat7/webapps/fcrepo-camel-webapp.war 

# Install Fuseki 1.1.2
ENV FUSEKI_VERSION 1.1.2
ENV FUSEKI_HOME /usr/share/fuseki

RUN mkdir $FUSEKI_HOME \
	&& cd /tmp \
	&& curl -fSL https://archive.apache.org/dist/jena/binaries/jena-fuseki1-"$FUSEKI_VERSION"-distribution.tar.gz -o jena-fuseki1-$FUSEKI_VERSION-distribution.tar.gz \
	&& tar -xzvf jena-fuseki1-"$FUSEKI_VERSION"-distribution.tar.gz \
	&& cd jena-fuseki1-"$FUSEKI_VERSION" \
	&& mv -v * $FUSEKI_HOME \
	&& chown -hR tomcat7:tomcat7 $FUSEKI_HOME \
	&& mkdir "$FUSEKI_HOME/test_data" \
	&& ln -s $FUSEKI_HOME/fuseki /etc/init.d \
	&& echo "FUSEKI_HOME=\"$FUSEKI_HOME\"" > /etc/default/fuseki \
	&& echo "FUSEKI_ARGS=\"--update --loc=$FUSEKI_HOME/test_data /test\"" >> /etc/default/fuseki \
	&& update-rc.d fuseki start 20 2 3 4 5 . stop 20 0 1 6 .

EXPOSE 8080
EXPOSE 3030

WORKDIR $CATALINA_HOME

CMD /etc/init.d/fuseki start && catalina.sh run 
