#SingleInstance Force
;===================================================== Seldom Changing Directives 
#Requires AutoHotkey v1.1.34.03
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
;===================================================== Sometimes Changing Directives
SetKeyDelay, 50
Menu, Tray, Icon , Shell32.dll, 14 , 1
TrayTip, GlobalCoder, Started %nowtime%
Sleep 800   ; Let it display for 3 seconds.
HideTrayTip()
FormatTime, nowtime , YYYYMMDDHH24MISS, MMdd--HHmm
;=====================================================
Gui, Font,Q4, MS Sans Serif ;opts-> (c)olor (s)ize (w)eight (Q)uality
Gui, Font,, Arial
Gui, Font,, Verdana  ; Preferred font.

applicationname := "GlobalCoder"

;----------------------------------------------| VARIABLES |---------------------------------------------;
FileEncoding, UTF-8
global ScriptName := "GlobalCoder"
global Version    := "1.0"
global items	  := 0
global MyProgress := 0
Global TotalWords := 0

; comment if Gdip.ahk is in your standard library
#Include, includes\singles\Gdip.ahk 				



; Get amount of items in folder and prepare the menu
FindAmountItems()	
PrepareMenu(A_ScriptDir "\CustomMenuFiles") 

; Run other scripts in the "IncludeOtherScripts" folder
RunOtherScripts(A_ScriptDir "\IncludeOtherScripts")

; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

Width  := A_ScreenWidth
Height := A_ScreenHeight
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs 
Gui, 1: Show, NA

; Intro taken from GDIP library introduction, see https://github.com/tariqporter/Gdip/blob/master/Gdip.ahk
hwnd1 := WinExist() 						; Get a handle to this window we have created in order to update it later
hbm   := CreateDIBSection(Width, Height) 	; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
hdc   := CreateCompatibleDC() 				; Get a device context compatible with the screen
obm   := SelectObject(hdc, hbm) 			; Select the bitmap into the device context
G     := Gdip_GraphicsFromHDC(hdc) 			; Get a pointer to the graphics of the bitmap, for use with drawing functions
Gdip_SetSmoothingMode(G, 4) 				; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)

; Create a slightly transparent gray brush to draw rectagle with
pBrush 	:= Gdip_BrushCreateSolid(0x80C7C7C7) 
Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)

; Create Hourglass image and draw it onto screen
pBitmap := Gdip_CreateBitmapFromFile("includes\graphics\globe.png")
Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2, A_ScreenHeight, Width/2, Height/2, 0, 0, Width, Height)

; Graphic has at this point been drawn, but view is not yet updated. Waiting to update view until script is called
;This is the first example of text inserted from Minerva.



return

; CODE AUTO-EXECUTE ENDS HERE

;------------------------------------------------| MENU |------------------------------------------------#
PrepareMenu(PATH)
{
	global
		
	; GUI loading/progress bar
	Gui, new, +ToolWindow, % ScriptName " is Loading"		; Adding title to progressbar
	Gui, add, Progress, w200 vMyProgress range1-%items%, 0	; Adding progressbar
	Gui, show	  											; Displaying Progressbar

	; Add Name, Icon and seperating line
	Menu, %PATH%, Add, % ScriptName " vers. " Version, Github									; Name
	Menu, %PATH%, Add, 																			; seperating 
		
	; Add all custom items using algorithm 
	LoopOverFolder(Path)

	; Add Admin Panel
	Sleep, 200
	Menu, %PATH%, Add, 													; seperating line 
	Menu, %PATH%"\Admin", Add, &1 Restart, ReloadProgram				; Add Reload option
	Menu, %PATH%"\Admin", Add, &2 Exit, ExitApp							; Add Exit option
	Menu, %PATH%"\Admin", Add, &3 Go to Parent Folder, GoToRootFolder	; Open script folder
	Menu, %PATH%"\Admin", Add, &4 Add Custom Item, GoToCustomFolder		; Open custom folder
	Menu, %PATH%, Add, &0 Admin, :%PATH%"\Admin"						; Adds Admin section

	; Loadingbar GUI is no longer needed, remove it from memory
	Gui, Destroy 
}

;---------------------------------------| FOLDER ADDING ALGORITHM |--------------------------------------;

; From the perspective of a folder, items are read top to bottom, but AHK Expects menus to be build from bottom to top.
; Therefore; recurse into the most bottom element, note all the elements on the way there, and build from bottom up
LoopOverFolder(PATH)
{
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
	
	; First add all folders, so files have a place to stay
	for index, element in FolderArray
	{
		; Recurse into next folder
		LoopOverFolder(element)
		
		; Then add it as item to menu
		SplitPath, element, name, dir, ext, name_no_ext, drive
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


;-----------------------------------------------| HOTKEYS |----------------------------------------------;

; Bring up Minerva Menu
^f24::
Ctrl & RShift::
CoordMode Menu, Screen
GetCaret(X, Y,, H)
;Menu, MyMenu, Show, % X, % Y + H
Menu, %A_ScriptDir%\CustomMenuFiles, show , % X, % Y + H
return

; Reload program if Graphics for whatever reason does not work
LShift & Delete::
	Reload
return


;-----------------------------------------------| LABELS |-----------------------------------------------#;
; Labels are a simple .AHK implementation of Functions (which .AHK also supports), but only labels are supported some places - like in menus.
; See more here: https://www.autohotkey.com/board/topic/25097-are-there-any-advantages-with-labels-over-functions/

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


;----------------------------------------------| FUNCTIONS |---------------------------------------------;
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
        return
    }
}
f24 & F1::
CoordMode Menu, Screen
GetCaret(X, Y,, H)
Menu, MyMenu, Add, Menu Item 1, GoMenuHandler
Menu, MyMenu, Add, Menu Item 2, GoMenuHandler
Menu, MyMenu, Add, Menu Item 3, GoMenuHandler
Menu, MyMenu, Show, % X, % Y + H
gui, menu, mymenu
f24 & f2::

