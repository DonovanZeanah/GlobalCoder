;Seldom Changing Directives
#Requires AutoHotkey v1.1+ ;.34.03+
#Persistent
#NoEnv
#SingleInstance
#WinActivateForce
#KeyHistory
#installKeybdHook
#InstallMouseHook
setbatchlines,-1
SetTitleMatchMode, 2
DetectHiddenWindows, on
;Sometimes Changing Directives
SetKeyDelay, 50
CoordMode, Caret, Screen
CoordMode, Mouse, Screen
Suspend, On
Gui, Font,Q4, MS Sans Serif ;opts-> (c)olor (s)ize (w)eight (Q)uality
Gui, Font,, Arial
Gui, Font,, Verdana  ; Preferred font.
applicationname := "GlobalCoder"
g_OSVersion := GetOSVersion()
FileEncoding, UTF-8

;[//Includes]==============================[//Includes]=================================[//Includes]

#Include, lib\((functions)).ahk
#Include, lib\Gdipall.ahk
#Include, lib\read-ini.ahk
#Include, lib\JXON.ahk
#Include, lib\Minerva-PowerToys.ahk
#Include, lib\Minerva-Handlers.ahk
#Include, lib\Minerva-Statistics.ahk

					;[GLOBALS]==============================[GLOBALS]=================================[GLOBALS]
global GCshowing := false
global ScriptName  := StrReplace(A_ScriptName, ".ahk")
global Version     := "1.1"
global GitHub      := "https://github.com/donovanzeanah/globalcoder"
global FileCount   := 0
global MyProgress  := 0
global TotalWords  := 0
global settingsINI := "globalcoder.ini"
global ignoreFiles := ""
global frontproject := "d:/(github)\globalcoder\gc\globalcoder" ; super-global ( exist inside and outside of functions/methods ) holds path of last folder selected.
global rootfolder := "d:/(github)\globalcoder\gc\globalcoder"
global projectname := "GlobalCoder"
global items	  := 0
global MyProgress := 0
Global TotalWords := 0
global callingwindow := ""
global rootpath := a_scriptdir
global hotpath := a_scriptdir . "\CustomMenuFiles"
global notepath := a_scriptdir . "\logs\notes"
global timestring := ""
global g_hotpath := a_scriptdir . "\logs\"
global g_Qpath := a_scriptdir . "\logs\questions"
global g_Apath := a_scriptdir . "\logs\questions\answers"
FormatTime, TimeString, 20050423220133,MM d-HHmmss tt
global myGC := new gc()
Menu, Tray, Icon , Shell32.dll, 14 , 1
TrayTip, GlobalCoder, Started %timestring%


;[//NOTES]==============================[//NOTES]=================================[//NOTES]
/*
   

*/
;[//START]==============================[START]=================================[START]
;-------------------------------------------------Start gdi+
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


Menu, MenuName, UseErrorLevel


   ;The following code sets up the Gui with a DropDownList with the original list of
   ;open windows. Remove or comment out this code for Menu only.

Gui,+AlwaysOnTop
Gui, Font, s12, Arial
Gui, Add, DropDownList, w275 vWindowMove gPosChoice Sort Choose1 ; ,Pick a Window||
Menu, FileMenu, Add, &Rescan`tCtrl+R, GuiReset
Menu, MyMenuBar, Add, &File, :FileMenu
Gui, Menu, MyMenuBar



If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
;OnExit, Exit

FindAmountItems()
PrepareMenu(A_ScriptDir "\CustomMenuFiles")
PrepareMenu(A_ScriptDir "\singles")
;RunOtherScripts(A_ScriptDir "\singles")

hwnd1 := WinExist() 						; Get a handle to this window we have created in order to update it later
hbm   := CreateDIBSection(Width, Height) 	; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
hdc   := CreateCompatibleDC() 				; Get a device context compatible with the screen
obm   := SelectObject(hdc, hbm) 			; Select the bitmap into the device context
G     := Gdip_GraphicsFromHDC(hdc) 			; Get a pointer to the graphics of the bitmap, for use with drawing functions
Gdip_SetSmoothingMode(G, 4) 				; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)

pBrush 	:= Gdip_BrushCreateSolid(0x80C7C7C7) ; Create a slightly transparent gray brush to draw rectagle with
Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
pBitmap := Gdip_CreateBitmapFromFile("includes\graphics\globe.png")
Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2, A_ScreenHeight, Width/2, Height/2, 0, 0, Width, Height)


;========= Typing Setup
;disable hotkeys until setup is complete

EvaluateScriptPathAndTitle()
SuspendOn()
Startup()
OnExit, SaveScript ;specifices this sub-routine to be called should/when script exits.
SetBatchLines, 20ms
ReadPreferences() ;read in the preferences file
SetTitleMatchMode, 2 ;set windows constants

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
g_Helper_Id =
g_HelperManual =
g_DelimiterChar := Chr(2)
g_cursor_hand := DllCall( "LoadImage", "Ptr", g_NULL, "Uint", g_IDC_HAND , "Uint", g_IMAGE_CURSOR, "int", g_NULL, "int", g_NULL, "Uint", g_LR_SHARED )
if (A_PtrSize == 8) {
   g_SetClassLongFunction := "SetClassLongPtr"
} else {
   g_SetClassLongFunction := "SetClassLong"
}
g_PID := DllCall("GetCurrentProcessId")
AutoTrim, Off

InitializeListBox()
BlockInput, Send
InitializeHotKeys()
DisableKeyboardHotKeys()


ReadWordList() ;Read in the WordList

g_WinChangedCallback := RegisterCallback("WinChanged")
g_ListBoxScrollCallback := RegisterCallback("ListBoxScroll")

if !(g_WinChangedCallback)
{
   MsgBox, Failed to register callback function
   ExitApp
}

if !(g_ListBoxScrollCallback)
{
   MsgBox, Failed to register ListBox Scroll callback function
   ExitApp
}

;Find the ID of the window we are using
GetIncludedActiveWindow()

MainLoop()

msgbox, % "end"
;OnExit, ExitSub

Return
;END Auto Execute===========================================================================================================================================================================================
;===========================================================================================================================================================================================
;===========================================================================================================================================================================================End Auto Execute

settingsrecent:
vOutput := "", CSIDL_RECENT := 8
VarSetCapacity(vDirRecent, 260*2, 0)
DllCall("shell32\SHGetFolderPath", Ptr,0, Int,8, Ptr,0, UInt,0, Str,vDirRecent)
VarSetCapacity(vOutput, 100000*2)
Loop, Files, % vDirRecent "\*.lnk", F
        {
        vPath := A_LoopFileFullPath
        FileGetShortcut, % vPath, vTarget
        vAttrib := FileExist(vTarget)
        if InStr(vAttrib, "D") || !vAttrib
                continue
        vOutput .= A_LoopFileTimeModified "`t" vTarget "`n"
        }
Sort, vOutput, R
vOutput := RegExReplace(vOutput, "(?<=^|`n)\d{14}`t")
gui, font, s12
gui, margin, 0, 0
gui, -caption
gui, add, listview, w400 r10 -hdr gMyLV, flnm|fllpth
gui, add, button, w0 h0 hidden default, OK
for x,y in strsplit(vOutput,"`n", "`r")
        {
        splitpath,y,z   
        lv_add("",z,y)
        } until (x = 20)                                                                                                                        ; 20 most recent "recents"
LV_ModifyCol(1,380)
LV_ModifyCol(2,0)
gui, show
return

f24 & `::
GlobalMode := !GlobalMode

MsgBox, % "`n GlobalMode Status " globalmode
return

:*:ahk2:: 
clipboard := "autohotkey version 2"
sendclipboard(clipboard)
return

:*:gcd::
routinegcpath(){
send, !d
clipboard := "d:/(github)/globalcoder/gc/globalcoder"
send, ^v
return
}


#IfWinActive ahk_exe explorer.exe
:*:gcd::
routine(){
clipboard := "d:/(github)/globalcoder/gc/globalcoder"
send, !d
send, ^v
return
}
^enter::+f10
#if

#if (globalmode := 1) 
{

^left::
!enter::
selectsubject()
return

^down::
newsubject()
msgbox, % "" frontproject
return

^2::
inputbox, ans
noteex(ans, frontproject)
return

f24 & n::
notein() ;no input - default to frontproj
return

^right::
run(notepath)
return


:*:gtest::
gtest(){

for k,v in g {
MsgBox, % "0: `n " v
}

;InputBox, answer , Is anybody out there?, What is your name?, , , , , , , , Your Name
;MsgBox % "Your name " ((answer < "georgf") ? ("is stupid.") : ( ((answer < "normap") ? ("ROCKsORZ!") : ( ((answer < "tog") ? ("is totally wimpy.") : ("is nothing special."))))))
}
return


backspaceAg(gcomment)
{

    WordLength := strlen(gcomment)
    send, {backspace WordLength}
}


:*:gcomb::
commentblock := " /* `n"
. "`n"
. "*/"
sendclipboard(CommentBlock)
sleep, 500
send, {esc}
send, {up}

return


;g commands send the hotstrings into one function that reroute it based on editor then save
; the 'input' as a g.editer.session object which basically acts as a timeline 
:*:gtodo:: 
:*:g`;::
:*:gcomm::
WinGet,Process,ProcessName,A
Switch Process
{

  Case "sublime_text.exe":
    CommentBlock := " `;*************************************************************************`n"
    . ";Author: Donovan Zeanah `n"
    . ";Purpose: Code Comment `n"
    . ";Comment:`n"
    . "' ***************************************************************************`n"
  Case "devenv.exe":
    CommentBlock := " //# ===========================================================================`n"
    . "//Author: Donovan Zeanah `n"
    . "//Purpose: Code Comment `n"
    . "//Comment:`n"
    . "//# ===========================================================================`n"
    Case "Code.exe":
    CommentBlock := "`;======================================================================`n"
    . "`;Author: Donovan Zeanah `n"
    . "`;Purpose: Code Comment `n"
    . "`;Comment:`n"
    . "`;======================================================================`n"
  Case "scite.exe":
    CommentBlock:=" `;===========================================================================`n"
    . "`;Author: Donovan Zeanah `n"
    . "`;Purpose: Code Comment `n"
    . "`;Comment:`n"
    . "`; ===========================================================================`n"
  Case "ssms.exe":
    CommentBlock:="-- ===========================================================================`n"
    . "`;Author: Donovan Zeanah `n"
    . "`;Purpose: Code Comment `n"
    . "`;Comment:`n"
    . "`; ===========================================================================`n"
  Default:
    MsgBox,4144,Error,Active window is not a supported program
    Return
}


sendclipboard(CommentBlock)
sleep, 500
send, {esc}
send, {up 2}
send, {end}
send, {space}

return

sendclipboard(string := "", bool := "1")
{
        if (bool = 1){
            clipboard := string 
            send, ^v 
            return   
        
;send, ^c 
send, ^v
return 
}
}
}
#if




^+e::
    editor_open_folder() {
        run sublime_text.exe %A_ScriptFullPath% ;"scratch\globalcoderv2.ah2" ;;"%A_ScriptFullPath%" run, d:/
       ;WinGetTitle, path, A
        ;if RegExMatch(path, "\*?\K(.*)\\[^\\]+(?= [-*] )", path)
            ;if (FileExist(path) && A_ThisHotkey = "^+e")
               ; Run explorer.exe /select`,"%path%"
           ; else
               ; Run explorer.exe "%path1%"
               return
    }



f24 & s::
hotpath := "D:\(github)\GlobalCoder\gc\GlobalCoder\CustomMenuFiles\(Dev)\header.txt.txt"
showfile(hotpath)
msgbox, % "hotpath: `n" hotpath
return




rshift & m::

f24 & m::
Gui, mygui:+Resize
Gui, mygui:Add, Edit, w300 r10 vhotedit, Example text
gui, mygui:Add, Button, gGoButton1, Go Button
Gui, mygui:Show ,, Functions instead of labels
return


GoButton1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
static hotpath := { 0 : ""
	, 1 : a_scriptdir . "\notes"
	, 2 : a_scriptdir . "\logs\notes" }
   msgbox, % g_hotpath
	;msgbox, % hotpath.2
	;msgbox, % frontproject
   ;for k, dir in hotpath
      ;msgbox, % "k: " k " dir: " dir
   
	;SelectHotPath(hotpath.2)
   GuiControlGet, hotedit
   clipboard := hotedit
      Gui, mygui:Destroy 

   selectsubject()
   msgbox, % "cont to pass clipboard to notex(): `n" clipboard
   noteex(clipboard, g_hotpath)
   ;mnoteex(clipboard, hotpath.2)
   notein(hotpath.2)
}

f24 & f::
findstring()
return

return
f13 & f::
GetCaret(x,y,,h)
MouseClick, Left, % X, % Y "- 5", 3
send ^c
noteex(clipboard, notepath "functions.txt")
run(notepath "functions.txt")
run, notepath "functions.txt"
return

newsubject(path := ""){
  if (path = "")
  path := frontproject

  ;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
  InputBox, subject ,, "enter a subject"
  frontproject := notepath . "\" . subject ; ".txt"
  if fileexist(frontproject . "\notes.txt"){
  MsgBox, already exists.
  return frontproject
   }

  filecreatedir, % frontproject
  ;fileappend,"init", % frontproject "\note.txt"
  return frontproject
 } ; should add new folder and set to frontproj



selectsubject(path := ""){

  if (!path)
  {
   g_hotpath := ""
      path := notepath
  }
  Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListView3, Name
  Loop, % path . "\* " , 2 ; 2 = folders only
  LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
  LV_ModifyCol()  ; Auto-size each column to fit its contents.
  LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
  FolderList .= A_LoopFileName . "`n"

Gui, Show

  while (g_hotpath = "")
  {
  
  MyListView3:
    if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
    {
      LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
      LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.

            frontproject := notepath . "\" . filename
            msgbox, % frontproject

    GuiControl,, Folder, %frontproject%
        g_hotpath := frontproject
      break
    }
    }
    
    gui, destroy
    g_hotpath := frontproject
    MsgBox, % "path: `n" g_hotpath
 return g_hotpath   
    }



;path is frontproject
;note external
noteex(data,hotpath){
count := 0 ;tracks files having same name and incrimenting them if so using count var.

frontproject := hotpath

 inputbox, fname	, "Enter filename w/ Extension:"
  if (fileexist(file := hotpath . "\" fname ))
	  {
		  while ( FileExist(file))
			  {
			  	file := hotpath . "\" . ++count fname ;g. ".txt"
			  }
	  }
   frontproject := file
   ;msgbox, % "data: `n" data m
   MsgBox, % "appending file: `n" data . "`n to: `n " . frontproject ;"\notes.txt"
   ;MsgBox, % "appending file: `n" file . "`n to: `n " . frontproject "\notes.txt"
   fileappend, % "-" timestring "`:" "`n" . data . ";"    , % frontproject ;"\notes.txt"
   runfp()
   ;run, % frontproject
;fileappend, `n %clipboard% , % file
  return
}

;path is predeterined and inputted
;newnote gets input inside the func
notein(path := ""){
  if (path = "")
  path := frontproject

    InputBox, fname, filename w/ ext. :, "enter a filename"

  if (fileexist(file := path . "\" fname ))
	  {
		  while ( FileExist(file))
			  {
			  	file := hotpath . "\" . ++count fname ;g. ".txt"
			  }
	  }

  ;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
  fileappend, %  note . " - " . timestring "`n"  , % frontproject "\notes.txt"
  return
}

hotpath(folder:="") {
	if (folder = "")
  folder := frontproject

    Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListView AltSubmit, Name
        Loop, Files, % folder "\*", D
        {
            LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
            LV_ModifyCol()  ; Auto-size each column to fit its contents.
            LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
            FolderList .= A_LoopFileName . "`n"
        }
    Gui, Show
    return

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListView")  ; This check is optional. It displays the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

MyListView:
if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
{
    LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
    LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.

    Run %Dir%\%FileName%,, UseErrorLevel
    hotpath := dir
    msgbox, % hotpath
    ;Run %FileDir%\%FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox Could not open "%FileDir%\%FileName%".
}
return hotpath


}
SelectHotPath(path := "")
{
  if (path = "")
  {
  path := a_scriptdir . "/notes/"
  return
  }
  Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gHotFileView, Name
  Loop, % path . "/"* , 2 ; 2 = folders only
  LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
  LV_ModifyCol()  ; Auto-size each column to fit its contents.
  LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
  FolderList .= A_LoopFileName . "`n"
   Gui, Show


  HotFileView:
   if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
   {
      LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
      LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
    hotpath := hotpath . "/" . filename
    GuiControl,, Folder, %hotpath%
    msgbox, % hotpath
    gui, destroy

   }
return

}

runfp2(path := ""){
  run, %frontproject%
}
chrome_name2(){
    SetKeyDelay 100
send,{f10}

send,{space 2}
send, l
send, w
send, dkz
send,{enter}
return
}

chrome_group2(){
;WinActivate, dkz
WinWaitActive, dkz

send, !g
return
}

f13::send, ^{click}

xbutton2 & 3::
 SendMode Input
 SendRaw, `;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
 SendRaw, `;~   ~
 SendRaw, `;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
 send,{home}
 send, {up}
 send, {right 2}
return

xbutton2 & b::
 SendMode Input
 SendRaw, `;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
return

xbutton1 & b::
    SendMode Input

    Send, `;[]==============================[]=================================[]
return

f13 & b::
send, `//================
clipboard := "`;================"
return

xbutton2 & n::
f24 & g::

chrome_name()

:*:pyear::&as_qdr=y1

return
f24 & Space:: ;------------------------------------------------------------------

query := "&as_qdr=y1"
InputBox, ans
Run, www.google.com/search?q=%ans%%query%  
crm := chrome_group()
WinWait, dkz, dkz, 3,  
send, !g

run %frontdir%
run, %file%
return


f24 & 2::
;run sublime_text.exe "0_globalcoder.ahk" ;;"%A_ScriptFullPath%" run, d:/
run sublime_text.exe "scratch\globalcoderv2.ah2" ;;"%A_ScriptFullPath%" run, d:/
;run, "C:\Program Files\AutoHotkey\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoder.ahk" ;/ErrorStdOut %programfiles%\autohotkey\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
;run, "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoderv2.ah2" ;/ErrorStdOut %programfiles%\autohotkey\v2\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
return




;=========================================================================================================

; main Call window R^Rshift ( f24 & rshift )
; code stats - overview of current session classes/vars/methods/etc
; Tool window -> immenates from botton right corner
;------------------------------------------------| MENU |------------------------------------------------#

;/ premaremenu(path) ; a main function for creating menu system using folder paths
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
		Gui, new, +ToolWindow, % ScriptName " is Loading"		; Adding title to progressbar
		Gui, add, Progress, w200 vMyProgress range1-%items%, 0	; Adding progressbar
		Gui, show	  											; Displaying Progressbar

		; Add Name, Icon and seperating line
		Menu, %PATH%, Add, % "g&oogler", googler ; Regular search ;googler								; Name

		Menu, %PATH%, Add, 																			; seperating

		; Add all custom items using algorithm
		LoopOverFolder(Path)
	   ;loopoverfolder(singles)

	                                                       ; seperating


		; Add Admin Panel
		Sleep, 200
		Menu, %PATH%, Add,
        menu, %path%"\new", Add, &n test, ReloadProgram 													; seperating line
		Menu, %PATH%"\Admin", Add, &3 Restart, ReloadProgram				; Add Reload option
		Menu, %PATH%"\Admin", Add, &2 Exit, ExitApp							; Add Exit option
		Menu, %PATH%"\Admin", Add, &1 Go to Parent Folder, GoToRootFolder	; Open script folder
		Menu, %PATH%"\Admin", Add, &4 Add Custom Item, GoToCustomFolder		; Open custom folder
		
        ;bottom sec
        Menu, %PATH%, Add, &1 Admin, :%PATH%"\Admin"						; Adds Admin section
        Menu, %PATH%, Add, &2 New, :%PATH%"\New" 
        Menu, %PATH%, Add,   ; seperater
        Menu, %PATH%, Add, % "&" ScriptName " vers. " Version, github ;googler                        ; Name
        Menu, %PATH%, Add,                           ; Adds Admin section

		; Loadingbar GUI is no longer needed, remove it from memory
		Gui, Destroy
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
	Loop, Files, %PATH%\* , DF
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
	Sort, FolderArray
	Sort, FileArray

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
		SplitPath, element, name, dir, ext, name_no_ext, drive
		Menu, %dir%, Add, &%name%, :%element%
        ;Menu, MenuName, Cmd [, P3, P4, P5]

		; Iterate loading GUI progress
		FoundItem("Folder")
	}

	; Then add all files to folders
	for index, element in FileArray
	{
		; Add To Menu
		SplitPath, element, name, dir, ext, name_no_ext, drive
		Menu, %dir%, Add, %name%, MenuEventHandler

		; Iterate GUI loading
		FoundItem("File")
	}
}

; Hotkey x

;// end hotkey x


;trippleclick@caret

;----------------------------------------------------------------------------------------| HOTKEYS |----------------------------------------------;



~LButton::
CheckForCaretMove("LButton","UpdatePosition")
return

; rbutton - del?
~RButton::
;/
CheckForCaretMove("RButton","UpdatePosition")
Return ;//


; Hotkey x
f24 & x::
;/ code

return ;// end hotkey x


;/ [ WindowsMenu ] - Ctrl + WIN L,M === Ctrl + Alt + W
;//

; MAIN MENU & the Children MENUs
;-------------------------

; main menu

^f24::
f24 & Rshift::
Ctrl & RShift::
;/

callingwindow := winactive("A")
CoordMode Menu, Screen
GetCaret(X, Y,, H)
;Menu, MyMenu, Show, % X, % Y + H
Menu, %A_ScriptDir%\CustomMenuFiles, show , % X, % Y + H
return
;// endregion

f24 & f1::
f24 & 1::
CoordMode Menu, Screen
GetCaret(X, Y,, H)
;Menu, MyMenu, Show, % X, % Y + H
Menu, %A_ScriptDir%\singles, show , % X, % Y + H
return

;--------------------------- END Main Menu Family

; quick menu / google, etc...
f24 & ralt::
;/
CoordMode Menu, Screen
GetCaret(X, Y,, H)
Menu, MyMenu, Add, Menu Item 1(googler), GoMenuHandler1
Menu, MyMenu, Add, Menu Item 2, GoMenuHandler1
Menu, MyMenu, Add, Menu Item 3, GoMenuHandler1
Menu, MyMenu, Show, % X, % Y + H
;gui, menu, mymenu
return
;//
ShowCapMenu:
    GCshowing := true
    Menu, test, Show

return
CapsLockMenu(){
    Menu, MyMenu, Add, Menu Item 1(googler), GoMenuHandler1
    Menu, MyMenu, Add, Menu Item 2, GoMenuHandler1
    Menu, MyMenu, Add, Menu Item 3, GoMenuHandler1
    Menu, MyMenu, Show, % X, % Y + H
    Menu, test, Add, 1
    Menu, test, Add, 2
    Menu, test, Add, 3
    GoSub ShowCapMenu
    return
}
xbutton2 & f::
gcshowing := false
return

Capfunction(){
    static myedit

    MsgBox, % "Capfunction"
    Gui, add, edit, vmyedit w200 h50,
    Gui, add, button, gcapbutton w200 h50,
    gui,show
    KeyWait, q
    ;KeyWait, esc
    ;gui Submit
    ;msgbox, % myedit
    ;Send % item := A_ThisLabel 
    return myedit
}


capbutton:
    GuiControl, ,myedit
    msgbox, % myedit 
    gui submit
    msgbox, % myedit 
return

$CapsLock::
    KeyWait CapsLock, T0.25
        if ErrorLevel
        {
            callingwindow := winactive("A")
            CoordMode Menu, Screen
            GetCaret(X, Y,, H)
            CapsLockMenu()
        }
        else
        {
            KeyWait CapsLock, D T0.25
            if ErrorLevel
            {
                MsgBox, % "damn"
            }
            else
            {
                MsgBox, % "dang"
            }
        }
    KeyWait CapsLock

return


#If, GCshowing := true
;j::down 
return
#if

;------ clipboard menu
f24 & c:: clipStore.ShowMenu()
;ahk_class #32768 is uniform class for menu 'windows'
; 2nd solution is binding left arrow to esc when menu is shown


; Reload
f24 & enter::
;/
	Reload
return
;//

; exit
f24 & esc::
;/
goto exit
ExitApp
;//


goMenuHandler1:
GetCaret(X, Y,, H)
;InputBox, test
;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
InputBox, omniinput, ,g - google `n f - search files? `n c - search currentdoc? `n m - main proj folder?, , , , % x, % y ,Consolas, 10000, g%a_space% ;
StringLeft, checkvar, omniINPUT, 1
msgbox, % omniinput
StringTrimleft, omniinput, omniinput,1
msgboX, % checkvar "-" omniinput
clipboard := omniinput
switch checkvar
{
   case "g":
   clipboard := omniinput
   runstring("www.google.com/search?q=" . clipboard)
   WinWaitActive, ahk_exe chrome.exe
   send, !g
   return
   case "f":
   msgbox, % "return"
   return
   case "c":
   msgbox, % "return"
   return
   case "m":
   msgbox, % "return"
   return
   ;filesearch(frontfolder)
}
return
;// omnibox 3-selection menu w/ 4 direction switch

f16::f7
#numpad1::
msgbox test
return


;hotkey to add reference notes via edit
; -- under construction


rctrl::f24
; -------------------------------------------------------------------------------------------------- under construction
f24 & 3::
;/
BoundGivePar := Func("GivePar").Bind("First", "Test one")
BoundGivePar2 := Func("GivePar").Bind("Second", "Test two")

; Create the menu and show it:
Menu MyMenu, Add, Menu Name 1, % BoundGivePar
Menu MyMenu, Add, Menu Name 2, % BoundGivePar2
Menu MyMenu, Show


; Definition of custom function GivePar:
GivePar(a, b, ItemName, ItemPos, MenuName){
    MsgBox % "a:`t`t" a "`n"
           . "b:`t`t" b "`n"
           . "ItemName:`t" ItemName "`n"
           . "ItemPos:`t`t" ItemPos "`n"
           . "MenuName:`t" MenuName
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
CheckWord(A_ThisHotkey)
Return

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
EvaluateUpDown(A_ThisHotKey)
Return

$^+h::
MaybeOpenOrCloseHelperWindowManual()
Return

$^+c::
AddSelectedWordToList()
Return

$^+Delete::
DeleteSelectedWordFromList()
Return

^!+y::
alterclipboard(clipboard, ";" ,"{")
return
;----------------------------------------------| quickmenu FUNCTIONS |---------------------------------------------;

CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField1
    MsgBox, Go has been clicked! The content of the edit field is "%EditField%"!
}

GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
return

;----------------------------------------------| FUNCTIONS |---------------------------------------------;

MainLoop(){
   global g_TerminatingEndKeys
   Loop
   {

      ;If the active window has changed, wait for a new one
      IF !( ReturnWinActive() )
      {
         Critical, Off
         GetIncludedActiveWindow()
      } else {
         Critical, Off
      }


   ;===== can insert a condition here to block the usual terminiating keys/ temporarily remove space for end keys

   ;===== also, can direct the input chars to go to a second ( pre-function ) in combination with the normal processkey()
      ;Get one key at a time
      Input, InputChar, L1 V I, {BS}%g_TerminatingEndKeys%

      Critical
      EndKey := ErrorLevel

      ProcessKey(InputChar,EndKey)
   }

}


ProcessKey(InputChar,EndKey){
   global g_Active_Id
   global g_Helper_Id
   global g_IgnoreSend
   global g_LastInput_Id
   global g_OldCaretX
   global g_OldCaretY
   global g_TerminatingCharactersParsed
   global g_Word
   global prefs_DetectMouseClickMove
   global prefs_EndWordCharacters
   global prefs_ForceNewWordCharacters
   global prefs_Length

   IfEqual, g_IgnoreSend, 1
   {
      g_IgnoreSend =
      Return
   }

   IfEqual, EndKey,
   {
      EndKey = Max
   }

   IfEqual, EndKey, NewInput
      Return

   IfEqual, EndKey, Endkey:Tab
      If ( GetKeyState("Alt") =1 || GetKeyState("LWin") =1 || GetKeyState("RWin") =1 )
         Return

   ;If we have no window activated for typing, we don't want to do anything with the typed character
   IfEqual, g_Active_Id,
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

   IfEqual, g_Active_Id, %g_Helper_Id%
   {
      Return
   }

   ;If we haven't typed anywhere, set this as the last window typed in
   IfEqual, g_LastInput_Id,
      g_LastInput_Id = %g_Active_Id%

   IfNotEqual, prefs_DetectMouseClickMove, On
   {
      ifequal, g_OldCaretY,
         g_OldCaretY := HCaretY()

      if ( g_OldCaretY != HCaretY() )
      {
         ;Don't do anything if we aren't in the original window and aren't starting a new word
         IfNotEqual, g_LastInput_Id, %g_Active_Id%
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
   ifequal, EndKey, Endkey:BackSpace
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      IfNotEqual, g_LastInput_Id, %g_Active_Id%
         Return

      StringLen, len, g_Word
      IfEqual, len, 1
      {
         ClearAllVars(true)
      } else IfNotEqual, len, 0
      {
         StringTrimRight, g_Word, g_Word, 1
      }
   } else if ( ( EndKey == "Max" ) && !(InStr(g_TerminatingCharactersParsed, InputChar)) )
   {
      ; If active window has different window ID from the last input,
      ;learn and blank word, then assign number pressed to the word
      IfNotEqual, g_LastInput_Id, %g_Active_Id%
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
         g_LastInput_Id := g_Active_Id
         Return
      }

      if InputChar in %prefs_ForceNewWordCharacters%
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
      } else if InputChar in %prefs_EndWordCharacters%
      {
         g_Word .= InputChar
         AddWordToList(g_Word, 1)
         ClearAllVars(true)
      } else {
         g_Word .= InputChar
      }

   } else IfNotEqual, g_LastInput_Id, %g_Active_Id%
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
   SetTimer, RecomputeMatchesTimer, -1
}

RecomputeMatchesTimer:
   Thread, NoTimers
   RecomputeMatches()
   Return

