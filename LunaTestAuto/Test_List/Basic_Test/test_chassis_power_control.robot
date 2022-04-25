*** Settings ***
Suite Setup       Suite Setup Execution
Suite Teardown    Close All Browsers
Force Tags        Chassis_Power_Control
Resource          ../../lib/GUI_Resource.robot
Resource          ../../Data/resource_variables.robot
Resource          ../../lib/ipmi_client.robot
Library           Selenium2Library

*** Variables ***
${find_log}       ${EMPTY}
${irow}           ${EMPTY}

*** Test Cases ***
Webpage Chassis Power OFF
    [Documentation]    This test case verfies system power off status
    ...    Check capability of power control on Web GUI.
    [Tags]    Webpage Chassis Power OFF
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    Go To    ${power_control_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Element Should Be Enabled    ${xpath_save_button}
    Click Element    ${xpath_power_off_radio}
    Click Element    ${xpath_save_button}
    Handle Alert
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a0h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

Webpage Chassis Power ON
    [Documentation]    This test case verfies system power on status
    ...    Check capability of power control on Web GUI.
    [Tags]    Webpage Chassis Power ON
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is on'    IPMI Command Power OFF
    Go To    ${power_control_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Element Should Be Enabled    ${xpath_save_button}
    Click Element    ${xpath_power_on_radio}
    Click Element    ${xpath_save_button}
    Handle Alert
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a1h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

Webpage Chassis Power Cycle
    [Documentation]    This test case verfies system power cycle status
    ...    Check capability of power control on Web GUI.
    [Tags]    Webpage Chassis Power Cycle
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    Go To    ${power_control_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Element Should Be Enabled    ${xpath_save_button}
    Click Element    ${xpath_power_cycle_radio}
    Click Element    ${xpath_save_button}
    Handle Alert
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a2h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

Webpage Chassis Power Hard Reset
    [Documentation]    This test case verfies system power hard reset status
    ...    Check capability of power control on Web GUI.
    [Tags]    Webpage Chassis Power Hard Reset
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    ${power_status_before}=    Check Chassis Power Status
    Go To    ${power_control_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Element Should Be Enabled    ${xpath_save_button}
    Click Element    ${xpath_power_hard_reset_radio}
    Click Element    ${xpath_save_button}
    Handle Alert
    ${power_status_after}=    Check Chassis Power Status
    Should Be Equal    ${power_status_before}    ${power_status_before}
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a3h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

Webpage Chassis Power Soft Shutdown
    [Documentation]    This test case verfies system powersoft shutdone status
    ...    Check capability of power control on Web GUI.
    [Tags]    Webpage Chassis Power Soft Shutdown
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    ${power_status_before}=    Check Chassis Power Status
    Go To    ${power_control_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    Element Should Be Enabled    ${xpath_save_button}
    Click Element    ${xpath_power_ACPI_shutdown_radio}
    Click Element    ${xpath_save_button}
    Handle Alert
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a4h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

IPMI Chassis Power Cycle
    [Documentation]    This test case verfies system power cycle status
    ...    using IPMI Get Chassis status command.
    [Tags]    IPMI Chassis Power Cycle
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    Run External IPMI Standard Command    chassis power cycle
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a2h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

IPMI Chassis Power OFF
    [Documentation]    This test case verfies system power off status
    ...    using IPMI Get Chassis status command.
    [Tags]    IPMI Chassis Power OFF
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    IPMI Command Power OFF
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a0h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

IPMI Chassis Power Reset
    [Documentation]    This test case verfies system power hard reset of status
    ...    using IPMI Get Chassis status command.
    [Tags]    IPMI Chassis Power Reset
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    ${power_status_before}=    Check Chassis Power Status
    Run External IPMI Standard Command    chassis power reset
    ${power_status_after}=    Check Chassis Power Status
    Should Be Equal    ${power_status_before}    ${power_status_before}
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a0h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

IPMI Chassis Power Soft Shutdown
    [Documentation]    This test case verfies system power soft shutdown of status
    ...    using IPMI Get Chassis status command.
    [Tags]    IPMI Chassis Power Soft Shutdown
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is off'    IPMI Command Power ON
    Run External IPMI Standard Command    chassis power soft
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a4h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

IPMI Chassis Power ON
    [Documentation]    This test case verfies system power on status
    ...    using IPMI Get Chassis status command.
    [Tags]    IPMI Chassis Power ON
    ${power_status}=    Check Chassis Power Status
    Run Keyword If    '${power_status}' == 'Chassis Power is on'    IPMI Command Power OFF
    IPMI Command Power ON
    Wait Until Keyword Succeeds    ${OS_WAIT_TIMEOUT}    ${OS_WAIT_RETRY_TIMEOUT}    Open Connection And Log In
    Close All Connections
    Go To    ${event_log_ipmi_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    ${count} =    Get Element Count    ${xpath_IPMI_Event_Log_table_row}
    FOR    ${row}    IN RANGE    1    ${count}
        ${irow}    set Variable    [${row}]
        ${resp} =    Get Text    ${xpath_IPMI_Event_Log_table_row}${irow}
        ${find_log}=    Run Keyword And Ignore Error    Should Contain    ${resp}    c5h 6fh a1h 01h
        Exit For Loop If    ${find_log} == ('PASS', None)
    END
    Should Not Contain    ${find_log}    FAIL

*** Keywords ***
Check Chassis Power Status
    ${output}=    Run External IPMI Standard Command    chassis power status
    [Return]    ${output}

Check Chassis Power Status Util ON
    ${output}=    Run External IPMI Standard Command    chassis power status
    Should Contain    ${output}    Chassis Power is on

Check Chassis Power Status Util OFF
    ${output}=    Run External IPMI Standard Command    chassis power status
    Should Contain    ${output}    Chassis Power is off

Open Connection And Log In
    Open Connection    ${OS_HOST}
    Login    ${OS_USERNAME}    ${OS_PASSWORD}

IPMI Command Power ON
    Run External IPMI Standard Command    chassis power on
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util ON

IPMI Command Power OFF
    Run External IPMI Standard Command    chassis power off
    Wait Until Keyword Succeeds    ${POWERSTATUS_CHECK_TIMEOUT}    ${POWERSTATUS_CHECK_RETRY_TIMEOUT}    Check Chassis Power Status Util OFF
