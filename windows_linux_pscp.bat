@ECHO OFF

if 1==0 (
###############
###:@Target:    how to copy files from windows to  linux
###:Author:     Robert Luo
###:DATE :      20160923
###:Email :     robert_luo1949@163.com
###:Deploy env: windows 7 professional
###:Other:      pscp version : 0.67
###############

####content structure###
#@01 download pscp
#@02 install pscp 
#@03 configure enviroment variable
#@04 start pscp
#@05 get more
####content structure###
)
@ECHO ON

REM #@01 download pscp
rem  goto following site and download [PSCP: pscp.exe] 
rem  http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
REM #@02 install pscp
REM 可执行程序直接使用
echo  D:\Program Files\pscp\pscp.exe

REM #@03 configure enviroment variable
echo 编辑系统环境变量的PATH，在最后增加“;D:\Program Files\pscp”


REM #@04 start pscp
::cmd.exe
SET pscppath=D:\Program Files\pscp
cd /d %pscppath%
pscp.exe
REM print as follow if content
:: PuTTY Secure Copy client
:: Release 0.67

REM #@05 get more
echo http://www.zoneself.org/2013/03/27/content_2113.html
pause
echo 1、把服务器上的/root/dir目录取回本地”C:\My Documents\data\”目录
echo C:\>pscp.exe -r root@192.168.32.50:/root/dir “C:\My Documents\data\”
pause
echo 2、把服务器上的/root/file文件取回来本地当前目录
echo C:\>pscp.exe root@192.168.32.50:/root/file .
pause
echo 3、把本地目录dir、文件file传输到Linux服务器的/root/，并指定服务器端口2009
echo C:\>pscp.exe -P 2009 -r dir file root@192.168.32.50:/root/
pause 
echo 4、把本地文件file传输到Linux服务器的/root/
echo C:\>pscp.exe file 192.168.32.50:/root/
