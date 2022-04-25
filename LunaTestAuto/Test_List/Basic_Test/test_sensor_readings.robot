*** Settings ***
Suite Setup       Prepare Sensors Data
Resource          ../../lib/GUI_Resource.robot
Resource          ../../lib/ipmi_client.robot
Resource          ../../Data/resource_variables.robot
Library           Selenium2Library
Library           Process
Library           Collections
Library           String
Library           ExcelLibrary

*** Variables ***
${path_excel}     ${CURDIR}/../../Data/Sensors.xlsx
@{sensor_names}    @{EMPTY}

*** Test Cases ***
Verify Sensors Displayed On Webpage
    [Documentation]    ADC, CPU temp, DIMM zone temp, voltages and fan speed can be displayed correctly on Web page
    [Tags]    Verify Sensors Displayed On Webpage
    Suite Setup Execution
    GO TO    ${sensors_url}
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=${BROWSER_PROCESSING_TIMEOUT}
    FOR    ${sensor_name}    IN    @{sensor_names}
        Page Should Contain    ${sensor_name}
    END
    Close All Browsers

Verify Sensors Displayed On Ipmitool
    [Documentation]    ADC, CPU temp, DIMM zone temp, voltages and fan speed can be displayed correctly through ipmitool
    [Tags]    Verify Sensors Displayed On Ipmitool
    # Example of SDR info command output:
    # SDR Version    : 0x51
    # Record Count    : 216
    # Free Space    : unspecifie
    # Get sensor count from "sdr elist " command output.
    ${resp}=    Get Sensor List
    FOR    ${sensor_name}    IN    @{sensor_names}
        Should Contain    ${resp}    ${sensor_name}
    END

*** Keywords ***
Get Sensor List
    [Documentation]    Get sensors count using "sdr elist" command.
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

Prepare Sensors Data
    [Documentation]    JUST TEST
    Open Excel Document    filename=${path_excel}    doc_id=doc1
    Get Sheet    Sensor Table
    @{sensor_names} =    Read Excel Column    1
    Remove From List    ${sensor_names}    0
    Remove From List    ${sensor_names}    0
    Set Suite Variable    @{sensor_names}    @{sensor_names}
    Close All Excel Documents
