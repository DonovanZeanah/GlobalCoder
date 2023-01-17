
/*
Creates, deletes, modifies and displays menus and menu items. Changes the tray icon and its tooltip. Controls whether the main window of a compiled script can be opened.

Menu, MenuName, SubCommand , Value1, Value2, Value3, Value4
The MenuName parameter can be Tray or the name of any custom menu. A custom menu is automatically created the first time its name is used with the Add sub-command. For example: Menu, MyMenu, Add, Item1. Once created, a custom menu can be displayed with the Show sub-command. It can also be attached as a submenu to one or more other menus via the Add sub-command.

The SubCommand, Value1, Value2, Value3 and Value4 parameters are dependent on each other their usage is described below.

Table of Contents
Sub-commands
The MenuItemName Parameter
Win32 Menus
Remarks
Related
Examples
Sub-commands
For SubCommand, specify one of the following:

Add: Adds a menu item, updates one with a new submenu or label, or converts one from a normal item into a submenu (or vice versa).
Insert [v1.1.23+]: Inserts a new item before the specified menu item.
Delete: Deletes the specified menu item from the menu.
DeleteAll: Deletes all custom menu items from the menu.
Rename: Renames the specified menu item.
Check: Adds a visible checkmark in the menu next to the specified menu item.
Uncheck: Removes the checkmark from the specified menu item.
ToggleCheck: Adds a checkmark to the specified menu item; otherwise, removes it.
Enable: Enables the specified menu item if was previously disabled.
Disable: Disables the specified menu item.
ToggleEnable: Disables the specified menu item; otherwise, enables it.
Default: Changes the menu's default item to be the specified menu item and makes its font bold.
NoDefault: Reverses setting a user-defined default menu item.
Standard: Inserts the standard menu items at the bottom of the menu.
NoStandard: Removes all standard menu items from the menu.
Icon: Changes the script's tray icon or [in v1.0.90+] sets a icon for the specified menu item.
NoIcon: Removes the tray icon or [in v1.0.90+] removes the icon from the specified menu item.
Tip: Changes the tray icon's tooltip.
Show: Displays the specified menu.
Color: Changes the background color of the menu.
Click: Sets the number of clicks to activate the tray menu's default menu item.
MainWindow: Allows the main window of a script to be opened via the tray icon.
NoMainWindow: Prevents the main window from being opened via the tray icon.
UseErrorLevel: Skips any warning dialogs and thread terminations whenever the Menu command generates an error.
Add
Adds a menu item, updates one with a new submenu or label, or converts one from a normal item into a submenu (or vice versa).

Menu, MenuName, Add , MenuItemName, LabelOrSubmenu, Options
This is a multipurpose sub-command. MenuItemName is the name or position of a menu item (see MenuItemName for details). If MenuItemName does not yet exist, it will be added to the menu. Otherwise, MenuItemName is updated with the newly specified LabelOrSubmenu.

To add a menu separator line, omit all three parameters.

The label subroutine is run as a new thread when the user selects the menu item (similar to Gosub and hotkey subroutines). If LabelOrSubmenu is omitted, MenuItemName will be used as both the label and the menu item's name.

[v1.1.20+]: If it is not the name of an existing label, LabelOrSubmenu can be the name of a function, or a single variable reference containing a function object. For example, %FuncObj% or % FuncObj. See example #5 for a fully functional demonstration. Other expressions which return objects are currently unsupported. The function can optionally define parameters as shown below:

FunctionName(ItemName, ItemPos, MenuName)
To have MenuItemName become a submenu -- which is a menu item that opens a new menu when selected -- specify for LabelOrSubmenu a colon followed by the MenuName of an existing custom menu. For example:

Menu, MySubmenu, Add, Item1
Menu, Tray, Add, This menu item is a submenu, :MySubmenu
*/

;#### Demonstrates the usage of BoundFunc objects to pass additional parameters when using a function instead of a subroutine.

; Bind parameters to the function and return BoundFunc objects:
BoundGivePar := Func("GivePar").Bind("First", "Test one")
BoundGivePar2 := Func("GivePar").Bind("Second", "Test two")

; Create the menu and show it:
Menu MyMenu, Add, Give parameters, % BoundGivePar
Menu MyMenu, Add, Give parameters2, % BoundGivePar2
Menu MyMenu, Show

; Definition of custom function GivePar:
GivePar(a, b, ItemName, ItemPos, MenuName)
{
    MsgBox % "a:`t`t" a "`n"
           . "b:`t`t" b "`n"
           . "ItemName:`t" ItemName "`n"
           . "ItemPos:`t`t" ItemPos "`n"
           . "MenuName:`t" MenuName
}


dir = %A_ScriptDir%\t
Menu, docs, Add, Display
Menu, docs, Add, Copy
return

F3::Menu, docs, Show

Display:
list =
For each, file in list(dir)
 list .= file "`n"
MsgBox, 64, List, % Trim(list, "`n")
Return

Copy:
For each, file in list(dir)
 FileCopy, %file%, %A_ScriptDir%\t2
MsgBox, 64, Copied, Done!
Return

list(dir) {
 list := []
 Loop, Files, %dir%\*.docx
  list.Push(A_LoopFilePath)
 Return list
}

;======================================


F3::handler(A_ScriptDir "\t", "display")
F4::handler(A_ScriptDir "\t", "copy")

handler(dir, action) {
 Static fileList := []
 If !fileList.Count() {
  Loop, Files, %dir%\*.docx
   fileList.Push(A_LoopFilePath)
  For each, file in fileList
   Menu, files, Add, %file%, Handle
 }
 Menu, files, Show
 Return
 Handle:
 Switch action {
  Case "display": MsgBox, 64, Happy, %A_ThisMenuItem%
  Case "copy"   : MsgBox, 48, Sad  , %A_ThisMenuItem%
 }
 Return
}
;==================
F3::handler(A_ScriptDir "\t", "display")
F4::handler(A_ScriptDir "\t", "copy")

handler(dir, action) {
 If !FileExist(dir)
  Return
 Try Menu, files, Delete
 Loop, Files, %dir%\*.docx
  Menu, files, Add, %A_LoopFilePath%, %action%
 Menu, files, Show
}

display(itemName, itemPos, menuName) {
 MsgBox, 64, Happy, %itemName%
}

copy(itemName, itemPos, menuName) {
 MsgBox, 48, Sad  , %itemName%
}