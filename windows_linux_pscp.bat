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
REM ��ִ�г���ֱ��ʹ��
echo  D:\Program Files\pscp\pscp.exe

REM #@03 configure enviroment variable
echo �༭ϵͳ����������PATH����������ӡ�;D:\Program Files\pscp��


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
echo 1���ѷ������ϵ�/root/dirĿ¼ȡ�ر��ء�C:\My Documents\data\��Ŀ¼
echo C:\>pscp.exe -r root@192.168.32.50:/root/dir ��C:\My Documents\data\��
pause
echo 2���ѷ������ϵ�/root/file�ļ�ȡ�������ص�ǰĿ¼
echo C:\>pscp.exe root@192.168.32.50:/root/file .
pause
echo 3���ѱ���Ŀ¼dir���ļ�file���䵽Linux��������/root/����ָ���������˿�2009
echo C:\>pscp.exe -P 2009 -r dir file root@192.168.32.50:/root/
pause 
echo 4���ѱ����ļ�file���䵽Linux��������/root/
echo C:\>pscp.exe file 192.168.32.50:/root/
