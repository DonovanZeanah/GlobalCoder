query := "&as_qdr=y1"
ans := ""

ans := InputBox( "Google Search", "Enter search query") ;remove 1st param , now its the equals
Run("www.google.com/search?q=" . ans . query)
crm := ChromeGroup()
WinWait("dkz", , 3)
SendInput("{Alt down}g{Alt up}")
Run(A_ScriptDir . "\" . A_ScriptName)
Run(A_ScriptFullPath)
Return

ChromeGroup() {
    shell := ComObjCreate("Shell.Application")
    for window in shell.Windows
    {
        if (InStr(window.FullName, "chrome.exe"))
        {
            return window
        }
    }
    shell := ""
}
/*Google := Func("box").Bind("g")
Menu, MyMenu, Add, Google, % Google
Menu, MyMenu, Show

box(action) {
 Static prompt := {g: ["Search Google"    , "a query"]
                 , d: ["Search DuckDuckGo", "a query"]
                 , s: ["Shutdown"         , "seconds"]}
 InputBox, param, % prompt[action].1, % "Enter " prompt[action].2,, 300, 125
 If (ErrorLevel || param = "")
  Return
 param := encodeDecodeURI(param)
 Run, %A_AhkPath% "%A_ScriptDir%\action.ahk" %action% %param%
}

encodeDecodeURI(str, encode := true, component := true) {
 ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=84825&p=372154#p372154
 Static doc, js
 If !doc {
  doc := ComObjCreate("htmlfile"), doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
  js  := doc.parentWindow
  (doc.documentMode < 9 && js.execScript())
 }
 Return js[(encode ? "en" : "de") "codeURI" (component ? "Component" : "")](str)
}
*/

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
}