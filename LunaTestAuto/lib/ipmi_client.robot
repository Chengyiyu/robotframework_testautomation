*** Settings ***
Resource          ../Data/resource_variables.robot
Resource          connection_client.robot
Library           String
Library           var_funcs.py
Library           ipmi_client.py

*** Variables ***
${netfnByte}      ${EMPTY}
${cmdByte}        ${EMPTY}
${arrayByte}      array:byte:
${IPMI_USER_OPTIONS}    ${EMPTY}
${HOST}           -H
${RAW}            raw

*** Keywords ***
Run External IPMI Standard Command
    [Arguments]    ${command}    ${fail_on_err}=${1}    ${expected_rc}=${0}    &{options}
    [Documentation]    Run the external IPMI standard command.
    # Description of argument(s):
    # command    The IPMI command string to be executed
    #    (e.g. "power status").    Note that if
    #    ${IPMI_USER_OPTIONS} has a value (e.g.
    #    "-vvv"), it will be pre-pended to this
    #    command string.
    # fail_on_err    Fail if the IPMI command execution fails.
    # expected_rc    The expected return code from the ipmi
    #    command (e.g. ${0}, ${1}, etc.).
    # options    Additional ipmitool command options (e.g.
    #    -C=3, -I=lanplus, etc.)o
    ${command_string}=    Process IPMI User Options    ${command}
    ${ipmi_cmd}=    Create IPMI Ext Command String    ${command_string}    &{options}
    #Qprint Issuing    ${ipmi_cmd}
    ${rc}    ${output}=    Run And Return RC and Output    ${ipmi_cmd}
    Return From Keyword If    ${fail_on_err} == ${0}    ${output}
    Should Be Equal    ${rc}    ${expected_rc}    msg=${output}
    [Return]    ${output}

Run External IPMI Raw Command
    [Arguments]    ${command}    ${fail_on_err}=${1}    &{options}
    [Documentation]    Run the external IPMI raw command.
    # This keyword is a wrapper for 'Run External IPMI Standard Command'. See
    # that keyword's prolog for argument details.    This keyword will pre-pend
    # the word "raw" plus a space to command prior to calling 'Run External
    # IPMI Standard Command'.
    ${output}=    Run External IPMI Standard Command    raw ${command}    ${fail_on_err}    &{options}
    [Return]    ${output}
