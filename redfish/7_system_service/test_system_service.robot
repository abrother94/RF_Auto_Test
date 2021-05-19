*** Settings ***
Documentation    Test Redfish system service 

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Library          Collections

*** Variables ***
${URI_BODY_ERROR_FORMAT_1}  {"GrubDefault":"errorONIE:update"} 
${URI_BODY_ERROR_FORMAT_2}  {"GrubDefault":"ONIE:errorupdate"} 
${URI_BODY_ERROR_FORMAT_3}  {"GrubDefault":"ONIE:"} 
${URI_BODY_ERROR_FORMAT_4}  {"GrubDefault":":update"} 
${URI_BODY_ERROR_FORMAT_5}  {"GrubDefault":":"} 
${URI_BODY_ERROR_FORMAT_6}  {"GrubDefault":""} 
${URI_BODY_ERROR_FORMAT_7}  {"GrubDefault":"XYZABCDEFG"} 

${URI_SOURCE_OR_BODY_ERROR_FORMAT_1}  {"Boot":{"BootSourceOverrideEnabled": "TWICE"}}
${URI_SOURCE_OR_BODY_ERROR_FORMAT_2}  {"Boot":{"BootSourceOverrideEnabled": ""}}
${URI_SOURCE_OR_BODY_ERROR_FORMAT_3}  {"Boot":{"BootSourceOverrideEnableds": "ONce"}}
${URI_SOURCE_OR_BODY_ERROR_FORMAT_4}  {"Boot":{"BootSourceOverrideEnableds": "Contiounous"}}
${URI_SOURCE_OR_BODY_ERROR_FORMAT_5}  {"Boot":{"BootSourceOverrideEnabled": "Disable "}}

${URI_SOURCE_OR_BODY_FORMAT_1}  {"Boot":{"BootSourceOverrideEnabled": "Disabled"}}
${URI_SOURCE_OR_BODY_FORMAT_2}  {"Boot":{"BootSourceOverrideEnabled": "Once"}}
${URI_SOURCE_OR_BODY_FORMAT_3}  {"Boot":{"BootSourceOverrideEnabled": "Continuous"}}

** Test Cases **
#########################################################################
# GrubDefault
#########################################################################

Verify Redfish Admin default grub NOS serivce 
    [Documentation]  Test Admin default grub ONL serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${g_default_nos} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}
    set suite variable    ${g_default_nos}

    Run Keyword If  '${g_default_nos}' != 'None' 
    ...        Redfish default grub NOS serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

Verify Redfish Admin default grub onie update serivce 
    [Documentation]  Test Admin default grub onie update serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish default grub onie update serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 


Verify Redfish Op user can use default grub serivce test
    [Documentation]  Test Op default grub serivce
    [Tags]   
    Redfish.Login
    Redfish Create User  NewOP  OpUser1  UserPwd  Operator  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  OpUser1  UserPwd

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish default grub serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser1
    Redfish.Logout

Verify Redfish Readonly user can not use default grub serivce test
    [Documentation]  Test readonly user can not use default grub serivce test
    [Tags]   

    Redfish.Login
    Redfish Create User  NewReadOnly  ReadOnly1  UserPwd  ReadOnly  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ReadOnly1  UserPwd

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish readonly user can not use default grub serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/ReadOnly1
    Redfish.Logout

Verify Redfish Readonly user can not use source override serivce test
    [Documentation]  Test readonly user can not use source override serivce test
    [Tags]   

    Redfish.Login
    Redfish Create User  NewReadOnly  ReadOnly1  UserPwd  ReadOnly  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  ReadOnly1  UserPwd

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish readonly user can not use source override serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/ReadOnly1
    Redfish.Logout

Verify Redfish Admin default grub serivce 
    [Documentation]  Test Admin default grub serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish default grub serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

##########################################################################
### Oem Enabled Target 
##########################################################################


Verify Redfish Admin override target continuous to onie update serivce 
    [Documentation]  Test Redfish Admin grub override target continuous to onie update serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish Admin grub override target continuous to onie update serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

Verify Redfish Admin override target once to onie rescue serivce 
    [Documentation]  Test Redfish Admin grub override target once to onie rescue serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish Admin grub override target once to onie rescue serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

Verify Redfish Admin override target continuous to NOS serivce 
    [Documentation]  Test Redfish Admin grub override target continuous to NOS serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish Admin grub override target continuous to NOS serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

