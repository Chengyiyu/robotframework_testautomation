*** Settings ***
Library           Collections
Library           String
Library           RequestsLibrary.RequestsKeywords
Library           OperatingSystem

*** Variables ***
#BMC setting
${PORT}           ${EMPTY}
${LUNA_BMCIP}     10.32.50.50
${LUNA_USERNAME}    admin
${LUNA_PASSWORD}    dgxluna.admin
${LUNA_HOSTNAME}    admin
${LUNA_HOSTPASSWORD}    dgxluna.admin
# Default GUI browser and mode is set to "Firefox" and "headless"
${GUI_BROWSER}    ff
${GUI_MODE}       headless
# IPMITOOL LAN SETTING
${IPMI_USERNAME}    admin
${IPMI_PASSWORD}    dgxluna.admin
# IPMI_COMMAND here is set to "External" by default.
${IPMI_COMMAND}    External
# IPMI chipher default.
${IPMI_CIPHER_LEVEL}    ${17}
# IPMI timeout default.
${IPMI_TIMEOUT}    ${3}
# Log default path for IPMI SOL.
${IPMI_SOL_LOG_FILE}    ${EXECDIR}${/}logs${/}sol_${LUNA_BMCIP}
# User define input SSH and HTTPS related parameters
${SSH_PORT}       22
${HTTPS_PORT}     443
${IPMI_PORT}      623
# OS related parameters.
${OS_HOST}        10.32.50.56
${OS_USERNAME}    root
${OS_PASSWORD}    root
${OS_WAIT_TIMEOUT}    ${15*60}
#Gui xpath setting
${xpath_textbox_username}    xpath=//*[@id='userid']
${xpath_textbox_password}    xpath=//*[@id='password']
${xpath_login_button}    xpath=//*[@id='btn-login']
${xpath_clear_log_button}    xpath=//*[@id='idcl_log']
${xpath_refresh_button}    xpath=//*[@id="main"]/div/header/nav/div/ul/li[4]
${xpath_processing_image}    xpath=//*[@id='processing_image']
${xpath_sensors_button}    xpath=//*[@id='main']/div/div/aside[1]/div/section/ul/li[2]
${xpath_power_control_button}    xpath=//*[@id="main"]/div/div/aside[1]/div/section/ul/li[11]
${xpath_save_button}    xpath=//*[@id="save"]
${xpath_power_off_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[1]/label/div
${xpath_power_on_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[2]/label/div
${xpath_power_cycle_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[3]/label/div
${xpath_power_hard_reset_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[4]/label/div
${xpath_power_ACPI_shutdown_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[5]/label/div
${xpath_IPMI_Event_Log_path}    xpath=//*[@id="main"]/div/div/aside[1]/div/section/ul/li[6]/ul/li[1]
${xpath_IPMI_Event_Log_table_row}    xpath=//*[@id='timeline']/table/tbody/tr
${event_log_ipmi_url}    https://${LUNA_BMCIP}/#logs/event-log
${power_control_url}    https://${LUNA_BMCIP}/#power-control
