*** Settings ***
Documentation    Test Redfish user account.

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Library          Collections

Test Setup       Test Setup Execution
Test Teardown    Test Teardown Execution

*** Variables ***
${EVENT_ALERT}  { "Name": "This is Alert Subscription event test", "Destination": "https://${LISTENER_HOST}", "Context": "THIS IS TEST FROM AUTO TEST SUBS ALERT", "Protocol": "Redfish", "EventTypes": [ "Alert" ] }

${PATCH_EVENT_ALERT}  { "Name": "This is Alert Subscription event patch test", "Destination": "https://${LISTENER_HOST}", "Context": "THIS IS TEST FROM AUTO TEST SUBS ALERT" }

${EVENT_RESOURCEADD}  { "Name": "This is ResourceAdded Subscription event test", "Destination": "https://${LISTENER_HOST}", "Context": "THIS IS TEST FROM AUTO TEST SUBS RESOURCEADD", "Protocol": "Redfish", "EventTypes": [ "ResourceAdded" ] }

${PATCH_EVENT_ALERT_NAME}  { "Name": "This is Alert Subscription event patch test name"}

${PATCH_EVENT_RESOURCEADD}  { "Name": "This is ResourceAdded Subscription event patch test", "Destination": "https://${LISTENER_HOST}", "Context":"THIS IS TEST FROM AUTO TEST SUBS RESOURCEADD" }

${PATCH_EVENT_RESOURCEADD_DES}  { "Destination": "https://${LISTENER_HOST}ONLY"}

${EVENT_RESOURCEREMOVE}  { "Name": "This is ResourceRemoved Subscription event test", "Destination": "https://${LISTENER_HOST}", "Context": "THIS IS TEST FROM AUTO TEST SUBS RESOURCERMV", "Protocol": "Redfish", "EventTypes": [ "ResourceRemoved" ] }

${PATCH_EVENT_RESOURCEREMOVE}  { "Name": "This is ResourceRemoved Subscription event patch test", "Destination": "https://${LISTENER_HOST}", "Context": "THIS IS TEST FROM AUTO TEST SUBS RESOURCERMV"}

${PATCH_EVENT_RESOURCEREMOVE_CONTEXT}  { "Context": "THIS IS PATCH TEST FROM AUTO TEST SUBS ONLY"}

** Test Cases **

Verify Redfish Admin Add Event
    [Documentation]  Subscribe Event
    [Tags]  Admin Redfish_Add_Event 
    Redfish Admin Add Event 

Verify Redfish Admin Patch Event
    [Documentation]  Subscribe Event
    [Tags]  Admin Redfish_Patch_Event 
    Redfish Admin Patch Event 

Verify Redfish Admin Del Event
    [Documentation]  Del Subscribed Event
    [Tags]  Admin Redfish_Del_Event 
    Redfish Admin Del Event 

Verify Redfish Op Add Event
    [Documentation]  Subscribe Event
    [Tags]  Op Redfish_Add_Event 
    Redfish Op Add Event 

Verify Redfish Op Del Event
    [Documentation]  Del Subscribed Event
    [Tags]  Op Redfish_Del_Event 
    Redfish Op Del Event 

Verify Redfish ReadOnly Add Event
    [Documentation]  Subscribe Event
    [Tags]  ReadOnly Redfish_Add_Event 
    Redfish ReadOnly Add Event 

Verify Redfish Op Add Event
    [Documentation]  Subscribe Event
    [Tags]  Op Redfish_Add_Event 
    Redfish Op Add Event 

Verify Redfish ReadOnly Del Event
    [Documentation]  Del Subscribed Event
    [Tags]  ReadOnly Redfish_Del_Event 
    Redfish ReadOnly Del Event 

Verify Redfish Op Del Event
    [Documentation]  Del Subscribed Event
    [Tags]  Op Redfish_Del_Event 
    Redfish Op Del Event 


*** Keywords ***

Test Setup Execution
    [Documentation]  Do test case setup tasks.

    Redfish.Login

