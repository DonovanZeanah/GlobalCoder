


MenuOne := new Menu("FirstMenu") ; create the first menu
MenuTwo := new Menu("SecondMenu") ; create the second menu
MenuTwo.Standard() ; add the standard items to the second menu
MenuOne.AppendItem("Item One", "LabelSample") ; sample item that calls a label
MenuOne.AppendItem("Item Two", "FunctionSample") ; sample item that calls a function
MenuOne.AddSeparator() ; add a separator
MenuOne.AppendItem("Item Three", "LabelFunction") ; sample item that calls a label, the script has a function of the same name but the default behavior will call the label subroutine
MenuOne.AppendItem("LabelSample") ; using the MenuItemName as the label
MenuOne.AddSeparator()
MenuOne.AppendItem("FunctionSample") ; using the MenuItemName as the function
MenuOne.AddSubMenu(MenuTwo, "Open submenu") ; opens a submenu, notice that for the"MenuName" parameter, the object instance is used instead of the actual menu's name

i := 0
Gui , Add , Button , x13 y13 w406 h26 vButton1, Right click on this button to show the first menu
Gui , Add , Button , x13 y51 w406 h26 vButton2, Right click on this button to show the second menu
Gui , Add , Button , x13 y89 w406 h26 gInsert vButton3, Click this button and see what happens.
Gui , Show , x486 y315 w428 h127 , Menu Demo
return

GuiContextMenu:
Gui, Submit, NoHide
if (A_GuiControl == "Button1")
MenuOne.Show() ; show the first menu
if (A_GuiControl == "Button2")
MenuTwo.Show() ; show the second menu
return

GuiClose:
MenuOne.Destroy()
MenuTwo.Destroy()
ExitApp

Insert:
i++
Inserted := "Inserted Item " i
MenuOne.InsertItem(Inserted, 4, "LabelSample")
MsgBox, An item was inserted at position 4 of the first menu.
MenuOne.InsertSeparator(6)
MsgBox, A separator was inserted at position 6 of the first menu.
MenuOne.MoveItem("Open submenu")
MsgBox, The last item named "Open submenu" was moved up.
return

LabelSample:
MsgBox, This item calls a label subroutine.
return

LabelFunction:
MsgBox, Right now this item called a label subroutine`nSelect the item again and it will call a function of the same name as the current label.
MenuOne.ModifyItem("Item Three", "LabelFunction", false) ; by setting "mode" to "false", the item will now call the function of the same name
return

FunctionSample() {
MsgBox, This item calls a function.
}

LabelFunction() {
global MenuOne
MsgBox, This item is now calling a function.`nSelect it again and it will call the label of the same name as this function.
MenuOne.ModifyItem("Item Three", "LabelFunction") ; behavior is back to default, the item will call the label subroutine instead of this function
}







/*;====================================================/*;=======================================================================================

class: Menu

;=======================================================================================

*/



class Menu

{

static MenuList := [], MenuCount := 0, RetVal := ""



__New(MenuName) { ; Creates a new menu

this.Instance := true, this.Name := MenuName, this.ItemCount := 0, this.MenuItems := []

if (this.Name <> "Tray")

this.AddSeparator(), this.RemoveAll()

this.IsStandard := this.Name == "Tray" ? true : false

Menu.MenuCount++

}



__Delete() {

}



AppendItem(MenuItemName, LabelorFunction="", mode=true) {

if !this.IsInstance()

return

if (this.ItemCount >= 1)

for k, v in this.MenuItems

if (v["MenuItem"] == MenuItemName) {

MsgBox, Menu item "%MenuItemName%" already exists!

return

}

this.SetItemAction(MenuItemName, LabelorFunction, mode)

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))

this.AppendToList(MenuItemName, LabelorFunction <> "" ? LabelorFunction : MenuItemName, mode)

}



AddSubMenu(MenuName, MenuItemName) {

if !this.IsInstance()

return

Menu, % this.Name, Add, % MenuItemName, % IsObject(MenuName) ? ":" MenuName.Name : ":" MenuName

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))

this.AppendToList(MenuItemName, IsObject(MenuName) ? this.GetMenuHandle(MenuName.Name) : this.GetMenuHandle(MenuName))

}



AddSeparator() {

if !this.IsInstance()

return

Menu, % this.Name, Add

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))

this.AppendToList("", "")

}



