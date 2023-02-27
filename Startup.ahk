; AHK Startup
; Fanatic Guru
;
; Version: 2022 11 07
;
; Startup Script for Startup Folder to Run on Bootup.
;{-----------------------------------------------
; Runs the Scripts Defined in the Files Array
; Removes the Scripts' Tray Icons leaving only AHK Startup
; Creates a ToolTip for the One Tray Icon Showing the Startup Scripts
; If AHK Startup is Exited All Startup Scripts are Exited
; Includes a "Load" menu for a list of scripts that are not currently loaded
;}

; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force  ; Ensures that only the last executed instance of script is running
DetectHiddenWindows, On
;}

; INITIALIZATION - VARIABLES
;{-----------------------------------------------
;
; Folder: all files in that folder and subfolders
; Relative Paths: .\ at beginning is the folder of the script, each additional . steps back one folder
; Wildcards: * and ? can be used
; Not Loaded scripts have "/noload" to the right, can use tabs for readability
Files := [	; Additional Startup Files and Folders Can Be Added Between the ( Continuations  ) Below
(Join,
"C:\Users\Guru\Documents\AutoHotkey\Startup\"
"C:\Users\Guru\Documents\AutoHotkey\Compiled Scripts\*.exe"
A_MyDocuments "\AutoHotkey\My Scripts\Hotstring Helper.ahk"
"C:\Users\Guru\Documents\AutoHotkey\My Scripts\Calculator.ahk"
".\Web\Google Search.ahk"
"..\Dictionary.ahk"
"Hotkey Help.ahk"
"MediaMonkey.ahk"		"/noload"
)]
;}

