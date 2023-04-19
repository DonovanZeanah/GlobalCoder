#warn all, off

;#Requires AutoHotkey v2.0
InputBoxDropDownList("test")

InputBoxDropDownList(Prompt,Title?,Options?,aChoices?, VarDefault?){
    oValues := Object() ; allows to return
    DDLGui := Gui(Options ?? Unset, Title ?? Unset)
    (IsSet(Prompt)) ? DDLGui.AddText(,Prompt) : ""
    ogDDL := DDLGui.AddDropDownList("w160 vNewValue", aChoices ?? [] )
    (IsSet(VarDefault)) ? ogDDL.Text := VarDefault : ""
    DDLGui.AddButton("w75","OK").OnEvent("Click", (*)=>(oValues := DDLGui.Submit()))
    DDLGui.AddButton("yp x+10 w75","Cancel").OnEvent("Click", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
    DDLGui.OnEvent("Close", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
    DDLGui.Show()
    WinWaitClose(DDLGui)
    return oValues.NewValue
}

/*
;F3::m.Show(x = "" ? unset : x, y = "" ? unset : y)
^F3::
{
    getcaret(&x,&y,&w,&h)
    msgbox(X . " - " . y)
    m.Show(x || unset, y || unset)
}

F4::
{
    m.Show(x = "" ? unset : x, y = "" ? unset : y)

    three(*) {
    MsgBox 3
    }
}
*/