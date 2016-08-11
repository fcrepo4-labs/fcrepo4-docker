# Fedora 4 Docker Repo

This is the Git repo of the Docker image for [Fedora 4 docker](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/). Please see the [Hub page](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/) for the full readme on how to use the Docker image and for information regarding contributing and issues.

## Requirements

* [Docker](https://www.docker.com/)

## Usage

1. `docker pull yinlinchen/fcrepo4-docker`
2. `docker run -it -p 8080:8080 -p 9080:9080 -d yinlinchen/fcrepo4-docker:4.5.1`

You can shell into the machine with `docker exec -i -t "CONTAINER ID" /bin/bash`

## In this Docker image

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](https://tomcat.apache.org) at [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.5.1](https://wiki.duraspace.org/display/FF/Downloads) at [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](https://lucene.apache.org/solr/) at [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in "/usr/local/tomcat7/solr"
  * [Apache Karaf 4.0.5](http://karaf.apache.org/)
    Installed in /opt/karaf
    Installed as a service apache-karaf
  * [Fuseki 2.3.1](https://jena.apache.org/documentation/serving_data/index.html) at [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in "/usr/local/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/usr/local/fuseki/databases/test_data"
  * [Fcrepo-camel-toolbox 4.5.1](https://github.com/fcrepo4-labs/fcrepo-camel-toolbox)
    * Installed in Tomcat container

  ps. MacOS: docker is configured to use the default machine with IP 192.168.99.100, the Fedora 4 URL is  [http://192.168.99.100:8080/fcrepo](http://192.168.99.100:8080/fcrepo)

  ps2. For Fedora version 4.2.0 and 4.3.0, you should use -p 3030:3030 for Fuseki server. (e.g. `docker run -it -p 8080:8080 -p 3030:3030 -d yinlinchen/fcrepo4-docker:4.3.0`)


## Maintainers

Current maintainers:

* [Yinlin Chen](https://github.com/yinlinchen)
* [James R. Griffin III](https://github.com/jrgriffiniii)