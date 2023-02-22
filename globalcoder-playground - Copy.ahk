esc::reload
#persistent


!q::
 counter := ++0
ToolTip, count, 1850, 1020,

Gui, Add, Button, gCtrlEvent vButton1, Button 1
Gui, Add, Button, gCtrlEvent vButton2, Button 2
Gui, Add, Button, gGoButton, Go Button
Gui, Add, Edit, vEditField, Example text
Gui, Show,, Functions instead of labels



GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, Go has been clicked! The content of the edit field is "%EditField%"!
   
	AlterClipboard("//" ,"{", "}", "(")
	Sleep 100
	msgbox % clipboard
	
	
/*	str := "AlterClipboard(ReplaceWith, ToReplace*) {`n"
	str .= "    clip := clipboard`n"
	str .= "    for _, v in ToReplace {`n"
	str .= "        clip := StrReplace(clip, v, ReplaceWith)`n"
	str .= "    }`n"
	str .= "    clipboard := clip`n"
	str .= "}"
	*/
	
	clipboard := str
	AlterClipboard3(" " , StrSplit("()}{:=,")*)
	msgbox % clipboard
return 

}
alterClipboard(ReplaceWith := "", ToReplace*) {
    oldstring := clip := clipboard
    if ReplaceWith = ""
        ReplaceWith := A_Space

    for _, v in ToReplace {
        clip := StrReplace(clip, v, ReplaceWith)
    }
    clipboard := clip
}




CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
return

/*AlterClipboard_AllSymbols(ReplaceWith, ToReplace*) {
    clip := clipboard
    for _, v in ToReplace {
        clip := StrReplace(clip, v, ReplaceWith)
    }
    clipboard := clip
}



AlterClipboard2(ReplaceWith, ToReplace*) {
    clip := clipboard
    for _, v in ToReplace {
        clip := StrReplace(clip, v, ReplaceWith)
    }
    clipboard := clip
}
*/


9::
haystack := %freshstring% 
needle := 

MsgBox, % "0: `n " needle "--" sub
	x := RegExMatch(clipboard, """" needle """", outvar)
	Msgbox, % "0: `n result:" x "-" OutVar

	y := RegExReplace(clipboard,"" needle "" ,"" sub "", "outvar",-1, 1)
	clipboard := y
	MsgBox, % "1: `n replaced result: " y 

	y := RegExReplace(clipboard,"""" needle """" ,"" sub "", "outvar",-1, 1)
	clipboard := y
	MsgBox, % "1: `n replaced result: " y 

    return