#warn all, off

;#include D:\(github)-MAINS\AHK-v2-libraries\Lib\Array.ahk

!n::{
    mymenu1.Show
}

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


F1::{
    P := Path(Path.Documents())
    For Item in P.IterDir() {
        If Path(Item).IsSymLink {
            Folder := Path(Item)
            List .= Folder.Path "`n"
        }

    }
    MsgBox(List)
}


/*MsgBox String(Test1("Hello World"))

class Test1 {
    __New(What) {
        this.data := What
    }
    ToString() {
        return this.data
    }
}

instance := Test1("Hello World")

MsgBox instance.data
MsgBox String(instance)

class Test2 {
    __New(What) {
        this.data := What
    }
    ToString() {
        return this.data
    }
}*/








;mymenu := MyMenu()
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

msgbox "still executing..."
*/


MyMenu1 := Menu()
PrepareMenu("D:\(github)\GlobalCoder\gc\GlobalCoder\CustomMenuFiles", MyMenu1)
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
   ; MyMenu1 := Menu()
    /*MyMenu1.Add "Item 1", MenuHandler
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
    MyMenu1.Add "Item 3", MenuHandler  ; Add another menu item beneath the submenu.*/

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
	myMap := new Map()
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
	 keys1 := map.keys(myMap)
	 values1 := Object.values(myMap)

	 for i, key in keys1 {
	     value1 := values[i]
	     MsgBox "Key: " key "`nValue: " value
	 }

	    myMap := {a: 1, b: 2, c: 3}
	 for key, value in myMap
	 {
	     MsgBox "Key " key " contains " value
	 }

	;//================
	 ; Read the content of the input .ahk file
	 content := FileRead("guiclass.ah2")

	 ; Find and extract the classes
	 ahclasses := {}
	 regex := "class\s+(\w+)\s*\{[\s\S]*?\}"
	 while RegExMatch(content, regex, found) {
	     class_name := found[1]
	     class_code := found[0]
	     ahclasses[class_name] := class_code
	     content := SubStr(content, found.Pos + found.Len)
	 }

	 ; Sort the classes
	 sorted_classes := ahSortClasses(ahclasses)

	 ; Write the sorted classes to a new output .ahk file
	 sorted_content := ""
	 for _, class_code in sorted_classes {
	     sorted_content .= class_code "`n`n"
	 }
	 FileDelete("output.ahk")
	 FileAppend("output.ahk", sorted_content)

	 ; Function to sort the classes by name
	 ahSortClasses(ahclasses) {
	     sorted := {}
	     for class_name, class_code in ahclasses {
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
		 loggerObj := Logger()
		 timelineObj := Timeline(loggerObj)

		 timelineObj.logEvents("First event")
		 sleep(1000)
		 timelineObj.logEvents("Second event")
		 timeline1 := Timeline(loggerobj)
		 timeline1.AddEvent("start", A_TickCount)
		 Sleep(1000)
		 timeline1.AddEvent("middle", A_TickCount)
		 Sleep(1000)
		 timeline1.AddEvent("end", A_TickCount)
		 timeline1.logevents()
		 ;timeline1.logeventsjson()
		 startTime := timeline1.GetEventTime("start")
		 middleTime := timeline1.GetEventTime("middle")
		 endTime := timeline1.GetEventTime("end")
		 MsgBox("Start time:" startTime "`nMiddle time:" middleTime "`nEnd time:" endTime)
		 return
}



PrepareMenu(PATH, menu1) {

    FileMenu := Menu()
    FileMenu.Add("Script Icon", MenuHandler)
    FileMenu.Add("Suspend Icon", MenuHandler)
    FileMenu.Add("Pause Icon", MenuHandler)
    FileMenu.SetIcon("Script Icon", A_AhkPath, 2) ; 2nd icon group from the file
    FileMenu.SetIcon("Suspend Icon", A_AhkPath, -206) ; icon with resource ID 206
    FileMenu.SetIcon("Pause Icon", A_AhkPath, -207) ; icon with resource ID 207

    MyMenuBar := MenuBar()
    MyMenuBar.Add("&File", FileMenu)

    MyGui := Gui()
    MyGui.MenuBar := MyMenuBar
    MyGui.Add("Button",, "Exit This Example").OnEvent("Click", (*) => WinClose())
    MyGui.Add("Button",, "try").OnEvent("Click", (*) => Wincust())
    MyGui.Add("Button",, "tried").OnEvent("Click", (*) => Wincust())

    wincust(*){
        msgbox "wincust"
    }


    MenuHandler(*) {
        ; For this example, the menu items don't do anything.
    }
    ;menu1 := menuin
   ; msgbox Type(menu1)
    ;msgbox Type(menuin)

    ; GUI loading/progress bar
    MyGui := Gui("+ToolWindow", A_ScriptName " is Loading") ; Adding title to progressbar
    MyGui.Add("Progress", "w200 vMyProgress") ;Adding progressbar
    MyGui.Show() ; Displaying Progressbar

    ; Add Name, Icon and separating line
    Menu1.Add("g&oogler", googler)
    Menu1.Add

    googler(*){
        msgbox "placeholder"
    }
    ; Add all custom items using algorithm
    ;msgbox "Passing PATH to loopoverfolder: `n " . PATH
    LoopOverFolder(PATH, Menu1)

    ; Separating line
    Menu1.Add

    ; Add Admin Panel
    Sleep 200
    Menu1.Add({Type: "SubMenu", Name: "new", Text: "&n test"})
    Menu1.Add({Text: "&3 Restart", Func: "ReloadProgram", Parent: PATH . "\Admin"}) ; Add Reload option
    Menu1.Add({Text: "&2 Exit", Func: "ExitApp", Parent: PATH . "\Admin"}) ; Add Exit option
    Menu1.Add({Text: "&1 Go to Parent Folder", Func: "GoToRootFolder", Parent: PATH . "\Admin"}) ; Open script folder
    Menu1.Add({Text: "&4 Add Custom Item", Func: "GoToCustomFolder", Parent: PATH . "\Admin"}) ; Open custom folder

    ; Bottom sec
    Menu1.Add({Type: "SubMenu", Name: "Admin", Text: "&1 Admin", Parent: PATH})
    Menu1.Add({Type: "SubMenu", Name: "New", Text: "&2 New", Parent: PATH})
    Menu1.Add({Type: "Separator", Parent: PATH})
    Menu1.Add({Text: "&" ScriptName " vers. " Version, Func: "github", Parent: PATH}) ; Name
    Menu1.Add({Type: "Separator", Parent: PATH}) ; Adds Admin section

    MyGui.Show
    ; Loading bar GUI is no longer needed, remove it from memory
    ;Gui1.Destroy()
    ;return menu1
}
/*
;depthtrawler help
Files := []
Folders := []
SizeKB := 0

Loop Files, Path "\*", "DFR" {
    If !InStr(GetFileAttrib(A_LoopFileFullPath), "D") {
        SizeKB += A_LoopFileSizeKB
        Files.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
        Continue
    }
    Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
}

; The File/Folder arrays now contain objects that you can reference their names or paths
; Example

For File in Files {
    MsgBox("Path: " File.Path "`nName: " File.Name)
}
; Prevents having to use SplitPath later
*/

LoopOverFolder(PATH,menu1) {
    ;static menu1 ;:= menu
    ;global menu1
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []
   ; res := Type(menu1)
    ; Loop over all files and folders in input path, but do NOT recurse
    ;Loop, Files, % PATH . "\*", F
    Loop Files, PATH  . "\*", "FD" {

    {
       ; msgbox a_loopfilefullpath
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(A_LoopFileFullPath)

        ; Current item is a directory
        if (VALUE == "D") {
            FolderArray.Push(A_LoopFileFullPath)
        }
        ; Current item is a file
        else if (VALUE == "F") {
            FileArray.Push(A_LoopFileFullPath)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    ;FolderArray.Sort(ArraySortFunction)
    ;FileArray.Sort(ArraySortFunction)

    value := ""
    for index, element in FolderArray {
        value .= element "`n"
    }

    sort(value)

    value2 := ""
    for index, element in FileArray {
        value2 .= element "`n"
    }
    sort(value2)

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element, menu1)

        ; Then add it as item to menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
       ; Menu1.Add("&" name, ":" . element)
       menuname := menu()
        menuname.Add("&" . name, MenuEventHandler)

        ; Iterate loading GUI progress
        ;FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
        Menu1.Add("&" . name, MenuEventHandler)

        ; Iterate GUI loading
        FoundItem("File")
    }
}
;return menu1
}

MenuEventHandler(Item, *) {
    msgbox "you chose: " . Item
    ; Draw the rectangle, the hourglass and update the Window
    ;Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
   ; Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)
    ;UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

    ; Get Extension of item to evaluate what handler to use
    WordArray := StrSplit(A_ThisMenuItem, ".")
    FileExtension := WordArray[WordArray.MaxIndex()]

    ; Get full path from Menu Item pass to handler
    FileItem := SubStr(A_ThisMenuItem, 2, StrLen(A_ThisMenuItem))
    FilePath := A_ThisMenu A_ThisMenuItem

    ; Run item with appropriate handler
    Switch FileExtension {
        case "rtf":
            Handler_RTF(FilePath)
        case "bat":
            Handler_LaunchProgram(FilePath)
        case "txt":
            Handler_txt(FilePath)
        case "lnk":
            Handler_LaunchProgram(FilePath)
        case "exe":
            Handler_LaunchProgram(FilePath)
        case "ahn":
            Handler_Note(FilePath)
        Default:
            Handler_Default(FilePath)
    }

    ; Clear the graphics and update thw window
    Gdip_GraphicsClear(G)                                 ;This sets the entire area of the graphics to 'transparent'
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display
}
Handler_RTF(FilePath) {
    ; Add your code to handle RTF files here
}

