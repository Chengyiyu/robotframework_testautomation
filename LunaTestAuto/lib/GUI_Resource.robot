*** Settings ***
Library           XvfbRobot
Library           Selenium2Library
Resource          ../Data/resource_variables.robot

*** Variables ***
${webgui_url}     https://${LUNA_BMCIP}

*** Keywords ***
Open Browser With URL
    [Arguments]    ${URL}    ${browser}=${GUI_BROWSER}    ${mode}=${GUI_MODE}
    [Documentation]    Open browser with specified URL and returns browser id.
    # Description of argument(s):
    # URL    Openbmc GUI URL to be open
    #    (e.g. https://openbmc-test.mybluemix.net/#/login).
    # browser    Browser used to open above URL
    #    (e.g. gc for google chrome, ff for firefox).
    # mode    Browser opening mode(e.g. headless, header).
    ${browser_ID}=    Run Keyword If    '${mode}' == 'headless'    Launch Headless Browser    ${URL}    ${browser}
    ...    ELSE    Open Browser    ${URL}    ${browser}
    [Return]    ${browser_ID}

Launch Headless Browser
    [Arguments]    ${URL}=${webgui_url}    ${browser}=${GUI_BROWSER}
    [Documentation]    Launch headless browser.
    # Description of argument(s):
    # URL    Openbmc GUI URL to be open
    #    (e.g. https://openbmc-test.mybluemix.net/#/login).
    # browser    Browser to open given URL in headless way
    #    (e.g. gc for google chrome, ff for firefox).
    Start Virtual Display
    ${browser_ID}=    Open Browser    ${URL}
    Set Window Size    1920    1080
    [Return]    ${browser_ID}

Launch Header Browser
    [Arguments]    ${browser_type}=${GUI_BROWSER}
    [Documentation]    Open the browser with the URL and
    ...    login on windows platform.
    # Description of argument(s):
    # browser_type    Type of browser (e.g. "firefox", "chrome", etc.).
    ${BROWSER_ID}=    Open Browser    ${webgui_url}    ${browser_type}
    Maximize Browser Window
    Set Global Variable    ${BROWSER_ID}

Launch Browser And Login GUI
    [Arguments]    ${username}=${LUNA_USERNAME}    ${password}=${LUNA_PASSWORD}
    [Documentation]    Launch browser and login to NVDIA GUI.
    Open Browser With URL    ${webgui_url}
    Login GUI    ${username}    ${password}

Login GUI
    [Arguments]    ${username}    ${password}
    [Documentation]    Login to NVDIA GUI.
    # Description of argument(s):
    # username    The username to be used for login.
    # password    The password to be used for login.
    Go To    ${webgui_url}
    Wait Until Element Is Enabled    ${xpath_textbox_username}    timeout=60s
    Input Text    ${xpath_textbox_username}    ${username}
    Input Password    ${xpath_textbox_password}    ${password}
    Click Element    ${xpath_login_button}

Suite Setup Execution
    [Documentation]    Do test suite setup tasks.
    Launch Browser And Login GUI
    Wait Until Keyword Succeeds    30 sec    5 sec    Location Should Contain    dashboard
    Wait Until Element Is Not Visible    ${xpath_processing_image}    timeout=300s
