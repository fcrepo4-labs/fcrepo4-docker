# Fedora 5 Docker Repo

This is the Git repo of the Docker image for [Fedora 5 docker](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/). Please see the [Hub page](https://hub.docker.com/r/yinlinchen/fcrepo4-docker/) for the full readme on how to use the Docker image and for information regarding contributing and issues.

## Requirements

* [Docker](https://www.docker.com/)

## Usage
Run Fedora with a file-based objects database (Default Fcrepo 5.0.0-RC-1):
```
# Start server
docker-compose up -d

# Shutdown server
docker-compose down
```

Run Fedora with a MySQL database:
```
# Start server
docker-compose -f fcrepo-mysql.yml up -d

# Shutdown server
docker-compose -f fcrepo-mysql.yml down
```

Run Fedora with a PostgreSQL database:
```
# Start server
docker-compose -f fcrepo-postgres.yml up -d

# Shutdown server
docker-compose -f fcrepo-postgres.yml down
```

Fedora [Dockerfile](docker/services/fcrepo/Dockerfile)

You can shell into the machine with `docker exec -i -t "CONTAINER ID" /bin/bash`

## In this Docker image, see detail in [Dockerfile](Dockerfile)

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 8.0.53](https://tomcat.apache.org) at [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 5.0.0-RC-1](https://wiki.duraspace.org/display/FF/Downloads) at [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)

  ps. MacOS: docker is configured to use the default machine with IP e.g. 192.168.99.100 or 127.0.0.1, the Fedora 4 URL is either [http://192.168.99.100:8080/fcrepo](http://192.168.99.100:8080/fcrepo) or [http://127.0.0.1/fcrepo](http://127.0.0.1/fcrepo). You can use "docker-machine ip" to see your docker machine IP.

## Fedora 4 docker
  * All the previous Fedora 4 releases are located at [Fedora4](Fedora4)

## Maintainers

Current maintainers:

* [Yinlin Chen](https://github.com/yinlinchen)

