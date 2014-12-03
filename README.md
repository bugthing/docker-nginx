# docker-nginx

Docker image providing a very simple Nginx service.
Built for use on my VPS to serve up web sites.

## Build

    docker build -t bugthing/docker-nginx .

## Run container

Before running the docker container you must prepare with the following steps

 - Place the site(s) content. (e.g /sites/example.com)
 - Generate SSL cert(s) (e.g ./certs/example.com.key ./certs/example.com.crt)
 - Write config file(s). (e.g ./sites-enabled/example.com)

Once you have setup the directory you should be able to run the container, like so:

    docker run -d --name=vps-nginx -p 80:80 -p 443:443 -v `pwd`/sites:/sites -v `pwd`/certs:/etc/nginx/certs -v `pwd`/sites-enabled:/etc/nginx/sites-enabled -v `pwd`/logs:/var/log/nginx bugthing/docker-nginx

## Directories

This docker image is built around referencing prepared volumes (directories), below is an explaination of each volume.

### sites-enabled

To be mounted at `/etc/nginx/sites-enabled`

Each specific sites configuration. For example:

    server {
        server_name .example.com; # for default use: server_name  _;
        ssl_certificate      /etc/nginx/certs/example.crt;
        ssl_certificate_key  /etc/nginx/certs/example.key;
        listen 80; # for default use: listen 80 default_server;
        listen 443 ssl;
        root /sites/example.com;
        index index.html index.htm;
    }

### certs

To be mounted at `/etc/nginx/certs`

A place to put all the generated SSL certificates.

### sites

To be mounted at `/sites`

The HTML, CSS etc. served up for each site.

Docker image providing a very simple opensmtpd service

Intended to accept mail for configured domains and relay onward to other email addresses

### logs

To be mounted at `/var/log/nginx`

Nginx log output directory

## SSL Generation

The following can be using to generate a self signed SSL certificate:

    openssl genrsa -des3 -out example.key 2048
    openssl req -new -key example.key -out example.csr
    cp example.key example.key.org
    openssl rsa -in example.key.org -out example.key
    openssl x509 -req -days 365 -in example.csr -signkey example.key -out example.crt

## How to use

What follows is the commands of how I got a site up on my VPS using this image.

    docker pull bugthing/docker-nginx
    mkdir -p /storage/docker-container-volumes/nginx
    cd /storage/docker-container-volumes/nginx
    mkdir sites
    mkdir sites-enabled
    mkdir certs
    mkdir logs
    cd certs/
    openssl genrsa -des3 -out example.key 2048
    openssl req -new -key example.key -out example.csr
    cp example.key example.key.org
    openssl rsa -in example.key.org -out example.key
    openssl x509 -req -days 365 -in example.csr -signkey example.key -out example.crt
    rm example.key.org
    cd ..
    vi sites-enabled/example
    mkdir sites/example
    vi sites/example/index.html
    docker run -d --name=nginx -p 80:80 -p 443:443 -v `pwd`/sites:/sites -v `pwd`/certs:/etc/nginx/certs -v `pwd`/sites-enabled:/etc/nginx/sites-enabled -v `pwd`/logs:/var/log/nginx bugthing/docker-nginx
