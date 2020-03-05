*** Settings ***
Documentation    Test PSME switches port functionality.
Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Resource         ../../lib/common_utils.robot

Test Setup       Test Setup Execution
Test Teardown    Test Teardown Execution

*** Variables ***

${OP_DOWN}  {"OperationalState": "Down"} 
${OP_UP}  {"OperationalState": "Up"} 

*** Test Cases ***

Verify SFP Port tx_disable function 
    [Documentation]  Verify SFP port tx disable function 
    [Tags]  Verify_tx_disable

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/
 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${item_count}  Get Length  ${resp.dict['Members']}
    Log to console             ${item_count} 

    ${n1}  Set Variable  1
    ${n2}  Set Variable  ${item_count} 

    : FOR  ${i}  IN RANGE   ${n1}   ${n2} 
    \  Test Tx Disable Down  ${i}

    : FOR  ${i}  IN RANGE   ${n1}   ${n2} 
    \  Test If Tx Op Down   ${i}

    : FOR  ${j}  IN RANGE   ${n1}   ${n2} 
    \  Test Tx Disable Up  ${j}

    : FOR  ${i}  IN RANGE   ${n1}   ${n2} 
    \  Test If Tx Op Up   ${i}


*** Keywords ***

Test Setup Execution
    [Documentation]  Do test case setup tasks.

    redfish.Login

Test Teardown Execution
    [Documentation]  Do the post test teardown.

    redfish.Logout

Test Tx Disable Down
    [Documentation]  Test SFP port tx disable down function 
    [Tags]  Test tx_disable down 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}


    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    Log to console              ${PORT_ENABLE}
    Log to console              ${PortId}
    Log to console              ${resp.dict['OperationalState']}

           Run Keyword If  '${PORT_ENABLE}' == 'Enabled' 
      \    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port'
      \    ...        Test Tx Op Down   ${ID} 
      \    ...    ELSE          
      \    ...          Log to console  "####### Disabled ######" 

Test Tx Disable Up 
    [Documentation]  Test SFP port tx disable Up function 
    [Tags]  Test tx_disable up 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}


    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    Log to console              ${PORT_ENABLE}
    Log to console              ${PortId}
    Log to console              ${resp.dict['OperationalState']}

           Run Keyword If  '${PORT_ENABLE}' == 'Enabled' 
      \    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port'
      \    ...        Test Tx Op Up   ${ID} 
      \    ...    ELSE          
      \    ...          Log to console  "####### Disable ######" 




Test Tx Op Down 
    [Documentation]  Test SFP port tx disable function 
    [Tags]  Test tx_disable 
    [Arguments]   ${ID} 

    ${payload}=  Evaluate  json.loads($OP_DOWN)    json 
    Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/${ID}  body=${payload}


Test Tx Op Up 
    [Documentation]  Test SFP port tx disable function 
    [Tags]  Test tx_disable 
    [Arguments]   ${ID} 

    ${payload}=  Evaluate  json.loads($OP_UP)    json 
    Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/${ID}  body=${payload}


Test If Tx Op Down 
    [Documentation]  Test if SFP port tx disable function 
    [Tags]  Test if tx_disable down 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}

    Run Keyword If  '${PORT_ENABLE}' == 'Enabled' 
    \    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port'
    \    ...        Should Be Equal As Strings  ${resp.dict['OperationalState']}  Down 


Test If Tx Op Up 
    [Documentation]  Test if SFP port tx disable function 
    [Tags]  Test if tx_disable up 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}

    Run Keyword If  '${PORT_ENABLE}' == 'Enabled' 
    \    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port'
    \    ...        Should Be Equal As Strings  ${resp.dict['OperationalState']}  Up 

