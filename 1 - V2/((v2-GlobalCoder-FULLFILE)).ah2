
#warn all, off

;Seldom Changing Directives
#Requires Autohotkey v2.0-beta.1+ ;.34.03+
Persistent
; REMOVED: #NoEnv
#SingleInstance
#WinActivateForce
KeyHistory()
InstallKeybdHook()
InstallMouseHook()
; REMOVED: setbatchlines,-1
SetTitleMatchMode(2)
DetectHiddenWindows(true)
;Sometimes Changing Directives
SetKeyDelay(50)
CoordMode("Caret", "Screen")
CoordMode("Mouse", "Screen")
Suspend(true)
;#Include "lib\((functions)).ah2"
;#Include, lib\Gdip.ahk
;#Include "lib\read-ini.ah2"
;#Include "lib\JXON.ah2"
;#Include "lib\Minerva-PowerToys.ah2"
;#Include "lib\Minerva-Handlers.ah2"+
;#Include "lib\Minerva-Statistics.ah2"

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

+

    Ptr := A_PtrSize ? "Ptr" : "UInt"
    SkipExitSub := True ;Disables save-on-exit until the Startup() function is finished
    ;As long as the above is set to True and the Startup() function is never executed the script
    ;will not execute any critical code and can sit in a pre-Startup() state forever.

    Name := "GlobalCoder"
    VersionNumber := 1.79
    Package_FileVersion := 2.2
    Pixel_FileVersion := 1.1
    Save_FileVersion := 1.2
    HD_FileVersion := 1.0

    MouseMovement_IndexVersion := 1.36
    Key_IndexVersion := 1.2
    WordsTyped_IndexVersion := 1.25

    MouseMovement_Number := 189
    WordsPerTime_Number := 190


    MenuName := Menu()
    MenuName.UseErrorLevel()


       ;The following code sets up the Gui with a DropDownList with the original list of
       ;open windows. Remove or comment out this code for Menu only.

    myGui.Opt("+AlwaysOnTop")
    myGui.SetFont("s12", "Arial")
    ogcDropDownListWindowMove := myGui.Add("DropDownList", "w275 vWindowMove  Sort Choose1")
    ogcDropDownListWindowMove.OnEvent("Change", PosChoice.Bind("Change")) ; ,Pick a Window||
    FileMenu := Menu()
    FileMenu.Add("&Rescan`tCtrl+R", GuiReset)
    MyMenuBar := Menu()
    MyMenuBar.Add("&File", FileMenu)
    myGui.MenuBar := MyMenuBar



    If !pToken := Gdip_Startup()
    {
        MsgBox("Gdiplus failed to start. Please ensure you have gdiplus on your system", "gdiplus error!", 48)
        ExitApp()
    }
    OnExit(Exit, )

    FindAmountItems()
    PrepareMenu(A_ScriptDir "\CustomMenuFiles")
    PrepareMenu(A_ScriptDir "\singles")
    RunOtherScripts(A_ScriptDir "\singles")

    hwnd1 := WinExist()                         ; Get a handle to this window we have created in order to update it later
    hbm   := CreateDIBSection(Width, Height)    ; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
    hdc   := CreateCompatibleDC()               ; Get a device context compatible with the screen
    obm   := SelectObject(hdc, hbm)             ; Select the bitmap into the device context
    G     := Gdip_GraphicsFromHDC(hdc)          ; Get a pointer to the graphics of the bitmap, for use with drawing functions
    Gdip_SetSmoothingMode(G, 4)                 ; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)

    pBrush  := Gdip_BrushCreateSolid(0x80C7C7C7) ; Create a slightly transparent gray brush to draw rectagle with
    Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
    pBitmap := Gdip_CreateBitmapFromFile("includes\graphics\globe.png")
    Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2, A_ScreenHeight, Width/2, Height/2, 0, 0, Width, Height)


    ;========= Typing Setup
    ;disable hotkeys until setup is complete

    EvaluateScriptPathAndTitle()
    SuspendOn()

    Startup()
    ;msgbox returned
    ;Build_TrayMenu()

    OnExit(SaveScript, )
    ;specifices this sub-routine to be called should/when script exits.

    ;Change the setup performance speed
    ; REMOVED: SetBatchLines, 20ms

    ;read in the preferences file
    ReadPreferences()

    SetTitleMatchMode(2)
    ;set windows constants
    g_EVENT_SYSTEM_FOREGROUND := 0x0003
    g_EVENT_SYSTEM_SCROLLINGSTART := 0x0012
    g_EVENT_SYSTEM_SCROLLINGEND := 0x0013
    g_GCLP_HCURSOR := -12
    g_IDC_HAND := 32649
    g_IDC_HELP := 32651
    g_IMAGE_CURSOR := 2
    g_LR_SHARED := 0x8000
    g_NormalizationKD := 0x6
    g_NULL := 0
    g_Process_DPI_Unaware := 0
    g_Process_System_DPI_Aware  := 1
    g_Process_Per_Monitor_DPI_Aware := 2
    g_PROCESS_QUERY_INFORMATION := 0x0400
    g_PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
    g_SB_VERT := 0x1
    g_SIF_POS := 0x4
    g_SM_CMONITORS := 80
    g_SM_CXVSCROLL := 2
    g_SM_CXFOCUSBORDER := 83
    g_WINEVENT_SKIPOWNPROCESS := 0x0002
    g_WM_LBUTTONUP := 0x202
    g_WM_LBUTTONDBLCLK := 0x203
    g_WM_MOUSEMOVE := 0x200
    g_WM_SETCURSOR := 0x20

    ;setup code
    g_DpiScalingFactor := A_ScreenDPI/96
    g_Helper_Id := ""
    g_HelperManual := ""
    g_DelimiterChar := Chr(2)
    g_cursor_hand := DllCall("LoadImage", "Ptr", g_NULL, "Uint", g_IDC_HAND, "Uint", g_IMAGE_CURSOR, "int", g_NULL, "int", g_NULL, "Uint", g_LR_SHARED)
    if (A_PtrSize == 8) {
       g_SetClassLongFunction := "SetClassLongPtr"
    } else {
       g_SetClassLongFunction := "SetClassLong"
    }
    g_PID := DllCall("GetCurrentProcessId")
    ; REMOVED: AutoTrim, Off

    InitializeListBox()
    BlockInput("Send")
    InitializeHotKeys()
    DisableKeyboardHotKeys()


    ReadWordList() ;Read in the WordList

    g_WinChangedCallback := CallbackCreate(WinChanged)
    g_ListBoxScrollCallback := CallbackCreate(ListBoxScroll)

    if !(g_WinChangedCallback)
    {
       MsgBox("Failed to register callback function")
       ExitApp()
    }

    if !(g_ListBoxScrollCallback)
    {
       MsgBox("Failed to register ListBox Scroll callback function")
       ExitApp()
    }

    ;Find the ID of the window we are using
    GetIncludedActiveWindow()

    MainLoop()


    ;OnExit, ExitSub

    Return
}
;END Auto Execute===========================================================================================================================================================================================
;===========================================================================================================================================================================================
;===========================================================================================================================================================================================End Auto Execute
;return




/*#HotIf WinActive("ahk_exe explorer.exe", )
enter::+f10
#HotIf*/


