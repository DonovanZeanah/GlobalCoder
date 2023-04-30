
; create an instance of the MyMenu class
myMenu := _MyMenu()

; define a hotkey to trigger the menu
^m::
{
    m := myMenu.Create()
    MenuShow(m)
return
}


class _MyMenu {
    ; define the menu items and their actions
    items := [
        {text: "Option 1", action: "MsgBox, You selected Option 1."},
        {text: "Option 2", action: "MsgBox, You selected Option 2."},
        {text: "Option 3", action: "MsgBox, You selected Option 3."}
    ]
    
    ; define a method to create the menu
    Create() {
        menu := MenuCreate()
        for item in this.items {
            Menu.Add( item.text, item.action)
        }
        return menu
    }
}


/*MyMenu := menu()
a := MMaker("a",MyMenu)

; Use Ctrl+Alt+T as a hotkey to show the menu
^!t::a.myMenu.DisplayMenu() ; call DisplayMenu instead of ShowMenu

class MMaker {
    __New(name, menuobj) {
        this.name := name
        ;this.menu := "" ; declare the menu property
        this.menu := menuobj ; use := instead of :
        this.menu.Add("Item 1", {OnEvent: Func("Action1")}) ; use an object literal as the third parameter
        this.menu.Add("Item 2", {OnEvent: Func("Action2")}) ; use an object literal as the third parameter
        this.menu.Add("Item 3", {OnEvent: Func("Action3")}) ; use an object literal as the third parameter
    }

    DisplayMenu() { ; rename ShowMenu to DisplayMenu
        this.menu.Show()
    }

    Action1() {
        MsgBox("You selected Item 1.")
    }

    Action2() {
        MsgBox("You selected Item 2.")
    }

    Action3() {
        MsgBox("You selected Item 3.")
    }
}
*/

/*class MMaker {

    __New(name,menuobj) {
        this.name := name
        ;this.menu := "" ; declare the menu property
        this.menu := menuobj ; use := instead of :
        this.menu.Add("Item 1", "Action1")
        this.menu.Add("Item 2", "Action2")
        this.menu.Add("Item 3", "Action3")
    }

    DisplayMenu() { ; rename ShowMenu to DisplayMenu
        this.menu.Show()
    }

    Action1() {
        MsgBox("You selected Item 1.")
    }

    Action2() {
        MsgBox("You selected Item 2.")
    }

    Action3() {
        MsgBox("You selected Item 3.")
    }
}

*/
