; #Requires AutoHotkey v2.0-beta.1
; #SingleInstance Force

; Create a new QuickLinks object
ql := QuickLinks()

; Create the menu
ql.CreateMenu()

quickLinksInstance.oMenu["link1"] := "a_scriptdir . / . here "
quickLinksInstance.oMenu["link1"].Show := Func("ShowMethod")

quickLinksInstance.oMenu["link2"] := "www.google.com"
quickLinksInstance.oMenu["link2"].Show := Func("ShowMethod")

; Set the hotkey for showing the menu
CapsLock::ql.Show()

; QuickLinks class definition
/*class QuickLinks {
    oMenu := {}
    linkDir := ""

    ; Constructor
    __New(linkDir:="Links") {
        this.linkDir := linkDir
    }

    ; CreateMenu method
    CreateMenu() {
        if (!InStr(this.linkDir, "\")) {
            this.linkDir := A_ScriptDir "\" this.linkDir
        }
        ; Show method
           
        ; ... (rest of the CreateMenu method code)
    }
    ;Show method
       Show(linkName:="Links") {
           this.oMenu[linkName].Call("Show")
       }

       __Get(key) {
             return this.oMenu[key]
         }


   
}*/

/*class QuickLinks {
    oMenu := {}
    linkDir := ""

    ; Constructor
    __New(linkDir:="Links") {
        this.linkDir := linkDir
    }

    ; CreateMenu method
    CreateMenu() {
        if (!InStr(this.linkDir, "\")) {
            this.linkDir := A_ScriptDir "\" this.linkDir
        }
        ; Define the Show method for each item in oMenu
        for k, v in this.oMenu {
            this.oMenu[k].Show := Func("ShowMethod")
        }

        ; ... (rest of the CreateMenu method code)
    }
    
    ; Show method
    Show(linkName:="Links") {
        this.oMenu[linkName].Show()
    }

    __Get(key) {
        return this.oMenu[key]
    }

    ; Define the ShowMethod as a separate function outside the class
    ShowMethod() {
        ; Your code to show the item goes here
    }
}*/

class QuickLinks {
    oMenu := {}
    linkDir := ""

    ; Constructor
    __New(linkDir:="Links") {
        this.linkDir := linkDir
    }

    ; CreateMenu method
    CreateMenu() {
        if (!InStr(this.linkDir, "\")) {
            this.linkDir := A_ScriptDir "\" this.linkDir
        }

        ; ... (rest of the CreateMenu method code)

        ; Assuming you're adding items to oMenu inside the CreateMenu method
        ; Example: this.oMenu["link1"] := ...
        ;          this.oMenu["link2"] := ...
        ;for k, v in this.oMenu {
            ;this.oMenu[k].Show := Func("ShowMethod")
       ; }
    }

    ; Show method
    Show(linkName:="Links") {
        this.oMenu[linkName].Show()
    }

    __Get(key) {
        return this.oMenu[key]
    }

    ; Define the ShowMethod as a separate function outside the class
    ShowMethod() {
        ; Your code to show the item goes here
    }
}

