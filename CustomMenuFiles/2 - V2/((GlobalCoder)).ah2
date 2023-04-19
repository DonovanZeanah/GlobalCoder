<^m:: mymenu.Menu.show
<!m:: anotherMenu.show


MyGui.Add("Hotkey", "vChosenHotkey")


QL_CreateMenu()
return

CapsLock::{
    QL_Show()
    return
}



f13 & space::
{
    ShowMenu()
}

/*{
        callingwindow := WinActive("A")
        CoordMode("Menu", "Screen")
        GetCaret(X, Y,, H)
        
        ; Create a transparent window to receive focus when the menu is shown
        CreateTransparentWindow(X,Y,H)
        
        MenuShow(A_ScriptDir "\CustomMenuFiles", "x" X " y" (Y + H))
}*/

CreateTransparentWindow1() {
        ; Create a transparent window with the WS_EX_TOOLWINDOW style to prevent it from appearing in the taskbar
        Gui := GuiCreate("+LastFound +AlwaysOnTop -Caption +ToolWindow +E0x20")
        Gui.Color("FFFFFF", "FFFFFF")
        Gui.Show("x-10000 y-10000", "FocusWindow")
        ;WinSet("Transparent", 255, "FocusWindow")
}
; Label for when the menu is dismissed
MenuClose(){
            ; Close the transparent window
            Gui.Destroy()
        return
}

ShowMenu(){
    callingwindow := WinActive("A")
    CoordMode("Menu", "Screen")
    GetCaret(X, Y,, H)
    
    ; Create a transparent window to receive focus when the menu is shown
    CreateTransparentWindow(X, Y, H)
    
    MenuShow(A_ScriptDir "\CustomMenuFiles", "x" X " y" (Y + H))
}
CreateTransparentWindow(X, Y, H)
{
    ; Create a transparent window with the WS_EX_TOOLWINDOW style to prevent it from appearing in the taskbar
    Gui := GuiCreate("+LastFound +AlwaysOnTop -Caption +ToolWindow +E0x20")
    Gui.Color("FFFFFF", "FFFFFF")
    Gui.Show("x-10000 y-10000", "FocusWindow")
    WinSet()
}


On("MenuClose", "Event", "FocusWindow",  { cb:
     () => {
        callback: Gui.Destroy()
    }
})

