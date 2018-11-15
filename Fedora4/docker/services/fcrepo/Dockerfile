FROM tomcat:8.0-jre8

MAINTAINER Yinlin Chen "ylchen@vt.edu"

RUN apt-get update && apt-get -y upgrade

# Install Fedora4
ARG FEDORA_VERSION=4.7.5
ARG FEDORA_TAG=4.7.5
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

WORKDIR /usr/local/tomcat

EXPOSE 8080