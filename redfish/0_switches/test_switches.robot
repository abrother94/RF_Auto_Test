*** Settings ***
Documentation    Test PSME switches port functionality.
Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Resource         ../../lib/common_utils.robot

Test Setup       Test Setup Execution
Test Teardown    Test Teardown Execution

*** Variables ***

${TX_ENABLE}  {"TxDisabledState": false} 
${TX_DISABLE}  {"TxDisabledState": true} 

*** Test Cases ***

Verify Stress loop test
    [Documentation]  Test SFP port tx disable stress test 
    [Tags]  Test Stress loop test 

    FOR  ${i}  IN RANGE   1   2 
    Test SFP Port tx_disable function  ${i} 
    END

*** Keywords ***

Test Setup Execution
    [Documentation]  Do test case setup tasks.

    redfish.Login

Test Teardown Execution
    [Documentation]  Do the post test teardown.

    redfish.Logout

Test SFP Port tx_disable function 
    [Documentation]  Verify SFP port tx disable function 
    [Tags]  Verify_tx_disable
    [Arguments]   ${count} 
    Log to console  "################### COUNT[${count}] ###################" 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/
 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${item_count}  Get Length  ${resp.dict['Members']}
    Log to console             ${item_count} 

    ${n1}  Set Variable  1
    ${n2}  Set Variable  ${item_count} 


      FOR  ${i}  IN RANGE   ${n1}   ${n2} 
      Test Tx Disable Down  ${i}
      END

      FOR  ${i}  IN RANGE   ${n1}   ${n2} 
      Test If Tx State Down   ${i}
      END

      FOR  ${j}  IN RANGE   ${n1}   ${n2} 
      Test Tx Disable Up  ${j}
      END

      FOR  ${i}  IN RANGE   ${n1}   ${n2} 
      Test If Tx State Up   ${i}
      END

Test Tx Disable Down
    [Documentation]  Test SFP port tx disable down function 
    [Tags]  Test tx_disable down 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    Log to console              ${resp}



    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    ${IS_TX_WORKABLE} =  Set Variable  ${resp.dict['TxDisabledState']}
    Log to console              ${PORT_ENABLE}
    Log to console              ${PortId}
    Log to console              ${resp.dict['TxDisabledState']}
    Log to console              ${IS_TX_WORKABLE}

           Run Keyword If  '${PORT_ENABLE}' == 'Enabled' and '${IS_TX_WORKABLE}' != 'None' 
           ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port' or '${PORT_ID}' == 'QSFP port'
    ...        Test Tx State Down   ${ID} 
           ...    ELSE          
           ...          Log to console  "####### Disabled ######" 

Test Tx Disable Up 
    [Documentation]  Test SFP port tx disable Up function 
    [Tags]  Test tx_disable up 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}


    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    ${IS_TX_WORKABLE} =  Set Variable  ${resp.dict['TxDisabledState']}
    Log to console              ${PORT_ENABLE}
    Log to console              ${PortId}
    Log to console              ${resp.dict['TxDisabledState']}

           Run Keyword If  '${PORT_ENABLE}' == 'Enabled' and '${IS_TX_WORKABLE}' != 'None' 
           ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port' or '${PORT_ID}' == 'QSFP port'
    ...        Test Tx State Up   ${ID} 
           ...    ELSE          
           ...          Log to console  "####### Disable ######" 


Test Tx State Down 
    [Documentation]  Test SFP port tx disable function 
    [Tags]  Test tx_disable 
    [Arguments]   ${ID} 

    ${payload}=  Evaluate  json.loads($TX_DISABLE)    json 
    Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/${ID}  body=${payload}

Test Tx State Up 
    [Documentation]  Test SFP port tx disable function 
    [Tags]  Test tx_disable 
    [Arguments]   ${ID} 

    ${payload}=  Evaluate  json.loads($TX_ENABLE)    json 
    Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/${ID}  body=${payload}

Test If Tx State Down 
    [Documentation]  Test if SFP port tx disable function 
    [Tags]  Test if tx_disable down 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    ${IS_TX_WORKABLE} =  Set Variable  ${resp.dict['TxDisabledState']}

    Run Keyword If  '${PORT_ENABLE}' == 'Enabled' and '${IS_TX_WORKABLE}' != 'None' 
    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port' or '${PORT_ID}' == 'QSFP port'
    ...        Should be true  ${resp.dict['TxDisabledState']} == ${TRUE} 

Test If Tx State Up 
    [Documentation]  Test if SFP port tx disable function 
    [Tags]  Test if tx_disable up 
    [Arguments]   ${ID} 

    ${resp}=  Redfish.Get  /redfish/v1/EthernetSwitches/1/Ports/${ID} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${PORT_ENABLE} =  Set Variable  ${resp.dict['Status']['State']}
    ${PORT_ID} =  Set Variable  ${resp.dict['PortId']}
    ${IS_TX_WORKABLE} =  Set Variable  ${resp.dict['TxDisabledState']}

    Run Keyword If  '${PORT_ENABLE}' == 'Enabled' and '${IS_TX_WORKABLE}' != 'None'
    ...        Run Keyword If  '${PORT_ID}' == 'PON port' or '${PORT_ID}' == 'SFP port' or '${PORT_ID}' == 'QSFP port'
    ...        Should be true  ${resp.dict['TxDisabledState']} == ${FALSE} 

