;These functions and labels are related to the preferences file

MaybeWriteHelperWindowPos()
{
   global g_XY
   global g_XYSaved
   ;Update the Helper Window Position
   if (g_XYSaved = 1)
   {
      if (g_XY != "")
         IniWrite(g_XY, A_ScriptDir "\LastState.ini", "HelperWindow", "XY")
   }
   Return
}

;------------------------------------------------------------------------

ReadPreferences(RestoreDefaults := false,RestorePreferences := false)
{
   global dft_IncludeProgramExecutables
   global dft_IncludeProgramTitles
   global dft_ExcludeProgramExecutables
   global dft_ExcludeProgramTitles
   global dft_Length
   global dft_NumPresses
   global dft_LearnMode
   global dft_LearnCount
   global dft_LearnLength
   global dft_DoNotLearnStrings
   global dft_ArrowKeyMethod
   global dft_DisabledAutoCompleteKeys
   global dft_DetectMouseClickMove
   global dft_NoBackSpace
   global dft_AutoSpace
   global dft_ShowLearnedFirst
   global dft_SuppressMatchingWord
   global dft_SendMethod
   global dft_TerminatingCharacters
   global dft_ForceNewWordCharacters
   global dft_EndWordCharacters
   global dft_ListBoxOffSet
   global dft_ListBoxFontFixed
   global dft_ListBoxFontOverride
   global dft_ListBoxFontSize
   global dft_ListBoxCharacterWidth
   global dft_ListBoxMaxWidth
   global dft_ListBoxOpacity
   global dft_ListBoxRows
   global dft_ListBoxNotDPIAwareProgramExecutables
   global dft_HelperWindowProgramExecutables
   global dft_HelperWindowProgramTitles
   
   global prefs_IncludeProgramExecutables
   global prefs_IncludeProgramTitles
   global prefs_ExcludeProgramExecutables
   global prefs_ExcludeProgramTitles
   global prefs_Length
   global prefs_NumPresses
   global prefs_LearnMode
   global prefs_LearnCount
   global prefs_LearnLength
   global prefs_DoNotLearnStrings
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_DetectMouseClickMove
   global prefs_NoBackSpace
   global prefs_AutoSpace
   global prefs_ShowLearnedFirst
   global prefs_SuppressMatchingWord
   global prefs_SendMethod
   global prefs_TerminatingCharacters
   global prefs_ForceNewWordCharacters
   global prefs_EndWordCharacters
   global prefs_ListBoxOffset
   global prefs_ListBoxFontFixed
   global prefs_ListBoxFontOverride
   global prefs_ListBoxFontSize
   global prefs_ListBoxCharacterWidth
   global prefs_ListBoxMaxWidth
   global prefs_ListBoxOpacity
   global prefs_ListBoxRows
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global prefs_HelperWindowProgramExecutables
   global prefs_HelperWindowProgramTitles
   
   ;g_PrefsFile is global so it works in Settings.ahk
   global g_PrefsFile
   global g_PrefsSections
   global g_XY
   
   g_PrefsFile := A_ScriptDir . "\Preferences.ini"
   Defaults := A_ScriptDir . "\Defaults.ini"
   LastState := A_ScriptDir . "\LastState.ini"
   
   MaybeFixFileEncoding(g_PrefsFile,"UTF-16")
   MaybeFixFileEncoding(Defaults,"UTF-16")
   MaybeFixFileEncoding(LastState,"UTF-16")
   
   dft_TerminatingCharacters := "{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}."
   
   
   ; There was a bug in TypingAid 2.19.7 that broke terminating characters for new preference files, this code repairs it
   BrokenTerminatingCharacters := "{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}."
   if FileExist(g_PrefsFile)
   {
      MaybeFixTerminatingCharacters := IniRead(g_PrefsFile, "Settings", "TerminatingCharacters", A_Space)
      IF (MaybeFixTerminatingCharacters == BrokenTerminatingCharacters)
      {
         IniWrite(dft_TerminatingCharacters, g_PrefsFile, "Settings", "TerminatingCharacters")
      }
   }      
   
   SpaceVar := "%A_Space%"
   
   IniValues := "
   (
      dft_IncludeProgramExecutables,prefs_IncludeProgramExecutables,IncludePrograms,%SpaceVar%
      dft_IncludeProgramTitles,prefs_IncludeProgramTitles,IncludePrograms,%SpaceVar%
      dft_ExcludeProgramExecutables,prefs_ExcludeProgramExecutables,ExcludePrograms,%SpaceVar%
      dft_ExcludeProgramTitles,prefs_ExcludeProgramTitles,ExcludePrograms,%SpaceVar%      ,Title,Settings,%SpaceVar%
      dft_Length,prefs_Length,Settings,3
      dft_NumPresses,prefs_NumPresses,Settings,1
      dft_LearnMode,prefs_LearnMode,Settings,On
      dft_LearnCount,prefs_LearnCount,Settings,5
      dft_LearnLength,prefs_LearnLength,Settings,%SpaceVar%
      dft_DoNotLearnStrings,prefs_DoNotLearnStrings,Settings,%SpaceVar%
      dft_ArrowKeyMethod,prefs_ArrowKeyMethod,Settings,First
      dft_DisabledAutoCompleteKeys,prefs_DisabledAutoCompleteKeys,Settings,%SpaceVar%
      dft_DetectMouseClickMove,prefs_DetectMouseClickMove,Settings,On
      dft_NoBackSpace,prefs_NoBackSpace,Settings,On
      dft_AutoSpace,prefs_AutoSpace,Settings,Off
      dft_ShowLearnedFirst,prefs_ShowLearnedFirst,Settings,Off
      dft_SuppressMatchingWord,prefs_SuppressMatchingWord,Settings,Off
      dft_SendMethod,prefs_SendMethod,Settings,1
      dft_TerminatingCharacters,prefs_TerminatingCharacters,Settings,`%dft_TerminatingCharacters`%
      dft_ForceNewWordCharacters,prefs_ForceNewWordCharacters,Settings,%SpaceVar%
      dft_EndWordCharacters,prefs_EndWordCharacters,Settings,%SpaceVar%
      dft_ListBoxOffSet,prefs_ListBoxOffset,ListBoxSettings,<Computed>
      dft_ListBoxFontFixed,prefs_ListBoxFontFixed,ListBoxSettings,Off
      dft_ListBoxFontOverride,prefs_ListBoxFontOverride,ListBoxSettings,<Default>
      dft_ListBoxFontSize,prefs_ListBoxFontSize,ListBoxSettings,10 
      dft_ListBoxCharacterWidth,prefs_ListBoxCharacterWidth,ListBoxSettings,<Computed>
      dft_ListBoxMaxWidth,prefs_ListBoxMaxWidth,ListBoxSettings,%SpaceVar%
      dft_ListBoxOpacity,prefs_ListBoxOpacity,ListBoxSettings,215
      dft_ListBoxRows,prefs_ListBoxRows,ListBoxSettings,10
      dft_ListBoxNotDPIAwareProgramExecutables,prefs_ListBoxNotDPIAwareProgramExecutables,ListBoxSettings,%SpaceVar%
      dft_HelperWindowProgramExecutables,prefs_HelperWindowProgramExecutables,HelperWindow,%SpaceVar%
      dft_HelperWindowProgramTitles,prefs_HelperWindowProgramTitles,HelperWindow,%SpaceVar%      ,XY,HelperWindow,%SpaceVar%
   )"
   
   g_PrefsSections := Object()
    
   Loop Parse, IniValues, "`n", "`r" A_Space
   {
      CurrentIniValues := StrSplit(A_LoopField,",")
      DftVariable := CurrentIniValues[1]
      NormalVariable := CurrentIniValues[2]
      IniSection := CurrentIniValues[3]
      DftValue := CurrentIniValues[4]
      ; maybe strip "prefs_" prefix
      if (SubStr(NormalVariable, 1, 6) == "prefs_")
      {
         KeyName := SubStr(NormalVariable, (6)+1)
      } else {
         KeyName := NormalVariable
      }
      
      g_PrefsSections[KeyName] := IniSection
      
      ; this is done because certain characters can break the parsing (comma, for example)
      IF (DftValue == "%dft_TerminatingCharacters%")
      {
         DftValue := dft_TerminatingCharacters
      }

      IF ( DftValue = "%A_Space%" )
         DftValue := A_Space
      
      IF !(RestoreDefaults)
         %NormalVariable% := IniRead(g_PrefsFile, IniSection, KeyName, A_Space)
      
      IF DftVariable
      { 
         %DftVariable% := IniRead(Defaults, IniSection, KeyName, DftValue)
         IF (RestoreDefaults || %NormalVariable% == "")
         {
            %NormalVariable% := %DftVariable%
         }
      }
   }
   
   ValidatePreferences()
   ParseTerminatingCharacters()
   
   ; Legacy support for old Preferences File
   if (Etitle != "")
   {
      if (prefs_IncludeProgramTitles = "")
      {
         prefs_IncludeProgramTitles := Etitle
      } else {
         prefs_IncludeProgramTitles .= "|" . Etitle
      }
      
      Etitle := ""
   }
   
   g_XY := XY
   
   IF ( RestoreDefaults || RestorePreferences )
      Return
   
   if FileExist(LastState)
   {    
      g_XY := IniRead(LastState, "HelperWindow", "XY", A_Space)
   }
   
   ConstructHelpStrings()
         
   Return
}

