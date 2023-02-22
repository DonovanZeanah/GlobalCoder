 F1::
    CoordMode Menu, Screen
    GetCaret(X, Y,, H)
    Menu, MyMenu, Add, Menu Item 1, MenuHandler
    Menu, MyMenu, Add, Menu Item 2, MenuHandler
    Menu, MyMenu, Add, Menu Item 3, MenuHandler
    Menu, MyMenu, Show, % X, % Y + H
return
    guilabel:
    gui, menu, mymenu

;// if menu item 1
;create this gui with an edit and button // used to add snips.txt to /snips folder

    ; Create the main Edit control and display the window:
Gui, +Resize, ;+NoActivate  ; Make the window resizable.
Gui, Add, Edit, vMainEdit WantTab W300 R20
Gui, Add, Button, gGoButton1, Go Button
Gui, Show, ,% X, % Y + H, Functions instead of labels
CurrentFileName := ""  ; Indicate that there is no current file.

;// if menu item 2
; make a button for each file in /snips that displays file preview
; when clicked

;// if menu 3
;launch gui.ah2 via c/PF/autohotkey/v2/autohotkey.exe that 
;awaits the exit key to both close ah2 gui & continue/ return from 3rd menu
;function/label


;Gui, Add, Button, gCtrlEvent vButton1, Button 1
;;Gui, Add, Button, gCtrlEvent vButton2, Button 2
;Gui, Add, Button, gGoButton, Go Button
;Gui, Add, Edit, w300 hvEditField, Example text
;Gui, Show,, Functions instead of labels

/*CtrlEvent1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
*/
menuhandler:
Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit, vMainEdit1 WantTab W300 R20
Gui, Add, Button, gGoButton1, Go Button
Gui, Show,% X, % Y + H, Functions instead of labels
CurrentFileName := ""  ; Indicate that there is no current fi
MsgBox, % "0: `n " mymenu
return
GoButton1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    gui, Submit
    GuiControlGet, mainedit1
    MsgBox, % "Go has been clicked! The content of the edit field is " . mainedit1
}

/*GuiClose1(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
*/
return


if (A_PriorHotkey = "/" || A_ThisHotkey = "/")
;{
    ;Input, [ OutputVar, Options, EndKeys, MatchList]
Input, UserInput, V T5 L10 C, {enter}.{esc}{tab}, gclass,otoh,fl,ahk,ca
switch ErrorLevel
;MenuHandler:

{
case "Max":
    MsgBox, You entered "%UserInput%", which is the maximum length of text.
    return
case "Timeout":
    MsgBox, You entered "%UserInput%" at which time the input timed out.
    return
case "NewInput":
    return
default:
    if InStr(ErrorLevel, "EndKey:;")
    {
        string := userinput
        ;resultstring := clipsendw(string)
        MsgBox, % "You entered " resultstring ;%UserInput%" and terminated the input with %ErrorLevel%.
        return ;resultstring := clipsendw(string)

    }
}
switch UserInput
{
case "gcl":   send, ^V ;clipsendw(resultstring) ;Send, {backspace 4}by the way
case "otoh":  Send, {backspace 5}on the other hand
case "fl":    Send, {backspace 3}Florida
case "ca":    Send, {backspace 3}California
case "ahk":   Run, https://www.autohotkey.com
}
return

    ; do something

;Here's the GetCaret Function:

GetCaret(ByRef X:="", ByRef Y:="", ByRef W:="", ByRef H:="") {

    ; UIA caret
    static IUIA := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
    ; GetFocusedElement
    DllCall(NumGet(NumGet(IUIA+0)+8*A_PtrSize), "ptr", IUIA, "ptr*", FocusedEl:=0)
    ; GetCurrentPattern. TextPatternElement2 = 10024
    DllCall(NumGet(NumGet(FocusedEl+0)+16*A_PtrSize), "ptr", FocusedEl, "int", 10024, "ptr*", patternObject:=0), ObjRelease(FocusedEl)
    if patternObject {
        ; GetCaretRange
        DllCall(NumGet(NumGet(patternObject+0)+10*A_PtrSize), "ptr", patternObject, "int*", IsActive:=1, "ptr*", caretRange:=0), ObjRelease(patternObject)
        ; GetBoundingRectangles
        DllCall(NumGet(NumGet(caretRange+0)+10*A_PtrSize), "ptr", caretRange, "ptr*", boundingRects:=0), ObjRelease(caretRange)
        ; VT_ARRAY = 0x20000 | VT_R8 = 5 (64-bit floating-point number)
        Rect := ComObject(0x2005, boundingRects)
        if (Rect.MaxIndex() = 3) {
            X:=Round(Rect[0]), Y:=Round(Rect[1]), W:=Round(Rect[2]), H:=Round(Rect[3])
            return
        }
    }

    ; Acc caret
    static _ := DllCall("LoadLibrary", "Str","oleacc", "Ptr")
    idObject := 0xFFFFFFF8 ; OBJID_CARET
    if DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", WinExist("A"), "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc:=0)=0 {
        oAcc := ComObjEnwrap(9,pacc,1)
        oAcc.accLocation(ComObj(0x4003,&_x:=0), ComObj(0x4003,&_y:=0), ComObj(0x4003,&_w:=0), ComObj(0x4003,&_h:=0), 0)
        X:=NumGet(_x,0,"int"), Y:=NumGet(_y,0,"int"), W:=NumGet(_w,0,"int"), H:=NumGet(_h,0,"int")
        if (X | Y) != 0
            return
    }

    ; default caret
    CoordMode Caret, Screen
    X := A_CaretX
    Y := A_CaretY
    W := 4
    H := 20
}