*** Settings ***
Documentation    Test PSME Manager functionality.
Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Resource         ../../lib/common_utils.robot

Test Setup       Test Setup Execution
Test Teardown    Test Teardown Execution

*** Variables ***

*** Test Cases ***

Verify Redfish PSME Chassis Properties
    [Documentation]  Verify PSME chassis resource properties.
    [Tags]  Verify_Redfish_PSME_Chsssis_Properties

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

Check Thermal Sensor 
    [Documentation]  Verify Thermal sensor 
    [Tags]  Verify_Thermal_sensor 

    ${resp}=  Redfish.Get   /redfish/v1/Chassis/1/Thermal/ 
 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${item_count}  Get Length  ${resp.dict['Temperatures']}
    Log to console             ${item_count} 

    ${n1}  Set Variable  1
    ${n2}  Set Variable  ${item_count} 

    FOR  ${i}  IN RANGE   ${n1}   ${n2} 
        Test Thermal Sensor reading   ${i}
    END

    ${resp_os}=  Redfish.Get  /redfish/v1/Systems/1
    Should Be Equal As Strings  ${resp_os.status}  ${HTTP_OK}
    ${NOS_Type} =  Set Variable  ${resp_os.dict['HostName']}

    Run Keyword If  '${NOS_Type}' != 'sonic' 
    ...     Test Thermal Sensor reading threshold loop
    ...  ELSE          
    ...     Log to console             "NO NEED TEST THERMAL THRESHOLD IN SONIC NOS" 

    FOR  ${i}  IN RANGE   ${n1}   ${n2} 

       Run Keyword If  '${NOS_Type}' != 'sonic' 
       ...     Test Set Thermal Sensor Threshold  ${i}
       ...  ELSE          
       ...     Log to console     "NO NEED TEST SET THERMAL THRESHOLD IN SONIC NOS" 
        
    END

Check Fan 

    [Documentation]  Verify Fan and verify status
    [Tags]  Verify_FAN_and_verify_status

    ${resp}=  Redfish.Get   /redfish/v1/Chassis/1/Thermal/ 
 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${item_count}  Get Length  ${resp.dict['Fans']}
    Log to console             ${item_count} 

    ${n1}  Set Variable  1
    ${n2}  Set Variable  ${item_count}  

    Log to console  "#################################################" 
    FOR  ${i}  IN RANGE   ${n1}   ${n2} 
       Plug In Fan  ${i}
    END

Check PSU

    [Documentation]  Verify PSU and verify status
    [Tags]  Verify_PSU_and_verify_status

    Log to console  "######## Plug In PSU 1 with Power Core #######" 
    Plug In PSU  1 

    Log to console  "######## Plug In PSU 2 with Power Core #######" 
    Plug In PSU  2 

*** Keywords ***

Test Setup Execution
    [Documentation]  Do test case setup tasks.

    redfish.Login

Test Teardown Execution
    [Documentation]  Do the post test teardown.

    redfish.Logout

Test Thermal Sensor reading
    [Documentation]  Test Thermal Sensor reading
    [Tags]  Test Thermal Sensor Reading
    [Arguments]   ${THERMAL_SENSOR_ID} 
    ${ID}=  Evaluate  ${THERMAL_SENSOR_ID} - ${1}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Log to console              ${resp.dict['Temperatures'][${ID}]}
    Should Be Equal As Strings  ${resp.dict['Temperatures'][${ID}]['Status']['State']}  Enabled 

    Log to console               ${resp.dict['Temperatures'][${ID}]['ReadingCelsius']}
    Run Keyword If  ${resp.dict['Temperatures'][${ID}]['ReadingCelsius']} != None 
     ...        Should Be True  ${resp.dict['Temperatures'][${ID}]['ReadingCelsius']} > 0


Test Thermal Sensor reading threshold loop

    ${resp}=  Redfish.Get   /redfish/v1/Chassis/1/Thermal/ 
 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${item_count}  Get Length  ${resp.dict['Temperatures']}
    Log to console             ${item_count} 

    ${n1}  Set Variable  1
    ${n2}  Set Variable  ${item_count} 

    FOR  ${i}  IN RANGE   ${n1}   ${n2}        
       Test Thermal Sensor reading threshold  ${i}       
    END      