ValidatePreferences(){
   global g_ListBoxCharacterWidthComputed, g_ListBoxOffsetComputed, g_NumKeyMethod
   global prefs_ArrowKeyMethod, prefs_DisabledAutoCompleteKeys
   global dft_ArrowKeyMethod
   global prefs_AutoSpace, prefs_DetectMouseClickMove, prefs_LearnCount, prefs_LearnLength, prefs_LearnMode, prefs_Length
   global dft_AutoSpace, dft_DetectMouseClickMove, dft_LearnCount, dft_LearnLength, dft_LearnMode, dft_Length
   global prefs_ListBoxCharacterWidth, prefs_ListBoxFontFixed, prefs_ListBoxFontSize, prefs_ListBoxMaxWidth, prefs_ListBoxOffset, prefs_ListBoxOpacity, prefs_ListBoxRows
   global dft_ListBoxCharacterWidth, dft_ListBoxFontFixed, dft_ListBoxFontSize, dft_ListBoxMaxWidth, dft_ListBoxOffset, dft_ListBoxOpacity, dft_ListBoxRows
   global prefs_NoBackSpace, prefs_NumPresses, prefs_SendMethod, prefs_ShowLearnedFirst, prefs_SuppressMatchingWord, prefs_TerminatingCharacters
   global dft_NoBackSpace, dft_NumPresses, dft_SendMethod, dft_ShowLearnedFirst, dft_SuppressMatchingWord, dft_TerminatingCharacters
   
   if !isInteger(prefs_Length)
   {
      prefs_Length := dft_Length
   }
   
   if (prefs_Length < 1) {
      prefs_Length := "1"
   }
   
   if !(prefs_NumPresses ~= "^(?i:1|2)$")
      prefs_NumPresses := dft_NumPresses
   
   if !(prefs_LearnMode ~= "^(?i:On|Off)$")
      prefs_LearnMode := dft_LearnMode
   
   if !isInteger(prefs_LearnCount)
   {
      prefs_LearnCount := dft_LearnCount
   }
   
   if (prefs_LearnCount < 1)
   {
      prefs_LearnCount := "1"
   }
   
   if !isInteger(dft_LearnLength)
   {
      dft_LearnLength := prefs_Length + 2
   }
   
   if !isInteger(prefs_LearnLength)
   {
      prefs_LearnLength := dft_LearnLength
   } else If ( prefs_LearnLength < ( prefs_Length + 1 ) )
   {
      prefs_LearnLength := prefs_Length + 1
   }
   
   if (prefs_DisabledAutoCompleteKeys ~= "i)(N)")
   {
      g_NumKeyMethod := "Off"
   } else {
      g_NumKeyMethod := "On"
   }
   
   if (prefs_ArrowKeyMethod != "Off")
      if (prefs_DisabledAutoCompleteKeys ~= "i)(E)")
         if (prefs_DisabledAutoCompleteKeys ~= "i)(S)")
            if (prefs_DisabledAutoCompleteKeys ~= "i)(T)")
               if (prefs_DisabledAutoCompleteKeys ~= "i)(R)")
                  if (prefs_DisabledAutoCompleteKeys ~= "i)(U)")
                     if (prefs_DisabledAutoCompleteKeys ~= "i)(M)")
                        prefs_ArrowKeyMethod := "Off"
   
   if !(prefs_ArrowKeyMethod ~= "^(?i:First|Off|LastWord|LastPosition)$")
   {
      prefs_ArrowKeyMethod := dft_ArrowKeyMethod
   }
   
   if !(prefs_DetectMouseClickMove ~= "^(?i:On|Off)$")
      prefs_DetectMouseClickMove := dft_DetectMouseClickMove
   
   if !(prefs_NoBackSpace ~= "^(?i:On|Off)$")
      prefs_NoBackSpace := dft_NoBackSpace
      
   if !(prefs_AutoSpace ~= "^(?i:On|Off)$")
      prefs_AutoSpace := dft_AutoSpace
   
   if !(prefs_ShowLearnedFirst ~= "^(?i:On|Off)$")
      prefs_ShowLearnedFirst := dft_ShowLearnedFirst
   
   if !(prefs_SuppressMatchingWord ~= "^(?i:On|Off)$")
      prefs_SuppressMatchingWord := dft_SuppressMatchingWord
   
   if !(prefs_SendMethod ~= "^(?i:1|2|3|1C|2C|3C|4C)$")
      prefs_SendMethod := dft_SendMethod
   
   ;SendPlay does not work when not running as Administrator, switch to SendInput
   If not A_IsAdmin
   {
      if (prefs_SendMethod = 1)
      {
         prefs_SendMethod := "2"
      } else       if (prefs_SendMethod = "1C")
      {
         prefs_SendMethod := "2C"
      }
   }
   
   if (prefs_TerminatingCharacters = "")
      prefs_TerminatingCharacters := dft_TerminatingCharacters
      
   if !(prefs_ListBoxFontFixed ~= "^(?i:On|Off)$")
      prefs_ListBoxFontFixed := dft_ListBoxFontFixed
   
   if !isInteger(prefs_ListBoxFontSize)
   {
      prefs_ListBoxFontSize := dft_ListBoxFontSize
   }
   else    if (prefs_ListBoxFontSize < 2)
   {
      prefs_ListBoxFontSize := "2"
   }
   
   if !isInteger(dft_ListBoxOffset)
   {
      dft_ListBoxOffset := "<Computed>"
   }
   
   if !isInteger(prefs_ListBoxOffset)
   {
      if !(prefs_ListBoxOffset == "<Computed>")
      {
         prefs_ListBoxOffset := dft_ListBoxOffset
      }
   }
   
   if isInteger(prefs_ListBoxOffset)
   {
      g_ListBoxOffsetComputed := prefs_ListBoxOffset
   } else {
      ; There are 72 points in an inch. Font size is measured in points.
      g_ListBoxOffsetComputed := Ceil(prefs_ListBoxFontSize * A_ScreenDPI / 72)
   }
   
   if !isInteger(dft_ListBoxCharacterWidth)
   {
      dft_ListBoxCharacterWidth := "<Computed>"
   }
   
   if !isInteger(prefs_ListBoxCharacterWidth)
   {
      if !(prefs_ListBoxCharacterWidth == "<Computed>")
      {
         prefs_ListBoxCharacterWidth := dft_ListBoxCharacterWidth
      }
   }
   
   if isInteger(prefs_ListBoxCharacterWidth)
   {
      g_ListBoxCharacterWidthComputed := prefs_ListBoxCharacterWidth
   } else {
      ; There are 72 points in an inch. Font size is measured in points. Most fonts have a width 3/5 the size of their height
      g_ListBoxCharacterWidthComputed := Ceil(prefs_ListBoxFontSize * A_ScreenDPI / 72 * 0.6)
   }
   
   if !isInteger(dft_ListBoxMaxWidth)
   {
      dft_ListBoxMaxWidth := ""
   }
   
   if !isInteger(prefs_ListBoxMaxWidth)
   {
      prefs_ListBoxMaxWidth := dft_ListBoxMaxWidth
   }
   
   if !prefs_ListBoxMaxWidth
   {
      ; skip out
   } else    if isInteger(prefs_ListBoxMaxWidth)
   {
      if (prefs_ListBoxMaxWidth < 100)
         prefs_ListBoxMaxWidth := "100"
   }
      
   if !isInteger(prefs_ListBoxOpacity)
      prefs_ListBoxOpacity := dft_ListBoxOpacity
   
   if (prefs_ListBoxOpacity < 0)
      prefs_ListBoxOpacity := "0"
   else    if (prefs_ListBoxOpacity > 255)
      prefs_ListBoxOpacity := "255"
                  
   if !isInteger(prefs_ListBoxRows)
      prefs_ListBoxRows := dft_ListBoxRows
   
   if (prefs_ListBoxRows < 3)
      prefs_ListBoxRows := "3"
   else    if (prefs_ListBoxRows > 30)
      prefs_ListBoxRows := "30"
            
   Return
}

