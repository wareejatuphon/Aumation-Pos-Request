*** Settings ***       
Library    SeleniumLibrary
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections


*** Variables ***
${Post_URL}         https://api.getpostman.com
${EP_Name}          TT
${postman-api-key}    PMAK-62b3da4ef7407513c2a88397-7bc057caa3cdc0e380b0368ed910ef6e1a

*** Test Cases ***
Post Create a Collections Successfull
    ${body}    Get Data To txt
    ${content}    Send Request For API    ${body}    ${postman-api-key}
    Verify Data Reponse    ${content}    ${EP_Name}


*** Keywords ***
Get Data To txt
    ${body} =     Get File     format_json.txt
    ${body}    Convert String To JSON    ${body}
    Log    ${body}
    Return From Keyword    ${body}

Send Request For API
    [Arguments]    ${body}    ${postman-api-key}
    Create Session    mysession    ${Post_URL}
    ${header}    Create Dictionary    Content-Type=application/json    x-api-key=${postman-api-key}
    ${resp}    Post Request    mysession    /collections    data=${body}    headers=${header} 
    ${status_code}    Set Variable    ${resp.status_code} 
    ${content}    Set Variable    ${resp.content}
    ${content}    evaluate  json.loads('''${content}''')    json
    Run Keyword if    '${status_code}' != '200'    Fail    Send request error status is ${status_code} ${content['error']['name']}
    Return From Keyword    ${content}

Verify Data Reponse
    [Arguments]    ${content}    ${EP_Name}
    ${AC_Name}    Set Variable    ${content['collection']['name']}
    ${Flag_Name}    Run Keyword And Return Status    Should Contain    ${AC_Name}    ${EP_Name} 
    Run Keyword if    '${Flag_Name}' == 'False'    Fail    Data Reponse Not Math
   


    
