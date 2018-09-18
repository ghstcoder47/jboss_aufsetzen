#!/bin/sh
SERVERNAME=[i]rrs
echo Stoppe $SERVERNAME...
#kill `cat pid.txt`
ps -fae | grep -w $SERVERNAME | grep java | awk '{print $2}' | xargs kill -15
