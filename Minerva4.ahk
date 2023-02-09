#SingleInstance Force
/*

   Name ...........: Minerva
   Description ....: Will generate a context menu from which to insert text, launch shortcuts and much more
   AHK Version ....: AHK_L 1.1.33.10 (Unicode 32-bit) - 28-12-2021
   Platform .......: Tested on Windows 11 22H2
   Language .......: English (en-US)
   Author .........: Jonas Vollhaase Mikkelsen <Mikkelsen.v.jonas@gmail.com>
   Documentation ..: Github.com
*/

;----------------------------------------------| VARIABLES |---------------------------------------------;
FileEncoding, UTF-8
global ScriptName  := StrReplace(A_ScriptName, ".ahk")
global Version     := "4.0.2"
global GitHub      := "https://github.com/bforbenny/Minerva"
global FileCount   := 0
global MyProgress  := 0
global TotalWords  := 0
global settingsINI := "settings.ini"
global ignoreFiles := ""

; comment if Gdip.ahk is in your standard library
#Include, includes\Gdip.ahk 			
#Include, includes\read-ini.ahk	
#Include, includes\JXON.ahk
#Include, includes\Minerva-PowerToys.ahk
#Include, includes\Minerva-Handlers.ahk
#Include, includes\Minerva-Statistics.ahk

; Read settings.ini file
ReadIni(settingsINI)

setUpHotkey(HotKeys_OpenMinervaMenu, "showMinervaMenu", "%settingsINI% [HotKeys]OpenMinervaMenu")
setUpHotkey(HotKeys_ReloadProgram,   "ReloadProgram",   "%settingsINI% [HotKeys]ReloadProgram")
ignoreFiles := General_IgnoreFiles

; Check Update
if General_CheckUpdate
	CheckUpdate()

; Change tray icon from default
Menu, Tray, Icon, %A_ScriptDir%\icon\icon.ico

; Get amount of items in folder and prepare the menu
global FileCount := getItemCount()

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
pBitmap := Gdip_CreateBitmapFromFile("Icon\Hourglass.png")
Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)

; Graphic has at this point been drawn, but view is not yet updated. Waiting to update view until script is called
return

; CODE AUTO-EXECUTE ENDS HERE

;------------------------------------------------| MENU |------------------------------------------------#
PrepareMenu(PATH)
{
	global
		
	; GUI loading/progress bar
	Gui, new, +ToolWindow, % ScriptName " is Loading"		; Adding title to progressbar
	Gui, add, Progress, w200 vMyProgress range1-%FileCount%, 0	; Adding progressbar
	Gui, show	  											; Displaying Progressbar

	; Add Name, Icon and seperating line
	Menu, %PATH%, Add, % ScriptName " v " Version, About									; Name
	Menu, %PATH%, Icon,% ScriptName " v " Version, %A_ScriptDir%\Icon\Minerva-logo.png 		; Logo
	Menu, %PATH%, Add, 																			; seperating 
		
	; Add all custom items using algorithm 
	LoopOverFolder(Path)

	; Sleep, 200
	Menu, %PATH%, Add, 	; seperating line 
	; PowerToys
	if ( initPowerToys(General_PowerToys) ){
		callPT_AOT := Func("sendPowerToysKey").Bind("AlwaysOnTop")
		callPT_CP := Func("sendPowerToysKey").Bind("ColorPicker")
		callPT_FZ := Func("sendPowerToysKey").Bind("FancyZones")
		callPT_MT := Func("sendPowerToysKey").Bind("Measure Tool")
		callPT_OCR := Func("sendPowerToysKey").Bind("TextExtractor")

		Menu, %PATH%"\PowerToys", Add, Always On Top, % callPT_AOT
		Menu, %PATH%"\PowerToys", Add, Color Picker, % callPT_CP
		Menu, %PATH%"\PowerToys", Add, Fancy Zones, % callPT_FZ
		Menu, %PATH%"\PowerToys", Add, Screen Ruler, % callPT_MT
		Menu, %PATH%"\PowerToys", Add, Text Extractor, % callPT_OCR

		Menu, %PATH%, Add, PowerToys, :%PATH%"\PowerToys"
		Menu, %PATH%, Icon, PowerToys, %A_ScriptDir%\Icon\PowerToys-logo.png 
	}

	; Add Admin Panel
	Menu, %PATH%"\Admin", Add, &1 Reload, ReloadProgram				; Add Reload option
	Menu, %PATH%"\Admin", Add, &2 Exit, ExitApp							; Add Exit option
	Menu, %PATH%"\Admin", Add, &3 Go to Parent Folder, GoToRootFolder	; Open script folder
	Menu, %PATH%"\Admin", Add, &4 Add Custom Item, GoToCustomFolder		; Open custom folder
	Menu, %PATH%"\Admin", Add, 
	Menu, %PATH%"\Admin", Add, Check for Update, CheckUpdate		; Open custom folder

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
		if (VALUE = "D" or VALUE="AD")
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
		Menu, %dir%, Icon, %name%, C:\Windows\syswow64\SHELL32.dll , 5
		
		; Iterate loading GUI progress
		FoundItem("Folder")
	}
	
	; Then add all files to folders
	for index, element in FileArray
	{
		; Add To Menu
		SplitPath, element, name, dir, ext, name_no_ext, drive

		vaar := InStr(ignoreFiles, name , 0 )
		if InStr(ignoreFiles, name , 0 ) = 0{
			Menu, %dir%, Add, %name%, MenuEventHandler
			
			switch ext{
				case "ahk":
					Menu, %dir%, Icon, %name%, %A_ScriptDir%\Icon\ahk-logo.jpg

				case "bat":
					Menu, %dir%, Icon, %name%, C:\Windows\syswow64\SHELL32.dll , 3
					
				case "exe":
					Menu, %dir%, Icon, %name%, C:\Windows\syswow64\SHELL32.dll , 3

				default:
					Menu, %dir%, Icon, %name%, C:\Windows\syswow64\SHELL32.dll , 1
			}

		}
		
		; Iterate GUI loading
		FoundItem("File")
	}
}


;-----------------------------------------------| HOTKEYS |----------------------------------------------;
; Bring up Minerva Menu
;Ctrl & RShift::
showMinervaMenu(){
	WinGet, active_proc, ProcessName, A
	Try{
		Menu, %A_ScriptDir%\CustomMenuFiles, Check, %active_proc%
	}
	Menu, %A_ScriptDir%\CustomMenuFiles, show
	Try{
		Menu, %A_ScriptDir%\CustomMenuFiles, UnCheck, %active_proc%
	}
}


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
		case "rtf" : Handler_COM(FilePath)
		case "docx": Handler_COM(FilePath)
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


; Recursively 
getItemCount()
{
	local itemCount := 0

	Loop, Files, %A_ScriptDir%\*, FR
	{
		itemCount += 1
	} 

	return itemCount
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
About()
{
	run, % GitHub
}

CheckUpdate(){
	UrlDownloadToFile, %GitHub%/releases, %TEMP%\releases.html
	FileRead, releasehtml, %TEMP%\releases.html

	RegExMatch(releasehtml, "/bforbenny/Minerva/releases/tag/v.+?.*>Minerva v\K[\d.]+", GHversion)

	if GHVersion > %Version%
	{
	   MsgBox, Update v %GHVersion% available (installed v %Version%).
	   ifMsgBox OK
	   {
			About()
	   }
	}
}