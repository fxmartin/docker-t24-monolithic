#!/bin/bash
##############################################################################
# Script for managing docker image
# Based on manage.sh from https://github.com/fxmartin/docker-sshd-nginx
# Syncordis Copyright 2016
# Author: FX
# Date: 14-mar-2016
# Version: 1.00
##############################################################################

SCRIPT=manage.sh
VERSION=1.11

IMAGE="fxmartin/docker-t24-monolithic"

ID=`docker ps | grep "$IMAGE" | head -n1 | cut -d " " -f1`
IP=`docker-machine ip default`

BUILD_CMD="docker build -t=$IMAGE -f Dockerfile.wget ."
RUN_CMD="docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 -p 55591:91 -v $(pwd)/t24-db:/opt/h2-data $IMAGE"
BASH_CMD="docker run -it -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 -p 55591:91 -v $(pwd)/t24-db:/opt/h2-data $IMAGE bash"
SSH_CMD="ssh root@$IP -p 55522 -i ~/.ssh/id_rsa_docker"

is_running() {
	[ "$ID" ]
}

case "$1" in
        build)
                echo "Building Docker image: '$IMAGE'"
                $BUILD_CMD
                exit 0;;
        start)
                if is_running; then
                	echo "Image '$IMAGE' is already running under Id: '$ID'"
                	exit 1;
                fi
                echo "Starting Docker image: '$IMAGE'"
                $RUN_CMD
                echo "Docker image: '$IMAGE' started"
                exit 0;;

        stop)
                if is_running; then
					echo "Stopping Docker image: '$IMAGE' with Id: '$ID'"
	                docker stop "$ID"
					echo "Docker image: '$IMAGE' with Id: '$ID' stopped"

                else
                	echo "Image '$IMAGE' is not running"
                fi
                exit 0;;

        status)
                if is_running; then
                	echo "Image '$IMAGE' is running under Id: '$ID'"
                else
                	echo "Image '$IMAGE' is not running"
                fi		
                exit 0;;
        bash)
        		if is_running; then
                	echo "Image '$IMAGE' is already running under Id: '$ID'"
                	exit 1;
                fi
                echo "Starting Docker image: '$IMAGE'"
                $BASH_CMD
                echo "Docker image: '$IMAGE' started"
                exit 0;;
        ssh)
                if is_running; then
                	echo "Attaching to running image '$IMAGE' with Id: '$ID'"
                	$SSH_CMD
                else
                	echo "Image '$IMAGE' is not running"
                fi		
                exit 0;;
		web)
                open -a "Google Chrome" "http://$IP:55580"
                exit 0;;
        console)
                open -a "Google Chrome" "http://$IP:55581"
                exit 0;;
        proc)
                open -a "Google Chrome" "http://$IP:55591"
                exit 0;;
        *)
                echo "Usage: $0 {build|start|stop|status|ssh|web|console}"
                exit 1;;
esac

exit 0