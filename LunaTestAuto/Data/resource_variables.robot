*** Settings ***
Library           Collections
Library           String
Library           RequestsLibrary.RequestsKeywords
Library           OperatingSystem

*** Variables ***
#BMC setting
${PORT}           ${EMPTY}
${BMC_IP}         10.32.50.22
${BMC_USERNAME}    admin
${BMC_PASSWORD}    dgxluna.admin
# Default GUI browser and mode is set to "Firefox" and "headless"
${GUI_BROWSER}    ff
${GUI_MODE}       headless
# Default upgrade and downgrade image file name
${BMC_UPGRADE_REVERSION}    17
${BMC_DOWNGRADE_REVERSION}    16
${BMC_UPGRADE_IMAGE}    /home/caesar/Desktop/LunaTestAuto/Data/images/LUNA8BmcFw00.17.04.ima
${BMC_DOWNGRADE_IMAGE}    /home/caesar/Desktop/LunaTestAuto/Data/images/LUNA8BmcFw00.16.12-luna-rel.ima
${BIOS_UPGRADE_IMAGE}    ff
${BIOS_DOWNGRADE_IMAGE}    headless
${FIRMEWARE_RETRY_TIMEOUT}    10s
${FIRMEWARE_TIMEOUT}    20min
${KVM_SESSION_TIMEOUT}    360s
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
${IPMI_SOL_LOG_FILE}    ${EXECDIR}${/}logs${/}sol_${BMC_IP}
# User define input SSH and HTTPS related parameters
${SSH_PORT}       22
${HTTPS_PORT}     443
${IPMI_PORT}      623
# OS related parameters.
${OS_HOST}        10.32.50.24
${OS_USERNAME}    root
${OS_PASSWORD}    root
${OS_WAIT_TIMEOUT}    15min
${OS_WAIT_RETRY_TIMEOUT}    30s
${SSH_CONNECTION_TIMEOUT}    30s
#OS frimware data
${OS_FIRMWARE_DATA_DIRECTORY}    ~/FW_images
${OS_BMC_DOWNGRADE_IMAGE}    LUNA8BmcFw00.16.12-luna-rel.ima
${OS_BMC_UPGRADE_IMAGE}    LUNA8BmcFw00.17.04.ima
${OS_BIOS_DOWNGRADE_IMAGE}    109hpm
${OS_BIOS_UPGRADE_IMAGE}    113hpm
# GUI Loading Timeout Setting
${BROWSER_CONNECTION_TIMEOUT}    30s
${BROWSER_CONNECTION_RETRY_TIMEOUT}    1s
${BROWSER_PROCESSING_TIMEOUT}    300s
${BROWSER_PROCESSING_RETRY_TIMEOUT}    5s
# PowerStatus Loading Timeout Setting
${POWERSTATUS_CHECK_TIMEOUT}    3min
${POWERSTATUS_CHECK_RETRY_TIMEOUT}    5s
#Gui xpath setting
${xpath_textbox_username}    xpath=//*[@id='userid']
${xpath_textbox_password}    xpath=//*[@id='password']
${xpath_login_button}    xpath=//*[@id='btn-login']
${xpath_clear_log_button}    xpath=//*[@id='idcl_log']
${xpath_download_log_button}    xpath=//*[@id='idsave_elist_log']
${xpath_refresh_button}    xpath=//*[@id="main"]/div/header/nav/div/ul/li[4]
${xpath_processing_image}    xpath=//*[@id="processing_layout"]/div
${xpath_power_control_button}    xpath=//*[@id="main"]/div/div/aside[1]/div/section/ul/li[11]
${xpath_save_button}    xpath=//*[@id="save"]
${xpath_event_filters_data}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div[4]/div
${xpath_start_bmc_firmware_update_button}    xpath=//*[@id="start"]
${xpath_start_bios_firmware_update_button}    xpath=//*[@id="proceed"]
${xpath_power_off_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[1]/label/div
${xpath_power_on_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[2]/label/div
${xpath_power_cycle_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[3]/label/div
${xpath_power_hard_reset_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[4]/label/div
${xpath_power_ACPI_shutdown_radio}    xpath=//*[@id="main"]/div/div/aside[2]/div/section[2]/div/div/div[2]/form/div[5]/label/div
${xpath_IPMI_Event_Log_path}    xpath=//*[@id="main"]/div/div/aside[1]/div/section/ul/li[6]/ul/li[1]
${xpath_IPMI_Event_Log_table_row}    xpath=//*[@id='timeline']/table/tbody/tr
${xpath_firmware_checks_button}    xpath=//*[@id="btnFirmwareChecks"]
${xpath_preserve_all_configuration_checkbox}    xpath=//*[@id="idpreserveAll"]
${xpath_upload_firmware_image}    xpath=//*[@id="mainfirmware_image"]
${xpath_launchKVM_button}    xpath=//*[@id="download"]
${sensors_url}    https://${BMC_IP}/#sensors
${event_log_ipmi_url}    https://${BMC_IP}/#logs/event-log
${power_control_url}    https://${BMC_IP}/#power-control
${FW_upgrade_url}    https://${BMC_IP}/#maintenance/firmware_update_wizard
${remote_control_url}    https://${BMC_IP}/#remote_control
${event_filters_url}    https://${BMC_IP}/#settings/pef/event_filters
