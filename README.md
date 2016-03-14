# docker-h2-server
Dockerfile for building docker container h2 database engine. This image is an extension of [fxmartin/docker-sshd-nginx](https://github.com/fxmartin/docker-sshd-nginx).

## About

This repository contains all needed resources to build a docker image with following features:
* sshd with passwordless login;
* nginx running and serving simple static page;
* h2 server and console running;
* services configured and running via supervisord.

if the image is run without mounting a host directory to /opt/h2-data then there will be no persistence. To enable persistence then just run the container as follows:
```
docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 55591:91 -p 1521:1521 -v $(pwd)/t24-db:/opt/h2-data fxmartin/docker-t24-monolithic
```

For convenience there is a *./manage.sh* command for building, starting (with proper port mappings), stopping and connecting via ssh.

## Usage

This image cannot be downloaded from []Docker Registry](https://hub.docker.com) as it contains proprietary software from Temenos.

Clone this repository on your local machine and launch a build.

There are two docker files:
* __Dockerfile__, using the ADD command for importing the Temenos installation files, which are expected to be found in build/ directory
* __Dockerfile.wget__, using wget and more optimised as far as the size of the resulting image is concerned. The files are downloaded from a dropbox repository. Be aware that there are a mere 686 Mb to retrieve so hopefully you have a good Internet connection or a lot of patience.

A bash script is provided: _manage.sh_, which allows to manage the container, considering that it won't stop by itself due to supervisor daemon:
* start: to start the container
* stop: to stop the container
* build: build the docker image
* ssh: ssh to the container
* web: launch chrome on port 80 from nginx, with the IP automatically retrieved from the script
* console: launch chrome on port 81 from h2 console, with the IP automatically retrieved from the script
* proc: launch chrome on port 91 for supervisord web ui

**Run using command:**
```
manage.sh start
```

**Connect via ssh:**
```
manage.sh ssh
```

## Screenshots

Image 1 - Supervisord web ui

![nginx welcome page](https://raw.github.com/fxmartin/docker-t24-monolithic/master/screenshots/supervisord.png)

## Instructions for build

to build locally with the benefits of the wget (in terms of image size) you can set-up a local http server from the directory where the files are stored:
```
python -m SimpleHTTPServer
```

Hence all files will be accessible trough http://local:8000.

Example from last build
```
fxmartin@AdminisatorsMBP:~/Dropbox/syncordis.docker$ python -m SimpleHTTPServer
Serving HTTP on 0.0.0.0 port 8000 ...
127.0.0.1 - - [14/Mar/2016 16:53:32] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [14/Mar/2016 16:53:32] code 404, message File not found
127.0.0.1 - - [14/Mar/2016 16:53:32] "GET /favicon.ico HTTP/1.1" 404 -
192.168.178.125 - - [14/Mar/2016 16:56:39] "GET /tafj.r15.sp5.0.tar.gz HTTP/1.1" 200 -
192.168.178.125 - - [14/Mar/2016 16:57:48] "GET /MB.R15.000.H2.TAFJ-R15_SP2.Training.20151031.zip HTTP/1.1" 200 -
```

## Notes
Just don't forget to add private key (yeah, I know) from **ssh_keys** folder to you '~/.ssh/' and add it via
```
ssh-add -K ~/.ssh/id_rsa_docker
```