Handler_LaunchProgram(FilePath) {
    ; Add your code to handle launching programs here
    Run FilePath
}

Handler_txt(FilePath) {
    ; Add your code to handle TXT files here
}

Handler_Note(FilePath) {
    ; Add your code to handle AHN files here
}

Handler_Default(FilePath) {
    ; Add your code to handle other files here
}


; Define a custom function to sort an array
; Define a custom function to sort an array
ArraySortFunc(a, b) {
    ; Compare the two elements
    if (a < b) {
        return -1
    }
    else if (a > b) {
        return 1
    }
    else {
        return 0
    }
}

; Extend the Array object with a custom Sort() method


; Define the custom Sort() method
ArraySort(arr, fnFunc := ArraySortFunc) {
    ; Sort the array using the custom function
    for i, x in arr {
        for j, y in arr {
            if (fnFunc(x, y) < 0) {
                arr.Swap(i, j)
            }
        }
    }
}
/*; Define the custom Sort() method
ArraySort(arr, fnFunc := ArraySortFunc) {
    ; Sort the array using the custom function
    for i, x in arr {
        for j, y in arr {
            if (fnFunc(x, y) < 0) {
                arr.Swap(i, j)
            }
        }
    }
}*/

; Example usage of the custom Sort() method on an array



LoopOverFolderMY(PATH) {
    DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
    DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore := 0)
    Sleep 1000

    static passedPath := PATH
    ;msgbox "In Loopoverfolder func (as a closure?)" . PATH
    ; Prepare empty arrays for folders and files
    Folders := []
    Files   := []
    SizeKB := 0

    if (passedpath := "")
    {
        ;msgbox "not passed in"
        WhichFolder := DirSelect()  ; Ask the user to pick a folder.
        Loop Files, WhichFolder "\*", "DF" {
            If !InStr(FileGetAttrib(A_loopFileFullPath), "D" ) {
            SizeKb += A_LoopFileSizeKB
            Files.push({Path: A_LoopFileFullPath, Name: A_LoopFileName})
            continue
            ;FolderSizeKB += A_LoopFileSizeKB
            }
            Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
        }
        ;MsgBox "Size of " WhichFolder " is " FolderSizeKB " KB."
    }
    else
    {
        ;FolderSizeKB := 0
       ;msgbox passedpath . "`n passedpath var in looperfunc"
       ;msgbox PATH

       Filelist := ""
       folderlist := ""

       Loop Files, passedPATH "\*", "FD" {
           If !InStr(FileGetAttrib(A_LoopFileFullPath), "D") {
               ;SizeKB += A_LoopFileSizeKB
               FileList .= A_LoopFileTimeModified "`t" A_LoopFileName "`n"
               Files.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
               Continue
           }
           folderList .= A_LoopFileTimeModified "`t" A_LoopFileName "`n"

           Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
       }
       DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)
       MsgBox "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000000 " s"

       FileList := Sort(FileList)  ; Sort by date.
       Loop Parse, FileList, "`n"
       {
           if A_LoopField = "" ; Omit the last linefeed (blank item) at the end of the list.
               continue
           FileItem := StrSplit(A_LoopField, A_Tab)  ; Split into two parts at the tab char.
           Result := MsgBox("The next file (modified at " FileItem[1] ") is:`n" FileItem[2] "`n`nContinue?",, "y/n")
           if Result = "No"
               break
       }
       folderList := Sort(folderList)  ; Sort by date.
       Loop Parse, folderList, "`n"
       {
           if A_LoopField = "" ; Omit the last linefeed (blank item) at the end of the list.
               continue
           folderItem := StrSplit(A_LoopField, A_Tab)  ; Split into two parts at the tab char.
           Result := MsgBox("The next file (modified at " FolderItem[1] ") is:`n" folderItem[2] "`n`nContinue?",, "y/n")
           if Result = "No"
               break
       }

       looper := 0

       for Folder in Folders {
        looper++
        ;looperpaths += Folders["Path"] ;.Path

       }
       msgbox looperpaths
       msgbox looper

       looper := 0

       For File in Files {
        looper++
    }
    msgbox looper
    msgbox folders[150000]
        looperpaths += File.Path
           ;MsgBox("Path: " File.Path "`nName: " File.Name)

      /* Loop Files, PATH "\*.*", "DR"
            FolderArray.push([a_loopfilefullpath])

        msgbox FolderArray.Length

        Loop FolderArray.Length
        {
            MsgBox FolderArray[A_Index]
            MsgBox FolderArray[2]
            MsgBox FolderArray[3]
        }*/
        }


       ;block1

    ; Sort arrays to get alphabetical representation in GUI menu
    Sort(Folders)
    Sort(Files)

    ; First add all folders, so files have a place to stay
    for index, element in Folders {
        ; Recurse into next folder
        LoopOverFolderMY(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add({Text: "&" name, Name: element, Parent: dir})

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add({Text: name, Func: "MenuEventHandler", Parent: dir})

        ; Iterate GUI loading
        FoundItem("File")
    }
}

