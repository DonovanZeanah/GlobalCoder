#warn all, off

#Include d:/lib/v2/ ;WebView2.ahk
#Include WebView2.ahk
#include "D:\lib\V2\SQLite\cSQLite.ahk"


capslock::Search("Google").Show()
;capslock::Search("Google").Show()

<^m:: mymenu.Menu.show ;().HandleKeyInput()
^+m::{

    anotherMenu.show(200,200)
    anotherMenu.HandleKeyInput()
}
^!m::{
    anotherMenu.HandleKeyInput()

}
;OnError LogError
;i := Integer("cause_error")

;mymenu := MyMenu()
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

msgbox "still executing..."

PrepareMenu(A_ScriptDir "\CustomMenuFiles")
;PrepareMenu(A_ScriptDir "\singles")


/*anotherMenu := mymenu()

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
*/

;## Create the popup menu by adding some items to it.
    MyMenu1 := Menu()
    MyMenu1.Add "Item 1", MenuHandler
    MyMenu1.Add "Item 2", MenuHandler
    MyMenu1.Add  ; Add a separator line.
    ;//
;## Create another menu destined to become a submenu of the above menu.
    Submenu1 := Menu()
    Submenu1.Add "Item A", MenuHandler
    Submenu1.Add "Item B", MenuHandler
;## Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
    MyMenu1.Add "My Submenu", Submenu1

    MyMenu1.Add  ; Add a separator line below the submenu.
    MyMenu1.Add "Item 3", MenuHandler  ; Add another menu item beneath the submenu.

return
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[Hotkeys]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
;^!m:: mymenuI.Menu.show ;().HandleKeyInput()
;<^m:: mymenu.Menu.show ;().HandleKeyInput()
;<!m:: anotherMenu.show(200,200)



#z::
{
	;getcaret(&x,&y,&w,&h)
	MyMenu1.Show()  ; i.e. press the Win-Z hotkey to show the menu.
}

^!t::
{
	   for n in FibC()
	    if MsgBox("#" A_Index " = " n "`nContinue?",, "y/n") = "No"
	        break


	for n in FibF() ;val not enumerable
	    if MsgBox("#" A_Index " = " n "`nContinue?",, "y/n") = "No"
	        break


	windows := ""
	for window in ComObject("Shell.Application").Windows
	    windows .= window.LocationName " :: " window.LocationURL "`n"
	MsgBox windows

	colours := {red: 0xFF0000, blue: 0x0000FF, green: 0x00FF00}
	; The above expression could be used directly in place of "colours" below:
	s := ""
	for k, v in colours.OwnProps()
	    s .= k "=" v "`n"
	MsgBox s

	;//=====================================================
	myArray := ["apple", "banana", "cherry"]
	for index, value in myArray
	{
	    MsgBox "Index " index " contains " value
	}
	myMap := Map()
	myMap.Set("key1", "value1")
	myMap.Set("key2", "value2")
	myMap.Set("key3", "value3")

	for key, value in myMap
	{
	    MsgBox "Key: " key ", Value: " value
	}
	myMap := {key1: "value1", key2: "value2"}
	if (IsObject(myMap))
	{
	    keyList := myMap.keys()
	    for key, value in keyList
	    {
	        MsgBox "Key: " key ", Value: " value
	    }
	}




	 ; Read the content of the input .ahk file
	content := FileRead("guiclass.ah2")
    msgbox content

	; Find and extract the classes
	ahclasses := []
	regex := "class\s+(\w+)\s*\{[\s\S]*?\}"
	pos := 1
	found := []

	while (pos := RegExMatch(content, regex, &found, pos)) {
	    class_name := found[1]
	    class_code := found[0]
	    ahclasses.push(class_name, class_code )
	    ;ahclasses["class_name"] := class_code
	    ;content := SubStr(content, found.Pos + found.Len)
	    pos += found.len - 1 ;strlen(found[0])
	}

	; Sort the classes
	sorted_classes := SortClasses(ahclasses)

	; Write the sorted classes to a new output .ahk file
	sorted_content := ""
	for _, class_code in sorted_classes {
	    sorted_content .= class_code "`n`n"
	}
	FileDelete("output.ahk")
	FileAppend("output.txt", sorted_content)
}

!x::
{
	; keys1 := map.keys(myMap)
	; values1 := Object.values(myMap)

	; for i, key in keys1 {
	;     value1 := values[i]
	;     MsgBox "Key: " key "`nValue: " value
	; }

	;    myMap := {a: 1, b: 2, c: 3}
	; for key, value in myMap
	; {
	;     MsgBox "Key " key " contains " value
	; }

	;//================
	; ; Read the content of the input .ahk file
	; content := FileRead("guiclass.ah2")

	; ; Find and extract the classes
	; ahclasses := {}
	; regex := "class\s+(\w+)\s*\{[\s\S]*?\}"
	; while RegExMatch(content, regex, found) {
	;     class_name := found[1]
	;     class_code := found[0]
	;     ahclasses[class_name] := class_code
	;     content := SubStr(content, found.Pos + found.Len)
	; }

	; ; Sort the classes
	; sorted_classes := ahSortClasses(ahclasses)

	; ; Write the sorted classes to a new output .ahk file
	; sorted_content := ""
	; for _, class_code in sorted_classes {
	;     sorted_content .= class_code "`n`n"
	; }
	; FileDelete("output.ahk")
	; FileAppend("output.ahk", sorted_content)

	; ; Function to sort the classes by name
	; ahSortClasses(ahclasses) {
	;     sorted := {}
	;     for class_name, class_code in ahclasses {
	;         sorted[class_name] := class_code
	;     }
	;     ; Sort dictionary keys
	;     sorted_keys := Object()
	;     for key in sorted {
	;         sorted_keys.Insert(key)
	;     }
	;     sorted_keys.Sort()
	    
	;     ; Create a new sorted dictionary
	;     sorted_output := Object()
	;     for key in sorted_keys {
	;         sorted_output[key] := sorted[key]
	;     }

	;     return sorted_output

	;}
		; loggerObj := Logger()
		; timelineObj := Timeline(loggerObj)

		; timelineObj.logEvents("First event")
		; sleep(1000)
		; timelineObj.logEvents("Second event")
		; timeline1 := Timeline(loggerobj)
		; timeline1.AddEvent("start", A_TickCount)
		; Sleep(1000)
		; timeline1.AddEvent("middle", A_TickCount)
		; Sleep(1000)
		; timeline1.AddEvent("end", A_TickCount)
		; timeline1.logevents()
		; ;timeline1.logeventsjson()
		; startTime := timeline1.GetEventTime("start")
		; middleTime := timeline1.GetEventTime("middle")
		; endTime := timeline1.GetEventTime("end")
		; MsgBox("Start time:" startTime "`nMiddle time:" middleTime "`nEnd time:" endTime)
		; return
}
PrepareMenu2(PATH)
{

    ;static custom1 := A_ScriptDir "\custom1"
    /*static urls := { 0: ""
            , 1 : "https://www.google.com/search?hl=en&q="
            , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
            , 3 : "https://www.google.com/maps/search/"
            , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
            */

       ;global

        ; GUI loading/progress bar
        mygui := gui("+ToolWindow", ScriptName " is Loading")      ; Adding title to progressbar
        ogcMyProgress := mygui.add("Progress", "w200 vMyProgress range1-" . items, "0") ; Adding progressbar
        mygui.show()                                                ; Displaying Progressbar

        ; Add Name, Icon and seperating line
        PATH := Menu()
        PATH.Add("googler", googler) ; Regular search ;googler                                ; Name

        PATH.Add("")                                                                          ; seperating

        ; Add all custom items using algorithm
        LoopOverFolder(Path)
       ;loopoverfolder(singles)

       PATH.Add("")   ; seperater
       PATH.Add(ScriptName " vers. " Version, github) ;googler                        ; Name
       PATH.Add("")                                                         ; seperating


        ; Add Admin Panel
        Sleep(200)
        PATH.Add("")                                                  ; seperating line
        PATH.Add := Menu()
        PATH  "\Admin".Add("&1 Restart", ReloadProgram)             ; Add Reload option
        PATH  "\Admin".Add("&2 Exit", ExitApp)                          ; Add Exit option
        PATH  "\Admin".Add("&3 Go to Parent Folder", GoToRootFolder)    ; Open script folder
        PATH  "\Admin".Add("&4 Add Custom Item", GoToCustomFolder)      ; Open custom folder
        PATH.Add("&0 Admin", PATH "\Admin")                      ; Adds Admin section

        ; Loadingbar GUI is no longer needed, remove it from memory
        mygui.Destroy()
}
;// end

; AHK Expects menus to be build from bottom to top.
; recurses into the most bottom element, notes all the elements on the way there, and builds from bottom up.

;/ loopoverfolder(path) - another main function
LoopOverFolder2(PATH){
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []

    ; Loop over all files and folders in input path, but do NOT recurse
    Loop Files, PATH "\*", "DF"
    {
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(A_LoopFilePath)

        ; Current item is a directory
        if (VALUE = "D")
        {
            ;~ MsgBox, % "Pushing to folders`n" A_LoopFilePath
            FolderArray.Push(A_LoopFilePath)
        }
        ; Current item is a file
        else
        {
            ;~ MsgBox, % "Pushing to files`n" A_LoopFilePath
            FileArray.Push(A_LoopFilePath)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    FolderArray := Sort(FolderArray)
    FileArray := Sort(FileArray)

    for k,v in folderarray
{
    value  .= v "`n"
}
    for k,v in filearray
{
    value2  .= v "`n"
}


    ; First add all folders, so files have a place to stay
    for index, element in FolderArray
    {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Then add it as item to menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
        %dir% := Menu()
        %dir%.Add(name, %element%)

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray
    {
        ; Add To Menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
        %dir%.Add(name, MenuEventHandler)

        ; Iterate GUI loading
        FoundItem("File")
    }
}


;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[Classes]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]

Class Search extends Gui {

    Width     := Round(A_ScreenWidth / 1920 * 1200)
    TopMargin := Round(A_ScreenHeight / 1080 * 200)

    /**
     * Get a gui to type into.
     * Close it by pressing Escape. (This exits the entire thread)
     * Accept your input by pressing Enter.
     * Call WaitForInput() after creating the class instance.
     */
     
    __New(searchEngine) {
        super.__New("AlwaysOnTop -Caption")
        ;this.DarkMode().MakeFontNicer(30)
        this.BackColor := 171717
        this.MarginX := 0

        ;this.SelectedSearchEngine := this.AvailableSearchEngines[searchEngine]

        this.InputField := this.AddEdit("x0 Center -E0x200 Background" this.BackColor " w" this.Width)
        this.inputfield.SetFont("s" fontSize " cC5C5C5", "Consolas")

        this.Input := ""
        this.isWaiting := true
        this.RegisterHotkeys()
    }

    ShowVisual() => this.Show("y" this.TopMargin " w" this.width)
    Show() => (super.Show("y" this.TopMargin " w" this.Width), this)

    /**
     * Occupy the thread until you type in your input and press
     * Enter, returns this input
     * @returns {String}
     */
     
    WaitForInput() {
        this.Show()
        while this.isWaiting {
        }
        return this.Input
    }

    SetInput() {
        this.Input := this.InputField.Text
        this.isWaiting := false
        this.Finish()
    }

    SetCancel() {
        this.isWaiting := false
        this.Finish()
    }

    RegisterHotkeys() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", (*) => this.SetInput(), "On")
        this.OnEvent("Escape", (*) => this.SetCancel())
    }

    Finish() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", "Off")
        this.Minimize()
        this.Destroy()
    }
    /*DarkMode(guiObj) {
        guiObj.BackColor := "171717"
        return guiObj
    }
    Gui.Prototype.DefineProp("DarkMode", {Call: DarkMode})

    MakeFontNicer(guiObj, fontSize := 20) {
        guiObj.SetFont("s" fontSize " cC5C5C5", "Consolas")
        return guiObj
    }*/

}