ModifyItem(MenuItemName, Param="", mode=true) {

if !this.IsInstance()

return

if (IsObject(Param) || InStr(Param, ":") == 1) { ; Converted to submenu

Menu, % this.Name, Add, % MenuItemName, % IsObject(Param) ? ":" Param.Name : Param

this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := IsObject(Param) ?this.GetMenuHandle(Param.Name) : this.GetMenuHandle(SubStr(Param, 2))

this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := true ; reset mode to "true" if item is converted to submenu

} else { ; New label or function

this.SetItemAction(MenuItemName, Param, mode)

this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := Param <> "" ? Param : MenuItemName

this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := mode

}

}



RenameItem(MenuItemName, NewName="") { ; if blank, MenuItemName will be converted to a separator. This action cannot be undone.

if !this.IsInstance()

return

Menu, % this.Name, Rename, % MenuItemName, % NewName

NewName <> "" ? this.MenuItems[this.GetItemPos(MenuItemName), "MenuItem"] := NewName : this.MenuItems[this.GetItemPos(MenuItemName), "MenuItem"] := "", this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := "", this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := true ; reset mode to "true" if item is converted to a separator

}



RemoveItem(MenuItemNameorPos, ByName=true, Occurrence=1) { ; If item name is blank(""), this method will remove a separator. By default it will remove the first. Specify "2" for the "Occurrence" parameter to remove the second, "3" for third, and so on... Set "ByName" parameter to "false" if you want to specify the menu item's position instead for the "MenuItemNameorPos" parameter.

if !this.IsInstance()

return

ByName := ByName == "" ? true : ByName ; set to "true"(default) if parameter is blank("")

if (ByName && MenuItemNameorPos <> "") ; Normal item

Menu, % this.Name, Delete, % MenuItemName

else if (ByName && MenuItemNameorPos == "") ; Separator

DllCall("RemoveMenu", Int, this.GetMenuHandle(this.Name), UInt, this.GetItemPos(MenuItemNameorPos, Occurrence)-1, UInt, "0x00000400L")

else { ; By position

if (this.MenuItems[MenuItemNameorPos, "MenuItem"] <> "") ; Normal Item

Menu, % this.Name, Delete, % this.MenuItems[MenuItemNameorPos, "MenuItem"]

else ; Separator

DllCall("RemoveMenu", Int, this.GetMenuHandle(this.Name), UInt, MenuItemNameorPos-1, UInt, "0x00000400L")

}

this.MenuItems.Remove(ByName ? this.GetItemPos(MenuItemNameorPos, MenuItemNameorPos == "" ? Occurrence : 1) : MenuItemNameorPos)

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))

}



RemoveAll() {

if !this.IsInstance()

return

Menu, % this.Name, DeleteAll

this.IsStandard ? (this.Standard(false), this.MenuItems.Remove(1, this.MenuItems.MaxIndex()), this.Standard()) : this.MenuItems.Remove(1, this.MenuItems.MaxIndex()) ; if Menu contains the standard items, remove them temporarily, clear the list, and add them back again

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))

}



SetItem(MenuItemName, Options="") { ; "Options" can be any of the following(space-delimited): Check, Uncheck, ToggleCheck, Enable, Disable, ToggleEnable

if !this.IsInstance()

return

if (Options <> "") { ; nothing is altered if omitted

Options := RegExReplace(Options, "S) +", A_Space) ; replace multiple spaces with a single space

Loop, Parse, Options, % A_Space

if A_LoopField in Check,Uncheck,ToggleCheck,Enable,Disable,ToggleEnable ; check if option is valid, if not, nothing is altered

Menu, % this.Name, % A_LoopField, % MenuItemName

}

}



Default(MenuItemName="") {

if !this.IsInstance()

return

Menu, % this.Name, Default, % MenuItemName

}



Standard(param=true) {

if !this.IsInstance()

return

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name)) ; get menu item count prior to adding the standard items

Menu, % this.Name, % param ? "Standard" : "NoStandard"

if param {

for k, v in ["Open", "Help", "", "Window Spy", "Reload This Script", "Edit This Script", "", "Suspend Hotkeys", "Pause Script", "Exit"]

this.ItemCount++, this.AppendToList(v, "`nStdItem")

} else {

a := "", b := 0 ; counters: a=index of the first standard item | b=index of the last standard item

for k, v in this.MenuItems

if (v["LabelorFunction"] == "`nStdItem")

a := b <= 0 ? k : a, b := b <= 0 ? k : b+1

this.MenuItems.Remove(a, Posted Image) ; remove the standard items from array

}

