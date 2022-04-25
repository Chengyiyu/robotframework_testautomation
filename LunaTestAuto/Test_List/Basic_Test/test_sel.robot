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
Verify Clear Event Log
    [Documentation]    1. Login BMC WebUI.
    ...    2. Logs & Reports> IPMI Evnet Log.
    ...    3. Enter "Clear Event Logs" button.
    ...    4. Check clear event is generated or not.
    [Tags]    Verify Clear Event Log
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Click Button    ${xpath_clear_log_button}
    Handle Alert
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${irow}    set Variable    [1]
    ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
    Should Contain    ${resp}    Log Area Reset/Cleared - Asserted

Verify SEL Event
    [Documentation]    1. Full SEL via ipmi command.
    ...    2. Login BMC WebUI.
    ...    3. Logs & Reports> IPMI Event Log.
    [Tags]    Verify SEL Event
    Run External IPMI Standard Command    sel elist
    Go And Check SEL Event Page

Verify SEL Event Decode
    [Documentation]    1. Login BMC WebUI.
    ...    2. Enter IPMI SEL Page
    ...    Logs & Reports> IPMI Event Log.
    ...    3. Check IPMI Event Logs.
    ...    4. Unknown SEL should not be exist on the screen
    ...    5. Click "Download Event Log (txt)" to decode SEL.
    ...    6. Unknown SEL should not be exist.
    [Tags]    Verify SEL Event Decode
    Go And Check SEL Event Page
    Wait Until Element Is Enabled    ${xpath_download_log_button}    timeout=${BROWSER_CONNECTION_TIMEOUT}
    Page Should Not Contain    Unknown
    ${home_dir}    Get Environment Variable    HOME
    ${download_dir}    Join Path    ${home_dir}    Downloads
    # download
    Click Element    ${xpath_download_log_button}
    # wait for download to finish
    ${file}    Wait Until Keyword Succeeds    1 min    2 sec    Download Should Be Done    ${download_dir}
    ${file_data}    OperatingSystem.Get File    ${file}    encoding=UTF-8    encoding_errors=strict
    Should Not Contain    ${file_data}    Unknown
    OperatingSystem.Remove File    ${file}

*** Keywords ***
Go And Check SEL Event Page
    [Documentation]    1. Full SEL via ipmi command.
    ...    2. Login BMC WebUI.
    ...    3. Logs & Reports> IPMI Evnet Log.
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}

Download Should Be Done
    [Arguments]    ${directory}
    [Documentation]    Verifies that the directory has only one folder and it is not a temp file.
    ...
    ...    Returns path to the file
    ${files}    OperatingSystem.List Files In Directory    ${directory}
    Length Should Be    ${files}    1    Should be only one file in the download folder
    Should Not Match Regexp    ${files[0]}    (?i).*\\.tmp    still downloading a file
    ${file}    Join Path    ${directory}    ${files[0]}
    Log    File was successfully downloaded to ${file}
    [Return]    ${file}
