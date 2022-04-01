*** Settings ***
Suite Setup       Suite Setup Execution
Suite Teardown    Close All Browsers
Resource          ../../lib/GUI_Resource.robot
Resource          ../../Data/resource_variables.robot
Library           Selenium2Library

*** Variables ***
${find_log}       ${EMPTY}

*** Test Cases ***
clear event log
    [Documentation]    1. Login BMC WebUI.
    ...    2. Logs & Reports> IPMI Evnet Log.
    ...    3. Enter "Clear Event Logs" button.
    ...    4. Check clear event is generated or not.
    [Tags]    SEL_check
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=300s
    Click Button    ${xpath_clear_log_button}
    Handle Alert
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=300s
    ${irow}    set Variable    [1]
    ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
    Should Contain    ${resp}    Log Area Reset/Cleared - Asserted

SEL event
    [Documentation]    1. Full SEL via ipmi command.
    ...    2. Login BMC WebUI.
    ...    3. Logs & Reports> IPMI Evnet Log.
    [Tags]    SEL_check
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=300s
