*** Settings ***
Documentation     实名认证 验证是否能实名认证成功
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    integer    mobile    loginPassword    ipaddress    advertiser    LIST_identifies
...               LIST_mobile    testdb

*** Test Cases ***
C-02-01-TOKEN
    [Documentation]    生成TOKEN值
    Import Resource    ${CURDIR}\\resourcefile.robot
    getTOKEN    ${mobile}    ${ipaddress}

C-02-02-REALNAME
    [Documentation]    验证实名认证的接口能实名成功
    import resource    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    ${mobile}
    ${urladdress}=    set variable    /api/user/realName
    ${ID}    set variable    @{LIST_identifies}[0]
    Comment    ${iden}    @{LIST_identifies}[0]
    ${RCODE}=    Create Dictionary    OK="OK"    USED=USED    CHECKD="CHECKED"
    ${codeOK}=    GET FROM DICTIONARY    ${RCODE}    OK
    ${codeUSED}=    GET FROM DICTIONARY    ${RCODE}    USED
    ${index}    set variable    0
    ${bizContent}    Create Dictionary    identificationNo=${ID}    password=${loginPassword}    identificationOwnerName=AUTO    IdentificationType=0
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    : FOR    ${index}    IN RANGE    9
    \    ${ID}    set variable    @{LIST_identifies}[${index}]
    \    set global variable    ${ID}
    \    set to dictionary    ${bizContent}    identificationNo    @{LIST_identifies}[${index}]
    \    set to dictionary    ${rData}    bizContent    ${bizContent}
    \    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    \    ${gocontent}    TO JSON    ${rcontent.content}
    \    ${tt}=    Convert To String    ${rcontent.content}
    \    ${goData}    GET FROM DICTIONARY    ${gocontent}    data
    \    ${code}=    GET FROM DICTIONARY    ${goData}    code
    \    ${resMsg}    GET FROM DICTIONARY    ${goData}    message
    \    set suite variable    ${code}
    \    run keyword if    ${index} >= 9    SET TAGS    you need update ID number.
    \    Continue For Loop If    '${code}'== 'USED'
    \    PASS Execution If    '${code}'== 'OK'    SET TAGS    ${ID} is a correct ID number.
    \    PASS Execution If    '${code}'== 'OK'    exit for loop
    \    Comment    run keyword if    '${code}'== 'CHECKED'    FAIL    SET TAGS    ${mobile} is a checked mobile number.you need a new mobile number.
    should be equal    '${code}'    'OK'    ${code}${resMsg}

C-02-03-query_db
    [Documentation]    验证该用户的ID信息是否插入数据库，app_user表
    Comment    ${ORA_SIT}    set variable    'MOBILEAPP2','mobileapp2','SIT'
    Comment    ${ORA_UAT}    set variable    'MOBILEAPP2','mobileapp2#123','UAT'
    Comment    Set Environment Variable    NLS_LANG    SIMPLIFIED_CHINESE_CHINA_UTF8
    Import Resource    ${CURDIR}\\resourcefile.robot
    QUERYDB    ${testdb}    select mobile,identification_type,identification_no,identification_owner_name,real_name_time from app_user where mobile ='${mobile}' and identification_no='${ID}'
    QUERYDB    ${testdb}    select mobile,id_no,id_type,real_name from t_customer_basic where mobile ='${mobile}' and id_no='${ID}'
    QUERYDB    ${testdb}    select customer_code,id_no from t_customer_account where CUSTOMER_CODE IN (select CUSTOMER_CODE from t_customer_mobile WHERE mobile ='${mobile}')
    QUERYDB    ${testdb}    select mobile,id_type,id_no from t_customer_mobile where mobile ='${mobile}'    ##核对实名表t_customer_mobile    ##测试环境有误，id_no和id_type无法验证
    Comment    QUERYDB    ${testdb}    select identification_type,identification_no,identification_owner_name,last_update_time from real_name_log \ where IDENTIFICATION_NO ='${ID}'    ##核对实名表real_name_log    ##测试环境有误，无法验证

