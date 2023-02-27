; Independenator
; Fanatic Guru
; 2014 12 15
; Version: 1.05
;
; Embeds dependent functions and #includes into script.
;
;{-----------------------------------------------
; Files may be drag and dropped on the Gui or selected by clicking on the file open icon.
; Checkbox "Include Library Function Pre-Comments" will look for comments at the beginning
;    of a library function and embed those also.
; The script can be editted before it is saved to a file or to the clipboard.
; The paths searched can be editted or expanded easily in the Initialization section below.
;
;}

; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force  ; Ensures that only the last executed instance of script is running

;}

; INITIALIZATION - VARIABLES
;{-----------------------------------------------
;

Depend_Width := 200
Set_Comment := true
SplitPath, A_AhkPath,,Exe_Path
Init_Paths := {}
Init_Paths.Insert(Exe_Path "\Lib\")
Init_Paths.Insert(A_ScriptDir "\Lib\")
Init_Paths.Insert(A_MyDocuments "\AutoHotkey\Lib\")
Init_Paths.Insert(Exe_Path "\")
Init_Paths.Insert(A_ScriptDir "\")
Init_Paths.Insert(A_MyDocuments "\AutoHotkey\")

Libs := {}

;}

; INITIALIZATION - GUI
;{-----------------------------------------------
;

Gui, Start:+MinSize825x600 +Resize
Gui, Start:Add, Text,, Drag && Drop File
Gui, Start:Add, Text, x500 yp, Browse to Select
Gui, Start:Add, Edit, xm w550 vGui_File
Gui, Start:Add, Button, gButtonOpenFile yp x560 w22 h22 0x40 section hwndIcon_1
Gui, Start:Add, CheckBox, x600 y30 gCheckbox_Comment vSet_Comment, Include Library Function Pre-Comments
Gui, Start:Add, Text,xm y60, Dependencies:
Gui, Start:Add, Text,% "x" Depend_Width+20 " yp", Independent Script:
Gui, Start:Add, Edit,% "xm w" Depend_Width " Multi vDepend_Output"
Gui, Start:Add, Edit,% "x" Depend_Width+20 " yp Multi vScript_Output"
Gui, Start:Add, Button,% "x" Depend_Width+20 " gButtonSaveAs", Save As
Gui, Start:Add, Button,% "x" Depend_Width+120 " gButtonClip", Clipboard
GuiControl, Start:, Set_Comment, %Set_Comment%

Psz := A_PtrSize = "" ? 4 : A_PtrSize, DW := "UInt", Ptr := A_PtrSize = "" ? DW : "Ptr"
VarSetCapacity( button_il, 20 + Psz, 0 )
NumPut( normal_il := DllCall( "ImageList_Create", DW, 16, DW, 16, DW, 0x21, DW, 1, DW, 1 ), button_il, 0, Ptr )
NumPut( 4, button_il, 16 + Psz, DW )
SendMessage, BCM_SETIMAGELIST := 5634, 0, &button_il,, AHK_ID %Icon_1%
IL_Add( normal_il, A_WinDir "\system32\shell32.dll", 46 )

;}

; AUTO-EXECUTE
;{-----------------------------------------------
;

Gui, Start:Show,w825 h600, INDEPENDENATOR
return

;
;}-----------------------------------------------
; END OF AUTO-EXECUTE

; SUBROUTINES
;{-----------------------------------------------
;

Process_Script:
	Script_Include := {}
	Paths := Init_Paths.Clone()
	SplitPath, Gui_File,,TargetDir
	if (A_ScriptDir <> TargetDir)
	{
		Paths.Insert(TargetDir "\")
		Paths.Insert(TargetDir "\Lib\")
	}
	FileRead, Script_File, %Gui_File%	;  Read AHK Script File into String
	Loop
	{
		Match := ""
		if RegExMatch(Script_File, "mi`a)^\s*#include(?:again)?(?:\s+|\s*,\s*)(?:\*i[ `t]?)?([^;\v]+[^\s;\v])", Match)	; Check for #Include
		{
			Match1 := A_Path(Match1)
			SplitPath, Match1,, OutDir,, OutNameNoExt
			if RegExMatch(Match1, "(:|\\)(?!.*\.)")
			{
				Paths.Insert(1, Trim(Match1, " \") "\")
				StringReplace, Script_File, Script_File, %Match%
				continue
			}
			if OutDir
				Paths.Insert(1, OutDir "\")
			File_Name := Trim(OutNameNoExt, " <>") ".ahk"
			Include_Exist := false
			For key, Path in Paths
			{
				File_Full_Name := Path File_Name
				If FileExist(File_Full_Name)
				{	
					Include_Exist := true
					FileRead, File, %File_Full_Name%
					StringReplace, Script_File, Script_File, %Match%, `n%File%
					Script_Include.Insert(File_Name)
					break
				}
			}
			if !Include_Exist
				MsgBox % "INCLUDE ERROR`n[" Match1 "]`n`nNOT FOUND"
		}
	} until !Match 
	Script_Funcs := {}
	Script_Scan := Script_File
	Func_Recursive:
	Func_Recursive := false
	Script_Scan := RegExReplace(Script_Scan, "ms`a)(^\s*/\*.*?^\s*\*/\s*\v|^\s*\(.*?^\s*\)\s*|(?-s)(^\s*;.*\R|[ \t]+;.*)|^\s+?\v)")	; Removes /* ... */ and ; ... and blank lines and ( ... ) Blocks
	Pos := 1, Match := ""
	Loop 
	{
		Pos := RegExMatch(Script_Scan, "imU)(^|\s)\K[a-z0-9#_@\$\?\[\]]+(?=\()", Match, Pos+StrLen(Match)) 
		if Pos
		{
			if (!IsFunc(Match) and !Script_Funcs[Match,"Status"])
			{
				Script_Funcs[Match,"Status"] := 0
				if RegExMatch(Match, "(.*)_", Lib)
					Libs[Lib1] := true
			}
		}
		else
			break
	}
	Pos := 1, Match := ""
	Loop 
	{
		Pos := RegExMatch(Script_Scan, "im)(*ANYCRLF)^[[:blank:]]*\K[a-zA-Z0-9#_@\$\?\[\]]+(?=\(.*?\)(\s+\Q;\E.*?[\r\n]+)*?\s+\{)", Match, Pos+StrLen(Match)) 
		if Pos
		{
			if !Script_Funcs[Match,"Status"]
				Script_Funcs[Match,"Status"] :=  1
		}
		else
			break
	}
	for Func in Script_Funcs
	{
		if (Script_Funcs[Func,"Status"] = 0)
		{
			Func_Found := false
			Func_Recursive := true
			for key, Path in Paths
			{
				File_Full_Name := Path Func ".ahk"
				If FileExist(File_Full_Name)
				{	
					Func_Found := true
					FileRead, File, %File_Full_Name% 
					Script_Funcs[Func,"Code"] := Trim(File, " `n`r`t")
					Script_Funcs[Func,"Status"] := 2
					break
				}
				for Lib in Libs
				{
					File_Full_Name := Path Lib ".ahk"
					if FileExist(File_Full_Name)
					{	
						FileRead, File, %File_Full_Name%
						Func_Start := RegExMatch(File,"Umi`a)^\s*" Func "\(.*\)([\s\v]*;.*$)?[\s\v]*\{", Match)
						if Func_Start
						{	
							Func_Found := true
							Pos := Func_Start + StrLen(Match)
							Bracket := 1
							Loop 
							{
								Pos := Pos + RegExMatch(SubStr(File, Pos), "\{|}", Match)
								if (Match = "{")
									Bracket ++=
								else
									Bracket --=
							} until !Bracket
							Func_Len := Pos - Func_Start
							Comment_Start := Func_Start-1
							Block := 0
							Loop
							{
								Pos := RegExMatch(SubStr(File, 1, Comment_Start), "(^|\v).*$", Match)
								Match := Trim(Match, " `n`r")
								Comment_Check := RegExMatch(Match, "(\*/|/\*|;)", Comment)
								if (Comment = "*/")
									Block ++=
								if (Comment = "/*")
									Block --=
								if (!Comment_Check and !Block and Match)
									break
								if  (Pos=1)
								{
									Comment_Start := Pos
									break
								}
								Comment_Start := Pos
							}
							if (Set_Comment and Comment_Start > 0)
								Script_Funcs[Func,"Code"] := Trim(SubStr(File, Comment_Start, Func_Start - Comment_Start)," `n`r`t") "`n" Trim(SubStr(File, Func_Start, Func_Len)," `n`r`t")
							else
								Script_Funcs[Func,"Code"] := Trim(SubStr(File, Func_Start, Func_Len)," `n`r`t")
							Script_Funcs[Func,"Status"] := 2
							Script_Funcs[Func,"Lib"] := Lib
							break 2
						}
					}
				}
			}
			if !Func_Found
				MsgBox % "FUNCTION ERROR`n`n" Func "`n`nNOT FOUND"
		}
	}
	Script_Output := Script_File "`n`n; FUNCTIONS - LIBRARY`n;{-----------------------------------------------`n;"
	for Lib in Libs
		for Func in Script_Funcs
			if (Script_Funcs[Func,"Status"] = 2 and Script_Funcs[Func,"Lib"] = Lib)  
				Script_Output .= "`n`n" Trim(Script_Funcs[Func,"Code"], " `n`r`t")
	for Func in Script_Funcs
		if (Script_Funcs[Func,"Status"] = 2 and Script_Funcs[Func,"Lib"] = "")  
			Script_Output .= "`n`n" Trim(Script_Funcs[Func,"Code"], " `n`r`t")
	if Func_Recursive
	{
		Script_Scan := Script_Output
		goto Func_Recursive
	}
	Script_Output := Trim(Script_Output "`n`n;}", "`n`r")
	Depend_Output := ""
	if Script_Include.MaxIndex()
	{
		Depend_Output .= "===== #INCLUDE ====="
		for index, Include in Script_Include
			Depend_Output .= "`n" Include
		Depend_Output .= "`n`n"
	}
	Depend_Count := 0
	for Func in Script_Funcs
		if (Script_Funcs[Func,"Status"] = 2)
			Depend_Count ++=
	if Depend_Count
	{
		Depend_Output .= "===== FUNCTIONS ====="
		for Lib in Libs
			for Func in Script_Funcs
				if (Script_Funcs[Func,"Status"] = 2 and Script_Funcs[Func,"Lib"] = Lib)
					Depend_Output .= "`n" Script_Funcs[Func,"Lib"] ": " Func
		for Func in Script_Funcs
			if (Script_Funcs[Func,"Status"] = 2 and Script_Funcs[Func,"Lib"] = "")
				Depend_Output .= "`n" Func
	}
	else
		Script_Output := RegExReplace(Script_Output, "`n`n; FUNCTIONS - LIBRARY`n;{---.*")
	Depend_Width := GuiTextWidth(Depend_Output) + 25
	if (Depend_Width < 150)
		Depend_Width := 150
	Script_Width := GuiWidth - Depend_Width - 25
	GuiControl, Start:Move, Independent Script:,% "x" Depend_Width+20
	GuiControl, Start:Move, Depend_Output,% "W" Depend_Width
	GuiControl, Start:Move, Script_Output,% "x" Depend_Width+20 " W" Script_Width
	GuiControl, Start:Move, Save As,% "x" Depend_Width+20
	GuiControl, Start:Move, Clipboard,% "x" Depend_Width+120

return

;}

; SUBROUTINES - GUI
;{-----------------------------------------------
;

StartGuiDropFiles:
	Gui_File :=  A_GuiEvent
	gosub Process_Script
	GuiControl, Start:, Gui_File, %Gui_File%
	GuiControl, Start:, Depend_Output, %Depend_Output%
	GuiControl, Start:, Script_Output, %Script_Output%
return

StartGuiSize:
	GuiWidth := A_GuiWidth
	Script_Width := A_GuiWidth - Depend_Width - 25
	Script_Height := A_GuiHeight - 125
	Func_Height := A_GuiHeight - 125	
	BottomButtons := A_GuiHeight - 35
	GuiControl, Start:Move, Depend_Output, H%Script_Height%
	GuiControl, Start:Move, Script_Output, W%Script_Width% H%Script_Height%
	GuiControl, Start:Move, Save As, Y%BottomButtons%
	GuiControl, Start:Move, Clipboard, Y%BottomButtons%
	
return

CheckBox_Comment:
	Gui, Start:Submit, NoHide
	gosub Process_Script
	GuiControl, Start:, Script_Output, %Script_Output%
return

ButtonOpenFile:
	FileSelectFile, OpenFile, 1,,,*.ahk
	if OpenFile
	{
		Gui_File := OpenFile
		gosub Process_Script
		GuiControl, Start:, Gui_File, %Gui_File%
		GuiControl, Start:, Depend_Output, %Depend_Output%
		GuiControl, Start:, Script_Output, %Script_Output%
	}
return

ButtonSaveAs:
	Gui, Start:Submit, NoHide
	SaveAs := RegExReplace(Gui_File, ".*\\(.*)\.ahk", "$1 (Independent).ahk")
	FileSelectFile, SaveAs, S16, %SaveAs%,,*.ahk
	if SaveAs
	{
		if FileExist(SaveAs)
			FileDelete %SaveAs%
		FileAppend, %Script_Output%, %SaveAs%
	}
return

ButtonClip:
	Gui, Start:Submit, NoHide
	Clipboard := RegExReplace(Script_Output,"`n","`r`n")
return

StartGuiEscape:
StartGuiClose:
	IL_Destroy( normal_il )
	Exitapp
return

;}

; FUNCTIONS
;{-----------------------------------------------
;

A_Path(Path)
{
	RegExMatch(Path, "%(A_.*)%", Match)
	If Match
	{
		if (Match1 = "A_ScriptDir")
			Match1 := "TargetDir"
		Path := RegExReplace(Path, Match, %Match1%)
	}
	return Path
}

GuiTextWidth(String, Font:="", FontSize:=10)
{
		if Font
			Gui GuiTextWidth:Font, s%FontSize%, %Font%
		Gui GuiTextWidth:Add, Text, HwndControlID, %String%
		GuiControlGet T, GuiTextWidth:Pos, %ControlID%
		Gui DropDownSize:Destroy
	return TW
}

;}
