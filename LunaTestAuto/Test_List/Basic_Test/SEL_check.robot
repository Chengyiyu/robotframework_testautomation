*** Settings ***
Suite Setup       Suite Setup Execution
Suite Teardown    Close All Browsers
Resource          ../../lib/GUI_Resource.robot
Resource          ../../Data/resource_variables.robot
Resource          ../../lib/ipmi_client.robot
Library           OperatingSystem
Library           Selenium2Library
Library           RequestsLibrary

*** Variables ***
${find_log}       ${EMPTY}

*** Test Cases ***
Clear Event Log
    [Documentation]    1. Login BMC WebUI.
    ...    2. Logs & Reports> IPMI Evnet Log.
    ...    3. Enter "Clear Event Logs" button.
    ...    4. Check clear event is generated or not.
    [Tags]    SEL_check
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Click Button    ${xpath_clear_log_button}
    Handle Alert
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${irow}    set Variable    [1]
    ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
    Should Contain    ${resp}    Log Area Reset/Cleared - Asserted

SEL Event
    [Documentation]    1. Full SEL via ipmi command.
    ...    2. Login BMC WebUI.
    ...    3. Logs & Reports> IPMI Evnet Log.
    [Tags]    SEL_check
    Run External IPMI Standard Command    sel elist
    Go And Check SEL Event Page

SEL Event Decode
    [Documentation]    1. Login BMC WebUI.
    ...    2. Enter IPMI SEL Page
    ...    Logs & Reports> IPMI Evnet Log.
    ...    3. Check IPMI Event Logs.
    ...    4. Unknown SEL should not be exist on the screen
    ...    5. Click "Download Event Log (txt)" to decode SEL.
    ...    6. Unknown SEL should not be exist.
    Go And Check SEL Event Page
    Page Should Contain Element    ${xpath_download_log_button}

*** Keywords ***
Go And Check SEL Event Page
    [Documentation]    1. Full SEL via ipmi command.
    ...    2. Login BMC WebUI.
    ...    3. Logs & Reports> IPMI Evnet Log.
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
