
Sysget, totalWidth, 78
Sysget, totalHeight, 79
Sysget, MonNb, 79

ToolTipX := 3050
ToolTipY := 0

DMS_Lists_DIRNAME := "SDMS"
DMS_Lists_DIR := "\" DMS_Lists_DIRNAME "\"


;============
Initialize_SDMS:
;============



;============================================
InitializesArrays:
;============================================
MenuItemsListFileName := []
MenuItemsListFileNameExt := []
MenuName := []
ItemName := []
NP1_AHKMenuHeader := []
GedAbbr := []
MenuHandlerChooserName := []
MenuHandlerName := []
NP1_IsTerminal := []
NP1_Is_SubOrAc := []
NP1_UseAbbrevInGed := []
NP1_MenuItemsListFileName := []
NP1_MenuItemsListFileNameExt := []
CurrentMenuTable := []
FolderTable := []

;============================================
InitializesGeneralVariables:
;============================================
DebugNameKey := 0
TestFolderKey := 0
DestinationFound := 0
MenuLevel := 0
FinalAction := ""
Recipient := ""
DocType := ""
DOCYEAR := ""
YEAR_menu_OffSetCurrentYear := +1
YEAR_menu_Total_items := 20
DOCMONTH := ""
DOCDAY := ""
DOCRECEPTIONDAYDATE := ""
DATE_YYYYMMDD := ""
DATE_DDMMYYYY := ""
DOCDATE_temp := ""
Periode := ""

DOC_FOLDER_KEY := ""
DOC_NAME_KEY := ""
DMS_DOCFILENAME := ""
; AHKMenuItemName := ""
HEADERCOMPLEMENT := ""
AHKMenuNameCOMPLEMENT := ""
DestinationDir := ""

NP1_TYPE := ""
MENUITEMELASTCAR := ""
LASTLASTLASTCAR := ""
LASTLASTCAR := ""
LASTCAR := ""
TODAYDOCDATEACCEL := "§"
EDITMENUACCEL := "é"
RELOADMENUACCEL := "$"
ESCTHISLISTMENUACCEL := CHR(27)


;============================================
InitializesTableIndexVariables:
;============================================
CL_AHKMenuItemName_ColIndex             := 2
CL_ItemAbbr_ColIndex                    := 3
CL_USE_ItemAbbr_DMSFOLDER_ColIndex      := 4
CL_USE_ItemAbbr_DMSFILENAME_ColIndex    := 5
CL_MenuHandlerName_ColIndex             := 6

NP1_Type_ColIndex                       := 7
NP1_AHKMenuName_ColIndex                := 8
NP1_AHKMenuHeader_ColIndex              := 9
NP1_MenuHandlerName_ColIndex            := 10
NP1_MenuItemsListFileName_ColIndex      := 11
NP1_MenuItemsListFileNameExt_ColIndex   := 12

NP2_Type_ColIndex                       := 13
NP2_MenuHandlerName_ColIndex            := 14
NP2_AHKMenuName_ColIndex                := 15
NP2_MenuHeader_ColIndex                 := 16
NP2_MenuItemsListFileName_ColIndex      := 17
NP2_MenuItemsListFileNameExt_ColIndex   := 18



;============================================
Build_Menu_LP1:
;============================================

CurrentMenu_Items_Max := 0
Accelerator_Index := 0
MenuLine_Index := 0
BB := 0
ascn := 0
; AHKMenuName := CL_AHKMenuName
; AHKMenuHeader := CL_AHKMenuHeader
CL_AHKMenuName :=  AHKMenuName
CL_AHKMenuHeader  := AHKMenuHeader

