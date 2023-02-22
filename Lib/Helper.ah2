; These functions and labels are related to interacting with the Helper Window

MaybeOpenOrCloseHelperWindow(ActiveProcess,ActiveTitle,ActiveId)
{
   ; This is called when switching the active window
   global g_HelperManual
   
   if (g_HelperManual != "")
   {
      MaybeCreateHelperWindow()
      Return
   }

   IF ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
   {
      global g_HelperClosedWindowIds
      ; Remove windows which were closed
      Loop Parse, g_HelperClosedWindowIDs, "|"
      {
         if (A_LoopField = "")
            Continue
            
         if WinExist("ahk_id " A_LoopField)
         {
            TempHelperClosedWindowIDs .= "|" . A_LoopField . "|"
         }
      }
      
      g_HelperClosedWindowIDs := TempHelperClosedWindowIDs
      TempHelperClosedWindowIDs := ""
      
      SearchText := "|" . ActiveId . "|"
      
      if InStr(g_HelperClosedWindowIDs, SearchText)
      {
         MaybeSaveHelperWindowPos()
      } else MaybeCreateHelperWindow()
   
   } else MaybeSaveHelperWindowPos()

   Return
   
}

CheckHelperWindowAuto(ActiveProcess,ActiveTitle)
{
   global prefs_HelperWindowProgramExecutables
   global prefs_HelperWindowProgramTitles
   
   quotechar := """"
   
   Loop Parse, prefs_HelperWindowProgramExecutables, "|"
   {
      if (ActiveProcess = A_LoopField)
         Return true
   }

   Loop Parse, prefs_HelperWindowProgramTitles, "|"
   {
      if (SubStr(A_LoopField, 1, 1) == quotechar && SubStr(A_LoopField, (StrLen(A_LoopField))<1 ? (StrLen(A_LoopField))-1 : (StrLen(A_LoopField)), 1) == quotechar)
      {
         TrimmedString := SubStr(A_LoopField, (1)+1)
         TrimmedString := SubStr(TrimmedString, 1, -1*(1))
         if (ActiveTitle = TrimmedString)
         {
            Return true
         }
      } else       if InStr(ActiveTitle, A_LoopField)
      {
         Return true
      }
   }

   Return
}

MaybeOpenOrCloseHelperWindowManual()
{
   ;Called when we hit Ctrl-Shift-H
      
   global g_Helper_Id
   global g_HelperManual
   
   ;If a helper window already exists 
   if (g_Helper_Id != "")
   {
      ; If we've forced a manual helper open, close it. Else mark it as forced open manually
      if (g_HelperManual != "")
      {
         HelperWindowClosed()
      } else g_HelperManual := "1"
   } else {
      global g_Active_Id
      global g_Active_Process
      global g_Active_Title
      ;Check for Auto Helper, and if Auto clear closed flag and open
      IF ( CheckHelperWindowAuto(g_Active_Process,g_Active_Title) )
      {
         global g_HelperClosedWindowIDs
         SearchText := "|" . g_Active_Id . "|"
         ; StrReplace() is not case sensitive
         ; check for StringCaseSense in v1 source script
         ; and change the CaseSense param in StrReplace() if necessary
         g_HelperClosedWindowIDs := StrReplace(g_HelperClosedWindowIDs, SearchText,,,, 1)
               
      } else {
         ; else Open a manually opened helper window
         g_HelperManual := "1"
      }
      MaybeCreateHelperWindow()
   }
      
   Return
}

;------------------------------------------------------------------------

;Create helper window for showing ListBox
MaybeCreateHelperWindow()
{
   Global g_Helper_Id
   Global g_XY
   ;Don't open a new Helper Window if One is already open
   if (g_Helper_Id != "")
      Return
      
   HelperGui := Gui()
   HelperGui.Opt("+Owner -MinimizeBox -MaximizeBox +AlwaysOnTop")
   HelperGui.Opt("+LabelHelper_")
   HelperGui.Add("Text", , "List appears here")
   if (g_XY != "")
   {
      Pos := StrSplit(g_XY,",")
      HelperGui.Show("X" . Pos[1] . " Y" . Pos[2] . " NoActivate")
   } else {
      HelperGui.Show("NoActivate")
   }
   g_Helper_Id := WinGetID(,"List appears here")
   WinSetTransparent(125, "ahk_id " g_Helper_Id)
   return 
}

;------------------------------------------------------------------------

Helper_Close:
HelperWindowClosed()
Return

HelperWindowClosed()
{
   global g_Helper_Id
   global g_HelperManual
   if (g_Helper_Id != "")
   {
      ;Check g_LastActiveIdBeforeHelper and not g_Active_Id in case we are on the Helper Window
      global g_LastActiveIdBeforeHelper
      ActiveTitle := WinGetTitle("ahk_id " g_LastActiveIdBeforeHelper)
      ActiveProcess := WinGetProcessName("ahk_id " g_LastActiveIdBeforeHelper)
      
      If ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
      {
         global g_HelperClosedWindowIDs
         
         SearchText := "|" . g_LastActiveIdBeforeHelper . "|"         
         if !InStr(g_HelperClosedWindowIDs, SearchText)
            g_HelperClosedWindowIDs .= SearchText
      }
   
      g_HelperManual := ""
   
      MaybeSaveHelperWindowPos()
   }
   Return
}

;------------------------------------------------------------------------

MaybeSaveHelperWindowPos()
{
   global g_Helper_Id
   if (g_Helper_Id != "")
   {
      global g_XY
      global g_XYSaved
      WinGetPos(&hX, &hY, , , "ahk_id " g_Helper_Id)
      g_XY := hX . "," . hY
      g_XYSaved := "1"
      g_Helper_Id := ""
      HelperGui.Hide()
   }
   Return
}

;------------------------------------------------------------------------