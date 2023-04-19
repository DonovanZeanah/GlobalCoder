#warn all, off

/*
The function takes five optional parameters: Prompt, Title, Options, aChoices, and VarDefault. These parameters are used to set the text prompt, window title, drop-down list options, default value, and other GUI options.

The Object() function is used to create an empty object that will be used to store the selected value.

A new GUI window is created using the Gui() function, with the Options and Title parameters passed in if they were provided.

If the Prompt parameter is provided, a text prompt is added to the GUI using the AddText() method.

A drop-down list control is added to the GUI using the AddDropDownList() method. The w160 option sets the width of the control to 160 pixels, and the vNewValue option assigns the selected value to a variable called NewValue. The aChoices parameter is passed in as the list of options to be displayed in the drop-down list control.

If the VarDefault parameter is provided, the default value is set to the provided value using the Text property of the drop-down list control.

An "OK" button is added to the GUI using the AddButton() method. The w75 option sets the width of the button to 75 pixels. An OnEvent() method is chained to the button to listen for a click event. When the button is clicked, the Submit() method of the GUI is called to retrieve the selected value and store it in the oValues object.

A "Cancel" button is added to the GUI using the AddButton() method. The yp x+10 w75 option sets the position and width of the button. Another OnEvent() method is chained to the button to listen for a click event. When the button is clicked, the NewValue property of the oValues object is set to "Cancel", and the GUI is destroyed.

An OnEvent() method is added to the GUI to listen for a "Close" event. When the GUI is closed (either by clicking the "X" button or pressing Alt+F4), the NewValue property of the oValues object is set to "Cancel", and the GUI is destroyed.

The GUI window is displayed using the Show() method.
The WinWaitClose() function is used to wait for the GUI to be closed before returning the selected value.

The NewValue property of the oValues object is returned as the selected value.
*/

;#Requires AutoHotkey v2.0
InputBoxDropDownList("test")

InputBoxDropDownList(Prompt,Title?,Options?,aChoices?, VarDefault?){
    oValues := Object() ; allows to return
        
    DDLGui := Gui(Options ?? Unset, Title ?? Unset)
        ;This line creates a new GUI window using the Gui() function. The Options and Title parameters are passed in if
        ; they were provided, otherwise Unset is used as a default value. The resulting GUI object is assigned to the variable DDLGui.
        
    (IsSet(Prompt)) ? DDLGui.AddText(,Prompt) : ""
        ;This line adds a text prompt to the GUI window using the AddText() method. 
        ;The Prompt parameter is passed in if it was provided, and an empty string is used if it was not provided. 
        ;The IsSet() function is used to check if the Prompt parameter was provided.

    ogDDL := DDLGui.AddDropDownList("w160 vNewValue", aChoices ?? [] )
        ;This line adds a drop-down list control to the GUI window using the AddDropDownList() method. 
        ;The w160 option sets the width of the control to 160 pixels, and the vNewValue option assigns the 
        ;selected value to a variable called NewValue. The aChoices parameter is passed in as the list of options to 
        ;be displayed in the drop-down list control. An empty array is used as the default value if aChoices was not provided.

    (IsSet(VarDefault)) ? ogDDL.Text := VarDefault : ""
        ;This line sets the default value of the drop-down list control to the value of the VarDefault parameter, if it was provided. The Text property of the control is set to the value of VarDefault using a ternary operator. If VarDefault was not provided, an empty string is used.

    DDLGui.AddButton("w75","OK").OnEvent("Click", (*)=>(oValues := DDLGui.Submit()))
        ;This line adds an "OK" button to the GUI window using the AddButton() method. 
        ;The w75 option sets the width of the button to 75 pixels. An OnEvent() method is chained to the button to
        ; listen for a click event. When the button is clicked, the Submit() method of the GUI is called to retrieve 
        ;the selected value and store it in the oValues object.

    DDLGui.AddButton("yp x+10 w75","Cancel").OnEvent("Click", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
        ;This line adds a "Cancel" button to the GUI window using the AddButton() method. 
        ;The yp x+10 w75 option sets the position and width of the button. Another OnEvent() method is chained 
        ;to the button to listen for a click event. When the button is clicked, 
        ;the NewValue property of the oValues object is set to "Cancel", and the GUI is destroyed.

    DDLGui.OnEvent("Close", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
        ;This line adds an `OnEvent()` method to the GUI window to listen for a "Close" event. 
        ;When the GUI is closed (either by clicking the "X" button or pressing Alt+F4), 
        ;the `NewValue` property of the `oValues` object is set to "Cancel", and the GUI is destroyed.

    DDLGui.Show()

    WinWaitClose(DDLGui)
        ;This line waits for the GUI window to be closed before continuing execution. 
        ;The `WinWaitClose()` function blocks the script until the specified window (`DDLGui` in this case) is closed.


    return oValues.NewValue
        ;This line returns the selected value as a string. 
        ;The `NewValue` property of the `oValues` object is used to retrieve the selected value. 
        ;If the user clicked the "OK" button, the selected value will be the option they chose from the drop-down list.
        ;If the user clicked the "Cancel" button or closed the GUI window, the selected value will be the string "Cancel".
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