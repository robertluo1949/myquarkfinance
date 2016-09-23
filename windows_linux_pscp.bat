@ECHO OFF

if 1==0 (
###############
###:@Target:    how to copy files from windows to  linux
###:Author:     Robert Luo
###:DATE :      20160923
###:Email :     robert_luo1949@163.com
###:Deploy env: windows 7 professional
###:Other:      jenkins version : 2.7.2
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
cmd.exe
pscp
REM print as follow if content
:: PuTTY Secure Copy client
:: Release 0.67
)
REM #@05 get more
echo http://www.zoneself.org/2013/03/27/content_2113.html
