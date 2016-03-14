#!/bin/sh
dir=$(dirname "$0")
java -server -Xmx2048M -XX:MaxPermSize=256M -cp "$dir/h2-1.3.176.jar:$dir/TAFJFunctions.jar" org.h2.tools.Server \
	-properties '/opt/h2-conf/' -baseDir '/opt/h2-data/' \
 	-web -webAllowOthers -webPort 81 \
 	-tcp -tcpAllowOthers -tcpPort 1521