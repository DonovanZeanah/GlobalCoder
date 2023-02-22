; GUI for TypingAid configuration
; by HugoV / Maniac

LaunchSettings:
if (g_InSettings == true)
{
   return
}
InactivateAll()
Tray:= A_TrayMenu
Tray.Disable("Settings")
g_InSettings := true
ClearAllVars(True)
Menu_OldLearnCount := prefs_LearnCount
; initialize this to make sure the object exists
Menu_ChangedPrefs := Object()

ConstructGui()
; Call "HandleMessage" when script receives WM_SETCURSOR message
OnMessage(g_WM_SETCURSOR, HandleSettingsMessage)
; Call "HandleMessage" when script receives WM_MOUSEMOVE message
OnMessage(g_WM_MOUSEMOVE, HandleSettingsMessage)
; clear and re-initialize variables after constructing the GUI as some controls call the edit flag immediately
Menu_ChangedPrefs := ""
Menu_ChangedPrefs := Object()
Menu_ValueChanged := false
Return

ConstructGui()
{
   global prefs_ArrowKeyMethod, prefs_AutoSpace, prefs_DetectMouseClickMove, prefs_DisabledAutoCompleteKeys, prefs_DoNotLearnStrings
   global helpinfo_ArrowKeyMethod, helpinfo_AutoSpace, helpinfo_DetectMouseClickMove, helpinfo_DisabledAutoCompleteKeys, helpinfo_DoNotLearnStrings
   global prefs_EndWordCharacters, prefs_ForceNewWordCharacters, prefs_LearnCount, prefs_LearnLength, prefs_LearnMode, prefs_Length
   global helpinfo_EndWordCharacters, helpinfo_ForceNewWordCharacters, helpinfo_LearnCount, helpinfo_LearnLength, helpinfo_LearnMode, helpinfo_Length
   global prefs_NoBackSpace, prefs_NumPresses, prefs_SendMethod, prefs_ShowLearnedFirst, prefs_SuppressMatchingWord, prefs_TerminatingCharacters
   global helpinfo_NoBackSpace, helpinfo_NumPresses, helpinfo_SendMethod, helpinfo_ShowLearnedFirst, helpinfo_SuppressMatchingWord, helpinfo_TerminatingCharacters
   global prefs_ExcludeProgramExecutables, prefs_ExcludeProgramTitles, prefs_IncludeProgramExecutables, prefs_IncludeProgramTitles, prefs_HelperWindowProgramExecutables, prefs_HelperWindowProgramTitles
   global helpinfo_ExcludeProgramExecutables, helpinfo_ExcludeProgramTitles, helpinfo_IncludeProgramExecutables, helpinfo_IncludeProgramTitles, helpinfo_HelperWindowProgramExecutables, helpinfo_HelperWindowProgramTitles
   global prefs_ListBoxCharacterWidth, prefs_ListBoxFontFixed, prefs_ListBoxFontOverride, prefs_ListBoxFontSize, prefs_ListBoxMaxWidth, prefs_ListBoxOffset, prefs_ListBoxOpacity, prefs_ListBoxRows
   global helpinfo_ListBoxCharacterWidth, helpinfo_ListBoxFontFixed, helpinfo_ListBoxFontOverride, helpinfo_ListBoxFontSize, helpinfo_ListBoxMaxWidth, helpinfo_ListBoxOffset, helpinfo_ListBoxOpacity, helpinfo_ListBoxRows
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global helpinfo_ListBoxNotDPIAwareProgramExecutables
   global helpinfo_FullHelpString
   global Menu_ArrowKeyMethodOptionsText, Menu_CaseCorrection, Menu_ListBoxOpacityUpDown, Menu_SendMethodOptionsCode, Menu_SendMethodC
   global Menu_CtrlEnter, Menu_CtrlSpace, Menu_Enter, Menu_SingleClick, Menu_NumberKeys, Menu_NumpadEnter, Menu_RightArrow, Menu_Tab
   global g_ScriptTitle
   ; Must be global for colors to function, colors will not function if static
   global Menu_VisitForum

   Menu_CaseCorrection := ""
   Menu_ArrowKeyMethodOptionsText := ""

   MenuFontList:=Writer_enumFonts() ; see note at function for credit

   MenuGuiWidth := "700"
   MenuGuiHeight := "480"
   MenuGuiRows := "8"
   MenuGuiHelpIcon := A_Space . "(?)" . A_Space

   MenuSeparatorX := "10"
   MenuSeparatorY := "8"
   MenuEditIndentX := "10"
   MenuEditIndentY := "20"
   MenuHelpIndentX := "30"
   MenuHelpIndentY := "0"

   MenuRowHeight := (MenuGuiHeight - ((MenuGuiRows +1 ) * MenuSeparatorY ))/MenuGuiRows

   MenuTextMenuRowY := (MenuRowHeight - 6 ) / 3

   MenuTabWidth:=MenuGuiWidth-4
   MenuTabHeight:=MenuGuiHeight-75
   MenuTabHeightEdit:=MenuTabHeight-40

   MenuOneColGroupWidth := MenuGuiWidth - (2 * MenuSeparatorX)
   MenuTwoColGroupWidth := (MenuGuiWidth - (3 * MenuSeparatorX))/2
   MenuThreeColGroupWidth := (MenuGuiWidth - (4 * MenuSeparatorX))/3
   MenuDualThreeColGroupWidth := (MenuThreeColGroupWidth * 2) + MenuSeparatorX

   MenuOneColEditWidth := MenuOneColGroupWidth - (MenuEditIndentX * 2)
   MenuTwoColEditWidth := MenuTwoColGroupWidth - (MenuEditIndentX * 2)
   MenuThreeColEditWidth := MenuThreeColGroupWidth - (MenuEditIndentX * 2)
   MenuOneColEditWidthEdit := MenuOneColEditWidth - 140
   MenuOneColEditButton := MenuOneColEditWidthEdit + 30

   MenuGroup1BoxX := MenuSeparatorX
   MenuGroup1EditX := MenuGroup1BoxX + MenuEditIndentX
   MenuGroup1of1HelpX := MenuGroup1BoxX + MenuOneColGroupWidth - MenuHelpIndentX
   MenuGroup1of2HelpX := MenuGroup1BoxX + MenuTwoColGroupWidth - MenuHelpIndentX
   MenuGroup1of3HelpX := MenuGroup1BoxX + MenuThreeColGroupWidth - MenuHelpIndentX

   MenuGroup2of2BoxX := MenuGroup1BoxX + MenuTwoColGroupWidth + MenuSeparatorX
   MenuGroup2of2EditX := MenuGroup2of2BoxX + MenuEditIndentX
   MenuGroup2of2HelpX := MenuGroup2of2BoxX + MenuTwoColGroupWidth - MenuHelpIndentX

   MenuGroup2of3BoxX := MenuGroup1BoxX + MenuThreeColGroupWidth + MenuSeparatorX
   MenuGroup2of3EditX := MenuGroup2of3BoxX + MenuEditIndentX
   MenuGroup2of3HelpX := MenuGroup2of3BoxX + MenuThreeColGroupWidth - MenuHelpIndentX

   MenuGroup3of3BoxX := MenuGroup2of3BoxX + MenuThreeColGroupWidth + MenuSeparatorX
   MenuGroup3of3EditX := MenuGroup3of3BoxX + MenuEditIndentX
   MenuGroup3of3HelpX := MenuGroup3of3BoxX + MenuThreeColGroupWidth - MenuHelpIndentX

   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui := Gui()
   MenuGui.OnEvent("Close", MenuGuiGuiEscape)
MenuGui.OnEvent("Escape", MenuGuiGuiEscape)
MenuGui.SetFont("s8", "Arial")

   Tab := MenuGui.Add("Tab2", "x2 w" . MenuTabWidth . " h" . MenuTabHeight, ["General Settings", "Wordlist Box", "Programs", "Advanced (Experts Only)", "About && Help", "GlobalCoder"])

   Tab.UseTab(1) ; General Settings

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Learn new words as you type")
   Menu_LearnModeOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_LearnModeOptions := StrReplace(Menu_LearnModeOptions, "|" prefs_LearnMode "|", "|" prefs_LearnMode "||",,, 1)
   Menu_LearnModeOptions := SubStr(Menu_LearnModeOptions, (1)+1)
   ogcDDLprefs_LearnMode := MenuGui.Add("DDL", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_LearnMode", Menu_LearnModeOptions)
   ogcDDLprefs_LearnMode.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_LearnMode := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_LearnMode", MenuGuiHelpIcon)
   ogcTexthelpinfo_LearnMode.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuGui.Add("GroupBox", "x" . MenuGroup2of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Minimum length of word to learn")
   Menu_LearnLengthOptions := "|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_LearnLengthOptions := StrReplace(Menu_LearnLengthOptions, "|" prefs_LearnLength "|", "|" prefs_LearnLength "||",,, 1)
   Menu_LearnLengthOptions := SubStr(Menu_LearnLengthOptions, (1)+1)
   ogcDDLprefs_LearnLength := MenuGui.Add("DDL", "x" . MenuGroup2of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_LearnLength", Menu_LearnLengthOptions)
   ogcDDLprefs_LearnLength.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_LearnLength := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_LearnLength", MenuGuiHelpIcon)
   ogcTexthelpinfo_LearnLength.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Add to wordlist after X times")
   Menu_LearnCountOptions := "|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_LearnCountOptions := StrReplace(Menu_LearnCountOptions, "|" prefs_LearnCount "|", "|" prefs_LearnCount "||",,, 1)
   Menu_LearnCountOptions := SubStr(Menu_LearnCountOptions, (1)+1)
   ogcDDLprefs_LearnCount := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_LearnCount", Menu_LearnCountOptions)
   ogcDDLprefs_LearnCount.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_LearnCount := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_LearnCount", MenuGuiHelpIcon)
   ogcTexthelpinfo_LearnCount.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuTwoColGroupWidth . " h" . MenuRowHeight, "Sub-strings to not learn")
   ogcEditprefs_DoNotLearnStrings := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuTwoColEditWidth . " r1 vprefs_DoNotLearnStrings Password", prefs_DoNotLearnStrings)
   ogcEditprefs_DoNotLearnStrings.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_DoNotLearnStrings := MenuGui.Add("Text", "x" . MenuGroup1of2HelpX . " y" . MenuRowHelpY . " vhelpinfo_DoNotLearnStrings", MenuGuiHelpIcon)
   ogcTexthelpinfo_DoNotLearnStrings.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup2of2BoxX . " y" . MenuRowY . " w" . MenuTwoColGroupWidth . " h" . MenuRowHeight, "Number of presses")
   Menu_NumPressesOptions := "|1|2|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_NumPressesOptions := StrReplace(Menu_NumPressesOptions, "|" prefs_NumPresses "|", "|" prefs_NumPresses "||",,, 1)
   Menu_NumPressesOptions := SubStr(Menu_NumPressesOptions, (1)+1)
   ogcDDLprefs_NumPresses := MenuGui.Add("DDL", "x" . MenuGroup2of2EditX . " y" . MenuRowEditY . " w" . MenuTwoColEditWidth . " r5 vprefs_NumPresses", Menu_NumPressesOptions)
   ogcDDLprefs_NumPresses.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_NumPresses := MenuGui.Add("Text", "x" . MenuGroup2of2HelpX . " y" . MenuRowHelpY . " vhelpinfo_NumPresses", MenuGuiHelpIcon)
   ogcTexthelpinfo_NumPresses.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuDualThreeColGroupWidth . " h" . MenuRowHeight, "Auto Complete Keys")
   ;  E = Ctrl + Enter
   ;  S = Ctrl + Space
   ;  T = Tab
   ;  R = Right Arrow
   ;  N = Number Keys
   ;  U = Enter
   ;  L = Single Click
   ;  M = Numpad Enter
   Menu_CheckedE := "Checked"
   Menu_CheckedS := "Checked"
   Menu_CheckedT := "Checked"
   Menu_CheckedR := "Checked"
   Menu_CheckedN := "Checked"
   Menu_CheckedU := "Checked"
   Menu_CheckedL := "Checked"
   Menu_CheckedM := "Checked"
   Loop Parse, prefs_DisabledAutoCompleteKeys
   {
     If (A_LoopField = "E")
       Menu_CheckedE := ""
     If (A_LoopField = "S")
       Menu_CheckedS := ""
     If (A_LoopField = "T")
       Menu_CheckedT := ""
     If (A_LoopField = "R")
       Menu_CheckedR := ""
     If (A_LoopField = "N")
       Menu_CheckedN := ""
     If (A_LoopField = "U")
       Menu_CheckedU := ""
     If (A_LoopField = "L")
       Menu_CheckedL := ""
     If (A_LoopField = "M")
       Menu_CheckedM := ""
   }

   MenuCheckmarkIndent := MenuTwoColEditWidth/3 + MenuEditIndentX
   ogcCheckboxMenu_CtrlEnter := MenuGui.Add("Checkbox", "x" . MenuGroup1EditX . " yp+" . MenuTextMenuRowY . " vMenu_CtrlEnter  " . Menu_CheckedE, "Ctrl + Enter")
   ogcCheckboxMenu_CtrlEnter.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_Tab := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_Tab  " . Menu_CheckedT, "Tab")
   ogcCheckboxMenu_Tab.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_RightArrow := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_RightArrow  " . Menu_CheckedR, "Right Arrow")
   ogcCheckboxMenu_RightArrow.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_SingleClick := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_SingleClick  " . Menu_CheckedL, "Single Click")
   ogcCheckboxMenu_SingleClick.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_CtrlSpace := MenuGui.Add("Checkbox", "x" . MenuGroup1EditX . " yp+" . MenuTextMenuRowY . " vMenu_CtrlSpace  " . Menu_CheckedS, "Ctrl + Space")
   ogcCheckboxMenu_CtrlSpace.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_NumberKeys := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_NumberKeys  " . Menu_CheckedN, "Number Keys")
   ogcCheckboxMenu_NumberKeys.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_Enter := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_Enter  " . Menu_CheckedU, "Enter")
   ogcCheckboxMenu_Enter.OnEvent("Click", EditValue.Bind("Normal"))
   ogcCheckboxMenu_NumpadEnter := MenuGui.Add("Checkbox", "xp" . MenuCheckmarkIndent . " yp vMenu_NumpadEnter  " . Menu_CheckedM, "Numpad Enter")
   ogcCheckboxMenu_NumpadEnter.OnEvent("Click", EditValue.Bind("Normal"))

   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_DisabledAutoCompleteKeys := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_DisabledAutoCompleteKeys", MenuGuiHelpIcon)
   ogcTexthelpinfo_DisabledAutoCompleteKeys.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Send Method")
   Menu_SendMethodOptionsText := "1 - Default (Type)|2 - Fast (Type)|3 - Slow (Type)|4 - Default (Paste)|5 - Fast (Paste)|6 - Slow (Paste)|7 - Alternate method"
   Menu_SendMethodOptionsCode := "1|2|3|1C|2C|3C|4C"
   Loop Parse, Menu_SendMethodOptionsCode, "|"
   {
     If (prefs_SendMethod = A_LoopField)
       Menu_SendCount:=A_Index
   }

   Loop Parse, Menu_SendMethodOptionsText, "|"
   {
     Menu_SendMethodOptions .= A_LoopField "|"
     If (A_Index = Menu_SendCount)
       Menu_SendMethodOptions .= "|"
   }
   ogcDDLMenu_SendMethodC := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vMenu_SendMethodC  altsubmit", Menu_SendMethodOptions)
   ogcDDLMenu_SendMethodC.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_SendMethod := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_SendMethod", MenuGuiHelpIcon)
   ogcTexthelpinfo_SendMethod.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Case correction")
   Menu_CaseCorrectionOptions := "|On|Off|"
   If (prefs_NoBackSpace = "on")
     Menu_CaseCorrection := "Off"
   Else If (prefs_NoBackSpace = "off")
     Menu_CaseCorrection := "On"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_CaseCorrectionOptions := StrReplace(Menu_CaseCorrectionOptions, "|" Menu_CaseCorrection "|", "|" Menu_CaseCorrection "||",,, 1)
   Menu_CaseCorrectionOptions := SubStr(Menu_CaseCorrectionOptions, (1)+1)
   ogcDDLMenu_CaseCorrection := MenuGui.Add("DDL", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vMenu_CaseCorrection", Menu_CaseCorrectionOptions)
   ogcDDLMenu_CaseCorrection.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_NoBackSpace := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_NoBackSpace", MenuGuiHelpIcon)
   ogcTexthelpinfo_NoBackSpace.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")


   MenuGui.Add("GroupBox", "x" . MenuGroup2of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Monitor mouse clicks")
   Menu_DetectMouseClickMoveOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_DetectMouseClickMoveOptions := StrReplace(Menu_DetectMouseClickMoveOptions, "|" prefs_DetectMouseClickMove "|", "|" prefs_DetectMouseClickMove "||",,, 1)
   Menu_DetectMouseClickMoveOptions := SubStr(Menu_DetectMouseClickMoveOptions, (1)+1)
   ogcDDLprefs_DetectMouseClickMove := MenuGui.Add("DDL", "x" . MenuGroup2of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_DetectMouseClickMove", Menu_DetectMouseClickMoveOptions)
   ogcDDLprefs_DetectMouseClickMove.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_DetectMouseClickMove := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_DetectMouseClickMove", MenuGuiHelpIcon)
   ogcTexthelpinfo_DetectMouseClickMove.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Type space after autocomplete")
   Menu_AutoSpaceOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_AutoSpaceOptions := StrReplace(Menu_AutoSpaceOptions, "|" prefs_AutoSpace "|", "|" prefs_AutoSpace "||",,, 1)
   Menu_AutoSpaceOptions := SubStr(Menu_AutoSpaceOptions, (1)+1)
   ogcDDLprefs_AutoSpace := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_AutoSpace", Menu_AutoSpaceOptions)
   ogcDDLprefs_AutoSpace.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_AutoSpace := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_AutoSpace", MenuGuiHelpIcon)
   ogcTexthelpinfo_AutoSpace.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   Tab.UseTab(2) ; listbox ---------------------------------------------------------


   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup2of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Show wordlist after X characters")
   Menu_LengthOptions := "|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_LengthOptions := StrReplace(Menu_LengthOptions, "|" prefs_Length "|", "|" prefs_Length "||",,, 1)
   Menu_LengthOptions := SubStr(Menu_LengthOptions, (1)+1)
   ogcDDLprefs_Length := MenuGui.Add("DDL", "x" . MenuGroup2of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_Length", Menu_LengthOptions)
   ogcDDLprefs_Length.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_Length := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_Length", MenuGuiHelpIcon)
   ogcTexthelpinfo_Length.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Maximum number of results to show")
   Menu_ListBoxRowsOptions := "|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ListBoxRowsOptions := StrReplace(Menu_ListBoxRowsOptions, "|" prefs_ListBoxRows "|", "|" prefs_ListBoxRows "||",,, 1)
   Menu_ListBoxRowsOptions := SubStr(Menu_ListBoxRowsOptions, (1)+1)
   ogcDDLprefs_ListBoxRows := MenuGui.Add("DDL", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_ListBoxRows", Menu_ListBoxRowsOptions)
   ogcDDLprefs_ListBoxRows.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxRows := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxRows", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxRows.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Show learned words first")
   Menu_ShowLearnedFirstOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ShowLearnedFirstOptions := StrReplace(Menu_ShowLearnedFirstOptions, "|" prefs_ShowLearnedFirst "|", "|" prefs_ShowLearnedFirst "||",,, 1)
   Menu_ShowLearnedFirstOptions := SubStr(Menu_ShowLearnedFirstOptions, (1)+1)
   ogcDDLprefs_ShowLearnedFirst := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " vprefs_ShowLearnedFirst", Menu_ShowLearnedFirstOptions)
   ogcDDLprefs_ShowLearnedFirst.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ShowLearnedFirst := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ShowLearnedFirst", MenuGuiHelpIcon)
   ogcTexthelpinfo_ShowLearnedFirst.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuTwoColGroupWidth . " h" . MenuRowHeight, "Wordlist row highlighting")
   Menu_ArrowKeyMethodOptionsText := "Off - only use the number keys|First - reset selected word to the beginning|LastWord - keep last word selected|LastPosition - keep the last cursor position"
   Loop Parse, Menu_ArrowKeyMethodOptionsText, "|"
   {
     Menu_ArrowKeyMethodOptions .= A_LoopField "|"
     Split := StrSplit(A_LoopField,"-")
      Split[1] := Trim(Split[1])
     If (Split[1] = prefs_ArrowKeyMethod)
     {
       Menu_ArrowKeyMethodOptions .= "|"
     }
   }

   ogcDDLprefs_ArrowKeyMethod := MenuGui.Add("DDL", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuTwoColEditWidth . " r5 vprefs_ArrowKeyMethod  altsubmit", Menu_ArrowKeyMethodOptions)
   ogcDDLprefs_ArrowKeyMethod.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ArrowKeyMethod := MenuGui.Add("Text", "x" . MenuGroup1of2HelpX . " y" . MenuRowHelpY . " vhelpinfo_ArrowKeyMethod", MenuGuiHelpIcon)
   ogcTexthelpinfo_ArrowKeyMethod.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup2of2BoxX . " y" . MenuRowY . " w" . MenuTwoColGroupWidth . " h" . MenuRowHeight, "Suppress matching word")
   Menu_SuppressMatchingWordOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_SuppressMatchingWordOptions := StrReplace(Menu_SuppressMatchingWordOptions, "|" prefs_SuppressMatchingWord "|", "|" prefs_SuppressMatchingWord "||",,, 1)
   Menu_SuppressMatchingWordOptions := SubStr(Menu_SuppressMatchingWordOptions, (1)+1)
   ogcDDLprefs_SuppressMatchingWord := MenuGui.Add("DDL", "x" . MenuGroup2of2EditX . " y" . MenuRowEditY . " w" . MenuTwoColEditWidth . " vprefs_SuppressMatchingWord", Menu_SuppressMatchingWordOptions)
   ogcDDLprefs_SuppressMatchingWord.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_SuppressMatchingWord := MenuGui.Add("Text", "x" . MenuGroup2of2HelpX . " y" . MenuRowHelpY . " vhelpinfo_SuppressMatchingWord", MenuGuiHelpIcon)
   ogcTexthelpinfo_SuppressMatchingWord.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Pixels below cursor override")
   Menu_ListBoxOffsetOptions := "|<Computed>|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ListBoxOffsetOptions := StrReplace(Menu_ListBoxOffsetOptions, "|" prefs_ListBoxOffset "|", "|" prefs_ListBoxOffset "||",,, 1)
   Menu_ListBoxOffsetOptions := SubStr(Menu_ListBoxOffsetOptions, (1)+1)
   ogcDDLprefs_ListBoxOffset := MenuGui.Add("DDL", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_ListBoxOffset", Menu_ListBoxOffsetOptions)
   ogcDDLprefs_ListBoxOffset.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxOffset := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxOffset", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxOffset.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup2of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Fixed width font in list")
   Menu_ListBoxFontFixedOptions := "|On|Off|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ListBoxFontFixedOptions := StrReplace(Menu_ListBoxFontFixedOptions, "|" prefs_ListBoxFontFixed "|", "|" prefs_ListBoxFontFixed "||",,, 1)
   Menu_ListBoxFontFixedOptions := SubStr(Menu_ListBoxFontFixedOptions, (1)+1)
   ogcDDLprefs_ListBoxFontFixed := MenuGui.Add("DDL", "x" . MenuGroup2of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_ListBoxFontFixed", Menu_ListBoxFontFixedOptions)
   ogcDDLprefs_ListBoxFontFixed.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxFontFixed := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxFontFixed", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxFontFixed.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "Font size in list")
   Menu_ListBoxFontSizeOptions := "|8|9|10|11|12|13|14|15|16|17|18|19|20|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ListBoxFontSizeOptions := StrReplace(Menu_ListBoxFontSizeOptions, "|" prefs_ListBoxFontSize "|", "|" prefs_ListBoxFontSize "||",,, 1)
   Menu_ListBoxFontSizeOptions := SubStr(Menu_ListBoxFontSizeOptions, (1)+1)
   ogcDDLprefs_ListBoxFontSize := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_ListBoxFontSize", Menu_ListBoxFontSizeOptions)
   ogcDDLprefs_ListBoxFontSize.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxFontSize := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxFontSize", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxFontSize.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "List opacity")
   ogcEditprefs_ListBoxOpacity := MenuGui.Add("Edit", "xp+10 yp+20 w" . MenuThreeColEditWidth . " vprefs_ListBoxOpacity", prefs_ListBoxOpacity)
   ogcEditprefs_ListBoxOpacity.OnEvent("Change", EditValue.Bind("Change"))
   ogcMenu_ListBoxOpacityUpDown := MenuGui.Add("UpDown", "xp+10 yp+20 w" . MenuThreeColEditWidth . " vMenu_ListBoxOpacityUpDown Range0-255", prefs_ListBoxOpacity)
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxOpacity := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxOpacity", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxOpacity.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup2of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "List character width override")
   Menu_ListBoxCharacterWidthOptions := "|<Computed>|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   Menu_ListBoxCharacterWidthOptions := StrReplace(Menu_ListBoxCharacterWidthOptions, "|" prefs_ListBoxCharacterWidth "|", "|" prefs_ListBoxCharacterWidth "||",,, 1)
   Menu_ListBoxCharacterWidthOptions := SubStr(Menu_ListBoxCharacterWidthOptions, (1)+1)
   ogcDDLprefs_ListBoxCharacterWidth := MenuGui.Add("DDL", "x" . MenuGroup2of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r5 vprefs_ListBoxCharacterWidth", Menu_ListBoxCharacterWidthOptions)
   ogcDDLprefs_ListBoxCharacterWidth.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxCharacterWidth := MenuGui.Add("Text", "x" . MenuGroup2of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxCharacterWidth", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxCharacterWidth.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuGui.Add("GroupBox", "x" . MenuGroup3of3BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "List font")
   MenuFontList := Sort(MenuFontList, "D|")
   MenuFontList := "|<Default>|" . MenuFontList
   If (MenuListBoxFont = "") or (MenuListBoxFont = " ")
   {
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      MenuFontList := StrReplace(MenuFontList, "|" prefs_ListBoxFontOverride "|", "|" prefs_ListBoxFontOverride "||",,, 1)
   }
   ; remove the extra leading "|" we added for searching
   MenuFontList := SubStr(MenuFontList, (1)+1)
   ogcDDLprefs_ListBoxFontOverride := MenuGui.Add("DDL", "x" . MenuGroup3of3EditX . " y" . MenuRowEditY . " w" . MenuThreeColEditWidth . " r10 w200 vprefs_ListBoxFontOverride", MenuFontList)
   ogcDDLprefs_ListBoxFontOverride.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxFontOverride := MenuGui.Add("Text", "x" . MenuGroup3of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxFontOverride", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxFontOverride.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuThreeColGroupWidth . " h" . MenuRowHeight, "List max width in pixels")
   ogcEditprefs_ListBoxMaxWidth := MenuGui.Add("Edit", "xp+10 yp+20 w" . MenuThreeColEditWidth . " vprefs_ListBoxMaxWidth", prefs_ListBoxMaxWidth)
   ogcEditprefs_ListBoxMaxWidth.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxMaxWidth := MenuGui.Add("Text", "x" . MenuGroup1of3HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxMaxWidth", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxMaxWidth.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Processes which are not DPI Aware")
   ogcEditprefs_ListBoxNotDPIAwareProgramExecutables := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_ListBoxNotDPIAwareProgramExecutables", prefs_ListBoxNotDPIAwareProgramExecutables)
   ogcEditprefs_ListBoxNotDPIAwareProgramExecutables.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetNotDPIAwareProcess.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ListBoxNotDPIAwareProgramExecutables := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_ListBoxNotDPIAwareProgramExecutables", MenuGuiHelpIcon)
   ogcTexthelpinfo_ListBoxNotDPIAwareProgramExecutables.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   Tab.UseTab(3) ; Programs ---------------------------------------------------------


   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Window titles you want " . g_ScriptTitle . " enabled for")
   ogcEditprefs_IncludeProgramTitles := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_IncludeProgramTitles", prefs_IncludeProgramTitles)
   ogcEditprefs_IncludeProgramTitles.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetEnableTitles.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_IncludeProgramTitles := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_IncludeProgramTitles", MenuGuiHelpIcon)
   ogcTexthelpinfo_IncludeProgramTitles.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Window titles you want " . g_ScriptTitle . " disabled for")
   ogcEditprefs_ExcludeProgramTitles := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_ExcludeProgramTitles", prefs_ExcludeProgramTitles)
   ogcEditprefs_ExcludeProgramTitles.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetDisableTitles.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ExcludeProgramTitles := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_ExcludeProgramTitles", MenuGuiHelpIcon)
   ogcTexthelpinfo_ExcludeProgramTitles.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Processes you want " . g_ScriptTitle . " enabled for")
   ogcEditprefs_IncludeProgramExecutables := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_IncludeProgramExecutables", prefs_IncludeProgramExecutables)
   ogcEditprefs_IncludeProgramExecutables.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetEnableProcess.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_IncludeProgramExecutables := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_IncludeProgramExecutables", MenuGuiHelpIcon)
   ogcTexthelpinfo_IncludeProgramExecutables.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Processes you want " . g_ScriptTitle . " disabled for")
   ogcEditprefs_ExcludeProgramExecutables := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_ExcludeProgramExecutables", prefs_ExcludeProgramExecutables)
   ogcEditprefs_ExcludeProgramExecutables.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetDisableProcess.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ExcludeProgramExecutables := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_ExcludeProgramExecutables", MenuGuiHelpIcon)
   ogcTexthelpinfo_ExcludeProgramExecutables.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   ;HelperWindowProgramTitles

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Window titles you want the helper window enabled for")
   ogcEditprefs_HelperWindowProgramTitles := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_HelperWindowProgramTitles", prefs_HelperWindowProgramTitles)
   ogcEditprefs_HelperWindowProgramTitles.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetHelpTitles.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_HelperWindowProgramTitles := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_HelperWindowProgramTitles", MenuGuiHelpIcon)
   ogcTexthelpinfo_HelperWindowProgramTitles.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   ;HelperWindowProgramExecutables

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Processes you want the helper window enabled for")
   ogcEditprefs_HelperWindowProgramExecutables := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidthEdit . " r1 vprefs_HelperWindowProgramExecutables", prefs_HelperWindowProgramExecutables)
   ogcEditprefs_HelperWindowProgramExecutables.OnEvent("Change", EditValue.Bind("Change"))
   ogcButtonEdit := MenuGui.Add("Button", "x" . MenuOneColEditButton . " yp w130", "Edit")
   ogcButtonEdit.OnEvent("Click", SetHelpProcess.Bind("Normal"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_HelperWindowProgramExecutables := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_HelperWindowProgramExecutables", MenuGuiHelpIcon)
   ogcTexthelpinfo_HelperWindowProgramExecutables.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")



   Tab.UseTab(4) ; advanced  -------------------------------------------------------------------------

   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Terminating Characters (see http://www.autohotkey.com/docs/KeyList.htm)")
   ogcEditprefs_TerminatingCharacters := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidth . " r1 vprefs_TerminatingCharacters", prefs_TerminatingCharacters)
   ogcEditprefs_TerminatingCharacters.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_TerminatingCharacters := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_TerminatingCharacters", MenuGuiHelpIcon)
   ogcTexthelpinfo_TerminatingCharacters.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "Force New Word Characters (comma separated)")
   ogcEditprefs_ForceNewWordCharacters := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidth . " r1 vprefs_ForceNewWordCharacters", prefs_ForceNewWordCharacters)
   ogcEditprefs_ForceNewWordCharacters.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_ForceNewWordCharacters := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_ForceNewWordCharacters", MenuGuiHelpIcon)
   ogcTexthelpinfo_ForceNewWordCharacters.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuRowHeight, "End Word Characters (comma separated)")
   ogcEditprefs_EndWordCharacters := MenuGui.Add("Edit", "x" . MenuGroup1EditX . " y" . MenuRowEditY . " w" . MenuOneColEditWidth . " r1 vprefs_EndWordCharacters", prefs_EndWordCharacters)
   ogcEditprefs_EndWordCharacters.OnEvent("Change", EditValue.Bind("Change"))
   MenuGui.SetFont("cGreen")
   ogcTexthelpinfo_EndWordCharacters := MenuGui.Add("Text", "x" . MenuGroup1of1HelpX . " y" . MenuRowHelpY . " vhelpinfo_EndWordCharacters", MenuGuiHelpIcon)
   ogcTexthelpinfo_EndWordCharacters.OnEvent("Click", HelpMe.Bind("Normal"))
   MenuGui.SetFont("cBlack")



   Tab.UseTab(5) ; about & help --------------------------------------------

   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   helpinfo_Intro := "
   (
%g_ScriptTitle% is a simple, compact, and handy auto-completion utility.

It is customizable enough to be useful for regular typing and for programming.

Features:
As you type your word, up to 10 (or as defined in Settings) matches will appear in a drop-down dialog, numbered 1 - 0 (10th). To choose the match you want just hit the associated number on your keyboard (numpad does not work). Alternatively you can select an item from the drop-down using the Up/Down arrows. You can define a fixed position for the drop-down dialog to appear by hitting Ctrl-Shift-H to open a small helper window, or by specifying a list of programs in the preferences file. Please note that in Firefox, Thunderbird, and certain other programs you will probably need to open the helper window due to issues detecting the caret position.

Words should be stored in a file named 'Wordlist.txt' which should be located in the script directory. These words may be commented out by prefixing with a semicolon or simply removed or added. Words may include terminating characters (such as space), but you must select the word before typing the terminating character.

In addition to being able to use the number keys to select a word, you can select words from the drop-down via the Up/Down arrows. Hitting Up on the first item will bring you to the last and hitting Down on the last item will bring you to the first. Hitting Page Up will bring you up 10 items, or to the first item. Hitting Page Down will bring you down 10 items, or to the last item. You can hit Tab, Right Arrow, Ctrl-Space, or Ctrl-Enter to autocomplete the selected word. This feature can be disabled or have some of its behavior modified via Settings.

The script will learn words as you type them if "Learn new words as you type" is set to On in Settings. If you type a word more than 5 times (or as defined in "Minimum length of word to learn") in a single session the word will be permanently added to the list of learned words. Learned words will always appear below predefined words, but will be ranked and ordered among other learned words based on the frequency you type them. You can permanently learn a word by highlighting a word and hitting Ctrl-Shift-C (this works even if "Learn new words as you type" is set to Off). You may use Ctrl-Shift-Del to remove the currently selected Learned Word.
Learned words are stored in the WordlistLearned.db sqlite3 database. Learned words are backed up in WordlistLearned.txt. To modify the list of Learned words manually, delete the WordlistLearned.db database, then manually edit the WordlistLearned.txt file. On the next launch of the script, the WordlistLearned.db database will be rebuilt.

Word descriptions can be added to 'Wordlist.txt' that will appear in the wordlist next to the word. These descriptions should be in the form of <word>|d|<description>, e.g., Tylenol|d|Pain Reliever. This could be used for spelling replacements, text expansion, or translation aids. Multiple replacements can be defined for a word (put each on a separate line). Descriptions can be added to each word as well.

Word replacements can be added to 'Wordlist.txt' that will appear in the wordlist next to the word. When the word is chosen, it will be backspaced out and replaced with the new word. These replacements should be in the form of <word>|r|<description>, e.g., fire|r|fuego. This could be used for things like definitions, translation aids, or function arguments. When Fixed Width fonts are used in the wordlist, the description columns will be tabbed evenly so they line up.

When Settings are changed, the script will automatically create a file named Preferences.ini in the script directory. This file allows for sharing settings between users. Users are encouraged to only edit settings by using the Settings window.
To allow for distribution of standardized preferences, a Defaults.ini may be distributed with the same format as Preferences.ini. If the Defaults.ini is present, this will override the hardcoded defaults in the script. A user may override the Defaults.ini by changing settings in the Settings window.

Customizable features include (see also detailed description below)

   * Enable or disable learning mode.
   * Number of characters a word needs to have in order to be learned.
   * Number of times you must type a word before it is permanently learned.
   * Number of items to show in the list at once.
   * Number of characters before the list of words appears.
   * Change the method used to send the word to the screen.
   * Enable, disable, or customize the arrow key's functionality.
   * Disable certain keys for autocompleting a word selected via the arrow keys.
   * Change whether the script simply completes or actually replaces the word (capitalization change based on the wordlist file).
   * Enable or disable the resetting of the Wordlist Box on a mouseclick.
   * Change whether a space should be automatically added after the autocompleted word or not.
   * List of strings which will prevent any word which contains one of these strings from being learned.
   * Change whether the typed word should appear in the word list or not.
   * Number of pixels below the caret to display the Wordlist Box.
   * Wordlist Box Default Font of fixed (Courier New) or variable (Tahoma) width.
   * Wordlist Box Font Size.
   * Wordlist Box Opacity setting to set the transparency of the List Box.
   * Wordlist Box Character Width to override the computed character width.
   * Wordlist Box Default Font override.
   * List of programs for which you want %g_ScriptTitle% enabled.
   * List of programs for which you do not want %g_ScriptTitle% enabled.
   * List of programs for which you want the Helper Window to automatically open.
   * List of characters which terminate a word.
   * List of characters which terminate a word and start a new word.
   * Number of times you must press a number hotkey to select the associated word (options are 1 and 2, 2 is buggy).

Unicode Support:
Full support for UTF-8 character set.
   )"

   helpinfo_HelpText := helpinfo_Intro . "`r`n`r`n" . helpinfo_FullHelpString

   Loop Parse, helpinfo_HelpText, "`n", "`r"
   {
     IF ( SubStr(A_LoopField, 1, 1) = ";")
     {
       helpinfo_ModHelpText .= SubStr(A_LoopField, 2) . "`r`n"
     } else
     {
       helpinfo_ModHelpText .= A_LoopField . "`r`n"
     }
   }

   MenuGui.Add("Edit", "ReadOnly x" . MenuGroup1BoxX . " y" . MenuRowY . " w" . MenuOneColGroupWidth . " h" . MenuTabHeightEdit, helpinfo_ModHelpText)

   helpinfo_ModHelpText := ""
   helpinfo_HelpText := ""
   helpinfo_Intro := ""

   Tab.UseTab()

   MenuRowY := MenuTabHeight+15
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowThreeButtonWidth := (MenuTwoColGroupWidth - (4 * MenuEditIndentX))/3
   MenuRowThreeButtonNext := MenuEditIndentX + MenuRowThreeButtonWidth

   MenuGui.Add("GroupBox", "x" . MenuGroup1BoxX . "           y" . MenuRowY . "     w" . MenuTwoColGroupWidth . " h50", "Configuration")
   ogcButtonSaveClose := MenuGui.Add("Button", "x" . MenuGroup1EditX . "          y" . MenuRowEditY . " w" . MenuRowThreeButtonWidth, "Save && Close")
   ogcButtonSaveClose.OnEvent("Click", Save.Bind("Normal"))
   ogcButtonRestoredefault := MenuGui.Add("Button", "xp+" . MenuRowThreeButtonNext . " yp          w" . MenuRowThreeButtonWidth, "Restore default")
   ogcButtonRestoredefault.OnEvent("Click", Restore.Bind("Normal"))
   ogcButtonCancel := MenuGui.Add("Button", "xp+" . MenuRowThreeButtonNext . " yp          w" . MenuRowThreeButtonWidth, "Cancel")
   ogcButtonCancel.OnEvent("Click", MenuGuiGuiEscape.Bind("Normal"))

   if (g_ScriptTitle == "TypingAid")
   {
      MenuGui.SetFont("cBlack bold")
      MenuGui.Add("Text", "x" . MenuGroup2of2EditX . " Yp-10", g_ScriptTitle)
      MenuGui.SetFont("cBlack normal")

      MenuGui.Add("Text", "xp+60 Yp", "is free software, support forum at")
      MenuGui.SetFont("cGreen")
      ;the vMenu_VisitForum variable is necessary for the link highlighting
      ogcTextMenu_VisitForum := MenuGui.Add("Text", "x" . MenuGroup2of2EditX . " Yp+" . MenuTextMenuRowY . " vMenu_VisitForum", "www.autohotkey.com (click here)")
      ogcTextMenu_VisitForum.OnEvent("Click", VisitForum.Bind("Normal"))
      MenuGui.SetFont("cBlack")
   }

   Menugui.Opt("+OwnDialogs")
   MenuGui.Title :=  . " Settings"
   MenuGui.Show("h" . MenuGuiHeight . " w" . MenuGuiWidth)
   .OnEvent("Change", _ScriptTitle.Bind("Change"))
   Return
}

SetNotDPIAwareProcess(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_ListBoxNotDPIAwareProgramExecutables",1)
Return
} ; V1toV2: Added Bracket before label

SetEnableTitles(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_IncludeProgramTitles",0)
Return
} ; V1toV2: Added Bracket before label

SetDisableTitles(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_ExcludeProgramTitles",0)
Return
} ; V1toV2: Added Bracket before label

SetEnableProcess(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_IncludeProgramExecutables",1)
Return
} ; V1toV2: Added Bracket before label

SetDisableProcess(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_ExcludeProgramExecutables",1)
Return
} ; V1toV2: Added Bracket before label

SetHelpTitles(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_HelperWindowProgramTitles",0)
Return
} ; V1toV2: Added Bracket before label

SetHelpProcess(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GetList("prefs_HelperWindowProgramExecutables",1)
Return
} ; V1toV2: Added bracket before function

GetList(TitleType,GetExe){
   global Menu_GetExe
   global Menu_TitleType
   global Menu_InProcessList
   global g_ScriptTitle
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global prefs_IncludeProgramTitles
   global prefs_ExcludeProgramTitles
   global prefs_IncludeProgramExecutables
   global prefs_ExcludeProgramExecutables
   global prefs_HelperWindowProgramTitles
   global prefs_HelperWindowProgramExecutables


   Menu_InProcessList := true
   Menu_GetExe := GetExe
   Menu_TitleType := TitleType
   If (GetExe == 1)
   {
      oid := WinGetlist(,,"Program Manager",)
      aid := Array()
      id := oid.Length
      For v in oid
      {   aid.Push(v)
      }
      Loop aid.Length
      {
         tmptitle := ""
         tmpid := aid[A_Index]
         tmptitle := WinGetProcessName("ahk_id " tmpid)
         If (tmptitle <> "")
            RunningList .= tmptitle "|"
      }
   } Else If (GetExe == 0) ; get list of active window titles
   {
      oid := WinGetlist(,,"Program Manager",)
      aid := Array()
      id := oid.Length
      For v in oid
      {   aid.Push(v)
      }
      Loop aid.Length
      {
         tmptitle := ""
         tmpid := aid[A_Index]
         tmptitle := WinGetTitle("ahk_id " tmpid)
         If (tmptitle <> "")
            RunningList .= tmptitle "|"
      }
   }

   MenuTitleList := ogc%Menu_TitleType%.Text

   MenuProcessHeight := 380

   RunningList := Sort(RunningList, "D| U")
   ProcessList := Gui()
   ProcessList.OnEvent("Close", ProcessListGuiEscape)
ProcessList.OnEvent("Escape", ProcessListGuiEscape)
ProcessList.Opt("+OwnerMenuGui")
   MenuGui.Opt("+Disabled")  ; disable main window
   ProcessList.Add("Text", "x10 y10", "Select program:")
   ogcDDLRunningList := ProcessList.Add("DDL", "xp+100 yp w250 R10", RunningList)
   ogcDDLRunningList.OnEvent("Change", ToEdit.Bind("Change"))
   ProcessList.Add("Text", "x10 yp+30", "Edit:")
   ProcessList.Add("Edit", "xp+100 yp w250")
   ogcButtonAdd := ProcessList.Add("Button", "xp+260 yp  w40 Default", "Add")
   ogcButtonAdd.OnEvent("Click", AddNew1.Bind("Normal"))
   if (GetExe == 0)
   {
      ProcessList.Add("Text", "x10 yp+30", "Exact Match:")
      ProcessList.Add("Checkbox", "xp+100 yp")
      MenuProcessHeight += 30
   }
   ProcessList.Add("Text", "x10 yp+30", "Current list:")
   ProcessList.Add("ListBox", "xp+100 yp w250 r10", [MenuTitleList])
   ogcButtonDel := ProcessList.Add("Button", "xp+260 yp  w40", "Del")
   ogcButtonDel.OnEvent("Click", RemoveNew1.Bind("Normal"))
   ProcessList.Add("Text", "x10 yp+170", "a) Select a program or window from the list or type a name in the`n" . A_Space . "" . A_Space . "" . A_Space . "" . A_Space . "" . A_Space . "'Edit' control (you may need to edit it further)`nb) Click ADD to add it to the list`nc) To remove a program/title, select an item from the 'current list' and`n" . A_Space . "" . A_Space . "" . A_Space . "" . A_Space . "click DEL.")
   ogcButtonSave := ProcessList.Add("Button", "x10 yp+90 w190", "Save")
   ogcButtonSave.OnEvent("Click", SaveTitleList.Bind("Normal"))
   ogcButtonCancel := ProcessList.Add("Button", "xp+210 yp w190", "Cancel")
   ogcButtonCancel.OnEvent("Click", ProcessListGuiEscape.Bind("Normal"))
   ProcessList.Title :=  . " Settings"
   ProcessList.Show("w420 h" . MenuProcessHeight)
   .OnEvent("Change", _ScriptTitle.Bind("Change"))
   Return
}

VisitForum(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
msgResult := MsgBox("Do you want to visit the " g_ScriptTitle " forum on www.autohotkey.com?", "Visit " g_ScriptTitle " forum (www.autohotkey.com)", 36)
if (msgResult = "Yes")
   Run("http://www.autohotkey.com/board/topic/49517-ahk-11typingaid-v2198-word-autocompletion-utility/")
Return
} ; V1toV2: Added bracket before function

Restore(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
msgResult := MsgBox("This will restore all settings to default. Continue?", "Restore Defaults", 1)
if (msgResult = "Cancel")
   return
RestoreDefaults()
Cancel()
return
} ; V1toV2: Added bracket before function

RestoreDefaults(){
   global g_PrefsFile
   global g_ScriptTitle
   global Menu_OldLearnCount
   global prefs_LearnCount

   ReadPreferences("RestoreDefaults")

   IF ( Menu_OldLearnCount < prefs_LearnCount )
   {
      msgResult := MsgBox("Restoring Defaults will increase the Learn Count value.`r`nWhen exiting " g_ScriptTitle ", this will permanently delete any words`r`nfrom the Learned Words which have been typed less times`r`nthan the new Learn Count. Continue?", "Restore Defaults", 1)
      if (msgResult = "Cancel")
      {
         ReturnValue := "Cancel"
      }
   }

   if (ReturnValue == "Cancel")
   {
      ReadPreferences(,"RestorePreferences")
      return
   } else {

      if FileExist(g_PrefsFile)
      {
         try {
            FileCopy(g_PrefsFile, PrefsFile "-" A_Now ".bak", 1)
            FileDelete(g_PrefsFile)
         } catch {
            MsgBox("Unable to back up preferences! Canceling...", "Restore Defaults", "")
            ReadPreferences(,"RestorePreferences")
            return
         }
      }

      ApplyChanges()
      MsgBox("Defaults have been restored.", "Restore Defaults", "")
   }

   return
}

MenuGuiGuiEscape(*)
{ ; V1toV2: Added bracket
  MenuGuiGuiClose:
  CancelButton:
  if (Menu_ValueChanged == true)
  {
     msgResult := MsgBox("Changes will not be saved. Cancel anyway?", "Cancel", 4)
     if (msgResult = "Yes")
     {
        Cancel()
     }
  } else {
     Cancel()
  }
  return
} ; V1toV2: Added Bracket before label

Cancel()
{ ; V1toV2: Added bracket
  MenuGui.Destroy()
  ; Clear WM_SETCURSOR action
  OnMessage(g_WM_SETCURSOR)
  ; Clear WM_MOUSEMOVE action
  OnMessage(g_WM_MOUSEMOVE)
  ;Clear mouse flags
  HandleSettingsMessage("", "", "", "")
  g_InSettings := false
  Tray.Enable("Settings")
  GetIncludedActiveWindow()
  Return
} ; V1toV2: Added bracket before function

Save(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Save()
return
} ; V1toV2: Added bracket before function

Save2(){
   global prefs_ArrowKeyMethod, prefs_DisabledAutoCompleteKeys, prefs_LearnCount, prefs_ListBoxOpacity, prefs_NoBackSpace, prefs_SendMethod
   global Menu_ChangedPrefs, Menu_ListBoxOpacityUpDown, Menu_OldLearnCount
   global g_ScriptTitle
   ; should only save preferences.ini if different from defaults
   Menu_ChangedPrefs["prefs_ArrowKeyMethod"] := prefs_ArrowKeyMethod
   Menu_ChangedPrefs["prefs_DisabledAutoCompleteKeys"] := prefs_DisabledAutoCompleteKeys
   Menu_ChangedPrefs["prefs_NoBackSpace"] := prefs_NoBackSpace
   Menu_ChangedPrefs["prefs_SendMethod"] := prefs_SendMethod
   oSaved := MenuGui.Submit()
   prefs_LearnMode := oSaved.prefs_LearnMode
   prefs_LearnLength := oSaved.prefs_LearnLength
   prefs_LearnCount := oSaved.prefs_LearnCount
   prefs_DoNotLearnStrings := oSaved.prefs_DoNotLearnStrings
   prefs_NumPresses := oSaved.prefs_NumPresses
   Menu_CtrlEnter := oSaved.Menu_CtrlEnter
   Menu_Tab := oSaved.Menu_Tab
   Menu_RightArrow := oSaved.Menu_RightArrow
   Menu_SingleClick := oSaved.Menu_SingleClick
   Menu_CtrlSpace := oSaved.Menu_CtrlSpace
   Menu_NumberKeys := oSaved.Menu_NumberKeys
   Menu_Enter := oSaved.Menu_Enter
   Menu_NumpadEnter := oSaved.Menu_NumpadEnter
   Menu_SendMethodC := oSaved.Menu_SendMethodC
   Menu_CaseCorrection := oSaved.Menu_CaseCorrection
   prefs_DetectMouseClickMove := oSaved.prefs_DetectMouseClickMove
   prefs_AutoSpace := oSaved.prefs_AutoSpace
   prefs_Length := oSaved.prefs_Length
   prefs_ListBoxRows := oSaved.prefs_ListBoxRows
   prefs_ShowLearnedFirst := oSaved.prefs_ShowLearnedFirst
   prefs_ArrowKeyMethod := oSaved.prefs_ArrowKeyMethod
   prefs_SuppressMatchingWord := oSaved.prefs_SuppressMatchingWord
   prefs_ListBoxOffset := oSaved.prefs_ListBoxOffset
   prefs_ListBoxFontFixed := oSaved.prefs_ListBoxFontFixed
   prefs_ListBoxFontSize := oSaved.prefs_ListBoxFontSize
   prefs_ListBoxOpacity := oSaved.prefs_ListBoxOpacity
   Menu_ListBoxOpacityUpDown := oSaved.Menu_ListBoxOpacityUpDown
   prefs_ListBoxCharacterWidth := oSaved.prefs_ListBoxCharacterWidth
   prefs_ListBoxFontOverride := oSaved.prefs_ListBoxFontOverride
   prefs_ListBoxMaxWidth := oSaved.prefs_ListBoxMaxWidth
   prefs_ListBoxNotDPIAwareProgramExecutables := oSaved.prefs_ListBoxNotDPIAwareProgramExecutables
   prefs_IncludeProgramTitles := oSaved.prefs_IncludeProgramTitles
   prefs_ExcludeProgramTitles := oSaved.prefs_ExcludeProgramTitles
   prefs_IncludeProgramExecutables := oSaved.prefs_IncludeProgramExecutables
   prefs_ExcludeProgramExecutables := oSaved.prefs_ExcludeProgramExecutables
   prefs_HelperWindowProgramTitles := oSaved.prefs_HelperWindowProgramTitles
   prefs_HelperWindowProgramExecutables := oSaved.prefs_HelperWindowProgramExecutables
   prefs_TerminatingCharacters := oSaved.prefs_TerminatingCharacters
   prefs_ForceNewWordCharacters := oSaved.prefs_ForceNewWordCharacters
   prefs_EndWordCharacters := oSaved.prefs_EndWordCharacters
   prefs_ListBoxOpacity := Menu_ListBoxOpacityUpDown

   IF (Menu_OldLearnCount < prefs_LearnCount )
   {
      msgResult := MsgBox("Saving will increase the Learn Count value.`r`nWhen exiting " g_ScriptTitle ", this will permanently delete any words`r`nfrom the Learned Words which have been typed less times`r`nthan the new Learn Count. Continue?", "Save", 1)
      if (msgResult = "Cancel")
      {
         ReturnValue := "Cancel"
      }
   }

   If ( ReturnValue == "Cancel" )
   {
      ReadPreferences("RestorePreferences")
   } 
   else 
   {
      SaveSettings()
      ApplyChanges()
   }
   Cancel()
   Return
}

SaveSettings(){
   Global

   Local Menu_PrefsToSave
   Local Split
   Local Split0
   Local Split1

   Local key
   Local value

   Menu_PrefsToSave := Object()

   Loop Parse, Menu_SendMethodOptionsCode, "|" ; get sendmethod
   {
      If (Menu_SendMethodC = A_Index)
         prefs_SendMethod:=A_LoopField
   }

   prefs_DisabledAutoCompleteKeys := ""
   If (Menu_CtrlEnter = 0)
      prefs_DisabledAutoCompleteKeys .= "E"
   If (Menu_Tab = 0)
      prefs_DisabledAutoCompleteKeys .= "T"
   If (Menu_CtrlSpace = 0)
      prefs_DisabledAutoCompleteKeys .= "S"
   If (Menu_RightArrow = 0)
      prefs_DisabledAutoCompleteKeys .= "R"
   If (Menu_NumberKeys = 0)
      prefs_DisabledAutoCompleteKeys .= "N"
   If (Menu_Enter = 0)
      prefs_DisabledAutoCompleteKeys .= "U"
   If (Menu_SingleClick = 0)
      prefs_DisabledAutoCompleteKeys .= "L"
   If (Menu_NumpadEnter = 0)
      prefs_DisabledAutoCompleteKeys .= "M"

   Loop Parse, Menu_ArrowKeyMethodOptionsText, "|"
   {
      Split := StrSplit(A_LoopField,"-")
      Split[1] := Trim(Split[1])
      If (prefs_ArrowKeyMethod = A_Index)
      {
         prefs_ArrowKeyMethod := Split[1]
      }
   }

   If (Menu_CaseCorrection = "on")
      prefs_NoBackSpace := "Off"
   Else If (Menu_CaseCorrection = "off")
      prefs_NoBackSpace := "On"

   ; Determine list of preferences to save
   For key, value in Menu_ChangedPrefs
   {
      IF (%key% <> value)
      {
         Menu_PrefsToSave.Insert(key)
      }
   }

   SavePreferences(Menu_PrefsToSave)
}

ApplyChanges()
{
   ValidatePreferences()
   ParseTerminatingCharacters()
   InitializeHotKeys()
   DestroyListBox()
   InitializeListBox()

   Return

}

EditValue(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Menu_ValueChanged := true
IF (A_GuiControl && !(SubStr(A_GuiControl, 1, 5) == "Menu_") )
{
   Menu_ChangedPrefs[A_GuiControl] := %A_GuiControl%
}
Return
} ; V1toV2: Added Bracket before label

HelpMe(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
HelpMe()
return
} ; V1toV2: Added bracket before function

HelpMe2()
{
   global g_ScriptTitle
   Loop Parse, %A_GuiControl%, "`r`n"
   {
      IF ( SubStr(A_LoopField, 1, 1) = ";")
      {
         Menu_Help .= SubStr(A_LoopField, 2) . "`r`n"
      } else {
         Menu_Help .= A_LoopField . "`r`n"
      }
   }
   MsgBox(Menu_Help, g_ScriptTitle " Help", 32)
   return
}

; derived from work by shimanov, 2005
; http://www.autohotkey.com/forum/viewtopic.php?p=37696#37696
HandleSettingsMessage( p_w, p_l, p_m, p_hw )
{
   Global g_IDC_HELP, g_IMAGE_CURSOR, g_LR_SHARED, g_NULL, g_WM_SETCURSOR, g_WM_MOUSEMOVE, g_cursor_hand
   Static Help_Hover, h_cursor_help, URL_Hover, h_old_cursor, Old_GuiControl

   ; pass in all blanks to clear flags
   if ((!p_w) && (!p_l) && (!p_m) && (!p_hw)) {
      Help_Hover := ""
      URL_Hover := ""
      h_old_cursor := ""
      Old_GuiControl := ""
   }

   if ( p_m = g_WM_SETCURSOR )
   {
      if ( Help_Hover || URL_Hover)
         return true
   } else if (A_GuiControl == Old_GuiControl)
   {
      return
   } else if ( p_m = g_WM_MOUSEMOVE )
   {
      if (Help_Hover || URL_Hover)
      {

         MenuGui.SetFont("cGreen")     ;;; xyz
         ;to be implemented ;;; xyz
      }

      if ( SubStr(A_GuiControl, 1, 9) == "helpinfo_" )
      {
         if !(Help_Hover)
         {
            IF !(h_cursor_help)
            {
               h_cursor_help := DllCall("LoadImage", "Ptr", g_NULL, "Uint", g_IDC_HELP, "Uint", g_IMAGE_CURSOR, "Int", g_NULL, "Int", g_NULL, "Uint", g_LR_SHARED)
            }
            old_cursor := DllCall("SetCursor", "Uint", h_cursor_help)
            Help_Hover := "true"
            URL_Hover := ""
            MenuGui.SetFont("cBlue")        ;;; xyz
            ;to be implemented ;;; xyz
         }
      } else if (A_GuiControl == "Menu_VisitForum")
      {
         if !(URL_Hover)
         {
            old_cursor := DllCall("SetCursor", "uint", g_cursor_hand)
            URL_Hover := "true"
            Help_Hover := ""
            MenuGui.SetFont("cBlue")        ;;; xyz
            ;to be implemented ;;; xyz
         }

      } else if (Help_Hover || URL_Hover)
      {
         DllCall("SetCursor", "Uint", h_old_cursor)
         Help_Hover := ""
         URL_Hover := ""
         h_old_cursor := ""
      }
      IF !(h_old_cursor)
      {
         h_old_cursor := old_cursor
      }

      Old_GuiControl := A_GuiControl
   }
}

SaveTitleList(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
SaveTitleList()
return
} ; V1toV2: Added bracket before function

SaveTitleList2()
{
   global Menu_InProcessList
   global Menu_TitleType
   oMenuTitleList := ControlGetItems("ListBox1", , , , )
   loop oMenuTitleList.length
   {
   MenuTitleList .= A_index=1 ? "" : "`n"
   MenuTitleList .= oMenuTitleList[A_Index] 
   }
   Menu_InProcessList := false
   ProcessList.Destroy()
   MenuGui.Opt("-Disabled")  ; enable main window
   MenuGui.Show()
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   MenuTitleList := StrReplace(MenuTitleList, "`n", "|")

   ogc%Menu_TitleType%.Text := MenuTitleList
   Menu_ChangedPrefs[Menu_TitleType] := %Menu_TitleType%

   return
}

ProcessListGuiEscape(*)
{ ; V1toV2: Added bracket
ProcessListGuiClose:
CancelTitle:
Menu_InProcessList := false
ProcessList.Destroy()
MenuGui.Opt("-Disabled") ; enable main window
MenuGui.Show()
Return
} ; V1toV2: Added Bracket before label

ToEdit(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ToEdit()
return
} ; V1toV2: Added bracket before function

ToEdit2()
{
   MenuOutputVar := ogcComboBox1.Text
   ogcEdit1.Value := ""
   ogcEdit1.Value := MenuOutputVar
   ControlFocus("Edit1")
   return
}

AddNew1(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
AddNew12()
return
} ; V1toV2: Added bracket before function

AddNew12()
{
   global Menu_GetExe
   if (Menu_GetExe == 0)
   {
      MenuExactMatch := ogcButton2.Text
   } else {
      MenuExactMatch := 0
   }
   MenuOutputVar := ogcEdit1.Text
   oMenuTitleList := ControlGetItems("ListBox1", , , , )
   loop oMenuTitleList.length
   {
   MenuTitleList .= A_index=1 ? "" : "`n"
   MenuTitleList .= oMenuTitleList[A_Index] 
   }

   if (MenuExactMatch == 1)
   {
      MenuOutputVar := """" . MenuOutputVar . """"
   }

   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   MenuTitleList := StrReplace(MenuTitleList, "`n", "|")
   MenuTitleList := "|" . MenuTitleList . "|"

   SearchString := "|" . MenuOutputVar . "|"

   if InStr(MenuTitleList, "|" MenuOutputVar "|")
   {
      MsgBox("Duplicate entry.", "", 16)
      return
   }

   ogcListBox1.Add([MenuOutputVar])
   ListBox1.ChooseString(MenuOutputVar)
   ogcEdit1.Value := ""
   if (Menu_GetExe == 0)
   {
      ogcButton2.Value := 0
   }
   ControlFocus("Edit1")
   return
}

RemoveNew1(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
RemoveNew12()
return
} ; V1toV2: Added bracket before function

RemoveNew12()
{
   MenuOutputVar := ogcListbox1.Text
   oMenuTitleList := ControlGetItems("ListBox1", , , , )
   loop oMenuTitleList.length
   {
   MenuTitleList .= A_index=1 ? "" : "`n"
   MenuTitleList .= oMenuTitleList[A_Index] 
   }
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   MenuTitleList := StrReplace(MenuTitleList, "`n", "|")
   MenuTitleList := "|" . MenuTitleList . "|"
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   MenuTitleList := StrReplace(MenuTitleList, "|" MenuOutputVar "|", "|")
   MenuTitleList := SubStr(MenuTitleList, 1, -1*(1))
   ogcListBox1.Delete() ;Clean the list
   ogcListBox1.Add([])
   ogcListBox1.Value := MenuTitleList

   return
}

; copied from font explorer http://www.autohotkey.com/forum/viewtopic.php?t=57501&highlight=font
Writer_enumFonts()
{
   global g_NULL
   Writer_enumFontsProc(0, 0, 0, 0,"Clear")
   hDC := DllCall("GetDC", "Uint", g_NULL)
   DllCall("EnumFonts", "Uint", hDC, "Uint", g_NULL, "Uint", CallbackCreate(Writer_enumFontsProc, "F"), "Uint", g_NULL)
   DllCall("ReleaseDC", "Uint", g_NULL, "Uint", hDC)

   return Writer_enumFontsProc(0, 0, 0, 0, "ReturnS")
}

Writer_enumFontsProc(lplf, lptm, dwType, lpData, Action := 0)
{
   static s

   if (Action = "Clear")
   {
      s := ""
      return
   }

   if (Action = "ReturnS")
      return s

   s .= DllCall("MulDiv", "Int", lplf+28, "Int", 1, "Int", 1, "str") "|"
   return 1
}






























































































