*** Settings ***
Documentation     resource file
...               资源文件

*** Keywords ***
QUERYDB
    [Arguments]    ${testdb}    ${sqlstr}
    [Documentation]    Name: QUERYDB
    ...    Source: resource file \ <test library>
    ...    Arguments: [ ${testdb}| ${sqlstr} ]
    ...
    ...    自定义关键字QUERYDB,用来查询db并返回查询结果
    ...
    ...    格式如下：
    ...
    ...    QUERYDB \ \ \ ${testdb} \ \ select mobile from app_user
    Comment    Set Environment Variable    NLS_LANG    SIMPLIFIED_CHINESE_CHINA_UTF8
    Connect To Database Using Custom Params    cx_Oracle    ${testdb}
    EXECUTE SQL STRING    ${sqlstr}
    ${dbresult}=    Query    ${sqlstr}
    ${result}=    replace variables    ${dbresult}
    set suite variable    ${result}
    Comment    log    ${result}
    DISCONNECT FROM DATABASE
    should not be empty    ${result}    there is no db result. ${sqlstr}

getTOKEN
    [Arguments]    ${mobile}    ${ipaddress}
    [Documentation]    *bold*
    ...    Name: getTOKEN
    ...    Source: resource file \ <test library>
    ...    Arguments: [ ${mobile} | ${ipaddress}]
    ...
    ...    自定义关键字getTOKEN,用来生产一个token值
    ...
    ...    格式如下：
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${ipaddress}
    ...
    ...    Example: \ \ \ \ \ IMPORT RESOURCE \ \ \ ${CURDIR}\\resourcefile.robot
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${ipaddress}
    ${rData}=    Create Dictionary    mobile=${mobile}    advertiser=${advertiser}    type=1
    ${rHeaders}=    Create dictionary    Connection=keep-alive    Accept-Language=zh-CN,en-US;q=0.8    Origin=file://    X-Requested-With=com.kuake.kklicai    Content-Type=application/x-www-form-urlencoded; charset=UTF-8
    ...    client_id=APP    Accept-Encoding=gzip, deflate    Accept=application/json, text/plain, */*    User-Agent=Mozilla/5.0 (Linux; Android 5.1.1; vivo X6S A Build/LMY47V) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/39.0.0.0 Mobile Safari/537.36    Content-Length=545    Host=${ipaddress}
    CREATE SESSION    apisession    http://${ipaddress}    ${rHeaders}    ## 创建 session [apisession] ，指定header
    log    apisession
    ${rData2}=    Create dictionary    appVersion=3.0.9    sysId=qAndroid    idfa=    ip=172.26.183.211    iemi=860576034110310
    ...    sessionId=eyJvcyI6IkFuZHJvaWQiLCJ2ZXJzaW9uIjoiMi4wLjYiLCJzZXNzaW9uX2lkIjoicXVhcmtmaW5hbmNlYWVhNmI4YjNhNWY2ZTk1OTJhYWFjYTMxMjljZmU4MSIsImRldmljZV9pZCI6IjdJRzNvdE8xYWQ0WWtHbGQ0dGU9IiwiYnVuZGxlIjoiY29tLmt1YWtlLmtrbGljYWlfMzAxMDE4IiwiZGF0YSI6ImZCVTY2VXc0VW90VlU4Wk82bU5uN293OFZwQz0ifQ==    client_id=APP    password=${loginPassword}    grant_type=password    appBuildVersion=20160913    client_secret=client_secret
    ...    username=${mobile}
    ${urladdress}    set variable    /api/token
    COMMENT    ##通过session 建立 POST 请求 ,请求地址urladdress, 带上body--rData
    Comment    ${urladdress}=    set variable    ${urladdress}${rr}
    ${rcontent}    POST REQUEST    apisession    ${urladdress}    ${rData2}
    ${content}    TO JSON    ${rcontent.content}
    ${access_token}    get from dictionary    ${content}    access_token
    Set Suite Variable    ${access_token}
    ${dlength}=    get length    ${access_token}
    RUN KEYWORD IF    ${dlength} >=32    LOG    获得token成功，access_token: ${access_token}
    ...    ELSE    LOG    获得token不成功

createSESSION_API
    [Arguments]    ${ipaddress}    ${mobile}    # ${ipaddress} | ${mobile}
    [Documentation]    *bold*
    ...    Name: createSESSION_API
    ...    Source: resource file \ <test library>
    ...    Arguments: [ ${mobile} | ${ipaddress}]
    ...
    ...    Create API Session
    ...    建立与API服务器的session连接
    ${rHeaders}=    Create dictionary    Connection=keep-alive    Access-Control-Allow-Origin=*    Accept-Language=zh-CN,en-US;q=0.8    Origin=file://    X-Requested-With=com.kuake.kklicai
    ...    Content-Type=application/json;charset=UTF-8    client_id=APP    Accept-Encoding=gzip, deflate    Accept=application/json, text/plain, */*    User-Agent=Mozilla/5.0 (Linux; Android 5.1.1; vivo X6S A Build/LMY47V) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/39.0.0.0 Mobile Safari/537.36    Content-Length=357
    ...    Host=${ipaddress}
    CREATE SESSION    apisession    http://${ipaddress}    ${rHeaders}    ## 创建 session [apisession] ，指定header

