*** Settings ***
Documentation     验证更多页面的打开成功(邀请，意见反馈，帮助中心，关于我们)
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    testenv_db    integer    mobile    loginPassword    ipaddress    advertiser
...               identifies    mobileMORE    LIST_voucher

*** Test Cases ***
C-06-00-TOKEN
    [Documentation]    生成TOKEN值
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    getTOKEN    @{LIST_voucher}[0]    ${ipaddress}

C-06-01-Invit
    [Documentation]    页面
    ...    更多-邀请好友
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_voucher}[0]    ##${mobileMORE}是不限制使用的手机号
    ${bizContent}    Create Dictionary
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/inv/getInvInfo
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-06-02-Feedback
    [Documentation]    验证页面
    ...    更多-意见反馈
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_voucher}[0]
    ${bizContent}    Create Dictionary    deviceNo=860576034110310    mobile=@{LIST_voucher}[0]    comments=i am autotesting.
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/inv/getInvInfo
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-06-03-HelpCenter
    [Documentation]    验证页面
    ...    更多-帮助中心
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_voucher}[0]
    ${bizContent}    Create Dictionary    mobile=@{LIST_voucher}[0]
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/helpinfo
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-06-04-AboutUS
    [Documentation]    验证页面
    ...    更多-关于我们
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_voucher}[0]
    ${bizContent}    Create Dictionary    mobile=@{LIST_voucher}[0]
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/monthActivity/monthTaskStatus
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-06-05-userCode
    [Documentation]    验证能兑换抵扣券成功
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_voucher}[0]
    ${batch_id}    set variable    '@{LIST_voucher}[1]'    ##券码批次号
    ${status}    set variable    '@{LIST_voucher}[2]'    ##券码状态为1的，未使用
    get_VOUCHERCODE    ${testdb}    ${batch_id}    ${status}
    ${bizContent}    Create Dictionary    mobile=@{LIST_voucher}[0]    code=${VOUCHER_CODE}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    api/voucher/userCode
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}
    set tags    big version APP 未开发券码兑换，测试无效
