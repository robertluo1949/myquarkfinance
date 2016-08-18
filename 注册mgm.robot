*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           DatabaseLibrary

*** Variables ***
${mobileinput}    \    # 13022220190
${mobilecount}    1    # 1
${hosturlinput}    \    # http://172.26.186.54:9002
${result_dict}    ${EMPTY}
${result_list}    ${EMPTY}

*** Test Cases ***
register
    Comment    ${mobile}=    set variable if    ${mobile} == None    13022220001
    ${mobile}    get variable value    ${mobileinput}    #第一个注册手机号
    ${mobile_count}    set variable    1    #注册手机号的个数
    ${mobile_count}    get variable value    ${mobilecount}    #注册手机号的个数
    ${env_url}    get variable value    ${hosturlinput}    #环境的IP地址和端口
    ${mobile_max}=    Evaluate    ${mobile}+${mobilecount}    #最大手机号+1
    Comment    ${mobile_max}=    Evaluate    ${mobile}+${mobile_count}    #最大手机号+1
    Comment    ${env_url}    set variable    http://172.26.186.54:9002    #环境的IP地址和端口
    ${channel}    set variable    &channel=7ead27f41c97c079    #16位MD5加密的小写渠道号
    ${validateCode}    set variable    &validateCode=999999    #短信验证码
    ${channe_lType}    set variable    &channelType=2    #渠道类型
    ${password}    set variable    &password=AEC60231D83FE6CF81444BC536596887    #32位大写MD5加密的密码，也就是123456q
    ${url_msg}    set variable    /api/register/sendSms    #短信验证接口地址
    ${url_register}    set variable    /api/register/submit    #新户注册手机接口地址
    ${result_dict}    Create dictionary
    ${result_list}    Create List
    set suite variable    ${result_dict}
    set suite variable    ${result_list}
    : FOR    ${mobile_now}    IN RANGE    ${mobile}    ${mobile_max}
    \    Comment    ${mobile}    set variable    ${mobile}    #获取新的手机号
    \    ${mobileconn}    set variable    ?mobile=    #mobile连接符号
    \    ${url_msg_temp}    set variable    ${url_msg}${mobileconn}${mobile_now}    #获取带新手机号的短信地址
    \    ${url_register_temp}    set variable    ${url_register}${mobileconn}${mobile_now}${validateCode}${password}${channel}${channe_lType}    #获取带新手机号的注册地址
    \    log    ${mobile_now}
    \    ${strmobile}=    evaluate    str(${mobile_now})
    \    Create Session    api    ${env_url}    #建立session
    \    ${msg}    POST REQUEST    api    ${url_msg_temp}    #发送获取手机短信的请求
    \    Comment    Should Be Equal As Strings    ${addr.status_code}    200
    \    ${register_data}    Post Request    api    ${url_register_temp}    #发送注册手机号的请求
    \    ${requestdata}    create dictionary
    \    ${requestdata}    TO JSON    ${register_data.content}    #转换成Json数据格式
    \    ${resCode}=    Get From Dictionary    ${requestdata}    resCode
    \    Comment    Should Be Equal As Strings    ${addr_redata.status_code}    200
    \    Comment    Should Be Equal As Strings    ${addr_redata.rescode}    0207
    \    sleep    1s
    \    DELETE ALL SESSIONS
    \    run keyword if    ${resCode}==0    set to dictionary    ${result_dict}    ${strmobile}    'PASS'
    \    run keyword if    ${resCode}==1    set to dictionary    ${result_dict}    ${strmobile}    'FAIL'
    \    APPEND TO LIST    ${result_list}    ${mobile}
    \    RUN KEYWORD IF    ${mobile}==${mobile_max}    Exit For Loop
    Log many    ${result_dict}
    log many    ${mobile}

oracle
    ${mobile}    get variable value    ${mobileinput}    #第一个注册手机号
    ${mobile_count}    get variable value    ${mobilecount}    #注册手机号的个数
    ${mobile_max}=    Evaluate    ${mobile}+${mobilecount}    #最大手机号+1
    ${SQL_start}    SET VARIABLE    select mobile,advertiser from app_user where mobile IN (
    ${SQL_mid}    SET VARIABLE    ${mobile}
    SET SUITE VARIABLE    ${SQL_mid}
    ${SQL_end}    SET VARIABLE    )
    Connect To Database Using Custom Params    cx_Oracle    "MOBILEAPP2","mobileapp2#123","UAT"
    ${sql_result}    set variable    ${SQL_start}${SQL_mid}${SQL_end}
    EXECUTE SQL STRING    ${sql_result}
    ${result}    Query    ${sql_result}
    DISCONNECT FROM DATABASE
    log    ${result}