Test Teardown Execution
    [Documentation]  Do the post test teardown.

    Redfish.Logout

Redfish Admin Add Event
    [Documentation]  Admin can add Subscribe Event 

    ${payload}=  Evaluate  json.loads($EVENT_ALERT)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEADD)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEREMOVE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}


Redfish Admin Patch Event
    [Documentation]  Admin can patch added Subscribe Event 

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_ALERT)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/1  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_RESOURCEADD)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/2  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_RESOURCEREMOVE)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/3  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_ALERT_NAME)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/1  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_RESOURCEADD_DES)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/2  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Evaluate  json.loads($PATCH_EVENT_RESOURCEREMOVE_CONTEXT)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/EventService/Subscriptions/3  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}


Redfish Admin Del Event
    [Documentation]  Admin can Del Subscribed Event 

    ${resp_list}=  Redfish_Utils.List Request
    ...  redfish/v1/EventService/Subscriptions/

    ${resp}=  Redfish.Delete  ${resp_list[1]} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    Redfish.Delete  ${resp_list[2]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    Redfish.Delete  ${resp_list[3]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

Redfish Op Add Event
    [Documentation]  Operator can add Subscribe Event 

    Redfish Create User  NewOp    OpUser  OpUserPwd  Operator  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  OpUser  OpUserPwd

    ${payload}=  Evaluate  json.loads($EVENT_ALERT)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEADD)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEREMOVE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}

    Redfish.Logout
    Redfish.Login

Redfish Op Del Event
    [Documentation]  Operator can del Subscribed Event 

    Redfish Create User  NewOp    OpUser  OpUserPwd  Operator  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  OpUser  OpUserPwd

    ${resp_list}=  Redfish_Utils.List Request
    ...  redfish/v1/EventService/Subscriptions/

    ${resp}=   Redfish.Delete  ${resp_list[1]} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    ${resp}=   Redfish.Delete  ${resp_list[2]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    ${resp}=  Redfish.Delete  ${resp_list[3]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_NO_CONTENT}

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser

Redfish ReadOnly Add Event
    [Documentation]  ReadOnly User can't Subscribe Event 

    Redfish Create User  NewReadOnly  ReadOnly1  UserPwd  ReadOnly  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ReadOnly1  UserPwd

    ${payload}=  Evaluate  json.loads($EVENT_ALERT)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEADD)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($EVENT_RESOURCEREMOVE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/EventService/Subscriptions/  body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser


Redfish ReadOnly Del Event
    [Documentation]  ReadOnly User can't del Subscribed Event 

    Redfish Create User  NewReadOnly  ReadOnly1  UserPwd  ReadOnly  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ReadOnly1  UserPwd

    ${resp_list}=  Redfish_Utils.List Request
    ...  redfish/v1/EventService/Subscriptions/

    ${resp}=  Redfish.Delete  ${resp_list[1]} 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    ${resp}=  Redfish.Delete  ${resp_list[2]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    ${resp}=  Redfish.Delete  ${resp_list[3]}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser

Redfish Create User
    [Documentation]  Redfish create user.
    [Arguments]   ${name}  ${username}  ${password}  ${role_id}  ${locked}  ${enabled}

    # Description of argument(s):
    # name                The name to be created.
    # username            The username to be created.
    # password            The password to be assigned.
    # role_id             The role id of the user to be created
    #                     (e.g. "Administrator", "Operator", etc.).
    # locked              should be enabled (${True}, ${False}).
    # enabled             Indicates whether the username being created
    #                     should be enabled (${True}, ${False}).

    # Create specified user.
    ${payload}=  Create Dictionary
    ...  Name=${name}  UserName=${username}  Password=${password}  RoleId=${role_id}  Locked=${locked}  Enabled=${enabled}
    Redfish.Post  /redfish/v1/AccountService/Accounts  body=&{payload}
    ...  valid_status_codes=[${HTTP_CREATED}]
