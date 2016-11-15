*** Settings ***
Documentation     验证是否能注册新用户
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    testenv_db    mobile    loginPassword    ipaddress    advertiser    identifies
...               LIST_mobile    gesturePwd    mobileMORE

*** Test Cases ***
C-01-01-Create_Session_API
    [Documentation]    Create API Session
    ...    建立与API服务器的session连接
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    ${mobileMORE}    ##${mobileMORE}是不限制使用的手机号
    Comment    getTOKEN    ${mobile}    ${ipaddress}

C-01-02-vialidateUser
    [Documentation]    验证该用户是否已注册
    ${lindex}    set variable    0
    : FOR    ${lindex}    IN RANGE    @{LIST_mobile}[2]
    \    log    @{LIST_mobile}[2]
    \    ${mobileend}    convert to Integer    @{LIST_mobile}[1]    ##把手机末尾4位数转换整形
    \    ${tempmobileend}    evaluate    ${mobileend}+${lindex}    ##把手机尾号+循环次数=当前手机尾号
    \    ${mobileend}    evaluate    "%04d" %${tempmobileend}    ##把手机尾号用0补全4位数
    \    ${mobile}    evaluate    '@{LIST_mobile}[0]''${mobileend}'    ##新的手机号11位=手机前7位+手机尾号4位
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
    \    ${newmobile}=    replace variables    ${mobile}
    \    set global variable    ${mobile}    ${newmobile}
    \    set suite variable    ${resCode}
    \    set suite variable    ${R_value}
    \    LOG    number${mobile}.[url: ${urladdress}][data: ${rStatus}]
    \    EXIT FOR LOOP
    \    ${maxindex}    evaluate    @{LIST_mobile}[2]-1
    \    RUN KEYWORD IF    ${lindex} >= ${maxindex}    SET TAGS    You need update LIST_mobile.
    \    EXIT FOR LOOP IF    ${lindex} >= 100
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
    Comment    ${urladdress}=    set variable    /api/user/registerFAP
    ${urladdress}=    set variable    /api/user/registerInfoFAP
    ${bizContent}    Create Dictionary    mobile=${mobile}    loginPassword=AEC60231D83FE6CF81444BC536596887    validateCode=999999    recommName=${mobileMORE }    resType=1
    ${rData}=    Create Dictionary    timestamp=1478140485378    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
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

C-01-05-TOKEN
    [Documentation]    生成token值
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    getTOKEN    ${mobile}    ${ipaddress}

C-01-06-modGesturePwd
    [Documentation]    设定手势密码为 7，加密字符串 \ A3680C6E501817BA33A063289A47BD63
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    ${urladdress}=    set variable    /api/user/modGesturePwd
    ${bizContent}    create dictionary
    Comment    ${bizContent}    create dictionary    gesturePwd=A3680C6E501817BA33A063289A47BD63    ##gesturePwd参数不能通过bizContent参数来传递
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    gesturePwd=A3680C6E501817BA33A063289A47BD63    sign=B7F1295798E2EBC3742C6D36BA43B3C4    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    RUN KEYWORD IF    ${resCode} == 0000    Set Tags    gesturePwd configured successful. (7)
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-01-07-query_db
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

C-01-08-confirm_db
    [Documentation]    核对
    ...    app_user表插入一条数据（mobile,advertiser,app_version存值正确）
    ...    t_customer_basic插入一条数据（mobile正确，GESTURE_PWD正确）
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    QUERYDB    ${testdb}    select MOBILE,GESTURE_PWD from t_Customer_Basic where mobile=${mobile}
    Should be equal    ${result[0][1]}    ${gesturePwd}    手势密码不一致 ${result[0][1]} !=${gesturePwd}
    QUERYDB    ${testdb}    select mobile,advertiser,app_version from app_user where mobile = ${mobile}
    Should be equal    ${result[0][0]}    ${mobile}    手机号不一致 ${result[0][0]} !=${mobile}
    Should be equal    ${result[0][1]}    ${advertiser}    渠道号不一致 ${result[0][1]} !=${advertiser}
    Should be equal    ${result[0][2]}    3.1.1    app_version不一致 ${result[0][2]} !=3.0.9
    QUERYDB    ${testdb}    select user_no from app_user where mobile=${mobile}    ##获取邀请人的user_no
    ${inv_user_no}    set variable    '${result[0][0]}'
    QUERYDB    ${testdb}    select user_no from app_user where mobile=${mobileMORE}    ##获取被邀请人的inv_user_no
    ${temp_user_no}    set variable    '${result[0][0]}'
    QUERYDB    ${testdb}    select USER_NO,INV_USER_NO from inv_user where inv_user_no in(select user_no from app_user where mobile=${mobile})
    Should be equal    '${result[0][0]}'    ${temp_user_no}    邀请人user_no不一致 '${result[0][0]}' !=${temp_user_no}
    Should be equal    '${result[0][1]}'    ${inv_user_no}    被邀请人inv_user_no不一致 '${result[0][1]}' !=${inv_user_no}
