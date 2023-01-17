;#requires v1
/* 
-1- sublime.log_commands(True) 
-2- set_file_type {"syntax": "Packages/AutoHotkey/AutoHotkey.tmLanguage"} 
-*- set_file_type {"syntax": "Packages/User/Autohotkey2.sublime-syntax"} ;--- v2 ; 

*/
Menu, Tray, Icon , Shell32.dll, 16 , 1
TrayTip, AutoHotKey, Started, 1
SoundBeep, 300, 1
DetectHiddenWindows, on
setbatchlines,-1
settitlematchmode,2
FormatTime, time , YYYYMMDDHH24MISS, MMdd--HHmm
;SetCapsLockState, alwaysoff
#SingleInstance, off
#WinActivateForce
#KeyHistory
;#SingleInstance, Force
#installKeybdHook
#InstallMouseHook
#Persistent
;SetTitleMatchMode, slow ; june 30

;================

SendMode, event
;===
SetKeyDelay,
SetControlDelay, 1001
SetWinDelay, 200
SetMouseDelay, 50

;====here it is============

CoordMode, Tooltip, Screen
;CoordMode, Mouse, Screen

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[Globals]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]

/*
global dir = p:\App\app\logs\questions\ .%answer% 
global adir = c:\answer\%answer%
global pdir = p:\App\app
global cdir = c:\answer\%answer%
global Qfile = %adir%\Q.txt
global Mfile = %basedir%\Q-Master.txt1212
*/

f13 & g::
string := "d:/globalcoder/globalcoder.ahk"
run(string)
return

global toggle := ""
global frontproject := "p:\app\app\"
global c := 1
global wps := 15.00/3600
global script := "p:\app\app\((start).ahk"
global frontfile := ""
global myfun
global g :=1
global file := ""
global frontfile := ""
global frontdir :=  ""
global funclist := "p:/app/app/functions.txt"
global Qlist := "p:/app/app/logs/q-google.txt"
global s := "", global r := ""


return  ;----End of auto-execute section.

;------------------------------------------------------------------------------includes
 ;hide window hotkeys ; {alt} + V/C - {xbuttons} + H/J
1 & 2::
MsgBox, test
return

;/ ----------[Includes]
#include d:/lib
#include print.ahk
#include gdip_all.ahk
#include <globalcoderlib>
;#include ocr.ahk

;#include
;#include
;#include
;#include
;SetWorkingDir, %A_ScriptDir%


;#include p:\app\app\shins\Shinsimagescanclass.ahk ;;;
;#include P:\app\app\favorite-folders.ahk
;#include p:\app\app\((start)-class&fn.ahk ;;;
;#include p:\app\app\((start)-ifs.ahk
;#include p:\app\app\hotkeys.ahk
;#include d:/lib/btt.ahk ;;;
#include d:/lib/Vis2.ahk
;#include p:\app\app\((start)-winmin.ahk 
;#include p:\app\app\((start)-winmin2.ahk 

;#include <GuiBase>
;#include P:\App\app\gui\GuiBase.ahk
;#include <windowclass>
;#include p:\app\app\windowclass.ahk
;#include <btt>
;#include <UIA_Interface>
;#include %A_ScriptDir%\lib\
;#Include lib\Chrome.ahk
;#include P:\App\App\uiautomation\UIAutomation-main\lib\UIA_interface.ahk
;#include P:\App\App\uiautomation\UIAutomation-main\lib\UIA_browser.ahk
;#include P:\App\App\uiautomation\UIAutomation-main\lib\UIA_constant.ahk
;//



/*go(string){
MsgBox, % "0: `n " string
bracketstring := "[" . string . "]"
rawstring := string
clipboard := "x=[mid" . rawstring
send, ^f 
send, {backspace}
send, ^v
send, {enter}
clipboard := ""
if string != index
send, {f3 2}
send, ^+{left 5}
prefix := "=["
send, % "" prefix . "mid"
return
}
*/
f24 & i::
!i::
lv("d:/")
return

