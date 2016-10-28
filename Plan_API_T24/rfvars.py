# -*- coding:utf-8 -*- 
import random
'''
'testdb_env','mobile','loginPassword','integer','ipaddress','advertiser','LIST__identifies']
you can get many variables from 'rfvars.py',such as 
moible : 13022220438        ##手机号 ,暂不使用
LIST_mobile :['13022220460','13022220461'.'13022220462'] 数组类型的手机号，一次写10个，尾数从0到9
loginPassword : AEC60231D83FE6CF81444BC536596887    ##密码 123456q
integer : random number     ##随机数
ipaddress : http://172.26.182.238:8080    ##API地址
advertiser ： automated    ##渠道号
LIST__identifies ：610103197902022189    ##身份证号，一次写10个，用身份证号码生成工具生成
testdb : ORA_SIT   [ORA_SIT | ORA_UAT]测试环境名称
LIST_cardno = ['6226159000900101'] 绑定的卡号 ，卡bin 622615  总长度 16位  民生银行
LIST_caiduobao = ['mobile','pid','txAmt','cardid','answer_id'] 关于猜多宝产品的信息，mobile是username,pid是产品ID,txAmt是金额,answer_id是选择答案A的字符串
##LIST_caifuyoujia = ['mobile','pid','txAmt','cardid','answer_id',‘coupons_name_抵扣券','coupons_name_体验金'] 关于财富优加的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,answer_id是选择答案A的字符串,id是身份证号
'''
#__all__ = ['mobile','loginPassword','integer','ipaddress','advertiser','LIST__identifies']
__all__ = ['mobile','mobileMORE','LIST_mobile','loginPassword','integer','ipaddress',\
'advertiser','LIST_identifies','testdb','LIST_cardno','LIST_caiduobao','LIST_caifuyoujia']
#testdb = "'MOBILEAPP2','mobileapp2','SIT'"
#testdb = "'MOBILEAPP2','mobileapp2#123','UAT'"
testdb = "'MOBILEAPP2','mobileapp2','T24'"
#ipaddress = "172.26.182.238:8080"  ##连接 shuibom
#ipaddress = "172.16.250.181:8080"  ##连接SIT 181机器
#ipaddress = "172.16.1.165:8080"  ##连接UAT 165机器
ipaddress = "172.26.186.82:8080"  ##连接T24 82机器
mobile = '11122220017'
mobileMORE = '13022220001'  ###不限制使用的手机号码
LIST_mobile=['11122220060','11122220061','11122220062','11122220063','11122220064',\
'11122220065','11122220066','11122220067','11122220068','11122220069']
loginPassword = "AEC60231D83FE6CF81444BC536596887"
integer = random.randint(1,10)
advertiser = "automated"
##LIST_identifies ：身份证号码
LIST_identifies =['340101199306288619','33010319940922482x','220101197607127230','410104198006307614','530423199007076114',\
'220112199201196998','230101199209288275','530103198712168384','530402199201066436','430124199311085054']
##LIST_cardno : 银行卡号
LIST_cardno = ['6226159000900040','6226159000900041','6226159000900042','6226159000900043','6226159000900044',\
'6226159000900045','6226159000900046','6226159000900047','6226159000900048','6226159000900049']
##LIST_caiduobao = ['mobile','pid','txAmt','cardid','answer_id',‘coupons_name_抵扣券','coupons_name_体验金'] 关于猜多宝产品的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,answer_id是选择答案A的字符串
LIST_caiduobao = ['11122220017','4785','1000','6226159000900002','2ED566D554E74A1F88D3909F8DDA1E17','AUTO-API-06-DKQ','AUTO-API-06-TYJ']
#LIST_caiduobao = ['11122220018','4785','1000','320103198609079341','2ED566D554E74A1F88D3909F8DDA1E17']
##LIST_caifuyoujia = ['mobile','pid','txAmt','cardid','SUBSIDY_RATE',‘coupons_name_抵扣券','coupons_name_体验金'] 关于财富优加的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,SUBSIDY_RATE是财富优加的补贴收益率,coupons_name是抵扣券名字coupons_name是体验金名字
LIST_caifuyoujia = ['11122220017','4790','1000','6226159000900002','','AUTO-API-06-DKQ','AUTO-API-06-TYJ']
##LIST_caifuyoujia = ['11122220017','4790','1000','6226159000900120','','AUTO-API-06-DKQ','AUTO-API-06-TYJ']