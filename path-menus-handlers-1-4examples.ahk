 ;Adds a new menu item to the bottom of the tray icon menu.

#Persistent  ; Keep the script running until the user exits it.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Item1, MenuHandler  ; Creates a new menu item.
return

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
return
 Creates a popup menu that is displayed when the user presses a hotkey.

; Create the popup menu by adding some items to it.
Menu, MyMenu, Add, Item1, MenuHandler
Menu, MyMenu, Add, Item2, MenuHandler
Menu, MyMenu, Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Menu, Submenu1, Add, Item1, MenuHandler
Menu, Submenu1, Add, Item2, MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
Menu, MyMenu, Add, My Submenu, :Submenu1

Menu, MyMenu, Add  ; Add a separator line below the submenu.
Menu, MyMenu, Add, Item3, MenuHandler  ; Add another menu item beneath the submenu.
return  ; End of script's auto-execute section.

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return

#z::Menu, MyMenu, Show  ; i.e. press the Win-Z hotkey to show the menu.



 ;Demonstrates some of the various menu sub-commands.

#Persistent
#SingleInstance
Menu, Tray, Add ; separator
Menu, Tray, Add, TestToggle&Check
Menu, Tray, Add, TestToggleEnable
Menu, Tray, Add, TestDefault
Menu, Tray, Add, TestStandard
Menu, Tray, Add, TestDelete
Menu, Tray, Add, TestDeleteAll
Menu, Tray, Add, TestRename
Menu, Tray, Add, Test
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TestToggle&Check:
Menu, Tray, ToggleCheck, TestToggle&Check
Menu, Tray, Enable, TestToggleEnable ; Also enables the next test since it can't undo the disabling of itself.
Menu, Tray, Add, TestDelete ; Similar to above.
return

TestToggleEnable:
Menu, Tray, ToggleEnable, TestToggleEnable
return

TestDefault:
if (Default = "TestDefault")
{
    Menu, Tray, NoDefault
    Default := ""
}
else
{
    Menu, Tray, Default, TestDefault
    Default := "TestDefault"
}
return

TestStandard:
if (Standard != false)
{
    Menu, Tray, NoStandard
    Standard := false
}
else
{
    Menu, Tray, Standard
    Standard := true
}
return

TestDelete:
Menu, Tray, Delete, TestDelete
return

TestDeleteAll:
Menu, Tray, DeleteAll
return

TestRename:
if (NewName != "renamed")
{
    OldName := "TestRename"
    NewName := "renamed"
}
else
{
    OldName := "renamed"
    NewName := "TestRename"
}
Menu, Tray, Rename, %OldName%, %NewName%
return

Test:
MsgBox, You selected "%A_ThisMenuItem%" in menu "%A_ThisMenu%".
return







; Demonstrates how to add icons to menu items.

Menu, FileMenu, Add, Script Icon, MenuHandler
Menu, FileMenu, Add, Suspend Icon, MenuHandler
Menu, FileMenu, Add, Pause Icon, MenuHandler
Menu, FileMenu, Icon, Script Icon, %A_AhkPath%, 2 ; Use the 2nd icon group from the file
Menu, FileMenu, Icon, Suspend Icon, %A_AhkPath%, -206 ; Use icon with resource identifier 206
Menu, FileMenu, Icon, Pause Icon, %A_AhkPath%, -207 ; Use icon with resource identifier 207
Menu, MyMenuBar, Add, &File, :FileMenu
Gui, Menu, MyMenuBar
Gui, Add, Button, gExit, Exit This Example
Gui, Show
return

MenuHandler:
return

Exit:
ExitApp