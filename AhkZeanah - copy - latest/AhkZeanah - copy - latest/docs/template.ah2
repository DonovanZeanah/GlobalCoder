

#Requires AutoHotkey v2.0-beta.7 
#warn all, off
;alt + b to run v2 code (debug)
;^+b to run without debug

a::
{
msgbox("hello")
no := FileExist(A_AhkPath)
MsgBox(no)
}