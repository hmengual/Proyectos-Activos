*** Settings ***
Documentation       Aplicación Demo, automatización de proceso estándar de SAP: Generación de SOLPED

Library             RPA.PDF
Library             OperatingSystem
Library             String
Library             RPA.Windows
Library             RPA.SAP


*** Variables ***
${pdf_path}         ${CURDIR}\\tmp\\Factura.pdf
${Path_SAPGUI}      C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe
${Conection}        2 - QAS - SAP ERP CALIDAD
${Usuario}          wnd[0]/usr/txtRSYST-BNAME
${Mandante}         wnd[0]/usr/txtRSYST-MANDT
${Password}         wnd[0]/usr/pwdRSYST-BCODE
${PDF_Path2}        wnd[1]/usr/ctxtDY_PATH
${PDF_Nombre}       wnd[1]/usr/ctxtDY_FILENAME
${Header_Detail}
...                 wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:3102/tabsREQ_HEADER_DETAIL/tabpTABREQHDT1/ssubTABSTRIPCONTROL3SUB:SAPLMEGUI:1230/subTEXTS:SAPLMMTE:0100/subEDITOR:SAPLMMTE:0101/cntlTEXT_EDITOR_0101/shellcont/shell
${Tabla}
...                 wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:3212/cntlGRIDCONTROL/shellcont/shell
${Centro_costo}
...                 wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:3303/tabsREQ_ITEM_DETAIL/tabpTABREQDT6/ssubTABSTRIPCONTROL1SUB:SAPLMEVIEWS:1101/subSUB2:SAPLMEACCTVI:0100/subSUB1:SAPLMEACCTVI:1100/subKONTBLOCK:SAPLKACB:1101/ctxtCOBL-KOSTL
${Precio}
...                 wnd[0]/usr/subSUB0:SAPLMEGUI:0015/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:3303/tabsREQ_ITEM_DETAIL/tabpTABREQDT5/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:3320/txtMEREQ3320-PREIS
${Save}             wnd[0]/tbar[0]/btn[11]


*** Tasks ***
Ingresar SOLPED
    SAP GUI LOGIN
    ${Factura}=    Extraer Datos
    Crear SOLPED    ${Factura}
    [Teardown]    No Operation


*** Keywords ***
Extraer Datos
    ${text}=    Get Text From Pdf    ${pdf_path}    details=${FALSE}    trim=${FALSE}
    Create File    output.txt
    FOR    ${page}    IN    @{text.keys()}
        Append To File    output.txt    ${text[${page}]}
    END
    ${InvoiceNumber}=    Get Regexp Matches    ${text}[${1}]    A - .... - ........
    RETURN    ${InvoiceNumber}[0]

SAP GUI LOGIN
    Windows Run    ${Path_SAPGUI}
    Connect To Session
    Open Connection    ${Conection}
    Input Text    ${Mandante}    300
    Input Text    ${Usuario}    test
    Input Password    ${Password}    Mayo2023
    Send Vkey    0

Crear SOLPED
    [Arguments]    ${Texto_factura}
    Run Transaction    ME51N
    Select Context Menu Item    wnd[0]/titl/shellcont/shell    %GOS_TOOLBOX    %GOS_PCATTA_CREA
    Input Text    ${PDF_Path2}    ${CURDIR}\\tmp
    Input Text    ${PDF_Nombre}    Factura.pdf
    Send Vkey    0
    Send Vkey    26
    Input Text    ${Header_Detail}    ${Texto_factura}
    Send Vkey    0
    Send Vkey    27
    Set Cell Value    ${Tabla}    0    MATNR    70099
    Set Cell Value    ${Tabla}    0    NAME1    Aranguren
    Set Cell Value    ${Tabla}    0    KNTTP    K
    Set Cell Value    ${Tabla}    0    MENGE    1
    Set Cell Value    ${Tabla}    0    AFNAM    SISTEMAS
    Send Vkey    0
    Input Text    ${Centro_costo}    cc00032
    Send Vkey    0
    Input Text    ${Precio}    1
    Send Vkey    0
    Click Element    ${Save}

SAP Gui Logout
    Send Vkey    15
    Close Window    SAP Logon 760
