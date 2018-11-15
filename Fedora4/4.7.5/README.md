# Fedora 4 Docker Repo

This is the Git repo of the Docker image for [Fedora 4 docker](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/). Please see the [Hub page](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/) for the full readme on how to use the Docker image and for information regarding contributing and issues.

## Requirements

* [Docker](https://www.docker.com/)

## Usage

1. `docker pull yinlinchen/fcrepo4-docker`
2. `docker run -it -p 8080:8080 -d yinlinchen/fcrepo4-docker:4.7.5`
3. Use `docker ps` to check the "CONTAINER ID" and "STATUS". The container should be ready to use after 5 minutes.

You can shell into the machine with `docker exec -i -t "CONTAINER ID" /bin/bash`

## In this Docker image

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7.0.72](https://tomcat.apache.org) at [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.7.5](https://wiki.duraspace.org/display/FF/Downloads) at [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](https://lucene.apache.org/solr/) at [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in "/usr/local/tomcat7/solr"
  * [Apache Karaf 4.0.5](http://karaf.apache.org/)
    Installed in /opt/karaf
    Installed as a service apache-karaf
  * [Fuseki 2.3.1](https://jena.apache.org/documentation/serving_data/index.html) at [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in "/etc/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/etc/fuseki/databases/test_data"
  * [Fcrepo-camel-toolbox 4.7.2](https://github.com/fcrepo4-labs/fcrepo-camel-toolbox)
    * Installed in Tomcat container

  ps. MacOS: docker is configured to use the default machine with IP e.g. 192.168.99.100 or 127.0.0.1, the Fedora 4 URL is either [http://192.168.99.100:8080/fcrepo](http://192.168.99.100:8080/fcrepo) or [http://127.0.0.1/fcrepo](http://127.0.0.1/fcrepo). You can use "docker-machine ip" to see your docker machine IP.


## Fedora Configuration
The default Docker build is Fedora 4 without WebAC and Audit capability.
```
docker build -t="4.7.5-default" .
```

To enable Fedora 4 with WebAC enabled.
```
docker build --build-arg FedoraConfig=webac- --build-arg ModeshapeConfig=servlet-auth -t="4.7.5-webac" .
```
Three Fedora user accounts are available:
  * user account testuser, with password password1
  * user account adminuser, with password password2
  * admin account fedoraAdmin with the password secret3

To enable Fedora 4 with Audit capability. 
```
docker build --build-arg FedoraConfig=audit- -t="4.7.5-audit" .
```

To enable Fedora 4 with WebAC and Audit capability.
```
docker build --build-arg FedoraConfig=webac-audit- --build-arg ModeshapeConfig=servlet-auth -t="4.7.5-webac-audit" .
```

## Maintainers

Current maintainers:

* [Yinlin Chen](https://github.com/yinlinchen)
* [Paul Mather](https://github.com/pmather)
