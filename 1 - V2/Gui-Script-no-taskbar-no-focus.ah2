MyGui := Gui(, "Title of Window")
MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button.
MyGui.Add("Text",, "Some text to display.")
MyGui.Show("NoActivate")  ; NoActivate avoids deactivating the currently active window.