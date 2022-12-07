To understand this guide please download the files in this repo and then just follow the explanation for the structure of the docker-compose.yml file located at the main directory.

# Docker Compose
So you need to create a docker-compose file and you don't know how to do that. First, you should understand the main docker compose file structure:

1. version - The docker compose version (optional)
2. services - The environment variables to work
3. volumes - The persistance of the informaction
4. networks - How our containers wull commumicate each other

## Creating a Docker Compose file

First of all, you have to create a file with the yml or yaml extension. In this case, we are gonna call it docker-compose.yml. Then, we follow the structure mentioned.

### Services
You can install any docker services. For example:
```
services:
    nginx:
        image: nginx:alpine
        container_name: nginx_svc
        port: 
            - 8080:80
```
We get the nginx image from docker hub.
We set the container tag/name as we want.
We set the port as read in image's documentation at docker hub.

Another way to set our docker-compose file is by creating a Dockerfile wich serves as context writing the next code:

- In Dockerfile
```
FROM nginx:alpine
```

- In docker-compose.yml
```
services:
    nginx:
        build:
            context: .
            dockerfile: Dockerfile
            restart: always
        container_name: nginx_svc
        port: 
            - 8080:80
        volumes:
            - <host>: <container host>
        networks:
            nginx_network:
                aliasses:
                    - nginx_host
volumes: 
    <host>: {}
```

Explanation:
Context is the directory where my new docker file is located.
dockerfile is the name of my docker file, in this case: Dockerfile.
restart is in case of error, what do I want to do?

## So, how this file works?:

### Volumes
"volumes" keeps the changes and information that I work with
"volumes" at "services" level is used to confirm our volumes in every service we ran

So, to work with volumes you have to configure the host directory ant the container directory (wich you will find at image's documentation). Then you have to confirm the volume at main level. You can see this in docker-compose.yml file from this directory.

### Networks
To see all active networks
```
    >>> docker network ls
```

*Note: The best practice with docker network is let docker sets it up for you. However, you can work wuth aliases*

First, you have to configure the network at "images" level.
```
networks:
            nginx_network:
                aliasses:
                    - nginx_host
```

Then, the next code lets docker manage your ip
```
networks:
  nginx_network:
    name: nginx_net
    driver: bridge
    ipam: 
      driver: default
```

* Network types
bridge: as the name says is a bridge among our containers
host: used to work with our machine ip
none: disables networking for a container

### Some commands
1. Initializing docker compose
```
    >>> docker-compose up
    >>> docker-compose up -d (runs background)
```
2. What containers I have run?
```
    >>> docker-compose ps -a
```
3. Stop docker compose execution
```
    >>> docker-compose down
```
4. When docker-compose doesn't make the changes
```
    >>> docker-compose up -d --build
```
5. See what is happening with our container
```
    >>> docker-compose up logs -f
```
6. Inspect a network
```
    >>> docker network inspect <network id>
```

## Working with the Practical Project
Once you ran < docker-compose up -d > follow the next steps:

1. Create a php file in the www directory with the next code just to prove it (index.php)
```
<? phpinfo();
```
2. Connect your DBServer with the information to login.
server: custom_db
password: FerMavec
3. Create a php file to connect the db (db.php)
```
<?php
$mysqli = new mysqli("mariadb_host", "root", "FerMavec", "custom_db");
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
echo $mysqli->host_info . "<br/>";

$mysqli = new mysqli("mariadb_host", "root", "FerMavec", "custom_db", 3306);
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

echo $mysqli->host_info . "<br/>";
```
4. Go to localhost:8080 and localhost:8080/db.php