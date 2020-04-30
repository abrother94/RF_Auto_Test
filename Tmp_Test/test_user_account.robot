*** Settings ***
Documentation    Test Redfish user account.

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot

*** Variables ***

${UserName}  admin
${Pwd}  redfish 

${RO_UserName}  readonly 
${RO_Pwd}  readonly 
${RO_ROLE}  ReadOnlyUser 

${TEST_RO_UserName}  testreadonly 
${TEST_RO_Pwd}  testreadonly 
${RO_ROLE}  ReadOnlyUser 

${OP_UserName}  Operator 
${OP_Pwd}  Operator 
${OP_ROLE}  Operator 

${TEST_USER_BODY}  {"UserName":"U1","Password":"P1","RoleId":"ReadOnlyUser", "Enabled":true , "Locked":false}

${OP_DOWN}  {"OperationalState": "Down"} 
${OP_UP}  {"OperationalState": "Up"} 

** Test Cases **

Verify AccountService_ReadOnlyUser
    [Documentation]  Verify Redfish ReadOnlyUser account can get major service 
    [Tags]  Verify_AccountService_UserOnlyUser_Enable

    Redfish.Login  ${UserName}  ${Pwd} 

    Redfish Create User  ${RO_UserName}  ${RO_Pwd}  ${RO_ROLE}  ${False}  ${True}

    Redfish.Logout

    Redfish.Login  ${RO_UserName}  ${RO_Pwd} 

    ${resp}=  Redfish.Get   /redfish/v1/EthernetSwitches/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get   /redfish/v1/EthernetSwitches/1/Ports/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get   /redfish/v1/EthernetSwitches/1/Ports/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/EventService/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/EventService/Subscriptions
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Accounts
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Roles
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Roles/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Roles/2
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Roles/3
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Registries/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Registries/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Power
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Drives/1/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Managers
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1/EthernetInterfaces
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1/EthernetInterfaces/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Managers/1/SerialInterfaces/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Processors
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Processors/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Storage/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/SessionService/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/SessionService/Sessions
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Redfish.Login  
    # Delete Specified User
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${RO_UserName}
    Redfish.Logout

Verify AccountService_ReadOnlyUser_Cannot_POST_PATCH
    [Documentation]  Verify Redfish ReadOnlyUser account cannot use patch post action 
    [Tags]  Verify_AccountService_ReadOnlyUser_CANNOT_PATCH_POST

    Redfish.Login  ${UserName}  ${Pwd} 
    Redfish Create User  ${RO_UserName}  ${RO_Pwd}  ${RO_ROLE}  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ${RO_UserName}  ${RO_Pwd} 

    ${payload}=  Evaluate  json.loads($OP_UP)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/1  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    ${payload}=  Create Dictionary
    ...  ResetType=GracefulRestart 
    Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.Reset  body=&{payload}
    ...  valid_status_codes=[${HTTP_UNAUTHORIZED}]
# Should not able to create user
#    ${payload}=  Evaluate  json.loads($TEST_USER_BODY)    json
#    Redfish.Post  /redfish/v1/redfish/v1/AccountService/Accounts/  body=&{payload}
#    ...  valid_status_codes=[${HTTP_OK]
#    Sleep  10s
#    Redfish.Post  /redfish/v1/redfish/v1/AccountService/Accounts/U1  body=&{payload}
#    ...  valid_status_codes=[${HTTP_OK]

    Redfish.Login  
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${RO_UserName}
    Redfish.Logout

Verify AccountService_Operator_Can_POST_PATCH
    [Documentation]  Verify Redfish Operator account can use patch post action 
    [Tags]  Verify_AccountService_OperatorUser_CAN_PATCH_POST

    Redfish.Login  ${UserName}  ${Pwd} 
    Redfish Create User  ${OP_UserName}  ${OP_Pwd}  ${OP_ROLE}  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ${OP_UserName}  ${OP_Pwd} 

    ${payload}=  Evaluate  json.loads($OP_UP)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/1  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

# Should not able to create user
#    ${payload}=  Evaluate  json.loads($TEST_USER_BODY)    json
#    Redfish.Post  /redfish/v1/redfish/v1/AccountService/Accounts/  body=&{payload}
#    ...  valid_status_codes=[${HTTP_OK]
#    Sleep  10s
#    Redfish.Post  /redfish/v1/redfish/v1/AccountService/Accounts/U1  body=&{payload}
#    ...  valid_status_codes=[${HTTP_OK]

    ${payload}=  Create Dictionary
    ...  ResetType=GracefulRestart 
    Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.Reset  body=&{payload}
    ...  valid_status_codes=[${HTTP_OK}]
    Sleep  180s
    # Wait device ready

    Redfish.Login  
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${OP_UserName}
    Redfish.Logout


*** Keywords ***
Redfish Create User
    [Documentation]  Redfish create user.
    [Arguments]   ${username}  ${password}  ${role_id}  ${locked}  ${enabled}

    # Description of argument(s):
    # username            The username to be created.
    # password            The password to be assigned.
    # role_id             The role id of the user to be created
    #                     (e.g. "Administrator", "Operator", etc.).
    # locked              should be enabled (${True}, ${False}).
    # enabled             Indicates whether the username being created
    #                     should be enabled (${True}, ${False}).

    # Create specified user.
    ${payload}=  Create Dictionary
    ...  UserName=${username}  Password=${password}  RoleId=${role_id}  Locked=${locked}  Enabled=${enabled}
    Redfish.Post  /redfish/v1/AccountService/Accounts  body=&{payload}
    ...  valid_status_codes=[${HTTP_CREATED}]
