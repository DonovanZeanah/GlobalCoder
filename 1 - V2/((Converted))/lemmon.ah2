Persistent
; REMOVED: SetBatchLines -1
MonitorGetWorkArea(, &SizeLeft, &SizeTop, &SizeRight, &SizeBottom)


GuiRight := SizeRight - 147
Button_Right := SizeRight - 147
Button_Bottom := SizeBottom - 31
myGui := Gui()
myGui.Color("cFFFFFF")
Loop "*.ahk"
{
   If (A_LoopFileName <> "Main Window.ahk")
   {
      A_IndexCount := A_Index
      If A_IndexCountMinus
         A_IndexCount -= A_IndexCountMinus
      YPos := A_IndexCount * 25 - 20
      FileName%A_IndexCount% := SubStr(A_LoopFileName, 1, -1*(4))
      RunPath%A_IndexCount% := A_LoopFilePath
      myGui.Add("Button", "w110 h20 x5 y" . YPos, FileName . A_IndexCount).OnEvent("Change", Run.Bind("Change"))
      myGui.Add("Button", "w20 h20 x120 Disabled y" . YPos . " vFileName2" . A_IndexCount, "K")
      ogcButtonFileName2.OnEvent("Change", ButtonK.Bind("Change"))
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
myGui.Font("w700 c000000")
myGui.Add("Text", "w90 h20 x30 y" . TitlePos . " Center", "Utilities").OnEvent("Change", Drag.Bind("Change"))
myGui.Font("c000000")
myGui.Add("Button", "w20 h20 x5 y" . ButtonPos, "&-").OnEvent("Change", Button-.Bind("Change"))
myGui.Add("Button", "w20 h20 x120 y" . ButtonPos, "&X").OnEvent("Change", ButtonX.Bind("Change"))
myGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Border")
myGui.Show("NoActivate w145 h" . YPos . " x" . GuiRight . " y" . GuiBottom, "Main Window")
return

Drag(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
   PostMessage(0xA1, 2, , , "A")
return
} 

Run(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
   Loop
   {
   If (A_GuiControl = FileName . A_Index)
   {
      RunPath := RunPath . A_Index
      Run("Autohotkey.exe" . RunPath ,A_GuiControl, &ProgRun . A_Index)
      ProcessRun := A_Index
      break
   }
   }
   ogcFileName2%ProcessRun%.Enabled := true
   myGui.Show("NoActivate w145 h" . YPos . " x" . GuiRight . " y" . GuiBottom, "Main Window")
return
} ; V1toV2: Added Bracket before label

ButtonK(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
   RunningName := SubStr(A_GuiControl, (9)+1)
   FileNameKill := ProgRun%RunningName%
   ProcessClose(FileNameKill)
   ogcFileName2%RunningName%.Enabled := false
return
} ; V1toV2: Added Bracket before label

Button-(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
   myGui.Cancel()
   oGui2 := Gui()
   oGui2.Color("cFFFFFF")
   oGui2.Font("w700 c000000")
   oGui2.Add("Text", "w90 h20 x30 y9 Center", "Utilities").OnEvent("Change", Drag.Bind("Change"))
   oGui2.Font("c000000")
   oGui2.Add("Button", "w20 h20 x5 y5", "&+").OnEvent("Change", _2Button+.Bind("Change"))
   oGui2.Add("Button", "w20 h20 x120 y5", "&X").OnEvent("Change", ButtonX.Bind("Change"))
   oGui2.Opt("-Caption +AlwaysOnTop +Border")
   oGui2.Show("NoActivate w145 h30 x" . Button_Right . " y" . Button_Bottom, "Minimized")
return
} 

_2Button+(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
   oGui2.Destroy()
   myGui.Show("NoActivate w145 h" . YPos . " x" . GuiRight . " y" . GuiBottom, "Main Window")
return
} 

ButtonX(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
_2ButtonX:
ExitApp()
} 


