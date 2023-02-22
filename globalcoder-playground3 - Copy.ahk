esc::reload
#persistent

funcs := {}
funcs.1 := AlterClipboard(" " , StrSplit("()}{:=,")*) ;strip all symbols
funcs.2 := AlterClipboard(" " , StrSplit("()}{,")*) ;strip all symbols
funcs.3 := AlterClipboard(" " , StrSplit("(),")*) ;strip all symbols


for i, menu in strsplit(menutools, ":")
{
	Menu %_menuName%, Add, %A_LoopField%, %_menuLabel%
}

menutools =
(
&Google Search :
http://www.google.com/search?hl=en&q=@@
Google &Images:
http://images.google.com/images?hl=en&@@
&Dictionary.com:
http://www.dictionary.com/search?q=@@&db=*, , max
The &Free Dictionary:
http://www.thefreedictionary.com/@@
&Merriam-Webster:
http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=@@
&Wikipedia:
http://en.wikipedia.org/w/wiki.phtml?search=@@
&Columbia Encyclopedia:
http://columbia.thefreedictionary.com/@@
&Encarta Encyclopedia:
http://encarta.msn.com/encnet/refpages/search.aspx?q=@@
&AutoHotkey manual:
http://www.autohotkey.com/docs/commands/@@.htm
)



funcrunner(func){
 funcvar := func


}

alterClipboard(ReplaceWith := "", ToReplace*) {
    oldstring := clip := clipboard
    if ReplaceWith = ""
        ReplaceWith := A_Space

    for _, v in ToReplace {
        clip := StrReplace(clip, v, ReplaceWith)
    }
    clipboard := clip
    MsgBox, % "clipboard set to : `n`n " clipboard
    return clipboard
}




!q::
 counter := ++0
ToolTip, count, 1850, 1020,

Gui, Add, Button, gCtrlEvent vButton1, Button 1
Gui, Add, Button, gCtrlEvent vButton2, Button 2
Gui, Add, Button, gGoButton, Go Button
Gui, Add, Edit, vEditField, Example text
Gui, Show,, Functions instead of labels
return 

#+r::
	Send ^c
	Sleep 100
	CreateMenu("mRef", menuReferenceTools, "ReferenceTools")
	Menu mRef, Show
Return

ReferenceTools:
	RunMenuItem(menuReferenceTools, A_ThisMenuItemPos)
Return

CreateMenu(_menuName, _menuDef, _menuLabel){
	Loop Parse, _menuDef, `n
	{
		If (Mod(A_Index, 2) = 1) ; Odd
		{
			Menu %_menuName%, Add, %A_LoopField%, %_menuLabel%
		}
	}
}

RunMenuItem(_menuDef, _index){
	Loop Parse, _menuDef, `n
	{
		If (_index * 2 = A_Index)
		{
			StringReplace toRun, A_LoopField, @@, %Clipboard%, All
			Run %toRun%
			Break
		}
	}
}



GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, Go has been clicked! The content of the edit field is "%EditField%"!
/*	str := "AlterClipboard(ReplaceWith, ToReplace*) {`n"
	str .= "    clip := clipboard`n"
	str .= "    for _, v in ToReplace {`n"
	str .= "        clip := StrReplace(clip, v, ReplaceWith)`n"
	str .= "    }`n"
	str .= "    clipboard := clip`n"
	str .= "}"
	*/
	
	clipboard := str
	AlterClipboard(" " , StrSplit("()}{:=,")*)
	msgbox % clipboard
return 

}





CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}

/*GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
*/
return




/*
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
    */



