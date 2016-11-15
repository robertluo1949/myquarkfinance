*** Settings ***
Documentation     验证是否绑定银行卡成功
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    testenv_db    integer    mobile    loginPassword    ipaddress    advertiser
...               identifies    LIST_mobile    LIST_cardno

*** Test Cases ***
C-03-01-TOKEN
    [Documentation]    生成TOKEN值
    Import Resource    ${CURDIR}\\resourcefile.robot
    getTOKEN    ${mobile}    ${ipaddress}

C-03-02-sendSms
    [Documentation]    验证接口能发送短信验证码成功
    import resource    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    ${mobile}
    ${bizContent}    Create Dictionary    mobile=${mobile}    type=3    resType=1
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    Comment    ${rData}=    Create Dictionary    mobile=${mobile}    advertiser=${advertiser}    type=1
    ${urladdress}=    set variable    /api/sendSms
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-03-03-validateSms
    [Documentation]    验证接口能验证短信验证码成功
    ${bizContent}    Create Dictionary    mobile=${mobile}    type=3    resType=1    validateCode=999999
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/validateSms
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-03-04-cardbind
    [Documentation]    验证接口能绑定银行卡成功
    ${index}    set variable    0
    ${bizContent}    Create Dictionary    bankCardNo=@{LIST_cardno}[${index}]    bankId=305    bankName="民生银行"    bankMobile=${mobile}    mobile=${mobile}
    ...    validateCode=999999
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${resCode}    set variable
    ${bank_card_no}    set variable
    ${urladdress}=    set variable    /api/bank/cardbind
    : FOR    ${index}    IN RANGE    @{LIST_cardno}[2]
    \    ${bank_card_no_end}    convert to Integer    @{LIST_cardno}[1]    ##把手机末尾4位数转换整形
    \    ${tem_bank_card_no_end}    evaluate    ${bank_card_no_end}+${index}    ##把手机尾号+循环次数=当前手机尾号
    \    ${bank_card_no_end}    evaluate    "%04d" %${tem_bank_card_no_end}    ##把手机尾号用0补全4位数
    \    ${bank_card_no}    evaluate    '@{LIST_cardno}[0]''${bank_card_no_end}'    ##新的手机号11位=手机前7位+手机尾号4位
    \    Comment    set to dictionary    ${bizContent}    bankMobile    @{LIST_mobile}[${index}]
    \    set to dictionary    ${bizContent}    bankCardNo    ${bank_card_no}
    \    set to dictionary    ${rData}    bizContent    ${bizContent}
    \    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    \    ${content}    TO JSON    ${rcontent.content}
    \    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    \    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    \    set suite variable    ${bank_card_no}
    \    Comment    Set Suite Variable    ${resCode}
    \    COMMENT    602:验证码次数超限；603：验证码失效
    \    ${maxindex}    evaluate    @{LIST_cardno}[2]-1
    \    continue for loop if    ${resCode} == 602
    \    continue for loop if    ${resCode} == 0204
    \    continue for loop if    ${resCode} == 0225
    \    Comment    run keyword if    ${resCode} == 0109 \ \ and ${index} == 9    exit for loop
    \    continue for loop if    ${resCode} == 603
    \    PASS Execution If    ${resCode} == 0000    SET TAGS    ${bank_card_no} is a correct cardno.
    \    ${bank_card_no}    evaluate    '@{LIST_cardno}[0]''${bank_card_no_end}'
    \    run keyword if    ${index} >=20    SET TAGS    you need update LIST_cardno
    \    exit for loop IF    ${index} ==20
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-03-05-query_db
    [Documentation]    验证绑卡相关表和字段值正确
    ...    mapp_platform.coms_user_bindcard表
    ...    mapp_platform.coms_bank_card_channel表
    ...    mobileapp2.bank_card
    IMPORT RESOURCE    ${CURDIR}/resourcefile.robot
    QUERYDB    ${testdb}    select mobile,user_no,mobile,bank_card_no from mapp_platform.coms_user_bindcard where mobile=${mobile}
    QUERYDB    ${testdb}    select mobile,user_no,mobile,bank_card_no from mapp_platform.coms_bank_card_channel where mobile=${mobile}
    QUERYDB    ${testdb}    select mobile,bank_card_no,card_owner_name,identification_type,identification_no,bank_mobile,user_no from mobileapp2.bank_card where mobile=${mobile}
    Comment    QUERYDB    ${testdb}    select mobile,user_no,mobile,bank_card_no from mapp_platform.coms_user_bindcard where mobile=${mobile}

C-03-06-confirm_db
    [Documentation]    mapp_platform.coms_user_bindcard表（user_no，mobile，bank_card_no
    ...    mapp_platform.coms_bank_card_channel表（user_no，mobile，bank_card_no
    ...    mobileapp2.bank_card表中（mobile,bank_card_no,card_owner_name,identification_type,identification_no,bank_mobile,user_no
    import resource    ${CURDIR}\\resourcefile.robot
    get_bankcard    ${testdb}    ${mobile}    ${bank_card_no}
    QUERYDB    ${testdb}    select mobile,bank_card_no,card_owner_name,identification_type,identification_no,bank_mobile,user_no from mobileapp2.bank_card where mobile=${mobile} and bank_card_no='${bank_card_no}'
    Comment    get_bankcard    ${testdb}    ${mobile}    ${bank_card_no}
    should be equal    '${result[0][0]}'    '${mobile}'    mobileapp2.bank_card表，手机号不一致mobile : '${result[0][0]}'    ##核对mobile
    should be equal    '${result[0][1]}'    '${bank_card_no}'    mobileapp2.bank_card表，银行卡号不一致 bank_card_no'${result[0][1]}'    ##核对bank_card_no
    should be equal    '${result[0][2]}'    '${user_name}'    mobileapp2.bank_card表，银行卡账号名不一致 card_ower_name: '${result[0][2]}'    ##核对card_ower_name
    should be equal    '${result[0][3]}'    '${identification_type}'    mobileapp2.bank_card表，证件类别不一致identification_type :'${result[0][3]}'    ##核对identification_type
    should be equal    '${result[0][4]}'    '${ID}'    mobileapp2.bank_card表，证件号不一致 identification_no :'${result[0][4]}'    ##核对identification_no
    should be equal    '${result[0][5]}'    '${mobile}'    mobileapp2.bank_card表，银行卡手机号不一致 bank_mobile :'${result[0][5]}'    ##核对bank_mobile
    should be equal    '${result[0][6]}'    '${user_no}'    mobileapp2.bank_card表，用户ID不一致 \ user_no : '${result[0][6]}'    ##核对user_no
