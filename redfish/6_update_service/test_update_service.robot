*** Settings ***
Documentation    Test Redfish update service 

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Library          Collections

*** Variables ***
${URI_BODY_THE_SAME_NOS_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/ONL-HEAD_ONL-OS8_2020-09-03.1004-f0bcb23_AMD64_INSTALLED_INSTALLER" }
${URI_BODY_LATEST_NOS_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/ONL-HEAD_ONL-OS8_2020-10-23.0019-f0bcb23_AMD64_INSTALLED_INSTALLER" }
${URI_BODY_WRONG_CPLD_FORMAT_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/asgvolt64_as4630cpldcpu_vb.0.0.1t.updater" }
${URI_BODY_ERROR_FORMAT_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/asgvolt64_onie_diag_installer_v02.01.00.11.bin" }
${URI_BODY_ERROR_TOO_LARGE_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/asgvolt64_pak_vb.0.0.1_zz.updater.01.00.11.bin" }
${URI_BODY_OK_MU_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/asgvolt64_pak_vb.0.0.2_zz.updater" }
${URI_BODY_NON_EXIST_FILE}  { "ImageURI": "http://${UPDATE_SERVER}/NONEXISTFILE" }


** Test Cases **

Verify Redfish Admin MU update serivce 
    [Documentation]  Test Admin MU update service 
    [Tags]   
    Redfish.Login

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Redfish Admin update test  
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 


Verify Redfish Admin MU update serivce with too large image
    [Documentation]  Test Admin MU update service with image size larger then onie-boot partition 
    [Tags]   
    Redfish.Login

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Redfish Admin MU update serivce with too large image
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

    Redfish.Login

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Verify MU Status Failure
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

#Verify Redfish Admin MU update serivce with OK image
#    [Documentation]  Test Admin MU update service with OK image 
#    [Tags]   
#    Redfish.Login
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#    ...          Redfish Admin MU update serivce with OK image
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
#    # Wait update ready
#    Sleep  960s
#
#    Redfish.Login
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#    ...          Verify MU Status Success 
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
Verify Redfish Admin MU update serivce with wrong cpld image
    [Documentation]  Test Admin MU update service with wrong error cpld image 
    [Tags]   
    Redfish.Login

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Redfish Admin update test with wrong error cpld image 
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

    Redfish.Login

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Verify MU Status Failure
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

#Verify Redfish Admin NOS update serivce with the same NOS version image
#    [Documentation]  Test Admin NOS update service with the same version of NOS image, you need pre-install the same image first 
#    [Tags]   
#
#    Redfish.Login
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#    ...          Redfish Admin update test with the same NOS version image
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
#    #take some time to download
#    Sleep  120s
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#    ...          Verify NOS Status Failure
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
#Verify Redfish Admin NOS update serivce with the latest NOS version image
#    [Documentation]  Test Admin NOS update service with latest version of NOS image
#    [Tags]   
#
#    Redfish.Login
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#     ...          Redfish Admin update test with the latest version image
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
#    #take some time to download
#
#    Sleep  300s
#
#    Run Keyword If  '${UPDATE_SERVER}' != '' 
#    ...          Verify NOS Status Success 
#    ...    ELSE          
#    ...          Log to console  "####### Do not test update Service ######" 
#
Verify Redfish Readonly user can not update test 
    [Documentation]  Test readonly user can not  MU update service 
    [Tags]   

    Redfish.Login
    Redfish Create User  NewReadOnly  ReadOnly1  UserPwd  ReadOnly  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ReadOnly1  UserPwd

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Redfish ReadOnly update test 
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/ReadOnly1
    Redfish.Logout

Verify Redfish Op user can update test 
    [Documentation]  Test Op user can MU update service 
    [Tags]   

    Redfish.Login
    Redfish Create User  NewOP  OpUser1  UserPwd  Operator  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  OpUser1  UserPwd

    Run Keyword If  '${UPDATE_SERVER}' != '' 
    ...          Redfish OpUser update test 
    ...    ELSE          
    ...          Log to console  "####### Do not test update Service ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser1
    Redfish.Logout

    Sleep  2s

*** Keywords ***

Redfish Admin update test with wrong error cpld image 
    [Documentation]  Test Admin update service with wrong cpld image.

    ${payload}=  Evaluate  json.loads($URI_BODY_WRONG_CPLD_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    # Wait update ready
    Sleep  360s

Redfish Admin MU update serivce with too large image
    [Documentation]  Test Admin update service with too large image.

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_TOO_LARGE_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    # Wait download ready
    Sleep  80s

Verify MU Status Failure
    [Documentation]  Check MU Status is Failure 

    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/MU 
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

Verify MU Status Success 
    [Documentation]  Check MU Status is success 

    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/MU 
    Should Not Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure

Verify NOS Status Failure
    [Documentation]  Check NOS Status is Failure 

    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/NOS
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

Verify NOS Status Success 
    [Documentation]  Check NOS Status is success 

    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/NOS
    Should Not Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure

Redfish Admin MU update serivce with OK image
    [Documentation]  Test Admin update service with too large image.

    ${payload}=  Evaluate  json.loads($URI_BODY_OK_MU_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

Redfish Admin update test with the same NOS version image 
    [Documentation]  Test Admin update service with the same NOS version image 

    ${payload}=  Evaluate  json.loads($URI_BODY_THE_SAME_NOS_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

Redfish Admin update test with the latest version image
    [Documentation]  Test Admin update service with the latest NOS version image 

    ${payload}=  Evaluate  json.loads($URI_BODY_LATEST_NOS_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

Redfish Admin update test 
    [Documentation]  Test Admin update service.

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    #Check if under downloading process
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    Sleep  60s

    #NON exit file download test
    ${payload}=  Evaluate  json.loads($URI_BODY_NON_EXIST_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Sleep  15s
    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/MU 
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

    #Under update status, any more post will be forbidden
    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    #Can post NOS upate now!!
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}

    Sleep  60s
#NOS Part

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    #Can post MU upate now!!
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    Sleep  5s
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    Sleep  20s
    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/NOS
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

Redfish ReadOnly update test 
    [Documentation]  ReadOnly can not update service 

    Sleep  20s
    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}

Redfish OpUser update test 
    [Documentation]  Op user can update service 
    Sleep  20s
#MU Part

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    #Check if under downloading process
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    Sleep  30s

    #NON exit file download test
    ${payload}=  Evaluate  json.loads($URI_BODY_NON_EXIST_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Sleep  10s
    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/MU 
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

    #Under update status, any more post will be forbidden
    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    #Can post NOS upate now!!
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}

    Sleep  20s
#NOS Part

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_FILE)    json 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Downloading 
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/NOS   body=${payload}
    #Can post MU upate now!!
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    Sleep  5s
    ${resp}=  Redfish.Post  /redfish/v1/UpdateService/FirmwareInventory/MU   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_FORBIDDEN}
    Sleep  30s
    ${resp}=  Redfish.Get  /redfish/v1/UpdateService/FirmwareInventory/NOS
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]["UpdateState"]}  Failure 

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