Verify Redfish Admin Oem boot srouce enabled override serivce
    [Documentation]  Test Admin Redfish default grub serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish boot srouce override target enabled serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 


Verify Redfish Op user can use boot srouce override enabled serivce
    [Documentation]  Test Op default grub serivce test
    [Tags]   
    Redfish.Login
    Redfish Create User  NewOP  OpUser1  UserPwd  Operator  ${False}  ${True}
    Redfish.Logout
    Redfish.Login  OpUser1  UserPwd

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish boot srouce override target enabled serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

    Redfish.Logout
    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/OpUser1
    Redfish.Logout

Set Redfish Admin default grub NOS serivce 
    [Documentation]  Test Admin default grub ONL serivce
    [Tags]   
    Redfish.Login

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${efi_support} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['GrubDefault']}

    Log to console  "####### Set NOS as default boot partition ######" 
    Run Keyword If  '${efi_support}' != 'None' 
    ...        Redfish default grub NOS serivce
    ...    ELSE          
    ...        Log to console  "####### Not Support EFI system ######" 

*** Keywords ***

Redfish Admin grub override target once to onie rescue serivce 
    [Documentation]  Test Admin Redfish Admin grub override target once to onie rescue serivce

    ${payload_1}=  Create Dictionary
    ...  BootSourceOverrideEnabled=Once

    ${payload}=  Create Dictionary
    ...  Boot=${payload_1}

    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Create Dictionary
    ...  BootSourceOverrideTarget=ONIE:rescue

    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTarget   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['BootSourceOverrideTarget']}  ONIE:rescue

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTargetTest 
    Should Be Equal As Strings  ${resp.dict['ONIEType']}  rescue
    Should Be Equal As Strings  ${resp.dict['BootSourceOverrideEnabled']}  Once 
    Should Be Equal As Strings  ${resp.dict['OemBootSourceOverrideTarget']}  ONIE:rescue

Redfish Admin grub override target continuous to onie update serivce 
    [Documentation]  Test Admin Redfish Admin grub override target continuous to onie update serivce

    ${payload_1}=  Create Dictionary
    ...  BootSourceOverrideEnabled=Continuous

    ${payload}=  Create Dictionary
    ...  Boot=${payload_1}

    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Create Dictionary
    ...  BootSourceOverrideTarget=ONIE:update

    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTarget   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTargetTest 
    Should Be Equal As Strings  ${resp.dict['ONIEType']}  update
    Should Be Equal As Strings  ${resp.dict['BootSourceOverrideEnabled']}  Continuous
    Should Be Equal As Strings  ${resp.dict['OemBootSourceOverrideTarget']}  ONIE:update

Redfish Admin grub override target continuous to NOS serivce 
    [Documentation]  Test Admin Redfish Admin grub override target continuous to NOS serivce

    ${payload_1}=  Create Dictionary
    ...  BootSourceOverrideEnabled=Continuous

    ${payload}=  Create Dictionary
    ...  Boot=${payload_1}

    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp_os}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp_os.status}  ${HTTP_OK}
    ${NOS_Type} =  Set Variable  ${resp_os.dict['HostName']}

    Run Keyword If  '${NOS_Type}' != 'sonic' 
    ...        Source OverRide BootSourceOverrideTarget Value Set Test  Open Network Linux
    ...  ELSE          
    ...        Source OverRide BootSourceOverrideTarget Value Set Test  SONiC-OS

Redfish default grub serivce
    [Documentation]  Test Admin default grub serivce

    #NON correct format onie type
    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_1)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_2)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_3)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_4)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_5)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_6)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_7)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/ 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    ${item_count}  Get Length  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['Actions']['#ComputerSystem.GrubDefault']['GrubDefault@Redfish.AllowableValues']}
    Log to console             ${item_count} 

    FOR  ${i}  IN RANGE   0   ${item_count}
    	${Available_Value} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['Actions']['#ComputerSystem.GrubDefault']['GrubDefault@Redfish.AllowableValues'][${i}]}
	Grub Default Available Value Set Test  ${Available_Value}
    END

    Log to console  "####### Set back to NOS  ######" 
    ${resp_os}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp_os.status}  ${HTTP_OK}
    ${NOS_Type} =  Set Variable  ${resp_os.dict['HostName']}

    Run Keyword If  '${NOS_Type}' != 'sonic' 
    ...        Grub Default Available Value Set Test  Open Network Linux 
    ...  ELSE          
    ...        Grub Default Available Value Set Test  ${g_default_nos} 

