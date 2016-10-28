*** Settings ***
Documentation     验证是否能注册新用户
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    testenv_db    integer    mobile    loginPassword    ipaddress    advertiser
...               identifies    LIST_mobile

*** Test Cases ***
C-01-01-Create_Session_API
    [Documentation]    Create API Session
    ...    建立与API服务器的session连接
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    ${mobileMORE}    ##${mobileMORE}是不限制使用的手机号

C-01-02-vialidateUser
    [Documentation]    验证该用户是否已注册
    ${lindex}    set variable    0
    ${mobile}=    set variable    @{LIST_mobile}[${lindex}]
    ${newmobile}=    set variable    @{LIST_mobile}[${lindex}]
    : FOR    ${lindex}    IN RANGE    10
    \    log    @{LIST_mobile}[${lindex}]
    \    ${mobile}    set variable    @{LIST_mobile}[${lindex}]
    \    ${rData}=    Create Dictionary    mobile=${mobile}    advertiser=${advertiser}    type=1
    \    ${urladdress}=    set variable    /api/user/validateUser
    \    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}    ##通过session 建立 POST 请求 ,请求地址urladdress, 带上body--rData
    \    ${content}    TO JSON    ${rcontent.content}
    \    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    \    ${rStatus}    GET FROM DICTIONARY    ${content}    data
    \    ${R_value}    GET FROM DICTIONARY    ${rStatus}    status
    \    Comment    Dictionary Should Contain Item    ${rStatus}    status    0    msg= \ \ This is a invaild number.[url: ${urladdress}][data: ${rStatus}]
    \    Continue For Loop If    ${R_value} == 2
    \    Continue For Loop If    ${R_value} == 3
    \    LOG    number.[url: ${urladdress}][data: ${rStatus}]
    \    RUN KEYWORD IF    '${R_value}' == '0'    set tags    ${mobile} is a correct mobile number.
    \    ${newmobile}=    replace variables    @{LIST_mobile}[${lindex}]
    \    set global variable    ${mobile}    ${newmobile}
    \    set suite variable    ${resCode}
    \    set suite variable    ${R_value}
    \    LOG    number${mobile}.[url: ${urladdress}][data: ${rStatus}]
    \    EXIT FOR LOOP
    \    RUN KEYWORD IF    ${lindex} == 9    SET TAGS    You need update LIST_mobile.
    Should Be Equal    '${resCode}'    '0000'    ${mobile} : ${rStatus}
    Should Be Equal    '${R_value}'    '0'    ${mobile} : ${rStatus}

C-01-03-sendSms
    [Documentation]    验证接口是否能发送验证短信
    ${rData}=    Create Dictionary    mobile=${mobile}    advertiser=${advertiser}    type=1
    ${urladdress}=    set variable    /api/sendSms
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}
    Comment    ${urladdress}=    set variable    /api/user/registerInfoFAP
    Comment    ${bizContent}    Create Dictionary    mobile=${mobile}    loginPassword=AEC60231D83FE6CF81444BC536596887    validateCode=999999    recommName=
    ...    resType=1
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=null

C-01-04-registerInfoAP
    [Documentation]    验证该用户是否能注册成功
    ${urladdress}=    set variable    /api/user/registerInfoFAP
    ${bizContent}    Create Dictionary    mobile=${mobile}    loginPassword=AEC60231D83FE6CF81444BC536596887    validateCode=999999    recommName=    resType=1
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=null
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    RUN KEYWORD IF    ${resCode} == 0000    LOG    ${mobile} registe successful.
    ...    ELSE IF    ${resCode} == 0207    LOG    This is a duplicated number.[url: ${urladdress}][resCode:${resCode}}
    ...    ELSE    LOG    ${resCode}
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}
    Comment    DELETE ALL SESSIONS

C-01-05-query_db
    [Documentation]    验证该用户信息是否插入数据库，app_user表
    Comment    ${ORA_SIT}    set variable    'MOBILEAPP2','mobileapp2','SIT'
    Comment    ${ORA_UAT}    set variable    'MOBILEAPP2','mobileapp2#123','UAT'
    Comment    Set Environment Variable    NLS_LANG    SIMPLIFIED_CHINESE_CHINA_UTF8
    Import Resource    ${CURDIR}\\resourcefile.robot
    QUERYDB    ${testdb}    select mobile,advertiser,app_version from app_user where \ mobile = ${mobile}
    QUERYDB    ${testdb}    select mobile,name,user_no from app_user_ext where \ mobile = ${mobile}
    QUERYDB    ${testdb}    select MOBILE,id_no,REAL_NAME from t_customer_basic where mobile = \ ${mobile}
    QUERYDB    ${testdb}    select MOBILE,CUSTOMER_CODE,ID from t_customer_mobile where mobile = \ ${mobile}
    QUERYDB    ${testdb}    select CUSTOMER_CODE,ID_NO,SELL_CHANNEL from t_customer_account where \ CUSTOMER_CODE IN (select CUSTOMER_CODE from t_customer_mobile \ WHERE mobile = \ ${mobile} \ )
    QUERYDB    ${testdb}    select user_no,COUPONS_USE_NO,COUPONS_ID,PAR_VALUE from coupons_use where \ USER_NO in (select user_no from app_user where mobile = \ ${mobile} ) and par_value=8888