class ClassName1 extends object
{
    InstanceVar := Expression
    
    static ClassVar := Expression

    class NestedClass
    {
        ;...
    }

    Method()
    {
        ;...
    }
    
    static Method()
    {
        ;...
    }

    Property[Parameters]  ; Use brackets only when parameters are present.
    {
        get {
            return value of property
        }
        set {
            ;Store or otherwise handle value
        }
    }
    
    ShortProperty
    {
        get => Expression which calculates property value
        set => Expression which stores or otherwise handles value
    }
    
    ShorterProperty => Expression which calculates property value
} ;template Class Definition
class View extends Gui
{
    __New() {
        super.__New("-DPIScale")
        this._text1 := super.Add("Text", "xm ym r1 w200")
        this._button := super.Add("Button", "xm y+m", "button")
        super.Show("w400 h400 Center")
    }
}
class Array2D extends Array {
    __new(x, y) {
        this.Length := x * y
        this.Width := x
        this.Height := y
    }
    __Item[x, y] {
        get => super[this.Width * (y-1) + x]
        set => super[this.Width * (y-1) + x] := value
    }
}
class FibC {
    a := 0, b := 1
    Call(&n) {
        n := c := this.b, this.b += this.a, this.a := c
        return true
    }
}
; Model
class Task {
    Name := ""
    Description := ""

    __New(name, description) {
        this.Name := name
        this.Description := description
    }
}
; Controller
class TaskController {
    TaskList := []

    AddTask(name, description) {
        task := TaskFactory.Create(name, description)
        this.TaskList.Push(task)
    }

    GetTasks() {
        return this.TaskList
    }
}
; View
class TaskView {
    Controller := ""

    __New(controller) {
        this.Controller := controller
    }

    AddTask(name, description) {
        this.Controller.AddTask(name, description)
    }

    DisplayTasks() {
        Gui1 := Gui()
        lv := Gui1.Add("ListView", {w: 400, h: 300}, "Name|Description")
        Gui1.OnEvent("Close", () => ExitApp())

        tasks := this.Controller.GetTasks()
        for task in tasks {
            lv.Add("", task.Name, task.Description)
        }

        Gui1.Show()
    }
}
; Factory
class TaskFactory {
    static __new(){
        return Task(name, description)
    }
    __new(){
            return Task(name, description)
        }
    static Create(name, description) {
        return Task(name, description)
    }
}
class Tasker {
    Name := ""
    Duration := 0
    Value := 0

    __New(name, duration, value) {
        this.Name := name
        this.Duration := duration
        this.Value := value
    }

    Rank() {
        return this.Value / this.Duration
    }
}
class TaskList {
    Tasks := []

    AddTask(task) {
        this.Tasks.Push(task)
    }

    RankTasks() {
        this.Tasks.Sort((a, b) => b.Rank() - a.Rank())
    }

    DisplayTasks() {
        Gui1 := gui()
        Gui1.add("ListView", "w400 h300", "Task|Duration|Value|Rank")

        for task in this.Tasks {
            LV_Add("", task.Name, task.Duration, task.Value, task.Rank())
        }

        Gui1.Show(Ranked Tasks)
    }
}
Class GMenu extends Menu {
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
Class MyMenu2 extends Menu {
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
    Static ItemAction(item, *) => MsgBox("You selected " item)

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
       ; if (!IsObject(this.GUI))
         ;   this.CreateEditBox()

        ; Get the menu position
        ;menuPos := this.GetPos()

        ; Position the Edit control window over the menu
        ;this.GUI.Show("x" . menuPos.x . " y" . (menuPos.y - 25))
    }
    Showedit(x , y) {
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
    CreateEditBox() {
            ; Create a GUI window and add an Edit control
            this.GUI := Gui()
            this.GUI.Add("Edit", "w200 h20", "")
            this.GUI.OnEvent("Close", (*) => this.GUI.Hide())
        }
        
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

    
Class MyMenu extends Menu {

    static keyInputActive := false
    keyInputActive := false

    i := inputhook()

    Static menu := menu()
    Static itemss := Map(
        "Option 1", this.ItemAction,
        "Option 2", this.ItemAction,
        "Option 3", this.ItemAction
    )

    Static ItemAction(item, *) => MsgBox("You selected " item)

    Static __New() {
        ;msgbox mymenu.keyInputActive ;false
        ;msgbox this.keyInputActive ;false

        For itemName, action in this.itemss
            this.Menu.Add itemName, action

        this.Menu.Add
        this.Menu.Add "Toggle", (*) => this.Menu.ToggleCheck("Toggle")
    }

    __New(items?) {
        ;msgbox mymenu.keyInputActive ;false
        ;msgbox this.keyInputActive ;true , but changed false in instance property above, so false

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
            this.keyInputActive := true
            msgbox this.keyInputActive

            while (this.keyInputActive){
                this.i := InputHook("L1Mm+M{Esc}")
                        key := this.i.KeyPress()

                if (key = "{Esc}") {
                    msgbox "esc"
                    keyInputActive := false
                } else if (key = "m") {
                    this.menu.Show()
                } else if (key = "+m") {
                    anotherMenu.Show()
                }
            }
        }

}
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

        ; Adding items to oMenu inside the CreateMenu method
        this.oMenu["link1"] := MenuItem("Link 1")
        this.oMenu["link2"] := MenuItem("Link 2")
    }

    ; Show method
    Show(linkName:="Links") {
        this.oMenu[linkName].Show()
    }

    __Get(key) {
        return this.oMenu[key]
    }
}
; Define a class for your menu items
class MenuItem {
    name := ""

    __New(name) {
        this.name := name
    }

    Show() {
        MsgBox("Showing item: " this.name)
    }
}
class TextProcessor {
    data := []

    ; Constructor
    __New() {
        this.data := []
    }

    ; Add text from key strokes
    AddTextFromKeyStrokes(text) {
        this.AddText(text)
    }

    ; Add text from clipboard
    AddTextFromClipboard() {
        this.AddText(Clipboard)
    }

    ; Add text from screen OCR (using a hypothetical OCR function GetTextFromScreen())
    AddTextFromScreenOCR() {
        ocrText := GetTextFromScreen() ; Replace with an actual OCR function
        this.AddText(ocrText)
    }

    ; Add text from a file
    AddTextFromFile(filePath) {
        try fileText := FileRead(filePath)
        catch {
            ; Handle error if needed (e.g. file not found)
            return
        }
        this.AddText(fileText)
    }

    ; Private method to add text and handle duplicates
    AddText(text) {
        words := StrSplit(text, " ")
        wordsCount := words.Length()

        for index, word in words {
            ; Check for duplicates within a 2-word range
            Loop 5 {
                offset := A_Index - 3
                ; Check if index + offset is within the range of the data array
                if (index + offset > 0) && (index + offset <= wordsCount) {
                    partialWord := words[index + offset]
                    ; If the partial word is found in the data array, skip adding the current word
                    if this.IsWordInData(partialWord) {
                        continue 2
                    }
                }
            }

            ; Add the word to the data array
            this.data.Push(word)
        }
    }
}
class TextFileProcessor {
    __New(filePath) 
	{
		this.filecontent := ""
		;this.processedlines := {}
        this.filePath := filePath
        this.ReadFileContent()
        this.ProcessLines()
    }

    ReadFileContent() 
	{
		file1 := fileread(this.filepath)
		;this.filecontents
        ;FileRead(this.fileContent, this.filePath)
        this.lines := StrSplit(file1, "`n")
    }

    ProcessLines() 
	{
        this.processedLines := []
        for index, line in this.lines {
			            this.processedLines.Push(StrReplace(line, "\\", "`r`n"))

            ;this.processedLines.Push(StrReplace(line, "//", "`n"))
        }
    }

    GetFileContent() 
	{
        return this.fileContent
    }

    GetLines() 
	{
        return this.lines
    }

    GetProcessedLines() 
	{
        return this.processedLines
    }
	  DisplayGUI() {
		; this.gui := Gui()
        ; processedText := StrJoin("`r`n", this.processedLines)
        ; this.gui.Add("Edit", "vMyEdit w600 h300", processedText)
        ; this.gui.Add("Button", "x+m y+m Default", "Copy to Clipboard").OnEvent("Click", Func(this, "CopyToClipboard"))
        ; this.gui.OnEvent("Close", Func("ExitApp"))
        ; this.gui.Show()

		 static looper := 0
         this.gui1 := Gui()

		 for k,v in this.processedlines
		 {
         	this.gui1.Add("Edit"  , "vMyEdit" . ++looper " w200 h50", v) ;, StrJoin("`r`n", this.processedLines))
		 }
		 	this.gui1.Add("Button", " ", "Copy to Clipboard")
            this.gui1.OnEvent("Click", guiclip)
             guiclip := Func(this.gui1*)
         	this.gui1.OnEvent("Close", gui_close)
        
         this.gui1.Show()
    }
	
 gui_close(*) {                      ; embedded method for close event; used with Gui " event sink "
        Msgbox " Now closing "
        ExitApp
    }
    CopyToClipboard(*) {
        global gui1
        selectedText := gui1["MyEdit"].Value
        clipboard := selectedText
        MsgBox("Selected text has been copied to the clipboard.")
    }

	;    DisplayGUI() {
    ;     Gui, New
    ;     Gui, Add, Edit, vMyEdit w600 h300, % StrJoin("`r`n", this.processedLines)
    ;     Gui, Add, Button, x+m y+m Default gCopyToClipboard, Copy to Clipboard
    ;     Gui, Show
    ; }

    ; CopyToClipboard() {
    ;     GuiControlGet, selectedText,, MyEdit
    ;     Clipboard := selectedText
    ;     MsgBox, "Selected text has been copied to the clipboard."
    ; }
}
class TemplateControllerGenerator {
    static modelName := "MyModel"

    static GenerateTemplateController()
    {
        ; Define the template controller content
        controllerTemplate := "
        (
        using Microsoft.AspNetCore.Mvc;
        using System.Collections.Generic;
        using <YourProjectNamespace>.Models;

        namespace <YourProjectNamespace>.Controllers
        {
            public class %sController : Controller
            {
                public IActionResult Index()
                {
                    var modelList = new List<%s>();
                    // Add code to fetch or create the model list
                    return View(modelList);
                }

                public IActionResult Details(int id)
                {
                    var model = new %s();
                    // Add code to fetch the model by id
                    return View(model);
                }

                [HttpGet]
                public IActionResult Create()
                {
                    return View();
                }

                [HttpPost]
                [ValidateAntiForgeryToken]
                public IActionResult Create(%s model)
                {
                    if (ModelState.IsValid)
                    {
                        // Add code to save the model
                        return RedirectToAction(nameof(Index));
                    }

                    return View(model);
                }

                [HttpGet]
                public IActionResult Edit(int id)
                {
                    var model = new %s();
                    // Add code to fetch the model by id
                    return View(model);
                }

                [HttpPost]
                [ValidateAntiForgeryToken]
                public IActionResult Edit(int id, %s model)
                {
                    if (ModelState.IsValid)
                    {
                        // Add code to update the model
                        return RedirectToAction(nameof(Index));
                    }

                    return View(model);
                }

                [HttpPost]
                [ValidateAntiForgeryToken]
                public IActionResult Delete(int id)
                {
                    // Add code to fetch and delete the model by id
                    return RedirectToAction(nameof(Index));
                }
            }
        }
        )"

        ; Replace the placeholders with the actual model name. "%s" is an arbitrary placeholder for the model name, 
		;needs to be unique if changed to something else.
        controllerTemplate := StrReplace(controllerTemplate, "%s", TemplateControllerGenerator.modelName)

        ; Set the output file name
        outputFileName := "TemplateController_OutputFile.cs"
		
		while (FileExists(outputFileName))
		{
			outputFileName := InputBox("Enter the output file name:", "Output File Name")
		  {

        ; Create and write the controller template to the output file
        File1 := FileOpen(outputFileName, "w")
        File1.Write(controllerTemplate)
        File1.Close()
        MsgBox("Template controller file has been generated as " . outputFileName)
		return outputFileName
		  }
        }
    }

