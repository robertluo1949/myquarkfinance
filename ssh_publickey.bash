#!/bin/sh

###############
###:@Target:    use SSH public key access remote machine 
###:Author:     Robert Luo
###:DATE :      20160905
###:Email :     robert_luo1949@163.com
###:Deploy env: Centos 6.6
###:Other:      
###############

####@@@00 content structure###
        ###@01  create public key from MACHINE-A
        ###@02  send public key to MACHINE-B 
        ###@03  configure SSH key on MACHINE-B
        ###@04  configure ssh config file on MACHINE-B
        ###@05  grant config files on MACHINE-B

####content structure###


###@01  create public key from MACHINE-A
ssh-keygen -t rsa
ls ~/.ssh
#可以看到两个密钥文件：id_rsa（私钥） id_rsa.pub（公钥）
###@02  send public key to MACHINE-B 
scp ~/.ssh/id_rsa.pub  jenkins@172.26.182.152:/home/jenkins/.ssh/
###@03  configure SSH key on MACHINE-B
##如果没有则添加
touch authorized_keys
cd ~/.ssh
cat -n /home/jenkins/.ssh/id_rsa.pub >> authorized_keys 
#将公钥内容加入到authorized_keys文件，没有则新建一个就行
###@04  configure ssh config file
vi ~/.ssh/config
   Host jenkins  #别名，域名缩写
   HostName jenkins.com  #完整的域名
   User jenkins  #登录该域名使用的账号名
   PreferredAuthentications publickey  #有些情况或许需要加入此句，优先验证类型ssh
   IdentityFile ~/.ssh/id_rsa #私钥文件的路径
###@05  grant config files
cd  ~/.ssh
chmod 600 *
###.ssh/ file directory
 ls -ltr
-rw-------. 1 cmadmin cmadmin 1679 Sep  5 11:50 id_rsa
-rw-------. 1 cmadmin cmadmin  140 Sep  5 13:52 config
-rw-------. 1 cmadmin cmadmin  412 Sep  5 13:55 id_rsa.pub
-rw-------. 1 cmadmin cmadmin  419 Sep  5 13:55 authorized_keys
