*** Settings ***
Library     RPA.Browser.Selenium
Library     RPA.Excel.Files
Library     RPA.HTTP


*** Tasks ***
Solve The Challenge
    [Documentation]    Solve the first challenge at rpachallenge.com, which
    ...    consists of filling a form that randomly rearranges itself,
    ...    with data taken from a provided Microsoft Excel file.
    Open Available Browser    https://rpachallenge.com/
    Download    https://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=${TRUE}
    Click Button    Start
    ${people}=    Read People From Excel File
    FOR    ${person}    IN    @{people}
        Fill And Submit Form    ${person}
    END
    Capture Element Screenshot    alias:Congratulations
    Sleep    2 seconds


*** Keywords ***
Read People From Excel File
    Open Workbook    challenge.xlsx
    ${table}=    Read Worksheet As Table    header=${TRUE}
    Close Workbook
    RETURN    ${table}

Fill And Submit Form
    [Arguments]    ${person}
    Input Text    alias:First Name    ${person}[First Name]
    Input Text    alias:Last Name    ${person}[Last Name]
    Input Text    alias:Company Name    ${person}[Company Name]
    Input Text    alias:Role in Company    ${person}[Role in Company]
    Input Text    alias:Address    ${person}[Address]
    Input Text    alias:Email    ${person}[Email]
    Input Text    alias:Phone Number    ${person}[Phone Number]
    Click Button    Submit
