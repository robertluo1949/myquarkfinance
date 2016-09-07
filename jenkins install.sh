#!/bin/bash

###############
###:@Target:    how to intall jenkins and go to start 
###:Author:     Robert Luo
###:DATE :      20160811
###:Email :     robert_luo1949@163.com
###:Deploy env: Centos 6.6
###:Other:      jenkins version : 2.7.2
###############

####content structure###
#@01 download jenkins
#@02 starting  jenkins with DirectoryBrowserSupport  and  9999 port 
#@03 uninstall open-jdk 1.7.0
#@04 install jdk 1.7.0_79
#@05 configure user system enviroment
####content structure###

###@01 download jenkins
sudo mkdir /usr/local/jenkinsweb
cd /usr/local/jenkinsweb
sudo wget  http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
	##admin:admin根据当前用户名和组名修改成正确的
sudo chown admin:admin /usr/local/jenkinsweb/*
sudo chown admin:admin /usr/local/jenkinsweb

###@02 start jenkins on prot 9999
cd /usr/local/jenkinsweb
nohup java -Dhudson.model.DirectoryBrowserSupport.CSP= -jar jenkins.war --httpPort=9999  > jenkins.log 2>&1 &
##-Dhudson.model.DirectoryBrowserSupport.CSP= 这个参数可以解决浏览器打不开robot报告的问题

###other  confirm ,this is not necessary 这不是必须的
###@03 uninstall open jdk
rpm -qa | grep java
  tzdata-java-2016e-1.el6.noarch
  java-1.7.0-openjdk-1.7.0.101-2.6.6.4.el6_8.x86_64

sudo rpm -e --nodeps java-1.7.0-openjdk-1.7.0.101-2.6.6.4.el6_8.x86_64
sudo rpm -e --nodeps tzdata-java-2016e-1.el6.noarch

###@04 install jdk 1.7.0_79
download url: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
package name : jdk-7u79-linux-x64.tar.gz
sudo mkdir /usr/local/jdk1.7.0_79
	##admin:admin根据当前用户名和组名修改成正确的
sudo chown admin:admin /usr/local/jdk1.7.0_79
cd /usr/local/jdk1.7.0_79
sudo wget http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
tar -xvf jdk-7u79-linux-x64.tar.gz
###@05edit user system enviroment
#解压安装包后，配置环境变量： {这里是修改当前用户的环境变量}
cd 
vi .bash_profile
#在文件最后一行添加（注意安装路径）：
  JAVA_HOME=/usr/local/jdk1.7.0_79
  JRE_HOME=$JAVA_HOME/jre
  CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
  export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME:$CLASSPATH

#保存退出后，使其生效后即可：
source .bash_profile
java -version
  java version "1.7.0_79"
  Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
  Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)
  
 ###@04 install gradle2.3 
  wget https://services.gradle.org/distributions/gradle-2.3-bin.zip
  
 ###other  confirm ,this is ont necessary 如果已安装，这不是必须的