ParseTerminatingCharacters(){
   global prefs_TerminatingCharacters
   global g_TerminatingCharactersParsed
   global g_TerminatingEndKeys
   
   Loop Parse, prefs_TerminatingCharacters
   {
      if (OpenWord = 1)
      {
         If ( A_LoopField == "}" )
         {
            OpenWord := ""
            IF !(Word)
               TempCharacters .= "{}"
            else If ( Word = "{" || Word = "}")
               TempCharacters .= Word
            else
               TempEndKeys .= "{" . Word . "}"
            
            Word := ""
         } else 
         {
            Word .= A_LoopField
         }
      } else if ( A_LoopField  == "{" )
      {
         OpenWord := "1"
      } else
      {
         TempCharacters .= A_LoopField
      }
   }
      
   if (Word != "")
      TempCharacters .= Word
   
   g_TerminatingCharactersParsed := TempCharacters
   g_TerminatingEndKeys := TempEndKeys
}

SavePreferences(PrefsToSave){
   global
   local index
   local element
   local KeyName
   local PrefsExist
   
   ValidatePreferences()
   
   if FileExist(g_PrefsFile)
   {
      PrefsExist := true
   } else {
      PrefsExist := false
   }
      
   for index, element in PrefsToSave
   {
      if (SubStr(element, 1, 6) == "prefs_")
      {
         KeyName := SubStr(element, (6)+1)
      } else {
         KeyName := element
      }
   
      If (%element% == dft_%KeyName%)
      {
         ; Make sure preferences already exist so we don't create 0 byte file
         if (PrefsExist == true)
         {
            IniDelete(g_PrefsFile, g_PrefsSections[KeyName], KeyName)
         }
      } else {
         IniWrite(%element%, g_PrefsFile, g_PrefsSections[KeyName], KeyName)
      }
   }
   
   Return
}