this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name)) ; Get the new item count

this.IsStandard := param

}



SetIcon(MenuItemName, FileName, IconNumber="", IconWidth="") {

if !this.IsInstance()

return

Menu, % this.Name, Icon, % MenuItemName, % FileName, % IconNumber, % IconWidth

}



RemoveIcon(MenuItemName) {

if !this.IsInstance()

return

Menu, % this.Name, NoIcon, % MenuItemName

}



Destroy() {

if !this.IsInstance()

return

for k, v in Menu.MenuList

for a, b in v

if (b["LabelorFunction"] == this.GetMenuHandle(this.Name)) ; Remove item entries in list for other items that is using the currently destoyed menu as a submenu.

v.Remove(a)

Menu, % this.Name, Delete

Menu.MenuList.Remove(this.Name)

this.Instance := false, this.Name := "", this.ItemCount := "", this.MenuItems := ""

Menu.MenuCount--

}



Show(X="", Y="", CoordMode="") {

if !this.IsInstance()

return

if (CoordMode && X<>"" || Y<>"") {

if CoordMode in Screen,Relative,Window,Client

CoordMode, Menu, % CoordMode

}

Menu, % this.Name, Show, % X, % Y

}



InsertItem(MenuItemName, Pos, Param="", mode=true) {

if !this.IsInstance()

return

this.AppendItem(MenuItemName, Param, mode)

count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount

Loop, % count - Pos

this.MoveItem(MenuItemName)

}



InsertSubMenu(MenuName, MenuItemName, Pos) {

if !this.IsInstance()

return

this.AddSubMenu(MenuName, MenuItemName)

count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount

Loop, % count - Pos

this.MoveItem(MenuItemName)

}



InsertSeparator(Pos) {

if !this.IsInstance()

return

this.AddSeparator()

xpos := this.ItemCount ; get the newly appended separator's position

count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount

Loop, % count - Pos

xpos := this.MoveItem(xpos, true, false)

}



MoveItem(MenuItemNameorPos, up=true, ByName=true) {

if !this.IsInstance()

return

up := up == "" ? true : up ; set to "true"(default) if parameter is blank("")

items := [], oldh := [] ; Objects to temporarily hold menus/menu items properties after removal

pos := ByName ? this.GetItemPos(MenuItemNameorPos) : MenuItemNameorPos

xpos := up ? pos-1 : pos+1

if (up && pos <= 1 || !up && pos >= this.ItemCount) ; Unable to move item due to its postition and the associated direction

return

if (this.MenuItems[xpos, "LabelorFunction"] == "`nStdItem")

xpos := up ? xpos-9 : xpos+9

for k, v in this.MenuItems

items[k] := {name: v["MenuItem"], action: v["LabelorFunction"], mode: v["Mode"]}

items.Insert(xpos, items.Remove(pos))

for m in Menu.MenuList ; Retrieve handle of menus, menu(s) which are being used as submenu(s) gets a new handle if the item that opens it is removed

oldh[m] := this.GetMenuHandle(m) ; store handle(s) in object for later comparison

this.IsStandard ? (this.Standard(false), RemoveStd := true, this.RemoveAll()) : this.RemoveAll()

for a, b in items {

item := b["name"], action := b["action"], mode := b["mode"]

if (action <> "`nStdItem") {

if (item <> "") { ; Item is not a separator

if (!IsLabel(action) && !IsFunc(action)) { ; Item opens a submenu

for m in Menu.MenuList ; Retrieve new menu handle(s)

if (oldh[m] <> this.GetMenuHandle(m) && oldh[m] == action) ; compare handle changes and filter out the new handle

this.AddSubMenu(m, item)

} else if (IsLabel(action) || IsFunc(action)) ; Normal item

this.AppendItem(item, action, mode)

} else ; Item is a separator

this.AddSeparator()

} else if (action == "`nStdItem" && RemoveStd == true)

this.Standard(), RemoveStd := false

}

return xpos ; return the new position of the item

}



GetItemPos(MenuItemName, Occurrence=1) {

if !this.IsInstance()

return

i := 0

for k, v in this.MenuItems

if (MenuItemName == v["MenuItem"] && MenuItemName <> "")

return k

else if (MenuItemName == v["MenuItem"] && MenuItemName == "" && v["LabelorFunction"] <> "`nStdItem") {

i++

if (i == Occurrence)

return k

}

}



