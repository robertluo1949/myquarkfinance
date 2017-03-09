#!/bin/bash

###############
###:@Target:    restart pdms-pdloan services  
###:Author:     Robert Luo
###:DATE :      20170306
###:Email :     robert_luo1949@163.com
###:Deploy env: Centos 6.6
###:Other:      jenkins version : 2.7.2
###############

####content structure###
#@01 define variables and functions
#@02 get queque of jar packages
#@03 shutdown  jar packages
#@04 check shutdowned status of jar packages 
#@05 starting jar packages
#@06 check started status of jar packages
####content structure###

#@01 define var and functions
countpid="00"
pdms_HE="/data"
JRE_HOME="/usr/local/jdk1.8.0_111/jre"
JAVA_HOME="/usr/local/jdk1.8.0_111"
PATH=$PATH:$HOME/bin
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH


#@02 get queque of jar packages
cd ${pdms_HE}
filelist=$(cat server_pwd.txt)
count=`cat server_pwd.txt |grep jar |wc -l` ##count jar packages and assign to variable of count
jarfile=`sed -n ${i}p server_pwd.txt`   ##get jar package list and assign to variable of jarfile
jarshortfile=${jarfile##*-jar}  ##get shortage jar package list and assign to variable of jarshortfile
##   jarfile=`cat server_pwd.txt |head -n ${i} |tail -n 1 `
tac ${pdms_HE}/server_pwd.txt >>/tmp/jar_pwd_tac.txt   ##write jar package list order by esc

#@01 define var and functions
function Do_kill_ALL () {
  ##pkill -term java
  kill -TERM  `ps -ef|grep -v grep |grep -e "$1"|awk '{print $2}'` && echo "`date "+%F %T"` $1 killed "
  countpid=`ps -ef |grep java |grep -v grep |wc -l`
  echo -e "The sum number of current jars is:\c"& echo {countpid}
#  if [${countpid} -eq 0];then
  if [ ${countpid} -eq 0 ] ; then
    echo "☆☆☆☆☆☆☆☆SHUTDOWN: Shutdowned jar packages successfully!"
  else 
    echo "☆☆☆☆☆☆☆☆SHUTDOWN: Shutdowned jar packages unsuccessfully!"
  fi  
}
 function Do_kill () {
  ##pkill -term java
   #kill -TERM  `ps -ef|grep -v grep |grep -e "$1"|awk '{print $2}'` && echo "`date "+%F %T"` $1 killed "
  ##echo $1
  ##jarpid=`ps -ef |grep "$1" |grep -v grep |awk '{print $2}'`
  ps -ef | grep -v grep | grep $1 | awk '{printf(" kill %s\n",$2)}' | sh
  echo  -e "☆☆☆☆☆☆☆☆KILL: killing:  \c"&& echo $1
 }

function Do_start () {
  #echo $JRE_HOME 
  #echo $1
#  nohup $JRE_HOME/bin/java  $1&>/dev/null 2>&1 &
  nohup $JRE_HOME/bin/java  $1&>/dev/null 2>&1 &
  echo -e "count jar number:\c" 
  echo $2 
  if [ ${countpid} -eq 1 ] ;then
        echo "☆☆☆☆☆☆☆☆START: starting $1 jar package."
  else
        echo "☆☆☆☆☆☆☆☆START: starting $1 jar package."
  fi

}

function Do_check () {
  countpid=`ps -ef |grep $1 |grep -v grep |wc -l`
  #echo ${countpid}
  if [ ${countpid} -eq 1 ] ;then
        echo "☆☆☆☆☆☆☆☆CHECK: Started $2 jar packages successfully!"
  else
        echo "☆☆☆☆☆☆☆☆CHECK: Started $2 jar packages unsuccessfully!"
  fi

}

function Do_check_kill () {
  countpid=`ps -ef |grep $1 |grep -v grep |wc -l`
   if [ ${countpid} -eq 0 ] ;then
      echo "☆☆☆☆☆☆☆☆CHECK: kill  pd_loan  jar packages successfully!"
   else
      echo "☆☆☆☆☆☆☆☆CHECK: kill  pd_loan  jar packages unsuccessfully!"
      echo "☆☆☆☆☆☆☆☆CHECK: exec command pkill -term java"
      pkill -term $1
      sleep 5s
   fi
}
#@03 shutdown  jar packages
for (( i=1;i<=$count;i++ ))
do 
    echo  -e "kill jar number :\c"
    echo ${i}
    jarfileesc=`sed -n ${i}p /tmp/jar_pwd_tac.txt`
    jarshortfileesc=${jarfileesc##*-jar}
    ##echo ${jarshortfileesc}
    Do_kill ${jarshortfileesc}
    delaynum=$[${count} - 3]  
    if [ ${i} -le ${delaynum} ];then
       sleep 1s ###front 3 jars sleep 1 seconds
    else
       sleep 3s  ###other jars sleep 3 second
    fi
    
done
Do_check_kill "java"


#@04 starting jar packages within for loop
for (( i=1;i<=$count;i++ )) 
do 
##   jarfile=`cat server_pwd.txt |head -n ${i} |tail -n 1 `
   jarfile=`sed -n ${i}p ${pdms_HE}/server_pwd.txt`

#@05 starting jar packages
   jarshortfile=${jarfile##*-jar}
   Do_start "${jarfile}" ${i}
   if [ ${i} -le 2 ];then
      sleep 15s ###front 3 jars sleep 10 seconds
   else
      sleep 1s  ###other jars sleep 1 second
   fi
    #@06 check started status of jar packages
   Do_check "${jarshortfile}" "${jarfile}"
done