; msgbox, 4096, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`n CL_AHKMenuHandlerName=%CL_AHKMenuHandlerName% `n CL_AHKMenuName=%CL_AHKMenuName% `n CL_AHKMenuHeader=%CL_AHKMenuHeader%

Menu, %AHKMenuName%, Add, %AHKMenuHeader%, NoAction 
Menu, %AHKMenuName%, Disable, %AHKMenuHeader%
Loop, read, %A_ScriptDir%%DMS_Lists_DIR%%MenuItemsListFileName%.%MenuItemsListFileNameExt%,
{
    Column_Index := 0
    ReadFile_LoopIndex := A_Index
    If (A_Index < 3)
    {
        Continue
    }
    If (A_LoopReadLine != "")
    {
        Accelerator_Index      := Accelerator_Index + 1
        MenuLine_Index         := MenuLine_Index + 1

        LineSegment            := StrSplit(A_LoopReadLine, A_Tab)
        Line_MaxColumns        := LineSegment.MaxIndex()

        Loop, %Line_MaxColumns%
        {
            Column_Index                               := A_Index
            ; builds table readline by readline :
            CurrentMenuTable[MenuLine_Index, Column_Index] := LineSegment[Column_Index]
        }
        CL_AHKMenuItemName         := CurrentMenuTable[MenuLine_Index, CL_AHKMenuItemName_ColIndex]
        CL_AHKMenuHandlerName      := CurrentMenuTable[MenuLine_Index, CL_MenuHandlerName_ColIndex]
        
        ; msgbox, 4096, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`n AHKMenuName=%AHKMenuName% `n`n (AI%Accelerator_Index%-MI%MenuLine_Index%) CL_AHKMenuItemName=%CL_AHKMenuItemName% `n CL_AHKMenuHandlerName=%CL_AHKMenuHandlerName% `n MENUITEMELASTCAR=%MENUITEMELASTCAR%
        
        

        ; GoSub Debug_Menu_LineByLine_Constitution

        If (Accelerator_Index < 10)
        {
            If (CL_AHKMenuItemName = "¦")
            {
                BB := 1
                Accelerator_Index  := Accelerator_Index - 1
                MenuLine_Index     := MenuLine_Index - 1
                Continue
            }
            If (CL_AHKMenuItemName = "|")
            {
                BB := 2
                Accelerator_Index  := Accelerator_Index - 1
                MenuLine_Index     := MenuLine_Index - 1
                Continue
            }
            If (BB = 0)
            {
                ; IfMsgBox No
                ;     return

                ; GoSub Debug_Menu_Line_Constitution_IfAcc_LessThan10
                GoSub MenuItem_AddsLastCar
                Menu, %AHKMenuName%, Add, &%Accelerator_Index% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%
            }
            Else If (BB = 1)
            {
                GoSub MenuItem_AddsLastCar
                Menu, %AHKMenuName%, Add, &%Accelerator_Index% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, +BarBreak
                BB := 0
            }
            Else If (BB = 2)
            {
                Menu, %AHKMenuName%, Add 
                GoSub MenuItem_AddsLastCar
                Menu, %AHKMenuName%, Add, &%Accelerator_Index% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, 
                BB := 0
            }
        }
        Else If Not (Accelerator_Index < 10)
        {
            ascn := 87 + Accelerator_Index
            If (Accelerator_Index < 36)
            {
                car := CHR(ascn)
                If (CL_AHKMenuItemName = "¦")
                {
                    BB := 1
                    ; Menu, %AHKMenuName%, Add, %BB% %CL_AHKMenuItemName% , %CL_AHKMenuHandlerName%, +BarBreak
                    Accelerator_Index  := Accelerator_Index - 1
                    MenuLine_Index     := MenuLine_Index - 1
                    Continue
                }
                If (CL_AHKMenuItemName = "|")
                {
                    BB := 2
                    Accelerator_Index := Accelerator_Index - 1
                    MenuLine_Index    := MenuLine_Index - 1
                    Continue
                }
                If (BB = 0)
                {
                    ; msgbox, 4096, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`n AHKMenuName=%AHKMenuName% `n CL_AHKMenuItemName=%CL_AHKMenuItemName%
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, &%car% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%
                }
                If (BB = 1)
                {
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, &%car% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, +BarBreak
                    BB := 0
                }
                Else If (BB = 2)
                {
                    Menu, %AHKMenuName%, Add 
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, &%car% %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, 
                    BB := 0
                }
            }
            Else If Not (Accelerator_Index < 36)
            {
                If (CL_AHKMenuItemName = "¦")
                {
                    BB := 1
                    ; Menu, %AHKMenuName%, Add, %BB% %CL_AHKMenuItemName% , %CL_AHKMenuHandlerName%, +BarBreak
                    Accelerator_Index  := Accelerator_Index - 1
                    MenuLine_Index     := MenuLine_Index - 1
                    Continue
                }
                If (CL_AHKMenuItemName = "|")
                {
                    BB := 2
                    Accelerator_Index := Accelerator_Index - 1
                    MenuLine_Index    := MenuLine_Index - 1
                    Continue
                }
                If (BB = 0)
                {
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%
                }
                If (BB = 1)
                {
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, +BarBreak
                    BB := 0
                }
                Else If (BB = 2)
                {
                    Menu, %AHKMenuName%, Add 
                    GoSub MenuItem_AddsLastCar
                    Menu, %AHKMenuName%, Add, %CL_AHKMenuItemName%%MENUITEMELASTCAR%, %CL_AHKMenuHandlerName%, 
                    BB := 0
                }
            }

        }
        ; GoSub Debug_Menu_LineByLine_Constitution
    }
}
        ; msgbox, 4096, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n MenuLine_Index=%MenuLine_Index% `n 

GoSub MenuItem_AddsReloadScriptToMenu
GoSub MenuItem_AddsEditCurrentListToMenu
Menu, %AHKMenuName%, Add ; adds_Horiz_separator1:
PutInfosInMenuName = TitleAClass=%TitleAClass% `nCX=%CX%, CY=%CY% `n MX=%MX%, MY=%MY%; TW=%totalWidth%, TH=%totalHeight%
; Msgbox %PutInfosInMenuName%
;menu item tagged nto label by its name
Menu, %AHKMenuName%, Add, %PutInfosInMenuName%,MenuHandler


return




;=====================================
MenuItem_AddsLastCar:
;=====================================
NP1_TYPE := CurrentMenuTable[Accelerator_Index, NP1_Type_ColIndex]
NP1_MenuItemsListFileName := CurrentMenuTable[Accelerator_Index, NP1_MenuItemsListFileName_ColIndex]

LASTLASTLASTCAR := CHR(02) 
LASTLASTCAR := " ="


; IF (Instr(AHKMenuName, "OSMIA") > 0)
; {

;     msgbox, 4097, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`nTitleAClass=%TitleAClass%`n `n
;     , AHKMenuName=%AHKMenuName% `n
;     , `n
;     , NP1_MenuItemsListFileName=%NP1_MenuItemsListFileName% `n 
;     ,  `n 
;     , MenuLine_Index=%MenuLine_Index% `n 
;     , Accelerator_Index=%Accelerator_Index% `n 
;     , CL_AHKMenuItemName=%CL_AHKMenuItemName% `n 
;     , `n 
;     , CL_AHKMenuHandlerName=%CL_AHKMenuHandlerName% `n
;     , `n 
;     , NP1_Type_ColIndex=%NP1_Type_ColIndex% `n 
;     , NP1_TYPE=%NP1_TYPE% `n
;     , `n 
;     , NP1_MenuItemsListFileName_ColIndex=%NP1_MenuItemsListFileName_ColIndex% `n
;     , NP1_MenuItemsListFileName=%NP1_MenuItemsListFileName% `n

; }



If (NP1_TYPE = "sub" or NP1_TYPE = "last" or NP1_TYPE = "input" or NP1_TYPE = "date")
{
    If (NP1_MenuItemsListFileName = "" OR NP1_MenuItemsListFileName = ".")
    {
        msgbox, 4097, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`nTitleAClass=%TitleAClass%`n AHKMenuName=%AHKMenuName% `n NP1_TYPE=%NP1_TYPE% `n NP1_MenuItemsListFileName=%NP1_MenuItemsListFileName% `n Accelerator_Index=%Accelerator_Index% `n A_Index=%A_Index% `n NP1_Type_ColIndex=%NP1_Type_ColIndex% `n MenuItemsListFileName_ColIndex=%MenuItemsListFileName_ColIndex% `n `n Le champ 'NP1_Type(Col%MenuItemsListFileName_ColIndex%)' du fichier %MenuItemsListFileName%.%MenuItemsListFileNameExt% `n contient la valeur:%NP1_TYPE% `n mais il manque des éléments du nom de fichier pour continuer `n`n NP1_MenuItemsListFileName=%NP1_MenuItemsListFileName% `n`n la macro va s'arrêter et ouvrir le fichier pour l'éditer `n 
        IfMsgbox Ok
            GoSub Handle_EditCurrentList
            ; GoSub Handle_ReloadScript
            Exit
            
        IfMsgbox Cancel
            ; GoSub Handle_ReloadScript
        LASTLASTCAR := "0"
    }
    LASTCAR := ">"
    MENUITEMELASTCAR = %LASTLASTLASTCAR%%LASTLASTCAR%%LASTCAR%
}
Else If (NP1_TYPE = "action")
{
    LASTLASTCAR := "-"
    ; LASTLASTCAR := CHR(240)
    LASTCAR := "»"
    MENUITEMELASTCAR = %LASTLASTLASTCAR%%LASTLASTCAR%%LASTCAR%
}
Else If (NP1_TYPE = "" OR NP1_TYPE = ".")
{
    msgbox, 4096, Classement GED-DVP, Script %A_ScriptName%-Ligne %A_LineNumber%-Label %A_ThisLabel%`n`nTitleAClass=%TitleAClass%`n AHKMenuName=%AHKMenuName% `n NP1_TYPE=%NP1_TYPE% `n NP1_MenuItemsListFileName=%NP1_MenuItemsListFileName% `n Accelerator_Index=%Accelerator_Index% `n A_Index=%A_Index% `n NP1_Type_ColIndex=%NP1_Type_ColIndex% `n MenuItemsListFileName_ColIndex=%MenuItemsListFileName_ColIndex% `n `n Le champ No %NP1_Type_ColIndex% (NP1_Type(Col%NP1_Type_ColIndex%))' du fichier %MenuItemsListFileName%.%MenuItemsListFileNameExt% `n contient la valeur: `n %NP1_TYPE% `n CL_ItemAbbr=%CL_ItemAbbr% `n la macro va s'arrêter et ouvrir le fichier pour l'éditer `n 
    GoSub Handle_EditCurrentList
    return
    ; GoSub Handle_ReloadScript
    ; Reload
    ; %A_ScriptDir%%DMS_Lists_DIR%%MenuItemsListFileName%%MenuItemsListFileNameExt%
    Exit
}
Return


;=====================================
MenuItem_AddsReloadScriptToMenu:
;=====================================
Menu, %AHKMenuName%, Add ; adds_Horiz_separator1:
Menu, %AHKMenuName%, Add, &%RELOADMENUACCEL% Reload script, Handle_ReloadScript
Return


;=====================================
MenuItem_AddsEditCurrentListToMenu:
;=====================================
Menu, %AHKMenuName%, Add ; adds_Horiz_separator1:
Menu, %AHKMenuName%, Add, &%EDITMENUACCEL% Edit This list, Handle_EditCurrentList
Return




