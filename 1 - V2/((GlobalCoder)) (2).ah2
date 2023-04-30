<^m:: mymenu.Menu.show
<!m:: anotherMenu.show

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

Class MyMenu extends Menu {

    Static menu := menu()
    Static itemss := Map(
        "Option 1", this.ItemAction,
        "Option 2", this.ItemAction,
        "Option 3", this.ItemAction
    )

    Static __New()
    {
        For itemName, action in this.itemss
            this.Menu.Add itemName, action

        this.Menu.Add
        this.Menu.Add "Toggle", (*) => this.Menu.ToggleCheck("Toggle")
    }

    __New(items?)
    {
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

    Static ItemAction(item, *) => MsgBox("You selected " item)
}