Test Thermal Sensor reading threshold
    [Documentation]  Test Thermal Sensor reading
    [Tags]  Test Thermal Sensor Reading
    [Arguments]   ${THERMAL_SENSOR_ID} 
    ${ID}=  Evaluate  ${THERMAL_SENSOR_ID} - ${1}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Log to console               ${resp.dict['Temperatures'][${ID}]['LowerThresholdNonCritical']}
    Should Be True  ${resp.dict['Temperatures'][${ID}]['LowerThresholdNonCritical']} >= 0
    ${LowerThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['LowerThresholdNonCritical']}

    Log to console               ${resp.dict['Temperatures'][${ID}]['UpperThresholdNonCritical']}
    Should Be True  ${resp.dict['Temperatures'][${ID}]['UpperThresholdNonCritical']} > 0
    ${UpperThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['UpperThresholdNonCritical']}

    Should Be True   ${UpperThNonCri} > ${LowerThNonCri}

    Log to console               ${resp.dict['Temperatures'][${ID}]['UpperThresholdCritical']}
    Should Be True  ${resp.dict['Temperatures'][${ID}]['UpperThresholdCritical']} > 0

    Log to console               ${resp.dict['Temperatures'][${ID}]['UpperThresholdFatal']}
    Should Be True  ${resp.dict['Temperatures'][${ID}]['UpperThresholdFatal']} > 0

Test Set Thermal Sensor Threshold 
    [Documentation]  Test Set Thermal Sensor Threshold
    [Tags]  Test Thermal Sensor
    [Arguments]   ${THERMAL_SENSOR_ID}
    ${ID}=  Evaluate  ${THERMAL_SENSOR_ID} - ${1}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    ${CurrentTemp} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['ReadingCelsius']}
    ${LowerThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['LowerThresholdNonCritical']}
    ${LowerThNonCriPlus1} =   Evaluate  ${LowerThNonCri} + ${1}
    ${UpperThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['UpperThresholdNonCritical']}
    ${UpperThNonCriPlus1} =   Evaluate  ${UpperThNonCri} + ${1}

    ${payload_1}=  Create Dictionary
    ...  MemberId=${THERMAL_SENSOR_ID}  LowerThresholdNonCritical=${UpperThNonCri}  UpperThresholdNonCritical=${LowerThNonCri} 

    ${payload}=  Create Dictionary
    ...  Temperatures=${payload_1}


    Sleep  1s
    Log to console              "BadRequest###############${payload}################"
    ${resp}=  Redfish.Patch  /redfish/v1/Chassis/1/Thermal   body=&{payload}
    Should Be Equal As Strings  ${resp.status}  ${HTTP_BAD_REQUEST}

    ${VAR_ID} =  Convert To String  ${THERMAL_SENSOR_ID}  


    #${LowerThNonOverCurrentTemp} =   Evaluate  ${CurrentTemp} + ${2}
    #${payload_lower_upper}=  Create Dictionary
    #...  MemberId=${VAR_ID}  LowerThresholdNonCritical=${LowerThNonOverCurrentTemp}  UpperThresholdNonCritical=${UpperThNonCriPlus1}

    #${payload_lower_upper_body}=  Create Dictionary
    #...  Temperatures=${payload_lower_upper}

    #Sleep  1s
    #Log to console              "NormalPatch##############${payload_lower_upper_body}############"
    #${resp}=  Redfish.Patch  /redfish/v1/Chassis/1/Thermal  body=&{payload_lower_upper_body}
    #Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    #${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal 
    #Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    #${LowerThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['LowerThresholdNonCritical']}
    #Should Be Equal As Integers  ${LowerThNonOverCurrentTemp}  ${LowerThNonCri}

    #${UpperThNonCri} =  Set Variable  ${resp.dict['Temperatures'][${ID}]['UpperThresholdNonCritical']}
    #Should Be Equal As Integers  ${UpperThNonCriPlus1}  ${UpperThNonCri}


Plug In Fan 
    [Documentation]  Plug In Fan and verify status
    [Tags]  Plug_In_Fan_and_verify_status
    [Arguments]   ${FAN_ID} 
    ${ID}=  Evaluate  ${FAN_ID} - ${1}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Thermal 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Log to console              ${resp.dict['Fans'][${ID}]}
    Should Be Equal As Strings  ${resp.dict['Fans'][${ID}]['Status']['State']}  Enabled 

    Log to console               ${resp.dict['Fans'][${ID}]['Reading']}
    Run Keyword If  ${resp.dict['Fans'][${ID}]['Reading']} != None 
     ...        Should Not Be Equal As Integers  ${resp.dict['Fans'][${ID}]['Reading']}  0
    
Plug In PSU
    [Documentation]  Plugi In PSU and verify status
    [Tags]  Plug_In_PSU_and_verify_status
    [Arguments]   ${PSU_ID} 
    ${ID}=  Evaluate  ${PSU_ID} - ${1}

    ${resp}=  Redfish.Get  /redfish/v1/Chassis/1/Power 
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}

    Log to console              ${resp.dict['PowerControl'][${ID}]['Status']['State']}
    Should Be Equal As Strings  ${resp.dict['PowerControl'][${ID}]['Status']['State']}  Enabled 

    Log to console   ${resp.dict['PowerControl'][${ID}]['PowerConsumedWatts']}
    Should Not Be Equal As Integers  ${resp.dict['PowerControl'][${ID}]['PowerConsumedWatts']}  0

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
