;  Menu, MenuName, Add [, MenuItemName, LabelOrSubmenu, Options]
Menu, tray2, Add, Notepad, RunCommand
Menu, tray2, Add, Calc, RunCommand
Menu, tray2, Add, Cmd, RunCommand
Return

RunCommand:
MsgBox, % A_ThisMenuItem
    if (A_ThisMenuItem = "Notepad")
    {
    MsgBox, % "0:"
        Run notepad.exe
    }
    else if (A_ThisMenuItem = "Calc")
    {
        MsgBox, % "0:"
        Run calc.exe
    }
    Else if (A_ThisMenuItem = "Cmd")
    {
        MsgBox, % "0:"
        run cmd.exe
    }
Return

ESC & 6:: Menu, tray2, show ; Show menu