RecomputeMatches(){
   ; This function will take the given word, and will recompile the list of matches and redisplay the wordlist.
   global g_MatchTotal
   global g_SingleMatch
   global g_SingleMatchDescription
   global g_SingleMatchReplacement
   global g_Word
   global g_WordListDB
   global prefs_ArrowKeyMethod
   global prefs_LearnMode
   global prefs_ListBoxRows
   global prefs_NoBackSpace
   global prefs_ShowLearnedFirst
   global prefs_SuppressMatchingWord

   SavePriorMatchPosition()

   ;Match part-word with command
   g_MatchTotal = 0

   IfEqual, prefs_ArrowKeyMethod, Off
   {
      IfLess, prefs_ListBoxRows, 10
         LimitTotalMatches := prefs_ListBoxRows
      else LimitTotalMatches = 10
   } else {
      LimitTotalMatches = 200
   }

   StringUpper, WordMatchOriginal, g_Word

   WordMatch := StrUnmark(WordMatchOriginal)

   StringUpper, WordMatch, WordMatch

   ; if a user typed an accented character, we should exact match on that accented character
   if (WordMatch != WordMatchOriginal) {
      WordAccentQuery =
      LoopCount := StrLen(g_Word)
      Loop, %LoopCount%
      {
         Position := A_Index
         SubChar := SubStr(g_Word, Position, 1)
         SubCharNormalized := StrUnmark(SubChar)
         if !(SubCharNormalized == SubChar) {
            StringUpper, SubCharUpper, SubChar
            StringLower, SubCharLower, SubChar
            StringReplace, SubCharUpperEscaped, SubCharUpper, ', '', All
            StringReplace, SubCharLowerEscaped, SubCharLower, ', '', All
            PrefixChars =
            Loop, % Position - 1
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
      WordAccentQuery =
   }

   StringReplace, WordExactEscaped, g_Word, ', '', All
   StringReplace, WordMatchEscaped, WordMatch, ', '', All

   IfEqual, prefs_SuppressMatchingWord, On
   {
      IfEqual, prefs_NoBackSpace, Off
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

   IfEqual, Normalize,
   {
      Normalize := 0
   }

   WordLen := StrLen(g_Word)
   OrderByQuery := " ORDER BY CASE WHEN count IS NULL then "
   IfEqual, prefs_ShowLearnedFirst, On
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
   IfEqual, g_MatchTotal, 0
   {
      ClearAllVars(false)
      Return
   }

   SetupMatchPosition()
   RebuildMatchList()
   ShowListBox()
}

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
        return
    }
}

showfile(fileFullPath){

    static MyEdit
    Gui, Add, Edit, R20 vMyEdit
    FileRead, FileContents, % fillFullPath
    Gui, show 
    GuiControl,, MyEdit, %FileContents%
}

;==============================[]=================================[]
global GC_Subjects := {}
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

	FileRead, Clipboard, %PATH%

	; Gets amount of words (spaces) in file just pasted
	GetWordCount()
	Sleep, 50

	; Adds Info to file
	AddAmountFile(A_ThisMenuItem, TotalWords)
	Sleep, 50

	; Paste content of clipboard
	Send, ^v
}
Handler_note(PATH){
	;put all into clipboard
	FileRead, Clipboard, %PATH%

	;all into variable 'readfile'
	FileRead, readfile, %PATH%
	fulldata := clipboard
	;split file by each line in file '`n' and report the first
	;StrSplit(String, [Delimiters, OmitChars])
	readfile := strsplit(readfile, "`n", "`r")

msgbox, % "0: "  readfile.MaxIndex()


	report := readfile[1]

	;pass the 'report' into a validator, or -director- I should say.
	determine(report, fulldata)

	;if the file contains a known keyboard (heading), add it to a collection of files that contain the same headings
	for k,v in gc_subjects.data
		msgbox, % k "- " v

	; Gets amount of words (spaces) in file just pasted
	GetWordCount()
	Sleep, 50
	; Adds Info to file
	AddAmountFile(A_ThisMenuItem, TotalWords)
	Sleep, 50

	; Paste content of clipboard
	Send, ^v
}
; If program is executable, simply launch it
Handler_LaunchProgram(FilePath){
	run, %FilePath%
}
; .rtf files should be opened with a ComObject, that silently opens the file and copies the formatted text. Then paste
Handler_RTF(FilePath){
	; Clears clipboard. Syntax looks werid, but it is right.
	Clipboard =
	Sleep, 200

	; Load contents of file into memory
	oDoc := ComObjGet(FilePath)
	Sleep, 250

	; Copy contents of file into clipboard
	oDoc.Range.FormattedText.Copy
	Sleep, 250

	; Wait up to two seconds for content to appear on the clipboard
	ClipWait, 2
	if ErrorLevel
	{
		MsgBox, The attempt to copy text onto the clipboard failed.
		return
	}

	; File is no longer needed, close it
	oDoc.Close(0)
	Sleep, 250

	; Gets amount of words (spaces) in file just pasted
	GetWordCount()
	Sleep, 50

	; Add amount words to the AmountFile
	AddAmountFile(A_ThisMenuItem, TotalWords)
	Sleep, 50

	; Then Paste
	Send, ^v
	Sleep, 50
}
;todo
Handler_Settings(filepath){

	return
}
Handler_hotstrings(filepath){
;put all into clipboard
	FileRead, Clipboard, %PATH%

	fulldata := clipboard
	;all into variable 'readfile'
	FileRead, readfile, %PATH%

	;split file by each line in file '`n' and report the first
	;StrSplit(String, [Delimiters, OmitChars])
	readfile := strsplit(readfile, "`n", "`r")

	msgbox, % "0: "  readfile.MaxIndex()


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


	MsgBox, % "CONTENT IS: " content "`n full data: " fulldata

		for k,v in GC_Subjects.list
		{
			;InStr(Haystack, Needle [, CaseSensitive?, StartingPos])
			if (InStr( content,v))
			{
				MsgBox, % content " - does contains - " v

				;gc_subjects.data := {v : "%fulldata%"}
				gc_subjects.data := {1 : fulldata}

				MsgBox, % "gc_subjects.data" gc_subjects.data
				for k,v in gc_subjects.data
				msgbox, % "gc_subjects.data : " k "-" v
			}
			else
			{
				MsgBox, % content " - doesnt contains - " v
				;return false
			}
		}

			for k,v in GC_Subjects.data
				msgbox, % V "-" K
			for k,v in GC_Subjects.path
							msgbox, % V "-" K

		msgbox, gc_subjects.data
return gc_subjects.data
		}




director(report, path, rec = 1, case = 0){
    len := strlen(report)
    if (len = 0)
        return
}
/*

*/

; ---- Other Functions ----
; Amountfile is a .csv that the user can use to see how much info was saved.
AddAmountFile(FileName, WordCount){
	; Average Typing speed is 40 wpm pr. https://www.typingpal.com/en/typing-test
	MinutesSaved := WordCount / 40

	; It will look like 28-12-2021 13:23
	FormatTime, CurrentDateTime,, dd-MM-yyyy HH:mm

	; Check if file already exists. All other times than the very first run, it will exist.
	; If if not, create it and append, otherwise just append
	if FileExist("logs/AmountUsed.csv")
	{
		FileAppend, %CurrentDateTime%`,%FileName%`,%WordCount%`,%MinutesSaved%`n, %A_ScriptDir%\AmountUsed.csv
	}
	else
	{
		FileAppend, Date`,Text`,Word Count`,Minutes Saved`n, %A_ScriptDir%\AmountUsed.csv
		FileAppend, %CurrentDateTime%`,%FileName%`,%WordCount%`,%MinutesSaved%`n, %A_ScriptDir%\AmountUsed.csv
	}
}

; Gets the amount of words on the clipboard
GetWordCount(){
	Global TotalWords := 0
	Loop, parse, clipboard, %A_Space%,
	{
		TotalWords = %A_Index%
	}
}

; Recursively
FindAmountItems(){
	Loop, Files, %A_ScriptDir%\*, FR
	{
		global items := items+ 1
	}
}

; Iterate step of the GUI process bar by one
FoundItem(WhatWasFound){
	global
	GuiControl,, MyProgress, +1

	; Comment in for Debug
	;~ Sleep, 50
	;~ MsgBox, % "Found " WhatWasFound ": " A_LoopFileName "`n`nWith Path:`n" A_LoopFileFullPath "`n`nIn Folder`n" A_LoopFileDir
}

; Restarts the program. This is handy for updates in the code
ReloadProgram(){
    MsgBox, 64, About to restart %ScriptName%, Restarting %ScriptName%
    Reload
}

; Exits the program
ExitApp()
{
    MsgBox, 48, About to exit %ScriptName%, %ScriptName% will TERMINATE when you click OK
    IfMsgBox OK
    ExitApp
}

; Opens explorer window in root folder of script
GoToRootFolder(){
    run, explore %A_ScriptDir%
}

; Opens explorer window in folder where custom folders and menu item goes
GoToCustomFolder(){
	run, explore %A_ScriptDir%\CustomMenuFiles
}

