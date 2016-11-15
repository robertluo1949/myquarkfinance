*** Settings ***
Documentation     我的财富
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    LIST_cfdkq    integer    DICT_cf
Library           Process

*** Test Cases ***
C-07-00-TOKEN
    [Documentation]    生成TOKEN值
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    getTOKEN    @{LIST_cfdkq}[0]    ${ipaddress}

C-07-01-queryBLCouponsList
    [Documentation]    获取财富页面已有抵扣券列表
    import resource    ${CURDIR}\\resourcefile.robot
    createSession_API    ${ipaddress}    ${testdb}
    ${bizContent}    Create Dictionary    currentPage=1    pageSize=100
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    api/coupon/queryBLCouponsList
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-07-02-queryTYHistoryCouponsList
    [Documentation]    获取财富页面已使用抵扣券列表
    import resource    ${CURDIR}\\resourcefile.robot
    createSession_API    ${ipaddress}    ${testdb}
    ${bizContent}    Create Dictionary    currentPage=1    pageSize=100
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/coupon/queryHistoryBLCouponsList
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-07-03-queryTYCouponsList
    [Documentation]    获取财富页面可以体验金列表
    import resource    ${CURDIR}\\resourcefile.robot
    createSession_API    ${ipaddress}    ${testdb}
    ${bizContent}    Create Dictionary    currentPage=1    pageSize=100
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/coupon/queryTYCouponsList
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${TYJcontent}    set variable    ${content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}
    ${resData}    GET FROM DICTIONARY    ${content}    data
    log    ${resData}

C-07-04-queryTYHistoryCouponsList
    [Documentation]    获取财富页面已失效体验金列表
    import resource    ${CURDIR}\\resourcefile.robot
    createSession_API    ${ipaddress}    ${testdb}
    ${bizContent}    Create Dictionary    currentPage=1    pageSize=100
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/coupon/queryTYHistoryCouponsList
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-07-05-queryRED
    [Documentation]    获取财富页面已失效体验金列表
    import resource    ${CURDIR}\\resourcefile.robot
    createSession_API    ${ipaddress}    ${testdb}
    ${bizContent}    Create Dictionary    currentPage=1    pageSize=100
    Comment    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5
    ...    sysId=qAndroid    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211
    ...    iemi=860576034110310    idfa=    authToken=${access_token}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.1.1    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    ${urladdress}=    set variable    /api/coupon/queryRed
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${content}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${content}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${content}    resMsg
    Should Be Equal As Strings    ${resCode}    0000    ${resCode}${resMsg}

C-07-04-querydb
    QUERYDB    ${testdb}    select ID,COUPONS_NAME,PAR_VALUE,ACTIVE_STATUS,RECEIVE_TIME,EXPIRATION_DATE from coupons_use where user_no=(select user_NO from \ app_user where mobile=@{LIST_cfdkq}[0])
    ${OKtyj}    set variable    ${result}
    set suite variable    ${OKtyj}

C-07-05-comfirmdb
    No Operation