    static ReplaceModelNameInFile()
    {
        ; Set the input and output file names
        inputFileName := "TemplateController_outputFile.cs"
        outputFileName2 := "TemplateController_OutputFile_Updated.cs"

        ; Prompt for a new model name
        newModelName := InputBox("Enter the new model name:", "Replace Model Name")

        ; Read the input file content
        inputFileContent := FileRead(inputFileName)

        ; Replace the original model name with the new model name
		msgbox(TemplateControllerGenerator.modelName)
        updatedFileContent := StrReplace(inputFileContent, TemplateControllerGenerator.modelName, newModelName.value)
		msgbox(updatedFileContent)

        ; Write the updated content to the output file
        File2 := FileOpen(outputFileName2, "w")
        File2.Write(updatedFileContent)
        File2.Close()
        MsgBox("The model name has been replaced and the updated file is saved as " . outputFileName2)
		return outputfilename2
    }

	__new(){
		this.files := {}
		this.files.push(TemplateControllerGenerator.GenerateTemplateController())
		this.files.push(TemplateControllerGenerator.ReplaceModelNameInFile())
	}
}
class Logger {
    fileObj := {}
    
    __New() {
        this.fileObj := FileOpen(A_WorkingDir . "\logfile2.txt", "a", "UTF-8")
    }
    
    logEvent(event) {
		if IsObject(event) {
			event := this.convertObjectToString(event)
		}
        this.fileObj.Write(A_Now . ": " . event . "`n")
    }
	convertObjectToString(obj) {
    if (obj.HasMethod("ToString")) {
        return obj.ToString()
    } else {
        ;return JSON.stringify(obj)
        return JSON.stringify(obj)
    	}
	}
    
    __Delete() {
		this.fileObj.Write(";\\========" . "`n")
        this.fileObj.Close()
    }
}
class Timeline {
    logger := {}
    
    __New(loggerObj) {
        this.logger := loggerObj
		this.events := []

    }
    
    
	AddEvent(name, time) {
        event := { name: name, time: time }
        ;event := { name: name, time: time, note: note }
        this.events.push(event)
		;this.logEvents()
		;this.logeventsjson()
		;event2 := Map("name", name, "time", time)
    }
    
    GetEventTime(name) {
        for i, event in this.events {
            if (event.name = name) {
                return msgbox(event.time)
            }
        }
        return 0  ; event not found
    }
	logEvent(event) {
        this.logger.logEvent(event)
    }
	LogEvents() {
        for i, event in this.events {
            if (event.HasProp("name")) {
                 ;msgbox(event.time)
				 this.logevent(event.name)
				 ;this.logger.logevent(event)
            }
			else 
			{
				 msgbox("no event")
				 return 0
			}
        }
        return 1  ; event not found
    }
	LogEventsJson() {
        for i, event in this.events {
            if (event.HasProp("name")) {
                 ;msgbox(event.time)
				 ;this.logevent(event.name)
				 this.logger.logevent(event)
            }
			else 
			{
				 msgbox("no event")
				 return 0
			}
        }
        return 1  ; event not found
    }
}
class Employee{
    ; Constructor method
    __New(age, name, title)
    {
        this.age := age
        this.name := name
        this.title := title
    }

    ; Method to display employee info
    ShowInfo()
    {
        MsgBox ("Name: " . this.name . "`nAge: " . this.age . "`nTitle: " . this.title)
    } 
}
class JSON {
	static null := ComValue(1, 0), true := ComValue(0xB, 1), false := ComValue(0xB, 0)