; Launch Github repo
Github(){
	run, https://github.com/donovanzeanah/globalcoder
}
googler(){
	static urls := { 0: ""
	    , 1 : "https://www.google.com/search?hl=en&q="
	    , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
	    , 3 : "https://www.google.com/maps/search/"
	    , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
	    msgbox, % urls.1

   WinActivate, % callingwindow
   send, ^c
   if (clipboard = "")
		{
		   inputbox, googlequery
		   clipboard := googlequery
		}
	runstring("www.google.com/search?q=" . clipboard)
   ;Run, www.google.com/search?q=%clipboard%
   WinWaitActive, ahk_exe chrome.exe
   send, !g
   clipboard := ""
}
google(service := 1){
   if clipboard := ""
   {
      return
   }
    static urls := { 0: ""
        , 1 : "https://www.google.com/search?hl=en&q="
        , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
        , 3 : "https://www.google.com/maps/search/"
        , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }

    backup := ClipboardAll
    Clipboard := ""
    Send ^c
    ClipWait 0
    if ErrorLevel
        InputBox query, Google Search,,, 200, 100
    else
    query := Clipboard
    Run % urls[service] query
    Clipboard := backup
}

; Attemps to start all other files in the specified path.
RunOtherScripts(PATH){
	Loop, Files, %PATH%\*.ahk , F
	{
		;~ MsgBox, % "Including:`n" A_LoopFilePath
		run, % A_LoopFilePath
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
run, % string_path
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
   msgbox, % v
}
GetCaret(ByRef X:="", ByRef Y:="", ByRef W:="", ByRef H:="") {

    ; UIA caret
    static IUIA := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
    ; GetFocusedElement
    DllCall(NumGet(NumGet(IUIA+0)+8*A_PtrSize), "ptr", IUIA, "ptr*", FocusedEl:=0)
    ; GetCurrentPattern. TextPatternElement2 = 10024
    DllCall(NumGet(NumGet(FocusedEl+0)+16*A_PtrSize), "ptr", FocusedEl, "int", 10024, "ptr*", patternObject:=0), ObjRelease(FocusedEl)
    if patternObject {
        ; GetCaretRange
        DllCall(NumGet(NumGet(patternObject+0)+10*A_PtrSize), "ptr", patternObject, "int*", IsActive:=1, "ptr*", caretRange:=0), ObjRelease(patternObject)
        ; GetBoundingRectangles
        DllCall(NumGet(NumGet(caretRange+0)+10*A_PtrSize), "ptr", caretRange, "ptr*", boundingRects:=0), ObjRelease(caretRange)
        ; VT_ARRAY = 0x20000 | VT_R8 = 5 (64-bit floating-point number)
        Rect := ComObject(0x2005, boundingRects)
        if (Rect.MaxIndex() = 3) {
            X:=Round(Rect[0]), Y:=Round(Rect[1]), W:=Round(Rect[2]), H:=Round(Rect[3])
            return
        }
    }

    ; Acc caret
    static _ := DllCall("LoadLibrary", "Str","oleacc", "Ptr")
    idObject := 0xFFFFFFF8 ; OBJID_CARET
    if DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", WinExist("A"), "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc:=0)=0 {
        oAcc := ComObjEnwrap(9,pacc,1)
        oAcc.accLocation(ComObj(0x4003,&_x:=0), ComObj(0x4003,&_y:=0), ComObj(0x4003,&_w:=0), ComObj(0x4003,&_h:=0), 0)
        X:=NumGet(_x,0,"int"), Y:=NumGet(_y,0,"int"), W:=NumGet(_w,0,"int"), H:=NumGet(_h,0,"int")
        if (X | Y) != 0
            return
    }

    ; default caret
    CoordMode Caret, Screen
    X := A_CaretX
    Y := A_CaretY
    W := 4
    H := 20
}
CheckForCaretMove(MouseButtonClick, UpdatePosition = false){
   ;/
   global g_LastInput_Id
   global g_MouseWin_Id
   global g_OldCaretX
   global g_OldCaretY
   global g_Word
   global prefs_DetectMouseClickMove

   ;If we aren't using the DetectMouseClickMoveScheme, skip out
   IfNotEqual, prefs_DetectMouseClickMove, On
      Return

   if (UpdatePosition)
   {
      ; Update last click position in case Caret is not detectable
      ;  and update the Last Window Clicked in
      MouseGetPos, MouseX, MouseY, g_MouseWin_Id
      WinGetPos, ,TempY, , , ahk_id %g_MouseWin_Id%
   }

   IfEqual, MouseButtonClick, LButton
   {
      KeyWait, LButton, U
   } else KeyWait, RButton, U

   IfNotEqual, g_LastInput_Id, %g_MouseWin_Id%
   {
      Return
   }

   SysGet, SM_CYCAPTION, 4
   SysGet, SM_CYSIZEFRAME, 33

   TempY += SM_CYSIZEFRAME
   IF ( ( MouseY >= TempY ) && (MouseY < (TempY + SM_CYCAPTION) ) )
   {
      Return
   }

   ; If we have a g_Word and an g_OldCaretX, check to see if the Caret moved
   IfNotEqual, g_OldCaretX,
   {
      IfNotEqual, g_Word,
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
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_LearnMode

   g_EnabledKeyboardHotKeys =

   ;Setup toggle-able hotkeys

   ;Can't disable mouse buttons as we need to check to see if we have clicked the ListBox window
   ; If we disable the number keys they never get to the input for some reason,
   ; so we need to keep them enabled as hotkeys

   IfNotEqual, prefs_LearnMode, On
   {
      Hotkey, $^+Delete, Off
   } else {
      Hotkey, $^+Delete, Off
      ; We only want Ctrl-Shift-Delete enabled when the listbox is showing.
      g_EnabledKeyboardHotKeys .= "$^+Delete" . g_DelimiterChar
   }

   HotKey, $^+c, On

   IfEqual, prefs_ArrowKeyMethod, Off
   {
      Hotkey, $^Enter, Off
      Hotkey, $^Space, Off
      Hotkey, $Tab, Off
      Hotkey, $Right, Off
      Hotkey, $Up, Off
      Hotkey, $Down, Off
      Hotkey, $PgUp, Off
      Hotkey, $PgDn, Off
      HotKey, $Enter, Off
      Hotkey, $NumpadEnter, Off
   } else {
      g_EnabledKeyboardHotKeys .= "$Up" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$Down" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgUp" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgDn" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains E
         Hotkey, $^Enter, Off
      else g_EnabledKeyboardHotKeys .= "$^Enter" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains S
         HotKey, $^Space, Off
      else g_EnabledKeyboardHotKeys .= "$^Space" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains T
         HotKey, $Tab, Off
      else g_EnabledKeyboardHotKeys .= "$Tab" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains R
         HotKey, $Right, Off
      else g_EnabledKeyboardHotKeys .= "$Right" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains U
         HotKey, $Enter, Off
      else g_EnabledKeyboardHotKeys .= "$Enter" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains M
         HotKey, $NumpadEnter, Off
      else g_EnabledKeyboardHotKeys .= "$NumpadEnter" . g_DelimiterChar
   }

   ; remove last ascii 2
   StringTrimRight, g_EnabledKeyboardHotKeys, g_EnabledKeyboardHotKeys, 1

} ;//

EnableKeyboardHotKeys(){
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   Loop, Parse, g_EnabledKeyboardHotKeys, %g_DelimiterChar%
   {
      HotKey, %A_LoopField%, On
   }
   Return
}

DisableKeyboardHotKeys(){
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   Loop, Parse, g_EnabledKeyboardHotKeys, %g_DelimiterChar%
   {
      HotKey, %A_LoopField%, Off
   }
   Return
}
;------------------------------------------------------------------------
;/ checkword(key)
; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed
CheckWord(Key){
   global g_ListBox_Id
   global g_Match
   global g_MatchStart
   global g_NumKeyMethod
   global g_SingleMatch
   global g_Word
   global prefs_ListBoxRows
   global prefs_NumPresses

   StringRight, Key, Key, 1 ;Grab just the number pushed, trim off the "$"

   IfEqual, Key, 0
   {
      WordIndex := g_MatchStart + 9
   } else {
            WordIndex := g_MatchStart - 1 + Key
         }

   IfEqual, g_NumKeyMethod, Off
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      Return
   }

   IfEqual, prefs_NumPresses, 2
      SuspendOn()

   ; If active window has different window ID from before the input, blank word
   ; (well, assign the number pressed to the word)
   if !(ReturnWinActive())
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return
   }

   if ReturnLineWrong() ;Make sure we are still on the same line
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return
   }

   IfNotEqual, g_Match,
   {
      ifequal, g_ListBox_Id,        ; only continue if match is not empty and list is showing
      {
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         IfEqual, prefs_NumPresses, 2
            SuspendOff()
         Return
      }
   }

   ifequal, g_Word,        ; only continue if g_word is not empty
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return
   }

   if ( ( (WordIndex + 1 - MatchStart) > prefs_ListBoxRows) || ( g_Match = "" ) || (g_SingleMatch[WordIndex] = "") )   ; only continue g_SingleMatch is not empty
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return
   }

   IfEqual, prefs_NumPresses, 2
   {
      Input, KeyAgain, L1 I T0.5, 1234567890

      ; If there is a timeout, abort replacement, send key and return
      IfEqual, ErrorLevel, Timeout
      {
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         SuspendOff()
         Return
      }

      ; Make sure it's an EndKey, otherwise abort replacement, send key and return
      IfNotInString, ErrorLevel, EndKey:
      {
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }

      ; If the 2nd key is NOT the same 1st trigger key, abort replacement and send keys
      IfNotInString, ErrorLevel, %Key%
      {
         StringTrimLeft, KeyAgain, ErrorLevel, 7
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
   IfEqual, prefs_NumPresses, 2
      SuspendOff()
   Return
}
;//
;------------------------------------------------------------------------
;If a hotkey related to the up/down arrows was pressed
EvaluateUpDown(Key){
   global g_ListBox_Id
   global g_Match
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OriginalMatchStart
   global g_SingleMatch
   global g_Word
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_ListBoxRows

   IfEqual, prefs_ArrowKeyMethod, Off
   {
      if (Key != "$LButton")
      {
         SendKey(Key)
         Return
      }
   }

   IfEqual, g_Match,
   {
      SendKey(Key)
      Return
   }

   IfEqual, g_ListBox_Id,
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

   IfEqual, g_Word, ; only continue if word is not empty
   {
      SendKey(Key)
      ClearAllVars(false)
      Return
   }

   if ( ( Key = "$^Enter" ) || ( Key = "$Tab" ) || ( Key = "$^Space" ) || ( Key = "$Right") || ( Key = "$Enter") || ( Key = "$LButton") || ( Key = "$NumpadEnter") )
   {
      IfEqual, Key, $^Enter
      {
         KeyTest = E
      } else IfEqual, Key, $Tab
      {
         KeyTest = T
      } else IfEqual, Key, $^Space
      {
         KeyTest = S
      } else IfEqual, Key, $Right
      {
         KeyTest = R
      } else IfEqual, Key, $Enter
      {
         KeyTest = U
      } else IfEqual, Key, $LButton
      {
         KeyTest = L
      } else IfEqual, Key, $NumpadEnter
      {
         KeyTest = M
      }

      if (KeyTest == "L") {
         ;when hitting LButton, we've already handled this condition
      } else if prefs_DisabledAutoCompleteKeys contains %KeyTest%
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

   IfEqual, Key, $Up
   {
      g_MatchPos--

      IfLess, g_MatchPos, 1
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
         g_MatchPos := g_MatchTotal
      } else IfLess, g_MatchPos, %g_MatchStart%
      {
         g_MatchStart --
      }
   } else IfEqual, Key, $Down
   {
      g_MatchPos++
      IfGreater, g_MatchPos, %g_MatchTotal%
      {
         g_MatchStart =1
         g_MatchPos =1
      } Else If ( g_MatchPos > ( g_MatchStart + (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart ++
      }
   } else IfEqual, Key, $PgUp
   {
      IfEqual, g_MatchPos, 1
      {
         g_MatchPos := g_MatchTotal - (prefs_ListBoxRows - 1)
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
      } Else {
         g_MatchPos-=prefs_ListBoxRows
         g_MatchStart-=prefs_ListBoxRows
      }

      IfLess, g_MatchPos, 1
         g_MatchPos = 1
      IfLess, g_MatchStart, 1
         g_MatchStart = 1

   } else IfEqual, Key, $PgDn
   {
      IfEqual, g_MatchPos, %g_MatchTotal%
      {
         g_MatchPos := prefs_ListBoxRows
         g_MatchStart := 1
      } else {
         g_MatchPos+=prefs_ListBoxRows
         g_MatchStart+=prefs_ListBoxRows
      }

      IfGreater, g_MatchPos, %g_MatchTotal%
         g_MatchPos := g_MatchTotal

      If ( g_MatchStart > ( g_MatchTotal - (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
      }
   }

   IfEqual, g_MatchStart, %PreviousMatchStart%
   {
      Rows := GetRows()
      IfNotEqual, g_MatchPos,
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
   global g_OldCaretY
   global prefs_DetectMouseClickMove
   ; Return false if we are using DetectMouseClickMove
   IfEqual, prefs_DetectMouseClickMove, On
   {
      Return
   }

   Return, ( g_OldCaretY != HCaretY() )
}
;------------------------------------------------------------------------

AddSelectedWordToList(){
   ClipboardSave := ClipboardAll
   Clipboard =
   Sleep, 100
   SendCompatible("^c",0)
   ClipWait, 0
   IfNotEqual, Clipboard,
   {
      AddWordToList(Clipboard,1,"ForceLearn")
   }
   Clipboard = %ClipboardSave%
}
DeleteSelectedWordFromList(){
   global g_MatchPos
   global g_SingleMatch

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
   global g_ScriptTitle

   SplitPath, A_ScriptName,,,ScriptExtension,ScriptNoExtension,

   If A_Is64bitOS
   {
      IF (A_PtrSize = 4)
      {
         IF A_IsCompiled
         {

            ScriptPath64 := A_ScriptDir . "\" . ScriptNoExtension . "64." . ScriptExtension

            IfExist, %ScriptPath64%
            {
               Run, %ScriptPath64%, %A_WorkingDir%
               ExitApp
            }
         }
      }
   }

   if (SubStr(ScriptNoExtension, StrLen(ScriptNoExtension)-1, 2) == "64" )
   {
      StringTrimRight, g_ScriptTitle, ScriptNoExtension, 2
   } else {
      g_ScriptTitle := ScriptNoExtension
   }

   if (InStr(g_ScriptTitle, "TypingAid"))
   {
      g_ScriptTitle = TypingAid
   }

   return
}

;------------------------------------------------------------------------

InactivateAll(){
   ;Force unload of Keyboard Hook and WinEventHook
   Input
   SuspendOn()
   CloseListBox()
   MaybeSaveHelperWindowPos()
   DisableWinHook()
}

SuspendOn(){
   global g_ScriptTitle
   Suspend, On
   Menu, Tray, Tip, %g_ScriptTitle% - Inactive
   If A_IsCompiled
   {
      Menu, tray, Icon, %A_ScriptFullPath%,3,1
   } else
   {

  	Menu, Tray, Icon , Shell32.dll, 28 , 1
    ;Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Inactive.ico, ,1
   }
}
SuspendOff(){
   global g_ScriptTitle
   Suspend, Off
   Menu, Tray, Tip, %g_ScriptTitle% - Active
   If A_IsCompiled
   {
   	Menu, Tray, Icon , Shell32.dll, 28 , 1


   } else
   {
   	   	Menu, Tray, Icon , Shell32.dll, 14 , 1


    ;  Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Active.ico, ,1
          ;  Menu, tray, Icon, %A_ScriptFullPath%,1,1

   }
}
;------------------------------------------------------------------------

BuildTrayMenu(){
	;Prevents hotkeys from being fired before everything is configured correctly
	Critical, On

   Menu, Tray, DeleteAll
   Menu, Tray, NoStandard
   Menu,Tray,Add, Recent Files, settingsrecent

   Menu, Tray, add, Settings, Configuration
   Menu, Tray, add, filemenu,
   Menu, Tray, add, mymenubar,
   Menu, Tray, add, Pause, PauseResumeScript
   IF (A_IsCompiled)
   {
      Menu, Tray, add, Exit, ExitScript
   } else {
      Menu, Tray, Standard
   }
   Menu, Tray, Default, Settings
   ;Menu, Tray, Default, Settings
   ;Initialize Tray Icon
   Menu, Tray, Icon
}
;------------------------------------------------------------------------

; This is to blank all vars related to matches, ListBox and (optionally) word
ClearAllVars(ClearWord){
   global
   CloseListBox()
   Ifequal,ClearWord,1
   {
      g_Word =
      g_OldCaretY=
      g_OldCaretX=
      g_LastInput_id=
      g_ListBoxFlipped=
      g_ListBoxMaxWordHeight=
   }

   g_SingleMatch =
   g_SingleMatchDescription =
   g_SingleMatchReplacement =
   g_Match=
   g_MatchPos=
   g_MatchStart=
   g_OriginalMatchStart=
   Return
}
;------------------------------------------------------------------------
FileAppendDispatch(Text,FileName,ForceEncoding=0){
   IfEqual, A_IsUnicode, 1
   {
      IfNotEqual, ForceEncoding, 0
      {
         FileAppend, %Text%, %FileName%, %ForceEncoding%
      } else
      {
         FileAppend, %Text%, %FileName%, UTF-8
      }
   } else {
            FileAppend, %Text%, %FileName%
         }
   Return
}

MaybeFixFileEncoding(File,Encoding){
   IfGreaterOrEqual, A_AhkVersion, 1.0.90.0
   {

      IfExist, %File%
      {
         IfNotEqual, A_IsUnicode, 1
         {
            Encoding =
         }


         EncodingCheck := FileOpen(File,"r")

         If EncodingCheck
         {
            If Encoding
            {
               IF !(EncodingCheck.Encoding = Encoding)
                  WriteFile = 1
            } else
            {
               IF (SubStr(EncodingCheck.Encoding, 1, 3) = "UTF")
                  WriteFile = 1
            }

            IF WriteFile
            {
               Contents := EncodingCheck.Read()
               EncodingCheck.Close()
               EncodingCheck =
               FileCopy, %File%, %File%.preconv.bak
               FileDelete, %File%
               FileAppend, %Contents%, %File%, %Encoding%

               Contents =
            } else
            {
               EncodingCheck.Close()
               EncodingCheck =
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
   global g_NULL
   global g_ScrollEventHook
   global g_WinChangedEventHook

   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoInitializeEx", "Ptr", g_NULL, "Uint", g_NULL)
   }
}

MaybeCoUninitialize(){
   global g_WinChangedEventHook
   global g_ScrollEventHook
   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoUninitialize")
   }
}

;========================= labels
;-----------------------------------------------| LABELS |-----------------------------------------------#;

; This is called when user selects an item from a menu in GUI window
MenuEventHandler:
{
	; Draw the rectangle, the hourglass and update the Window
	Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
	Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

	; Get Extension of item to evaluate what handler to use
	WordArray := StrSplit(A_ThisMenuItem, ".")
	FileExtension := % WordArray[WordArray.MaxIndex()]

	; Get full path from Menu Item pass to handler
	FileItem := SubStr(A_ThisMenuItem, 2, StrLen(A_ThisMenuItem))
	FilePath := % A_ThisMenu "\" A_ThisMenuItem

	; Run item with appropriate handler
	Switch FileExtension
	{
		case "rtf" : Handler_RTF(FilePath)
		case "bat" : Handler_LaunchProgram(FilePath)
		case "txt" : Handler_txt(FilePath)
		case "lnk" : Handler_LaunchProgram(FilePath)
		case "exe" : Handler_LaunchProgram(FilePath)
		case "ahn" : Handler_Note(FilePath)

		Default: Handler_Default(FilePath)
	}

	; Clear the graphics and update thw window
	Gdip_GraphicsClear(G)  								  ;This sets the entire area of the graphics to 'transparent'
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

	return
}

; Is run when the program exits. This will take care of now unused graphics elements
Exit:
{
	Gdip_DeleteBrush(pBrush) 	; Delete the brush as it is no longer needed and wastes memory
	SelectObject(hdc, obm) 		; Select the object back into the hdc
	DeleteObject(hbm) 			; Now the bitmap may be deleted
	DeleteDC(hdc) 				; Also the device context related to the bitmap may be deleted
	Gdip_DeleteGraphics(G) 		; The graphics may now be deleted

	; gdi+ may now be shutdown on exiting the program
	Gdip_Shutdown(pToken)
	ExitApp
	Return
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
msgbox, % "went to" A_ThisLabel
Gui +LastFound        ; Window open/close detection
hWnd := WinExist()        ; Window open/close detection
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )

; To prevent Menu command errors from stopping script.
Menu, MenuName, UseErrorLevel

/*
   The following code sets up the Gui with a DropDownList with the original list of
   open windows. Remove or comment out this code for Menu only.
*/
Gui,+AlwaysOnTop
Gui, Font, s12, Arial
Gui, Add, DropDownList, w275 vWindowMove gPosChoice Sort Choose1 ; ,Pick a Window||
Menu, FileMenu, Add, &Rescan`tCtrl+R, GuiReset
Menu, MyMenuBar, Add, &File, :FileMenu
Gui, Menu, MyMenuBar

GoSub, GuiReset

Return

 ;// end autoexecute_windowsmenu()

;/ ALL Windows Menu Labels & Functions
ShellMessage( wParam,lParam ) {
   If ( wParam = 1 ) ; or ( wParam = 2 )  HSHELL_WINDOWCREATED := 1
   {
      GoSub, GuiReset
   }
}

; Subroutine scans open windows and creates a list for both the menu and Gui DropDownList.
GuiReset:

WinGet, OpenWindow, List
GuiControl,,WindowMove, |
Menu, WindowMenu, Delete
Menu, WindowMenu, Add, Rescan Windows, GuiReset
Menu, WindowMenu, Icon, Rescan Windows, C:\Windows\System32\imageres.dll, 140

Loop, %OpenWindow%
{
   WinGetTitle, Title, % "ahk_id " OpenWindow%A_Index%
   WinGetClass, Class, % "ahk_id " OpenWindow%A_Index%
   WinGet, AppName, ProcessPath, %Title%

   If (Title != "" and Class != "BasicWindow" and Title != "Start"
      and Title != "Program Manager")
   {
      Title := StrSplit(Title,"|")
      GuiControl,,WindowMove, % Title[1]
      Menu, WindowMenu, Insert,, % Title[1] . " |" . OpenWindow%A_Index%, MenuChoice
      Menu, WindowMenu, Icon, % Title[1] . " |" . OpenWindow%A_Index%, %AppName%
      If ErrorLevel
         Menu, WindowMenu, Icon, % Title[1] . " |" . OpenWindow%A_Index%
      , C:\WINDOWS\System32\SHELL32.dll,36
   }
}

GuiControl, Choose, WindowMove, 1
Return


MenuChoice:

ProcessID := StrSplit(A_ThisMenuItem,"|")
WinActivate, % "ahk_id " ProcessID[2]

Return

PosChoice:
Gui, Submit, NoHide
WinActivate, %WindowMove%

; Checks for window location off screen and resets to on screen.
WinGetPos,X1,Y1,W1,H1,Program Manager
WinGetPos,X2,Y2,W2,H2,%WindowMove%
If (X2 > W1 or Y2 > H1)
   WinMove, %WindowMove%,, 20, 20
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

  Gui, 2: Show,, To Do List
  LV_ColorInitiate()
  SetColor()
}
else
WinMinimize, To Do List
;gui, show,,hide
Return ;//

;/ mylistview
todoListView:
;  GUI, +LastFound
  HighlightRow := A_EventInfo
  If A_GuiEvent = e
    UpdateFile()
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "C", true))
        LV_ColorChange(HighlightRow, "0x660000", "0xCC99FF")
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "c", true))
        LV_ColorChange(HighlightRow, "0x000000", "0xFFFFFF")
;  MsgBox, %A_GuiEvent% %ErrorLevel%
Return ;//


;/ guicontextmenu
GuiContextMenu3:  ; Launched in response to a right-click or press of the Apps key.
if A_GuiControl <> MyListView  ; Display the menu only for clicks inside the ListView.
    return
  LV_GetText(EditText, A_EventInfo)
; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show , %A_GuiX%, %A_GuiY%
return ;//

;/ DeleteItem
DeleteItem:  ; The user selected "Clear" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
UpdateFile()
SetColor()
return ;//

;/ AddItem
AddItem:
  Gui, Submit, NoHide

If SelectedRow = 0
{
  LV_Add("", trim(NewItem))
}
else
{
  LV_Modify(SelectedRow,"",Trim(NewItem))
  SelectedRow := 0
  GuiControl, ,Button1, Add to list
}
  UpdateFile()
  LV_ModifyCol(1,"AutoHdr")

  SetColor()

Return ;//

;/ EditItem
EditItem:
  SelectedRow := LV_GetNext()
  GuiControl, ,Edit1, %EditText%
  GuiControl, ,Button1, Update
Return ;//

;/ UpdateFile
UpdateFile:
  DetectHiddenWindows On
  UpdateFile()
  ExitApp
Return ;//

;/ Guisize
GuiSize:  ; Expand or shrink the ListView in response to the user's resizing of the window.
if A_EventInfo = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
GuiControl, Move, Button1, % "y" . (A_GuiHeight - 30)
GuiControl, Move, Edit1, % "y" . (A_GuiHeight - 30) . "W" . (A_GuiWidth - 90)
Return ;//



;/ ==== All functions for this section
UpdateFile(){
    FileDelete, ToDoList.txt
    WinGetPos, X, Y, Width, Height, To Do List
    Width -= 16
    Height -= 38
    FileAppend, x%x% y%y% w%Width% h%Height% `n, ToDoList.txt
    Loop % LV_GetCount()
     {
       Gui +LastFound
       SendMessage, 4140, A_Index - 1, 0xF000, SysListView321
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
        {
          LV_GetText(Text, A_Index)
          FileAppend, *%Text% `n, ToDoList.txt
        }
         else
        {
          LV_GetText(Text, A_Index)
          FileAppend, %Text% `n, ToDoList.txt
        }
      }
   }

SetColor() {
  Loop, % LV_GetCount()
  {
       SendMessage, 4140, A_Index - 1, 0xF000, SysListView321
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
         LV_ColorChange(A_Index, "0x660000", "0xCC99FF")
       Else
         LV_ColorChange(A_Index, "0x000000", "0xFFFFFF")

  }
}

; These are the functions that change the row colors.
; I only changed WM_NOTIFY( p_w, p_l, p_m ) for this app

LV_ColorInitiate(Gui_Number=1, Control=""){ ; initiate listview color change procedure
  global hw_LV_ColorChange
  If Control =
    Control =SysListView321
  Gui, %Gui_Number%:+Lastfound
  Gui_ID := WinExist()
  ControlGet, hw_LV_ColorChange, HWND,, %Control%, ahk_id %Gui_ID%
  OnMessage( 0x4E, "WM_NOTIFY" )
}

LV_ColorChange(Index="", TextColor="", BackColor="") { ; change specific line's color or reset all lines
  global
  If Index =
    Loop, % LV_GetCount()
      LV_ColorChange(A_Index)
  Else
    {
    Line_Color_%Index%_Text := TextColor
    Line_Color_%Index%_Back := BackColor
   WinSet, Redraw,, ahk_id %hw_LV_ColorChange%
    }
}



WM_NOTIFY( p_w, p_l, p_m ){
  local  draw_stage, Current_Line, Index
  if ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) {
      if ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                            ; NM_CUSTOMDRAW
          draw_stage := DecodeInteger( "uint4", p_l, 12 )
          if ( draw_stage = 1 )                                                 ; CDDS_PREPAINT
              return, 0x20                                                      ; CDRF_NOTIFYITEMDRAW
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

DecodeInteger( p_type, p_address, p_offset, p_hex=true ){
  old_FormatInteger := A_FormatInteger
  ifEqual, p_hex, 1, SetFormat, Integer, hex
  else, SetFormat, Integer, dec
  StringRight, size, p_type, 1
  loop, %size%
      value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) )
  if ( size <= 4 and InStr( p_type, "u" ) != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 )
      value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) )
  SetFormat, Integer, %old_FormatInteger%
  return, value
}

EncodeInteger( p_value, p_size, p_address, p_offset )
{
  loop, %p_size%
    DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) )
}
;// end of todo functions

;=========================== Typing
Configuration:
GoSub, LaunchSettings
Return

PauseResumeScript:
if (g_PauseState == "Paused")
{
   g_PauseState =
   Pause, Off
   EnableWinHook()
   Menu, tray, Uncheck, Pause
} else {
   g_PauseState = Paused
   DisableWinHook()
   SuspendOn()
   Menu, tray, Check, Pause
   Pause, On, 1
}
Return

ExitScript:
ExitApp
Return

SaveScript:
; Close the ListBox if it's open
CloseListBox()

SuspendOn()

;Change the cleanup performance speed
SetBatchLines, 20ms
Process, Priority,,Normal

;Grab the Helper Window Position if open
MaybeSaveHelperWindowPos()

;Write the Helper Window Position to the Preferences File
MaybeWriteHelperWindowPos()

; Update the Learned Words
MaybeUpdateWordlist()

exitapp



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

IniSettingsEditor(ProgName,IniFile,OwnedBy = 0,DisableGui = 0) {
	;/ start
    static pos

    ;Find a GUI ID that does not exist yet
    Loop, 99 {
      Gui %A_Index%:+LastFoundExist
      If not WinExist() {
          SettingsGuiID = %A_Index%
          break
      }Else If (A_Index = 99){
          MsgBox, 4112, Error in IniSettingsEditor function, Can't open settings dialog,`nsince no GUI ID was available.
          Return 0
        }
      }
    Gui, %SettingsGuiID%:Default

    ;apply options to settings GUI
    If OwnedBy {
        Gui, +ToolWindow +Owner%OwnedBy%
        If DisableGui
            Gui, %OwnedBy%:+Disabled
    }Else
        DisableGui := False

    Gui, +Resize +LabelGuiIniSettingsEditor
    ;create GUI (order of the two edit controls is crucial, since ClassNN is order dependent)
    Gui, Add, Statusbar
    Gui, Add, TreeView, x16 y75 w200 h370 0x400
    Gui, Add, Edit, x225 y114 w400 h20,                           ;ahk_class Edit1
    Gui, Add, Edit, x225 y174 w400 h200 ReadOnly,                 ;ahk_class Edit2
    Gui, Add, Button, x490 y420 w100 gExitSettings , E&xit     ;ahk_class Button1
    Gui, Add, Button, x565 y88  gBtnBrowseKeyValue Hidden, B&rowse ;ahk_class Button2
    Gui, Add, Button, x225 y420 gBtnDefaultValue, &Restore        ;ahk_class Button3
    Gui, Add, DateTime, x225 y114 w340 h20 Hidden,                ;ahk_class SysDateTimePick321
    Gui, Add, Hotkey, x225 y114 w340 h20 Hidden,                  ;ahk_class msctls_hotkey321
    Gui, Add, DropDownList, x225 y114 w340 h120 Hidden,           ;ahk_class ComboBox1
    Gui, Add, CheckBox, x225 y114 w340 h20 Hidden,                ;ahk_class Button4
    Gui, Add, GroupBox, x4 y63 w640 h390 ,                        ;ahk_class Button5
    Gui, Font, Bold
    Gui, Add, Text, x225 y93, Value                               ;ahk_class Static1
    Gui, Add, Text, x225 y154, Description                        ;ahk_class Static2
    Gui, Add, Text, x15 y48 w650 h20 +Center, (All changes are Auto-Saved - A Reload may be needed for changes to have affect)
    Gui, Font, S16 CDefault Bold, Verdana
    Gui, Add, Text, x45 y13 w480 h35 +Center, Settings for %ProgName%

    ;read data from ini file, build tree and store values and description in arrays
    Loop, Read, %IniFile%
      {
        CurrLine = %A_LoopReadLine%
        CurrLineLength := StrLen(CurrLine)

        ;blank line
        If CurrLine is space
             Continue

        ;description (comment) line
        If ( InStr(CurrLine,";") = 1 ){
            StringLeft, chk2, CurrLine, % CurrLength + 2
            StringTrimLeft, Des, CurrLine, % CurrLength + 2
            ;description of key
            If ( %CurrID%Sec = False AND ";" CurrKey A_Space = chk2){
                ;handle key types
                If ( InStr(Des,"Type: ") = 1 ){
                    StringTrimLeft, Typ, Des, 6
                    Typ = %Typ%
                    Des = `n%Des%     ;add an extra line to the type definition in the description control

                    ;handle format or list
                    If (InStr(Typ,"DropDown ") = 1) {
                        StringTrimLeft, Format, Typ, 9
                        %CurrID%For = %Format%
                        Typ = DropDown
                        Des =
                    }Else If (InStr(Typ,"DateTime") = 1) {
                        StringTrimLeft, Format, Typ, 9
                        If Format is space
                            Format = dddd MMMM d, yyyy HH:mm:ss tt
                        %CurrID%For = %Format%
                        Typ = DateTime
                        Des =
                      }
                    ;set type
                    %CurrID%Typ := Typ
                ;remember default value
                }Else If ( InStr(Des,"Default: ") = 1 ){
                    StringTrimLeft, Def, Des, 9
                    %CurrID%Def = %Def%
                ;remember custom options
                }Else If ( InStr(Des,"Options: ") = 1 ){
                    StringTrimLeft, Opt, Des, 9
                    %CurrID%Opt = %Opt%
                    Des =
                ;remove hidden keys from tree
                }Else If ( InStr(Des,"Hidden:") = 1 ){
                    TV_Delete(CurrID)
                    Des =
                    CurrID =
                ;handle checkbox name
                }Else If ( InStr(Des,"CheckboxName: ") = 1 ){
                    StringTrimLeft, ChkN, Des, 14
                    %CurrID%ChkN = %ChkN%
                    Des =
                  }
                %CurrID%Des := %CurrID%Des "`n" Des
            ;description of section
            } Else If ( %CurrID%Sec = True AND ";" CurrSec A_Space = chk2 ){
                ;remove hidden section from tree
                If ( InStr(Des,"Hidden:") = 1 ){
                    TV_Delete(CurrID)
                    Des =
                    CurrSecID =
                  }
                ;set description
                %CurrID%Des := %CurrID%Des "`n" Des
              }

            ;remove leading and trailing whitespaces and new lines
            If ( InStr(%CurrID%Des, "`n") = 1 )
                StringTrimLeft, %CurrID%Des, %CurrID%Des, 1
            Continue
          }

        ;section line
        If ( InStr(CurrLine, "[") = 1 And InStr(CurrLine, "]", "", 0) = CurrLineLength) {
            ;extract section name
            StringTrimLeft, CurrSec, CurrLine, 1
            StringTrimRight, CurrSec, CurrSec, 1
            CurrSec = %CurrSec%
            CurrLength := StrLen(CurrSec)  ;to easily trim name off of following comment lines

            ;add to tree
            CurrSecID := TV_Add(CurrSec)
            CurrID = %CurrSecID%
            %CurrID%Sec := True
            CurrKey =
            Continue
          }

        ;key line
        Pos := InStr(CurrLine,"=")
        If ( Pos AND CurrSecID ){
            ;extract key name and its value
            StringLeft, CurrKey, CurrLine, % Pos - 1
            StringTrimLeft, CurrVal, CurrLine, %Pos%
            CurrKey = %CurrKey%             ;remove whitespaces
            CurrVal = %CurrVal%
            CurrLength := StrLen(CurrKey)

            ;add to tree and store value
            CurrID := TV_Add(CurrKey,CurrSecID)
            %CurrID%Val := CurrVal
            %CurrID%Sec := False

            ;store initial value as default for restore function
            ;will be overwritten if default is specified later on comment line
            %CurrID%Def := CurrVal
          }
      }

    ;select first key of first section and expand section
    TV_Modify(TV_GetChild(TV_GetNext()), "Select")

    ;show Gui and get UniqueID
    TV_Modify(CurrSecID, "Sort") ; modification lintalist
	    Gui, Show, w650 h490, %ProgName% Settings
	    Gui, +LastFound
	    GuiID := WinExist()

	    ;check for changes in GUI
	    Loop {
	        ;get current tree selection
	        CurrID := TV_GetSelection()

	        If SetDefault {
	            %CurrID%Val := %CurrID%Def
	            LastID = 0
	            SetDefault := False
	            ValChanged := True
	          }

	        MouseGetPos,,, AWinID, ACtrl
	        If ( AWinID = GuiID){
	            If ( ACtrl = "Button3")
	                SB_SetText("Restores Value to default (if specified), else restores it to initial value before change")
	        } Else
	            SB_SetText("")

	        ;change GUI content if tree selection changed
	        If (CurrID <> LastID) {
	            ;remove custom options from last control
	            Loop, Parse, InvertedOptions, %A_Space%
	                GuiControl, %A_Loopfield%, %ControlUsed%

	            ;hide/show browse button depending on key type
	            Typ := %CurrID%Typ
	            If Typ in File,Folder,Exe
	                GuiControl, Show , Button2,
	            Else
	                GuiControl, Hide , Button2,

	            ;set the needed value control depending on key type
	            If (Typ = "DateTime")
	                ControlUsed = SysDateTimePick321
	            Else If ( Typ = "Hotkey" )
	                ControlUsed = msctls_hotkey321
	            Else If ( Typ = "DropDown")
	                ControlUsed = ComboBox1
	            Else If ( Typ = "CheckBox")
	                ControlUsed = Button4
	            Else                    ;e.g. Text,File,Folder,Float,Integer or No Tyo (e.g. Section)
	                ControlUsed = Edit1

	            ;hide/show the value controls
	            Controls = SysDateTimePick321,msctls_hotkey321,ComboBox1,Button4,Edit1
	            Loop, Parse, Controls, `,
	                If ( ControlUsed = A_LoopField )
	                    GuiControl, Show , %A_LoopField%,
	                Else
	                    GuiControl, Hide , %A_LoopField%,

	            If ( ControlUsed = "Button4" )
	                GuiControl,  , Button4, % %CurrID%ChkN

	            ;get current options
	            CurrOpt := %CurrID%Opt
	            ;apply current custom options to current control and memorize them inverted
	            InvertedOptions =
	            Loop, Parse, CurrOpt, %A_Space%
	              {
	                ;get actual option name
	                StringLeft, chk, A_LoopField, 1
	                StringTrimLeft, chk2, A_LoopField, 1
	                If chk In +,-
	                  {
	                    GuiControl, %A_LoopField%, %ControlUsed%
	                    If (chk = "+")
	                        InvertedOptions = %InvertedOptions% -%chk2%
	                    Else
	                        InvertedOptions = %InvertedOptions% +%chk2%
	                }Else {
	                    GuiControl, +%A_LoopField%, %ControlUsed%
	                    InvertedOptions = %InvertedOptions% -%A_LoopField%
	                  }
	              }

	            If %CurrID%Sec {                      ;section got selected
	                CurrVal =
	                GuiControl, , Edit1,
	                GuiControl, Disable , Edit1,
	                GuiControl, Disable , Button3,
	            }Else {                               ;new key got selected
	                CurrVal := %CurrID%Val   ;get current value
	                GuiControl, , Edit1, %CurrVal%   ;put current value in all value controls
	                GuiControl, Text, SysDateTimePick321, % %CurrID%For
	                GuiControl, , SysDateTimePick321, %CurrVal%
	                GuiControl, , msctls_hotkey321, %CurrVal%
	                GuiControl, , ComboBox1, % "|" %CurrID%For
	                GuiControl, ChooseString, ComboBox1, %CurrVal%
	                GuiControl, , Button4 , %CurrVal%
	                GuiControl, Enable , Edit1,
	                GuiControl, Enable , Button3,
	              }
	            GuiControl, , Edit2, % %CurrID%Des
	          }
	        LastID = %CurrID%                   ;remember last selection

	        ;sleep to reduce CPU load
	        Sleep, 100

	        ;exit endless loop, when settings GUI closes
	        If not WinExist("ahk_id" GuiID)
	            Break

	        ;if key is selected, get value
	        If (%CurrID%Sec = False){
	            GuiControlGet, NewVal, , %ControlUsed%
	            ;save key value when it has been changed
	            If ( NewVal <> CurrVal OR ValChanged ) {
	                ValChanged := False

	                ;consistency check if type is integer or float
	                If (Typ = "Integer")
	                  If NewVal is not space
	                    If NewVal is not Integer
	                      {
	                        GuiControl, , Edit1, %CurrVal%
	                        Continue
	                      }
	                If (Typ = "Float")
	                  If NewVal is not space
	                    If NewVal is not Integer
	                      If (NewVal <> ".")
	                        If NewVal is not Float
	                          {
	                            GuiControl, , Edit1, %CurrVal%
	                            Continue
	                          }

	                ;set new value and save it to INI
	                %CurrID%Val := NewVal
	                CurrVal = %NewVal%
	                PrntID := TV_GetParent(CurrID)
	                TV_GetText(SelSec, PrntID)
	                TV_GetText(SelKey, CurrID)
	                If (SelSec AND SelKey)
	                    IniWrite, %NewVal%, %IniFile%, %SelSec%, %SelKey%
	              }
	          }
	      }

    ;Exit button got pressed
    ExitSettings:
      ;re-enable calling GUI
      If DisableGui {
          Gui, %OwnedBy%:-Disabled
          Gui, %OwnedBy%:,Show
        }
      Gui, Destroy
    ;exit function
    Return 1

    ;browse button got pressed
    BtnBrowseKeyValue:
      ;get current value
      GuiControlGet, StartVal, , Edit1
      Gui, +OwnDialogs

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
          FileSelectFile, Selected,M , %StartFolder%\bundles\, Select file for %SelSec% - %SelKey%, Any file (*.txt)
      }

else      If (Typ = "Exe"){
        StartFolder:=A_ScriptDir
          FileSelectFile, Selected, , %StartFolder%\bundles\, Select EXE for Snippet Editor, (*.exe)
      }

      Else If (Typ = "Folder"){
          ;get StartFolder
          IfExist %A_ScriptDir%\%StartVal%
              StartFolder = %A_ScriptDir%\%StartVal%
          Else IfExist %StartVal%
              StartFolder = %StartVal%
          Else
              StartFolder =

          ;select folder
          FileSelectFolder, Selected, *%StartFolder% , 3, Select folder for %SelSec% - %SelKey%

          ;remove last backslash "\" if any
          StringRight, LastChar, Selected, 1
          If LastChar = \
               StringTrimRight, Selected, Selected, 1
        }
      ;If file or folder got selected, remove A_ScriptDir (since it's redundant) and set it into GUI
      If Selected {
          StringReplace, Selected, Selected, %A_ScriptDir%\bundles
          StringReplace, Selected, Selected, `n, `, , All
          StringReplace, Selected, Selected, `r,  , , All
          If (SubStr(Selected,1,1) = ",")
            StringTrimLeft, Selected, Selected, 1
          GuiControl, , Edit1, %Selected%
          %CurrID%Val := Selected
        }
    Return  ;end of browse button subroutine

    ;default button got pressed
    BtnDefaultValue:
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


GuiIniSettingsEditorAnchor(ctrl, a, draw = false) { ; v3.2 by Titan (shortened)
    static pos
    sig = `n%ctrl%=
    If !InStr(pos, sig) {
      GuiControlGet, p, Pos, %ctrl%
      pos := pos . sig . px - A_GuiWidth . "/" . pw  - A_GuiWidth . "/"
        . py - A_GuiHeight . "/" . ph - A_GuiHeight . "/"
    }
    StringTrimLeft, p, pos, InStr(pos, sig) - 1 + StrLen(sig)
    StringSplit, p, p, /
    c = xwyh
    Loop, Parse, c
      If InStr(a, A_LoopField) {
        If A_Index < 3
          e := p%A_Index% + A_GuiWidth
        Else e := p%A_Index% + A_GuiHeight
        m = %m%%A_LoopField%%e%
      }
    If draw
      d = Draw
    GuiControl, Move%d%, %ctrl%, %m%
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
      Menu, clipMenu, Show
   }

   class OnClipboard {
      __New() {
         this.testFnObj := ObjBindMethod(this, "InsertClip")
         this.Clip := ObjBindMethod(this, "SaveClip")
         OnClipboardChange(this.Clip)
      }

      SaveClip(type) {
         if (type = 1) {
            testFnObj := this.testFnObj
            Menu, clipMenu, Add, % Clipboard, % testFnObj
         }
      }

      InsertClip() {
         Clipboard := A_ThisMenuItem
         Sleep, 50
         Send ^v
      }

      Clear() {
         OnClipboardChange(this.Clip, 0)
      }
   }
}


#Include lib\Conversions.ahk
#Include lib\Helper.ahk
#Include lib\ListBox.ahk
#Include lib\Preferences File.ahk
#Include lib\Sending.ahk
#Include lib\Settings.ahk
#Include lib\Window.ahk
#Include lib\Wordlist.ahk
#Include <DBA>
#Include <_Struct>


menulooper(PATH){
static urls := { 0: ""
        , 1 : "https://www.google.com/search?hl=en&q="
        , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
        , 3 : "https://www.google.com/maps/search/"
        , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }

	Menu, %PATH%, Add, % "googler", googler ; Regular search ;googler								; Name
	Menu, %PATH%, Add, 	; seperating


	LoopOverFolder(Path)



	; Add Admin Panel
	Sleep, 200
	Menu, %PATH%, Add, 													; seperating line
	Menu, %PATH%"\Admin", Add, &1 Go to Parent Folder, GoToRootFolder	; Open script folder
	Menu, %PATH%"\Admin", Add, &2 Add Custom Item, GoToCustomFolder		; Open custom folder
	Menu, %PATH%		  , Add,  % ScriptName " vers. " Version, github ;googler                        ; Name
	Menu, %PATH%"\Admin", Add, &0 Restart, ReloadProgram				; Add Reload option
	Menu, %PATH%"\Admin", Add, &9 Exit, ExitApp							; Add Exit option
	Menu, %PATH%, Add, &0 Admin, :%PATH%"\Admin"						; Adds Admin section

	; Loadingbar GUI is no longer needed, remove it from memory
	Gui, Destroy
}

folderlooper(PATH){
	; Prepare empty arrays for folders and files
	FolderArray := []
	FileArray   := []

	; Loop over all files and folders in input path, but do NOT recurse
	Loop, Files, %PATH%\* , DF
	{
		; Clear return value from last iteration, and assign it to attribute of current item
		VALUE := ""
		VALUE := FileExist(A_LoopFilePath)

		; Current item is a directory
		if (VALUE = "D")
		{
			 MsgBox, % "Pushing to folders`n" A_LoopFilePath
			FolderArray.Push(A_LoopFilePath)
		}
		; Current item is a file
		else
		{
			 MsgBox, % "Pushing to files`n" A_LoopFilePath
			FileArray.Push(A_LoopFilePath)
		}
	}

	; Arrays are sorted to get alphabetical representation in GUI menu
	Sort, FolderArray
	Sort, FileArray

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
		SplitPath, element, name, dir, ext, name_no_ext, drive
		;Menu, MenuName, Cmd [, P3, P4, P5]
		Menu, %dir%, Add, %name%, :%element%

		; Iterate loading GUI progress
		FoundItem("Folder")
	}

	; Then add all files to folders
	for index, element in FileArray
	{
		; Add To Menu
		SplitPath, element, name, dir, ext, name_no_ext, drive
		Menu, %dir%, Add, %name%, MenuEventHandler

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
ini2( filename = 0, updatemode = 0 )
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
      filename := SubStr( A_ScriptName, 1, -3 ) . "ini"

   FileRead, s, %filename%

   Loop, Parse, s, `n`r, %A_Space%%A_Tab%
   {
      c := SubStr(A_LoopField, 1, 1)
      if (c="[")
         key := SubStr(A_LoopField, 2, -1)
      else if (c=";")
         continue
      else {
         p := InStr(A_LoopField, "=")
         if p {
         k := SubStr(A_LoopField, 1, p-1)
       if updatemode=0
          %key%%k% := SubStr(A_LoopField, p+1)
       if updatemode=1
       {
          write := %key%%k%
          IniWrite, %write%, %filename%, %key%, %k%
       }
         }
      }
   }
}

#Include, stats.ahk

run(path)
{


    run % path
    return
}
runfp()
{
   
   MsgBox, % "running..: `n" frontproject
    run % frontproject
    return
}

chrome_name(num:=0)
{

    SetKeyDelay, 100
    ;MsgBox, % "1: `n " num++

    if (num = 0)
    {

	    ;MsgBox, % "num: `n " num++

	    ;MsgBox, % "0: num: " num
	    send,{Alt 2}
	    send,{space 2}
	    send, l
	    send, w
	    send, % "dkz" . num
	    send,{enter}
	    return num
    }
    if (num = 1)
    {
		;MsgBox, % "0: num is : `n " num++
		;num++
		send,{Alt 2}
		send,{space 2}
		send, l
		send, w
		send, % "dkz" . num
		send,{enter}
		MsgBox, % "1:" sent dkz1
		return num
    }
    if (num = 2)
	{

		;MsgBox, % "2: `n num is : " num
		send,{Alt 2}
		send,{space 2}
		send, l
		send, w
		send, % "dkz" . num
		send,{enter}
		MsgBox, % "2:" sent dkz2
		return
	}
}

listFolder(folder) {
    Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListViewListFolder AltSubmit, Name
        Loop, Files, % folder "\*", D
        {
            LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
            LV_ModifyCol()  ; Auto-size each column to fit its contents.
            LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
            FolderList .= A_LoopFileName . "`n"
        }
    Gui, Show
    return 

GuiContextMenuListFolder:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListViewlistFolder")  ; This check is optional. It displays the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

MyListViewListFolder:
if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
{
    LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
    LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
    Run %Dir%\%FileName%,, UseErrorLevel
    ;Run %FileDir%\%FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox % "Could not open " %FileDir% "\" %FileName%
}
return
}

;strsplit()
 ;Separates a sentence into an array of words and reports the fourth word.




;-----------------------






;--------------------

;
;======================================================//regexer

validatepath(path :=""){
    static counter := ++1
if (path = ""){
path := frontproject
file1 := frontproject . "\" counter . ".txt"
FileAppend, % counter, % file1
}

dir_folder := path
f1:= ;"C:\test\testsub" ; \testsub.txt"
SplitPath,f1,name, dir, ext, name_no_ext, drive
stringmid,c,f1,2,2
if (c=":\") and (ext!="")
  msgbox,%f1%`nIt's a file
  else
  msgbox, % "its a dir" dir . "\" name "--ext:" ext "--drive:" drive
return
}

writefile(input := "", dir_path:="",switch:=0){
static enum := 0
    if (input = ""){
  inputbox, text, Note,Write Note:,,300,100
    }
    

    if (switch =1){
        FileSelectFolder, dir_path, , 3
        if dir_path =
    MsgBox, You didn't select a folder.
else
    MsgBox, You selected folder "%dir_path%".

dir_path := RegExReplace(dir_path, "\\$")  ; Removes the trailing backslash, if present.

    }


    if (dir_path =""){
        dir_path := frontproject
    } else
    {
        frontproject := dir_path
    }

    text := input
  ;fileappend, %current% - %text%\`n, % dir_path . current ".txt"

  frontfile := frontproject . "writtenfile" ++enum ".txt"
  fileappend, %text%\`n, % frontfile ;dir_path . current ".txt"
  run(frontproject)
  msgbox, % frontfile
return frontfile
}
front2(filename,dir){
;StringSplit, OutputArray, InputVar , Delimiters, OmitChars

    InputBox, name, "name,path"
 random, ranVar, 1, 100000000
 msgbox % ranvar
 ranvar := StrSplit(ranvar, ",", %a_space% " `t")

TestString := "This is a test."
StringSplit, word_array, TestString, %A_Space%, .  ; Omits periods.
MsgBox, The 4th word is %word_array4%.

colors := "red,green,blue"
for index, color in StrSplit(colors, ",")
    MsgBox % "Color number " index " is " color

    return global frontfile, frontproject
}

getCode2(Order) { ; to fill in the second parameter of Template
    return repeat(1, Order) "," repeat(2, Order) "," repeat(3, Order)
     . "," repeat(4, Order) "," repeat(5, Order) "," repeat(6, Order)
}

repeat2(str, n) { ; return str repeated n*n times
    Result := ""
    Loop, % n * n
        Result .= str
    return Result
}

/*fun(){
    global myfun
    myfun:=new fun()
}

class fun{
    __new(){
        return this
    }
    fun(){
        
    }
}
*/
/*StrAppendEachLine(str, appendix){
 
    return, RegExReplace(str, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix)
}*/
fileAppendEachLine(filename, appendix){
    hmm := FileOpen(filename, "r`n").read()
    FileOpen(filename, "w`n").write(RegExReplace(hmm, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix))
    return
}
z_
z_stringreplace(string, find, rep ){
    MsgBox, % "0: `n " find rep
   ; StringReplace, r, s, - , ||| , All
    StringReplace, r, s, %find% , %rep% , All
return r
}



;[ahk]
removespace(ans){

;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
;Fronttext := clipboard
NewStr := StrReplace(ans, A_Space, "_")
;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
clipboard := newstr
return newStr 
}


chrome_group2(num := 0){
if (num = 0)
{
static count := ++0
}
WinActivate, ahk_exe chrome.exe
WinWaitActive, ahk_exe chrome.exe
sleep, 200
sendevent, !g
return
}



chrome_label:
WinActivate, dkz
scan := new Shinsimagescanclass(dkz)
;scan.pixelregion()
;0xF6F6F6
;DD4D11
if (scan.Pixel(0x8AB4F8,,x,y)) {
    tooltip % "Found a pixel at " x "," y
    mousemove,  x , y  
    MouseClick, r, X, Y, 1, 
}
return




   
ff_group(){
WinActivate, dkz1 
WinWaitActive, dkz1
;M("go")
send, !g
}
return



getlog(){
  ;  Loop, Read, InputFile [, OutputFile]
Loop, Read, A_ScriptDir\logs\q-google.txt , file
for k,v in file
msgbox % A_Index is A_LoopField
}
getwin() {
    global log
    FormatTime, time, , MMdd-HH-mm
    WinGetActiveTitle, Title
    WinGet, win_proc, ProcessName, A
    WinGet, uniq_id, ID, A
    ; ASCII 30 octal 036 Record Separator
    if %uniq_id%
    FileAppend, %A_Tab%%time%%A_Tab%%uniq_id%%A_Tab%%win_proc%%A_Tab%%Title%`n, *%log%
}
timeSinceLastCall(id=1, reset=0){
   global t
   static arr:=array()
   if (reset=1)
   {
      ((id=0) ? arr:=[] : (arr[id, 0]:=arr[id, 1]:="", arr[id, 2]:=0))
      return
   }
   arr[id, 2]:=!arr[id, 2]
   arr[id, arr[id, 2]]:=A_TickCount  
   ;msgbox % "abs var:" abs
   return global abs(arr[id,1]-arr[id,0])
}
target(c){
    send, !d
    send, ^a
    send, {delete}
return
}
target2(){
WinGet, hWnd, ID, A
hCtl := ""
if !hCtl ;check for treeview e.g. Win 7
{
ControlGet, hCtl, Hwnd, , SysTreeView321, ahk_id %hWnd%
if hCtl
Acc := Acc_Get("Object", "outline", 0, "ahk_id " hCtl)
}
msgbox % oAcc.accChildCount
Loop, % oAcc.accChildCount
for %A_Index% in % oAcc.accChildCount
{
    MsgBox, 4,, Control #%A_Index% is "%A_LoopField%". Continue?
    IfMsgBox, No
        break
}
Loop, % oAcc.accChildCount
if (oAcc.accName(A_Index) = "Desktop")
if (1, oAcc.accDoDefaultAction(A_Index))
break
Loop, % oAcc.accChildCount
return
}
fs(){
app := "z:/"
run explorer.exe 
WinWaitActive ahk_exe explorer.exe  
send, {f4} 
send, ^a
send, %app%
send, {enter}
return
}

GetTime(){
    FormatTime, OutputVar
    MsgBox, The time is %OutputVar%
}
GetTime2(){
    FormatTime, OutputVar
    Return OutputVar   ;value returned to calling variable
}
GetKeyHistoryText(){
    active_window := WinActive("A")
    dhw := A_DetectHiddenWindows
    DetectHiddenWindows, On
    Process, Exist
    hwnd := WinExist("ahk_class AutoHotkey ahk_pid " . ErrorLevel)
    was_active  := (hwnd=active_window)
    was_visible := was_active || DllCall("IsWindowVisible", "UInt", hwnd)
    if (!was_active)
    {   ; There seems to be no way to prevent KeyHistory from activating the window,
        ; so block user input to prevent accidental somethings.
        BlockInput, On
        if (!was_visible) {
            ; Seemed to work on XP, but not Vista:
            ;WinGetPos, x, y         ; remember position
            ;WinMove, -10000, -10000 ; should hopefully keep it out of the way...
            ; Works, but shows an empty frame on Vista:
            ;WinSet, Region, W0 H0 0-0
            
            WinGet, was_tp, Transparent
            WinSet, Transparent, 0
        }
    }
    KeyHistory
    ; Get the variable list text.
    ControlGetText, text, Edit1
    if (!was_active)
    {   ; un-block input
        BlockInput, Off
        if (!was_visible) {
            WinHide             ; restore invisibility
            ;WinMove, %x%, %y%   ; restore position
            ;WinSet, Region
            WinSet, Transparent, % (was_tp="") ? "OFF" : was_tp
        }
    
        ; Focus isn't always restored to the previously active window, so do this.
        WinActivate, ahk_id %active_window%
    }
    DetectHiddenWindows, %dhw%
    return text
}
Count(String, Needle, Type="", SubPattern=""){
    Global
    Local f := 1, n := 0, Output := ""
    If (Type = "") {
        StringReplace, String, String, %Needle%, , UseErrorLevel
        n := ErrorLevel
    } Else If Type {

            WinSet, Transparent, % (was_tp="") ? "OFF" : wa        While (f := RegExMatch(String, Needle, Output, f + StrLen(Output)))
            n += 1, %Type%%n% := Output%SubPattern%
        %Type% := n
    } Else
        RegExReplace(String, Needle, "", n)
    Return n
}
ss(  ){
;global c = c++
;msgbox % c
;global c := c++
random, rand, 1,10000000000
;FileSelectFile, OutputVar [, Options, RootDir[\DefaultFilename], Prompt, Filter]
;global c := c + 1
frontproject = P:/app/(((snips)))
FilePath = %frontproject%\%rand%
frontfile = %filepath%.png

if FileExist( frontfile . ".png"){
    tooltip, it do, ,,1
return global frontfile, global frontproject , global c := c + 1

}

tooltip, created, ,,1, 1000
  SplitPath, FilePath, FileName,, FileExt, FileNameNoExt
if (FileExt != "png")   ; Appends the .png file extension if it is not already present 
  FilePath .= ".png", FileName .= ".png"
WinWaitClose, Save Screenshot
Sleep, 200
pToken := Gdip_Startup()
pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
Gdip_SaveBitmapToFile(pBitmap, FilePath)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
;msgbox % saved to filepath
msgbox % frontproject "-" frontfile . "frontproject - frontfiles"
;msgbox % c
return global frontfile, global frontproject , global c := c + 1


    


} 
p(){

    send, !d
    ;send, ^a
    ;send, {del}
    send, p:
    send, {enter}
    return
}
CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY){
    static LoadedPic
    LastEL := ErrorLevel
    Gui, Pict:Add, Pic, vLoadedPic, % RegExReplace(File, "^(\*\w+\s)+")
    GuiControlGet, LoadedPic, Pict:Pos
    Gui, Pict:Destroy
    CoordX += LoadedPicW // 2
    CoordY += LoadedPicH // 2
    ErrorLevel := LastEL
}
goexplore(){
    WinActive("ahk_exe explorer.exe")
        WinWaitActive, ahk_exe explorer.exe
        WinActivate, ahk_exe explorer.exe
        send, !d
        send, ^a 
        send, {delete}
        send, %frontproject%
}
listFiles(Folder) { ; list the file directory incl. subdirs
    List := ""
    Loop, Files, %Folder%\*.*, R
        if (A_LoopFileExt = "lnk") {
            ; replace lnk-files with paths to linked target
            FileGetShortCut, %A_LoopFileLongPath%, linkedTarget
            List .= linkedTarget "`r`n"
        } else
            List .= A_LoopFileFullPath "`r`n"
    return List
}
searchahk(answer,outputdir){
msgbox % outputdir
    SetWorkingDir, outputdir
   ; FileSelectFolder, Outputdir , *StartingFolder, , Prompt
    msgbox % outputdir
    SetWorkingDir, outputdir
msgbox,% findstring("%answer%", outputdir "/*.ahk")

/*findstring(string, filepattern = "*.*", rec = 0, case = 0){
    len := strlen(string)
    if (len = 0)
        return
    loop,% filepattern, 0,% rec
    {
        fileread, x,% a_loopfilefullpath
        if (pos := instr(x, string, case)){
            positions .= a_loopfilefullpath "|" pos
            while(pos := instr(x, string, case, pos+len))
                positions .= "|" pos
            positions .= "`n"
        }
    }
    return, positions
*/


; edit: changed pattern to filepattern to reduce "confusion".
return

findstring2(string, filepattern = "*.*", rec = 0, case = 0){
    msgbox % filepattern
    msgbox %  "findstring: " outputdir
    len := strlen(string)
    if (len = 0)
        return
    loop,% filepattern, 0,% rec
    {
        msgbox % a_loopfilefullpath
        fileread, x,% a_loopfilefullpath
        if (pos := instr(x, string, case)){
            positions .= a_loopfilefullpath "|" pos
            while(pos := instr(x, string, case, pos+len))
                positions .= "|" pos
            positions .= "`n"
        }
    }
    return, positions
}

findstring(rec := "RFD"){

    inputbox, string, string,,
    inputbox, inp, folderpath,,, % "d:\(github)\globalcoder\gc\globalcoder"

    msgbox, % "about to search: `n" filepattern " `n for: " string
    filepattern := folderpath . "/" . filepattern
    len := strlen(string)
    if (len = 0)
        return
        
    loop, files, % filepattern,% rec
    {
        fileread, x,% a_loopfilefullpath
        if (pos := instr(x, string, case)){
            positions .= a_loopfilefullpath "|" pos
            while(pos := instr(x, string, case, pos+len))
                positions .= "|" pos
            positions .= "`n"
        }
    }
     return
}
;===//functions====================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]

;regexer

;RegExMatch(haystack, needle [, outputvar, startingpos)
;RegExReplaceh(haystack, needle, replacement, outputvarcount,limit,starting pos)

alterclipboard2(string, ReplaceWith := "", ToReplace*){
    outvar := ""
    oldstring := clipboard
    if replacewith := ""
        replacewith := a_space
    if clipboard = ""
        clipboard := string

    x := RegExMatch(clipboard, "O){", outvar)
    Msgbox, % "0: `n result:" x "-" OutVar

    y := RegExReplace(clipboard, "O){",";___", "outvar",-1, 1)
    clipboard := y
    MsgBox, % "1: `n replaced result: " y 
}

; want to pass in O){ , O)}, etc
alterClipboard(ReplaceWith := "", ToReplace*) {
    oldstring := clip := clipboard
    if ReplaceWith = ""
        ReplaceWith := A_Space

    for _, v in ToReplace {
        clip := StrReplace(clip, v, ReplaceWith)
    }
    clipboard := clip
}




RemoveComments(Line){
  If !(Pos := InStr(Trim(Line), ";"))
    Return Line             ; no quote character in this line

  If (Pos = 1)
    Return                  ; whole line is pure comment

  ;remove comments (first clean line of quotes strings)
  If (Pos := RegExMatch(RemoveQuotedStrings(Line), "\s+;.*$"))
    Line := SubStr(Line, 1, Pos - 1)

  Return Line
}

RemoveQuotedStrings(Line){
  ;the concept how to remove quoted strings was taken from CoCo's ListClasses script (line 77; http://ahkscript.org/boards/viewtopic.php?p=43349#p42793)
  ;replace quoted strings with dots and dashes to keep length of line constant, and that other character positions do not change
  static q := Chr(34)       ; quote character

  ;Replace quoted literal strings             1) replace two consecutive quotes with dots
  CleanLine := StrReplace(Line, q . q, "..")

  Pos := 1                                 ;  2) replace ungreedy strings in quotes with dashes
  Needle := q . ".*?" . q
  While Pos := RegExMatch(CleanLine, Needle, QuotedString, Pos){
    ReplaceString =
    Loop, % StrLen(QuotedString)
       ReplaceString .= "-"
    CleanLine := RegExReplace(CleanLine, Needle, ReplaceString, Count, 1, Pos)
  }
  Return CleanLine
}