; AUTO-EXECUTE
;{-----------------------------------------------
;
if FileExist(RegExReplace(A_ScriptName,"(.*)\..*","$1.txt")) ; Look for text file with same name as script
	Loop, Read, % RegExReplace(A_ScriptName,"(.*)\..*","$1.txt")
		if A_LoopReadLine
			Files.Insert(A_LoopReadLine)

Scripts := {}
For index, File in Files
{
	if (SubStr(File, -6) = "/noload")
		Status := false
	else
		Status := true
	File := RegExReplace(File, "/noload$")
	RegExMatch(File,"^(\.*)\\",Match), R := StrLen(Match1) ; Look for relative pathing
	if (R=1)
		File := A_ScriptDir SubStr(File,R+1)
	else if (R>1)
		File := SubStr(A_ScriptDir,1,InStr(A_ScriptDir,"\",,0,R-1)) SubStr(File,R+2)

	if RegExMatch(File,"\\$") ; If File ends in \ assume it is a folder
		Loop, %File%*.*,,1 ; Get full path of all files in folder and subfolders
		{
			SplitPath, % A_LoopFileFullPath,,,, Script_Name
			Scripts[Script_Name, "Path"] := A_LoopFileFullPath
			Scripts[Script_Name, "Status"] := Status
		}
	else
		if RegExMatch(File,"\*|\?") ; If File contains wildcard
			Loop, %File%,,1 ; Get full path of all matching files in folder and subfolders
			{
				SplitPath, % A_LoopFileFullPath,,,, Script_Name
				Scripts[Script_Name, "Path"] := A_LoopFileFullPath
				Scripts[Script_Name, "Status"] := Status
			}
		else
		{
			SplitPath, % File,,,, Script_Name
			Scripts[Script_Name, "Path"] := File
			Scripts[Script_Name, "Status"] := Status
		}
}

; Run All the Scripts with Status true, Keep Their Pid
for Script_Name, Script in Scripts
{
	if !Script.Status
		continue
	; Use same AutoHotkey version to run scripts as this current script is using
	; Required to deal with 'launcher' that was introduced when Autohotkey v2 is installed
	; Requires literal quotes around variables to handle spaces in file paths/names
	Run, % """" A_AhkPath """ """ Script.Path """",,, Pid
	Scripts[Script_Name,"Pid"] := Pid
}

OnExit, ExitSub ; Gosub to ExitSub when this Script Exits

; Build Menu and TrayTip then Remove Tray Icons
gosub TrayTipBuild
gosub MenuBuild
TrayIconRemove(10)

;
;}-----------------------------------------------
; END OF AUTO-EXECUTE

; HOTKEYS
;{-----------------------------------------------
;
~#^!Escape::ExitApp ; <-- Terminate Script
;}

; SUBROUTINES
;{-----------------------------------------------
;
TrayTipBuild:
	Tip_Text := ""
	for Script_Name, Script in Scripts
		if Script.Status
			Tip_Text .= Script_Name "`n"
	Sort, Tip_Text
	Tip_Text := TrimAtDelim(Trim(Tip_Text, " `n"))
	Menu, Tray, Tip, %Tip_Text% ; Tooltip is limited to first 127 characters
return

; Stop All the Scripts with Status true (Called When this Scripts Exits)
ExitSub:
	for Script_Name, Script in Scripts
	{
		WinGet, hWnds, List, % "ahk_pid " Script.Pid
		Loop % hWnds
		{
			hWnd := hWnds%A_Index%
			WinKill, % "ahk_id " hWnd
		}
	}
	ExitApp
return
;}

; SUBROUTINES - GUI
;{-----------------------------------------------
;
MenuBuild:
	try Menu, SubMenu_Load, DeleteAll ; SubMenu_Load does not always exist
	Menu, Tray, DeleteAll
	for Script_Name, Script in Scripts
		if Script.Status
		{
			PID := Script.PID
			try Menu, SubMenu_%PID%, DeleteAll
			Menu, SubMenu_%PID%, Add, View Lines, ScriptCommand
			Menu, SubMenu_%PID%, Add, View Variables, ScriptCommand
			Menu, SubMenu_%PID%, Add, View Hotkeys, ScriptCommand
			Menu, SubMenu_%PID%, Add, View Key History, ScriptCommand
			Menu, SubMenu_%PID%, Add
			Menu, SubMenu_%PID%, Add, &Open, ScriptCommand
			Menu, SubMenu_%PID%, Add, &Edit, ScriptCommand
			Menu, SubMenu_%PID%, Add, &Reload, ScriptCommand
			Menu, SubMenu_%PID%, Add, &Exit, ScriptCommand
			Menu, Tray, Add, %Script_Name%, :SubMenu_%PID%
		}
		else
			Menu, SubMenu_Load, Add, % Script_Name, ScriptCommand_Load

	Menu, Tray, NoStandard
	Menu, Tray, Add
	try Menu, Tray, Add, Load, :SubMenu_Load ; SubMenu_Load does not always exist
	Menu, Tray, Standard
	try Menu, Tray, Default, Load ; SubMenu_Load does not always exist
return

ScriptCommand:
	Cmd_Open			= 65300
	Cmd_Reload			= 65400
	Cmd_Edit			= 65401
	Cmd_Exit			= 65405
	Cmd_ViewLines		= 65406
	Cmd_ViewVariables	= 65407
	Cmd_ViewHotkeys		= 65408
	Cmd_ViewKeyHistory	= 65409
	Pid := RegExReplace(A_ThisMenu,"SubMenu_(\d*)$","$1") ; each SubMenu name included Pid
    cmd := RegExReplace(A_ThisMenuItem, "[^\w#@$?\[\]]") ; strip invalid chars

	; if Cmd_Reload, simulate by exiting and running again with captured Pid
	if (cmd = "Reload")
	{
		for Script_Name, Script in Scripts ; find Script by Pid
			if (Script.Pid = Pid)
				break
		Menu, SubMenu_%PID%, DeleteAll ; delete Tray SubMenu of old Pid (use 'try' just in case)
		PostMessage, 0x111, Cmd_Exit,,,ahk_pid %Pid%
		Run, % """" A_AhkPath """ """ Script.Path """",,, Pid ; specify Autohotkey version
		Scripts[Script_Name,"Pid"] := Pid
		gosub MenuBuild ; need to rebuild menu because changed Pid is used in menu names
		TrayIconRemove(8) ; need to remove new icon
	}
	else
	{
		cmd := Cmd_%cmd%
		PostMessage, 0x111, %cmd%,,,ahk_pid %Pid%
	}

	; If Cmd_Exit then Set Status to false
	if (cmd = 65405)
	{
		for Script_Name, Script in Scripts
			if (Script.Pid = Pid)
				break
		Scripts[Script_Name, "Status"] := false

		; Rebuild Menu and TrayTip
		gosub MenuBuild
		gosub TrayTipBuild
	}
return

ScriptCommand_Load:
	; Run Script and Keep Info
	Run, % """" A_AhkPath """ """ Scripts[A_ThisMenuItem].Path """",,, Pid ; specify Autohotkey version
	Scripts[A_ThisMenuItem, "Pid"] := Pid
	Scripts[A_ThisMenuItem, "Status"] := true

	; Rebuild Menu and TrayTip then Remove Tray Icon
	gosub MenuBuild
	gosub TrayTipBuild
	TrayIconRemove(8)
return

;}

; FUNCTIONS
;{-----------------------------------------------
;
TrayIconRemove(Attempts)
{
	global Scripts
	Tray_Icons := {}
	Loop, % Attempts	; Try To Remove Over Time Because Icons May Lag Especially During Bootup
	{
		Tray_Icons := TrayIcon_GetInfo()
		for Script_Name, Script in Scripts
			if Script.Status
				for index, Icon in Tray_Icons
					If (Script.Pid = Icon.Pid)
						TrayIcon_Remove(Icon.hWnd, Icon.uID)
		Sleep A_index**2 * 200
	}
	return
}

TrimAtDelim(String,Length:=124,Delim:="`n",Tail:="...")
{
	if (StrLen(String)>Length)
		RegExMatch(SubStr(String, 1, Length+1),"(.*)" Delim, Match), Result := Match Tail
	else
		Result := String
	return Result
}
;}


; FUNCTIONS - LIBRARY
;{-----------------------------------------------
;
TrayIcon_GetInfo(sExeName := "")
{
	DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
	oTrayIcon_GetInfo := {}
	For key, sTray in ["Shell_TrayWnd", "NotifyIconOverflowWindow"]
	{
		idxTB := TrayIcon_GetTrayBar(sTray)
		WinGet, pidTaskbar, PID, ahk_class %sTray%

		hProc := DllCall("OpenProcess", UInt, 0x38, Int, 0, UInt, pidTaskbar)
		pRB   := DllCall("VirtualAllocEx", Ptr, hProc, Ptr, 0, UPtr, 20, UInt, 0x1000, UInt, 0x4)

		SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class %sTray%   ; TB_BUTTONCOUNT

		szBtn := VarSetCapacity(btn, (A_Is64bitOS ? 32 : 20), 0)
		szNfo := VarSetCapacity(nfo, (A_Is64bitOS ? 32 : 24), 0)
		szTip := VarSetCapacity(tip, 128 * 2, 0)

		Loop, %ErrorLevel%
		{
			SendMessage, 0x417, A_Index - 1, pRB, ToolbarWindow32%idxTB%, ahk_class %sTray%   ; TB_GETBUTTON
			DllCall("ReadProcessMemory", Ptr, hProc, Ptr, pRB, Ptr, &btn, UPtr, szBtn, UPtr, 0)

			iBitmap := NumGet(btn, 0, "Int")
			IDcmd   := NumGet(btn, 4, "Int")
			statyle := NumGet(btn, 8)
			dwData  := NumGet(btn, (A_Is64bitOS ? 16 : 12))
			iString := NumGet(btn, (A_Is64bitOS ? 24 : 16), "Ptr")

			DllCall("ReadProcessMemory", Ptr, hProc, Ptr, dwData, Ptr, &nfo, UPtr, szNfo, UPtr, 0)

			hWnd  := NumGet(nfo, 0, "Ptr")
			uID   := NumGet(nfo, (A_Is64bitOS ? 8 : 4), "UInt")
			msgID := NumGet(nfo, (A_Is64bitOS ? 12 : 8))
			hIcon := NumGet(nfo, (A_Is64bitOS ? 24 : 20), "Ptr")

			WinGet, pID, PID, ahk_id %hWnd%
			WinGet, sProcess, ProcessName, ahk_id %hWnd%
			WinGetClass, sClass, ahk_id %hWnd%

			If !sExeName || (sExeName = sProcess) || (sExeName = pID)
			{
				DllCall("ReadProcessMemory", Ptr, hProc, Ptr, iString, Ptr, &tip, UPtr, szTip, UPtr, 0)
				Index := (oTrayIcon_GetInfo.MaxIndex()>0 ? oTrayIcon_GetInfo.MaxIndex()+1 : 1)
				oTrayIcon_GetInfo[Index,"idx"]     := A_Index - 1
				oTrayIcon_GetInfo[Index,"IDcmd"]   := IDcmd
				oTrayIcon_GetInfo[Index,"pID"]     := pID
				oTrayIcon_GetInfo[Index,"uID"]     := uID
				oTrayIcon_GetInfo[Index,"msgID"]   := msgID
				oTrayIcon_GetInfo[Index,"hIcon"]   := hIcon
				oTrayIcon_GetInfo[Index,"hWnd"]    := hWnd
				oTrayIcon_GetInfo[Index,"Class"]   := sClass
				oTrayIcon_GetInfo[Index,"Process"] := sProcess
				oTrayIcon_GetInfo[Index,"Tooltip"] := StrGet(&tip, "UTF-16")
				oTrayIcon_GetInfo[Index,"Tray"]    := sTray
			}
		}
		DllCall("VirtualFreeEx", Ptr, hProc, Ptr, pRB, UPtr, 0, Uint, 0x8000)
		DllCall("CloseHandle", Ptr, hProc)
	}
	DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
	Return oTrayIcon_GetInfo
}

TrayIcon_GetTrayBar(Tray:="Shell_TrayWnd")
{
	DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
	WinGet, ControlList, ControlList, ahk_class %Tray%
	RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)
	Loop, %nTB%
	{
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class %Tray%
		hParent := DllCall( "GetParent", Ptr, hWnd )
		WinGetClass, sClass, ahk_id %hParent%
		If !(sClass = "SysPager" or sClass = "NotifyIconOverflowWindow" )
			Continue
		idxTB := A_Index
		Break
	}
	DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
	Return  idxTB
}

TrayIcon_Remove(hWnd, uID)
{
		NumPut(VarSetCapacity(NID,(A_IsUnicode ? 2 : 1) * 384 + A_PtrSize * 5 + 40,0), NID)
		NumPut(hWnd , NID, (A_PtrSize == 4 ? 4 : 8 ))
		NumPut(uID  , NID, (A_PtrSize == 4 ? 8  : 16 ))
		Return DllCall("shell32\Shell_NotifyIcon", "Uint", 0x2, "Uint", &NID)
}
;}