QL_CreateMenu(QL_Link_Dir := "Links") { ; Just run it one time at the start.
    global oMenu :={}
    If !InStr(QL_Link_Dir, "\"){
        QL_Link_Dir := A_ScriptDir "\" QL_Link_Dir 
    }
    
    SplitPath(QL_Link_Dir, &QL_Menu)
    
    If !FileExist(QL_Link_Dir){
        DirCreate(QL_Link_Dir)
    }
    FileCreateShortcut(QL_Link_Dir, QL_Link_Dir "\" QL_Menu ".lnk")
    Loop Files, QL_Link_Dir "\*.*", "FR"
    {   
        if InStr(A_LoopFileAttrib, "H") or InStr(A_LoopFileAttrib, "R")  or InStr(A_LoopFileAttrib, "S") ;Skip any file that is H, R, or S (System).
            continue

        Folder1  := RegExReplace(A_Loopfilefullpath, "(.*\\[^\\]*)\\([^\\]*)\\([^\\]*)", "$2")
        Folder1Menu  := QL_Menu StrReplace(StrReplace(RegExReplace(A_Loopfilefullpath, "(.*\\[^\\]*\\[^\\]*)\\([^\\]*)", "$1"), QL_Link_Dir), "\")
        Folder2Menu  := QL_Menu StrReplace(StrReplace(RegExReplace(A_Loopfilefullpath, "(.*\\[^\\]*)\\([^\\]*)\\([^\\]*)", "$1"), QL_Link_Dir), "\")
        
        BoundRun := QL_MenuHandler.Bind("Run",A_Loopfilefullpath)
        Linkname := StrReplace(A_LoopFileName, ".lnk")

        if !oMenu.HasOwnProp(Folder1Menu){
            oMenu.%Folder1Menu% := Menu()
        }
        oMenu.%Folder1Menu%.Add(Linkname, BoundRun)
        Icon_Add(oMenu.%Folder1Menu%,Linkname,A_LoopFilePath) ; icon
        if !oMenu.HasOwnProp(Folder2Menu) {
            oMenu.%Folder2Menu% := Menu()
        }

        oMenu.%Folder2Menu%.Add(Folder1, oMenu.%Folder1Menu%) ; Create submenu
        oMenu.%Folder2Menu%.SetIcon(Folder1, A_Windir "\syswow64\SHELL32.dll", "5") ; icon for folder
    }
    return oMenu
}

QL_Show(Link_Name:= "Links") {
    oMenu.%Link_Name%.Show()
}

QL_MenuHandler(Functon1, Parameter, MyMenu,*){
    %Functon1%(Parameter)
}

Icon_Add(menuitem,submenu,LoopFileFullPath){ ; add icon based on extention or name
    If InStr(LoopFileFullPath, ".lnk"){
        FileGetShortcut(LoopFileFullPath, &File, , , , &OutIcon, &OutIconNum)
         if (OutIcon != "") {
            menuitem.SetIcon(submenu, OutIcon, OutIconNum)
            return
        }
    }
    Else{
        File := LoopFileFullPath
    }
    
    if InStr(FileExist(File),"D"){
        menuitem.SetIcon(submenu, A_Windir "\syswow64\SHELL32.dll", "5")
        return
    }
    Extension  := RegExReplace(File, "([^\.]*)(\.[^\.]*).*", "$2")
    Extension2  := RegExReplace(File, "([^\.]*)(\..*)", "$2")
    Icon_nr := 0
    If (Extension = ".exe"){
        menuitem.SetIcon(submenu, file, "1")
        return
    }
    
    IconFile := getExtIcon(StrReplace(Extension, "."))
    
    If InStr(Extension, "\") {
        menuitem.SetIcon(submenu, A_Windir "\syswow64\SHELL32.dll", "5")
    } Else If (Extension = ".ahk")
        menuitem.SetIcon(submenu, "autohotkey.exe", "2")
    Else If (Extension ~= "i)\.(jpg|png)")
        menuitem.SetIcon(submenu, A_Windir "\system32\Imageres.dll", "68")
    Else If (Extension = ".pdf" and FileExist(A_ScriptDir "\Icons\PDF.ico"))
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\PDF.ico")
    Else If InStr(Extension, ".xls") and FileExist(A_ScriptDir "\Icons\xlicons.exe")
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\xlicons.exe", "0")
    Else If InStr(Extension, ".doc") and FileExist(A_ScriptDir "\Icons\wordicon.exe")
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\wordicon.exe", "0")
    Else If InStr(Extension, ".ppt") and FileExist(A_ScriptDir "\Icons\ppticon.exe")
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\ppticon.exe", "0")
    Else If InStr(A_LoopFilePath, ".website") and FileExist(A_ScriptDir "\Icons\ielowutil.exe")
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\ielowutil.exe", "0")
    Else If (Extension = ".txt")
        menuitem.SetIcon(submenu, A_Windir "\syswow64\Notepad.exe", "0")
    Else If (Extension = ".pro")
        menuitem.SetIcon(submenu, A_Windir "\syswow64\Notepad.exe", "0")
    Else If (Extension2 = ".url") and InStr(A_LoopFileFullPath, "Windchill") and FileExist(A_ScriptDir "\Icons\Windchill.ico") {
        menuitem.SetIcon(submenu, A_ScriptDir "\Icons\Windchill.ico")
    } 
    Else If InStr(IconFile, " - "){
        try{ 
            RegExMatch(IconFile,"(.*) - (\d*)", &IconFile)
            menuitem.SetIcon(submenu, IconFile[1], IconFile[2])
        }
        Catch{
            MsgBox(IconFile[1] "`n" IconFile[2] "`next:" Extension)
        }
        return
    }
    ; Find hidden icons in the following directory: C:\Windows\Installer
    Return
}

getExtIcon(Ext) {

    from := RegRead("HKEY_CLASSES_ROOT\." Ext)
    DefaultIcon := RegRead("HKEY_CLASSES_ROOT\" from "\DefaultIcon")
    DefaultIcon := StrReplace(DefaultIcon, '"')
    DefaultIcon := StrReplace(DefaultIcon, "%SystemRoot%", A_WinDir)
    DefaultIcon := StrReplace(DefaultIcon, "%ProgramFiles%", A_ProgramFiles)
    DefaultIcon := StrReplace(DefaultIcon, "%windir%", A_WinDir)

    I := StrSplit(DefaultIcon, ",")

    Return I[1] " - " IndexOfIconResource(I[1], RegExReplace(I[2], "[^\d]+"))
}

IndexOfIconResource(Filename, ID) {
    ; If the DLL isn't already loaded, load it as a data file.
    If !DllCall("GetModuleHandle", "Str", Filename, "UPtr")
        HMOD := DllCall("LoadLibraryEx", "Str", Filename, "Ptr", 0, "UInt", 0x02, "UPtr")
    EnumProc := CallbackCreate(IndexOfIconResource_EnumIconResources, "F")
    Param := Buffer(12, 0)
    NumPut("UInt", ID, Param)
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "Ptr", HMOD, "UInt", 14, "Ptr", EnumProc, "Ptr", Param)
    CallbackFree(EnumProc)
    ; If we loaded the DLL, free it now.
    If (HMOD)
        DllCall("FreeLibrary", "Ptr", HMOD)
    Return (NumGet(Param, 8, "UInt")) ? NumGet(Param, 4, "UInt") : 0
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam) {
    NumPut("UInt", NumGet(lParam + 4, "UInt") + 1, lParam + 4)
    If (lpszName = NumGet(lParam, "UInt")) {
        NumPut("UInt", 1, lParam + 8)
        Return False    ; break
    }
    Return True
}

/*
    ; Hotkey to show the menu
^F24::
Ctrl & RShift::
{
        callingwindow := WinActive("A")
        CoordMode("Menu", "Screen")
        GetCaret(X, Y,, H)
        
        ; Create a transparent window to receive focus when the menu is shown
        CreateTransparentWindow()
        
        MenuShow(A_ScriptDir "\CustomMenuFiles", "x" X " y" (Y + H))
    return

    CreateTransparentWindow() {
        ; Create a transparent window with the WS_EX_TOOLWINDOW style to prevent it from appearing in the taskbar
        Gui := GuiCreate("+LastFound +AlwaysOnTop -Caption +ToolWindow +E0x20")
        Gui.Color("FFFFFF", "FFFFFF")
        Gui.Show("x-10000 y-10000", "FocusWindow")
        WinSet("Transparent", 255, "FocusWindow")
    }

    ; Label for when the menu is dismissed
    MenuClose:
        ; Close the transparent window
        Gui.Destroy()
    return
}

^f24::
Ctrl & RShift::
{ ; V1toV2: Added bracket
    callingwindow := winactive("A")
    CoordMode("Menu", "Screen")
    GetCaret(X, Y,, H)
    ;Menu, MyMenu, Show, % X, % Y + H
    CustomMenuFiles := Menu()
    CustomMenuFiles.show(X, Y + H)
    return
    ;// endregion
} ; V1toV2: Added Bracket before hotkey or Hotstring
*/

!1::
{
    myGui := Gui()
    myGui.OnEvent("Size", GuiSize)
    myGui.SetFont("Q4", "MS Sans Serif") ;opts-> (c)olor (s)ize (w)eight (Q)uality
    myGui.SetFont(, "Arial")
    myGui.SetFont(, "Verdana")  ; Preferred font.
    applicationname := "GlobalCoder"
    g_OSVersion := GetOSVersion()
    FileEncoding("UTF-8")
}

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
