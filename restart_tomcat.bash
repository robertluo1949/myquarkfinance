#!/bin/sh


#stop activity
BIN_DIR="/usr/local/tomcat/bin"
webapps_Dir="/usr/local/tomcat/webapps"
cd $BIN_DIR
echo "bin into dir $BIN_DIR"

##shutdown tomcat with shutdown.sh
sh $BIN_DIR/shutdown.sh
PIDS=`ps -f | grep java | grep "${BIN_DIR}" | awk '{print $2}'`
echo "PID:  $PIDS"

##shutdown tomcat with  kill 
COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    COUNT=`ps -f | grep java | grep "${BIN_DIR}" | awk '{print $2}' | wc -l`
    if [ $COUNT -gt 0 ]; then
        kill $PIDS
    else
        break
    fi
done

wait $!

echo -e "\033[40;34m  " 
echo "PID ${PIDS}"
echo "Shutdown activity tomcat successful ***"
echo -e "\033[0m"


#delete ROOT files
rm -rf $webapps_Dir/ROOT
rm $webapps_Dir/ROOT.war
echo -e "\033[40;34m "
echo "Remove ROOT files successful ***"
echo -e "\033[0m"

#start activity
sh $BIN_DIR/startup.sh
sleep 5
PIDS=`ps -f | grep java | grep "${BIN_DIR}" | awk '{print $2}'`
echo "PID:  $PIDS"

wait $!
echo -e "\033[40;34m "
echo "Started activity tomcat successful ***"
echo -e "\033[0m"
