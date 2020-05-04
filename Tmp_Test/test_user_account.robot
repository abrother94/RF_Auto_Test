*** Settings ***
Documentation    Test Redfish user account.

Resource         ../lib/resource.robot
Resource         ../lib/bmc_redfish_resource.robot

*** Variables ***

${UserName}  admin
${Pwd}  redfish 

${RO_UserName}  readonly 
${RO_Pwd}  readonly 
${RO_ROLE}  ReadOnlyUser 

${TEST_RO_UserName}  testreadonly 
${TEST_RO_Pwd}  testreadonly 
${TEST1_RO_UserName}  test1readonlypwd 
${TEST1_RO_Pwd}  test1readonlypwd 
${RO_ROLE}  ReadOnlyUser 

${OP_UserName}  Operator 
${OP_Pwd}  Operator 
${OP_ROLE}  Operator 

${TEST_USER_BODY}  {"UserName":"U1","Password":"P1","RoleId":"ReadOnlyUser", "Enabled":true , "Locked":false}
${TEST1_USER_BODY}  {"UserName":"U2","Password":"P2","RoleId":"ReadOnlyUser", "Enabled":true , "Locked":false}
${PATCH_PWD_BODY}  { "UserName": "readonly", "Password": "readonlyU2", "Locked": false, "Enabled": true, "RoleId": "ReadOnlyUser" } 
${OP_PATCH_PWD_BODY}  { "UserName": "Operator", "Password": "OperatorU2", "Locked": false, "Enabled": true, "RoleId": "Operator" } 
${PATCH_TEST_PWD_BODY}  { "UserName": "testreadonly", "Password": "testreadonlyU2", "Locked": false, "Enabled": true, "RoleId": "ReadOnlyUser" } 


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
    Redfish Create User  ${TEST_RO_UserName}  ${TEST_RO_Pwd}  ${RO_ROLE}  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ${RO_UserName}  ${RO_Pwd} 

    ${payload}=  Evaluate  json.loads($OP_UP)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EthernetSwitches/1/Ports/1  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    ${payload}=  Create Dictionary
    ...  ResetType=GracefulRestart 
    Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.Reset  body=&{payload}
    ...  valid_status_codes=[${HTTP_UNAUTHORIZED}]

#   ReadOnlyUser can't create account
    Redfish Create User  ${TEST1_RO_UserName}  ${TEST1_RO_Pwd}  ${RO_ROLE}  ${False}  ${True}
    ${role_config}=  Redfish_Utils.Get Attribute
    ...  /redfish/v1/AccountService/Accounts/${TEST1_RO_UserName}  RoleId
    Should Not Be Equal  ${RO_ROLE}  ${role_config}

#   ReadOnlyUser can't get Accounts related info. 
#   Check in upper layer

    ${resp}=  Redfish.Get  /redfish/v1/AccountService/Accounts/
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

#   ReadOnlyUser can patch its own pasword
    ${payload}=  Evaluate  json.loads($PATCH_PWD_BODY)    json 
    Redfish.Patch  /redfish/v1/AccountService/Accounts/${RO_UserName}  body=&{payload}
    ...  valid_status_codes=[${HTTP_OK}]

#   ReadOnlyUser can't patch other users pasword
    ${payload}=  Evaluate  json.loads($PATCH_TEST_PWD_BODY)    json 
    Redfish.Patch  /redfish/v1/AccountService/Accounts/${TEST_RO_UserName}  body=&{payload}
    ...  valid_status_codes=[${HTTP_UNAUTHORIZED}]


    Redfish.Login  
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${RO_UserName}
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${TEST_RO_UserName}
    Redfish.Logout


Verify AccountService_OPUser_Cannot_POST_PATCH
    [Documentation]  Verify Redfish OPUser account cannot use patch post action 
    [Tags]  Verify_AccountService_OPUser_CANNOT_PATCH_POST

    Redfish.Login  ${UserName}  ${Pwd} 
    Redfish Create User  ${OP_UserName}  ${OP_Pwd}  ${OP_ROLE}  ${False}  ${True}
    Redfish Create User  ${TEST_RO_UserName}  ${TEST_RO_Pwd}  ${RO_ROLE}  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ${OP_UserName}  ${OP_Pwd} 

#   OPUser can't create account
    Redfish Create User  ${TEST1_RO_UserName}  ${TEST1_RO_Pwd}  ${RO_ROLE}  ${False}  ${True}
    ${role_config}=  Redfish_Utils.Get Attribute
    ...  /redfish/v1/AccountService/Accounts/${TEST1_RO_UserName}  RoleId
    Should Not Be Equal  ${RO_ROLE}  ${role_config}

#   OPUser can patch its own pasword
    ${payload}=  Evaluate  json.loads($OP_PATCH_PWD_BODY)    json 
    Redfish.Patch  /redfish/v1/AccountService/Accounts/${OP_UserName}  body=&{payload}
    ...  valid_status_codes=[${HTTP_OK}]

#   ReadOnlyUser can't patch other users pasword
    ${payload}=  Evaluate  json.loads($PATCH_TEST_PWD_BODY)    json 
    Redfish.Patch  /redfish/v1/AccountService/Accounts/${TEST_RO_UserName}  body=&{payload}
    ...  valid_status_codes=[${HTTP_UNAUTHORIZED}]


    # Op can reset device
    ${payload}=  Create Dictionary
    ...  ResetType=GracefulRestart 
    Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.Reset  body=&{payload}
    ...  valid_status_codes=[${HTTP_OK}]
    Sleep  180s
    # Wait device ready
    
    Redfish.Logout
    Redfish.Login   
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${OP_UserName}
    Redfish.Delete  /redfish/v1/AccountService/Accounts/${TEST_RO_UserName}
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