^left::
!enter::
{ ; V1toV2: Added bracket
selectsubject()
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

^down::
{ ; V1toV2: Added bracket
newsubject()
MsgBox("" frontproject)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

^2::
{ ; V1toV2: Added bracket
IB := InputBox("", ""), ans := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
noteex(ans, frontproject)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

f24 & n::
{ ; V1toV2: Added bracket
notein() ;no input - default to frontproj
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

^right::
{ ; V1toV2: Added bracket
run(notepath)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

rshift & m::

f24 & m::
{ ; V1toV2: Added bracket
mygui.Opt("+Resize")
ogchotedit := mygui.Add("Edit", "w300 r10 vhotedit", "Example text")
ogcButtonGoButton := mygui.Add("Button", , "Go Button")
ogcButtonGoButton.OnEvent("Click", GoButton1.Bind("Normal"))
mygui.Title := "Functions instead of labels"
mygui.Show()
return
} ; Added bracket before function


GoButton1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
static hotpath := { 0 : ""  , 1 : a_scriptdir . "\notes"    , 2 : a_scriptdir . "\logs\notes" }
    ;msgbox, % hotpath.2
    ;msgbox, % frontproject

    SelectHotpath(hotpath.2)
    hotedit := ogchotedit.Text
    A_Clipboard := hotedit
    MsgBox("cont to pass A_Clipboard to notex(): `n" A_Clipboard)
    noteex(A_Clipboard, hotpath.2)
    notein(hotpath.2)
    mygui.destroy()
}



newsubject(path := ""){
  if (path = "")
  path := frontproject

  ;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
  IB := InputBox("`"enter a subject`"", ""), subject := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
  frontproject := notepath . "\" . subject ; ".txt"
  if fileexist(frontproject . "\notes.txt"){
  MsgBox("already exists.")
  return frontproject
   }

  DirCreate(frontproject)
  ;fileappend,"init", % frontproject "\note.txt"
  return frontproject
 } ; should add new folder and set to frontproj


selectsubject(path := ""){
  if (path = "")
  path := notepath
  MsgBox(": " path)

  ogcListViewName := mygui.Add("ListView", "background000000 cFFFFFF -Hdr r20 w200 h200", ["Name"])
  ogcListViewName.OnEvent("DoubleClick", MyListView3.Bind("DoubleClick"))
  Loop Files, path . "\* ", "D" ; 2 = folders only
  ogcListViewName.Add("", A_LoopFileName, A_LoopFileSizeKB)
  ogcListViewName.ModifyCol()  ; Auto-size each column to fit its contents.
  ogcListViewName.ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
  FolderList .= A_LoopFileName . "`n"

mygui.Show()


  MyListView3(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
    if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
    {
      FileName := ogcListViewName.GetText(A_EventInfo) ; Get the text of the first field.
      FileDir := ogcListViewName.GetText(A_EventInfo)  ; Get the text of the second field.

            frontproject := notepath . "\" . filename
            MsgBox(frontproject)

    ogcFolder.Value := frontproject

    mygui.destroy()

} ;selecting a subj should return notepaath + chosen folder
return frontproject
}

;path is frontproject
;note external
} ; V1toV2: Added bracket before function
noteex(data,hotpath){
count := 0
 IB := InputBox("", "`"Enter filename w/ Extension:`""), fname := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
  if (fileexist(file := hotpath . "/" fname ))
      {
          while ( FileExist(file))
              {
                file := hotepath . "/" . ++count fname ;g. ".txt"
              }
      }
MsgBox("appending file: `n" file)
FileAppend("`n " A_Clipboard, file)
  return
}

;path is predeterined and inputted
;newnote gets input inside the func
notein(path := ""){
  if (path = "")
  path := frontproject

  ;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
  IB := InputBox(frontproject - "new note:", ""), note := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
  FileAppend( note . " - " . timestring "`n", frontproject "\notes.txt")
  return
}

hotpath(folder:="") {
    if (folder = "")
  folder := frontproject

    ogcListViewName := mygui.Add("ListView", "background000000 cFFFFFF -Hdr r20 w200 h200  AltSubmit", ["Name"])
    ogcListViewName.OnEvent("DoubleClick", MyListView.Bind("DoubleClick"))
        Loop Files, folder "\*", "D"
        {
            ogcListViewName.Add("", A_LoopFileName, A_LoopFileSizeKB)
            ogcListViewName.ModifyCol()  ; Auto-size each column to fit its contents.
            ogcListViewName.ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
            FolderList .= A_LoopFileName . "`n"
        }
    mygui.Show()
    return

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListView")  ; This check is optional. It displays the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
MyContextMenu := Menu()
MyContextMenu.Show(A_GuiX, A_GuiY)
return

MyListView(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
{
    FileName := ogcListViewName.GetText(A_EventInfo) ; Get the text of the first field.
    FileDir := ogcListViewName.GetText(A_EventInfo)  ; Get the text of the second field.

    {   ErrorLevel := "ERROR"
       Try ErrorLevel := Run(Dir "\" FileName "" )
    }
    hotpath := dir
    MsgBox(hotpath)
    ;Run %FileDir%\%FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox("Could not open `"" FileDir "\" FileName "`".")
}
return hotpath


}
} ; V1toV2: Added bracket before function
selecthotpath(path){
  if (path = "")
  {
  hotpath := a_scriptdir . "/notes/"
  return
  }


  ogcListViewName := mygui.Add("ListView", "background000000 cFFFFFF -Hdr r20 w200 h200", ["Name"])
  ogcListViewName.OnEvent("DoubleClick", HotFileView.Bind("DoubleClick"))
  Loop("notepath . `"/`"* , 2") ; 2 = folders only
  ogcListViewName.Add("", A_LoopFileName, A_LoopFileSizeKB)
  ogcListViewName.ModifyCol()  ; Auto-size each column to fit its contents.
  ogcListViewName.ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
  FolderList .= A_LoopFileName . "`n"

mygui.Show()


  HotFileView(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
    if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
    {
      FileName := ogcListViewName.GetText(A_EventInfo) ; Get the text of the first field.
      FileDir := ogcListViewName.GetText(A_EventInfo)  ; Get the text of the second field.
    hotpath := hotpath . "/" . filename
    ogcFolder.Value := hotpath
    mygui.destroy()

}
return

}
} ; V1toV2: Added bracket before function

runfp(path := ""){
  Run(frontproject)
}
chrome_name2(){
    SetKeyDelay(100)
Send("{f10}")

Send("{space 2}")
Send("l")
Send("w")
Send("dkz")
Send("{enter}")
return
}

chrome_group2(){
;WinActivate, dkz
ErrorLevel := WinWaitActive("dkz") , ErrorLevel := ErrorLevel = 0 ? 1 : 0

Send("!g")
return
}

f13::Send("^{click}")

xbutton2 & 3::
{ ; V1toV2: Added bracket
 SendMode("Input")
 Send("{Raw}`;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]")
 Send("{Raw}`;~   ~")
 Send("{Raw}`;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]")
 Send("{home}")
 Send("{up}")
 Send("{right 2}")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

xbutton2 & b::
{ ; V1toV2: Added bracket
 SendMode("Input")
 Send("{Raw}`;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

xbutton1 & b::
{ ; V1toV2: Added bracket
    SendMode("Input")

    Send("`;[]==============================[]=================================[]")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

f13 & b::
{ ; V1toV2: Added bracket
Send("`//================")
A_Clipboard := "`;================"
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

xbutton2 & n::
f24 & g::

{ ; V1toV2: Added bracket
chrome_name()

return
} ; V1toV2: Added Bracket before hotkey or Hotstring
f24 & Space:: ;------------------------------------------------------------------
{ ; V1toV2: Added bracket
IB := InputBox("", ""), ans := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
Run("www.google.com/search?q=" ans)
crm := chrome_group()
Send("!g")

Run(frontdir)
Run(file)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring


f24 & 2::
;run sublime_text.exe "0_globalcoder.ahk" ;;"%A_ScriptFullPath%" run, d:/
{ ; V1toV2: Added bracket
Run("sublime_text.exe `"scratch\globalcoderv2.ah2`"") ;;"%A_ScriptFullPath%" run, d:/
;run, "C:\Program Files\AutoHotkey\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoder.ahk" ;/ErrorStdOut %programfiles%\autohotkey\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
;run, "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoderv2.ah2" ;/ErrorStdOut %programfiles%\autohotkey\v2\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
return




;=========================================================================================================

; main Call window R^Rshift ( f24 & rshift )
; code stats - overview of current session classes/vars/methods/etc
; Tool window -> immenates from botton right corner
;------------------------------------------------| MENU |------------------------------------------------#

;/ premaremenu(path) ; a main function for creating menu system using folder paths
} ; Added bracket before function
PrepareMenu(PATH)
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
        mygui.new("+ToolWindow", ScriptName " is Loading")      ; Adding title to progressbar
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
LoopOverFolder(PATH){
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

; Hotkey x

;// end hotkey x


;trippleclick@caret

;----------------------------------------------------------------------------------------| HOTKEYS |----------------------------------------------;



~LButton::
{ ; V1toV2: Added bracket
CheckForCaretMove("LButton","UpdatePosition")
return

; rbutton - del?
} ; V1toV2: Added Bracket before hotkey or Hotstring
~RButton::
;/
{ ; V1toV2: Added bracket
CheckForCaretMove("RButton","UpdatePosition")
Return ;//


; Hotkey x
} ; V1toV2: Added Bracket before hotkey or Hotstring
f24 & x::
;/ code

{ ; V1toV2: Added bracket
return ;// end hotkey x


;/ [ WindowsMenu ] - Ctrl + WIN L,M === Ctrl + Alt + W
;//

; MAIN MENU & the Children MENUs
;-------------------------

; main menu
} ; V1toV2: Added Bracket before hotkey or Hotstring

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

f24 & f1::
f24 & 1::
{ ; V1toV2: Added bracket
CoordMode("Menu", "Screen")
GetCaret(X, Y,, H)
;Menu, MyMenu, Show, % X, % Y + H
;%A_ScriptDir%\singles := Menu()
;%A_ScriptDir%\singles.show(X, Y + H)
singles := Menu()
singles.show(X, Y + H)
return

;--------------------------- END Main Menu Family

; quick menu / google, etc...
} ; V1toV2: Added Bracket before hotkey or Hotstring
f24 & ralt::
;/
{ ; V1toV2: Added bracket
CoordMode("Menu", "Screen")
GetCaret(X, Y,, H)
MyMenu := Menu()
MyMenu.Add("Menu Item 1(googler)", GoMenuHandler1)
MyMenu.Add("Menu Item 2", GoMenuHandler1)
MyMenu.Add("Menu Item 3", GoMenuHandler1)
MyMenu.Show(X, Y + H)
;gui, menu, mymenu
return
;//

;-------------------------- end quick menu

;------ clipboard menu
} ; V1toV2: Added Bracket before hotkey or Hotstring
f24 & c:: clipStore.ShowMenu()
;ahk_class #32768 is uniform class for menu 'windows'
; 2nd solution is binding left arrow to esc when menu is shown


; Reload
f24 & enter::
;/
{ ; V1toV2: Added bracket
    Reload()
return
;//

; exit
} ; V1toV2: Added Bracket before hotkey or Hotstring
f24 & esc::
;/
{ ; V1toV2: Added bracket
Goto(exit)
ExitApp()
;//


goMenuHandler1:
GetCaret(X, Y,, H)
;InputBox, test
;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
IB := InputBox("g - google `n f - search files? `n c - search currentdoc? `n m - main proj folder?", "", "x" x " y" y " t10000", "g" a_space), omniinput := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR" ;
checkvar := SubStr(omniINPUT, 1, 1)
MsgBox(omniinput)
omniinput := SubStr(omniinput, (1)+1)
MsgBox(checkvar "-" omniinput)
A_Clipboard := omniinput
/*switch checkvar
{
   ;case "g":
   A_Clipboard := omniinput
   runstring("www.google.com/search?q=" . A_Clipboard)
   ErrorLevel := WinWaitActive("ahk_exe chrome.exe") , ErrorLevel := ErrorLevel = 0 ? 1 : 0
   Send("!g")
   return
   ;case "f":
   MsgBox("return")
   return
   ;case "c":
   MsgBox("return")
   return
   ;case "m":
   MsgBox("return")
   return
   ;filesearch(frontfolder)
}*/
return
;// omnibox 3-selection menu w/ 4 direction switch
} ; V1toV2: Added Bracket before hotkey or Hotstring

#numpad1::
{ ; V1toV2: Added bracket
MsgBox("test")
return


;hotkey to add reference notes via edit
; -- under construction
} ; V1toV2: Added Bracket before hotkey or Hotstring


rctrl::f24
; -------------------------------------------------------------------------------------------------- under construction
f24 & 3::
;/
{ ; V1toV2: Added bracket
BoundGivePar := GivePar.Bind("First", "Test one")
BoundGivePar2 := GivePar.Bind("Second", "Test two")

; Create the menu and show it:
MyMenu.Add("Menu Name 1",  BoundGivePar)
MyMenu.Add("Menu Name 2",  BoundGivePar2)
MyMenu.Show()


; Definition of custom function GivePar:
} ; Added bracket before function
GivePar(a, b, ItemName, ItemPos, MenuName){
    MsgBox("a:`t`t" a "`n"           . "b:`t`t" b "`n"           . "ItemName:`t" ItemName "`n"           . "ItemPos:`t`t" ItemPos "`n"           . "MenuName:`t" MenuName)
           return
       }
return
;//
; --------------------------------------------------------------------------------------------------- under construction
^F1::google(1) ; Regular search
^F2::google(2) ; Images search
^F3::google(3) ; Maps search
^F4::google(4) ; Translation

$1::
$2::
$3::
$4::
$5::
$6::
$7::
$8::
$9::
$0::
{ ; V1toV2: Added bracket
CheckWord(A_ThisHotkey)
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

$^Enter::
$^Space::
$Tab::
$Up::
$Down::
$PgUp::
$PgDn::
$Right::
$Enter::
$NumpadEnter::
{ ; V1toV2: Added bracket
EvaluateUpDown(A_ThisHotKey)
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

$^+h::
{ ; V1toV2: Added bracket
MaybeOpenOrCloseHelperWindowManual()
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

$^+c::
{ ; V1toV2: Added bracket
AddSelectedWordToList()
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

$^+Delete::
{ ; V1toV2: Added bracket
DeleteSelectedWordFromList()
Return

;----------------------------------------------| quickmenu FUNCTIONS |---------------------------------------------;
} ; Added bracket before function

CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    controlName := ogc%CtrlHwnd%.Name
    MsgBox(controlName " has been clicked!")
}
GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    EditField1 := ogcEditField1.Text
    MsgBox("Go has been clicked! The content of the edit field is `"" EditField "`"!")
}

GuiClose(hWnd) {
    windowTitle := WinGetTitle("ahk_id " hWnd)
    MsgBox("The Gui with title `"" windowTitle "`" has been closed!")
    ExitApp()
}
return

;----------------------------------------------| FUNCTIONS |---------------------------------------------;

MainLoop(){
   ;global 
   g_TerminatingEndKeys
   Loop
   {

      ;If the active window has changed, wait for a new one
      IF !( ReturnWinActive() )
      {
         Critical("Off")
         GetIncludedActiveWindow()
      } else {
         Critical("Off")
      }


   ;===== can insert a condition here to block the usual terminiating keys/ temporarily remove space for end keys

   ;===== also, can direct the input chars to go to a second ( pre-function ) in combination with the normal processkey()
      ;Get one key at a time
      ihInputChar := InputHook("L1 V I","{BS}" g_TerminatingEndKeys), ihInputChar.Start(), ihInputChar.Wait(), InputChar := ihInputChar.Input

      Critical()
      EndKey := ErrorLevel

      ProcessKey(InputChar,EndKey)
   }

}


ProcessKey(InputChar,EndKey){
   ;global 
   g_Active_Id
   ;global 
   g_Helper_Id
   ;global 
   g_IgnoreSend
   ;global 
   g_LastInput_Id
   ;global 
   g_OldCaretX
   ;global 
   g_OldCaretY
   ;global 
   g_TerminatingCharactersParsed
   ;global 
   g_Word
   ;global 
   prefs_DetectMouseClickMove
   ;global 
   prefs_EndWordCharacters
   ;global 
   prefs_ForceNewWordCharacters
   ;global 
   prefs_Length

   if (g_IgnoreSend = 1)
   {
      g_IgnoreSend := ""
      Return
   }

   if (EndKey = "")
   {
      EndKey := "Max"
   }

   if (EndKey = "NewInput")
      Return

   if (EndKey = "Endkey:Tab")
      If ( GetKeyState("Alt") =1 || GetKeyState("LWin") =1 || GetKeyState("RWin") =1 )
         Return

   ;If we have no window activated for typing, we don't want to do anything with the typed character
   if (g_Active_Id = "")
   {
      if (!GetIncludedActiveWindow())
      {
         Return
      }
   }


   IF !( ReturnWinActive() )
   {
      if (!GetIncludedActiveWindow())
      {
         Return
      }
   }

   if (g_Active_Id = g_Helper_Id)
   {
      Return
   }

   ;If we haven't typed anywhere, set this as the last window typed in
   if (g_LastInput_Id = "")
      g_LastInput_Id := g_Active_Id

   if (prefs_DetectMouseClickMove != "On")
   {
      if (g_OldCaretY = "")
         g_OldCaretY := HCaretY()

      if ( g_OldCaretY != HCaretY() )
      {
         ;Don't do anything if we aren't in the original window and aren't starting a new word
         if (g_LastInput_Id != g_Active_Id)
            Return

         ; add the word if switching lines
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
         Return
      }
   }

   g_OldCaretY := HCaretY()
   g_OldCaretX := HCaretX()

   ;Backspace clears last letter
   if (EndKey = "Endkey:BackSpace")
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      if (g_LastInput_Id != g_Active_Id)
         Return

      len := StrLen(g_Word)
      if (len = 1)
      {
         ClearAllVars(true)
      } else       if (len != 0)
      {
         g_Word := SubStr(g_Word, 1, -1*(1))
      }
   } else if ( ( EndKey == "Max" ) && !(InStr(g_TerminatingCharactersParsed, InputChar)) )
   {
      ; If active window has different window ID from the last input,
      ;learn and blank word, then assign number pressed to the word
      if (g_LastInput_Id != g_Active_Id)
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
         g_LastInput_Id := g_Active_Id
         Return
      }

      if (InputChar ~= "^(?i:" RegExReplace(RegExReplace(prefs_ForceNewWordCharacters,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
      } else       if (InputChar ~= "^(?i:" RegExReplace(RegExReplace(prefs_EndWordCharacters,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
      {
         g_Word .= InputChar
         AddWordToList(g_Word, 1)
         ClearAllVars(true)
      } else {
         g_Word .= InputChar
      }

   } else    if (g_LastInput_Id != g_Active_Id)
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      Return
   } else {
      AddWordToList(g_Word,0)
      ClearAllVars(true)
      Return
   }

   ;Wait till minimum letters
   IF ( StrLen(g_Word) < prefs_Length )
   {
      CloseListBox()
      Return
   }
   SetTimer(RecomputeMatchesTimer,-1)
}

RecomputeMatchesTimer()
{ ; V1toV2: Added bracket
   Thread("NoTimers")
   RecomputeMatches()
   Return
} ; V1toV2: Added bracket before function

RecomputeMatches(){
   ; This function will take the given word, and will recompile the list of matches and redisplay the wordlist.
   ;global g_MatchTotal
   ;global g_SingleMatch
   ;global g_SingleMatchDescription
   ;global g_SingleMatchReplacement
   ;global g_Word
   ;global g_WordListDB
   ;global prefs_ArrowKeyMethod
   ;global prefs_LearnMode
   ;global prefs_ListBoxRows
   ;global prefs_NoBackSpace
   ;global prefs_ShowLearnedFirst
   ;global prefs_SuppressMatchingWord

   SavePriorMatchPosition()

   ;Match part-word with command
   g_MatchTotal := "0"

   if (prefs_ArrowKeyMethod = "Off")
   {
      if (prefs_ListBoxRows < 10)
         LimitTotalMatches := prefs_ListBoxRows
      else LimitTotalMatches := "10"
   } else {
      LimitTotalMatches := "200"
   }

   WordMatchOriginal := StrUpper(g_Word)

   WordMatch := StrUnmark(WordMatchOriginal)

   WordMatch := StrUpper(WordMatch)

   ; if a user typed an accented character, we should exact match on that accented character
   if (WordMatch != WordMatchOriginal) {
      WordAccentQuery := ""
      LoopCount := StrLen(g_Word)
      Loop LoopCount
      {
         Position := A_Index
         SubChar := SubStr(g_Word, (Position)<1 ? (Position)-1 : (Position), 1)
         SubCharNormalized := StrUnmark(SubChar)
         if !(SubCharNormalized == SubChar) {
            SubCharUpper := StrUpper(SubChar)
            SubCharLower := StrLower(SubChar)
            ; StrReplace() is not case sensitive
            ; check for StringCaseSense in v1 source script
            ; and change the CaseSense param in StrReplace() if necessary
            SubCharUpperEscaped := StrReplace(SubCharUpper, "'", "''")
            ; StrReplace() is not case sensitive
            ; check for StringCaseSense in v1 source script
            ; and change the CaseSense param in StrReplace() if necessary
            SubCharLowerEscaped := StrReplace(SubCharLower, "'", "''")
            PrefixChars := ""
            Loop Position - 1
            {
               PrefixChars .= "?"
            }
            ; because SQLite cannot do case-insensitivity on accented characters using LIKE, we need
            ; to handle it manually, so we need 2 searches for each accented character the user typed.
            ;GLOB is used for consistency with the wordindexed search.
            WordAccentQuery .= " AND (word GLOB '" . PrefixChars . SubCharUpperEscaped . "*' OR word GLOB '" . PrefixChars . SubCharLowerEscaped . "*')"
         }
      }
   } else {
      WordAccentQuery := ""
   }

   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   WordExactEscaped := StrReplace(g_Word, "'", "''")
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   WordMatchEscaped := StrReplace(WordMatch, "'", "''")

   if (prefs_SuppressMatchingWord = "On")
   {
      if (prefs_NoBackSpace = "Off")
      {
         SuppressMatchingWordQuery := " AND word <> '" . WordExactEscaped . "'"
      } else {
               SuppressMatchingWordQuery := " AND wordindexed <> '" . WordMatchEscaped . "'"
            }
   }

   WhereQuery := " WHERE wordindexed GLOB '" . WordMatchEscaped . "*' " . SuppressMatchingWordQuery . WordAccentQuery

   NormalizeTable := g_WordListDB.Query("SELECT MIN(count) AS normalize FROM Words" . WhereQuery . "AND count IS NOT NULL LIMIT " . LimitTotalMatches . ";")

   for each, row in NormalizeTable.Rows
   {
      Normalize := row[1]
   }

   if (Normalize = "")
   {
      Normalize := 0
   }

   WordLen := StrLen(g_Word)
   OrderByQuery := " ORDER BY CASE WHEN count IS NULL then "
   if (prefs_ShowLearnedFirst = "On")
   {
      OrderByQuery .= "ROWID + 1 else 0"
   } else {
      OrderByQuery .= "ROWID else 'z'"
   }

   OrderByQuery .= " end, CASE WHEN count IS NOT NULL then ( (count - " . Normalize . ") * ( 1 - ( '0.75' / (LENGTH(word) - " . WordLen . ")))) end DESC, Word"

   Matches := g_WordListDB.Query("SELECT word, worddescription, wordreplacement FROM Words" . WhereQuery . OrderByQuery . " LIMIT " . LimitTotalMatches . ";")

   g_SingleMatch := Object()
   g_SingleMatchDescription := Object()
   g_SingleMatchReplacement := Object()

   for each, row in Matches.Rows
   {
      g_SingleMatch[++g_MatchTotal] := row[1]
      g_SingleMatchDescription[g_MatchTotal] := row[2]
      g_SingleMatchReplacement[g_MatchTotal] := row[3]

      continue
   }

   ;If no match then clear Tip
   if (g_MatchTotal = 0)
   {
      ClearAllVars(false)
      Return
   }

   SetupMatchPosition()
   RebuildMatchList()
   ShowListBox()
}

HideTrayTip() {
    TrayTip()  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10." {
        Tray.NoIcon()
        Sleep(200)  ; It may be necessary to adjust this sleep.
        Tray.Icon()
        return
    }
}



;==============================[]=================================[]
;global
 GC_Subjects := {}
;GC_Subjects.containers := {}
GC_Subjects.folders := {test : A_ScriptDir . "/notes/test", code : A_ScriptDir . "/notes/code", git : A_ScriptDir . "/notes/git"}
GC_Subjects.Keywords := { 1 : "test", 2 : "code", 3 : "git"}
GC_Subjects.path := { 1 : "%a_scriptdir%/notes/test", 2 : "%a_scriptdir%/notes/code", 3 : "%a_scriptdir%/notes/git"}

class GC
{
    ;/[class] class subject{ } ;//
    static propogationString := ";/[class] class subject{ } `;// "
    static propogationStringNoSpace := "`n;/[class]`nclass subject{`n}`n;//`n"

        ;/[class]
         class subjects{

                static folders := {test : A_ScriptDir . "/notes/test", code : A_ScriptDir . "/notes/code", git : A_ScriptDir . "/notes/git"}
            } ;//
                ;/[class]
         class paths{

            } ;//
                ;/[class]
         class keywords{

            } ;//
}
;==============================[---- Menu Handler Functions for switch cases ----]=================================[]
; ---- Menu Handler Functions for switch cases ----

; Case not known; try to open the file
Handler_Default(PATH){
    Handler_LaunchProgram(PATH)
}
;contents of .txt should be copied to clipboard and pasted. This is fast.
Handler_txt(PATH){

    A_Clipboard := Fileread(PATH)

    ; Gets amount of words (spaces) in file just pasted
    GetWordCount()
    Sleep(50)

    ; Adds Info to file
    AddAmountFile(A_ThisMenuItem, TotalWords)
    Sleep(50)

    ; Paste content of clipboard
    Send("^v")
}
Handler_note(PATH){
    ;put all into clipboard
    A_Clipboard := Fileread(PATH)

    ;all into variable 'readfile'
    readfile := Fileread(PATH)
    fulldata := A_Clipboard
    ;split file by each line in file '`n' and report the first
    ;StrSplit(String, [Delimiters, OmitChars])
    readfile := strsplit(readfile, "`n", "`r")

MsgBox("0: "  readfile.MaxIndex())


    report := readfile[1]

    ;pass the 'report' into a validator, or -director- I should say.
    determine(report, fulldata)

    ;if the file contains a known keyboard (heading), add it to a collection of files that contain the same headings
    for k,v in gc_subjects.data
        MsgBox(k "- " v)

    ; Gets amount of words (spaces) in file just pasted
    GetWordCount()
    Sleep(50)
    ; Adds Info to file
    AddAmountFile(A_ThisMenuItem, TotalWords)
    Sleep(50)

    ; Paste content of clipboard
    Send("^v")
}
; If program is executable, simply launch it
Handler_LaunchProgram(FilePath){
    Run(FilePath)
}
; .rtf files should be opened with a ComObject, that silently opens the file and copies the formatted text. Then paste
Handler_RTF(FilePath){
    ; Clears clipboard. Syntax looks werid, but it is right.
    A_Clipboard := ""
    Sleep(200)

    ; Load contents of file into memory
    oDoc := ComObjGet(FilePath)
    Sleep(250)

    ; Copy contents of file into clipboard
    oDoc.Range.FormattedText.Copy
    Sleep(250)

    ; Wait up to two seconds for content to appear on the clipboard
    Errorlevel := !ClipWait(2)
    if ErrorLevel
    {
        MsgBox("The attempt to copy text onto the A_Clipboard failed.")
        return
    }

    ; File is no longer needed, close it
    oDoc.Close(0)
    Sleep(250)

    ; Gets amount of words (spaces) in file just pasted
    GetWordCount()
    Sleep(50)

    ; Add amount words to the AmountFile
    AddAmountFile(A_ThisMenuItem, TotalWords)
    Sleep(50)

    ; Then Paste
    Send("^v")
    Sleep(50)
}
;todo
Handler_Settings(filepath){

    return
}
Handler_hotstrings(filepath){
;put all into clipboard
    A_Clipboard := Fileread(PATH)

    fulldata := A_Clipboard
    ;all into variable 'readfile'
    readfile := Fileread(PATH)

    ;split file by each line in file '`n' and report the first
    ;StrSplit(String, [Delimiters, OmitChars])
    readfile := strsplit(readfile, "`n", "`r")

    MsgBox("0: "  readfile.MaxIndex())


    report := readfile[1]

    ;pass the 'report' into a validator, or -director- I should say.
    determine(report, fulldata)
    return
}
Handler_Ahk(filepath){
    return
}
Handler_json(filepath){
    return
}
Handler_html(filepath){
    return
}



determine(content,fulldata){
    gc_subjects := {}
    gc_subjects.list := { 1 : "test", 2 : "code", 3 : "git"}
    gc_subjects.path := { 1 : "%a_scriptdir%/notes/test", 2 : "%a_scriptdir%/notes/code", 3 : "%a_scriptdir%/notes/git"}
    gc_subjects.data


    MsgBox("CONTENT IS: " content "`n full data: " fulldata)

        for k,v in GC_Subjects.list
        {
            ;InStr(Haystack, Needle [, CaseSensitive?, StartingPos])
            if (InStr(content, v))
            {
                MsgBox(content " - does contains - " v)

                ;gc_subjects.data := {v : "%fulldata%"}
                gc_subjects.data := {1 : fulldata}

                MsgBox("gc_subjects.data" gc_subjects.data)
                for k,v in gc_subjects.data
                MsgBox("gc_subjects.data : " k "-" v)
            }
            else
            {
                MsgBox(content " - doesnt contains - " v)
                ;return false
            }
        }

            for k,v in GC_Subjects.data
                MsgBox(V "-" K)
            for k,v in GC_Subjects.path
                            MsgBox(V "-" K)

        MsgBox("gc_subjects.data")
return gc_subjects.data
        }




director(report, path, rec := "RFD")
{
    len := strlen(report)
    if (len = 0)
    return
}


; ---- Other Functions ----
; Amountfile is a .csv that the user can use to see how much info was saved.
AddAmountFile(FileName, WordCount){
    ; Average Typing speed is 40 wpm pr. https://www.typingpal.com/en/typing-test
    MinutesSaved := WordCount / 40

    ; It will look like 28-12-2021 13:23
    CurrentDateTime := FormatTime(, "dd-MM-yyyy HH:mm")

    ; Check if file already exists. All other times than the very first run, it will exist.
    ; If if not, create it and append, otherwise just append
    if FileExist("logs/AmountUsed.csv")
    {
        FileAppend(CurrentDateTime "," FileName "," WordCount "," MinutesSaved "`n", A_ScriptDir "\AmountUsed.csv")
    }
    else
    {
        FileAppend("Date,Text,Word Count,Minutes Saved`n", A_ScriptDir "\AmountUsed.csv")
        FileAppend(CurrentDateTime "," FileName "," WordCount "," MinutesSaved "`n", A_ScriptDir "\AmountUsed.csv")
    }
}

; Gets the amount of words on the clipboard
GetWordCount(){
    ;Global 
    TotalWords := 0
    Loop Parse, A_Clipboard, A_Space
    {
        TotalWords := A_Index
    }
}

; Recursively
FindAmountItems(){
    Loop Files, A_ScriptDir "\*", "FR"
    {
        global items := items+ 1
    }
}

; Iterate step of the GUI process bar by one
FoundItem(WhatWasFound){
    ;global
    ogcMyProgress.Value += 1

    ; Comment in for Debug
    ;~ Sleep, 50
    ;~ MsgBox, % "Found " WhatWasFound ": " A_LoopFileName "`n`nWith Path:`n" A_LoopFileFullPath "`n`nIn Folder`n" A_LoopFileDir
}

; Restarts the program. This is handy for updates in the code
ReloadProgram(){
    MsgBox("Restarting " ScriptName, "About to restart " ScriptName, 64)
    Reload()
}

; Exits the program
ExitApp()
{
    msgResult := MsgBox(ScriptName " will TERMINATE when you click OK", "About to exit " ScriptName, 48)
    if (msgResult = "OK")
    ExitApp()
}

; Opens explorer window in root folder of script
GoToRootFolder(){
    Run("explore " A_ScriptDir)
}

; Opens explorer window in folder where custom folders and menu item goes
GoToCustomFolder(){
    Run("explore " A_ScriptDir "\CustomMenuFiles")
}

; Launch Github repo
Github(){
    Run("https://github.com/donovanzeanah/globalcoder")
}
googler(){
    static urls := { 0: ""      , 1 : "https://www.google.com/search?hl=en&q="      , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="        , 3 : "https://www.google.com/maps/search/"     , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
        MsgBox(urls.1)

   WinActivate(callingwindow)
   Send("^c")
   if (A_Clipboard = "")
        {
           IB := InputBox("", ""), googlequery := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
           A_Clipboard := googlequery
        }
    runstring("www.google.com/search?q=" . A_Clipboard)
   ;Run, www.google.com/search?q=%clipboard%
   ErrorLevel := WinWaitActive("ahk_exe chrome.exe") , ErrorLevel := ErrorLevel = 0 ? 1 : 0
   Send("!g")
   A_Clipboard := ""
}
google(service := 1){
   if A_Clipboard := ""
   {
      return
   }
    static urls := { 0: ""        , 1 : "https://www.google.com/search?hl=en&q="        , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="        , 3 : "https://www.google.com/maps/search/"        , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }

    backup := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    Errorlevel := !ClipWait(0)
    if ErrorLevel
        IB := InputBox("", "Google Search", "w200 h100"), query := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    else
    query := A_Clipboard
    Run(urls[service] query)
    A_Clipboard := backup
}

; Attemps to start all other files in the specified path.
RunOtherScripts(PATH){
    Loop Files, PATH "\*.ahk", "F"
    {
        ;~ MsgBox, % "Including:`n" A_LoopFilePath
        Run(A_LoopFilePath)
    }
}



;====================================To Do Functions
/*
todo(){
static todolistview
Gui, two: default
Gui, two: +AlwaysOnTop +Resize
Gui, two: Add, ListView, sort r10 checked -readonly vtodoListView gtodoListView AltSubmit, Items To Do
Gui, two: Add, Button, section gAddItem,Add to list
Gui, two: Add, Edit, ys r20 vNewItem w180 , <Enter New Item Here>

;LV_ModifyCol(2, 0)

SelectedRow := 0

IfnotExist, ToDoList.txt
{
FileAppend, a_space, % a_scriptdir "/todolist.txt"
}
Loop, Read, ToDoList.txt
  {
  If (A_index = 1 and SubStr(A_LoopReadLine, 1, 1) = "x")
     {
       WinPos := A_LoopReadLine
       If Substr(WinPos, 2, 1) = "-"
         WinPos := "x600 y200 w360 h220"

       Continue
     }
  If SubStr(A_LoopReadLine, 1, 1) = "*"
    {
     StringTrimLeft, CheckedText, A_LoopReadLine, 1
     LV_Add("Check", CheckedText,A_Index-1)
    }
  Else
  {
     LV_Add("", A_LoopReadLine,A_Index-1)
  }





}



LV_ModifyCol(1,"AutoHdr")




IfExist, ToDoList.txt
  {
     Gui, two: Show, %WinPos% , To Do List
  }
Else
  {
     WinGetPos,X1,Y1,W1,H1,Program Manager
     X2 := W1-300
     Gui, two: Show, x%x2% y50 , To Do List
  }

LV_ColorInitiate() ; (Gui_Number, Control) - defaults to: (1, SysListView321)
SetColor()

GUI, 2: Destroy

Return
}
*/
;====================================Typing Text Functions


runstring(string_path){
Run(string_path)
}

readomni(omniinput)
Return

MenuHandler2:

Return
MenuHandler3:
    ; do something
Return
readomni(omniinput){
   StrSplit(omniinput, a_space ," ")
   for k,v in omniinput
   MsgBox(v)
}
GetCaret(&X:="", &Y:="", &W:="", &H:="") {

    ; UIA caret
    static IUIA := ComObject("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
    ; GetFocusedElement
    DllCall(NumGet(NumGet(IUIA+0, "UPtr")+8*A_PtrSize, "UPtr"), "ptr", IUIA, "ptr*", &FocusedEl:=0)
    ; GetCurrentPattern. TextPatternElement2 = 10024
    DllCall(NumGet(NumGet(FocusedEl+0, "UPtr")+16*A_PtrSize, "UPtr"), "ptr", FocusedEl, "int", 10024, "ptr*", &patternObject:=0), ObjRelease(FocusedEl)
    if patternObject {
        ; GetCaretRange
        DllCall(NumGet(NumGet(patternObject+0, "UPtr")+10*A_PtrSize, "UPtr"), "ptr", patternObject, "int*", &IsActive:=1, "ptr*", &caretRange:=0), ObjRelease(patternObject)
        ; GetBoundingRectangles
        DllCall(NumGet(NumGet(caretRange+0, "UPtr")+10*A_PtrSize, "UPtr"), "ptr", caretRange, "ptr*", &boundingRects:=0), ObjRelease(caretRange)
        ; VT_ARRAY = 0x20000 | VT_R8 = 5 (64-bit floating-point number)
        Rect := ComValue(0x2005, boundingRects)
        if (Rect.MaxIndex() = 3) {
            X:=Round(Rect[0]), Y:=Round(Rect[1]), W:=Round(Rect[2]), H:=Round(Rect[3])
            return
        }
    }

    ; Acc caret
    static _ := DllCall("LoadLibrary", "Str", "oleacc", "Ptr")
    idObject := 0xFFFFFFF8 ; OBJID_CARET
    if DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", WinExist("A"), "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetStrCapacity(&IID, 16)+NumPut("Int64", idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81, 
       IID), "Ptr*", &pacc:=0)=0 { ; V1toV2: if 'IID' is NOT a UTF-16 string, use 'IID := Buffer(16)'
        oAcc := ComObjEnwrap(9,pacc,1)
        oAcc.accLocation(ComObj(0x4003,&_x:=0), ComObj(0x4003,&_y:=0), ComObj(0x4003,&_w:=0), ComObj(0x4003,&_h:=0), 0)
        X:=NumGet(_x, 0, "int"), Y:=NumGet(_y, 0, "int"), W:=NumGet(_w, 0, "int"), H:=NumGet(_h, 0, "int")
        if (X | Y) != 0
            return
    }

    ; default caret
    CoordMode("Caret", "Screen")
    X := A_CaretX
    Y := A_CaretY
    W := 4
    H := 20
}
CheckForCaretMove(MouseButtonClick, UpdatePosition := false){
   ;/
   ;global 
   g_LastInput_Id
   ;global 
   g_MouseWin_Id
   ;global 
   g_OldCaretX
   ;global 
   g_OldCaretY
   ;global 
   g_Word
   ;global 
   prefs_DetectMouseClickMove

   ;If we aren't using the DetectMouseClickMoveScheme, skip out
   if (prefs_DetectMouseClickMove != "On")
      Return

   if (UpdatePosition)
   {
      ; Update last click position in case Caret is not detectable
      ;  and update the Last Window Clicked in
      MouseGetPos(&MouseX, &MouseY, &g_MouseWin_Id)
      WinGetPos(, &TempY, , , "ahk_id " g_MouseWin_Id)
   }

   if (MouseButtonClick = "LButton")
   {
      ErrorLevel := !KeyWait("LButton", "U")
   } else    ErrorLevel := !KeyWait("RButton", "U")

   if (g_LastInput_Id != g_MouseWin_Id)
   {
      Return
   }

   SM_CYCAPTION := SysGet(4)
   SM_CYSIZEFRAME := SysGet(33)

   TempY += SM_CYSIZEFRAME
   IF ( ( MouseY >= TempY ) && (MouseY < (TempY + SM_CYCAPTION) ) )
   {
      Return
   }

   ; If we have a g_Word and an g_OldCaretX, check to see if the Caret moved
   if (g_OldCaretX != "")
   {
      if (g_Word != "")
      {
         if (( g_OldCaretY != HCaretY() ) || (g_OldCaretX != HCaretX() ))
         {
            ; add the word if switching lines
            AddWordToList(g_Word,0)
            ClearAllVars(true)
         }
      }
   }

   Return
} ;//

;------------------------------------------------------------------------

InitializeHotKeys(){
   ;/
   ;global 
   g_DelimiterChar
   ;global 
   g_EnabledKeyboardHotKeys
   ;global 
   prefs_ArrowKeyMethod
   ;global 
   prefs_DisabledAutoCompleteKeys
   ;global 
   prefs_LearnMode

   g_EnabledKeyboardHotKeys := ""

   ;Setup toggle-able hotkeys

   ;Can't disable mouse buttons as we need to check to see if we have clicked the ListBox window
   ; If we disable the number keys they never get to the input for some reason,
   ; so we need to keep them enabled as hotkeys

   if (prefs_LearnMode != "On")
   {
      Hotkey("$^+Delete", "Off")
   } else {
      Hotkey("$^+Delete", "Off")
      ; We only want Ctrl-Shift-Delete enabled when the listbox is showing.
      g_EnabledKeyboardHotKeys .= "$^+Delete" . g_DelimiterChar
   }

   Hotkey("$^+c", "On")

   if (prefs_ArrowKeyMethod = "Off")
   {
      Hotkey("$^Enter", "Off")
      Hotkey("$^Space", "Off")
      Hotkey("$Tab", "Off")
      Hotkey("$Right", "Off")
      Hotkey("$Up", "Off")
      Hotkey("$Down", "Off")
      Hotkey("$PgUp", "Off")
      Hotkey("$PgDn", "Off")
      Hotkey("$Enter", "Off")
      Hotkey("$NumpadEnter", "Off")
   } else {
      g_EnabledKeyboardHotKeys .= "$Up" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$Down" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgUp" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgDn" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(E)")
         Hotkey("$^Enter", "Off")
      else g_EnabledKeyboardHotKeys .= "$^Enter" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(S)")
         Hotkey("$^Space", "Off")
      else g_EnabledKeyboardHotKeys .= "$^Space" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(T)")
         Hotkey("$Tab", "Off")
      else g_EnabledKeyboardHotKeys .= "$Tab" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(R)")
         Hotkey("$Right", "Off")
      else g_EnabledKeyboardHotKeys .= "$Right" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(U)")
         Hotkey("$Enter", "Off")
      else g_EnabledKeyboardHotKeys .= "$Enter" . g_DelimiterChar
      if (prefs_DisabledAutoCompleteKeys ~= "i)(M)")
         Hotkey("$NumpadEnter", "Off")
      else g_EnabledKeyboardHotKeys .= "$NumpadEnter" . g_DelimiterChar
   }

   ; remove last ascii 2
   g_EnabledKeyboardHotKeys := SubStr(g_EnabledKeyboardHotKeys, 1, -1*(1))

} ;//

EnableKeyboardHotKeys(){
   ;global 
   g_DelimiterChar
   ;global 
   g_EnabledKeyboardHotKeys
   Loop Parse, g_EnabledKeyboardHotKeys, g_DelimiterChar
   {
      Hotkey(A_LoopField, "On")
   }
   Return
}

DisableKeyboardHotKeys(){
   ;global 
   g_DelimiterChar
   ;global 
   g_EnabledKeyboardHotKeys
   Loop Parse, g_EnabledKeyboardHotKeys, g_DelimiterChar
   {
      Hotkey(A_LoopField, "Off")
   }
   Return
}
;------------------------------------------------------------------------
;/ checkword(key)
; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed
CheckWord(Key){
   ;global 
   g_ListBox_Id
   ;global 
   g_Match
   ;global 
   g_MatchStart
   ;global 
   g_NumKeyMethod
   ;global 
   g_SingleMatch
   ;global 
   g_Word
   ;global 
   prefs_ListBoxRows
   ;global 
   prefs_NumPresses

   Key := SubStr(Key, -1*(1)) ;Grab just the number pushed, trim off the "$"

   if (Key = 0)
   {
      WordIndex := g_MatchStart + 9
   } else {
            WordIndex := g_MatchStart - 1 + Key
         }

   if (g_NumKeyMethod = "Off")
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      Return
   }

   if (prefs_NumPresses = 2)
      SuspendOn()

   ; If active window has different window ID from before the input, blank word
   ; (well, assign the number pressed to the word)
   if !(ReturnWinActive())
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      if (prefs_NumPresses = 2)
         SuspendOff()
      Return
   }

   if ReturnLineWrong() ;Make sure we are still on the same line
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      if (prefs_NumPresses = 2)
         SuspendOff()
      Return
   }

   if (g_Match != "")
   {
      if (g_ListBox_Id = "")        ; only continue if match is not empty and list is showing
      {
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         if (prefs_NumPresses = 2)
            SuspendOff()
         Return
      }
   }

   if (g_Word = "")        ; only continue if g_word is not empty
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      if (prefs_NumPresses = 2)
         SuspendOff()
      Return
   }

   if ( ( (WordIndex + 1 - MatchStart) > prefs_ListBoxRows) || ( g_Match = "" ) || (g_SingleMatch[WordIndex] = "") )   ; only continue g_SingleMatch is not empty
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      if (prefs_NumPresses = 2)
         SuspendOff()
      Return
   }

   if (prefs_NumPresses = 2)
   {
      ihKeyAgain := InputHook("L1 I T0.5",1234567890), ihKeyAgain.Start(), ihKeyAgain.Wait(), KeyAgain := ihKeyAgain.Input

      ; If there is a timeout, abort replacement, send key and return
      if (ErrorLevel = "Timeout")
      {
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         SuspendOff()
         Return
      }

      ; Make sure it's an EndKey, otherwise abort replacement, send key and return
      if !InStr(ErrorLevel, "EndKey:")
      {
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }

      ; If the 2nd key is NOT the same 1st trigger key, abort replacement and send keys
      if !InStr(ErrorLevel, Key)
      {
         KeyAgain := SubStr(ErrorLevel, (7)+1)
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }

      ; If active window has different window ID from before the input, blank word
      ; (well, assign the number pressed to the word)
      if !(ReturnWinActive())
      {
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }

      if ReturnLineWrong() ;Make sure we are still on the same line
      {
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }
   }

   SendWord(WordIndex)
   if (prefs_NumPresses = 2)
      SuspendOff()
   Return
}
;//
;------------------------------------------------------------------------
;If a hotkey related to the up/down arrows was pressed
EvaluateUpDown(Key){
   ;global 
   g_ListBox_Id
   ;global 
   g_Match
   ;global 
   g_MatchPos
   ;global 
   g_MatchStart
   ;global 
   g_MatchTotal
   ;global 
   g_OriginalMatchStart
   ;global 
   g_SingleMatch
   ;global 
   g_Word
   ;global 
   prefs_ArrowKeyMethod
   ;global 
   prefs_DisabledAutoCompleteKeys
   ;global 
   prefs_ListBoxRows

   if (prefs_ArrowKeyMethod = "Off")
   {
      if (Key != "$LButton")
      {
         SendKey(Key)
         Return
      }
   }

   if (g_Match = "")
   {
      SendKey(Key)
      Return
   }

   if (g_ListBox_Id = "")
   {
      SendKey(Key)
      Return
   }

   if !(ReturnWinActive())
   {
      SendKey(Key)
      ClearAllVars(false)
      Return
   }

   if ReturnLineWrong()
   {
      SendKey(Key)
      ClearAllVars(true)
      Return
   }

   if (g_Word = "") ; only continue if word is not empty
   {
      SendKey(Key)
      ClearAllVars(false)
      Return
   }

   if ( ( Key = "$^Enter" ) || ( Key = "$Tab" ) || ( Key = "$^Space" ) || ( Key = "$Right") || ( Key = "$Enter") || ( Key = "$LButton") || ( Key = "$NumpadEnter") )
   {
      if (Key = "$^Enter")
      {
         KeyTest := "E"
      } else       if (Key = "$Tab")
      {
         KeyTest := "T"
      } else       if (Key = "$^Space")
      {
         KeyTest := "S"
      } else       if (Key = "$Right")
      {
         KeyTest := "R"
      } else       if (Key = "$Enter")
      {
         KeyTest := "U"
      } else       if (Key = "$LButton")
      {
         KeyTest := "L"
      } else       if (Key = "$NumpadEnter")
      {
         KeyTest := "M"
      }

      if (KeyTest == "L") {
         ;when hitting LButton, we've already handled this condition
      } else       if (prefs_DisabledAutoCompleteKeys ~= "i)(" RegExReplace(RegExReplace(KeyTest, "[\\\.\*\?\+\[\{\|\(\)\^\$]", "\$0"), "\s*,\s*", "|") ")")
      {
         SendKey(Key)
         Return
      }

      if (g_SingleMatch[g_MatchPos] = "") ;only continue if g_SingleMatch is not empty
      {
         SendKey(Key)
         g_MatchPos := g_MatchTotal
         RebuildMatchList()
         ShowListBox()
         Return
      }

      SendWord(g_MatchPos)
      Return

   }

   PreviousMatchStart := g_OriginalMatchStart

   if (Key = "$Up")
   {
      g_MatchPos--

      if (g_MatchPos < 1)
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         if (g_MatchStart < 1)
            g_MatchStart := "1"
         g_MatchPos := g_MatchTotal
      } else       if (StrCompare(g_MatchPos, g_MatchStart) < 0)
      {
         g_MatchStart-- 
      }
   } else    if (Key = "$Down")
   {
      g_MatchPos++
      if (StrCompare(g_MatchPos, g_MatchTotal) > 0)
      {
         g_MatchStart := "1"
         g_MatchPos := "1"
      } Else If ( g_MatchPos > ( g_MatchStart + (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart++
      }
   } else    if (Key = "$PgUp")
   {
      if (g_MatchPos = 1)
      {
         g_MatchPos := g_MatchTotal - (prefs_ListBoxRows - 1)
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
      } Else {
         g_MatchPos-=prefs_ListBoxRows
         g_MatchStart-=prefs_ListBoxRows
      }

      if (g_MatchPos < 1)
         g_MatchPos := "1"
      if (g_MatchStart < 1)
         g_MatchStart := "1"

   } else    if (Key = "$PgDn")
   {
      if (g_MatchPos = g_MatchTotal)
      {
         g_MatchPos := prefs_ListBoxRows
         g_MatchStart := 1
      } else {
         g_MatchPos+=prefs_ListBoxRows
         g_MatchStart+=prefs_ListBoxRows
      }

      if (StrCompare(g_MatchPos, g_MatchTotal) > 0)
         g_MatchPos := g_MatchTotal

      If ( g_MatchStart > ( g_MatchTotal - (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         if (g_MatchStart < 1)
            g_MatchStart := "1"
      }
   }

   if (g_MatchStart = PreviousMatchStart)
   {
      Rows := GetRows()
      if (g_MatchPos != "")
      {
         ListBoxChooseItem(Rows)
      }
   } else {
      RebuildMatchList()
      ShowListBox()
   }
   Return
}
;------------------------------------------------------------------------

ReturnLineWrong(){
   ;global 
   g_OldCaretY
   ;global 
   prefs_DetectMouseClickMove
   ; Return false if we are using DetectMouseClickMove
   if (prefs_DetectMouseClickMove = "On")
   {
      Return
   }

   Return ( g_OldCaretY != HCaretY() )
}
;------------------------------------------------------------------------

AddSelectedWordToList(){
   ClipboardSave := ClipboardAll()
   A_Clipboard := ""
   Sleep(100)
   SendCompatible("^c",0)
   Errorlevel := !ClipWait(0)
   if (A_Clipboard != "")
   {
      AddWordToList(A_Clipboard,1,"ForceLearn")
   }
   A_Clipboard := ClipboardSave
}
DeleteSelectedWordFromList(){
   ;global 
   g_MatchPos
   ;global 
   g_SingleMatch

   if !(g_SingleMatch[g_MatchPos] = "") ;only continue if g_SingleMatch is not empty
   {

      DeleteWordFromList(g_SingleMatch[g_MatchPos])
      RecomputeMatches()
      Return
   }
}
;------------------------------------------------------------------------
EvaluateScriptPathAndTitle(){
   ;relaunches to 64 bit or sets script title
   ;global 
   g_ScriptTitle

   SplitPath(A_ScriptName, , , &ScriptExtension, &ScriptNoExtension)

   If A_Is64bitOS
   {
      IF (A_PtrSize = 4)
      {
         IF A_IsCompiled
         {

            ScriptPath64 := A_ScriptDir . "\" . ScriptNoExtension . "64." . ScriptExtension

            if FileExist(ScriptPath64)
            {
               Run( A_WorkingDir)
               ExitApp()
            }
         }
      }
   }

   if (SubStr(ScriptNoExtension, ((StrLen(ScriptNoExtension)-1)<1 ? (StrLen(ScriptNoExtension)-1)-1 : (StrLen(ScriptNoExtension)-1))<1 ? ((StrLen(ScriptNoExtension)-1)<1 ? (StrLen(ScriptNoExtension)-1)-1 : (StrLen(ScriptNoExtension)-1))-1 : ((StrLen(ScriptNoExtension)-1)<1 ? (StrLen(ScriptNoExtension)-1)-1 : (StrLen(ScriptNoExtension)-1)), 2) == "64" )
   {
      g_ScriptTitle := SubStr(ScriptNoExtension, 1, -1*(2))
   } else {
      g_ScriptTitle := ScriptNoExtension
   }

   if (InStr(g_ScriptTitle, "TypingAid"))
   {
      g_ScriptTitle := "TypingAid"
   }

   return
}

;------------------------------------------------------------------------

/*InactivateAll(){
   ;Force unload of Keyboard Hook and WinEventHook
   ih := InputHook(), ih.Start(), ih.Wait(),  := ih.Input
   SuspendOn()
   CloseListBox()
   MaybeSaveHelperWindowPos()
   DisableWinHook()
}

SuspendOn(){
   global g_ScriptTitle
   Suspend(true)
   Tray.Tip(g_ScriptTitle . " - Inactive")
   If A_IsCompiled
   {
      tray.Icon(A_ScriptFullPath, "3", "1")
   } else
   {

    Tray.Icon("Shell32.dll", "28", "1")
    ;Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Inactive.ico, ,1
   }
}
SuspendOff(){
   global g_ScriptTitle
   Suspend(false)
   Tray.Tip(g_ScriptTitle . " - Active")
   If A_IsCompiled
   {
    Tray.Icon("Shell32.dll", "28", "1")


   } else
   {
        Tray.Icon("Shell32.dll", "14", "1")


    ;  Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Active.ico, ,1
          ;  Menu, tray, Icon, %A_ScriptFullPath%,1,1

   }
}*/
;------------------------------------------------------------------------

BuildTrayMenu(){
    ;Prevents hotkeys from being fired before everything is configured correctly
    Critical("On")

   Tray.Delete()
   Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
   Tray.add("Settings", Configuration)
   Tray.add("filemenu")
   Tray.add("mymenubar")
   Tray.add("Pause", PauseResumeScript)
   IF (A_IsCompiled)
   {
      Tray.add("Exit", ExitScript)
   } else {
      Tray.AddStandard()
   }
   Tray.Default := "Settings"
   ;Menu, Tray, Default, Settings
   ;Initialize Tray Icon
   Tray.Icon()
}
;------------------------------------------------------------------------

; This is to blank all vars related to matches, ListBox and (optionally) word
ClearAllVars(ClearWord){
   ;global
   CloseListBox()
   if (ClearWord = 1)
   {
      g_Word := ""
      g_OldCaretY := ""
      g_OldCaretX := ""
      g_LastInput_id := ""
      g_ListBoxFlipped := ""
      g_ListBoxMaxWordHeight := ""
   }

   g_SingleMatch := ""
   g_SingleMatchDescription := ""
   g_SingleMatchReplacement := ""
   g_Match := ""
   g_MatchPos := ""
   g_MatchStart := ""
   g_OriginalMatchStart := ""
   Return
}
;------------------------------------------------------------------------
FileAppendDispatch(Text,FileName,ForceEncoding:=0){
   if (1 = 1)
   {
      if (ForceEncoding != 0)
      {
         FileAppend(Text, FileName, ForceEncoding)
      } else
      {
         FileAppend(Text, FileName, "UTF-8")
      }
   } else {
            FileAppend(Text, FileName)
         }
   Return
}

MaybeFixFileEncoding(File,Encoding){
   if (StrCompare(A_AhkVersion, "1.0.90.0") >= 0)
   {

      if FileExist(File)
      {
         if (1 != 1)
         {
            Encoding := ""
         }


         EncodingCheck := FileOpen(File,"r")

         If EncodingCheck
         {
            If Encoding
            {
               IF !(EncodingCheck.Encoding = Encoding)
                  WriteFile := "1"
            } else
            {
               IF (SubStr(EncodingCheck.Encoding, 1, 3) = "UTF")
                  WriteFile := "1"
            }

            IF WriteFile
            {
               Contents := EncodingCheck.Read()
               EncodingCheck.Close()
               EncodingCheck := ""
               Try{
                  FileCopy(File, File ".preconv.bak")
                  ErrorLevel := 0
               } Catch as Err {
                  ErrorLevel := Err.Extra
               }
               FileDelete(File)
               FileAppend(Contents, File, Encoding)

               Contents := ""
            } else
            {
               EncodingCheck.Close()
               EncodingCheck := ""
            }
         }
      }
   }
}

;------------------------------------------------------------------------

GetOSVersion(){
   return ((r := DllCall("GetVersion") & 0xFFFF) & 0xFF) "." (r >> 8)
}
;------------------------------------------------------------------------
MaybeCoInitializeEx(){
   ;global 
   g_NULL
   ;global 
   g_ScrollEventHook
   ;global 
   g_WinChangedEventHook

   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoInitializeEx", "Ptr", g_NULL, "Uint", g_NULL)
   }
}

MaybeCoUninitialize(){
   ;global 
   g_WinChangedEventHook
   ;global 
   g_ScrollEventHook
   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoUninitialize")
   }
}

;========================= labels
;-----------------------------------------------| LABELS |-----------------------------------------------#;

; This is called when user selects an item from a menu in GUI window
MenuEventHandler(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    ; Draw the rectangle, the hourglass and update the Window
    Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
    Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

    ; Get Extension of item to evaluate what handler to use
    WordArray := StrSplit(A_ThisMenuItem, ".")
    FileExtension := WordArray[WordArray.MaxIndex()]

    ; Get full path from Menu Item pass to handler
    FileItem := SubStr(A_ThisMenuItem, 2, StrLen(A_ThisMenuItem))
    FilePath := A_ThisMenu "\" A_ThisMenuItem

    ; Run item with appropriate handler
    /*Switch FileExtension
    {
        case "rtf" : Handler_RTF(FilePath)
        case "bat" : Handler_LaunchProgram(FilePath)
        case "txt" : Handler_txt(FilePath)
        case "lnk" : Handler_LaunchProgram(FilePath)
        case "exe" : Handler_LaunchProgram(FilePath)
        case "ahn" : Handler_Note(FilePath)

        Default: Handler_Default(FilePath)
    }*/

    ; Clear the graphics and update thw window
    Gdip_GraphicsClear(G)                                 ;This sets the entire area of the graphics to 'transparent'
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

    return
}

; Is run when the program exits. This will take care of now unused graphics elements
Exit(A_ExitReason, ExitCode)
{
    Gdip_DeleteBrush(pBrush)    ; Delete the brush as it is no longer needed and wastes memory
    SelectObject(hdc, obm)      ; Select the object back into the hdc
    DeleteObject(hbm)           ; Now the bitmap may be deleted
    DeleteDC(hdc)               ; Also the device context related to the bitmap may be deleted
    Gdip_DeleteGraphics(G)      ; The graphics may now be deleted

    ; gdi+ may now be shutdown on exiting the program
    Gdip_Shutdown(pToken)
    ExitApp()
    Return 1
}

DrawGraphics:
{
    ; Draw the rectangle and hourglass to the graphic
    Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
    Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)

    ; Update the display to show the graphcis
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
    return
}

DeleteGraphics:
{
    ; This sets the entire area of the graphics to 'transparent'
    Gdip_GraphicsClear(G)

    ; Update the display to ide the graphics
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
    return
}

;========================================================================================================[ Windows Menu auxillaries ]

;/ autoexecute_windowsmenu() - autoexecute section

autoexecute_windowsmenu:
MsgBox("went to" A_ThisLabel)
mygui.Opt("+LastFound")        ; Window open/close detection
hWnd := WinExist()        ; Window open/close detection
DllCall("RegisterShellHookWindow", "UInt", hWnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, ShellMessage)

; To prevent Menu command errors from stopping script.
MenuName.UseErrorLevel()

/*
   The following code sets up the Gui with a DropDownList with the original list of
   open windows. Remove or comment out this code for Menu only.
*/
mygui.Opt("+AlwaysOnTop")
mygui.SetFont("s12", "Arial")
ogcDropDownListWindowMove := mygui.Add("DropDownList", "w275 vWindowMove  Sort Choose1")
ogcDropDownListWindowMove.OnEvent("Change", PosChoice.Bind("Change")) ; ,Pick a Window||
FileMenu.Add("&Rescan`tCtrl+R", GuiReset)
MyMenuBar.Add("&File", FileMenu)
mygui.MenuBar := MyMenuBar

;GuiReset(mygui)

Return

 ;// end autoexecute_windowsmenu()

;/ ALL Windows Menu Labels & Functions
/*ShellMessage( wParam,lParam ) {
   If ( wParam = 1 ) ; or ( wParam = 2 )  HSHELL_WINDOWCREATED := 1
   {
      GuiReset()
   }
}*/

; Subroutine scans open windows and creates a list for both the menu and Gui DropDownList.
GuiReset(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oOpenWindow := WinGetList(,,,)
aOpenWindow := Array()
OpenWindow := oOpenWindow.Length
For v in oOpenWindow
{   aOpenWindow.Push(v)
}
ogcDropDownListWindowMove.Delete() ;Clean the list
ogcDropDownListWindowMove.Add([])
WindowMenu := Menu()
WindowMenu.Delete()
WindowMenu.Add("Rescan Windows", GuiReset)
WindowMenu.Icon("Rescan Windows", "C:\Windows\System32\imageres.dll", "140")

Loop aOpenWindow.Length
{
   Title := WinGetTitle("ahk_id " aOpenWindow[A_Index])
   Class := WinGetClass("ahk_id " aOpenWindow[A_Index])
   AppName := WinGetProcessPath(Title)

   If (Title != "" and Class != "BasicWindow" and Title != "Start"
      and Title != "Program Manager")
   {
      Title := StrSplit(Title,"|")
      ogcDropDownListWindowMove.Add([Title[1]])
      WindowMenu.Insert("", Title[1] . " |" . aOpenWindow[A_Index], "MenuChoice")
      WindowMenu.Icon(Title[1] . " |" . aOpenWindow[A_Index], AppName)
      If ErrorLevel
         WindowMenu.Icon(Title[1] . " |" . aOpenWindow[A_Index], "C:\WINDOWS\System32\SHELL32.dll", "36")
   }
}

ogcDropDownListWindowMove.Choose(1)
Return
} ; V1toV2: Added Bracket before label


MenuChoice:

ProcessID := StrSplit(A_ThisMenuItem,"|")
WinActivate("ahk_id " ProcessID[2])

Return

PosChoice(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := mygui.Submit("0")
hotedit := oSaved.hotedit
WindowMove := oSaved.WindowMove
WinActivate(WindowMove)

; Checks for window location off screen and resets to on screen.
WinGetPos(&X1, &Y1, &W1, &H1, "Program Manager")
WinGetPos(&X2, &Y2, &W2, &H2, WindowMove)
If (X2 > W1 or Y2 > H1)
   WinMove(20, 20, , , WindowMove)
Return
;// End Windows Menu Labels & Functions
;========================================================================================================[ To Do Auxillaries ]

;/ ==== All Labels for ToDo

;// end of all labels for this section

;/ showtodo
ShowTodo:




toggle := !toggle
if (toggle)
{

  oGui2 := Gui()
  oGui2.Show("To Do List")
  LV_ColorInitiate()
  SetColor()
}
else
WinMinimize("To Do List")
;gui, show,,hide
Return ;//

;/ mylistview
todoListView:
;  GUI, +LastFound
  HighlightRow := A_EventInfo
  if (A_GuiEvent = "e")
    UpdateFile()
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "C", true))
        LV_ColorChange(HighlightRow, "0x660000", "0xCC99FF")
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "c", true))
        LV_ColorChange(HighlightRow, "0x000000", "0xFFFFFF")
;  MsgBox, %A_GuiEvent% %ErrorLevel%
Return ;//


;/ guicontextmenu
GuiContextMenu3:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListView")  ; Display the menu only for clicks inside the ListView.
    return
  EditText := ogcListViewName.GetText(A_EventInfo)
; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
MyContextMenu.Show(A_GuiX, A_GuiY)
return ;//

;/ DeleteItem
DeleteItem:  ; The user selected "Clear" in the context menu.
RowNumber := "0"  ; This causes the first iteration to start the search at the top.
Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := ogcListViewName.GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    ogcListViewName.Delete(RowNumber)  ; Clear the row from the ListView.
}
UpdateFile()
SetColor()
return ;//

;/ AddItem
AddItem:
  oSaved := oGui2.Submit("0")

if (SelectedRow = 0)
{
  ogcListViewName.Add("", trim(NewItem))
}
else
{
  ogcListViewName.Modify(SelectedRow, "", Trim(NewItem))
  SelectedRow := 0
  ogcButton1.Value := "Add to list"
}
  UpdateFile()
  ogcListViewName.ModifyCol(1, "AutoHdr")

  SetColor()

Return ;//

;/ EditItem
EditItem:
  SelectedRow := ogcListViewName.GetNext()
  ogcEdit1.Value := EditText
  ogcButton1.Value := "Update"
Return ;//

;/ UpdateFile
UpdateFile:
  DetectHiddenWindows(true)
  UpdateFile()
  ExitApp()
Return ;//

;/ Guisize
} ; V1toV2: Added bracket before function
GuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)  ; Expand or shrink the ListView in response to the user's resizing of the window.
{ ; V1toV2: Added bracket
if (A_EventInfo = 1)  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
ogcMyListView.Move(, , (A_GuiWidth - 20), (A_GuiHeight - 40))
ogcButton1.Move(, (A_GuiHeight - 30))
ogcEdit1.Move(, (A_GuiHeight - 30), (A_GuiWidth - 90))
Return ;//



;/ ==== All functions for this section
} ; V1toV2: Added bracket before function
UpdateFile(){
    FileDelete("ToDoList.txt")
    WinGetPos(&X, &Y, &Width, &Height, "To Do List")
    Width -= 16
    Height -= 38
    FileAppend("x" x " y" y " w" Width " h" Height " `n", "ToDoList.txt")
    Loop ogcListViewName.GetCount()
     {
       oGui2.Opt("+LastFound")
       ErrorLevel := SendMessage(4140, A_Index - 1, 0xF000, "SysListView321")
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
        {
          Text := ogcListViewName.GetText(A_Index)
          FileAppend("*" Text " `n", "ToDoList.txt")
        }
         else
        {
          Text := ogcListViewName.GetText(A_Index)
          FileAppend(Text " `n", "ToDoList.txt")
        }
      }
   }

SetColor() {
  Loop ogcListViewName.GetCount()
  {
       ErrorLevel := SendMessage(4140, A_Index - 1, 0xF000, "SysListView321")
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
         LV_ColorChange(A_Index, "0x660000", "0xCC99FF")
       Else
         LV_ColorChange(A_Index, "0x000000", "0xFFFFFF")

  }
}

; These are the functions that change the row colors.
; I only changed WM_NOTIFY( p_w, p_l, p_m ) for this app

LV_ColorInitiate(Gui_Number:=1, Control:=""){ ; initiate listview color change procedure
  ;global 
  hw_LV_ColorChange
  if (Control = "")
    Control:= "SysListView321"()
  %Gui_Number% := Gui()
  %Gui_Number%.Opt("+Lastfound")
  Gui_ID := WinExist()
  hw_LV_ColorChange := ControlGetHWND(Control, "ahk_id " Gui_ID)
  OnMessage(0x4E, WM_NOTIFY)
}

LV_ColorChange(Index:="", TextColor:="", BackColor:="") { ; change specific line's color or reset all lines
  ;global
  if (Index = "")
    Loop ogcListViewName.GetCount()
      LV_ColorChange(A_Index)
  Else
    {
    Line_Color_%Index%_Text := TextColor
    Line_Color_%Index%_Back := BackColor
   WinRedraw("ahk_id " hw_LV_ColorChange)
    }
}



WM_NOTIFY( p_w, p_l, p_m ){
  local  draw_stage, Current_Line, Index
  if ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) {
      if ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                            ; NM_CUSTOMDRAW
          draw_stage := DecodeInteger( "uint4", p_l, 12 )
          if ( draw_stage = 1 )                                                 ; CDDS_PREPAINT
              return 0x20                                                      ; CDRF_NOTIFYITEMDRAW
          else if ( draw_stage = 0x10000|1 ){                                   ; CDDS_ITEM
              Current_Line := DecodeInteger( "uint4", p_l, 36 )+1
;              LV_GetText(Index, Current_Line, 2)
              If (Line_Color_%Current_Line%_Text != ""){
                  EncodeInteger( Line_Color_%Current_Line%_Text, 4, p_l, 48 )   ; foreground
                  EncodeInteger( Line_Color_%Current_Line%_Back, 4, p_l, 52 )   ; background
                }
            }
        }
    }
}

/*DecodeInteger( p_type, p_address, p_offset, p_hex:=true ){
; REMOVED:   old_FormatInteger := A_FormatInteger
  if (p_hex = "1, SetFormat, Integer, hex")
; REMOVED:   else SetFormat, Integer, dec
  size := SubStr(p_type, -1*(1))
  Loop size
      value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) )
  if ( size <= 4 and InStr(p_type, "u") != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 )
      value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) )
; REMOVED:   SetFormat, Integer, %old_FormatInteger%
  return value
}

EncodeInteger( p_value, p_size, p_address, p_offset )
{
  Loop p_size
    DllCall("RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ))
}
;// end of todo functions
*/
;=========================== Typing
Configuration(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
LaunchSettings()
Return
} ; V1toV2: Added Bracket before label

PauseResumeScript(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
if (g_PauseState == "Paused")
{
   g_PauseState := ""
   Pause(false)
   EnableWinHook()
   tray.Uncheck("Pause")
} else {
   g_PauseState := "Paused"
   DisableWinHook()
   SuspendOn()
   tray.Check("Pause")
   Pause(true)
}
Return
} ; V1toV2: Added Bracket before label

ExitScript(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
ExitApp()
Return
} ; V1toV2: Added bracket before function

SaveScript(A_ExitReason, ExitCode)
; Close the ListBox if it's open
{ ; V1toV2: Added bracket
CloseListBox()

SuspendOn()

;Change the cleanup performance speed
; REMOVED: SetBatchLines, 20ms
ErrorLevel := ProcessSetPriority("Normal")

;Grab the Helper Window Position if open
MaybeSaveHelperWindowPos()

;Write the Helper Window Position to the Preferences File
MaybeWriteHelperWindowPos()

; Update the Learned Words
MaybeUpdateWordlist()

ExitApp()



;===============================================


;/ IniSettingsEditor(ProgName,IniFile,OwnedBy = 0,DisableGui = 0) {

; LINTALIST NOTE: Made minor changes for Lintalist, if you want to use this
; function please use the original one which can be found at the link below.
; http://www.autohotkey.com/forum/viewtopic.php?p=69534#69534
;
;
;
;#############   Edit ini file settings in a GUI   #############################
;  A function that can be used to edit settings in an ini file within it's own
;  GUI. Just plug this function into your script.
;
;  by Rajat, mod by toralf
;  www.autohotkey.com/forum/viewtopic.php?p=69534#69534
;
;   Tested OS: Windows XP Pro SP2
;   AHK_version= 1.0.44.09     ;(http://www.autohotkey.com/download/)
;   Language: English
;   Date: 2006-08-23
;
;   Version: 6
;
; changes since 5:
; - add key type "checkbox" with custom control name
; - added key field options (will only apply in Editor window)
; - whole sections can be set hidden
; - reorganized code in Editor and Creator
; - some fixes and adjustments
; changes since 1.4
; - Creator and Editor GUIs are resizeable (thanks Titan). The shortened Anchor function
;    is added with a long name, to avoid nameing conflicts and avoid dependencies.
; - switched from 1.x version numbers to full integer version numbers
; - requires AHK version 1.0.44.09
; - fixed blinking of description field
; changes since 1.3:
; - added field option "Hidden" (thanks jballi)
; - simplified array naming
; - shorted the code
; changes since 1.2:
; - fixed a bug in the description (thanks jaballi and robiandi)
; changes since 1.1:
; - added statusbar (thanks rajat)
; - fixed a bug in Folder browsing
; changes since 1.0:
; - added default value (thanks rajat)
; - fixed error with DisableGui=1 but OwnedBy=0 (thanks kerry)
; - fixed some typos
;
; format:
; =======
;   IniSettingsEditor(ProgName, IniFile[, OwnedBy = 0, DisableGui = 0])
;
; with
;   ProgName - A string used in the GUI as text to describe the program
;   IniFile - that ini file name (with path if not in script directory)
;   OwnedBy - GUI ID of the calling GUI, will make the settings GUI owned
;   DisableGui - 1=disables calling GUI during editing of settings
;
; example to call in script:
;   IniSettingsEditor("Hello World", "Settings.ini", 0, 0)
;
; Include function with:
;   #Include Func_IniSettingsEditor_v6.ahk
;
; No global variables needed.
;
; features:
; =========
; - the calling script will wait for the function to end, thus till the settings
;     GUI gets closed.
; - Gui ID for the settings GUI is not hard coded, first free ID will be used
; - multiple description lines (comments) for each key and section possible
; - all characters are allowed in section and key names
; - when settings GUI is started first key in first section is pre-selected and
;     first section is expanded
; - tree branches expand when items get selected and collapse when items get
;     unselected
; - key types besides the default "Text" are supported
;    + "File" and "Folder", will have a browse button and its functionality
;    + "Float" and "Integer" with consistency check
;    + "Hotkey" with its own hotkey control
;    + "DateTime" with its own datetime control and custom format, default is
;        "dddd MMMM d, yyyy HH:mm:ss tt"
;    + "DropDown" with its own dropdown control, list of choices has to be given
;        list is pipe "|" separated
;    + "Checkbox" where the name of the checkbox can be customized
; - default value can be specified for each key
; - keys can be set invisible (hidden) in the tree
; - to each key control additional AHK specific options can be assigned
;
; format of ini file:
; ===================
;     (optional) descriptions: to help the script's users to work with the settings
;     add a description line to the ini file following the relevant 'key' or 'section'
;     line, put a semi-colon (starts comment), then the name of the key or section
;     just above it and a space, followed by any descriptive helpful comment you'd
;     like users to see while editing that field.
;
;     e.g.
;     [SomeSection]
;     ;somesection This can describe the section.
;     Somekey=SomeValue
;     ;somekey Now the descriptive comment can explain this item.
;     ;somekey More then one line can be used. As many as you like.
;     ;somekey [Type: key type] [format/list]
;     ;somekey [Default: default key value]
;     ;somekey [Hidden:]
;     ;somekey [Options: AHK options that apply to the control]
;     ;somekey [CheckboxName: Name of the checkbox control]
;
;     (optional) key types: To limit the choice and get correct input a key type can
;     be set or each key. Identical to the description start an extra line put a
;     semi-colon (starts comment), then the name of the key with a space, then the
;     string "Type:" with a space followed by the key type. See the above feature
;     list for available key types. Some key types have custom formats or lists,
;     they are written after the key type with a space in-between.
;
;     (optional) default key value: To allow a easy and quick way back to a
;     default value, you can specify a value as default. If no default is given,
;     users can go back to the initial key value of that editing session.
;     Format: Identical to the description start an extra line, put a semi-colon
;     (starts comment line), then the name of the key with a space, then the
;     string "Default:" with a space followed by the default value.
;
;     (optional) hide key in tree: To hide a key from the user, a key can be set
;     hidden.
;     Format: Identical to the description start an extra line, put a semi-colon
;     (starts comment line), then the name of the key with a space, then the
;     string "Hidden:".
;
;     (optional) add additional AHK options to key controls. To limit the input
;     or enforce a special input into the key controls in the GUI, additional
;     AHK options can be specified for each control.
;     Format: Identical to the description start an extra line, put a semi-colon
;     (starts comment line), then the name of the key with a space, then the
;     string "Options" with a space followed by a list of AHK options for that
;     AHK control (all separated with a space).
;
;     (optional) custom checkbox name: To have a more relavant name then e.g.
;     "status" a custom name for the checkbox key type can be specified.
;     Format: Identical to the description start an extra line, put a semi-colon
;     (starts comment line), then the name of the key with a space, then the
;     string "CheckboxName:" with a space followed by the name of the checkbox.
;
;
; limitations:
; ============
; - ini file has to exist and created manually or with the IniFileCreator script
; - section lines have to start with [ and end with ]. No comments allowed on
;     same line
; - ini file must only contain settings. Scripts can't be used to store setting,
;     since the file is read and interpret as a whole.
; - code: can't use g-labels for tree or edit fields, since the arrays are not
;     visible outside the function, hence inside the g-label subroutines.
; - code: can't make GUI resizable, since this is only possible with hard
;     coded GUI ID, due to %GuiID%GuiSize label
;//
} ; V1toV2: Added bracket before function

/*IniSettingsEditor(ProgName,IniFile,OwnedBy := 0,DisableGui := 0) {
    ;/ start
    static pos

    ;Find a GUI ID that does not exist yet
    Loop 99 {
      %A_Index% := Gui()
      %A_Index%.Opt("+LastFoundExist")
      If not WinExist() {
          SettingsGuiID := A_Index
          break
      }Else If (A_Index = 99){
          MsgBox("Can't open settings dialog,`nsince no GUI ID was available.", "Error in IniSettingsEditor function", 4112)
          Return 0
        }
      }
    %SettingsGuiID% := Gui()
    %SettingsGuiID%.Default()

    ;apply options to settings GUI
    If OwnedBy {
        %SettingsGuiID%.Opt("+ToolWindow +Owner" . OwnedBy)
        If DisableGui
            %OwnedBy% := Gui()
            %OwnedBy%.Opt("+Disabled")
    }Else
        DisableGui := False

    %OwnedBy%.Opt("+Resize +LabelGuiIniSettingsEditor")
    ;create GUI (order of the two edit controls is crucial, since ClassNN is order dependent)
    SB := %OwnedBy%.Add("Statusbar")
    ogcTreeView := %OwnedBy%.Add("TreeView", "x16 y75 w200 h370 0x400")
    %OwnedBy%.Add("Edit", "x225 y114 w400 h20")                           ;ahk_class Edit1
    %OwnedBy%.Add("Edit", "x225 y174 w400 h200 ReadOnly")                 ;ahk_class Edit2
    ogcButtonExit := %OwnedBy%.Add("Button", "x490 y420 w100", "E&xit")
    ogcButtonExit.OnEvent("Click", ExitSettings.Bind("Normal"))     ;ahk_class Button1
    ogcButtonBrowse := %OwnedBy%.Add("Button", "x565 y88   Hidden", "B&rowse")
    ogcButtonBrowse.OnEvent("Click", BtnBrowseKeyValue.Bind("Normal")) ;ahk_class Button2
    ogcButtonRestore := %OwnedBy%.Add("Button", "x225 y420", "&Restore")
    ogcButtonRestore.OnEvent("Click", BtnDefaultValue.Bind("Normal"))        ;ahk_class Button3
    %OwnedBy%.Add("DateTime", "x225 y114 w340 h20 Hidden")                ;ahk_class SysDateTimePick321
    %OwnedBy%.Add("Hotkey", "x225 y114 w340 h20 Hidden")                  ;ahk_class msctls_hotkey321
    %OwnedBy%.Add("DropDownList", "x225 y114 w340 h120 Hidden")           ;ahk_class ComboBox1
    %OwnedBy%.Add("CheckBox", "x225 y114 w340 h20 Hidden")                ;ahk_class Button4
    %OwnedBy%.Add("GroupBox", "x4 y63 w640 h390")                        ;ahk_class Button5
    %OwnedBy%.SetFont("Bold")
    %OwnedBy%.Add("Text", "x225 y93", "Value")                               ;ahk_class Static1
    %OwnedBy%.Add("Text", "x225 y154", "Description")                        ;ahk_class Static2
    %OwnedBy%.Add("Text", "x15 y48 w650 h20 +Center", "(All changes are Auto-Saved - A Reload may be needed for changes to have affect)")
    %OwnedBy%.SetFont("S16 CDefault Bold", "Verdana")
    %OwnedBy%.Add("Text", "x45 y13 w480 h35 +Center", "Settings for " . ProgName)

    ;read data from ini file, build tree and store values and description in arrays
    Loop Read, "IniFile"
      {
        CurrLine := A_LoopReadLine
        CurrLineLength := StrLen(CurrLine)

        ;blank line
        if isSpace(CurrLine)
             Continue

        ;description (comment) line
        If ( InStr(CurrLine, ";") = 1 ){
            chk2 := SubStr(CurrLine, 1, CurrLength + 2)
            Des := SubStr(CurrLine, ((CurrLength + 2)+1)<1 ? ((CurrLength + 2)+1)-1 : ((CurrLength + 2)+1))
            ;description of key
            If ( %CurrID%Sec = False AND ";" CurrKey A_Space = chk2){
                ;handle key types
                If ( InStr(Des, "Type: ") = 1 ){
                    Typ := SubStr(Des, ((6)+1)<1 ? ((6)+1)-1 : ((6)+1))
                    Typ := Typ
                    Des := "`n" . Des     ;add an extra line to the type definition in the description control

                    ;handle format or list
                    If (InStr(Typ, "DropDown ") = 1) {
                        Format := SubStr(Typ, ((9)+1)<1 ? ((9)+1)-1 : ((9)+1))
                        %CurrID%For = %Format%
                        Typ := "DropDown"
                        Des := ""
                    }Else If (InStr(Typ, "DateTime") = 1) {
                        Format := SubStr(Typ, ((9)+1)<1 ? ((9)+1)-1 : ((9)+1))
                        if isSpace(Format)
                            Format := "dddd MMMM d, yyyy HH:mm:ss tt"
                        %CurrID%For = %Format%
                        Typ := "DateTime"
                        Des := ""
                      }
                    ;set type
                    %CurrID%Typ := Typ
                ;remember default value
                }Else If ( InStr(Des, "Default: ") = 1 ){
                    Def := SubStr(Des, ((9)+1)<1 ? ((9)+1)-1 : ((9)+1))
                    %CurrID%Def = %Def%
                ;remember custom options
                }Else If ( InStr(Des, "Options: ") = 1 ){
                    Opt := SubStr(Des, ((9)+1)<1 ? ((9)+1)-1 : ((9)+1))
                    %CurrID%Opt = %Opt%
                    Des := ""
                ;remove hidden keys from tree
                }Else If ( InStr(Des, "Hidden:") = 1 ){
                    ogcTreeView.Delete(CurrID)
                    Des := ""
                    CurrID := ""
                ;handle checkbox name
                }Else If ( InStr(Des, "CheckboxName: ") = 1 ){
                    ChkN := SubStr(Des, ((14)+1)<1 ? ((14)+1)-1 : ((14)+1))
                    %CurrID%ChkN = %ChkN%
                    Des := ""
                  }
                %CurrID%Des := %CurrID%Des "`n" Des
            ;description of section
            } Else If ( %CurrID%Sec = True AND ";" CurrSec A_Space = chk2 ){
                ;remove hidden section from tree
                If ( InStr(Des, "Hidden:") = 1 ){
                    ogcTreeView.Delete(CurrID)
                    Des := ""
                    CurrSecID := ""
                  }
                ;set description
                %CurrID%Des := %CurrID%Des "`n" Des
              }

            ;remove leading and trailing whitespaces and new lines
            If ( InStr(%CurrID%Des, "`n") = 1 )
                %CurrID%Des := SubStr(%CurrID%Des, ((1)+1)<1 ? ((1)+1)-1 : ((1)+1))
            Continue
          }

        ;section line
        If ( InStr(CurrLine, "[") = 1 And InStr(CurrLine, "]", "", -2) = CurrLineLength) {
            ;extract section name
            CurrSec := SubStr(CurrLine, ((1)+1)<1 ? ((1)+1)-1 : ((1)+1))
            CurrSec := SubStr(CurrSec, 1, -1*(1))
            CurrSec := CurrSec
            CurrLength := StrLen(CurrSec)  ;to easily trim name off of following comment lines

            ;add to tree
            CurrSecID := ogcTreeView.Add(CurrSec)
            CurrID := CurrSecID
            %CurrID%Sec := True
            CurrKey := ""
            Continue
          }

        ;key line
        Pos := InStr(CurrLine, "=")
        If ( Pos AND CurrSecID ){
            ;extract key name and its value
            CurrKey := SubStr(CurrLine, 1, Pos - 1)
            CurrVal := SubStr(CurrLine, ((Pos)+1)<1 ? ((Pos)+1)-1 : ((Pos)+1))
            CurrKey := CurrKey             ;remove whitespaces
            CurrVal := CurrVal
            CurrLength := StrLen(CurrKey)

            ;add to tree and store value
            CurrID := ogcTreeView.Add(CurrKey, CurrSecID)
            %CurrID%Val := CurrVal
            %CurrID%Sec := False

            ;store initial value as default for restore function
            ;will be overwritten if default is specified later on comment line
            %CurrID%Def := CurrVal
          }
      }

    ;select first key of first section and expand section
    ogcTreeView.Modify(ogcTreeView.GetChild(ogcTreeView.GetNext()), "Select")

    ;show Gui and get UniqueID
    ogcTreeView.Modify(CurrSecID, "Sort") ; modification lintalist
        %OwnedBy%.Title := ProgName . " Settings"
        %OwnedBy%.Show("w650 h490")
        %OwnedBy%.Opt("+LastFound")
        GuiID := WinExist()

        ;check for changes in GUI
        Loop{
            ;get current tree selection
            CurrID := ogcTreeView.GetSelection()

            If SetDefault {
                %CurrID%Val := %CurrID%Def
                LastID := "0"
                SetDefault := False
                ValChanged := True
              }

            MouseGetPos(, , &AWinID, &ACtrl)
            If ( AWinID = GuiID){
                If ( ACtrl = "Button3")
                    SB.SetText("Restores Value to default (if specified), else restores it to initial value before change")
            } Else
                SB.SetText("")

            ;change GUI content if tree selection changed
            If (CurrID > LastID) {
                ;remove custom options from last control
                Loop Parse, InvertedOptions, "A_Space"
                    

                ;hide/show browse button depending on key type
                Typ := %CurrID%Typ
                if (Typ ~= "^(?i:File|Folder|Exe)$")
                    ogcButton2.Visible := true
                Else
                    ogcButton2.Visible := false

                ;set the needed value control depending on key type
                If (Typ = "DateTime")
                    ControlUsed := "SysDateTimePick321"
                Else If ( Typ = "Hotkey" )
                    ControlUsed := "msctls_hotkey321"
                Else If ( Typ = "DropDown")
                    ControlUsed := "ComboBox1"
                Else If ( Typ = "CheckBox")
                    ControlUsed := "Button4"
                Else                    ;e.g. Text,File,Folder,Float,Integer or No Tyo (e.g. Section)
                    ControlUsed := "Edit1"

                ;hide/show the value controls
                Controls := "SysDateTimePick321,msctls_hotkey321,ComboBox1,Button4,Edit1"
                Loop Parse, Controls, "`",`""
                    If ( ControlUsed = A_LoopField )
                        ogc%A_LoopField%.Visible := true
                    Else
                        ogc%A_LoopField%.Visible := false

                If ( ControlUsed = "Button4" )
                    ogcButton4.Value := %CurrID%ChkN

                ;get current options
                CurrOpt := %CurrID%Opt
                ;apply current custom options to current control and memorize them inverted
                InvertedOptions := ""
                Loop Parse, CurrOpt, "A_Space"
                  {
                    ;get actual option name
                    chk := SubStr(A_LoopField, 1, 1)
                    chk2 := SubStr(A_LoopField, ((1)+1)<1 ? ((1)+1)-1 : ((1)+1))
                    if (chk ~= "^(?i:\+|-)$")
                      {
                        
                        If (chk = "+")
                            InvertedOptions := InvertedOptions . " -" . chk2
                        Else
                            InvertedOptions := InvertedOptions . " +" . chk2
                    }Else {
                        ogc%ControlUsed%.Options("+" A_LoopField)
                        InvertedOptions := InvertedOptions . " -" . A_LoopField
                      }
                  }

                If %CurrID%Sec {                      ;section got selected
                    CurrVal := ""
                    ogcEdit1.Value := ""
                    ogcEdit1.Enabled := false
                    ogcButton3.Enabled := false
                }Else {                               ;new key got selected
                    CurrVal := %CurrID%Val   ;get current value
                    ogcEdit1.Value := CurrVal   ;put current value in all value controls
                    ogcSysDateTimePick321.Text := %CurrID%For
                    ogcSysDateTimePick321.Value := CurrVal
                    ogcmsctls_hotkey321.Value := CurrVal
                    ogcComboBox1.Add([", "`" " . CurrID . "For"])
                    ogcComboBox1.Choose(CurrVal)
                    ogcButton4.Value := CurrVal
                    ogcEdit1.Enabled := true
                    ogcButton3.Enabled := true
                  }
                ogcEdit2.Value := %CurrID%Des
              }
            LastID := CurrID                   ;remember last selection

            ;sleep to reduce CPU load
            Sleep(100)

            ;exit endless loop, when settings GUI closes
            If not WinExist("ahk_id" GuiID)
                Break

            ;if key is selected, get value
            If (%CurrID%Sec = False){
                NewVal := ogc%ControlUsed%.Text
                ;save key value when it has been changed
                If ( NewVal <> CurrVal OR ValChanged ) {
                    ValChanged := False

                    ;consistency check if type is integer or float
                    If (Typ = "Integer")
                      if !isSpace(NewVal)
                        if !isInteger(NewVal)
                          {
                            ogcEdit1.Value := CurrVal
                            Continue
                          }
                    If (Typ = "Float")
                      if !isSpace(NewVal)
                        if !isInteger(NewVal)
                          If (NewVal <> ".")
                            if !isFloat(NewVal)
                              {
                                ogcEdit1.Value := CurrVal
                                Continue
                              }

                    ;set new value and save it to INI
                    %CurrID%Val := NewVal
                    CurrVal := NewVal
                    PrntID := ogcTreeView.GetParent(CurrID)
                    SelSec := ogcTreeView.GetText(PrntID)
                    SelKey := ogcTreeView.GetText(CurrID)
                    If (SelSec AND SelKey)
                        IniWrite(NewVal, IniFile, SelSec, SelKey)
                  }
              }
          }

    ;Exit button got pressed
    ExitSettings(A_GuiEvent, GuiCtrlObj, Info, *)
      ;re-enable calling GUI
{ ; V1toV2: Added bracket
      If DisableGui {
          %OwnedBy%.Opt("-Disabled")
          %OwnedBy%."Show"
        }
      %OwnedBy%.Destroy()
    ;exit function
    Return 1

    ;browse button got pressed
    BtnBrowseKeyValue(A_GuiEvent, GuiCtrlObj, Info, *)
      ;get current value
{ ; V1toV2: Added bracket
      StartVal := ogcEdit1.Text
      %OwnedBy%.Opt("+OwnDialogs")

      ;Select file or folder depending on key type
      If (Typ = "File"){
;          ;get StartFolder
;          IfExist %A_ScriptDir%\%StartVal%
;              StartFolder = %A_ScriptDir%
;          Else IfExist %StartVal%
;              SplitPath, StartVal, , StartFolder
;          Else
;              StartFolder =
;           ;select file LINTALIST "FIX"
               StartFolder:=A_ScriptDir
          oSelected := FileSelect("M", StartFolder "\bundles\", "Select file for " SelSec " - " SelKey, "Any file (*.txt)")
          for FileName in o Selected
          {
          Selected .= A_index=2 ? "`r" : ""
          Selected .= A_index=1 ? FileName : RegExReplace(FileName, "^.*\\([^\\]*)$", "$1") "`r`n"
          }
      }

else      If (Typ = "Exe"){
        StartFolder:=A_ScriptDir
          Selected := FileSelect("", StartFolder "\bundles\", "Select EXE for Snippet Editor", "(*.exe)")
      }

      Else If (Typ = "Folder"){
          ;get StartFolder
          if FileExist(A_ScriptDir "\" StartVal)
              StartFolder := A_ScriptDir . "\" . StartVal
          Else           if FileExist(StartVal)
              StartFolder := StartVal
          Else
              StartFolder := ""

          ;select folder
          Selected := DirSelect("*" StartFolder, 3, "Select folder for " SelSec " - " SelKey)

          ;remove last backslash "\" if any
          LastChar := SubStr(Selected, (-1*(1))<1 ? (-1*(1))-1 : (-1*(1)))
          if (LastChar = "\")
               Selected := SubStr(Selected, 1, -1*(1))
        }
      ;If file or folder got selected, remove A_ScriptDir (since it's redundant) and set it into GUI
      If Selected {
          ; StrReplace() is not case sensitive
          ; check for StringCaseSense in v1 source script
          ; and change the CaseSense param in StrReplace() if necessary
          Selected := StrReplace(Selected, A_ScriptDir "\bundles")
          ; StrReplace() is not case sensitive
          ; check for StringCaseSense in v1 source script
          ; and change the CaseSense param in StrReplace() if necessary
          Selected := StrReplace(Selected, "`n", ",")
          ; StrReplace() is not case sensitive
          ; check for StringCaseSense in v1 source script
          ; and change the CaseSense param in StrReplace() if necessary
          if (not ", All")
            Selected := StrReplace(Selected, "`r")
          else
            Selected := StrReplace(Selected, "`r", , , , &ErrorLevel)
          If (SubStr(Selected, 1, 1) = ",")
            Selected := SubStr(Selected, ((1)+1)<1 ? ((1)+1)-1 : ((1)+1))
          ogcEdit1.Value := Selected
          %CurrID%Val := Selected
        }
    Return  ;end of browse button subroutine

    ;default button got pressed
    BtnDefaultValue(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
      SetDefault := True
    Return  ;end of default button subroutine

    ;gui got resized, adjust control sizes
    GuiIniSettingsEditorSize:
      GuiIniSettingsEditorAnchor("SysTreeView321"      , "wh")
      GuiIniSettingsEditorAnchor("Edit1"               , "x")
      GuiIniSettingsEditorAnchor("Edit2"               , "xh")
      GuiIniSettingsEditorAnchor("Button1"             , "xy",true)
      GuiIniSettingsEditorAnchor("Button2"             , "x",true)
      GuiIniSettingsEditorAnchor("Button3"             , "xy",true)
      GuiIniSettingsEditorAnchor("Button4"             , "x",true)
      GuiIniSettingsEditorAnchor("Button5"             , "wh",true)
      GuiIniSettingsEditorAnchor("SysDateTimePick321"  , "x")
      GuiIniSettingsEditorAnchor("msctls_Hotkey321"    , "x")
      GuiIniSettingsEditorAnchor("ComboBox1"           , "x")
      GuiIniSettingsEditorAnchor("Static1"             , "x")
      GuiIniSettingsEditorAnchor("Static2"             , "x")
      GuiIniSettingsEditorAnchor("Static3"             , "x")
      GuiIniSettingsEditorAnchor("Static4"             , "x")
    Return
}


;==============================[]=================================[]
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
}*/ ; V1toV2: Added bracket before function


GuiIniSettingsEditorAnchor(ctrl, a, draw := false) { ; v3.2 by Titan (shortened)
    static pos
    sig := "`n" . ctrl . "="
    If !InStrm(pos, sig) {
      ogc%ctrl%.GetPos(&pX, &pY, &pW, &pH)
      pos := pos . sig . px - A_GuiWidth . "/" . pw  - A_GuiWidth . "/"        . py - A_GuiHeight . "/" . ph - A_GuiHeight . "/"
    }
    p := SubStr(pos, (InStr(pos, sig) - 1 + StrLen(sig))+1)
    p := StrSplit(p.Length,"/")
    c := "xwyh"
    Loop Parse, c
      If InStr(a, A_LoopField) {
        if (A_Index < 3)
          e := p[A_Index] + A_GuiWidth
        Else e := p[A_Index] + A_GuiHeight
        m := m . "" . A_LoopField . "" . e
      }
    If draw
      d := "Draw"
    
  }




;-----------------------------------------------| classes |-----------------------------------------------;

class ClipboardStore {
   __New() {
      this.OnClipboardChange := new this.OnClipboard()
   }

   __Delete() {
      this.OnClipboardChange.Clear()
   }

   ShowMenu() {
      clipMenu := Menu()
      clipMenu.Show()
   }

   class OnClipboard {
      __New() {
         this.testFnObj := ObjBindMethod(this, "InsertClip")
         this.Clip := ObjBindMethod(this, "SaveClip")
         OnClipboardChange(%this.Clip%)
      }

      SaveClip(type) {
         if (type = 1) {
            testFnObj := this.testFnObj
            clipMenu.Add(A_Clipboard, testFnObj)
         }
      }

      InsertClip() {
         A_Clipboard := A_ThisMenuItem
         Sleep(50)
         Send("^v")
      }

      Clear() {
         OnClipboardChange(%this.Clip%, 0)
      }
   }
}


#Include "lib\Conversions.ah2"
#Include "lib\Helper.ah2"
#Include "lib\ListBox.ah2"
#Include "lib\Preferences File.ah2"
#Include "lib\Sending.ah2"
#Include "lib\Settings.ah2"
#Include "lib\Window.ah2"
#Include "lib\Wordlist.ah2"
#Include "lib\DBA.ah2"
;#Include "lib\_Struct.ah2"


menulooper(PATH){
static urls := { 0: ""        , 1 : "https://www.google.com/search?hl=en&q="        , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="        , 3 : "https://www.google.com/maps/search/"        , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }

    %PATH%.Add("googler", googler) ; Regular search ;googler                                ; Name
    %PATH%.Add("")  ; seperating


    LoopOverFolder(Path)



    ; Add Admin Panel
    Sleep(200)
    %PATH%.Add("")                                                  ; seperating line
    %PATH%"\Admin".Add("&1 Go to Parent Folder", GoToRootFolder)    ; Open script folder
    %PATH%"\Admin".Add("&2 Add Custom Item", GoToCustomFolder)      ; Open custom folder
    %PATH%.Add(ScriptName " vers. " Version, github) ;googler                        ; Name
    %PATH%"\Admin".Add("&0 Restart", ReloadProgram)             ; Add Reload option
    %PATH%"\Admin".Add("&9 Exit", ExitApp)                          ; Add Exit option
    %PATH%.Add("&0 Admin", %PATH%"\Admin")                      ; Adds Admin section

    ; Loadingbar GUI is no longer needed, remove it from memory
    %OwnedBy%.Destroy()
}

folderlooper(PATH){
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
             MsgBox("Pushing to folders`n" A_LoopFilePath)
            FolderArray.Push(A_LoopFilePath)
        }
        ; Current item is a file
        else
        {
             MsgBox("Pushing to files`n" A_LoopFilePath)
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
        folderlooper(element)

        ; Then add it as item to menu
        ;SplitPath, InputVar , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
        ;Menu, MenuName, Cmd [, P3, P4, P5]
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



/* test section
iniFile := SubStr( A_ScriptName, 1, -3 ) . "ini"
iniContent =
(
[pos]
[color=red]x =100[/color]
y=300
Z=450
)
replaceFile(iniFile, iniContent)

ini(test)
msgbox posx := %posx% , posy := %posy% , posz := %posz%
;
; Now we change the variables and write/update the ini
;
posx := posx * 2
posy := posy * 2
posz := posz * 2
ini(test, 1)
Msgbox Updated variables written...
;
; To confirm the INI is correctly updated, we read out the INI again
;
ini(test)
msgbox UPDATED >>> posx := %posx% , posy := %posy% , posz := %posz%


RETURN ; END OF Auto-execution section


replaceFile(File, Content)
{
    FileDelete, %File%
    FileAppend, %Content%, %File%
}
Return
*/
ini2( filename := 0, updatemode := 0 )
;
; updates From/To a whole .ini file
;
; By default the update mode is set to 0 (Read)
; and creates variables like this:
; %Section%%Key% = %value%
;
; You don't have to state the updatemode when reading, just use
;
; update(filename)
;
; The function can be called to write back updated variables to
; the .ini by setting the updatemode to 1, like this:
;
; update(filename, 1)
;
{
Local s, c, p, key, k, write

   if not filename
      filename := SubStr(A_ScriptName, 1, -3) . "ini"

   s := Fileread(filename)

   Loop Parse, s, "`n`r", A_Space "" A_Tab
   {
      c := SubStr(A_LoopField, 1, 1)
      if (c="[")
         key := SubStr(A_LoopField, 2, -1)
      else if (c=";")
         continue
      else {
         p := InStr(A_LoopField, "=")
         if p.Length {
         k := SubStr(A_LoopField, 1, p.Length-1)
       if (updatemode = 0)
          %key%%k% := SubStr(A_LoopField, (p.Length+1)<1 ? (p.Length+1)-1 : (p.Length+1))
       if (updatemode = 1)
       {
          write := %key%%k%
          IniWrite(write, filename, key, k)
       }
         }
      }
   }
}

;#Include "stats.ahk"

run(path)
{

    Run(path)
    return
}

chrome_name(num:=0)
{

    SetKeyDelay(100)
    ;MsgBox, % "1: `n " num++

    if (num = 0)
    {

        ;MsgBox, % "num: `n " num++

        ;MsgBox, % "0: num: " num
        Send("{Alt 2}")
        Send("{space 2}")
        Send("l")
        Send("w")
        Send("dkz" . num)
        Send("{enter}")
        return num
    }
    if (num = 1)
    {
        ;MsgBox, % "0: num is : `n " num++
        ;num++
        Send("{Alt 2}")
        Send("{space 2}")
        Send("l")
        Send("w")
        Send("dkz" . num)
        Send("{enter}")
        MsgBox("1:" sent dkz1)
        return num
    }
    if (num = 2)
    {

        ;MsgBox, % "2: `n num is : " num
        Send("{Alt 2}")
        Send("{space 2}")
        Send("l")
        Send("w")
        Send("dkz" . num)
        Send("{enter}")
        MsgBox("2:" sent dkz2)
        return
    }
    return
}
