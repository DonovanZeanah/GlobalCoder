#Persistent
SetBatchLines -1
SysGet, Size, MonitorWorkArea
GuiRight := SizeRight - 147
Button_Right := SizeRight - 147
Button_Bottom := SizeBottom - 31
Gui, 1: Color, cFFFFFF

;loop all .ahk, if its anything BUT MainWindow.ahk, add it to gui
Loop, *.ahk
{
   If (A_LoopFileName <> "globalcoder.ahk")
   {
      A_IndexCount := A_Index
      If A_IndexCountMinus
         A_IndexCount -= A_IndexCountMinus
      YPos := A_IndexCount * 25 - 20
      StringTrimRight, FileName%A_IndexCount%, A_LoopFileName, 4
      RunPath%A_IndexCount% := A_LoopFileFullPath
      Gui, 1: Add, Button, w110 h20 x5 y%YPos% gRun, % FileName%A_IndexCount%
      Gui, 1: Add, Button, w20 h20 x120 Disabled y%YPos% vFileName2%A_IndexCount%, K
      YPos%A_IndexCount% := YPos . "," . FileName%A_IndexCount%
   }
   else
   {
      A_IndexCountMinus++
      continue
   }
}
YPos += 50
GuiBottom := SizeBottom - YPos - 1
TitlePos := YPos - 21
ButtonPos := YPos - 25
Gui, 1: Font, w700 c000000
Gui, 1: Add, Text, w90 h20 x30 y%TitlePos% Center gDrag, Utilities
Gui, 1: Font, c000000
Gui, 1: Add, Button, w20 h20 x5 y%ButtonPos%, &-
Gui, 1: Add, Button, w20 h20 x120 y%ButtonPos%, &X
Gui, 1: +AlwaysOnTop -Caption +ToolWindow +Border
Gui, 1: Show, NoActivate w145 h%YPos% x%GuiRight% y%GuiBottom%, Main Window
return

Drag:
   PostMessage, 0xA1, 2,,, A
return

Run:
   Loop
   {
   If (A_GuiControl = FileName%A_Index%)
   {
      RunPath := RunPath%A_Index%
      Run, Autohotkey.exe "%RunPath%",,, ProgRun%A_Index%
      ProcessRun := A_Index
      break
   }
   }
   GuiControl, Enable, FileName2%ProcessRun%
   Gui, 1: Show, NoActivate w145 h%YPos% x%GuiRight% y%GuiBottom%, Main Window
return

ButtonK:
   StringTrimLeft, RunningName, A_GuiControl,9
   FileNameKill := ProgRun%RunningName%
   Process, Close, % FileNameKill
   GuiControl, Disable, FileName2%RunningName%
return

Button-:
   Gui, 1: Cancel
   Gui, 2: Color, cFFFFFF
   Gui, 2: Font, w700 c000000
   Gui, 2: Add, Text, w90 h20 x30 y9 Center gDrag, Utilities
   Gui, 2: Font, c000000
   Gui, 2: Add, Button, w20 h20 x5 y5, &+
   Gui, 2: Add, Button, w20 h20 x120 y5, &X
   Gui, 2: -Caption +AlwaysOnTop +Border
   Gui, 2: Show, NoActivate w145 h30 x%Button_Right% y%Button_Bottom%, Minimized
return

2Button+:
   Gui, 2: Destroy
   Gui, 1: Show, NoActivate w145 h%YPos% x%GuiRight% y%GuiBottom%, Main Window
return

ButtonX:
2ButtonX:
ExitApp