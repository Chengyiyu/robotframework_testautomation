*** Settings ***
Library           Selenium2Library
Library           DataDriver    Sensors.xlsx    sheet_name=Sensor Table

*** Test Case ***
TEST EXE
    FOR    ${i}    IN RANGE    ${Sensor Name}
        Log    ${i}
    END
