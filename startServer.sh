#!/bin/sh
# ######################################################################
# Startscript fuer den JBoss Aufruf mit verschiedenen Instanzen
# Das Script ersetzt den Aufruf von standalone.sh
#
# Aufruf: startServer.sh <servername> [debug]
#
# ######################################################################

if [ "x$1" = "x" ]; then
	echo starten mit: startserver.sh <servername> !!!
	exit 1
fi
export SERVER_NAME=$1



echo Stoppe falls gestartet: $SERVER_NAME...
ps -fae | grep -w $SERVER_NAME | grep java | awk '{print $2}' | xargs kill -9



if [ -z $WFLY12 ] 
then
	echo SERVER_ROOT ist nicht gesetzt hier sollte die Variable WFLY12 mit dem Server Verzeichnis initialisiert werden!
	exit 1
fi

SERVER_ROOT=$WFLY12/$SERVER_NAME

echo Starte Wildfly mit der Umgebung $SERVER_NAME im Verzeichnis $SERVER_ROOT

#datei mit BASE_PORT einlesen
if [ -z $BASE_PORT ]; then
	echo "keine BASE_PORT variable vorhanden"
	if [ -f $SERVER_ROOT/base.port ]; then
		echo "lade base.port datei"
		. $SERVER_ROOT/base.port
	else
		echo "base.port konnte nicht gefunden werden"
	fi
fi

if [ "x$BASE_PORT" = "x" ]; then
	echo Basis Port muss gesetzt werden: $SERVER_ROOT/base.port
	echo Die Datei muss eine Zeile in der Form BASE_PORT=XXX enthalten.
	exit 1
fi

if [ "x$MX" = "x" ]; then
	MX=768m
fi

if [ "x$MS" = "x" ]; then
	MS=768m
fi

if [ "x$MXPERM" = "x" ]; then
	MXPERM=256m
fi

JAVA_OPTS="$JAVA_OPTS -Xms${MS} -Xmx${MX} -XX:MaxMetaspaceSize=${MXPERM} -Djava.net.preferIPv4Stack=true -Dorg.jboss.resolver.warning=true -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000"
JAVA_OPTS="$JAVA_OPTS -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS -Djava.awt.headless=true"
JAVA_OPTS="$JAVA_OPTS -Djboss.server.default.config=standalone-full.xml"
JAVA_OPTS="$JAVA_OPTS -Djboss.node.name=$SERVER_NAME"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=ISO-8859-1"
JAVA_OPTS="$JAVA_OPTS -Dsun.net.httpserver.nodelay=true"
JAVA_OPTS="$JAVA_OPTS -XX:HeapDumpPath=$SERVER_ROOT/logs/heapdumps -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS="$JAVA_OPTS -Xloggc:gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=512K"
export JAVA_OPTS="$JAVA_OPTS -XX:-OmitStackTraceInFastThrow"

if [ "xdebbug" = "x$2" ]; then
	DEBUT_PORT=$(($BASE_PORT+78))
	export JAVA_OPTS = "$JAVA_OPTS -Xrunjdwp:transport=dt_socket,address=$DEBUG_PORT,server=y,suspend=n"
fi

export JBOSS_PIDFILE=$SERVER_ROOT/pid.txt
export LAUNCH_JBOSS_IN_BACKGROUND=true

START_COMMAND="-b=0.0.0.0 -bmanagement=0.0.0.0 -Djboss.server.base.dir=$SERVER_ROOT -Djboss.socket.binding.port-offset=$BASE_PORT"
if [ -z $PROPERTIES ]; then
	echo "no properties"
else
 	echo "properties found: $PROPERTIES"
	START_COMMAND="$START_COMMAND -P $PROPERTIES"
fi

$WFLY12/bin/standalone.sh $START_COMMAND $JENKINS_JAVA_OPTIONS -c standalone-full.xml
