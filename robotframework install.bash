robotframework install.bash


###############
###:@Target:    how to intall robotframwork and go to start 
###:Author:     Robert Luo
###:DATE :      20160811
###:Email :     robert_luo1949@163.com
###:Deploy env: Centos 6.6
###:Other:      robotframwork version : 3.0
###############
####content structure###
install  python 2.7.12
install  setuptools  /  pip
install  robotframwork 
install  wxPython
install  robotframwork-ride
install  oracle_instantclient
install  cx_oracle
####content structure###

##python  install
##安装python需要的组件
sudo yum groupinstall “Development tools”
sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-develtar xf Python-2.7.10.tar.xz

sudo wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
tar xf Python-2.7.12.tar.xz
cd Python-2.7.12 

sudo su - root ###swith to root user, if not do this may face some  problems  about Permission delay
./configure –prefix=/usr/local
make && make install 
make clean 
make distclean

#change system python command to 2.7 version
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/bin/python2.7 /usr/bin/python

python --version
  Python 2.7.12

##modify python version within yum invoking python
vi /usr/bin/yum
  ##Before changed
  #!/usr/bin/python
  ##After changed
  #!/usr/bin/python2.6
  
#参考 URL  
#referance URL:http://www.linuxidc.com/Linux/2016-02/128452.htm


##install  setuptools  /  pip
sudo wget https://bootstrap.pypa.io/get-pip.py
chmod +x  get-pip.py
python get-pip.py
##upgrade setuptools and pip
pip install -U setuptools
pip install -U pip
## check pip version
pip --version
  pip 8.1.2 from /usr/local/lib/python2.7/site-packages (python 2.7)
##参考
referance URL:http://www.linuxidc.com/Linux/2016-05/131090.htm


##install  robotframwork
sudo su - root
pip install -U robotframework


##install  wxPython


##install  robotframwork-ride
pip install -U robotframework-ride

##install robot library
pip install -U robotframework-selenium2library
pip install -U robotframework-databaselibrary
pip install -U robotframework-requests
##参考如下
##referance URL: http://blog.csdn.net/youcharming/article/details/45341493




###install cx_oracle
##下载安装包，把三个包的内容整合一起，其中sqlplus是调试用的
wget http://download.oracle.com/otn/linux/instantclient/11204/instantclient-basic-linux.x64-11.2.0.4.0.zip
wget http://download.oracle.com/otn/linux/instantclient/11204/instantclient-sdk-linux.x64-11.2.0.4.0.zip
wget http://download.oracle.com/otn/linux/instantclient/11204/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip

##解压到/usr/local/instantclient_11_2
unzip 
##增加TNS目录
cd /usr/local/instantclient_11_2
mkdir NETWORK/admin
#整合到instantclient_11_2如下
	-rw-rw-r--. 1 cmadmin cmadmin     25420 Aug 25  2013 adrci
	-rw-rw-r--. 1 cmadmin cmadmin       439 Aug 25  2013 BASIC_README
	-rw-rw-r--. 1 cmadmin cmadmin     47860 Aug 25  2013 genezi
	-rw-rw-r--. 1 cmadmin cmadmin       368 Aug 18 10:10 glogin.sql
	lrwxrwxrwx. 1 cmadmin cmadmin        17 Aug 17 16:57 libclntsh.so -> libclntsh.so.11.1
	-rw-rw-r--. 1 cmadmin cmadmin  53865194 Aug 25  2013 libclntsh.so.11.1
	-rw-rw-r--. 1 cmadmin cmadmin   7996693 Aug 25  2013 libnnz11.so
	lrwxrwxrwx. 1 cmadmin cmadmin        15 Aug 17 16:56 libocci.so -> libocci.so.11.1
	-rw-rw-r--. 1 cmadmin cmadmin   1973074 Aug 25  2013 libocci.so.11.1
	-rw-rw-r--. 1 cmadmin cmadmin 118738042 Aug 25  2013 libociei.so
	-rw-rw-r--. 1 cmadmin cmadmin    164942 Aug 25  2013 libocijdbc11.so
	-rw-rw-r--. 1 cmadmin cmadmin   1503303 Aug 18 10:11 libsqlplusic.so
	-rw-rw-r--. 1 cmadmin cmadmin   1477446 Aug 18 10:10 libsqlplus.so
	drwxr-xr-x. 4 cmadmin cmadmin      4096 Aug 17 18:50 NETWORK
	-rw-rw-r--. 1 cmadmin cmadmin   2091135 Aug 25  2013 ojdbc5.jar
	-rw-rw-r--. 1 cmadmin cmadmin   2739616 Aug 25  2013 ojdbc6.jar
	drwxrwxr-x. 4 cmadmin cmadmin      4096 Aug 17 16:25 sdk
	-rwxrwxr-x. 1 cmadmin cmadmin      9352 Aug 18 10:43 sqlplus
	-rw-rw-r--. 1 cmadmin cmadmin       441 Aug 18 10:12 SQLPLUS_README
	-rw-rw-r--. 1 cmadmin cmadmin    192365 Aug 25  2013 uidrvci
	-rw-rw-r--. 1 cmadmin cmadmin     66779 Aug 25  2013 xstreams.jar




##增加环境变量
cd
vi .bash_profile
	ORACLE_HOME=/usr/local/instantclient_11_2
	if [ "$LD_LIBRARY_PATH" = "" ]; then
		export LD_LIBRARY_PATH=$ORACLE_HOME
	else
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
	fi

	export TNS_ADMIN=$ORACLE_HOME/NETWORK/admin
	export PATH=$PATH:$ORACLE_HOME:$ORACLE_HOME/sdk


##到/usr/local/instantclient_11_2目录下
cd /usr/local/instantclient_11_2
ln -fs libocci.dylib.11.1 libocci.dylib
ln -fs libclntsh.so.11.1 libclntsh.so

##把sqlplus添加到bin中
cd /usr/bin
sudo ln -fs /usr/local/instantclient_11_2/sqlplus sqlplus

##用sqlplus验证
sqlplus /nolog
conn mobileapp2/mobileapp2@t24CAIMITEST

	SQL> show parameter service;

	NAME				     TYPE	 VALUE
	------------------------------------ ----------- ------------------------------
	service_names			     string	 caimi_test

##执行cx_Oracle安装命令
pip install cx_Oracle --allow-external cx_Oracle --allow-unverified cx_Oracle 

##在Python中导入cx_Oracle
python
import cx_Oracle
conn=cx_Oracle.connect("MOBILEAPP2","mobileapp2#123","UAT")
####如果没有显示错误即说明安装OK####