ConstructHelpStrings()
{
   global

helpinfo_LearnMode := "
(

)"

helpinfo_LearnLength := "
(

)"

helpinfo_LearnCount := "
(

)"

helpinfo_ListBoxRows := "
(

)"

helpinfo_Length := "
(


)"

helpinfo_SendMethod := "
(













)"

helpinfo_DisabledAutoCompleteKeys := "
(

)"

helpinfo_ArrowKeyMethod := "
(






)"

helpinfo_NoBackSpace := "
(



)"

helpinfo_DetectMouseClickMove := "
(



)"

helpinfo_AutoSpace := "
(



)"

helpinfo_DoNotLearnStrings := "
(



)"

helpinfo_SuppressMatchingWord := "
(





)"

helpinfo_NumPresses := "
(

)"

helpinfo_ShowLearnedFirst := "
(

)"

helpinfo_ListBoxOffset := "
(

)"

helpinfo_ListBoxFontFixed := "
(


)"

helpinfo_ListBoxFontSize := "
(

)"

helpinfo_ListBoxOpacity := "
(


)"

helpinfo_ListBoxCharacterWidth := "
(







)"

helpinfo_ListBoxFontOverride := "
(


)"

helpinfo_ListBoxMaxWidth := "
(

)"

helpinfo_ListBoxNotDPIAwareProgramExecutables := "
(

)"

helpinfo_IncludeProgramTitles := "
(


)"

helpinfo_ExcludeProgramTitles := "
(


)"
   
helpinfo_IncludeProgramExecutables := "
(


)"

helpinfo_ExcludeProgramExecutables := "
(


)"

helpinfo_HelperWindowProgramTitles := "
(


)"

helpinfo_HelperWindowProgramExecutables := "
(


)"

helpinfo_TerminatingCharacters := "
(











)"

helpinfo_ForceNewWordCharacters := "
(






")

helpinfo_EndWordCharacters := "
(






)"

helpinfo_FullHelpString := "
(
%helpinfo_LearnMode%`r`n`r`n%helpinfo_LearnLength%`r`n`r`n%helpinfo_LearnCount%

%helpinfo_DoNotLearnStrings%`r`n`r`n%helpinfo_NumPresses%

%helpinfo_DisabledAutoCompleteKeys%`r`n`r`n%helpinfo_SendMethod%

%helpinfo_NoBackSpace%`r`n`r`n%helpinfo_DetectMouseClickMove%`r`n`r`n%helpinfo_AutoSpace%

%helpinfo_ListBoxRows%`r`n`r`n%helpinfo_Length%`r`n`r`n%helpinfo_ShowLearnedFirst%

%helpinfo_ArrowKeyMethod%`r`n`r`n%helpinfo_SuppressMatchingWord%

%helpinfo_ListBoxOffset%`r`n`r`n%helpinfo_ListBoxFontFixed%`r`n`r`n%helpinfo_ListBoxFontSize%

%helpinfo_ListBoxOpacity%`r`n`r`n%helpinfo_ListBoxCharacterWidth%`r`n`r`n%helpinfo_ListBoxFontOverride%

%helpinfo_ListBoxMaxWidth%`r`n`r`n%helpinfo_ListBoxNotDPIAwareProgramExecutables%

%helpinfo_IncludeProgramTitles%`r`n`r`n%helpinfo_ExcludeProgramTitles%`r`n`r`n%helpinfo_IncludeProgramExecutables%`r`n`r`n%helpinfo_ExcludeProgramExecutables%

%helpinfo_HelperWindowProgramTitles%`r`n`r`n%helpinfo_HelperWindowProgramExecutables%

%helpinfo_TerminatingCharacters%`r`n`r`n%helpinfo_ForceNewWordCharacters%`r`n`r`n%helpinfo_EndWordCharacters%
)"

}