;block1
    ;msgbox FolderArray.Length
    ;for k,v in FolderArray
      ;  msgbox v.value
       ;FolderSizeKB += A_LoopFileSizeKB
   ;MsgBox "Size of " WhichFolder " is " FolderSizeKB " KB."
;}
/*; Loop over all files and folders in input path, but do NOT recurse
FileSelectObj := FileSelect(PATH . "\*", "FD")

for index, file in FileSelectObj {
    ; Current item is a directory
    if (file IsDir) {
        FolderArray.Push(file.Path)
    }
    ; Current item is a file
    else {
        FileArray.Push(file.Path)
    }
}*/


/*PrepareMenu(PATH) {
    ; Create a new Menu object
    Menu1 := Menu()

    ; GUI loading/progress bar
    Gui1 := Gui("+ToolWindow", ScriptName " is Loading") ; Adding title to progressbar
    Gui1.Add("Progress", "w200 vMyProgress range1-`%items% 0") ; Adding progressbar
    Gui1.Show() ; Displaying Progressbar

    ; Add Name, Icon and separating line
    Menu1.Add("&googler", "googler")  ; Name
    Menu1.Add("")

    ; Add all custom items using algorithm
    LoopOverFolder(PATH)

    ; Separating line
    Menu1.Add("")

    ; Add Admin Panel
    Sleep 200
    Menu1.Add("", "", PATH . "\new")
    Menu1.Add("&n test", "ReloadProgram", PATH . "\new")                                                  ; Separating line
    Menu1.Add("&3 Restart", "ReloadProgram", PATH . "\Admin")             ; Add Reload option
    Menu1.Add("&2 Exit", "ExitApp", PATH . "\Admin")                          ; Add Exit option
    Menu1.Add("&1 Go to Parent Folder", "GoToRootFolder", PATH . "\Admin")    ; Open script folder
    Menu1.Add("&4 Add Custom Item", "GoToCustomFolder", PATH . "\Admin")      ; Open custom folder

    ; Bottom sec
    Menu1.Add("&1 Admin", "", PATH . "\Admin")                        ; Adds Admin section
    Menu1.Add("&2 New", "", PATH . "\New")
    Menu1.Add("")                                                           ; Separator
    Menu1.Add("&" ScriptName " vers. " Version, "github")               ; Name
    Menu1.Add("")                                                           ; Adds Admin section

    ; Loading bar GUI is no longer needed, remove it from memory
    Gui1.Destroy()
}*/