; Create the main Edit control and display the window:
Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit, vMainEdit WantTab W300 R20
Gui, Add, Button, gGoButton1, Go Button
Gui, Show, ,% X, % Y + H, Functions instead of labels
CurrentFileName := ""  ; Indicate that there is no current file.
return 



BoundGivePar := Func("GivePar").Bind("First", "Test one")
BoundGivePar2 := Func("GivePar").Bind("Second", "Test two")

f24 & 3::
; Create the menu and show it:
Menu MyMenu, Add, Give parameters, % BoundGivePar
Menu MyMenu, Add, Give parameters2, % BoundGivePar2
Menu MyMenu, Show
return
; Definition of custom function GivePar:
GivePar(a, b, ItemName, ItemPos, MenuName)
{
    MsgBox % "a:`t`t" a "`n"
           . "b:`t`t" b "`n"
           . "ItemName:`t" ItemName "`n"
           . "ItemPos:`t`t" ItemPos "`n"
           . "MenuName:`t" MenuName
           return
       }
 



^F1::google(1) ; Regular search
^F2::google(2) ; Images search
^F3::google(3) ; Maps search
^F4::google(4) ; Translation


f24 & g::
;Gui, Add, Button, gCtrlEvent vButton1, Button 1
;Gui, Add, Button, gCtrlEvent vButton2, Button 2
Gui, Add, Button, gGoButton, Go Button
Gui, Add, Edit, w300 hvEditField, Example text
Gui, Show,, Functions instead of labels
return

CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, Go has been clicked! The content of the edit field is "%EditField%"!
}

GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
return

;----------------------------------------------| FUNCTIONS |---------------------------------------------;

google(service := 1){
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
    else query := Clipboard
    Run % urls[service] query
    Clipboard := backup
}


; Definition of custom function GivePar:
/*GivePar(a, b, ItemName, ItemPos, MenuName){
    MsgBox % "a:`t`t" a "`n"
           . "b:`t`t" b "`n"
           . "ItemName:`t" ItemName "`n"
           . "ItemPos:`t`t" ItemPos "`n"
           . "MenuName:`t" MenuName
}
*/

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


; ---- GoButton1 ---
CtrlEvent1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GoButton1(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, % "Entered: " EditField "`n decide where it goes..."
    clipboard := editfield

}
GuiClose1(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}



; ---- Handlers ----

; Case not known; try to open the file
Handler_Default(PATH){
	Handler_LaunchProgram(PATH)
}

; contents of .txt should be copied to clipboard and pasted. This is fast.
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

; If program is executable, simply launch it
Handler_LaunchProgram(FilePath)
{
	run, %FilePath%
}

; .rtf files should be opened with a ComObject, that silently opens the file and copies the formatted text. Then paste
Handler_RTF(FilePath)
{
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

Handler_Settings(filepath){
return
}
Handler_hotstrings(filepath){
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



; ---- Other Functions ----
; Amountfile is a .csv that the user can use to see how much info was saved. 
AddAmountFile(FileName, WordCount)
{
	; Average Typing speed is 40 wpm pr. https://www.typingpal.com/en/typing-test
	MinutesSaved := WordCount / 40
	
	; It will look like 28-12-2021 13:23
	FormatTime, CurrentDateTime,, dd-MM-yyyy HH:mm 
	
	; Check if file already exists. All other times than the very first run, it will exist.
	; If if not, create it and append, otherwise just append
	if FileExist("AmountUsed.csv") 					
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
GetWordCount()
{
	Global TotalWords := 0
	Loop, parse, clipboard, %A_Space%,
	{
		TotalWords = %A_Index%
	}
}

; Recursively 
FindAmountItems()
{
	Loop, Files, %A_ScriptDir%\*, FR
	{
		global items := items+ 1
	} 
}

; Iterate step of the GUI process bar by one
FoundItem(WhatWasFound)
{
	global
	GuiControl,, MyProgress, +1

	; Comment in for Debug
	;~ Sleep, 50
	;~ MsgBox, % "Found " WhatWasFound ": " A_LoopFileName "`n`nWith Path:`n" A_LoopFileFullPath "`n`nIn Folder`n" A_LoopFileDir
}

; Restarts the program. This is handy for updates in the code
ReloadProgram()
{
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
GoToRootFolder()
{
    run, explore %A_ScriptDir%
}

; Opens explorer window in folder where custom folders and menu item goes
GoToCustomFolder()
{
	run, explore %A_ScriptDir%\CustomMenuFiles
}

; Launch Github repo
Github()
{
	run, https://github.com/donovanzeanah
}

; Attemps to start all other files in the specified path.
RunOtherScripts(PATH)
{
	Loop, Files, %PATH%\* , F
	{
		;~ MsgBox, % "Including:`n" A_LoopFilePath
		run, %A_LoopFilePath%
	}
}
