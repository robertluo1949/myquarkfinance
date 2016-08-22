###############
###:@Target:    how to intall jenkins and go to start 
###:Author:     Robert Luo
###:DATE :      20160822
###:Email :     robert_luo1949@163.com
###:Deploy env: windows 
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

下载一个jenkins安装包，这里推荐jar包并且附带了一个。其他下载地址请到https://jenkins.io/index.html。
其他的部署的方法不推荐新手使用，比如方法二，系统服务启动，方法三，tomcat启动war包.

###@02 starting  jenkins
在d盘新建一个文件夹jenkins_local
把war包和bat文件放入新建的文件夹内,点击D:\jenkins_local目录下startup.bat文件启动

####03 如果未能启动，请确认系统安装了jdk，并且加入了系统环境变量
输入java  -verison
有java的版本信息提示

###@04 打开本机的网址如下
http://localhost:9999/

###@05 linux下的安装可以参加另个说明，网址如下
https://github.com/robertluo1949/myquarkfinance/blob/master/jenkins%20install