/*LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []

    ; Loop over all files and folders in input path, but do NOT recurse
    FileSelectObj := FileSelect(PATH . "\*", "F")
    for key, file in FileSelectObj {
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(file)

        ; Current item is a directory
        if (VALUE = "D") {
            ;~ MsgBox, % "Pushing to folders`n" A_LoopFilePath
            FolderArray.Push(file)
        }
        ; Current item is a file
        else {
            ;~ MsgBox, % "Pushing to files`n" A_LoopFilePath
            FileArray.Push(file)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    for k, v in FolderArray {
        value .= v "`n"
    }
    for k, v in FileArray {
        value2 .= v "`n"
    }

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add("&" name, ":" . element)

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add(name, "MenuEventHandler")

        ; Iterate GUI loading
        FoundItem("File")
    }
}*/


/*LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []

    ; Loop over all files and folders in input path, but do NOT recurse
    for file in FileSelect(PATH . "\*", "F") {
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(file)

        ; Current item is a directory
        if (VALUE = "D") {
            ;~ MsgBox, % "Pushing to folders`n" A_LoopFilePath
            FolderArray.Push(file)
        }
        ; Current item is a file
        else {
            ;~ MsgBox, % "Pushing to files`n" A_LoopFilePath
            FileArray.Push(file)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    for k, v in FolderArray {
        value .= v "`n"
    }
    for k, v in FileArray {
        value2 .= v "`n"
    }

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add("&" name, ":" . element)

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add(name, "MenuEventHandler")

        ; Iterate GUI loading
        FoundItem("File")
    }
}*/

