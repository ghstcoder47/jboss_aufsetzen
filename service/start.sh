#!/bin/sh

export JAVA_HOME=/data/r-pe-k/tools/java/jdk1.8
export MX=2G
export MS=512M 
export WFLY12=/data/r-pe-k/appsrv/wildfly/12.0.0.Final
export BASE_PORT=1100

nohup $WFLY12/bin/startServer.sh irrs &