^i::
send, ^f 
clipboard := "[index ]"
send, ^v ;% clipboard 
;send, {enter}
return
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ INDEX ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[INDEX ]x=[]
;[ HOTSTRINGS ]             - 106 :*:gHOTSTRINGS 
;[ RUNS ]                   - 131 :*:gRUNS 
;[ WINDOWS ]                - 202 :*:gWINDOWS 
;[ FORMATTING & SPECIALS ]  - 391 :*:gFORMATTING & SPECIALS 
;[ WORD ]                   - 464 :*:gWORD 
;[ CHROME ]                 - 490 :*:gCHROME 
;[ INCLUDES ]               - 783 :*:gINCLUDES 





;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ HOTSTRINGS ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[Hotstrings ]
:*:dkz::dkzeanah@gmail.com
:*:3de::3de32882D+1
:*:ahkk::autohotkey
:*:msg::
mymsg_Function() {
    static count := 0
    clipboard := "MsgBox, % """ . count++ ": ``n " . """ "
    send, % clipboard
    ;send, % "MsgBox, % """ . count++ ": ``n " . """ "
}
return
:*:umgc::
umgcfunc(){
    clipboard := "dzeanah@student.umgc.edu"
    send, ^v
}
;==============================[midhoststrings]=================================[]
 return
:*:xb::xbutton2 &
:*:reqv2::#Requires AutoHotkey v2.0-beta.7 `n warn all, off
:*:reqv1::#Requires AutoHotkey  v1.1.34.03



/*:*:gindex::
        go("[ INDEX ]")
        return
:*:ghotstrings::
        go("HOTSTRINGS")
        return
:*:gruns::
        go("[ RUNS ]") 
        return                
:*:gwindows::
        go("[ WINDOWS ]") 
        return             
:*:gspecial::
        go("[ FORMATTING & SPECIALS ]") 
        return 
:*:gword::
        go("[ WORD ]") 
        return                
:*:gchrome::
        go("[ CHROME ]") 
        return              
:*:gincludes::
        go("[ INCLUDES ]") 
        return
*/

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[/HOTSTRINGS]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ RUNS ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[Runs ]

/*;
run, % "C:\Users\" . A_UserName . "\OneDrive\"
 C:\ProgramData\Microsoft\Windows\Start Menu\Programs
 "C:\Program Files\Sublime Text\sublime_text.exe"   
 "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Sublime Text.lnk"
 run "Z:\Program Files\scite4ahk3004\$DATA\SciTE.exe" "%A_ScriptFullPath%"
p:\app\app\((start)-class&fn.ahk
*/

~^f14::
;Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]
run, "p:\app\app\((start)-winmin2.ahk"  , A_WorkingDir ;"p:\app\app\((start)-winmin2.ahk"
return 
;==============================[midRUNS]=================================[]
f14 & 1::
ini( 0, updatemode = 0 )
msgbox % ini.A_Index
return


;helpers / EXmples
f24 & h::
run,  sublime_text.exe  "p:\app\app\regex.ahk "
run,  "C:\Program Files\Sublime Text\sublime_text.exe"  "p:\app\app\examples-gui.ahk "

return

; run,  "C:\Program Files\Sublime Text\sublime_text.exe" "f:/ile/path"     
f13 & r::
run, "C:\Program Files\Sublime Text\sublime_text.exe" "p:\app\app\favorite-folders.ahk"
run,  "C:\Program Files\Sublime Text\sublime_text.exe" "p:\app\app\((start)-ifs.ahk"
run,  "C:\Program Files\Sublime Text\sublime_text.exe" "p:\app\app\((start)-class&fn.ahk"
run,  "C:\Program Files\Sublime Text\sublime_text.exe" "p:\app\app\hotkeys.ahk"
run,  "C:\Program Files\Sublime Text\sublime_text.exe"  "p:\app\app\((start)-winmin.ahk "
run,  "C:\Program Files\Sublime Text\sublime_text.exe"  "p:\app\app\((start)-winmin2.ahk "
return 


;========================================= 
f13 & h:: 
send, ^l 
send, P:/app/
send, {enter}
return

;========================================= 
xbutton1 & p::
run, P:/app/app
return

;========================================= 
xbutton2 & p::
;if !WinActive("ahk_exe explorer.exe")
WinActivate, ahk_exe explorer.exe
return

;========================================= 
xbutton2 & d::
;run, d:/
Run ::{450d8fba-ad25-11d0-98a8-0800361b1103}
return

;========================================= 
^!+d::
ControlFocus, SysTreeView321, A
SendInput, % "desktop"
return ;focuses sidebar

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[/RUNS]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ WINDOWS ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[WINDOWS ]

f13 & v::
^+v::
WinActivate, "vs"
return 
^+c::
WinMinimize, vs
return 

Alt & LButton::
MouseGetPos, Mouse_Start_X, Mouse_Start_Y, Selected_Window
WinGet, Window_State, MinMax, ahk_id %Selected_Window%
if Window_State = 0
    SetTimer, MyLabel, 1
return
;==============================[midWINDOWS]=================================[]
MyLabel:
MouseGetPos, Mouse_Current_X, Mouse_Current_Y
WinGetPos, Selected_Window_X, Selected_Window_Y, , , ahk_id %Selected_Window%
WinMove, ahk_id %Selected_Window%, , Selected_Window_X + Mouse_Current_X - Mouse_Start_X, Selected_Window_Y + Mouse_Current_Y - Mouse_Start_Y

Mouse_Start_X := Mouse_Current_X
Mouse_Start_Y := Mouse_Current_Y

GetKeyState, LButton_State, LButton, P
if LButton_State = U
{
    SetTimer, MyLabel, off
    return
}
return

f13 & t:: ;==============================[test]=================================[]
  msgbox % A_UserName
run, % "C:\Users\" . A_UserName . "\OneDrive\"  

Colors := "red,green,blue"
StringSplit, ColorArray, Colors, `,
Loop, %ColorArray0%
{
    this_color := ColorArray%A_Index%
    MsgBox, Color number %A_Index% is %this_color%.
}
return

f13 & f:: ;==============================[]=================================[]
;Loop, FilePattern [, IncludeFolders?, Recurse?]


;loop functions.txt to display
MsgBox, % "0: `n "  funclist

Loop, read, %funclist%
{
    s .= A_LoopReadLine " `n "
}

test := z_stringreplace(s,"-","|||")
s := ""

Loop, read, %Qlist%
{
    s .= A_LoopReadLine " `n "
}
;MsgBox, % "0: `n " s

s_array := StrSplit(s, A_space , "`n" )
;for k,v in s_array
;MsgBox, % "0: `n " k "-" v

FileRead, QContents, %Qlist%
if not ErrorLevel  ; Successfully loaded.
{
    Sort, QContents
    ;FileDelete, C:\Address List (alphabetical).txt
    FileAppend, %QContents%, P:/app/app/logs/q-google(appended).txt
    run, P:/app/app/logs/q-google(appended).txt
    ;QContents := ""  ; Free the memory.
}
word_array := StrSplit(qcontents, ";", "-") ; Omits periods.
MsgBox % "The 4th word is " word_array[5]


;text := "Hi this`nis my;`ntest for this`nhmm;`n`ndoes it work?;`n`nI hope`nso`n`nLike Really!;"
MsgBox, % qcontents
MsgBox, % qcontents2 := StrAppendEachLine(qcontents, ";")
MsgBox, % "1: `n Qcontents: " qcontents

FileAppend, %QContents2%, P:/app/app/logs/q-google(appended2).txt
run, P:/app/app/logs/q-google(appended2).txt
return




for k,v in word_array
MsgBox, % "0: `n " k "-" v




;;;;;all works
;msgbox % s
;z_stringreplace(s,"-","|||")
;test := z_stringreplace(s,"-","|||")
;msgbox % r   
;msgbox % "test: `n " test   
;;;;
/*colors := "red,green,blue"
for index, color in StrSplit(colors, ",")
    MsgBox % "Color number " index " is " color

*/



/*recent_folder:="p:\app\app\"
Loop, Files, % recent_folder "\functions.txt ", 
{
    vPath := A_LoopFileFullPath
    FileGetShortcut, % vPath, vTarget
    vAttrib := FileExist(vTarget)
    if InStr(vAttrib, "D") || !vAttrib
        msgbox, %recent_folder%\%A_LoopFileName%`n`n ...points to a folder
                else
                msgbox, %recent_folder%\%A_LoopFileName%`n`n ...points to a file
    
}
return
*/

/*Lf = `n
Loop, Read, P:\app\app\func.txt
   {
   If A_LoopReadLine = 
        Lf = 
   TTContent = %TTContent%%A_LoopReadLine%%Lf%
   }
ToolTip, %TTContent%,5000
msgbox % TTContent . "`n continue?"
Sleep, 1000
ToolTip
return
*/
return
^f3::
f24 & f3::
xbutton2 & F3::
FileObject := {}
loop, %A_ScriptDir%\*.ahk, 0, 0 
{
splitpath, A_LoopFileName, FileName,,, Key 
FileObject[ Key ] := FileName 
}
for Each, File in FileObject
{

    FileList .= File "rn"
}
;btt(FileList,,,,"Style4",{Transparent:v})
sleep, 5000
return
;==============================[]=================================[]


xbutton2 & g::
send ^c
Run, www.google.com/search?q=%clipboard%
chrome_group()
return

xbutton2 & q::
WinActivate ahk_class Notepad
Win1.get()
SomeWin.AnnounceWinProps()
Return

xbutton2 & up::^!up
xbutton2 & down::^!down
xbutton2 & o:: OCR() 
xbutton2 & i:: ImageIdentify() 



/*if GetKeyState("Shift")
    MsgBox At least one Shift key is down.
else
    MsgBox Neither Shift key is down.

*/
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ FORMATTING & SPECIALS ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[specials ]x=[]
;==============================[breaks]=================================[breaks]


xbutton2 & f::
 global toggle := !toggle
send, ^f 
send, x=[]
return



;==============================[midspecials]=================================[]
/*xbutton2 & f::
send, ^f 
send, x=[]
  toggle := !toggle
return

#if (Toggle) 
F13::f3

#if
*/

;send % "{mbutton " ((t:=!t) ? "down" : "up") "}"
/*
xbutton2 & f::
send, ^f 
send, x=[]
  toggle := !toggle
while (Toggle && getkeystate("f13","p")){
   Send , {F3}  
}
return
*/

 /* While (toggle)
  {
    if GetKeyState("f13")
    send, {f3}
    return
  }
 
return

*/
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
  
    Send, `;==============================[]=================================[]
return

f13 & b::
send, `//================
clipboard := "`;================"
return

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ WORD ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[WORD]x=[]
;oWord.Selection.PasteAndFormat(22)  ; Plain Text
;oWord.Selection.PasteAndFormat(0)   ; Default 

xbutton2 & l:: 
 send, ^l 
 sleep, 100
 send, ^c
 sleep, 100
 sendword()
return
;==============================[midword]=================================[]


/*f1::
send := clipboard . "`n"
;send := send . "`n"
clipboard := send
oWord := ComObjActive("Word.Application")
oWord.Selection.PasteAndFormat(0)  ; Original Formatting
send := ""
clipboard := ""
return

*/
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ CHROME ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
;==============================[ CHROME ]=================================[CHROME ]
/*
chrome://settings/searchEngines
*/

^f1::
WinActivate("dkz1")
;savepic()
return 


/*RemoveToolTip:
ToolTip
return  
*/
;==============================[midchrome]=================================[]

f21::


f13 & Space:: ;------------------------------------------------------------------
InputBox, ans
Run, www.google.com/search?q=%ans%
chrome_group()

removespace(ans) ;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)

answer := clipboard
basedir := "c:\answer" 

createddir = p:\logs\questions\%date%__%answer%
createddir = %A_WorkingDir%\logs\questions\%answer%

FileCreateDir, p:\logs\questions\%time%_%answer% ;
FileCreateDir, %A_WorkingDir%\logs\questions\%answer% ;
FileCreateDir, %basedir%\%answer%
frontdir = %testdir%\%answer% 
fileappend, %answer%__%time% `n, %A_WorkingDir%\logs\questions\%answer%\Q.txt ;-- make text inside folder


dir = p:\App\logs\questions\%answer% 
frontdir = c:\answer\%answer%
file = %frontdir%\Q.txt
Masterfile = %basedir%\Q-Master.txt


fileappend, Q-%answer%__%time% `n, %A_WorkingDir%\logs\questions\%answer%\Q.txt ;-- make text inside folder
fileappend, Q-%answer%__%time% `n, p:\App\logs\questions\%answer%\Q.txt ;-- make text inside folder
FileAppend, -%answer%__%time% `n, %A_WorkingDir%\logs\Q-google.txt ;--- update global log file11
FileAppend, -%answer%__%time% `n, p:\App\logs\Q-google.txt ;--- update global log file11
fileappend, -%answer%__%time% `n ,%file%
fileappend, -%answer%__%time% `n ,%masterfile%

run %frontdir%
run, %file%

return 

;==============================[]=================================[]


scanchrome(){
static loopnum := 1

;create an array of colors, to add more just seperate them by commas
;--------------------pink------orange---white--green------purple--light blue-blu------red-----yellow
chromeTabColors := [0x  lwdkz2FF8BCB,0xFCAD70,0xDADCE0,0x81C995, 0xC58AF9,0x78D9EC,0x8AB4F8,0xF28B82,0xFDD663] 
chromeColors := {pink:  lwdkz20xFF8BCB,orange:0xFCAD70,white:0xDADCE0,green:0x81C995,purple:0xC58AF9,lightblue:0x78D9EC,blue:0x8AB4F8,red:0xF28B82,yellow:0xFDD663} 

WinActivate, dkz
send, !g
scan := new Shinsimagescanclass(dkz)
;scan.pixelregion()

for k,v in chromeColors
{
colorinloop := v
if (scan.Pixel(colorinloop,,x,y)) {
    tooltip % "Found" k " pixel at " x "," y
    mousemove,  x , y  
    MouseClick, r, X, Y, 1, 
           KeyWait, Tab
    } else 
    {
        MsgBox, % "0: `n damn " 
    }


}
return
}

xbutton2 & Space:: 
InputBox, ans
Run, www.google.com/search?q=%ans%
chrome_group(2)
removespace(ans) ;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
scanchrome()

answer := clipboard
basedir := "c:\answer" 

createddir = p:\logs\questions\%date%__%answer%
createddir = %A_WorkingDir%\logs\questions\%answer%

FileCreateDir, p:\logs\questions\%time%_%answer% ;
FileCreateDir, %A_WorkingDir%\logs\questions\%answer% ;
FileCreateDir, %basedir%\%answer%
dir = %testdir%\%answer% 
fileappend, %answer%__%time% `n, %A_WorkingDir%\logs\questions\%answer%\Q.txt ;-- make text inside folder


dir = p:\App\logs\questions\%answer% 
frontdir = c:\answer\%answer%
file = %frontdir%\Q.txt
Masterfile = %basedir%\Q-Master.txt


fileappend, Q-%answer%__%time% `n, %A_WorkingDir%\logs\questions\%answer%\Q.txt ;-- make text inside folder
fileappend, Q-%answer%__%time% `n, p:\App\logs\questions\%answer%\Q.txt ;-- make text inside folder
FileAppend, -%answer%__%time% `n, %A_WorkingDir%\logs\Q-google.txt ;--- update global log file11
FileAppend, -%answer%__%time% `n, p:\App\logs\Q-google.txt ;--- update global log file11
fileappend, -%answer%__%time% `n ,%file%
fileappend, -%answer%__%time% `n ,%masterfile%

filedir = %file%
;run, %frontdir%
;run, %frontfile%
;global frontfile := %file%
;global frontdir := %frontdir%
return 


;==============================[]=================================[]
;================



xbutton1 & n::

;MsgBox, % "1: `n " A_PriorHotkey
what := chrome_name(1)
MsgBox, % "1: `n " what
return

xbutton2 & n::

what := chrome_name(2)
MsgBox, % "2: `n " what
return
F17::
send, f17
toggle := !toggle
if (toggle)
MsgBox, % "0: `n on" 

MsgBox, % "1: `n off" 
return
/*
f14::
dkz2 := chrome_name(2)
chrome_group(2)

return
f17::

what := chrome_name(2)
MsgBox, % "2: `n " what
return
f20::

what := chrome_name("0")
MsgBox, % "0: `n " what
return 
*/
;================


xbutton2 & enter::
run, %frontdir%
run, %file%

ToolTip, % frontfile 
ToolTip, % frontdir 
;run %frontdir%
;run, %file%
return


;================
xbutton2 & v::
FileAppend, `n`r -%clipboard%-->%time% `; , %frontfile%
FileAppend, `n`r -%clipboard%-->%time% `; , %file%
return

;================
xbutton2 & c::
FileAppend, `n`r -%clipboard%-->%time% `; , %frontfile%
FileAppend, `n`r -%clipboard%-->%time% `; , %file%
return


;================
;------------------------------- inside of ss(), save the file in "frontfolder" dir.
xbutton2 & PrintScreen::
ss()
return

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]




xbutton2 & a::
 ;get recent files in order (via a file loop)
;CSIDL_RECENT := 8
VarSetCapacity(vDirRecent, 260*2, 0)
DllCall("shell32\SHGetFolderPath", Ptr,0, Int,8, Ptr,0, UInt,0, Str,vDirRecent)
vOutput := ""
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
Clipboard := StrReplace(vOutput, "`n", "`r`n")

MsgBox, % vOutput
return


;Alt+T = Toggle AlwaysOnTop ;state of the active window
xbutton2 & t::WinSet, AlwaysOnTop, Toggle, A




return 
xbutton1 & t::
res := WinActive("A")

;msgbox, % "0: `n " res
return 

xbutton2 & s::
InputBox, inp, , string to search,,
;InputBox, inp, , string to search, HIDE, , , , , Font, Timeout, Default]
findstring(inp,*.*,2,0)
msgbox,% findstring(inp, "*.ahk")
msgbox,% findstring(inp, "*.ahk")
t := {}
t := findstring(inp,*.*,0,0)
return








xbutton2 & f8::            ; copy info about the current mouse location to the clipboard
;Gosub, WatchCursor  
clipboard= ahk_id %id%`r`nahk_class %class%`r`n%title%`r`nControl: %control%`r`ntext: >>>`r`n%text%
return
;|||||||||||||||||||||||||||||||||||||||||||
xbutton2 & f9::            ; copy the info (formatted as Ahk_code) to the clipboard
ahk_code=
(
  ControlGetText, text, %control%, %title%
  ControlGetText, text, %control%, ahk_class %class%
)
clipboard= %ahk_code%
msgbox %ahk_code%
return

;-------------------------------------------------------------------------------------------
^xbutton2::
;;btt("This is BeautifulToolTip")
;;btt("This is BeautifulToolTip`n`nWhichToolTip = 2",500,500,2)
;Sleep, 5000
;btt("This is BeautifulToolTip",,,, "Style4")
sleep, 1000
;btt(,,,1)
Return

xbutton2 & m::
Lf = `n
Loop, Read, P:\app\app\logs\q-google.txt
   {
   If A_LoopReadLine = 
        Lf = 
   TTContent = %TTContent%%A_LoopReadLine%%Lf%
   } 
ToolTip, %TTContent%,5000
msgbox % TTContent . "`n continue?"
Sleep, 1000
ToolTip
return

f13 & 2::
ToolTip, % ggg.="1 :: " timeSinceLastCall(1)/1000 * wps  "¢`n"
return
f14 & 3::ToolTip, % ggg.="2 :: " timeSinceLastCall(2) "`n"
f14 & 4::ggg:="", timeSinceLastCall(0,1) ; reset everything




/*randomgenerator:
random, ranVar , 1, 100000000
m(ranVar)
return
*/


xbutton2 & e::
    winactivate, ahk_exe sublime_text.exe
      ;edit 
    return
xbutton2 & r:: ;-------------------------------------edit, reload, escape
    send ^s 
    reload 
    return
xbutton2 & esc::exitapp

xbutton2 & k::
keyhistory 
return


;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[ INCLUDES ]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[INCLUDES ]
;#include p:\app\app\((start)-winmin.ahk ;mouseb2 & h,j
;#include p:\app\app\((start)-winmin2.ahk