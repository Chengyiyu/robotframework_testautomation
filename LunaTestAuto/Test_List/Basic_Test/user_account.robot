*** Settings ***
Suite Setup
Resource          ../../Data/resource_variables.robot
Resource          ../../lib/GUI_Resource.robot
Resource          ../../lib/ipmi_client.robot
Library           SSHLibrary

*** Test Cases ***
ipmitool create account
    [Documentation]    Check if User ID 3 to 10 can be successfully created. Meanwhile, those account can send IPMI command for each privilege level.
    ...    Execute Command And Verify Output
    Open Connection And Log In
    FOR    ${user_id}    IN RANGE    3    11
        Execute Command    ipmitool user set name ${user_id} Leon${user_id}
        Execute Command    ipmitool user set password ${user_id} dgxluna.Leon${user_id}
        Execute Command    ipmitool user enable ${user_id}
        Execute Command    ipmitool channel setaccess 1 ${user_id} callin=on ipmi=on link=on privilege=4
        Launch Browser And Login GUI    Leon${user_id}    dgxluna.Leon${user_id}
        Wait Until Keyword Succeeds    30 sec    5 sec    Location Should Contain    dashboard
        Close All Browsers
    END
    ${output}=    Run External IPMI Raw Command    0x06 0x01 -L administrator
    ${output}=    Run External IPMI Raw Command    0x06 0x01 -L operator
    ${output}=    Run External IPMI Raw Command    0x06 0x01 -L user
    Close All Connections

error password
    [Documentation]    1. Login BMC WebUI with incorrect password 5 times.
    ...    2. "admin" user should be locked for channel number 1.
    ...    3. Accessed 6th time with correct password BMC will show user is locked.
    ...    4. Try WebUI login after 10 minutes, it works fine.
    Launch Headless Browser
    FOR    ${error_time}    IN RANGE    6
        Login GUI    admin    errorpassword${error_time}
    END
    Close All Browsers

*** Keywords ***
Open Connection And Log In
    Open Connection    ${OS_HOST}
    Login    ${OS_USERNAME}    ${OS_PASSWORD}