Redfish default grub NOS serivce
    [Documentation]  Test Admin default grub ONL serivce

    ${resp_os}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp_os.status}  ${HTTP_OK}
    ${NOS_Type} =  Set Variable  ${resp_os.dict['HostName']}

    Run Keyword If  '${NOS_Type}' != 'sonic' 
    ...        Grub Default Available Value Set Test  Open Network Linux 
    ...  ELSE          
    ...        Grub Default Available Value Set Test  ${g_default_nos} 

Redfish default grub onie update serivce
    [Documentation]  Test Admin default grub onie update serivce
    Grub Default Available Value Set Test  ONIE:update 

Redfish boot srouce override target enabled serivce
    [Documentation]  Test Admin boot srouce override serivce

    #NON correct format boot source type

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_ERROR_FORMAT_1)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_ERROR_FORMAT_2)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_ERROR_FORMAT_3)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_ERROR_FORMAT_4)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_ERROR_FORMAT_5)    json 
    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    ${item_count}  Get Length  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['Actions']['#ComputerSystem.BootSourceOverrideTarget']['BootSourceOverrideTarget@Redfish.AllowableValues']}
    Log to console             ${item_count} 

    FOR  ${i}  IN RANGE   0   ${item_count}
    	${Available_Value} =  Set Variable  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['Actions']['#ComputerSystem.BootSourceOverrideTarget']['BootSourceOverrideTarget@Redfish.AllowableValues'][${i}]}
	Source OverRide BootSourceOverrideTarget Value Set Test  ${Available_Value} 
    END

    Source OverRide BootSourceOverrideEnabled Value Set Test  Continuous 
    Source OverRide BootSourceOverrideEnabled Value Set Test  Once 
    Source OverRide BootSourceOverrideEnabled Value Set Test  Disabled 

Grub Default Available Value Set Test
    [Documentation]  Grub Default Available Value Set Test
    [Arguments]   ${available_value}

    # Description of argument(s):
    # available_value                The value to set in GrubDefault

    ${payload_1}=  Create Dictionary
    ...  BootSourceOverrideEnabled=Disabled

    ${payload}=  Create Dictionary
    ...  Boot=${payload_1}

    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${payload}=  Create Dictionary
    ...  GrubDefault=${available_value}
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.dict["Oem"]["Intel_RackScale"]["Accton_Oem"]['GrubDefault']}  ${available_value} 

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTargetTest
    Should Be Equal As Strings  ${resp.dict['BootSourceOverrideEnabled']}  Disabled 

Source OverRide BootSourceOverrideEnabled Value Set Test

    [Documentation]  Source OverRide BootSourceOverrideEnabled Available Value Set Test
    [Arguments]   ${available_value}

    # Description of argument(s):
    # available_value              The value to set in Source OverRide 

    ${payload_1}=  Create Dictionary
    ...  BootSourceOverrideEnabled=${available_value}

    ${payload}=  Create Dictionary
    ...  Boot=${payload_1}

    ${resp}=  Redfish.Patch  /redfish/v1/Systems/1   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.dict["Boot"]["BootSourceOverrideEnabled"]}  ${available_value} 

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTargetTest 
    Should Be Equal As Strings  ${resp.dict['BootSourceOverrideEnabled']}  ${available_value}

Source OverRide BootSourceOverrideTarget Value Set Test

    [Documentation]  Source OverRide BootSourceOverrideTarget Value Set Test
    [Arguments]   ${available_value}

    # Description of argument(s):
    # available_value              The value to set in Source OverRide Target 

    ${payload}=  Create Dictionary
    ...  BootSourceOverrideTarget=${available_value}

    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.BootSourceOverrideTarget  body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${resp}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp.dict['Oem']['Intel_RackScale']['Accton_Oem']['BootSourceOverrideTarget']}  ${available_value} 

Redfish readonly user can not use default grub serivce 
    [Documentation]  Test readonly user can not use  default grub serivce

    #NON correct format onie type
    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_1)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_2)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_3)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($URI_BODY_ERROR_FORMAT_4)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

Redfish readonly user can not use source override serivce
    [Documentation]  Test readonly user can not use  default grub serivce

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_FORMAT_1)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_FORMAT_2)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

    ${payload}=  Evaluate  json.loads($URI_SOURCE_OR_BODY_FORMAT_3)    json 
    ${resp}=  Redfish.Post  /redfish/v1/Systems/1/Actions/ComputerSystem.GrubDefault   body=${payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_METHOD_NOT_ALLOWED}

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
    ${resp}=  Redfish.Post  /redfish/v1/AccountService/Accounts  body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_CREATED}
