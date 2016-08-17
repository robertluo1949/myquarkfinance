#!/bin/sh
jenkins_HOME="/usr/local/jenkins"
#jenkins_OPTS="-Dhudson.model.DirectoryBrowserSupport.CSP="

JAVA_OPTS="-server -XX:PermSize=64M -XX:MaxPermSize=128M -Dfile.encoding=UTF-8 -Xloggc:/usr/local/jenkins/jenkins.log -Dhudson.model.DirectoryBrowserSupport.CSP= "
cd ${jenkins_HOME}

echo -e "Staring the jenkins"

#nohup java  ${jenkins_OPTS} -jar $jenkins_HOME/jenkins.war --httpPort=9999 >./jenkins.log >&1 &
nohup java  ${JAVA_OPTS} -jar jenkins.war --httpPort=9999 >./jenkins.log >&1 &

COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    COUNT=`ps -f | grep java | grep "${jenkins_HOME}" | awk '{print $2}' | wc -l`
    if [ $COUNT -gt 0 ]; then
        break
    fi
done

echo "OK!"
#PIDS='ps -f | grep java |grep "${jenkins_HOME}" | awk '{print $2}'

PIDS=`ps -f | grep java | grep "${jenkins_HOME}" | awk '{print $2}'`
echo "PID: $PIDS"
echo "STDOUT : {$jenkins_HOME}/jenkins.log"