;~ Miscellaneous Commands



SetColor(ColorValue="Default", Single=false) {

if !this.IsInstance()

return

Menu, % this.Name, Color, % ColorValue, % Single ? "Single" : ""

}



UseErrorLevel(param=false) {

if !this.IsInstance()

return

Menu, % this.Name, UseErrorLevel, % param ? "" : "Off"

}



;~==========================================

;~ Tray-specific methods/functions - MenuName must be "Tray"

;~==========================================



TrayIcon(FileName="", IconNumber="", state=0) { ; Omit all parameters to create the tray icon if it isn't already present

if !this.IsInstance()

return

if (this.Name == "Tray") ; verify if the "Tray" is the Menu name

Menu, % this.Name, Icon, % FileName, % IconNumber, % (FileName == "" && IconNumber == "") ? "" : state

}



TrayNoIcon() {

if !this.IsInstance()

return

if (this.Name == "Tray")

Menu, % this.Name, NoIcon

}



TrayTip(Text="") {

if !this.IsInstance()

return

if (this.Name == "Tray")

Menu, % this.Name, Tip, % Text

}



TrayClick(ClickCount=2) {

if !this.IsInstance()

return

if (this.Name == "Tray")

Menu, % this.Name, Click, % ClickCount

}



TrayMainWindow(default=true) {

if !this.IsInstance()

return

if (this.Name == "Tray")

Menu, % this.Name, % default ? "NoMainWindow" : "MainWindow"

}



;~=======================================

; The following methods are for internal use only, Do not use.

;~=======================================



SetItemAction(MenuItemName, LabelorFunction="", mode=true) { ; Internal use only

if (LabelorFunction <> "") {

x := [LabelorFunction, "MenuItemFunctionHandlerLabel", mode ? LabelorFunction : "MenuItemFunctionHandlerLabel"]

Menu, % this.Name, Add, % MenuItemName, % x[this.GetActionType(LabelorFunction)]

} else {

x := ["", "MenuItemFunctionHandlerLabel", mode ? "" : "MenuItemFunctionHandlerLabel"]

Menu, % this.Name, Add, % MenuItemName, % x[this.GetActionType(MenuItemName)]

}

}



GetActionType(Action) { ; 1=Label, 2=Function, 3=Both | Internal use only

if (IsLabel(Action) && !IsFunc(Action))

return 1

else if (IsFunc(Action) && !IsLabel(Action))

return 2

else if (IsLabel(Action) && IsFunc(Action))

return 3

}



MenuItemFunctionHandler() { ; This method is for internal use only

return ; return when this method is called

MenuItemFunctionHandlerLabel: ; This label is for internal use only

if (Menu.MenuList[A_ThisMenu][A_ThisMenuItemPos, "MenuItem"] == A_ThisMenuItem)

ItemFunc := Func(Menu.MenuList[A_ThisMenu][A_ThisMenuItemPos, "LabelorFunction"]), Menu.RetVal := ItemFunc.()

return

}



AppendToList(MenuItemName, LabelorFunction, mode=true) { ; Internal use only

this.MenuItems[this.ItemCount] := {MenuItem: MenuItemName, LabelorFunction: LabelorFunction, Mode: mode}

Menu.MenuList[this.Name] := this.MenuItems

}



GetMenuHandle(MenuName) {

static h_menuDummy

If !h_menuDummy { ; v2.2: Check for !h_menuDummy instead of h_menuDummy="" in case init failed last time.

Menu, menuDummy, Add

Menu, menuDummy, DeleteAll

Gui, 99:Menu, menuDummy

Gui, 99:+LastFound ; v2.2: Use LastFound method instead of window title. [Thanks animeaime.]

h_menuDummy := DllCall("GetMenu", "uint", WinExist())

Gui, 99:Menu

Gui, 99:Destroy

if !h_menuDummy ; v2.2: Return only after cleaning up. [Thanks animeaime.]

return 0

}

Menu, menuDummy, Add, :%MenuName%

h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )

DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400 )

Menu, menuDummy, Delete, :%MenuName%

return h_menu

}



GetMenuName(MenuHandle) {

for m in Menu.MenuList

if (this.GetMenuHandle(m) == MenuHandle)

return m

}



IsInstance() {

if (!this.Instance)

MsgBox, 16, % A_ScriptName, Menu or menu object does not exist! Please create a new instance using "__New".

return this.Instance

}



}