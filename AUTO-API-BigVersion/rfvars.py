# -*- coding:utf-8 -*- 
import random
'''
'testdb_env','mobile','loginPassword','integer','ipaddress','advertiser','LIST__identifies']
you can get many variables from 'rfvars.py',such as 
moible : 13022220438        ##手机号 ,暂不使用
LIST_mobile=['1112222','0070','10'] ##LIST_mobile=['1112222','0070','10'] '1112222'代表手机前7位，'0070'代表手机号后4位，'10'代表计算后四位范围
loginPassword : AEC60231D83FE6CF81444BC536596887    ##密码 123456q
integer : random number     ##随机数
ipaddress : http://172.26.182.238:8080    ##API地址
advertiser ： automated    ##渠道号
LIST__identifies ：610103197902022189    ##身份证号，一次写10个，用身份证号码生成工具生成
testdb : ORA_SIT   [ORA_SIT | ORA_UAT]测试环境名称
LIST_cardno = ['622615900090','0060','20']##LIST_cardno = ['622615900090','0060','20'] '622615900090'代表银行卡号前12位，'0060'代表银行卡号后4位，'20'代表计算后四位范围  民生银行
LIST_caiduobao = ['mobile','pid','txAmt','cardid','answer_id'] 关于猜多宝产品的信息，mobile是username,pid是产品ID,txAmt是金额,answer_id是选择答案A的字符串
##LIST_caifuyoujia = ['mobile','pid','txAmt','cardid','answer_id',‘coupons_name_抵扣券','coupons_name_体验金'] 关于财富优加的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,answer_id是选择答案A的字符串,id是身份证号
'''
#__all__ = ['mobile','loginPassword','integer','ipaddress','advertiser','LIST__identifies']
__all__ = ['mobile','mobileMORE','LIST_mobile','loginPassword','gesturePwd','name','ipaddress',\
'advertiser','LIST_identifies','testdb','LIST_cardno','LIST_caiduobao','LIST_caifuyoujia',\
'LIST_cfdkq','LIST_cftyj','LIST_cfhb','LIST_voucher']
###########################################关于测试环境######################
#testdb = "'MOBILEAPP2','mobileapp2','SIT'"
#testdb = "'MOBILEAPP2','mobileapp2#123','UAT'"
testdb = "'MOBILEAPP2','mobileapp2','T24'"
#ipaddress = "172.26.182.238:8080"  ##连接 shuibom
#ipaddress = "172.16.250.181:8080"  ##连接SIT 181机器
#ipaddress = "172.16.1.165:8080"  ##连接UAT 165机器
ipaddress = "172.26.186.82:8080"  ##连接T24 82机器
###########################################关于测试环境######################
###########################################关于注册实名绑卡信息###############
mobile = '11122220017' 
mobileMORE = '13022220001'  ###,[邀请]使用的手机号, 不限制使用的手机号码
name = 'AUTO' ##用户名，客户姓名
advertiser = "automated"
##LIST_mobile注册时使用的手机号
LIST_mobile=['1112222','0150','20'] ##LIST_mobile=['1112222','0070','10'] '1112222'代表手机前7位，'0070'代表手机号后4位，'10'代表计算后四位范围
loginPassword = "AEC60231D83FE6CF81444BC536596887" ##登录密码123456q
gesturePwd="A3680C6E501817BA33A063289A47BD63"##手势密码7
##LIST_identifies ：身份证号码保留，目前已实现自动生成，不在从配置文件获取
LIST_identifies =['222404197803301399','371501196010111012','370103199109304374','130133199403204116','320103198611169899',\
'430124199706154157','610113199301257371','350105199607205669','220103197612079336','220112198305169033']
##LIST_cardno : 民生银行卡号16位卡bin
LIST_cardno = ['622615900090','0160','20']##LIST_cardno = ['622615900090','0060','20'] '622615900090'代表银行卡号前12位，'0060'代表银行卡号后4位，'20'代表计算后四位范围
###########################################关于注册实名绑卡信息###############
###########################################关于交易购买#######################
##LIST_caiduobao = ['mobile','pid','txAmt','cardid','answer_id',‘coupons_name_抵扣券','coupons_name_体验金'] 关于猜多宝产品的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,answer_id是选择答案A的字符串,guessId是猜的答案
LIST_caiduobao = ['13022220010','4785','1000','622006100010001010','60A5400396DC4F63AF9F6BFBE58D552F',\
'AUTO-API-07-DKQ','AUTO-API-07-TYJ','4B55E7B65751407F88C1A4CF87C8D570']
##LIST_caifuyoujia = ['mobile','pid','txAmt','cardid','SUBSIDY_RATE',‘coupons_name_抵扣券','coupons_name_体验金'] 关于财富优加的信息，mobile是username,pid是产品ID,txAmt是金额,cardid是银行卡号,SUBSIDY_RATE是财富优加的补贴收益率,coupons_name是抵扣券名字coupons_name是体验金名字
LIST_caifuyoujia = ['13022220008','4790','1000','4336701000200010','','AUTO-API-08-DKQ','AUTO-API-08-TYJ']
###########################################关于交易购买#######################
###########################################关于财富的配置信息###############
LIST_cfdkq=['13022220120','016','1','AUTO-KQDH-01']##[财富]抵扣券配置
LIST_cftyj=['13022220120','016','1','AUTO-KQDH-01']##[更多]体验金配置
LIST_cfhb=['13022220120','016','1','AUTO-KQDH-01']##[更多]红包配置
###########################################更多的输入信息###############
###########################################更多的输入信息###############
LIST_voucher=['13022220001','016','1','AUTO-KQDH-01']##[更多]使用的手机号,券码批次号，券码使用状态未使用的,券码兑换原因
###########################################更多的输入信息###############