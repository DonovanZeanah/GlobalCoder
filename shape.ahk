; type shape to activate
:*:shape:: 
MsgBox, typed
    ; add shapes to context menu
    Menu, shapeMenu, Add, triangle, shapeMenuHandler
    Menu, shapeMenu, Add, square, shapeMenuHandler
    Menu, shapeMenu, Add, pentagon, shapeMenuHandler

    caret := GetCaret()
    ; show pop up at caret locationx and caretlocationy + 30
    Menu, shapeMenu, Show, % caret.x, % caret.y + 30
Return

shapeMenuHandler:
    ; Send the name of the selected context menu item
    Send % A_ThisMenuItem
Return

GetCaret() {
    If (A_CaretX) {
        return { x: A_CaretX, y: A_CaretY } ; get caret using A_CaretX and A_CaretY
    }
    Else {                                  ; if A_CaretX and A_CaretY cannot be found, use acc method
        Sleep, 20
        caret := Acc_ObjectFromWindow(WinExist("A"), OBJID_CARET := 0xFFFFFFF8)
        caretLocation := Acc_Location(caret)
        WinGetPos, winX, winY
        x := (caretLocation.x - winX)
        y := (caretLocation.y - winY)
        return { x: x, y: y }
    }
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
    static h := DllCall("LoadLibrary","Str","oleacc","Ptr")
    If   DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
    Return ComObjEnwrap(9,pacc,1)
}

Acc_Location(Acc, ChildId=0, byref Position="") { ; adapted from Sean's code
    try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
    catch
        return
    Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
    return {x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}
}