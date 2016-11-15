# Fedora 4 Docker Repo

This is the Git repo of the Docker image for [Fedora 4 docker](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/). Please see the [Hub page](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/) for the full readme on how to use the Docker image and for information regarding contributing and issues.

## Requirements

* [Docker](https://www.docker.com/)

## Usage

1. `docker pull yinlinchen/fcrepo4-docker`
2. `docker run -it -p 8080:8080 -p 3030:3030 -d yinlinchen/fcrepo4-docker:4.3.0`
3. Use `docker ps` to check the "CONTAINER ID" and "STATUS". The container should be ready to use after 5 minutes.

You can shell into the machine with `docker exec -i -t "CONTAINER ID" /bin/bash`

## In this Docker image

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](https://tomcat.apache.org) at [http://localhost:8080](https://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.3.0](https://wiki.duraspace.org/display/FF/Downloads) at [http://localhost:8080/fcrepo](https://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](https://lucene.apache.org/solr/) at [http://localhost:8080/solr](https://localhost:8080/solr), for indexing & searching your content.
    * Installed in "/var/lib/tomcat7/solr"
  * [Fuseki 1.3.0](https://jena.apache.org/documentation/serving_data/index.html) at [http://localhost:3030](https://localhost:3030), for querying and updating.
    * Installed in "/usr/share/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/usr/share/fuseki/temp\_data"
  * [Fcrepo-camel-toolbox 4.3.0](https://github.com/fcrepo4-labs/fcrepo-camel-toolbox)
    * Installed in Tomcat container

  ps. MacOS: docker is configured to use the default machine with IP 192.168.99.100, the Fedora 4.3.0 URL is  [http://192.168.99.100:8080/fcrepo](https://192.168.99.100:8080/fcrepo)

## Maintainers

Current maintainers:

* [Yinlin Chen](https://github.com/yinlinchen)