C-02-04-confirm_db
    [Documentation]    验证该用户的ID信息是否插入数据库
    ...    app_user表identification_type，identification_no,identification_owner_name,real_name_time
    ...    t_customer_basic表id_no,id_type,real_name
    ...    t_customer_account表中id_no正确，
    ...    t_customer_mobile表中id_type，id_no
    ...    real_name_log表id_no
    Comment    ${ORA_SIT}    set variable    'MOBILEAPP2','mobileapp2','SIT'
    Comment    ${ORA_UAT}    set variable    'MOBILEAPP2','mobileapp2#123','UAT'
    Comment    Set Environment Variable    NLS_LANG    SIMPLIFIED_CHINESE_CHINA_UTF8
    Import Resource    ${CURDIR}\\resourcefile.robot
    Comment    ${mobile}    set variable    11122220063
    Comment    ${ID}    set variable    410104198006307614
    QUERYDB    ${testdb}    select mobile,identification_type,identification_no,identification_owner_name,real_name_time from app_user where mobile ='${mobile}' and identification_no='${ID}'
    should be equal    '${result[0][0]}'    '${mobile}'    app_user表mobile 不一致 \ '${result[0][0]}'    ##核对app_user表mobile
    should be equal    '${result[0][1]}'    '0'    app_user表identification_type 不一致 \ '${result[0][1]}'    ##核对app_user表identification_type
    should be equal    '${result[0][2]}'    '${ID}'    app_user表identification_no 不一致 \ '${result[0][2]}'    ##核对app_user表identification_no
    should be equal    '${result[0][3]}'    'AUTO'    app_user表identification_owner_name 不一致 \ '${result[0][3]}'    ##核对app_user表identification_owner_name
    should not be equal    '${result[0][4]}'    'None'    app_user表real_name_time 不一致 \ '${result[0][4]}'    ##核对app_user表real_name_time
    QUERYDB    ${testdb}    select mobile,id_no,id_type,real_name,id from t_customer_basic where mobile ='${mobile}' and id_no='${ID}'
    should be equal    '${result[0][0]}'    '${mobile}'    t_customer_basic表mobile 不一致 \ '${result[0][0]}'
    should be equal    '${result[0][1]}'    '${ID}'    t_customer_basic表identification_type 不一致 \ '${result[0][1]}'
    should be equal    '${result[0][2]}'    '0'    t_customer_basic表identification_no 不一致 \ '${result[0][2]}'
    should be equal    '${result[0][3]}'    'AUTO'    t_customer_basic表identification_owner_name 不一致 \ '${result[0][3]}'
    ${CUSTOMER_CODE}    set Variable    ${result[0][4]}    ##取出t_customer_basic表的customer_code值
    QUERYDB    ${testdb}    select customer_code,id_no from t_customer_account where CUSTOMER_CODE IN (select CUSTOMER_CODE from t_customer_mobile WHERE mobile ='${mobile}')
    should be equal    '${result[0][0]}'    '${CUSTOMER_CODE}'    t_customer_account表CUSTOMER_CODE 不一致 \ '${result[0][0]}'
    should be equal    '${result[0][1]}'    '${ID}'    t_customer_account表id_no 不一致 \ '${result[0][1]}'
    Comment    QUERYDB    ${testdb}    select mobile,id_type,id_no from t_customer_mobile where mobile ='${mobile}'    ##核对实名表t_customer_mobile    ##测试环境有误，id_no和id_type无法验证，用例已删除
    Comment    run keyword if    '${result[0][1]}' =='None' or '${result[0][2]}' =='None'    Set Tags    t_customer_mobile 表测试环境无法验证id_type,id_no
    Comment    QUERYDB    ${testdb}    select identification_type,identification_no,identification_owner_name,last_update_time from real_name_log \ where IDENTIFICATION_NO ='${ID}'    ##核对实名表real_name_log    ##测试环境有误，无法验证
    QUERYDB    ${testdb}    select identification_type,identification_no,identification_owner_name,last_update_time from real_name_log where rownum <=1 \ order by last_update_time desc    ##核对实名表real_name_log    ##测试环境有误，无法验证
    run keyword Unless    '${result[0][0]}' =='0' and '${result[0][1]}' =='${ID}'    Set Tags    real_name_log 表测试环境无法验证last_update_time,create_time
