*** Settings ***
Resource          ../../lib/ipmi_client.robot
Resource          ../../Data/resource_variables.robot
Resource          ../../lib/GUI_Resource.robot
Library           Selenium2Library
Library           SSHLibrary

*** Test Cases ***
Firmware Downgrade Webui
    [Documentation]    Downgrade BMC firmeware by webui
    [Tags]    Firmeware downgrade Webui
    Suite Setup Execution
    Go To    ${FW_upgrade_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Choose File    ${xpath_upload_firmware_image}    ${BIOS_DOWNGRADE_IMAGE}
    Click Element    ${xpath_firmware_checks_button}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Select Checkbox    ${xpath_preserve_all_configuration_checkbox}
    Click Element    ${xpath_start_bmc_firmware_update_button}
    Handle Alert
    Wait Until Element Is Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Handle Alert    timeout=${FIRMEWARE_TIMEOUT}
    Close All Browsers
    Wait Until Keyword Succeeds    ${FIRMEWARE_TIMEOUT}    ${FIRMEWARE_RETRY_TIMEOUT}    Suite Setup Execution
    Run External IPMI Raw Command    0x06 0x01
    #20 81 00 16 02 bf 47 16 00 00 00 04 00 00 00
    Run External IPMI Standard Command    user list
    Close All Browsers

Firmware Upgrade Webui
    [Documentation]    Upgrade BMC firmeware by webui
    [Tags]    Firmeware Upgrade Webui
    Suite Setup Execution
    Go To    ${FW_upgrade_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Choose File    ${xpath_upload_firmware_image}    ${BIOS_UPGRADE_IMAGE}
    Click Element    ${xpath_firmware_checks_button}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Select Checkbox    ${xpath_preserve_all_configuration_checkbox}
    Click Element    ${xpath_start_bmc_firmware_update_button}
    Handle Alert
    Wait Until Element Is Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Handle Alert    timeout=${FIRMEWARE_TIMEOUT}
    Close All Browsers
    Wait Until Keyword Succeeds    ${FIRMEWARE_TIMEOUT}    ${FIRMEWARE_RETRY_TIMEOUT}    Suite Setup Execution
    Run External IPMI Raw Command    0x06 0x01
    #20 81 00 17 02 bf 47 16 00 00 00 04 00 00 00
    Run External IPMI Standard Command    user list
    Close All Browsers

Firmware Downgrade USB
    [Documentation]    Downgrade BMC firmeware by USB protocol
    [Tags]    Firmeware Downgrade USB
    Open Connection And Log In
    Execute Command    cd ${OS_FIRMWARE_DATA_DIRECTORY};./Yafuflash -fb -d 0x02 -cd ${OS_BIOS_DOWNGRADE_IMAGE}    timeout=${FIRMEWARE_TIMEOUT}
    Wait Until Keyword Succeeds    ${FIRMEWARE_TIMEOUT}    ${FIRMEWARE_RETRY_TIMEOUT}    Suite Setup Execution
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Close All Browsers

Firmware Upgrade USB
    [Documentation]    Upgrade BMC firmeware by USB protocol
    [Tags]    Firmeware Upgrade USB
    Open Connection And Log In
    Execute Command    cd ${OS_FIRMWARE_DATA_DIRECTORY};./Yafuflash -fb -d 0x02 -cd ${OS_BIOS_UPGRADE_IMAGE}    timeout=${FIRMEWARE_TIMEOUT}
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Close All Browsers

Firmware Downgrade LAN
    [Documentation]    Downgrade BMC firmeware by LAN protocol
    [Tags]    Firmeware Downgrade LAN
    Open Connection And Log In
    Execute Command    cd ${OS_FIRMWARE_DATA_DIRECTORY};ipmitool -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} hpm upgrade ${OS_BIOS_DOWNGRADE_IMAGE} -z 0x8000    timeout=${FIRMEWARE_TIMEOUT}
    Wait Until Keyword Succeeds    ${FIRMEWARE_TIMEOUT}    ${FIRMEWARE_RETRY_TIMEOUT}    Suite Setup Execution
    Run External IPMI Raw Command    0x06 0x01
    #20 81 00 17 02 bf 47 16 00 00 00 04 00 00 00
    Run External IPMI Standard Command    user list
    Close All Connections
    Close All Browsers

Firmware Upgrade LAN
    [Documentation]    Upgrade BMC firmeware by LAN protocol
    [Tags]    Firmeware Upgrade LAN
    Open Connection And Log In
    Execute Command    cd ${OS_FIRMWARE_DATA_DIRECTORY};ipmitool -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} hpm upgrade ${OS_BIOS_UPGRADE_IMAGE} -z 0x8000    timeout=${FIRMEWARE_TIMEOUT}
    Wait Until Keyword Succeeds    ${FIRMEWARE_TIMEOUT}    ${FIRMEWARE_RETRY_TIMEOUT}    Suite Setup Execution
    Run External IPMI Raw Command    0x06 0x01
    #20 81 00 17 02 bf 47 16 00 00 00 04 00 00 00
    Run External IPMI Standard Command    user list
    Close All Connections
    Close All Browsers

*** Keywords ***
Check Chassis Power Status Util ON
    ${output}=    Run External IPMI Standard Command    chassis power status
    Should Contain    ${output}    Chassis Power is on

Check Chassis Power Status Util OFF
    ${output}=    Run External IPMI Standard Command    chassis power status
    Should Contain    ${output}    Chassis Power is off

Open Connection And Log In
    Open Connection    ${OS_HOST}
    Login    ${OS_USERNAME}    ${OS_PASSWORD}
