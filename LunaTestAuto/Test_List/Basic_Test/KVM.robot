*** Settings ***
Resource          ../../lib/GUI_Resource.robot
Resource          ../../Data/resource_variables.robot
Library           Selenium2Library

*** Test Cases ***
Session Timeout
    [Documentation]    This test case verfies KVM session timeout
    [Tags]    KVM
    Suite Setup Execution
    Go To    ${remote_control_url}
    Wait Until Element Is Not Visible    xpath=//*[@id="processing_layout"]/div    timeout=100s
    Click Element    ${xpath_launchKVM_button}
    sleep    ${KVM_SESSION_TIMEOUT}
    sleep    5s
    ${windownow}=    Switch Window    locator=NEW
    Page Should Contain    KVM Session Timed-out
    Close All Browsers
