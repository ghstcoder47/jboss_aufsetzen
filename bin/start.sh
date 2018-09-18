#!/bin/sh

export JAVA_HOME=/data/r-pe-k/tools/java/jdk1.8
#export MAVEN_HOME=/data/r-pe-k/tools/maven/3.5.4
export MAVEN_HOME=/data/r-pe-k/tools/maven/3.9.9
export JENKINS_HOME=/data/r-pe-k/jenkins/data

export WFLY12=/data/r-pe-k/appsrv/wildfly/12.0.0.Final
export MX=2G
export MS=512M 
export BASE_PORT=5000

export JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Djava.io.tmpdir=/data/r-pe-k/jenkins/tmp"

nohup $WFLY12/bin/startServer.sh jenkins &
