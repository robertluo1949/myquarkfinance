*** Settings ***
Documentation     验证交易(购买财富优加)成功
Suite Teardown    DELETE ALL SESSIONS
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Variables         rfvars.py    testenv_db    integer    mobile    loginPassword    ipaddress    advertiser
...               identifies    LIST_mobile    LIST_cardno    LIST_caiduobao    LIST_caifuyoujia

*** Test Cases ***
C-05-01-TOKEN
    [Documentation]    生成TOKEN值
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    getTOKEN    @{LIST_caifuyoujia}[0]    ${ipaddress}

C-05-02-saveTxInfoNew
    [Documentation]    验证交易的接口是否交易成功(使用体验金和抵扣券)
    import resource    ${CURDIR}\\resourcefile.robot
    createSESSION_API    ${ipaddress}    @{LIST_caifuyoujia}[0]
    ${urladdress}=    set variable    /api/trade/saveTxInfoNew
    ${idTyjList}    set variable
    ${idDkqList}    set variable
    QUERYDB    ${testdb}    select MIN(ID) from coupons_use where \ coupons_name='@{LIST_caifuyoujia}[5]' and active_status='3' and user_no = (select user_no from app_user where mobile = @{LIST_caifuyoujia}[0])
    ${idDkqList}=    set variable    ${result[0][0]}
    QUERYDB    ${testdb}    select MIN(ID) from coupons_use where \ coupons_name='@{LIST_caifuyoujia}[6]' and active_status='3' and user_no = (select user_no from app_user where mobile = @{LIST_caifuyoujia}[0])
    ${idTyjList}=    set variable    ${result[0][0]}
    set suite variable    ${idDkq}    ${idDkqList}    ##抵扣券的ID号
    set suite variable    ${idTyj}    ${idTyjList}    ##体验金的ID号
    Comment    set suite variable    ${idTyj}    ${idTyjList}
    Comment    set suite variable    ${idDkq}    ${idDkqList}
    ${bizContent}    Create Dictionary    pid=@{LIST_caifuyoujia}[1]    txAmt=@{LIST_caifuyoujia}[2]    bankCardNo=@{LIST_caifuyoujia}[3]    password=${loginPassword}    isUseRed=5
    ...    channel=100001    productTypeId=2070    idList=${idDkqList}    idTyList=${idTyjList}
    ${rData}=    Create Dictionary    timestamp=1574539564846    bizContent=${bizContent}    sign=38E37ADB3D422201197F77D608E2B399    signType=MD5    sysId=qAndroid
    ...    appVersion=3.0.9    appBuildVersion=20160913    advertiser=${advertiser}    mac=3c:b6:b7:5c:c4:94    ip=172.26.183.211    iemi=860576034110310
    ...    idfa=    authToken=${access_token}
    Comment    ${bizContent}    Create Dictionary    pid=@{LIST_caifuyoujia}[1]    txAmt=@{LIST_caifuyoujia}[2]    bankCardNo=@{LIST_caifuyoujia}[3]    password=${loginPassword}
    ...    isUseRed=5
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData}
    ${gocontent}    TO JSON    ${rcontent.content}
    ${resCode}    GET FROM DICTIONARY    ${gocontent}    resCode
    ${resMsg}    GET FROM DICTIONARY    ${gocontent}    resMsg
    run keyword if    ${resCode} == 1005358    Set Test Message    ${resCode}${resMsg}
    ${goData}    GET FROM DICTIONARY    ${gocontent}    data
    ${orderNO}    GET FROM DICTIONARY    ${goData}    orderNo
    ${productName}    GET FROM DICTIONARY    ${goData}    productName
    set suite variable    ${orderNO}
    run keyword if    ${resCode} == 000000    Set Tags    user: @{LIST_caifuyoujia}[0] \ orderNO : ${orderNO} productName : ${productName} PID:@{LIST_caifuyoujia}[1]
    should be equal    ${resCode}    0000    ${gocontent}

C-05-03-query_db
    [Documentation]    验证数据库中交易相关表和值正确。
    ...    app_tx表
    ...    fin_contract表
    ...    coupons_use表
    ...    ex_plan表
    ...    trade_record表
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    QUERYDB    ${testdb}    select mobile,product_name,tx_amt from app_tx where mobile='@{LIST_caifuyoujia}[0]' and order_no='${orderNO}'
    QUERYDB    ${testdb}    select contract_amt,expected_amt,dk_amt,ty_amt,ty_expected_amt,active_days,annual_invest_amt,sub_expected_amt,sub_pre_profit_rate from fin_contract where order_no='${orderNO}'
    QUERYDB    ${testdb}    select par_value from coupons_use where id=${idDkq}
    QUERYDB    ${testdb}    select par_value from coupons_use where id=${idTyj}
    QUERYDB    ${testdb}    select amount from trade_record where order_no='${orderNO}'
    QUERYDB    ${testdb}    select active_status,use_time,last_update_time from coupons_use where coupons_name='@{LIST_caifuyoujia}[5]' and active_status='5' and user_no = (select user_no from app_user where mobile = ${@{LIST_caifuyoujia}[0]})
    QUERYDB    ${testdb}    select amount from trade_record where order_no='${orderNO}'

C-05-04-confirm_db
    [Documentation]    校验生成的数据库数值正确
    ...    app_tx表
    ...    fin_contract表
    ...    coupons_use表
    ...    ex_plan表
    ...    trade_record表
    IMPORT RESOURCE    ${CURDIR}\\resourcefile.robot
    resourcefile.get_caifuyoujia    ${testdb}    @{LIST_caifuyoujia}[1]
    QUERYDB    ${testdb}    select contract_amt,expected_amt,ty_amt,dk_amt,ty_expected_amt,active_days,annual_invest_amt,sub_expected_amt,sub_pre_profit_rate from fin_contract where order_no=${orderNO}
    should be equal    '${result[0][0]}'    '${contract_amt}'    合同金额不一致 '${contract_amt}'    ##核对合同金额
    should be equal    '${result[0][1]}'    '${expected_amt}'    预期收益金额不一致'${expected_amt}'    ##核对预期收益金额
    should be equal    '${result[0][2]}'    '${ty_amt}'    体验金金额 \ 不一致'${ty_amt}'    ##核对体验金金额
    should be equal    '${result[0][3]}'    '${dqy_amt}'    抵扣券金额 不一致 '${dqy_amt}'    ##核对抵扣券金额
    should be equal    '${result[0][4]}'    '${expected_tyj_amt}'    预期体验金收益 不一致 '${result[0][4]}' !=${expected_tyj_amt}    ##核对预期体验金收益
    should be equal    '${result[0][5]}'    '${active_days}'    体验金收益天数    ##核对体验金收益天数
    should be equal    '${result[0][6]}'    '${annual_invest_amt}'    年化投资金额不一致 '${result[0][5]}' != \ '${annual_invest_amt}'    ##核对年化投资金额
    Comment    should be equal    '${result[0][7]}'    '${sub_expected_amt}'    最终加息收益 不一致 '${sub_expected_amt}'    ##核对最终加息收益金额(已公布答案)
    Comment    should be equal    '${result[0][8]}'    '${sub_pre_profit_rate}'    最终加息利率 一致'${sub_pre_profit_rate}'    ##核对最终加息利率(已公布答案)