; This is called any time any of the edit boxes on the RegExMatch tab are changed.
UpdateMatch:
    Gui Submit, NoHide
    
    if not IsInteger(mStartPos) {
        mStartPos := 1
        Gui Font, cRed 
        GuiControl Font, mStartPos
    }else {
        Gui Font, cDefault
        GuiControl Font, mStartPos
    }
    
    ;when needle is broken in several lines comments are stripped off every line and lines with text are concatenated
    LineArray := StrSplit(mNeedle, "`n", "`r")
    If (LineArray.MaxIndex() > 1) {
      tmp =
      For i, Line in LineArray
        If (CleanLine := RemoveComments(Trim(Line)))
          tmp .= CleanLine
      mNeedle := tmp
    }
    ; Set Needle to return an object ( O maybe set even twice)
    mNeedle := RegExReplace(mNeedle, "^(\w*)\)", "O$1)", cnt)
    if (! cnt) {
        mNeedle := "O)" mNeedle
    }

    If mLF
      mNeedle := "`n" mNeedle
    If mCR
      mNeedle := "`r" mNeedle
    If mAnyCRLF
      mNeedle := "`a" mNeedle    

    Match =
    FoundPos := RegExMatch(mHaystack, mNeedle, Match, mStartPos)
    if (ErrLvl := ErrorLevel) {
        Gui Font, cRed 
        GuiControl Font, mNeedle
        ResultText := "FoundPos: " FoundPos "`n" 
                    . "ErrorLevel: `n" ErrLvl "`n`n"
                    . "Needle: `n""" mNeedle """`n`n"
    }else {
        Gui Font, cDefault
        GuiControl Font, mNeedle
        ResultText := "FoundPos: " FoundPos "`n"
        ResultText .= "Match: " Match.Value() "`n"
                   . "Needle: `n""" mNeedle """`n`n"
        Loop % Match.Count() {
            ResultText .= "Match["
            ResultText .= (Match.Name[A_Index] = "") 
                        ? A_Index 
                        :  Match.Name[A_Index] 
            ResultText .= "]: " Match[A_Index] "`n"
                       
        }
    }
    
    GuiControl, , mResult, %ResultText%
return

; This is called any time any of the edit boxes on the RegExReplace tab are changed.
UpdateReplace:
    Gui Submit, NoHide
    
    If not IsInteger(rStartPos) {
        rStartPos := 1
        Gui Font, cRed 
        GuiControl Font, rStartPos
    }Else {
        Gui Font, cDefault
        GuiControl Font, rStartPos
    }
    
    If not IsInteger(rLimit) {
        rLimit := -1
        Gui Font, cRed 
        GuiControl Font, rLimit
    }Else {
        Gui Font, cDefault
        GuiControl Font, rLimit
    }
    
    ;when needle is broken in several lines comments are stripped off every line and lines with text are concatenated
    LineArray := StrSplit(rNeedle, "`n", "`r")
    If (LineArray.MaxIndex() > 1) {
      tmp =
      For i, Line in LineArray
        If (CleanLine := RemoveComments(Trim(Line)))
          tmp .= CleanLine
      rNeedle := tmp
    }

    If rLF
      rNeedle := "`n" rNeedle
    If rCR
      rNeedle := "`r" rNeedle
    If rAnyCRLF
      rNeedle := "`a" rNeedle    
    
    NewStr := RegExReplace(rHaystack, rNeedle, rReplacement, rCount, rLimit, rStartPos)
    If (ErrLvl := ErrorLevel) {
        Gui Font, cRed 
        GuiControl Font, rNeedle
        ResultText := "Count: " rCount "`n" 
                    . "ErrorLevel: `n" ErrLvl "`n`n"
                    . "Needle: `n""" rNeedle """`n`n"
    }Else {
        Gui Font, cDefault
        GuiControl Font, rNeedle
        ResultText := "Count: " rCount "`n" 
                    . "NewStr: `n" NewStr
    }
    
    GuiControl, , rResult, %ResultText%
return

MakeGui:
    Gui, +ReSize +MinSize
    Gui Font, s10, Consolas
    Gui Add, Tab2, r25 w430 vTabSelection, RegExMatch|RegExReplace
    
    Gui Tab, RegExMatch
        Gui Add, Text, , Text to be searched:
        Gui Add, Edit, r10 w400 vmHaystack gUpdateMatch
        Gui Add, Text, Section vmTxtRegEx, Regular Expression:  Option
        Gui Add, Checkbox, x+2 vmLF gUpdateMatch, ``n
        Gui Add, Checkbox, x+2 vmCR gUpdateMatch, ``r
        Gui Add, Checkbox, x+2 vmAnyCRLF gUpdateMatch, ``a
        Gui Add, Edit, xs r5 w305 vmNeedle gUpdateMatch
        Gui Add, Text, x+15 ys vmTxtStart, Start: (1)
        Gui Add, Edit, r1 w75 vmStartPos gUpdateMatch, 1
        Gui Add, Text, xs vmTxtResult, Results:
        Gui Add, Edit, r14 w400 +readonly -TabStop vmResult
        
    Gui Tab, RegExReplace
        Gui Add, Text, , Text to be searched:
        Gui Add, Edit, r10 w400 vrHaystack gUpdateReplace, 
        Gui Add, Text, Section vrTxtRegEx, Regular Expression:  Option
        Gui Add, Checkbox, x+2 vrLF gUpdateReplace, ``n
        Gui Add, Checkbox, x+2 vrCR gUpdateReplace, ``r
        Gui Add, Checkbox, x+2 vrAnyCRLF gUpdateReplace, ``a
        Gui Add, Edit, xs r5 w305 vrNeedle gUpdateReplace, 
        Gui Add, Text, vrTxtReplace, Replacement Text:
        Gui Add, Edit, r2 w305 vrReplacement gUpdatereplace,
        Gui Add, Text,  vrTxtResult, Results:
        Gui Add, Edit, r10 w400 +readonly -TabStop vrResult
        Gui Add, Text, ys xs+320 Section vrTxtStart, Start: (1)
        Gui Add, Edit, r1 w75 vrStartPos gUpdateReplace, 1
        Gui Add, Text, xs y+15 vrTxtLimit, Limit: (-1)
        Gui Add, Edit, r1 w75 vrLimit gUpdateReplace, -1
return

/*IsInteger(str) {
    if str is integer
        return true
    else
        return false
}*/

GuiSize(GuiHwnd, EventInfo, Width, Height){
  AutoXYWH("wh", "TabSelection")
  AutoXYWH("wh0.333", "mHaystack", "rHaystack")
  AutoXYWH("y0.3333", "mTxtRegEx", "rTxtRegEx", "mLF", "mCR", "mAnyCRLF", "rLF", "rCR", "rAnyCRLF")
  AutoXYWH("xy0.3333", "mTxtStart", "rTxtStart", "mStartPos", "rStartPos", "rTxtLimit", "rLimit", "", "")
  AutoXYWH("y0.3333wh0.333", "mNeedle", "")
  AutoXYWH("y0.6666", "mTxtResult", "rTxtResult")
  AutoXYWH("y0.6666wh0.333", "mResult", "rResult")
  
  AutoXYWH("y0.3333wh0.166", "rNeedle")
  AutoXYWH("y0.5wh0.166", "rReplacement")
  AutoXYWH("y0.5", "rTxtReplace", "")
}

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0 
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

;---------------------------------------------------------------------
; .captain
;------------------------------------------------------------------------------
captainHOTKEY:
MouseGetPos,mx,my,mwin,mctrl
SendMessage,0x84,,(my<<16)|mx,,ahk_id %mwin% ;WM_NCHITTEST=0x84
If ErrorLevel=2 ;HTCAPTION
GoSub, captainCHANGE
 ; Menu,menu,Show 
Return


MENU:
;Menu,menu,Add,&Copy caption,COPY
Menu,menu,Add,C&hange caption,captainCHANGE
Return


COPY:
WinGetTitle,title,ahk_id %mwin%
Clipboard:=title
TOOLTIP("Caption copied: " title)
Return


captainCHANGE:
WinGetTitle,title,ahk_id %mwin%
InputBox,newtitle,%applicationname%,New title:,,,,,,,,%title%
If ErrorLevel=0
  If (newtitle<>title)
  {
    WinSetTitle,ahk_id %mwin%,,%newtitle%
    ids:=ids . mwin ","
    title_%mwin%:=newtitle
    SetTimer,UPDATE,-1000
  }  
Return

UPDATE:
Loop,Parse,ids,`,
{
  IfWinNotExist,ahk_id %A_LoopField%
  {
    StringReplace,ids,ids,% A_LoopField ",",
    title_%A_LoopField%=
    Continue
  }
  WinGetTitle,ctitle,ahk_id %A_LoopField%
  If (ctitle<>title_%A_LoopField%)
    WinSetTitle,ahk_id %A_LoopField%,,% title_%A_LoopField%
}
SetTimer,UPDATE,-1000
Return


TOOLTIP(tip)
{
  ToolTip,%tip%
  SetTimer,TOOLTIPOFF,-3000
}

TOOLTIPOFF:
ToolTip,
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,Add, Recent Files, settingsrecent

Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

configure(){
; Ini is created in folder specified to be the home location
     
ini := ""
ini=
(
    [globalcoder]
iniroot=value
key2=value
key3=value
key4=value
key5=value
key6=value
key7=value
[counter]
appruns=1
key2=value
key3=value
captainhotkey=mButton 
)
inputbox, rootfolder ,, "Enter a complete path as root folder `n Right arrow to accept auto-suggest" ,,,,,,,, D:/code/test
if (!FileExist(rootfolder))
fileCreateDir, %rootfolder% 


rootpath = %rootfolder%
FileAppend,%ini%,%rootfolder%\%applicationname%.ini
IniWrite, %rootfolder% `;rootfolder, %rootfolder%, Settings, key1
IniWrite, %rootfolder% `;rootfolder, %rootfolder%\%applicationname%.ini, settings, iniroot
MsgBox, % "0: `n " rootfolder
fileCreateDir, %rootfolder% 
  
IniWrite, %rootfolder%/references `;references, %A_ScriptFullPath%, settings, key2
IniWrite, %rootfolder%/references `;references, %rootfolder%\%applicationname%.ini, settings, key2
IfnotExist, %rootfolder%/notes
FileCreateDir, %rootfolder%/references

IniWrite, %rootfolder%/notes `;notes, %A_ScriptFullPath%, settings, key3
IniWrite, %rootfolder%/notes `;notes, %rootfolder%\%applicationname%.ini, settings, key3
IfnotExist, %rootfolder%/notes
FileCreateDir, %rootfolder%/notes
_referencedir = %rootfolder%/references
_notesdir = %rootfolder%/references

;run(_referencedir)
inputbox,outvar, "lang ex: csharp,ahk" ,,,,,,,, autohotkey
IniWrite,%outvar%, %A_ScriptFullPath%, settings, lang
IniWrite, %outvar%, %rootfolder%\%applicationname%.ini, settings, lang
IniWrite, 1, %A_ScriptFullPath%, counter, key1
IniWrite, 1, %rootfolder%\%applicationname%.ini, counter, key1

MsgBox, % "0: `n will copy globalcoder to rootpath?: `n" rootpath "-"A_ScriptFullPath
;FileCopyDir, Source, Dest 
FileCopy, %A_ScriptFullPath%, %rootpath%

run(rootpath) 



;run(_referencedir)
ExitApp
return
}
/*
IniWrite,Tim,%A_desktop%\example.ini,Member1,Name
IniWrite,%AgeOfTim%,%A_desktop%\example.ini,Member1,Age
IniWrite,blue,%A_desktop%\example.ini,Member1,EyeColour

IniWrite,Tom,%A_desktop%\example.ini,Member2,Name
IniWrite,Age,%A_desktop%\example.ini,Member2,Age
IniWrite,green,%A_desktop%\example.ini,Member2,EyeColour

IniRead,Name,%A_desktop%\example.ini,Member1,Name ; You can use the same name as the output & key name
IniRead,Age,%A_desktop%\example.ini,Member1,Age
IniRead,EyeColour,%A_desktop%\example.ini,Member1,EyeColour

IniRead,Name2,%A_desktop%\example.ini,Member2,Name
IniRead,Age2,%A_desktop%\example.ini,Member2,Age
IniRead,EyeColour2,%A_desktop%\example.ini,Member2,EyeColour

MsgBox % "Member1: " Name
             . "His age: " Age
             . "His eye colour: " eyecolour
             . "Member2: " Name2
             . "His age: " Age2
             . "His eye colour: " eyecolour2
;IniDelete,%A_desktop%\example.ini,Member1
;IniDelete,%A_desktop%\exmaple.ini,Member2 ; ini is now emptey


  ;send, inputbox,, root folder? ,,,,,,,, d:/code
  ;send, inputbox,, primary ide? ,,,,,,,, autofill-prompt"
  ;send, inputbox,, message ,,,,,,,, autofill-prompt"
  ;send, inputbox,, message ,,,,,,,, autofill-prompt"
  ;send, inputbox,, message ,,,,,,,, autofill-prompt"



    ;MsgBox, % " ^1 means ctrl + 1 will activate the key block `n i.e press ^1 to start setup of c# project" 
    ;MsgBox, % " ^esc  auto-reloads/'aborts' current thread "
    return
}
*/


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
[Settings]
iniroot=value
key2=value
key3=value
key4=value
key5=value
key6=value
key7=value
[counter]
appruns=1
key2=value
key3=value
captainhotkey=mButton 
; Ini is created in folder where first ran
)

; Ini is created in folder specified to be the home location
;configure()
  return
}

IniRead,iniroot, %rootfolder%\%applicationname%.ini, Settings, iniroot
IniRead,appruns, %applicationname%.ini, Counter
IniRead,captainhotkey,%applicationname%.ini,Counter,captainhotkey


;IniWrite, %ini%, A_ScriptFullPath, SelfSettings, Key
;MsgBox, % "0: `n selfsettings: `n " ini
if (iniroot = "value"){
;configure()
MsgBox, % "0: `n will copy globalcoder to rootpath?: `n" roopath
if ErrorLevel exitapp
FileCopy, A_ScriptFullPath, rootpath ,
run(rootpath) 
}
return

;iff all is norm - load ini vars here



;IniRead, OutputVar, Filename, Section, Key [, Default]
;Hotkey, KeyName [, Label, Options]
;Hotkey,%captainhotkey%,captainHOTKEY,On
;MsgBox, % "0: `n " captainhotkey " on`n val: " captainhotkey
/*
[SelfSettings]
key=value

*/

SETTINGS:
Hotkey,%hotkey%,HOTKEY,Off
Gui,Destroy
FileRead,ini,%applicationname%.ini
Gui,Font,Courier New
Gui,Add,Edit,Vnewini -Wrap W400,%ini%
Gui,Font
Gui,Add,Button,GSETTINGSOK Default W75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
FileDelete,%applicationname%.ini
FileAppend,%newini%,%applicationname%.ini
Gosub,INIREAD
Return


GuiEscape:
GuiClose:

SETTINGSCANCEL:
Gui,Destroy
;Hotkey,%hotkey%,HOTKEY,On
Return





ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Copy and change a window's title
Gui,99:Add,Text,y+5,- Use the middle mousebutton on a window's caption
Gui,99:Add,Text,y+5,- Change hotkey using Settings in the tray menu

Gui,99:Add,Picture,xm y+20 Icon5,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,99:Font
Gui,99:Add,Text,y+10,For more tools, information and donations, please visit 
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,DonationCoder
Gui,99:Font
Gui,99:Add,Text,y+10,Please support the contributors at
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:+AlwaysOnTop
Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

1HOURSOFTWARE:
  Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
  Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return



WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCurs)
  Return
}







;;;-------- classses

class tool{
;__new(Item, ppath:="")
;check() 
;givevalues(x := "") 
;readfile(ath := "")
;showfile(data := "")
;savetofile()
;total()

static tooltotal := 1
static frontproject := "c:\tester"

    __New(Item,type,ppath := "", unit := "",price:= "",stock:= 0,source:= ""){
        tool.tooltotal++

        items := this.items := {}
        item := this.item 
        ppath := this.ppath 
        unit := this.unit 
        Price := this.price 
        stock := this.stock 
        source := this.source

        if (ppath){
            this.ppath := A_Desktop . "\" . ppath . ".txt"
            this.frontproject := this.ppath
        } else {
            this.ppath :=  A_Desktop . "\project.txt"
            this.frontproject := this.ppath
        }

        tool.frontproject := this.frontproject
        

        if !FileExist(this.ppath){
            FileAppend, % "`n" item "," DateTime,  this.ppath
            ;MsgBox, % "5: `n didnt exist, created: " this.ppath "`n appended: " item 
        }
        ;MsgBox, % "0: `n  already existed"
        if (item = "screwdriver"){
            this.timetounscrew := 7.5
        } else if(item = "powerdriver"){
            this.timeToUnscrew := 5 
            ;MsgBox, % "0: `n passed in a powerdriver: " this.timetoUnscrew
        }

        ;static price :=
        ;return timeToUnscrew
    }

     addItems(param_x := 0) {
        this.stock += param_x
    }
    check(){
        MsgBox, % "10: `n tool.frontproject: " tool.frontproject . "10: `n this.frontproject: " this.frontproject . "10: `n frontproject: " frontproject . "2: `n " this.timeToUnscrew " seconds"
        return 
    }

    givevalues(item, x := 0){
       ; item := this.item := {}
       if (this.HasKey(item) == false){

       ;if (!IsObject(this.item)) {
        this.items.push(item) := {}
        this.item := item := {"name": item, "quantity": x}
        msgbox % this.item.quantity " " item.name "'s added!" this.item.name

        for k,v in this.item 
        msgbox % k ":" v
        return this.item
        }
        


        if (this.item.quantity != "")
         {
        msgbox, % this.item.quantity " " this.item.name "'s `n exist, so add to it"

           this.item.quantity +=  x
           ; this.item.quantity := this.item + x 
            msgbox, % this.item.quantity "`n object existed"
            return this.item ;.quantity
        }

        tool.frontproject := this.frontproject
        ;msgbox % item
      
        item.quantity := x 
        msgbox, % item.quantity "`n object didnt exist yet"

        return this.item
    }

    
    readfile(path := ""){
        tool.frontproject := this.frontproject

        if this.ppath != "" or fileexist(A_Desktop . this.ppath)
        {
            MsgBox, % "9: `n " this.frontproject
          MsgBox, % "0: `n " this.ppath
            this.frontproject := "c:\test"
            ;this.filepath := "C:\Users\dkzea\OneDrive\Desktop" . path
            this.filepath := path
            FileRead, Contents, % "C:\Users\dkzea\OneDrive\Desktop" . path ;A_Desktop "/Test.txt"
            StringReplace, Contents, Contents, `r,, All ; makes sure only `n separates the lines
            aFile := {}
           
            Loop, Parse, contents , `n
                {
                temp_arr := StrSplit(a_loopfield, ",") ;StrSplit(String, [Delimiters, OmitChars])
                afile[temp_arr [1]] := temp_arr[2] ;whatever temp_arr[1] is, becomes the key for afile i.e, afile[notepadLine1] := notepadLine2
                afile.path := "C:\Users\dkzea\OneDrive\Desktop" . path
                }
            return aFile
                }
            else 
                {
            MsgBox, % "0: `n it didn't read the file, path inside object method trip.readfile() is: " path 
            , "`n maybe it already exists"
            return
                }
            }

    showfile(data := "item"){
        tool.frontproject := this.frontproject

        for k,v in %data%
        {
        MsgBox, % "4: `n " k "-" v
        eachvalue .= v
        total += v 
        }
        Gui,+AlwaysOnTop ;Sets the Gui as forward priority in the window hierarchy.
        Gui, Color, 000000 ;Sets the Gui color to black
        Gui, +Delimiterspace
        Gui, Add, DropDownList,, %total%
        Gui, Add, DropDownList,, %eachvalue%
        Gui, Add, Button, x5 y370 w290 gSaveExit, Save and Exit
        Gui, Show

        saveexit:
        msgbox % "press ok to exit"

        return
        return total
        }
    savetofile(data,ppath := ""){

        tool.frontproject := this.frontproject
        FileAppend,  % "`n" data . "," . DateTime  , % this.ppath

        MsgBox, % "0: `n " data
        MsgBox, % "0: `n " this.ppath
        MsgBox, % "6: `n " this.filepath
      

        return
        }
    total(){
            tool.frontproject := this.frontproject

            for k,v in data
        {
            MsgBox, % "4: `n " k "-" v
            eachvalue .= v
            total += v 
            key3=testvalue
        }
        return
        }

}