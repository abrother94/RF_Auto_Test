*** Settings ***
Documentation      Test PSME using https://github.com/DMTF/Redfish-Protocol-Validator 
...                DMTF tool.

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot

Library            OperatingSystem
Resource           ../../lib/dmtf_tools_utils.robot

*** Variables ***

${DEFAULT_PYTHON}  python3
${rsv_dir_path}    Redfish-Protocol-Validator
${rsv_github_url}  https://github.com/DMTF/Redfish-Protocol-Validator 
${command_string}  ${DEFAULT_PYTHON} ${rsv_dir_path}${/}rf_protocol_validator.py
...                -r https://${OPENBMC_HOST}  -u ${OPENBMC_USERNAME} -p ${OPENBMC_PASSWORD} --no-cert-check --avoid-http-redirect --report-dir=logs

*** Test Case ***

Test Redfish Using Redfish Service Validator
    [Documentation]  Check conformance with a Redfish service interface.
    [Tags]  Test_Redfish_Using_Redfish_Service_Validator

    Redfish.Login  admin  redfish 

    Download DMTF Tool  ${rsv_dir_path}  ${rsv_github_url}  "master"

    ${output}=  Run DMTF Tool  ${rsv_dir_path}  ${command_string}

    Redfish Service Validator Result  ${output}