	/**
	 * Converts a AutoHotkey Object Notation JSON string into an object.
	 * @param text A valid JSON string.
	 * @param keepbooltype convert true/false/null to JSON.true / JSON.false / JSON.null where it's true, otherwise 1 / 0 / ''
	 */
	static parse(text, keepbooltype := false) {
		keepbooltype ? (_true := JSON.true, _false := JSON.false, _null := JSON.null) : (_true := true, _false := false, _null := "")
		NQ := "", LF := "", LP := 0, P := "", R := ""
		D := [C := (A := InStr(text := LTrim(text, " `t`r`n"), "[") = 1) ? [] : Map()], text := LTrim(SubStr(text, 2), " `t`r`n"), L := 1, N := 0, V := K := "", J := C, !(Q := InStr(text, '"') != 1) ? text := LTrim(text, '"') : ""
		Loop Parse text, '"' {
			Q := NQ ? 1 : !Q
			NQ := Q && (SubStr(A_LoopField, -3) = "\\\" || (SubStr(A_LoopField, -1) = "\" && SubStr(A_LoopField, -2) != "\\"))
			if !Q {
				if (t := Trim(A_LoopField, " `t`r`n")) = "," || (t = ":" && V := 1)
					continue
				else if t && (InStr("{[]},:", SubStr(t, 1, 1)) || RegExMatch(t, "^-?\d*(\.\d*)?\s*[,\]\}]")) {
					Loop Parse t {
						if N && N--
							continue
						if InStr("`n`r `t", A_LoopField)
							continue
						else if InStr("{[", A_LoopField) {
							if !A && !V
								throw Error("Malformed JSON - missing key.", 0, t)
							C := A_LoopField = "[" ? [] : Map(), A ? D[L].Push(C) : D[L][K] := C, D.Has(++L) ? D[L] := C : D.Push(C), V := "", A := Type(C) = "Array"
							continue
						} else if InStr("]}", A_LoopField) {
							if !A && V
								throw Error("Malformed JSON - missing value.", 0, t)
							else if L = 0
								throw Error("Malformed JSON - to many closing brackets.", 0, t)
							else C := --L = 0 ? "" : D[L], A := Type(C) = "Array"
						} else if !(InStr(" `t`r,", A_LoopField) || (A_LoopField = ":" && V := 1)) {
							if RegExMatch(SubStr(t, A_Index), "m)^(null|false|true|-?\d+\.?\d*)\s*[,}\]\r\n]", &R) && (N := R.Len(0) - 2, R := R.1, 1) {
								if A
									C.Push(R = "null" ? _null : R = "true" ? _true : R = "false" ? _false : IsNumber(R) ? R + 0 : R)
								else if V
									C[K] := R = "null" ? _null : R = "true" ? _true : R = "false" ? _false : IsNumber(R) ? R + 0 : R, K := V := ""
								else throw Error("Malformed JSON - missing key.", 0, t)
							} else
								throw Error("Malformed JSON - unrecognized character-", 0, A_LoopField " in " t)
						}
					}
				} else if InStr(t, ':') > 1
					throw Error("Malformed JSON - unrecognized character-", 0, SubStr(t, 1, 1) " in " t)
			} else if NQ && (P .= A_LoopField '"', 1)
				continue
			else if A
				LF := P A_LoopField, C.Push(InStr(LF, "\") ? UC(LF) : LF), P := ""
			else if V
				LF := P A_LoopField, C[K] := InStr(LF, "\") ? UC(LF) : LF, K := V := P := ""
			else
				LF := P A_LoopField, K := InStr(LF, "\") ? UC(LF) : LF, P := ""
		}
		return J
		UC(S, e := 1) {
			static m := Map(Ord('"'), '"', Ord("a"), "`a", Ord("b"), "`b", Ord("t"), "`t", Ord("n"), "`n", Ord("v"), "`v", Ord("f"), "`f", Ord("r"), "`r", Ord("e"), Chr(0x1B), Ord("N"), Chr(0x85), Ord("P"), Chr(0x2029), 0, "", Ord("L"), Chr(0x2028), Ord("_"), Chr(0xA0))
			v := ""
			Loop Parse S, "\"
				if !((e := !e) && A_LoopField = "" ? v .= "\" : !e ? (v .= A_LoopField, 1) : 0)
					v .= (t := InStr("ux", SubStr(A_LoopField, 1, 1)) ? SubStr(A_LoopField, 1, RegExMatch(A_LoopField, "^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K") - 1) : "") && RegexMatch(t, "i)^[ux][\da-f]+$") ? Chr(Abs("0x" SubStr(t, 2))) SubStr(A_LoopField, RegExMatch(A_LoopField, "^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K")) : m.has(Ord(A_LoopField)) ? m[Ord(A_LoopField)] SubStr(A_LoopField, 2) : "\" A_LoopField, e := A_LoopField = "" ? e : !e
			return v
		}
	}

	/**
	 * Converts a AutoHotkey Array/Map/Object to a Object Notation JSON string.
	 * @param obj A AutoHotkey value, usually an object or array or map, to be converted.
	 * @param expandlevel The level of JSON string need to expand, by default expand all.
	 * @param space Adds indentation, white space, and line break characters to the return-value JSON text to make it easier to read.
	 * @param unicode_escaped Convert non-ascii characters to \uxxxx where unicode_escaped = true
	 */
	static stringify(obj, expandlevel := unset, space := "  ", unicode_escaped := false) {
		expandlevel := IsSet(expandlevel) ? Abs(expandlevel) : 10000000
		return Trim(CO(obj, expandlevel))
		CO(O, J := 0, R := 0, Q := 0) {
			static M1 := "{", M2 := "}", S1 := "[", S2 := "]", N := "`n", C := ",", S := "- ", E := "", K := ":"
			if (OT := Type(O)) = "Array" {
				D := !R ? S1 : ""
				for key, value in O {
					F := (VT := Type(value)) = "Array" ? "S" : InStr("Map,Object", VT) ? "M" : E
					Z := VT = "Array" && value.Length = 0 ? "[]" : ((VT = "Map" && value.count = 0) || (VT = "Object" && ObjOwnPropCount(value) = 0)) ? "{}" : ""
					D .= (J > R ? "`n" CL(R + 2) : "") (F ? (%F%1 (Z ? "" : CO(value, J, R + 1, F)) %F%2) : ES(value, J, unicode_escaped)) (OT = "Array" && O.Length = A_Index ? E : C)
				}
			} else {
				D := !R ? M1 : ""
				for key, value in (OT := Type(O)) = "Map" ? (Y := 1, O) : (Y := 0, O.OwnProps()) {
					F := (VT := Type(value)) = "Array" ? "S" : InStr("Map,Object", VT) ? "M" : E
					Z := VT = "Array" && value.Length = 0 ? "[]" : ((VT = "Map" && value.count = 0) || (VT = "Object" && ObjOwnPropCount(value) = 0)) ? "{}" : ""
					D .= (J > R ? "`n" CL(R + 2) : "") (Q = "S" && A_Index = 1 ? M1 : E) ES(key, J, unicode_escaped) K (F ? (%F%1 (Z ? "" : CO(value, J, R + 1, F)) %F%2) : ES(value, J, unicode_escaped)) (Q = "S" && A_Index = (Y ? O.count : ObjOwnPropCount(O)) ? M2 : E) (J != 0 || R ? (A_Index = (Y ? O.count : ObjOwnPropCount(O)) ? E : C) : E)
					if J = 0 && !R
						D .= (A_Index < (Y ? O.count : ObjOwnPropCount(O)) ? C : E)
				}
			}
			if J > R
				D .= "`n" CL(R + 1)
			if R = 0
				D := RegExReplace(D, "^\R+") (OT = "Array" ? S2 : M2)
			return D
		}
		ES(S, J := 1, U := false) {
			static ascii := Map("\", "\", "`a", "a", "`b", "b", "`t", "t", "`n", "n", "`v", "v", "`f", "f", "`r", "r", Chr(0x1B), "e", "`"", "`"", Chr(0x85), "N", Chr(0x2029), "P", Chr(0x2028), "L", "", "0", Chr(0xA0), "_")
			switch Type(S) {
				case "Float":
					if (v := '', d := InStr(S, 'e'))
						v := SubStr(S, d), S := SubStr(S, 1, d - 1)
					if ((StrLen(S) > 17) && (d := RegExMatch(S, "(99999+|00000+)\d{0,3}$")))
						S := Round(S, Max(1, d - InStr(S, ".") - 1))
					return S v
				case "Integer":
					return S
				case "String":
					v := ""
					if (U && RegExMatch(S, "m)[\x{7F}-\x{7FFF}]")) {
						Loop Parse S
							v .= ascii.Has(A_LoopField) ? "\" ascii[A_LoopField] : Ord(A_LoopField) < 128 ? A_LoopField : "\u" format("{1:.4X}", Ord(A_LoopField))
						return '"' v '"'
					} else {
						Loop Parse S
							v .= ascii.Has(A_LoopField) ? "\" ascii[A_LoopField] : A_LoopField
						return '"' v '"'
					}
				default:
					return S == JSON.true ? "true" : S == JSON.false ? "false" : "null"
			}
		}
		CL(i) {
			Loop (s := "", i - 1)
				s .= space
			return s
		}
	}

	static stringifyoneline(obj, expandlevel := unset, space := "  ", unicode_escaped := false){
		expandlevel := IsSet(expandlevel) ? Abs(expandlevel) : 10000000
	CO(O, J := 0, R := 0, Q := 0) {
		static M1 := "{", M2 := "}", S1 := "[", S2 := "]", N := "`n", C := ",", S := "- ", E := "", K := ":"
		if (OT := Type(O)) = "Array" {
			D := !R ? S1 : ""
			for key, value in O {
				F := (VT := Type(value)) = "Array" ? "S" : InStr("Map,Object", VT) ? "M" : E
				Z := VT = "Array" && value.Length = 0 ? "[]" : ((VT = "Map" && value.count = 0) || (VT = "Object" && ObjOwnPropCount(value) = 0)) ? "{}" : ""
				D .= (J > R ? "" : "") (F ? (%F%1 (Z ? "" : CO(value, J, R + 1, F)) %F%2) : ES(value, J, unicode_escaped)) (OT = "Array" && O.Length = A_Index ? E : C)
			}
			D := RegExReplace(D, "\r?\n", "")
		} else {
			D := !R ? M1 : ""
			for key, value in (OT := Type(O)) = "Map" ? (Y := 1, O) : (Y := 0, O.OwnProps()) {
				F := (VT := Type(value)) = "Array" ? "S" : InStr("Map,Object", VT) ? "M" : E
				Z := VT = "Array" && value.Length = 0 ? "[]" : ((VT = "Map" && value.count = 0) || (VT = "Object" && ObjOwnPropCount(value) = 0)) ? "{}" : ""
				D .= (J > R ? "" : "") (Q = "S" && A_Index = 1 ? M1 : E) ES(key, J, unicode_escaped) K (F ? (%F%1 (Z ? "" : CO(value, J, R + 1, F)) %F%2) : ES(value, J, unicode_escaped)) (Q = "S" && A_Index = (Y ? O.count : ObjOwnPropCount(O)) ? M2 : E) (J != 0 || R ? (A_Index = (Y ? O.count : ObjOwnPropCount(O)) ? E : C) : E)
				if J = 0 && !R
					D .= (A_Index < (Y ? O.count : ObjOwnPropCount(O)) ? C : E)
			}
			D := RegExReplace(D, "\r?\n", "")
			D := RegExReplace(D, "\r?\n", "")
		}
		if J > R
			D .= "" CL(R + 1)
		if R = 0
			D := RegExReplace(D, "^\R+") (OT = "Array" ? S2 : M2)
		return D
	}
	ES(S, J := 1, U := false) {
			static ascii := Map("\", "\", "`a", "a", "`b", "b", "`t", "t", "`n", "n", "`v", "v", "`f", "f", "`r", "r", Chr(0x1B), "e", "`"", "`"", Chr(0x85), "N", Chr(0x2029), "P", Chr(0x2028), "L", "", "0", Chr(0xA0), "_")
			switch Type(S) {
				case "Float":
					if (v := '', d := InStr(S, 'e'))
						v := SubStr(S, d), S := SubStr(S, 1, d - 1)
					if ((StrLen(S) > 17) && (d := RegExMatch(S, "(99999+|00000+)\d{0,3}$")))
						S := Round(S, Max(1, d - InStr(S, ".") - 1))
					return S v
				case "Integer":
					return S
				case "String":
					v := ""
					if (U && RegExMatch(S, "m)[\x{7F}-\x{7FFF}]")) {
						Loop Parse S
							v .= ascii.Has(A_LoopField) ? "\" ascii[A_LoopField] : Ord(A_LoopField) < 128 ? A_LoopField : "\u" format("{1:.4X}", Ord(A_LoopField))
						return '"' v '"'
					} else {
						Loop Parse S
							v .= ascii.Has(A_LoopField) ? "\" ascii[A_LoopField] : A_LoopField
						return '"' v '"'
					}
				default:
					return S == JSON.true ? "true" : S == JSON.false ? "false" : "null"
			}
		}
		CL(i) {
			Loop (s := "", i - 1)
				s .= space
			return s
		}
	}
}
class Database {
    __New(databaseFile) {
        ; open database connection
        this.connection := SQLite3_Open(databaseFile)
    }

    Query(sql) {
        ; execute SQL statement and get result set
        result := SQLite3_Query(this.connection, sql)
        
        ; loop through result set and do something with each row
        While SQLite3_Fetch(result)
        {
            MsgBox(SQLite3_Column(result, 0) . " " . SQLite3_Column(result, 1))
        }
        
        ; close result set
        SQLite3_Free(result)
    }

    __Delete() {
        ; close database connection when object is deleted
        SQLite3_Close(this.connection)
    }
}
class Repository {
    __New(database) {
        this.database := database
    }
    
    GetUser(userId) {
        sql := "SELECT * FROM Users WHERE Id = " . userId
        this.database.Query(sql)
        ; parse query result and return user object
    }
}
class UserService {
    __New(repository) {
        this.repository := repository
    }
    
    GetUser(userId) {
        return this.repository.GetUser(userId)
    }
}
class MFile {

	__New(fileName, mode := "r", encoding := "UTF-8") {
		this.fileName := fileName
		this.mode := mode
		this.encoding := encoding
		this.file := FileOpen(this.fileName, this.mode, this.encoding)
	}
	WriteLn(str) {
        ; write string to file followed by a line break
        super.Write(str . "`n")
    }
	Writefile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
	}
	Runfile(whichFile, text := "") {
		run(whichfile) 
		return
	}
	ReadFile(whichFile) {
	fileObj := FileOpen(whichFile, "r")
	fileObj.Seek(0, 0)
	text := fileObj.Read()
	fileObj.Close()
	return text
	}
	
	Close() {
		FileClose(this.file)
	}
	__Delete() {
		this.Close()
	}
}
Class CleanInputBox extends Gui {

    Width     := Round(A_ScreenWidth / 1920 * 1200)
    TopMargin := Round(A_ScreenHeight / 1080 * 200)

    /**
     * Get a gui to type into.
     * Close it by pressing Escape. (This exits the entire thread)
     * Accept your input by pressing Enter.
     * Call WaitForInput() after creating the class instance.
     */
    __New() {
        super.__New("AlwaysOnTop -Caption")
        this.DarkMode().MakeFontNicer(30)
        this.MarginX := 0

        this.InputField := this.AddEdit(
            "x0 Center -E0x200 Background"
            this.BackColor " w" this.Width
        )

        this.Input := ""
        this.isWaiting := true
        this.RegisterHotkeys()
    }

    Show() => (super.Show("y" this.TopMargin " w" this.Width), this)

    /**
     * Occupy the thread until you type in your input and press
     * Enter, returns this input
     * @returns {String}
     */
    WaitForInput() {
        this.Show()
        while this.isWaiting {
        }
        return this.Input
    }

    SetInput() {
        this.Input := this.InputField.Text
        this.isWaiting := false
        this.Finish()
    }

    SetCancel() {
        this.isWaiting := false
        this.Finish()
    }

    RegisterHotkeys() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", (*) => this.SetInput(), "On")
        this.OnEvent("Escape", (*) => this.SetCancel())
    }

    Finish() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", "Off")
        this.Minimize()
        this.Destroy()
    }
}
;Class InternetSearch extends CleanInputBox {
       
    ;    __New(searchEngine) {
    ;       super.__New()
    ;       this.SelectedSearchEngine := this.AvailableSearchEngines[searchEngine]
    ;    }
       
    ;    FeedQuery(input) {
    ;       restOfLink := this.SanitizeQuery(input)
    ;       RunLink(this.SelectedSearchEngine restOfLink)
    ;    }
       
    ;    DynamicallyReselectEngine(input) {
    ;       for key, value in this.SearchEngineNicknames {
    ;          if input.RegExMatch("^" key " ") {
    ;             this.SelectedSearchEngine := value
    ;             input := input[3, -1]
    ;             break
    ;          }
    ;       }
    ;       return input
    ;    }

    ;    TriggerSearch() {
    ;       if !input := super.WaitForInput() {
    ;          return false
    ;       }
    ;       query := this.DynamicallyReselectEngine(input)
    ;       this.FeedQuery(query)
    ;    }
       
    ;    AvailableSearchEngines := Map(
    ;       "Google",  "https://www.google.com/search?q=",
    ;       "Youtube", "https://www.youtube.com/results?search_query=",
    ;       "Emoji",   "https://emojipedia.org/search/?q=",
    ;       "Yandex",  "https://yandex.ru/search/?text=",
    ;    )
       
    ;    SearchEngineNicknames := Map(
    ;       "g",  this.AvailableSearchEngines["Google"],
    ;       "y",  this.AvailableSearchEngines["Youtube"],
    ;       "e",  this.AvailableSearchEngines["Emoji"],
    ;       "ya", this.AvailableSearchEngines["Yandex"],
    ;    )

    ;    ;Rename suggestion by @Micha-ohne-el, used to be ConvertToLink()
    ;    SanitizeQuery(query) { 
    ;       SpecialCharacters := '%$&+,/:;=?@ "<>#{}|\^~[]``'.Split()
    ;       for key, value in SpecialCharacters {
    ;          query := query.Replace(value, "%" TransfToHex(Ord(value), false))
    ;       }
    ;       return query
    ;    }
; }
class Stopwatch {

   /**
    * The time your stopwatch started at
    * In YYYYMMDDHH24MISS format
    * @type {Integer}
    */
   startingTime := unset

   /**
    * Start the stopwatch
    * @returns {Integer} The startingTime property
    */
   Start() => this.startingTime := A_Now

   /**
    * The time passed after the start of the stopwatch
    * @type {String} time in format HH:mm:ss
    */
   CurrTime {
      get => FormatTime(Stopwatch.__AddPaddingForDateNum(A_Now - this.startingTime), "HH:mm:ss")
   }

   /**
    * FormatTime requires the YYYYMMDDHH24MISS format to format a number into a string
    * It has to have the leading zeros as well, this function adds them
    * @private
    * @returns {Integer} A valid YYYYMMDDHH24MISS number
    */
   static __AddPaddingForDateNum(num) {
      while StrLen(num) < 14 {
         num := 0 num
      }
      return num
   }

   /**
    * The time your stopwatch started at
    * In YYYYMMDDHH24MISS format
    * @type {Integer}
    */
   static startingTime := 0

   /**
    * Start the stopwatch by setting the startingTime property
    * @returns {Integer} The startingTime property
    */
   static Start() => this.startingTime := A_Now

   /**
    * The time passed after the start of the stopwatch
    * @type {String} time in format HH:mm:ss
    */
   static CurrTime {
      get => FormatTime(this.__AddPaddingForDateNum(A_Now - this.startingTime), "HH:mm:ss")
   }
}
Class FileSystemSearch extends Gui {

   /**
    * Find all the matches of your search request within the currently 
    * opened folder in the explorer.
    * The searcher recurses into all the subfolders.
    * Will search for both files and folders.
    * After the search is completed, will show all the matches in a list.
    * Call StartSearch() after creating the class instance if you can pass 
    * the input yourself.
    * Call GetInput() after creating the class instance if you want to have 
    * an input box to type in your search into.
    */
   __New(searchWhere?, caseSense := "Off") {
      super.__New("+Resize", "These files match your search:")

      this.MakeFontNicer(14)
      this.DarkMode()

      this.List := this.AddText(, "
      (
         Right click on a result to copy its full path. 
         Double click to open it in explorer.
      )")

      this.WidthOffset  := 35
      this.HeightOffset := 80

      this.List := this.AddListView(
         "Count50 Background" this.BackColor, 
         /**
          * Count50 — we're not losing much by allocating more memory 
          * than needed, 
          * and on the other hand we improve the performance by a lot 
          * by doing so
          */
         ["File", "Folder", "Directory"]
      ) 

      this.caseSense := caseSense

      if !IsSet(searchWhere) {
         this.ValidatePath()
      } else {
         this.path := searchWhere
      }
      
      this.SetOnEvents()
   }

   /**
    * Get an input box to type in your search request into.
    * Get a list of all the matches that you can open in explorer.
    */
   GetInput() {
      if !input := CleanInputBox().WaitForInput() {
         return false
      }
      this.StartSearch(input)
   }

   ValidatePath() {
      SetTitleMatchMode("RegEx")
      try this.path := WinGetTitle("^[A-Z]: ahk_exe explorer\.exe")
      catch Any {
         Info("Open an explorer window first!")
         Exit()
      }
   }
   
   /**
    * Get a list of all the matches of *input*.
    * You can either open them in explorer or copy their path.
    * @param input *String* 
    */
   StartSearch(input) {
      /**
       * Improves performance rather than keeping on adding rows 
       * and redrawing for each one of them
       */
      this.List.Opt("-Redraw") 

      ;To remove the worry of "did I really start the search?"
      gInfo := Infos("The search is in progress") 
      
      if this.path ~= "^[A-Z]:\\$" {
         this.path := this.path[1, -2]
      }

      loop files this.path "\*.*", "FDR" {
         if !A_LoopFileName.Find(input, this.caseSense) {
            continue
         }
         if A_LoopFileAttrib.Find("D")
            this.List.Add(, , A_LoopFileName, A_LoopFileDir)
         else if A_LoopFileExt
            this.List.Add(, A_LoopFileName, , A_LoopFileDir)
      }
      
      try WinClose(gInfo.Hwnd)
      
      this.List.Opt("+Redraw")
      this.List.ModifyCol() ;It makes the columns fit the data — @rbstrachan
      
      this.Show("AutoSize")
   }
   
   DestroyResultListGui() {
      this.Minimize()
      this.Destroy()
   }
   
   SetOnEvents() {
      this.List.OnEvent("DoubleClick", 
         (guiCtrlObj, selectedRow) => this.ShowResultInFolder(selectedRow)
      )
      this.List.OnEvent("ContextMenu", 
         (guiCtrlObj, rowNumber, *) => this.CopyPathToClip(rowNumber)
      ) 
      this.OnEvent("Size", 
         (guiObj, minMax, width, height) => this.FixResizing(width, height)
      )
      this.OnEvent("Escape", (guiObj) => this.DestroyResultListGui())
   }
   
   FixResizing(width, height) {
      this.List.Move(,, width - this.WidthOffset, height - this.HeightOffset)
      /**
       * When you resize the main gui, the listview also gets resize to have the same 
       * borders as usual.
       * So, on resize, the onevent passes *what* you resized and the width and height 
       * that's now the current one.
       * Then you can use that width and height to also resize the listview in relation 
       * to the gui
       */
   }

   ShowResultInFolder(selectedRow) {
      try Run("explorer.exe /select," this.GetPathFromList(selectedRow)) 
      /**
       * By passing select, we achieve the cool highlighting thing when the file / folder 
       * gets opened. (You can pass command line parameters into the run function)
       */
   }
   
   CopyPathToClip(rowNumber) {
      A_Clipboard := this.GetPathFromList(rowNumber)
      Info("Path copied to clipboard!")
   }
   
   GetPathFromList(rowNumber) {
      /**
       * The OnEvent passes which row we interacted with automatically
       * So we read the text that's on the row
       * And concoct it to become the full path
       * This is much better performance-wise than adding all the full paths to an array 
       * while adding the listviews (in the loop) and accessing it here.
       * Arguably more readable too
       */

      file := this.List.GetText(rowNumber, 1)
      dir  := this.List.GetText(rowNumber, 2)
      path := this.List.GetText(rowNumber, 3)

      return path "\" file dir ;No explanation required, it's just logic — @rbstrachan
   }
}
class Infos {
   
   autoCloseTimeout := 0
   
   static fontSize         := 20
   static ranOnce          := false
   static guiWidthModifier := 5 ; if you set this to 4, the infos will be closer together. I don't recommend setting any other number, but feel free to experiment
   
   ; These get set the first time you create an instance of this class
   static guiWidth        := unset
   static maximumInfos    := unset
   static AvailablePlaces := unset ; Starts with a capital letter because it's an object, not a primitive
   
   /**
    * To use Info, you just need to create an instance of it, no need to call any method after
    * @param text *String* 
    * @param autoCloseTimeout *Integer* in milliseconds. Doesn't close automatically
    */
   __New(text, autoCloseTimeout := 0) {
      this.autoCloseTimeout := autoCloseTimeout
      this.text := text
      this.__CreateGui()
      this.__DoOnce()
      if !this.__GetAvailableSpace()
         this.__StopDueToNoSpace()
      this.__SetupHotkeysAndEvents()
      this.__SetupAutoclose()
      this.__Show()
   }
   
   __bfDestroy := this.Destroy.Bind(this)
   Destroy(*) {
      try HotIfWinExist("ahk_id " this.gInfo.Hwnd) 
      catch Any {
         return false
      }
      Hotkey("Escape", "Off")
      this.gInfo.Destroy() 
      Infos.AvailablePlaces[this.currYCoord] := false 
      return true
   }
   
   /**
    * Will replace the text in the Info
    * If the window is destoyed, just creates a new Info. Otherwise: 
    * If the text is the same length, will just replace the text without recreating the gui.
    * If the text is of different length, will recreate the gui in the same place 
    * (once again, only if the window is not destroyed)
    * @param newText *String*
    * @returns {Infos} the class object
    */
   ReplaceText(newText) {

      ; If the gui doesn't exist
      try WinExist(this.gInfo) ; Not an if because we can't access the gui object once it's destroyed
      catch 
         return Infos(newText, this.autoCloseTimeout)

      ; If the text provided is the same length as in the existing gui's window
      if StrLen(newText) = StrLen(this.gcText.Text) {
         this.gcText.Text := newText
         this.__SetupAutoclose()
         return this
      }
      
      ; If the text length is different, but the window exists (it's a refresh)
      Infos.AvailablePlaces[this.currYCoord] := false 
      return Infos(newText, this.autoCloseTimeout)
   }
   
   __CreateGui() {
      this.gInfo  := Gui("AlwaysOnTop -Caption +ToolWindow").DarkMode().MakeFontNicer(Infos.fontSize)
      this.gcText := this.gInfo.AddText(, this.text)
   }
   
   __DoOnce() {
      if Infos.ranOnce { 
         return
      }

      Infos.guiWidth     := this.gInfo.MarginY * Infos.guiWidthModifier
      Infos.maximumInfos := Floor(A_ScreenHeight / Infos.guiWidth)

      Infos.AvailablePlaces := Map()
      index := 0
      loop Infos.maximumInfos {
         index++
         Infos.AvailablePlaces.Set(index * Infos.guiWidth - Infos.guiWidth, false)
      }
      Infos.ranOnce := true
   }
   
   __GetAvailableSpace() {
      for key, value in Infos.AvailablePlaces {
         if value 
            continue
         this.currYCoord := key
         Infos.AvailablePlaces[this.currYCoord] := true
         break
      }
      _ := this.currYCoord 
      if !IsSet(_) ; Ahk limitation
         return false
      return true
   }
   
   __StopDueToNoSpace() => this.gInfo.Destroy()
   
   __SetupHotkeysAndEvents() {
      HotIfWinExist("ahk_id " this.gInfo.Hwnd)
      Hotkey("Escape", this.__bfDestroy, "On")
      this.gcText.OnEvent("Click", this.__bfDestroy)
      this.gInfo.OnEvent("Close", this.__bfDestroy)
   }
   
   __SetupAutoclose() {
      if this.autoCloseTimeout {
         SetTimer(this.__bfDestroy, -this.autoCloseTimeout)
      }
   }

   __Show() => this.gInfo.Show("AutoSize NA x0 y" this.currYCoord)
}
Class Timer {

   /**
    * You start the timer when you create an object of the class
    * @param time *Integer* 1 hour 20 minutes would be 80, and not 120
    * @param isInMinutes *Boolean* Specify false if you want to create a timer in seconds instead of minutes
    * @param shouldExitapp *Boolean* Should the timer exit the script once it finishes
    * @param shouldRing *Boolean* Should the timer beep with an Infos or just stop your music once it finishes
    */
   __New(time, isInMinutes := true, shouldExitapp := false, shouldRing := true) {

      this.shouldRing := shouldRing

      this.timeWord := time " " (isInMinutes ? "minutes" : "seconds")
      this.endTime := Round(A_TickCount + time * (isInMinutes ? 60000 : 1000))

      this.shouldExitapp := shouldExitapp

      this.Start()
   }

   /**
    * Stop the timer preemtively, doesn't stop the alarm if it's already ringing
    * @private
    */
   Stop() => SetTimer(this.foIsItTime, 0)

   /**
    * Starts the timer. Is automatically called from the constructor
    * @private
    */
   Start() {
      SetTimer(this.foIsItTime, 500)
      Info("Timer set for " this.timeWord "!")
   }

   /**
    * Bound function needed for the timer's time checker
    * @private
    */
   foIsItTime := this.IsItTime.Bind(this)

   /**
    * Continues to check whether the time has run out
    * Once it has, disables the timer calling this method
    * And either starts ringing, or stops your music, depending on what you set this.shouldRing in the constructor
    * @private
    */
   IsItTime() {
      if A_TickCount < this.endTime {
         return
      }

      this.Stop()
      if this.shouldRing
         this.Alarm()
      else
         this.StopSound()
   }

   /**
    * The ringer. Will show you an Infos that displays the time you set that timer for
    * Will continue to beep intermittently until you close the info (press escape or click on the info)
    * @private
    */
   Alarm() {
      infoHwnd := Infos("Your timer for " this.timeWord " is up!").gInfo.Hwnd
      while WinExist(infoHwnd) {
         SoundBeep()
         Sleep(200)
      }
      if this.shouldExitapp {
         ExitApp()
      }
   }

   /**
    * An alternative to the usual beeping ringer, that will instead just disable your music
    * You can get this behavior if you set the "shouldRing" parameter in the constructor to false
    * @private
    */
   StopSound() => Send("{Media_Stop}")
}
class Counter {
   static num := 0

   static ShowNumber(newNum) {
      static currInfo := Info(newNum)
      currInfo := currInfo.ReplaceText(newNum)
   }
   static Increment() => this.ShowNumber(++this.num)
   static Decrement() => this.ShowNumber(--this.num)
   static Reset() => this.ShowNumber(this.num := 0)
   static Send() => Send(this.num)
   static Show() => this.ShowNumber(this.num)
}
class HoverScreenshot {

   /**
    * Full path to the picture you want to hover (show).
    * @type {String}
    */
   picturePath := ""

   /**
    * The gui object
    * Will be set in the constructor of the class
    * @type {Gui}
    */
   gHover := unset

   /**
    * The guictrl object of the picture
    * Will be set after Show() is called on the class instance
    * @type {GuiCtrl}
    */
   gcPicture := unset

   /**
    * Make a picture of your choosing appear on your screen
    * @example <caption>Choose a picture to hover and do so</caption>
    * gHover := HoverScreenshot()
    * if gHover := gHover.SelectPath()
    *    gHover.Show()
    * ; or this syntax:
    * try HoverScreenshot().SelectPath().Show()
    * @example <caption>Always show the same picture, the path of which you already know</caption>
    * gHover := HoverScreenshot()
    * gHover.picturePath := "C:\Pictures\My favorite picture 257.png"
    * gHover.Show()
    */
   __New() {
      this.gHover := Gui("AlwaysOnTop +ToolWindow -Caption")
   }

   /**
    * Brings up an interactive menu where the user can pick the picture to show
    * (sets the picturePath property).
    * Will always start in the folder where windows stores your Win+Shift+S screenshots,
    * filtering only pngs (since there are only pngs there).
    * You can still go and pick a picture from any other place, just make sure the format is
    * supported
    * @returns {Boolean/HoverScreenshot} `this` if you picked something, false if you didn't
    */
   SelectPath() {
      picturePath := FileSelect(, Paths.SavedScreenshots,, "*.png")
      if picturePath {
         this.picturePath := picturePath
         return this
      }
      return false
   }

   /**
    * Shows the gui with the picture you set
    * Before calling this method, make sure you set the picturePath property to the path of the
    * picture you want to show
    * @throws {MethodError} If the picturePath property is not a path / not set
    */
   Show() {
      if !(this.picturePath ~= "^[A-Z]:\\") {
         HoverScreenshot.Exceptions.PicturePathWrong(this.picturePath)
      }
      this.gcPicture := this.gHover.AddPicture(, this.picturePath)
      WinSetTransColor(0xF0F0F0, this.gHover.Hwnd)

      this.gcPicture.OnEvent("DoubleClick", (guiCtrlObj, *) => guiCtrlObj.Gui.Destroy())
      this.gcPicture.OnEvent("Click",       (guiCtrlObj, *) => guiCtrlObj.Gui.PressTitleBar())

      this.gHover.Show("AutoSize NA")
   }
class Exceptions {
      /**
       * Throw this if the picturePath property is not set / is not a path
       * @param picturePath pass the current picturePath to show in the error message
       * @throws {MethodError}
       */
      static PicturePathWrong(picturePath) {
         throw MethodError("
            (
               You didn't set a picture path to show
               Use the "SelectPath()" method to let the user pick the picture to show in a menu interactively
               Set the "picturePath" property manually if you have your own way of getting the path
            )",
            -2,
            "
            (
               picturePath property
               value:
            )" picturePath "`n" "
            (
               type:
            )" Type(picturePath)
         )
      }
   }
}
class ErrorAccumulator
{
    Errors := []                        ; Array for accumulated errors.
    _cb := AccumulateError.Bind(this.Errors)
    Start() => OnError(this._cb, -1)    ; Register our cb before others.
    Stop() => OnError(this._cb, 0)      ; Unregister our cb.
    Last => this.Errors[-1]             ; Most recent error.
    Count => this.Errors.Length         ; Number of accumulated errors.
    __item[i] => this.Errors[i]         ; Shortcut for indexing.
    __delete() => this.Stop()           ; For tying to function scope.
}
Class _CleanInputBox extends Gui {

    Width     := Round(A_ScreenWidth / 1920 * 1200)
    TopMargin := Round(A_ScreenHeight / 1080 * 200)

    /**
     * Get a gui to type into.
     * Close it by pressing Escape. (This exits the entire thread)
     * Accept your input by pressing Enter.
     * Call WaitForInput() after creating the class instance.
     */
    __New() {
        super.__New("AlwaysOnTop -Caption")
        this.DarkMode().MakeFontNicer(30)
        this.MarginX := 0

        this.InputField := this.AddEdit(
            "x0 Center -E0x200 Background"
            this.BackColor " w" this.Width
        )

        this.Input := ""
        this.isWaiting := true
        this.RegisterHotkeys()
    }

    Show() => (super.Show("y" this.TopMargin " w" this.Width), this)

    /**
     * Occupy the thread until you type in your input and press
     * Enter, returns this input
     * @returns {String}
     */
    WaitForInput() {
        this.Show()
        while this.isWaiting {
        }
        return this.Input
    }

    SetInput() {
        this.Input := this.InputField.Text
        this.isWaiting := false
        this.Finish()
    }

    SetCancel() {
        this.isWaiting := false
        this.Finish()
    }

    RegisterHotkeys() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", (*) => this.SetInput(), "On")
        this.OnEvent("Escape", (*) => this.SetCancel())
    }

    Finish() {
        HotIfWinactive("ahk_id " this.Hwnd)
        Hotkey("Enter", "Off")
        this.Minimize()
        this.Destroy()
    }
}
class ViewModel extends View
{
    Prop1
    {
        get => this._text1.Text
        set => this._text1.Text := Value
    }

    __New() {
        super.__New()
        this._button.OnEvent("Click", ObjBindMethod(this, "ButtonClicked"))
    }

    ButtonClicked(*) {
        this.Prop1 := "Button Clicked"
    }
}
class ParentModel {
    __New(w, h, title) {
        this.w := w
        this.h := h
        this.title := title
   }
}
class ParentController {
    __New(model) {
        this.model := model
    }
    Gui_Close(Gui) {
        Gui.Destroy()
    }
}
class ParentView extends Gui {
    __New(controller) {
        super.__New(, controller.model.title)
        super.Show("w" controller.model.w " h" controller.model.h)
        super.OnEvent("Close",  ObjBindMethod(controller, "Gui_Close"))
        super.OnEvent("Escape", ObjBindMethod(controller, "Gui_Close"))
    }
}
class ChildModel {
    __New(x, y, w, icon, parent) {
        this.x := x
        this.y := y
        this.w := w
        this.h := w
        this.bar := {h:10, time:800, color:"White", backColor:"Gray"}
        this.icon := {w:36, h:36, file:icon}
        this.parent := parent
    }
}
class ChildController {
    __New(model) {
        this.model := model
    }
    LoadIcon(GuiCtrl, *) {
        if icon := FileSelect(3, "./" , "Select an Icon", "*.png; *.ico")
            GuiCtrl.Value := this.model.icon.file := icon
   }
}
class ChildView extends Gui {
    __New(controller) {
        super.__New("-Border -Caption -SysMenu +ToolWindow -0x800000 +E0x08000000 +Parent" controller.model.parent.hwnd)
        super.MarginX := (controller.model.w - controller.model.icon.w) // 2
        super.MarginY := (controller.model.h - controller.model.icon.h - controller.model.bar.h) // 2
        pic := super.Add("Picture", "xm ym w" controller.model.icon.w " h" controller.model.icon.h, controller.model.icon.file)
        bar := super.Add("Progress", "xm y" (controller.model.h - controller.model.bar.h) " w" controller.model.icon.w " h" controller.model.bar.h " c" controller.model.bar.color " Background" controller.model.bar.backColor)
        super.Show("x" controller.model.x " y" controller.model.y " w" controller.model.w " h" controller.model.h)
        pic.OnEvent("Click", ObjBindMethod(CoolDownTimer(controller.model.bar.time, bar), "Start"))
        pic.OnEvent("ContextMenu", ObjBindMethod(controller, "LoadIcon"))
   }
}

/*Class _InternetSearch extends CleanInputBox {
   
   __New(searchEngine) {
      super.__New()
      this.SelectedSearchEngine := this.AvailableSearchEngines[searchEngine]
   }
   
   FeedQuery(input) {
      restOfLink := this.SanitizeQuery(input)
      RunLink(this.SelectedSearchEngine restOfLink)
   }
   
   DynamicallyReselectEngine(input) {
      for key, value in this.SearchEngineNicknames {
         if input.RegExMatch("^" key " ") {
            this.SelectedSearchEngine := value
            input := input[3, -1]
            break
         }
      }
      return input
   }

   TriggerSearch() {
      if !input := super.WaitForInput() {
         return false
      }
      query := this.DynamicallyReselectEngine(input)
      this.FeedQuery(query)
   }
   
   AvailableSearchEngines := Map(
      "Google",  "https://www.google.com/search?q=",
      "Youtube", "https://www.youtube.com/results?search_query=",
      "Emoji",   "https://emojipedia.org/search/?q=",
      "Yandex",  "https://yandex.ru/search/?text=",
   )
   
   SearchEngineNicknames := Map(
      "g",  this.AvailableSearchEngines["Google"],
      "y",  this.AvailableSearchEngines["Youtube"],
      "e",  this.AvailableSearchEngines["Emoji"],
      "ya", this.AvailableSearchEngines["Yandex"],
   )

   ;Rename suggestion by @Micha-ohne-el, used to be ConvertToLink()
   SanitizeQuery(query) { 
      SpecialCharacters := '%$&+,/:;=?@ "<>#{}|\^~[]``'.Split()
      for key, value in SpecialCharacters {
         query := query.Replace(value, "%" TransfToHex(Ord(value), false))
      }
      return query
   }}*/
/*
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
    }
    */
  
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
        }*/
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[Functions]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
CreateEditBox() {
        ; Create a GUI window and add an Edit control
        this.GUI := Gui()
        this.GUI.Add("Edit", "w200 h20", "")
        this.GUI.OnEvent("Close", (*) => this.GUI.Hide())
    }
InputBoxDropDownList(Prompt,Title?,Options?,aChoices?, VarDefault?){
    oValues := Object() ; allows to return
        
    DDLGui := Gui(Options ?? Unset, Title ?? Unset)
        ;This line creates a new GUI window using the Gui() function. The Options and Title parameters are passed in if
        ; they were provided, otherwise Unset is used as a default value. The resulting GUI object is assigned to the variable DDLGui.
        
    (IsSet(Prompt)) ? DDLGui.AddText(,Prompt) : ""
        ;This line adds a text prompt to the GUI window using the AddText() method. 
        ;The Prompt parameter is passed in if it was provided, and an empty string is used if it was not provided. 
        ;The IsSet() function is used to check if the Prompt parameter was provided.

    ogDDL := DDLGui.AddDropDownList("w160 vNewValue", aChoices ?? [] )
        ;This line adds a drop-down list control to the GUI window using the AddDropDownList() method. 
        ;The w160 option sets the width of the control to 160 pixels, and the vNewValue option assigns the 
        ;selected value to a variable called NewValue. The aChoices parameter is passed in as the list of options to 
        ;be displayed in the drop-down list control. An empty array is used as the default value if aChoices was not provided.

    (IsSet(VarDefault)) ? ogDDL.Text := VarDefault : ""
        ;This line sets the default value of the drop-down list control to the value of the VarDefault parameter, if it was provided. The Text property of the control is set to the value of VarDefault using a ternary operator. If VarDefault was not provided, an empty string is used.

    DDLGui.AddButton("w75","OK").OnEvent("Click", (*)=>(oValues := DDLGui.Submit()))
        ;This line adds an "OK" button to the GUI window using the AddButton() method. 
        ;The w75 option sets the width of the button to 75 pixels. An OnEvent() method is chained to the button to
        ; listen for a click event. When the button is clicked, the Submit() method of the GUI is called to retrieve 
        ;the selected value and store it in the oValues object.

    DDLGui.AddButton("yp x+10 w75","Cancel").OnEvent("Click", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
        ;This line adds a "Cancel" button to the GUI window using the AddButton() method. 
        ;The yp x+10 w75 option sets the position and width of the button. Another OnEvent() method is chained 
        ;to the button to listen for a click event. When the button is clicked, 
        ;the NewValue property of the oValues object is set to "Cancel", and the GUI is destroyed.

    DDLGui.OnEvent("Close", (*)=>(oValues.NewValue:="Cancel", DDLGui.Destroy()))
        ;This line adds an `OnEvent()` method to the GUI window to listen for a "Close" event. 
        ;When the GUI is closed (either by clicking the "X" button or pressing Alt+F4), 
        ;the `NewValue` property of the `oValues` object is set to "Cancel", and the GUI is destroyed.

    DDLGui.Show()

    WinWaitClose(DDLGui)
        ;This line waits for the GUI window to be closed before continuing execution. 
        ;The `WinWaitClose()` function blocks the script until the specified window (`DDLGui` in this case) is closed.


    return oValues.NewValue
        ;This line returns the selected value as a string. 
        ;The `NewValue` property of the `oValues` object is used to retrieve the selected value. 
        ;If the user clicked the "OK" button, the selected value will be the option they chose from the drop-down list.
        ;If the user clicked the "Cancel" button or closed the GUI window, the selected value will be the string "Cancel".
}
LogError(exception, mode) {
    FileAppend "Error on line " exception.Line ": " exception.Message "`n"
        , "errorlog.txt"
    return true
}
    ;Use OnError to implement alternative error handling methods. Caveat: OnError is ineffective while Try is active.
AccumulateErrors()
{
    local ea := ErrorAccumulator()
    ea.Start()
    return ea
}
; This is the OnError callback function. 'errors' is given a value via Bind().
AccumulateError(errors, e, mode)
{
    if mode != "Return" ; Not continuable.
        return
    if e.What = "" ; Expression defect or similar, not a built-in function.
        return
    try {
        ; Try to print the error to stdout.
        FileAppend Format("{1} ({2}) : ({3}) {4}`n", e.File, e.Line, e.What, e.Message), "*"
        if HasProp(e, "extra")
            FileAppend "     Specifically: " e.Extra "`n", "*"
    }
    errors.Push(e)
    return -1 ; Continue.
}
RearrangeWindows()
{
    ; Start accumulating errors in 'err'.
    local err := AccumulateErrors()

    ; Do some things that might fail...
    MonitorGetWorkArea , &left, &top, &right, &bottom
    width := (right-left)//2, height := bottom-top
    WinMove left, top, width, height, A_ScriptFullPath
    WinMove left+width, top, width, height, "AutoHotkey v2 Help"

    ; Check if any errors occurred.
    if err.Count
        MsgBox err.Count " error(s); last error at line #" err.Last.Line
    else
        MsgBox "No errors"

    ; Stop is called automatically when the variable goes out of scope,
    ; since only we have a reference to the object.  This causes OnError
    ; to be called to unregister the callback.
    ;err.Stop()
}
MenuHandler(Item, *) {
    MsgBox "You selected " Item
}
FibF() {
    a := 0, b := 1
    return (&n) => (
        n := c := b, b += a, a := c,
        true
    )
}
; Function to sort the classes by name
SortClasses(ahclasses) {
    sorted := {}

    for k, v in ahclasses {
        sorted[class_name] := class_code
    }
    ; Sort dictionary keys
    sorted_keys := Object()
    for key in sorted {
        sorted_keys.Insert(key)
    }
    sorted_keys.Sort()
    
    ; Create a new sorted dictionary
    sorted_output := Object()
    for key in sorted_keys {
        sorted_output[key] := sorted[key]
    }

    return sorted_output
}
/*DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)
{
	MsgBox Output  ; Display the information accumulated by the callback.
}*/
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
    Control := ""
    thisGui := GuiFromHwnd(hwnd)
    thisGuiControl := GuiCtrlFromHwnd(hwnd)
    if thisGuiControl
    {
        thisGui := thisGuiControl.Gui
        Control := "`n(in control " . thisGuiControl.ClassNN . ")"
    }
    ToolTip "You left-clicked in Gui window '" thisGui.Title "' at client coordinates " X "x" Y "." Control
}    
EnumWindowsProc(hwnd, lParam)
{
    global Output
    win_title := WinGetTitle(hwnd)
    win_class := WinGetClass(hwnd)
    if win_title
        Output .= "HWND: " hwnd "`tTitle: " win_title "`tClass: " win_class "`n"
    return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}
PrepareMenu(PATH) {
    ; Define static URLs for various search types

    Folderpath := PATH 
    menuPath := Menu()
    menuPath.add("text",LoopOverFolder ,folderpath)

    static urls := { 1: "https://www.google.com/search?hl=en&q="
    , 2: "https://www.google.com/search?site=imghp&tbm=isch&q="
    , 3: "https://www.google.com/maps/search/"
    , 4: "https://translate.google.com/?sl=auto&tl=en&text=" }
    
    ; GUI loading/progress bar
    Gui1 := Gui("+ToolWindow -MinimizeBox +Border")
    gui1.myProgress := Gui1.Add("Progress", "w200 myProgress range1-%items% 0")

    googler := CleanInputBox()

    ; Add name, icon, and separating line for Google search
    menupath.Add("g&oogler", googler) ; Regular search
    menupath.Add()

    ; Add custom items using algorithm
    LoopOverFolder(folderpath)

    ; Add admin panel
    Sleep 200
    menuPath.Add("&Admin", ":%PATH%\Admin")
    menuPath.NewSub("&Admin")
    menuPath.Add("&3 Restart", "ReloadProgram")
    menuPath.Add("&2 Exit", "ExitApp")
    menuPath.Add("&1 Go to Parent Folder", "GoToRootFolder")
    menuPath.Add("&4 Add Custom Item", "GoToCustomFolder")
    menuPath.EndSub()
    menuPath.Add("&1 Admin", ":&Admin")
    menuPath.Add("&2 New", ":&New")
    menuPath.Add()
    menuPath.Add("&" ScriptName " vers. " Version, "github")
    menuPath.Add()

    ; Loading bar GUI is no longer needed, remove it from memory
    Gui1.Destroy()
}
LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray := []

    ; Loop over all files and folders in input path, but do NOT recurse

   		Loop Files, PATH "\*.*", "R"  ; Recurse into subfolders.
    		{
		        ; Determine whether current item is a directory or file
		        if (FileExist(A_LoopFilePath) = "D")
		            FolderArray.Push(A_LoopFilePath)
		        else
		            FileArray.Push(A_LoopFilePath)
    		}

    ; Sort arrays for alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray
    {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Add folder as item to menu
        ;SplitPath, element, name, dir, ext, name_no_ext, drive
        SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive

        dir.Add("&" name, ":" element)
    }

    ; Then add all files to folders
    for index, element in FileArray
    {
        ; Add file as item to menu
        SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive
        dir.Add(name, "MenuEventHandler")

        FoundItem("File")
    }
}
FoundItem(whatwasfound){
    global
    myprogress.Add("myProgress", +1)

}
WriteFile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
}
AppendFile(whichFile, text) {
    if FileExist(whichFile)
        fileObj := FileOpen(whichFile, "a")
    else
        fileObj := FileOpen(whichFile, "w")
    fileObj.Seek(0, 2)
    fileObj.Write(text)
    fileObj.Close()
}
ReadFile(whichFile) {
   fileObj := FileOpen(whichFile, "r")
   fileObj.Seek(0, 0)
   text := fileObj.Read()
   fileObj.Close()
   return text
}
WindowGetter() {

   ;Getting the current window's info
   winTitle   := WinGetTitle("A")
   winTitle_regex := ConvertToRegex(winTitle) ;Dependency from https://github.com/Axlefublr/lib-v2/Get.ahk
   winExePath := WinGetProcessPath("A")
   winExe     := WinGetProcessName("A")
   winID      := WinGetID("A")
   winPID     := WinGetPID("A")

   ;Gui creation
   g_WinGet := Gui(, "WindowGetter").DarkMode().MakeFontNicer()

   WinGet_hwnd := g_WinGet.hwnd

   ;Show the window's info
   g_WinGet_WinTitle       := g_WinGet.Add("Text", "Center", winTitle)
   g_WinGet_WinTitle_regex := g_WinGet.Add("Text", "Center", winTitle_regex)
   g_WinGet_WinExePath     := g_WinGet.Add("Text", "Center", winExePath)
   g_WinGet_WinExe         := g_WinGet.Add("Text", "Center", winExe)
   g_WinGet_WinID          := g_WinGet.Add("Text", "Center", "id: " winID)
   g_WinGet_WinPID         := g_WinGet.Add("Text", "Center", "pid: " winPID)

   ;Destroys the gui as well as every previously created hotkeys
   FlushHotkeys := (*) => (
      HotIfWinActive("ahk_id " WinGet_hwnd),
      Hotkey("1", "Off"),
      Hotkey("2", "Off"),
      Hotkey("3", "Off"),
      Hotkey("4", "Off"),
      Hotkey("5", "Off"),
      Hotkey("6", "Off"),
      Hotkey("Escape", "Off"),
      g_WinGet.Destroy()
   )

   ;This function copies the text you clicked to your clipboard and destroys the gui right after
   ToClip := (text, *) => (
      A_Clipboard := text,
      FlushHotkeys()
   )

   ;Making the func objects to later call in two separate instances
   ToClip_Title       := ToClip.Bind(winTitle) ;We pass the params of winSmth
   ToClip_Title_regex := ToClip.Bind(winTitle_regex)
   ToClip_Path        := ToClip.Bind(winExePath) ;To copy it, disable the hotkeys and destroy the gui
   ToClip_Exe         := ToClip.Bind(winExe)
   ToClip_ID          := ToClip.Bind(winID)
   ToClip_PID         := ToClip.Bind(winPID)

   HotIfWinActive("ahk_id " WinGet_hwnd)
   Hotkey("1", ToClip_Title, "On")
   Hotkey("2", ToClip_Title_regex, "On")
   Hotkey("3", ToClip_Path, "On")
   Hotkey("4", ToClip_Exe, "On")
   Hotkey("5", ToClip_ID, "On")
   Hotkey("6", ToClip_PID, "On")

   Hotkey("Escape", FlushHotkeys, "On")

   g_WinGet_WinTitle.OnEvent("Click",       ToClip_Title)
   g_WinGet_WinTitle_regex.OnEvent("Click", ToClip_Title_regex)
   g_WinGet_WinExePath.OnEvent("Click",     ToClip_Path)
   g_WinGet_WinExe.OnEvent("Click",         ToClip_Exe)
   g_WinGet_WinID.OnEvent("Click",          ToClip_ID)
   g_WinGet_WinPID.OnEvent("Click",         ToClip_PID)

   g_WinGet.OnEvent("Close", FlushHotkeys) ;Destroys the gui when you close the X button on it

   g_WinGet.Show("AutoSize y0")
}
KeyCodeGetter() {

   static values_hwnd := false
   static used := false

   if values_hwnd {
      Win({winTitle: values_hwnd}).MinMax()
      return
   }

   g_values := Gui(, "Key code getter").DarkMode().MakeFontNicer(30)

   values_hwnd := g_values.hwnd

   g_values_input := g_values.Add("Edit", "background171717")

   g_values_name := g_values.Add("Text", "w400", "Key name")
   g_values_SC   := g_values.Add("Text",, "SC code")
   g_values_VK   := g_values.Add("Text", "x+100", "VK code")

   Destruction(*) {
      HotIfWinActive("ahk_id " values_hwnd)
      Hotkey("Escape", "Off")
      Hotkey("Enter", "Off")
      values_hwnd := false
      g_values.Minimize()
      g_values.Destroy()

      if !used
         return

      Hotkey("F1", "Off")
      Hotkey("F2", "Off")
      Hotkey("F3", "Off")
      used := false
   }

   toClip := (what, *) => A_Clipboard := what

   Submit(*) {
      used := true

      input := g_values_input.value
      g_values_input.value := ""

      key_name := GetKeyName(input)
      key_SC   := GetKeySC(input)
      key_VK   := GetKeyVK(input)

      key_SC := Format("sc{:X}", key_SC) ;getkey sc/vk returns a base 10 value, when both of those are actually base 16. This makes absolutely no fucking sense. So, we use format to format a base 10 integer into a base 16 int for both of them
      key_VK := Format("vk{:X}", key_VK)

      g_values_name.Text := key_name
      g_values_SC.Text   := key_SC
      g_values_VK.Text   := key_VK

      HotIfWinActive("ahk_id " values_hwnd) ;If a hotkey to call this function is under a #HotIf, the hotkeys created in this functions will be affected by that. So, we have to specify that they should have no condition.
      Hotkey("F1", toClip.Bind(g_values_name.text), "On")
      Hotkey("F2", toClip.Bind(g_values_SC.text  ), "On")
      Hotkey("F3", toClip.Bind(g_values_VK.text  ), "On")

      g_values_name.OnEvent("Click", toClip.Bind(g_values_name.text))
      g_values_SC.OnEvent("Click",   toClip.Bind(g_values_SC.text))
      g_values_VK.OnEvent("Click",   toClip.Bind(g_values_VK.text))
   }

   HotIfWinActive("ahk_id " values_hwnd)
      Hotkey("Enter" , Submit     , "On")
      Hotkey("Escape", Destruction, "On")
   g_values.OnEvent("Close", Destruction)

   g_values.Show("AutoSize y0 x" A_ScreenWidth / 20 * 12.95)
}
CoordGetter() {
   CoordMode("Mouse", "Screen")
   MouseGetPos(&ScrX, &ScrY)

   CoordMode("Mouse", "Window")
   MouseGetPos(&WinX, &WinY)

   CoordMode("Mouse", "Client")
   MouseGetPos(&CliX, &CliY)

   CoordMode("Pixel", "Screen")
   pixel := PixelGetColor(ScrX, ScrY, "Alt Slow")

   g_CrdGet := Gui(, "Coord Getter").DarkMode().MakeFontNicer(30)

   CrdGet_hwnd := g_CrdGet.hwnd

   toClip := (text, *) => A_Clipboard := text

   g_CrdGet.Add("Text", , "Screen: ")
      .OnEvent("Click", toClip.Bind(ScrX " " ScrY))
   g_CrdGet.Add("Text", "x+", "x" ScrX " ")
      .OnEvent("Click", toClip.Bind(ScrX))
   g_CrdGet.Add("Text", "x+", "y" ScrY " ")
      .OnEvent("Click", toClip.Bind(ScrY))
   g_CrdGet.Add("Text", "xm", "Window: ")
      .OnEvent("Click", toClip.Bind(WinX " " WinY))
   g_CrdGet.Add("Text", "x+", "x" WinX " ")
      .OnEvent("Click", toClip.Bind(WinX))
   g_CrdGet.Add("Text", "x+", "y" WinY " ")
      .OnEvent("Click", toClip.Bind(WinY))
   g_CrdGet.Add("Text", "xm", "Client: ")
      .OnEvent("Click", toClip.Bind(CliX " " CliY))
   g_CrdGet.Add("Text", "x+", "x" CliX " ")
      .OnEvent("Click", toClip.Bind(CliX))
   g_CrdGet.Add("Text", "x+", "y" CliY " ")
      .OnEvent("Click", toClip.Bind(CliY))
   g_CrdGet.Add("Text", "xm", "Pixel: " pixel)
      .OnEvent("Click", toClip.Bind(pixel))
   g_CrdGet.Add("Text", "xm", "CtrlClick Format")
      .OnEvent("Click", toClip.Bind('"x' CliX " y" CliY '"'))

   Destruction := (*) => (
      HotIfWinActive("ahk_id " CrdGet_hwnd),
      Hotkey("Escape", "Off"),
      Hotkey("1", "Off"),
      Hotkey("2", "Off"),
      Hotkey("3", "Off"),
      Hotkey("4", "Off"),
      Hotkey("5", "Off"),
      g_CrdGet.Minimize()
      g_CrdGet.Destroy()
   )

   HotIfWinActive("ahk_id " CrdGet_hwnd)
   Hotkey("Escape", Destruction, "On")
   Hotkey("1", toClip.Bind(ScrX " " ScrY), "On")
   Hotkey("2", toClip.Bind(WinX " " WinY), "On")
   Hotkey("3", toClip.Bind(CliX " " CliY), "On")
   Hotkey("4", toClip.Bind(pixel), "On")
   Hotkey("5", toClip.Bind('"x' CliX " y" CliY '"'), "On")
   g_CrdGet.OnEvent("Close", Destruction)

   g_CrdGet.Show("AutoSize y0 x" A_ScreenWidth / 20 * 13.5)
}
ToggleInfo(text) {
   g_ToggleInfo := Gui("AlwaysOnTop -caption").DarkMode().MakeFontNicer()
   g_ToggleInfo.Add("Text",, text)
   g_ToggleInfo.Show("W225 NA x1595 y640")
   SetTimer(() => g_ToggleInfo.Destroy(), -1000)
   return g_ToggleInfo
}
GetCaret(&X?, &Y?, &W?, &H?) {
    ; UIA2 caret  
    static IUIA := ComObject("{e22ad333-b25f-460c-83d0-0581107395c9}", "{34723aff-0c9d-49d0-9896-7ab52df8cd8a}")
    try {
        ComCall(8, IUIA, "ptr*", &FocusedEl:=0) ; GetFocusedElement
        ComCall(16, FocusedEl, "int", 10024, "ptr*", &patternObject:=0), ObjRelease(FocusedEl) ; GetCurrentPattern. TextPatternElement2 = 10024
        if patternObject {
            ComCall(10, patternObject, "int*", &IsActive:=1, "ptr*", &caretRange:=0), ObjRelease(patternObject) ; GetCaretRange
            ComCall(10, caretRange, "ptr*", &boundingRects:=0), ObjRelease(caretRange) ; GetBoundingRectangles
            if (Rect := ComValue(0x2005, boundingRects)).MaxIndex() = 3 { ; VT_ARRAY | VT_R8
                X:=Round(Rect[0]), Y:=Round(Rect[1]), W:=Round(Rect[2]), H:=Round(Rect[3])
                return
            }
        }
    }

    ; Acc caret
    static _ := DllCall("LoadLibrary", "Str","oleacc", "Ptr")
    try {
        idObject := 0xFFFFFFF8 ; OBJID_CARET
        if DllCall("oleacc\AccessibleObjectFromWindow", "ptr", WinExist("A"), "uint",idObject &= 0xFFFFFFFF
            , "ptr",-16 + NumPut("int64", idObject == 0xFFFFFFF0 ? 0x46000000000000C0 : 0x719B3800AA000C81, NumPut("int64", idObject == 0xFFFFFFF0 ? 0x0000000000020400 : 0x11CF3C3D618736E0, IID := Buffer(16)))
            , "ptr*", oAcc := ComValue(9,0)) = 0 {
            x:=Buffer(4), y:=Buffer(4), w:=Buffer(4), h:=Buffer(4)
            oAcc.accLocation(ComValue(0x4003, x.ptr, 1), ComValue(0x4003, y.ptr, 1), ComValue(0x4003, w.ptr, 1), ComValue(0x4003, h.ptr, 1), 0)
            X:=NumGet(x,0,"int"), Y:=NumGet(y,0,"int"), W:=NumGet(w,0,"int"), H:=NumGet(h,0,"int")
            if (X | Y) != 0
                return
        }
    }

    ; Default caret
    savedCaret := A_CoordModeCaret, W := 4, H := 20
    CoordMode "Caret", "Screen"
    CaretGetPos(&X, &Y)
    CoordMode "Caret", savedCaret
}
ErrorHandler(Error, *) {
    stdErr := "Error: {}`n`nSpecifically: {}`n`nCall stack:`n"
    stdErr := Format(stdErr, Error.Message, Error.Extra)
    stdErr .= RegExReplace(Error.Stack, " \((\d+)\)", ":$1")
    try FileAppend stdErr "`n", "**", "UTF-8"
    ;ExitApp 2
}
/*LogError(exception, mode) {
    FileAppend "Error on line " exception.Line ": " exception.Message "`n"
        , "errorlog.txt"
    return true
}*/


;No dependencies

DarkMode(guiObj) {
    guiObj.BackColor := "171717"
    return guiObj
}
Gui.Prototype.DefineProp("DarkMode", {Call: DarkMode})

MakeFontNicer(guiObj, fontSize := 20) {
    guiObj.SetFont("s" fontSize " cC5C5C5", "Consolas")
    return guiObj
}
Gui.Prototype.DefineProp("MakeFontNicer", {Call: MakeFontNicer})

PressTitleBar(guiObj) {
    PostMessage(0xA1, 2,,, guiObj)
    return guiObj
}
Gui.Prototype.DefineProp("PressTitleBar", {Call: PressTitleBar})

NeverFocusWindow(guiObj) {
    WinSetExStyle("0x08000000L", guiObj)
    return guiObj
}
Gui.Prototype.DefineProp("NeverFocusWindow", {Call: NeverFocusWindow})

MakeClickthrough(guiObj) {
    WinSetTransparent(255, guiObj)
    guiObj.Opt("+E0x20")
    return guiObj
}
Gui.Prototype.DefineProp("MakeClickthrough", {Call: MakeClickthrough})