get_caifuyoujia
    [Arguments]    ${testdb}    ${pid}
    [Documentation]    *bold*
    ...    Name: Get_Caifuyoujia
    ...    Source: resource file \ <test library>
    ...    Arguments: [ ${testdb} | ${pid}]
    ...
    ...    自定义关键字Get_Caifuyoujia,用来生产一个财富优加产品的基础值
    ...
    ...    格式如下：
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${ipaddress}
    ...
    ...    Example: \ \ \ \ \ IMPORT RESOURCE \ \ \ ${CURDIR}\\resourcefile.robot
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${ipaddress}
    import resource    ${CURDIR}\\resourcefile.robot
    ${subsidy_rate}    set variable    ##补贴加息收益率
    ${PRE_PROFIT_RATE}    set variable    ##基础收益利率
    ${PERIOD}    set variable    ##产品期限
    ${active_days}    set variable    ##体验金收益天数
    ${ty_amt}    set variable    ##体验金金额
    ${dqy_amt}    set variable    ##抵扣券金额
    ${contract_amt}    set variable    ##合同金额
    ${sub_pre_profit_rate}    set variable    ##最终加息利率
    ${sub_expected_amt }    set variable    ##最终加息收益
    ${expected_amt}    set variable    ##预期收益
    ${expected_tyj_amt}    set variable    ##预期体验金收益
    ${annual_invest_amt}    set variable    ##年化投资金额
    Comment    QUERYDB    ${testdb}    select * from coupons_use where coupons_name=${con_name} and active_status='3' and user_no = (select user_no from app_user where mobile =@{LIST_caifuyoujia}[0])
    QUERYDB    ${testdb}    select PID,SUBSIDY_RATE from mapp_platform.t_product_channel_kuake where CHANNEL_CODE=100001 and pid=@{LIST_caifuyoujia}[1]    ##获取补贴加息收益率
    ${subsidy_rate}=    set variable    ${result[0][1]}    ##财富优加补贴收益率subsidy_rate
    QUERYDB    ${testdb}    select PID,PRE_PROFIT_RATE,PERIOD from mapp_platform.app_product where rownum <= 10 and PID=@{LIST_caifuyoujia}[1]
    ${PRE_PROFIT_RATE}    set variable    ${result[0][1]}
    ${PERIOD}    set variable    ${result[0][2]}
    QUERYDB    ${testdb}    select ID,order_no,active_status,par_value from coupons_use where \ \ coupons_name='@{LIST_caifuyoujia}[6]' and ID=${idTyj}
    ${active_days}    set variable    ${result[0][2]}
    ${ty_amt}    set variable    ${result[0][3]}
    QUERYDB    ${testdb}    select ID,order_no,par_value from coupons_use where \ \ coupons_name='@{LIST_caifuyoujia}[5]' and ID=${idDkq}
    ${dqy_amt}    set variable    ${result[0][2]}
    ${amt_float}    set variable    @{LIST_caifuyoujia}[2]
    ${contract_amt}    convert to number    ${amt_float}    1
    ${tem_sub_pre_profit_rate}=    convert to number    ${subsidy_rate}    1
    ${sub_pre_profit_rate}=    set variable    ${tem_sub_pre_profit_rate}
    ${sub_expected_amt }    evaluate    (${contract_amt}/360*${SUBSIDY_RATE}*${PERIOD} + ${ty_amt}/360*${active_days}*${SUBSIDY_RATE})*0.01
    ${tem_expected_tyj_amt}=    evaluate    (${PRE_PROFIT_RATE}+${SUBSIDY_RATE})*${ty_amt}/360*${active_days}/100    ##计算预期体验金收益金额多位小数
    ${expected_tyj_amt}=    convert to number    ${tem_expected_tyj_amt}    2
    ${temp_annual_invest_amt}=    evaluate    ${contract_amt}*${PERIOD}/360
    ${annual_invest_amt}    convert to number    ${temp_annual_invest_amt}    2
    ${temp_expected_amt}    evaluate    (${contract_amt}/360*(${PRE_PROFIT_RATE}+${SUBSIDY_RATE})*${PERIOD} + ${ty_amt}/360*${active_days}*(${PRE_PROFIT_RATE}+${SUBSIDY_RATE}))*0.01
    ${expected_amt}    convert to number    ${temp_expected_amt}    2
    set suite variable    ${PRE_PROFIT_RATE}
    set suite variable    ${subsidy_rate}
    set suite variable    ${PERIOD}
    set suite variable    ${active_days}
    set suite variable    ${ty_amt}
    set suite variable    ${dqy_amt}
    set suite variable    ${contract_amt}
    set suite variable    ${sub_pre_profit_rate}
    set suite variable    ${sub_expected_amt }
    set suite variable    ${expected_amt}
    set suite variable    ${expected_tyj_amt}
    set suite variable    ${annual_invest_amt}

