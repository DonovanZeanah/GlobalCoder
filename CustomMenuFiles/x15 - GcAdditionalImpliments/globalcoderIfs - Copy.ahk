

Menu, Tray, Icon , Shell32.dll, 15 , 1






;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ sublime ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive, ahk_exe sublime_text.exe
f16::send, ^{tab}
return

f19::send, ^+{tab}
return


; KeyIsDown := GetKeyState(KeyName , Mode) 
; an explicit virtual key code such as vkFF may be specified.
; p specify phyiscal state

/*if GetKeyState("0727--2307
button","p") && 
:*:pot::

*/
#if
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[ end ]x=[]


;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[chrome]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive, ahk_exe chrome.exe

if !FileExist("p:\app\app\achrome\((chrome)).txt")
fileappend, %clipboard% - time `n, p:\app\app\achrome\((chrome)).txt
return

xbutton2 & w::
send := clipboard . "`n"
;send := send . "`n"
clipboard := send
oWord := ComObjActive("Word.Application")
oWord.Selection.PasteAndFormat(0)  ; Original Formatting
send := ""
clipboard := ""
return

#if ;//chrome
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[end]x=[]



;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[f13 toggle]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
#if (Toggle) 
*F13::
winactivate, ahk_exe sublime_text.exe
send, {F3}
return
#if


;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ mbutton held ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]

#if GetKeyState("mbutton","p") 
:*:pot::
msgbox,  it worpotks
return

#if

#if GetKeyState("~`","p") 
:*:pot::
msgbox,  it worpotks
return
#if



;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive, ahk_exe explorer.exe

xbutton2 & p::
send, ^l 
send, P:/app/app 
sleep, 300
send, {enter}
return

 F1::
 MsgBox % Explorer_GetSelection()
return
;==============================[]=================================[]
+RButton::
Click
send, {AppsKey}
return
;==============================[]=================================[]


/*
xbutton2::send, ^+{tab}
;==============================[]=================================[]
xbutton1::send, ^{tab}
;==============================[]=================================[]
*/
#if



;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive, VLC media player


xbutton1::send, +{right}
xbutton2:: send, !{f4}
space::!2
#if



;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive dkz


xbutton2::send, ^+{tab}
xbutton1::send, ^{tab}
^ & xbutton2::
;chrome name window
send, {f6}
send, {tab 8}
send, {enter}
send, l  
send, w 
send, {enter}
send, dkz
send, enter
return
#if


ControlGetText, text, Intermediate D3D Window2, 
ControlGetText, text, Intermediate D3D Window2, ahk_class Chrome_WidgetWin_1
; ControlClick()
#ifWinActive ahk_exe msedge.exe
xbutton2::
send, ^w 
return
xbutton1::
send, ^d 
return
#If
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
#IfWinActive ahk_class Notepad

    F1::
        explorer_path := "" ; empty variable
        IfWinNotExist ahk_class CabinetWClass ; explorer
            return  ; do nothing
        ; otherwise:
        ; https://autohotkey.com/boards/viewtopic.php?p=28751#p28751
        ; get the path of the first explorer window:
        for window in ComObjCreate("Shell.Application").Windows
        {
            try explorer_path := window.Document.Folder.Self.Path
                    break
        }
        ; MsgBox, %explorer_path%
        Send, ^s ; save the new document
        ; wait for the Save As window and activate it
        sleep, 300
        ; open the folder "explorer_path" in Save As
        send, {f4}
        send, ^a
        send, {delete}
        send, P:/app/
        Send, {Enter}
    return
#If
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
  


 /* Explorer_GetSelection(hwnd="") {
    hwnd := hwnd ? hwnd : WinExist("A")
    WinGetClass class, ahk_id %hwnd%
    if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
        for window in ComObjCreate("Shell.Application").Windows
            if (window.hwnd==hwnd)
    sel := window.Document.SelectedItems
    for item in sel
    ToReturn .= item.path "`n"
    return Trim(ToReturn,"`n")
}
*/



