<^m:: mymenu.Menu.show ;().HandleKeyInput()
^+m:: anotherMenu.show(200,200)

;mymenuInstance := MyMenu()
anotherMenu := mymenu()

anotherMenu := mymenu(
    Map("More Option 1", anotherMenu.ItemAction,
        "More Option 2", anotherMenu.ItemAction,
        "More Option 3", anotherMenu.ItemAction
    )
)

anotherMenu.Add "Another Option", mymenu.ItemAction

anotherMenu.CreateItems(
    Map("More Option 4", anotherMenu.ItemAction,
        "More Option 5", anotherMenu.ItemAction,
        "More Option 6", anotherMenu.ItemAction
    )
)


anotherMenu := MyMenu(Map("More Option 1", anotherMenu.ItemAction, "More Option 2", anotherMenu.ItemAction, "More Option 3", anotherMenu.ItemAction))


Class MyMenu extends Menu {
    static x := 500 
    static y := 500

    ;static 
    GUI := gui()
    Static menu := menu()
    Static itemss := Map(
        "Option 1", this.ItemAction,
        "Option 2", this.ItemAction,
        "Option 3", this.ItemAction
    )

    Static __New() {
        For itemName, action in this.itemss
            this.Menu.Add itemName, action

        this.Menu.Add
        this.Menu.Add "Toggle", (*) => this.Menu.ToggleCheck("Toggle")
    }

    __New(items?) {
        Menu.Prototype.CreateItems := ObjBindMethod(this, "CreateItems")
        Menu.Prototype.ItemAction := ObjBindMethod(MyMenu, "ItemAction")

        If !IsSet(items)
        {
            For itemName, action in MyMenu.itemss
                this.Add itemName, action

            this.Add
            this.Add "Toggle", (*) => this.ToggleCheck("Toggle")
        }
        Else this.CreateItems(items)
    }

    CreateItems(items := Map) {
        For itemName, action in items
            this.Add itemName, action
    }

    ; Modify the Show method to display the Edit control hovering over the menu
    ;Show(&x , &y) {
    Show(x , y) {
        ; Call the original Show method
        Super.Show(x, y)

        ; Create the Edit control if it doesn't exist
        if (!IsObject(this.GUI))
            this.CreateEditBox()

        ; Get the menu position
        menuPos := this.GetPos()

        ; Position the Edit control window over the menu
        this.GUI.Show("x" . menuPos.x . " y" . (menuPos.y - 25))
    }
    GetPos() {
            if (IsObject(this.GUI)) {
                WinGetPos(&X, &Y, , , "ahk_id " this.GUI.Hwnd)
                return {x: X, y: Y}
            }
            return {x: 0, y: 0}
        }
  
  /* preserve  Show() {
            super.Show()
            keyInputActive := true
            while (keyInputActive) {
                i := InputHook("L1Mm+M{Esc}")
                i.Wait()
                key := i.Input
                msgbox(key)
                keyInputActive := false

                if (key = "{Esc}") {
                    keyInputActive := false
                } else if (key = "m") {
                    this.Show()
                } else if (key = "+m") {
                    anotherMenu.Show()
                }
            }
        }
*/

    CreateEditBox() {
            ; Create a GUI window and add an Edit control
            this.GUI := Gui()
            this.GUI.Add("Edit", "w200 h20", "")
            this.GUI.OnEvent("Close", (*) => this.GUI.Hide())
        }
    
    Static ItemAction(item, *) => MsgBox("You selected " item)
}


/* preserved
Class MyMenu extends Menu {

    Static menu := menu()
    Static itemss := Map(
        "Option 1", this.ItemAction,
        "Option 2", this.ItemAction,
        "Option 3", this.ItemAction
    )

    Static __New() {
        For itemName, action in this.itemss
            this.Menu.Add itemName, action

        this.Menu.Add
        this.Menu.Add "Toggle", (*) => this.Menu.ToggleCheck("Toggle")
    }

    __New(items?) {
        Menu.Prototype.CreateItems := ObjBindMethod(this, "CreateItems")
        Menu.Prototype.ItemAction := ObjBindMethod(MyMenu, "ItemAction")

        If !IsSet(items)
        {
            For itemName, action in MyMenu.itemss
                this.Add itemName, action

            this.Add
            this.Add "Toggle", (*) => this.ToggleCheck("Toggle")
        }
        Else this.CreateItems(items)
    }

    CreateItems(items := Map) {
        For itemName, action in items
            this.Add itemName, action
    }
    HandleKeyInput() {
            global keyInputActive := true
            while (keyInputActive){
                i := InputHook("L1Mm+M{Esc}")
                        key := i.KeyPress()

                if (key = "{Esc}") {
                    keyInputActive := false
                } else if (key = "m") {
                    this.menu.Show()
                } else if (key = "+m") {
                    anotherMenu.Show()
                }
            }
        }

    Static ItemAction(item, *) => MsgBox("You selected " item)
}
*/