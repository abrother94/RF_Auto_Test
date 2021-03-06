*** Settings ***
Documentation    Test PSME Manager functionality.
Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Resource         ../../lib/common_utils.robot

Test Setup       Test Setup Execution
Test Teardown    Test Teardown Execution

*** Variables ***

${FirmwareVersion}  ${FWV}
${TIP}  ${TESTIP}
${IPV4}  { "DHCPv4": { "DHCPEnabled": false }, "IPv4Addresses": [ { "Address": "${TIP}", "SubnetMask": "255.255.252.0", "Gateway": "172.17.10.251" } ], "StaticNameServers": [ { "Address": "8.8.8.8" } ] }

*** Test Cases ***

Verify PSME Redfish Version
    [Documentation]  Get PSME version from manager board.
    [Tags]  Verify_PSME_Redfish_Version 

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Should Be Equal As Strings
    ...  ${resp.dict["FirmwareVersion"]}  ${FirmwareVersion} 


Verify Redfish PSME Manager Properties
    [Documentation]  Verify PSME managers resource properties.
    [Tags]  Verify_Redfish_PSME_Manager_Properties

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Should Be Equal As Strings
    ...  ${resp.dict["Description"]}  Manager description 
    Should Be Equal As Strings  ${resp.dict["Id"]}  1 
    Should Be Equal As Strings  ${resp.dict["Name"]}  Manager 
    Should Not Be Empty  ${resp.dict["UUID"]}
    Should Be Equal As Strings  ${resp.dict["Status"]["State"]}  Enabled 

Verify Redfish PSME Log Service 
    [Documentation]  Verify Redfish PSME Log Service
    [Tags]  Verify Redfish PSME Log Service  

    ${resp}=  Redfish.Get  redfish/v1/Managers/1/LogServices/1/ 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    Should Be Equal As Strings  ${resp.dict["ServiceEnabled"]}   ${TRUE}

    ${payload}=  Create Dictionary
    ...  ServiceEnabled  ${TRUE}

    ${resp}=  Redfish.Patch  redfish/v1/Managers/1/LogServices/1/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    ${resp}=  Redfish.Get  redfish/v1/Managers/1/LogServices/1/Entries 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    ${Entry_count} =  Set Variable  ${resp.dict["Members@odata.count"]}
    Log to console  "####### Entry count:${Entry_count} ######" 
    Should Not Be Equal As Integers  ${Entry_count}   0 

    ${payload}=  Create Dictionary
    ...  TEST=${EMPTY} 

    ${resp}=  Redfish.Post  /redfish/v1/Managers/1/LogServices/1/Actions/LogService.Reset  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  redfish/v1/Managers/1/LogServices/1/Entries 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    ${Entry_count} =  Set Variable  ${resp.dict["Members@odata.count"]}
    Log to console  "####### Entry count:${Entry_count} ######" 
    Should Be Equal As Integers  ${Entry_count}   0 

    # Send a test log
    ${resp}=  Redfish.Get  /redfish/v1/EventService/TestEventSubscription

#Verify Set Static IPv4 IP address
#    [Documentation]  Verify PSME managers to set IPv4 IP address 
#    [Tags]           Verify_PSME_managers_to_set_IPv4_IP

#    ${payload}=  Evaluate  json.loads($IPV4)    json 
#    Redfish.Patch  /redfish/v1/Managers/1/EthernetInterfaces/1  body=${payload}
#    # Wait IP get ready
#    Sleep  7s    
#    ...  valid_status_codes=[${HTTP_OK}]


*** Keywords ***

Test Setup Execution
    [Documentation]  Do test case setup tasks.

    redfish.Login


Test Teardown Execution
    [Documentation]  Do the post test teardown.

    redfish.Logout
