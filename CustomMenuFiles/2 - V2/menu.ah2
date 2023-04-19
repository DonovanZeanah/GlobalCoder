/*class QuickLinks {
    oMenu := {}
    linkDir := ""

    ; Constructor
    __New(linkDir:="Links") {
        this.linkDir := linkDir
    }*/
    ; Create a QuickLinks instance and call CreateMenu
    quickLinksInstance := QuickLinks()
    quickLinksInstance.CreateMenu()

    ; Call the Show method for the "link1" item
    quickLinksInstance.Show("link1")


    ; create an instance of the MyMenu class
    myMenu1 := MyMenu()
    mymenushow := mymenu1.create()
    mymenushow.show()

    ; define a hotkey to trigger the menu
    ^m:: 
    {
        ;smenu2 := myMenu1.Create()
        mymenu1.menu1.Show()
    }
    
   class MyMenu {
       ; define the menu items and their actions
       static items := [
           {text: "Option 1", action: "MsgBox, You selected Option 1."},
           {text: "Option 2", action: "MsgBox, You selected Option 2."},
           {text: "Option 3", action: "MsgBox, You selected Option 3."}
       ]
       __new() {
           this.menu1 := Menu()
           for k, item in MyMenu.items {
           this.menu1.Add(item.text,item.action)
           }
           return this
       }

       ; define a method to create the menu
       Create() {
           menu1 := Menu()
           for item in myMenu.items {
               menu.Add(item.text, item.action)
           }
           return menu
       }

   }


/*
class MyMenu {
    ; define the menu items and their actions
    static items := [
        {text: "Option 1", action: "MsgBox, You selected Option 1."},
        {text: "Option 2", action: "MsgBox, You selected Option 2."},
        {text: "Option 3", action: "MsgBox, You selected Option 3."}
    ]
    __new() {
        this.menu1 := Menu()
        for k, item in MyMenu.items {
        this.menu1.Add(item.text,item.action)
        }
        return this
    }

    ; define a method to create the menu
    Create() {
        menu1 := Menu()
        for item in myMenu.items {
            menu.Add(item.text, item.action)
        }
        return menu
    }

}

; create an instance of the MyMenu class
myMenu1 := MyMenu()
mymenushow := mymenu1.create()
mymenushow.show()

; define a hotkey to trigger the menu
^m:: 
{
    ;smenu2 := myMenu1.Create()
    mymenu1.menu1.Show()
return
}*/