*** Settings ***
Resource          ../../lib/GUI_Resource.robot
Resource          ../../lib/ipmi_client.robot
Resource          ../../Data/resource_variables.robot
Resource          ../../Data/Sensers.robot
Library           Selenium2Library
Library           Process
Library           Collections
Library           String

*** Test Cases ***
Webpage Case
    [Documentation]    ADC, CPU temp, DIMM zone temp, voltages and fan speed can be displayed correctly on Web page
    [Tags]    sensor_readings
    Suite Setup Execution
    Click Element    ${xpath_sensors_button}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    FOR    ${sensor_name}    IN    @{sensers_name}
        Page Should Contain    ${sensor_name}
    END
    Close All Browsers

Ipmitool Case
    [Documentation]    ADC, CPU temp, DIMM zone temp, voltages and fan speed can be displayed correctly through ipmitool
    [Tags]    sensor_readings
    # Example of SDR info command output:
    # SDR Version    : 0x51
    # Record Count    : 216
    # Free Space    : unspecifie
    # Get sensor count from "sdr elist " command output.
    ${resp}=    Get Sensor List
    FOR    ${sensor_name}    IN    @{sensers_name}
        Should Contain    ${resp}    ${sensor_name}
    END

*** Keywords ***
Get Sensor List
    [Documentation]    Get sensors count using "sdr elist all" command.
    # Example of "sdr elist all" command output:
    # BootProgress    | 03h | ok    | 34.2 |
    # OperatingSystemS | 05h | ok    | 35.1 |
    # AttemptsLeft    | 07h | ok    | 34.1 |
    # occ0    | 08h | ok    | 210.1 | Device Disabled
    # occ1    | 09h | ok    | 210.2 | Device Disabled
    # p0_core0_temp    | 11h | ns    |    3.1 | Disabled
    # cpu0_core0    | 12h | ok    | 208.1 | Presence detected
    # p0_core1_temp    | 14h | ns    |    3.2 | Disabled
    # cpu0_core1    | 15h | ok    | 208.2 | Presence detected
    # p0_core2_temp    | 17h | ns    |    3.3 | Disabled
    # ..
    # ..
    # ..
    # ..
    # ..
    # ..
    # fan3    | 00h | ns    | 29.4 | Logical FRU @35h
    # bmc    | 00h | ns    |    6.1 | Logical FRU @3Ch
    # ethernet    | 00h | ns    |    1.1 | Logical FRU @46h
    ${output}=    Run External IPMI Standard Command    sdr elist
    [Return]    ${output}
