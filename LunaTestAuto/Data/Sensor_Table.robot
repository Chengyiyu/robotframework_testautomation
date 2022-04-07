*** Settings ***
Test Template     Run Data Driven Steps
Library           Selenium2Library
Library           DataDriver    Sensors.xlsx    sheet_name=Sensor Table

*** Keywords ***
Run Data Driven Steps
    [Arguments]    ${Sensor Name}
    @{ListExcelData}    Create List    ${Sensor Name}
    [Return]    @{ListExcelData}