get_caiduobao
    [Arguments]    ${testdb}    ${pid}
    [Documentation]    *bold*
    ...    Name: Get_Caifuyoujia
    ...    Source: resource file \ <test library>
    ...    Arguments: [ ${testdb} | ${pid}]
    ...
    ...    自定义关键字Get_Caiduobao,用来生产一个猜多宝的基础值
    ...
    ...    格式如下：
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${pid}
    ...
    ...    Example: \ \ \ \ \ IMPORT RESOURCE \ \ \ ${CURDIR}\\resourcefile.robot
    ...    getTOKEN \ \ \ ${mobile} \ \ \ ${ipaddress}
    import resource    ${CURDIR}\\resourcefile.robot
    ${subsidy_rate}    set variable    ##补贴加息收益率
    ${PRE_PROFIT_RATE}    set variable    ##基础收益利率
    ${PERIOD}    set variable    ##产品期限
    ${active_days}    set variable    ##体验金收益天数
    ${ty_amt}    set variable    ##体验金金额
    ${dqy_amt}    set variable    ##抵扣券金额
    ${contract_amt}    set variable    ##合同金额
    ${sub_pre_profit_rate}    set variable    ##最终加息利率
    ${sub_expected_amt }    set variable    ##最终加息收益
    ${expected_amt}    set variable    ##预期收益
    ${expected_tyj_amt}    set variable    ##预期体验金收益
    ${annual_invest_amt}    set variable    ##年化投资金额
    Comment    QUERYDB    ${testdb}    select * from coupons_use where coupons_name=${con_name} and active_status='3' and user_no = (select user_no from app_user where mobile =@{LIST_caiduobao}[0])
    QUERYDB    ${testdb}    select PID,SUBSIDY_RATE from mapp_platform.t_product_channel_kuake where CHANNEL_CODE=100001 and pid=@{LIST_caiduobao}[1]    ##获取补贴加息收益率
    ${subsidy_rate}=    set variable    ${result[0][1]}    ##财富优加补贴收益率subsidy_rate
    QUERYDB    ${testdb}    select PID,PRE_PROFIT_RATE,PERIOD from mapp_platform.app_product where rownum <= 10 and PID=@{LIST_caiduobao}[1]
    ${PRE_PROFIT_RATE}    set variable    ${result[0][1]}
    ${PERIOD}    set variable    ${result[0][2]}
    QUERYDB    ${testdb}    select ID,order_no,active_status,par_value from coupons_use where \ \ coupons_name='@{LIST_caiduobao}[6]' and ID=${idTyj}
    ${active_days}    set variable    ${result[0][2]}
    ${ty_amt}    set variable    ${result[0][3]}
    QUERYDB    ${testdb}    select ID,order_no,par_value from coupons_use where \ \ coupons_name='@{LIST_caiduobao}[5]' and ID=${idDkq}
    ${dqy_amt}    set variable    ${result[0][2]}
    ${amt_float}    set variable    @{LIST_caiduobao}[2]
    ${contract_amt}    convert to number    ${amt_float}    1
    Comment    ${tem_sub_pre_profit_rate}=    convert to number    ${subsidy_rate}    1
    Comment    ${sub_pre_profit_rate}=    set variable    ${tem_sub_pre_profit_rate}
    Comment    ${sub_expected_amt }    evaluate    (${contract_amt}/360*${SUBSIDY_RATE}*${PERIOD} + ${ty_amt}/360*${active_days}*${SUBSIDY_RATE})*0.01    ##计算预期收益(已公布答案)
    ${tem_expected_tyj_amt}=    evaluate    (${PRE_PROFIT_RATE}+${SUBSIDY_RATE})*${ty_amt}/360*${active_days}*0.01    ##计算预期体验金收益金额多位小数(已公布答案)
    ${tem_expected_tyj_amt}=    evaluate    ${PRE_PROFIT_RATE}*${ty_amt}/360*${active_days}*0.01    ##计算预期体验金收益金额多位小数(未公布答案)
    ${expected_tyj_amt}=    convert to number    ${tem_expected_tyj_amt}    2
    ${temp_annual_invest_amt}=    evaluate    ${contract_amt}*${PERIOD}/360
    ${annual_invest_amt}    convert to number    ${temp_annual_invest_amt}    2
    ${tem_expected_amt}    evaluate    (${contract_amt}/360*${PRE_PROFIT_RATE}*${PERIOD} + ${ty_amt}/360*${active_days}*${PRE_PROFIT_RATE})*0.01
    ${expected_amt}    convert to number    ${tem_expected_amt}    2
    set suite variable    ${PRE_PROFIT_RATE}
    set suite variable    ${subsidy_rate}
    set suite variable    ${PERIOD}
    set suite variable    ${active_days}
    set suite variable    ${ty_amt}
    set suite variable    ${dqy_amt}
    set suite variable    ${contract_amt}
    set suite variable    ${sub_pre_profit_rate}
    set suite variable    ${sub_expected_amt }
    set suite variable    ${expected_amt}
    set suite variable    ${expected_tyj_amt}
    set suite variable    ${annual_invest_amt}

get_bankcard
    [Arguments]    ${testdb}    ${mobile}    ${bank_card_no}
    import resource    ${CURDIR}\\resourcefile.robot
    QUERYDB    ${testdb}    select mobile,user_no,id from app_user where mobile =${mobile}
    ${user_no}    set variable    ${result[0][1]}    ##获取app_user表中的user_no
    set suite variable    ${user_no}    ##设置变量suite范围套件范围
    ${identification_type}    set variable    0    ##设置证件类型0身份证
    set suite variable    ${identification_type}    ##设置变量suite范围套件范围
    ${user_name}    set variable    AUTO    ##设置用户名字 AUTO
    set suite variable    ${user_name}    ##设置变量suite范围套件范围
