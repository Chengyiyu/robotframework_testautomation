*** Settings ***
Resource          resource_variables.robot
Resource          ../lib/ipmi_client.robot

*** Test Cases ***
TEST OUTPUT
    ${output}    set variable    20 81 00 17 02 bf 47 16 00 00 00 04 00 00 00
    Should Match Regexp    ${output}    ^\\w{2}\\s\\w{2}\\s\\w{2}\\s${BMC_UPGRADE_REVERSION}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}
    ${device_id}=    Run External IPMI Raw Command    0x06 0x01
    Should Match Regexp    ${device_id}    ^\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s${BMC_UPGRADE_REVERSION}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}\\s\\w{2}
