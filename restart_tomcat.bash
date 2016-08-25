#!/bin/bash

###############
###:@Target:    Delete  webapps  content and restart tomcat
###:Author:     Robert Luo
###:DATE :      20160823
###:Email :     robert_luo1949@163.com
###:Deploy env: Centos 6.6
###:Other:      
###############

####@@@00 content structure###
        ###@01 shutdown.sh
        ###@02 count total  tomcat PID process 
                ##pid = ps -ef |grep java | grep ${bin_dir} |awk '{print $2}' |wc -l
                ##@02-01 for loop (i=0;i<count;i++)
                ##@02-02 pid = ps -ef |grep java | grep ${bin_dir} |awk '{print $2}' | sed -n '$p'
                ##@02-03    kill -9 $pid
        ###@03 delete ROOT file and .war package
        ###@04  count total  tomcat PID numbers
                ##@04-01 if count number 0 0 startup.sh ,tomcat restart successful
                ##@04-02 if count number > 0 echo tomcat restart failed ,echo pid
        ###@05 add JAVA_HOME ,JRE_HOME to CATALINE.sh
                ##JAVA environment on the top
                # JAVA_HOME=/usr/local/jdk1.7.0_79
                # JRE_HOME=/usr/local/jdk1.7.0_79/jre
####content structure###


TOMCAT_DIR=/usr/local/tomcat
WEBAPPS_DIR=/usr/local/tomcat/webapps

###@01 shutdown.sh
cd $TOMCAT_DIR/bin
./shutdown.sh
wait $!
###@02 count total  tomcat PID process 
##pid = ps -ef |grep java | grep ${bin_dir} |awk '{print $2}' |wc -l
count=`ps -ef |grep java |grep "${TOMCAT_DIR}/bin" |wc -l`
#echo $count
##@02-01 for loop (i=0;i<count;i++)


for((i=0;i< $count;i++))
do
       ##@02-02 capture second column with awk , capture last process number with sed
       ##@02-02 PID=`ps -ef | grep java | grep "${TOMCAT_DIR}/bin" | awk '{print $2}' | sed -n '$p'`
       ##ps -ef | grep java | grep '${TOMCAT_DIR}/bin' | awk '{print $2}' | sed -n '$p'| xargs kill -9
       PID=`ps -ef | grep java | grep "${TOMCAT_DIR}/bin" | awk '{print $2}' |sed -n '$p' `
       ps -ef|grep java | grep "${TOMCAT_DIR}/bin"  |sed -n '$p'|awk '{printf("kill -9 %s\n",$2)}' |sh
       ##@02-03    kill -9 process number
       echo "KILL -9  ${PID}"

done

###@03 delete ROOT file and .war package
rm -rf $WEBAPPS_DIR/ROOT
rm -f $WEBAPPS_DIR/ROOT.war
###@04  count total  tomcat PID numbers
COUNTS=`ps -ef |grep java |grep '${TOMCAT_DIR}/bin' |wc -l`
##@04-01 if count number = 0, startup.sh ,tomcat restart successful
echo "PIDS: ${COUNTS}"
PID=`ps -f |grep java |grep "${TOMCAT_DIR}/bin" |awk '{print $2}' `
if [ $COUNTS -eq 0 ]; then
        echo -e "\033[40;34m" 
        echo "Shutdown activity tomcat successful ***"
        echo -e "\033[0m"

        cd $TOMCAT_DIR/bin
        ./startup.sh
        PID=`ps -f |grep java |grep "${TOMCAT_DIR}/bin" |awk '{print $2}' `
        wait $!
        echo -e "\033[40;34m" 
        echo "Start activity tomcat successful *** ***"
        echo "PID: ${PID}"
        echo -e "\033[0m"
else

        ##@04-02 if count number > 0 echo tomcat restart failed ,echo pid
        echo -e "\033[40;34m" 
        echo "PID: ${PID}"
        echo "Shutdown activity tomcat filed ***"
        echo -e "\033[0m"
fi
