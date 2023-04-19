



;google cloud api key AIzaSyCXSGxaPjGWNYqeKsVKSgBioCOj-xevEeo

;features||| --- read-me at bottom, press ^end.
;==========;
;-ocr [x]
;-regexer [x]
;-ghost-folders [x...] [benefit] - interfaceless folder creation
;-global google[todo] [benefit] - interfaceless google searcher and information grouper
;----------------------------------results in information gathering of self
;----------------------------------results in information gathering of self

;text editer independant 'formatting' / //commenting 



;coder playground - parse clipboard, identify functions and hotkeys used within, save as new ahk script
;with the main function as the name,---> if multifunctions, identify root word between all], save copied ahk to file with
;auto-generated name scheme, add functions and file path to global list of tracked/added scripts. 


;if chrome active --- right click opens context menu
;; close page
;;save link
;; bookmark to





#Requires AutoHotkey v1.1.34.03
Menu, Tray, Icon , Shell32.dll, 14 , 1
TrayTip, GlobalCoder, Started, 1
DetectHiddenWindows, on
setbatchlines,-1
FormatTime, time , YYYYMMDDHH24MISS, MMdd--HHmm
#SingleInstance
#WinActivateForce
#KeyHistory
#installKeybdHook
#InstallMouseHook
SetKeyDelay, 100
SetTitleMatchMode, 2
DetectHiddenWindows, on
#Persistent
#NoEnv

 /*
[settings]
key1=d:/MainCodeDir
key2=d:/MainCodeDir/references
key3=d:/MainCodeDir/notes
key4=value
key5=value
key6=value
key7=value
[counter]
key1=value
key2=value
key3=value
*/
applicationname=GlobalCoder
Gosub,INIREAD
Gosub,MENU
Gosub,TRAYMENU
ids=



;CurHK:="~F1 & a"    
 ;CurHK.=" & a"
;Hotkey % CurHK,DDHK
;configurehotkey() 
                                  

global current = %A_DD%/%A_MM%/%A_YYYY% "," %A_Hour% ":" %A_Min%
global rootpath := "d:/code"
global frontproject := "d:/code/test/" 
global frontpic := frontproject . "/.pic"
global frontquestion := frontproject . "/.Questions"

IniRead,Name,%A_desktop%\example.ini,Member1,Name ; You can use the same name as the output & key name


IniRead, Key1, %A_ScriptFullPath%, settings, key1
if (key1 = "value"){
configure()
  return
}
else
{


return
}

;newclass (for c#)

stringclass := //PROP `N //CTOR `N //METHODS `N
send, stringclasssetup


  ^!c:: ;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Jack Dunning https://jacksautohotkeyblog.wordpress.com/
;   AutoHotkey books available at http://www.computoredgebooks.com
;
; Script Function:
;   Saving text to C:\Users\%A_UserName%\Documents\SaveEdit.txt
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Saving text to C:\Users\%A_UserName%\Documents\SaveEdit.txt with CTRL+ALT+B


^!B::
KeyWait, Control ; avoid sticky key  
KeyWait, Alt     ; avoid sticky key
KeyWait, b       ; avoid sticky key

  BlockInput, On ; turns off mouse and keyboard to prevent accidental deletion from input
    Send, ^a     ; select all
    Sleep, 100
    Send, ^c     ; copy selection to keyboard
    Sleep, 100
    Click        ; deselect all select
  BlockInput, Off

  IfExist, C:\Users\%A_UserName%\Documents\SaveEdit.txt
  {
    FileDelete, C:\Users\%A_UserName%\Documents\SaveEdit.txt   
  }
  FileAppend , %clipboard%, C:\Users\%A_UserName%\Documents\SaveEdit.txt

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


f13 & 1::
WinActivate, dzean
return


xbutton2 & t::WinSet, AlwaysOnTop, Toggle, A
return 
xbutton1 & t::WinSet, AlwaysOnTop, Toggle, A
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



~f13::
if (A_TimeSincePriorHotkey > 400) || (A_PriorHotkey != A_ThisHotkey)
{

send, {f13}
return
}
else
{
send, {f2}
return
}


^!+y::
alterclipboard(clipboard, ";" ,"{")
return

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




^!f2::
if (A_TimeSincePriorHotkey < 200) && (A_PriorHotkey = A_ThisHotkey)
tooltip % "function 2"
else
tooltip % "function 1"
return

:*:inputbox::"inputbox,, message ,,,,,,,, autofill-prompt"

:*:dotnetnew::
setup()
return

^f12::
 CurHK:="~F1"                                    
 CurHK.=" & a"
 hotkey % CurHK , configurehotkey()
return



MsgBox, % "0: `n test"
return 
!+1::Run % "%windir%\Sysnative\SystemSettingsAdminFlows.exe EnableTouchPad " (touchpadEnabled := !touchpadEnabled)
+^#F22::Send {Mbutton}

;QQQ::
^!+q::
path := %A_Startup%
run(path)
return
:*:pyear::&as_qdr=y1
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
:*:ccad8::
ccad8func(){
    clipboard := "ccad8-student-6@msftmssa.onmicrosoft.com"
    send, ^v
}
:*:donovan.::
outlookfunc(){
    clipboard := "donovan.zeanah@outlook.com"
    send, ^v
}

;==={ //End Auto-execute section of code}==============================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=====// Hotkeys, hotstrings, continue to run etc..===============================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=================||\\----||======================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=================||-\\---||======================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=================||--\\--||======================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=================||---\\-||======================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;====||----||==={ notes } & Global Google ===||----||==================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
~f13 & [::
;Gui, Add, Button, gCtrlEvent vButton1, Button 1
;Gui, Add, Button, gCtrlEvent vButton2, Button 2
Gui, Add, Button, gGoButton, Go Button
;Gui, Add, Edit, vEditField, Example text
gui, add, Edit, w400 h200 vEditField, ;Here is some text`nHere is some text`nHere is some text`nHere is some text`nHere is some text`nHere is some text`nHere is some text`nHere is some text`nHere is some text`n
gui, show,,Test +resizable
GuiControl,enable,EditField
Return

Gui, Show,, Functions instead of labels

CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, % "EditField: `n" EditField
    editfield := editfield .= " `n `;--------------------------------------[]"
    writefile(editfield)
}

GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
return
/*~^+[::
;if (A_PriorHotkey = ";" & A_TimeSincePriorHotkey > 300)
{
Input, UserInput, V T5 L4 C, {enter}.{esc}{tab}, btw,otoh,fl,ahk,ca
switch ErrorLevel
{
case "Max":
    MsgBox, You entered "%UserInput%", which is the maximum length of text.
    return
case "Timeout":
    MsgBox, You entered "%UserInput%" at which time the input timed out.
    return
case "NewInput":
    return
default:
    if InStr(ErrorLevel, "EndKey:]")
    {
        MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
        return
    }
}
switch UserInput
{
case "btw":   Send, {backspace 4}by the way
case "otoh":  Send, {backspace 5}on the other hand
case "fl":    Send, {backspace 3}Florida
case "ca":    Send, {backspace 3}California
case "ahk":   Run, https://www.autohotkey.com
}
return
}
*/

^!+g::
run(gsearch) gsearch := A_WorkingDir . "/bin/googlesearch.txt"
run(gscratch) gscratch := A_WorkingDir . "/globercoder-scratch.ahk"
;/  &as_qdr=m6
;/  &as+qdr=y1
;Specifies the maximum age of the search results, in months.
; x is any number between 1 and 12;
;safe=off



googlesearch := A_WorkingDir . "/bin/googlesearch.txt"
run(googlesearch)
return

;; 'variable' window - list onscreen showing declared variable names and type
;; bracket navigation window? -- mini map --> drill down to what method a person is currently in, and where that resides overall
; Takes up space of solution explorer... until mouse moves over to that area, then relaxes all mod-windows.
;so code is 2/3 screen, 1/3 is solution /& GlobalCoder






;==={ If #directives }=============================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]


#if WinActive("ahk_exe explorer.exe")
{
	1::^l 
	return
}
#if

/*
#if WinActive("ahk_exe sublime_text.exe")
{

enter 
return
}
#if
*/


;==={ Hotkeys }====================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]

/*WatchActiveWindow:
text := OCR([0, 0, A_ScreenWidth, A_ScreenHeight])
file_path := writefile(text)
tooltip, % text, 1
;WinGetTitle, TitleOutput, A,
;tooltip, % TitleOutput
return
*/

;====== switch example


^!+t::
AlterClipboard(" " , StrSplit("()}{:=,")*)
return

validatepath(rootpath)

msgbox, % variable1 := validatepath(frontproject)


TestString := "This is a test."
word_array := StrSplit(TestString, A_Space, ".") ; Omits periods.
MsgBox % "The 4th word is " word_array[4]

;================
 ;Removes all CR+LF's from the clipboard contents.
Clipboard := StrReplace(Clipboard, "`r`n")

;================
 ;Replaces all spaces with pluses.
NewStr := StrReplace(OldStr, A_Space, "+")

;================
 ;Removes all blank lines from the text in a variable.
Loop
{
    MyString := StrReplace(MyString, "`r`n`r`n", "`r`n", Count)
    if (Count = 0)  ; No more replacements needed.
        break
}


;================
WinGetTitle, active_title, A
if active_title contains Address List.txt,Customer List.txt
    MsgBox One of the desired windows is active.
if active_title not contains metapad,Notepad
    MsgBox But the file is not open in either Metapad or Notepad.
;================


;file validataion

fileName := "Folder_Or_File_Path"
if InStr(FileExist( fileName ), "D")
	Msgbox % "[" fileName "] was found and it was a directory !"
else if FileExist( fileName )
	Msgbox % "[" fileName "] was found and it was a file (or a folder)!" ; this 'file' could be a directory too, if we won't explicitely check for it, isn't it ??
else
	Msgbox % "[" fileName "] was not found !"
	return

~<#[::			; <# means LWin
count++   	 	; for each press, increment a counter
SetTimer action, -0	; SetTimer is only used here to cause the code to be jumped to in a psuedo-thread.
return

	action:
KeyWait, LWin, L
If (count=1)
    MsgBox, action 1
If (count=2)
    MsgBox, action 2
; ...
count:=0      	; reset counter
return



ClipChanged(Type) {
    ToolTip Clipboard data type: %Type%
    Sleep 3000
    ToolTip  ; Turn off the tip.
    msgbox, % "your clipboard is this: " clipboard
    writefile(clipboard,frontproject)
}



^space::
;OnClipboardChange("ClipChanged")

;suffixes to narrow google search in launch ( google search filters )
; &as_qdr=y3 

InputBox, ans
Run, www.google.com/search?q=%ans%
chrome_group2()
removespace(ans) ;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)





/*createddir := frontproject . ""
frontdir = c:\answer\%answer%
file = %frontdir%\Q.txt
Masterfile = %basedir%\Q-Master.txt
filedir = %file%
*/


return 

#1::
msgbox, % started
text := OCR([0, 0, A_ScreenWidth, A_ScreenHeight])
file_path := writefile(text)
tooltip, % text, 1
WinGetTitle, TitleOutput, A,
tooltip, % TitleOutput
return

!r::
; AutoeExecute
    ;#NoEnv
   ; #SingleInstance force

    gosub MakeGui
    gosub UpdateMatch
    gosub UpdateReplace
    Gui Show, , RegEx Tester - v15.06.2020
return

#IfWinActive Regex Tester
!c::
    Gui Submit, NoHide
    ClipBoard := (TabSelection = "RegExMatch") ? mNeedle : rNeedle
    MsgBox, 64, RegEx Copied, %Clipboard% has been copied to the Clipboard, 3
return
#if

#c:: 
OCR()              ; OCR to clipboard

Vis2.Graphics.Subtitle.Render("Press [Win] + [c] to highlight and copy anything on-screen.", "time: 30000 xCenter y92% p1.35% cFFB1AC r8", "c000000 s2.23%")
tr := Vis2.Graphics.Subtitle.Render("Processing test.jpg... Please wait", "xCenter y67% p1.35% c88EAB6 r8", "s2.23% cBlack")


tr.Destroy()
return

#i:: ImageIdentify()    ; Label images

; #hotstrings


;todo -- #ifs

!i::
lv("d:/")
return


^!1::
;snipewindow(frontproject)
msgbox, % data := ocr(snipewindow(frontproject))
FileAppend, %data%, % rootpath "\Filefromsnipe.txt"

;sendraw, % data
return


!1::
	run, "C:\Program Files\Git\git-bash.exe" --cd-to-home
	bashWin := WinActive("A")
	msgbox, % bashwin
	return
	^!2::
WinMinimize, ahk_pid %bashWin%
msgbox, % bashwin
return

!enter::
selectsubject()
return

^1::
terminal()
setup()
;clone(setup())
return

^down::
newsubject()
return

^right::
newnote()
return

^up::
run(frontproject)
return



;pinned window in corner displaying the last (ongoing) winsnip of code

;==={ functions }==================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]
;===//=============================================================================[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]




; #functions

; uses frontproject variable  to set a local path variable to use with file operations, then sets
; new value for frontproject variable.


admin(){
SetWorkingDir, %A_ScriptDir%
if not A_IsAdmin
Run, *RunAs %A_ProgramFiles%/autohotkey/autohotkey.exe "%A_ScriptFullPath%" ,,, NewPID
process, priority, %newpid%, high
exitapp
}

configurehotkey(){
    ;CurHK:="~F1 & a"    
 ;CurHK.=" & a"
;Hotkey % CurHK,DDHK
Gui Add,DropDownList,gChange vNewHK,~F1|~F2|~F3   ;Create a DDL with the keys
Gui Show
Return  
}

Changehotkey:                                        ;Triggered when DDL changed
  Gui Submit,NoHide                            ;  Get the Gui's contents
  HotKey % CurHK,,Off                          ;  Disable old key
  HotKey % NewHK,DDHK                          ;  Assign new key (from DDL)
  MsgBox % CurHK " is Off.`n" NewHK " is On."  ;  Show it's been done
  CurHK:=NewHK
  gui Destroy                                 ;  Assign new variable to old
Return                                         ;End code block

DDHK:                                          ;DDL hotkey triggered
  MsgBox % "You tiggered " CurHK "!"           ;  Show it's been fired
Return        

configure(){
inputbox, rootfolder ,, "Enter a complete path as root folder `n Right arrow to accept auto-suggest" ,,,,,,,, D:/code/test
rootpath = %rootfolder%
IniWrite, %rootfolder%, %A_ScriptFullPath%, settings, key1

  if (FileExist(rootpath))
  {
    MsgBox, % "0: `n it exist: " rootpath 
  }
  else
  {
     FileCreateDir, %rootfolder% 
  }

  IniWrite, %rootfolder%/references, %A_ScriptFullPath%, settings, key2
  FileCreateDir, %rootfolder%/references
  _referencedir = %rootfolder%/references
  run(_referencedir)

  IniWrite, %rootfolder%/notes, %A_ScriptFullPath%, settings, key3
  FileCreateDir, %rootfolder%/notes
  _notesdir = %rootfolder%/references
  run(_referencedir)

IniWrite, 1, %A_ScriptFullPath%, settings, key4
IniWrite, 1, %A_ScriptFullPath%, counter, key1


inputbox,outvar, "input something, obv" ,,,,,,,, placeholder
/*
IniWrite,Tim,%A_desktop%\example.ini,Member1,Name
IniWrite,%AgeOfTim%,%A_desktop%\example.ini,Member1,Age
IniWrite,blue,%A_desktop%\example.ini,Member1,EyeColour

IniWrite,Tom,%A_desktop%\example.ini,Member2,Name
IniWrite,Age,%A_desktop%\example.ini,Member2,Age
IniWrite,green,%A_desktop%\example.ini,Member2,EyeColour
*/
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
terminal(){
	;run, cmd.exe, 
	run, "C:\Program Files\Git\git-bash.exe" --cd-to-home
	;WinGet, BashWindow
	;
	WinActivate, ahk_exe WindowsTerminal.exe
	;winwaitactive, ahk_exe windowsterminal.exe
	;send, ^+6
	; this is MY shortcut to open git bash inside windows terminal
	;bashwindow := WinActive("A")
	;WinWaitActive, ahk_id bashwindow
	
	;WinWaitActive, bashwindow
	clipboard = cd d:/code/MSSA ; add your root folder path here
	SendEvent, ^v
	send, {enter}
}

console(){
	inputbox, consoleName
	string := "dotnet new console -n """ "" consoleName """ "
	send(string)
	string := "dotnet new classlib -n """ "" consoleName . "library" """ "
	send(string)
}
setup(){ ;activate anywhere
	
	inputbox, ProjName,, "Name your Project: `n this is the SLN file created. `n`n Make sure GIT BASH is under this dialogue box `n unless v2 version `n which will require manual paste of generated CLI commands." `n  ,,,,,,,,SLN_
	dir := dir "/" . projName
	;FileCreateDir, % dir "/" . projName
	FileCreateDir, % dir
	WinActivate, MINGW64:/d/code/mssa
	;senddir)
	;WinWaitActive,  MINGW64:/c/Users/%A_UserName%

	send("cd " . dir, "folder created. ")
	;SendInput, {enter} 
	MsgBox, % "1: `n evaluate results..." dir ; (combined at start of fn) dir "/" . projName 

	string := "dotnet new sln -n  """ "" ProjName  """ " 
	send(string)

	inputbox, consoleName,, " Name your Project: `n this is the Console App. " ,,,,,,,,Console_%projName%
	string := "dotnet new console -n """ "" consoleName """ "
	send(string)

	inputbox, LibraryName,, " Name your Project: `n this is an additional file library. " ,,,,,,,,%ConsoleName%library
	string := "dotnet new classlib -n """ "" LibraryName """ "
	send(string)

	string := "dotnet sln " ProjName ".sln add **/*.csproj"
	send(string)
	
	string := "dotnet add " ConsoleName "/" ConsoleName ".csproj reference " libraryName "/" libraryName ".csproj"
	send(string)

	send("cd " . ConsoleName)
	send("code .")
	msgbox, "generate debug files & exit"
	send("cd .. && code .")

	return dir
}

send(string, Msg:=""){ ;send within console

	send, {backspace 5} ;ensures blank terminal line before inputting to terminal  via clipboard
	clipboard = %string% ;sets clipboard to function input (string) variable
	MsgBox, % "message: " . Msg . "Command placed in clipboard :  `n " string " `n paste results in git bash then press ok to continue. " 
	;send, ^v ; paste clipboard
	;send, {enter}
}

clone(dir){
	SourceFolder = d:\code\mssa\.Templates\.vscode
	if SourceFolder =
    		return
	TargetFolder = %dir%
	if TargetFolder =
    	return
	MsgBox, 4, , A copy of the folder "%SourceFolder%" will be put into "%TargetFolder%".  Continue?
	IfMsgBox, No
	  	return
	SplitPath, SourceFolder, SourceFolderName  ; Extract only the folder name from its full path.
	FileCopyDir, %SourceFolder%, %TargetFolder%\%SourceFolderName%
	if ErrorLevel
	MsgBox The folder could not be copied, perhaps because a folder of that name already exists in "%TargetFolder%".
		return
}

newsubject(path := ""){
	if (path = "")
	path := rootpath

	;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
	InputBox, subject ,, "enter a subject"
	frontproject := path "\" . subject ;".txt"

	if fileexist(frontproject . "note.txt"){
	MsgBox, already exists... init archive()

	return frontproject
	 }

	filecreatedir, % frontproject
	fileappend,-init, % frontproject "\.notes.txt"  
	return frontproject
	}

archive(){
	Loop, % rootpath . "\*" , 2 ; 2 = folders only
	;Loop, HKLM|HKU|HKCU|HKCR|HKCC [, Key, IncludeSubkeys?, Recurse?]`n{`n RegName := A_LoopRegName`n RegType := A_LoopRegType`n command2`n}
	return
}

newnote(path := ""){
	if (path = "")
	path = %frontproject%

	;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
	InputBox, note,, % frontproject - "new note:"
	fileappend, `n %note% , % frontproject "\note.txt"
	return
}
selectsubject(path := ""){
	if (path = "")
	;frontproject := rootpath

	Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListView3, Name
	;Loop, d:\code\mssa\* , 2 ; 2 = folders only
	Loop, % rootpath . "\*" , 2 ; 2 = folders only

	LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
	FolderList .= A_LoopFileName . "`n"

	Gui, Show

	
	MyListView3:
		if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
		{
		LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
		LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
		;frontproject = d:\code\mssa\.notes\%filename%
		frontproject := rootpath . "/" . filename . "/"

		files := lv(frontproject)

		msgbox, % frontproject "`n files:" files ;filename ;filedir
		GuiControl,, Folder, %frontproject%
		gui, destroy
	
	}
return frontproject
}

run2(path:=""){
;if (path = "" )
	;path = %frontproject%

	;run, %path%
	run, % path
	return
}

snipewindow(frontproject:=""){
msgbox, snipewindow
static counter := 1
;ensure consistant pic location relative to the chosen folder.
;not left parameterless incase another location desired.
savepath := frontproject . "/" . ++counter . ".png"

	
	if (fileexist(savepath )){
		loop
	{
		msgbox, % must have existed, to be here...
		savepath :=  frontproject . "/" . ++counter
		
		} Until (!fileexist(savepath . ".png"))
	
		 
	msgbox, it shouldnt exist, you should be here
	frontproject := savepath . ".png"
 	msgbox, % savepath . ".png"
	msgbox, % "picture should be here:  " frontproject
	;msgbox, % 
	
	pToken := Gdip_Startup()
	WinGet, hwnd, ID, A
	msgbox, % hwnd "or: " ID
	pBitmap := Gdip_BitmapFromHWND(hwnd)
	Gdip_SaveBitmapToFile(pBitmap, frontproject)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)

		}
	}
;run(savepath . ".png")
/*	pToken := Gdip_Startup()
	WinGet, hwnd, ID, A
	msgbox, % hwnd "or: " ID
	pBitmap := Gdip_BitmapFromHWND(hwnd)
	Gdip_SaveBitmapToFile(pBitmap, savepath)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	*/

/*run(savepath){
	return frontproject := savepath . ".png"
	}
	*/

ocr2(file, lang := "FirstFromAvailableLanguages"){
   static OcrEngineStatics, OcrEngine, MaxDimension, LanguageFactory, Language, CurrentLanguage, BitmapDecoderStatics, GlobalizationPreferencesStatics
   if (OcrEngineStatics = "")
   {
      CreateClass("Windows.Globalization.Language", ILanguageFactory := "{9B0252AC-0C27-44F8-B792-9793FB66C63E}", LanguageFactory)
      CreateClass("Windows.Graphics.Imaging.BitmapDecoder", IBitmapDecoderStatics := "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}", BitmapDecoderStatics)
      CreateClass("Windows.Media.Ocr.OcrEngine", IOcrEngineStatics := "{5BFFA85A-3384-3540-9940-699120D428A8}", OcrEngineStatics)
      DllCall(NumGet(NumGet(OcrEngineStatics+0)+6*A_PtrSize), "ptr", OcrEngineStatics, "uint*", MaxDimension)   ; MaxImageDimension
   }
   if (file = "ShowAvailableLanguages")
   {
      if (GlobalizationPreferencesStatics = "")
         CreateClass("Windows.System.UserProfile.GlobalizationPreferences", IGlobalizationPreferencesStatics := "{01BF4326-ED37-4E96-B0E9-C1340D1EA158}", GlobalizationPreferencesStatics)
      DllCall(NumGet(NumGet(GlobalizationPreferencesStatics+0)+9*A_PtrSize), "ptr", GlobalizationPreferencesStatics, "ptr*", LanguageList)   ; get_Languages
      DllCall(NumGet(NumGet(LanguageList+0)+7*A_PtrSize), "ptr", LanguageList, "int*", count)   ; count
      loop % count
      {
         DllCall(NumGet(NumGet(LanguageList+0)+6*A_PtrSize), "ptr", LanguageList, "int", A_Index-1, "ptr*", hString)   ; get_Item
         DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", LanguageTest)   ; CreateLanguage
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+8*A_PtrSize), "ptr", OcrEngineStatics, "ptr", LanguageTest, "int*", bool)   ; IsLanguageSupported
         if (bool = 1)
         {
            DllCall(NumGet(NumGet(LanguageTest+0)+6*A_PtrSize), "ptr", LanguageTest, "ptr*", hText)
            buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
            text .= StrGet(buffer, "UTF-16") "`n"
         }
         ObjRelease(LanguageTest)
      }
      ObjRelease(LanguageList)
      return text
   }
   if (lang != CurrentLanguage) or (lang = "FirstFromAvailableLanguages")
   {
      if (OcrEngine != "")
      {
         ObjRelease(OcrEngine)
         if (CurrentLanguage != "FirstFromAvailableLanguages")
            ObjRelease(Language)
      }
      if (lang = "FirstFromAvailableLanguages")
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+10*A_PtrSize), "ptr", OcrEngineStatics, "ptr*", OcrEngine)   ; TryCreateFromUserProfileLanguages
      else
      {
         CreateHString(lang, hString)
         DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", Language)   ; CreateLanguage
         DeleteHString(hString)
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+9*A_PtrSize), "ptr", OcrEngineStatics, ptr, Language, "ptr*", OcrEngine)   ; TryCreateFromLanguage
      }
      if (OcrEngine = 0)
      {
         msgbox Can not use language "%lang%" for OCR, please install language pack.
         ExitApp
      }
      CurrentLanguage := lang
   }
   if (SubStr(file, 2, 1) != ":")
      file := A_ScriptDir "\" file
   if !FileExist(file) or InStr(FileExist(file), "D")
   {
      msgbox File "%file%" does not exist
      ExitApp
   }
   VarSetCapacity(GUID, 16)
   DllCall("ole32\CLSIDFromString", "wstr", IID_RandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}", "ptr", &GUID)
   DllCall("ShCore\CreateRandomAccessStreamOnFile", "wstr", file, "uint", Read := 0, "ptr", &GUID, "ptr*", IRandomAccessStream)
   DllCall(NumGet(NumGet(BitmapDecoderStatics+0)+14*A_PtrSize), "ptr", BitmapDecoderStatics, "ptr", IRandomAccessStream, "ptr*", BitmapDecoder)   ; CreateAsync
   WaitForAsync(BitmapDecoder)
   BitmapFrame := ComObjQuery(BitmapDecoder, IBitmapFrame := "{72A49A1C-8081-438D-91BC-94ECFC8185C6}")
   DllCall(NumGet(NumGet(BitmapFrame+0)+12*A_PtrSize), "ptr", BitmapFrame, "uint*", width)   ; get_PixelWidth
   DllCall(NumGet(NumGet(BitmapFrame+0)+13*A_PtrSize), "ptr", BitmapFrame, "uint*", height)   ; get_PixelHeight
   if (width > MaxDimension) or (height > MaxDimension)
   {
      msgbox Image is to big - %width%x%height%.`nIt should be maximum - %MaxDimension% pixels
      ExitApp
   }
   BitmapFrameWithSoftwareBitmap := ComObjQuery(BitmapDecoder, IBitmapFrameWithSoftwareBitmap := "{FE287C9A-420C-4963-87AD-691436E08383}")
   DllCall(NumGet(NumGet(BitmapFrameWithSoftwareBitmap+0)+6*A_PtrSize), "ptr", BitmapFrameWithSoftwareBitmap, "ptr*", SoftwareBitmap)   ; GetSoftwareBitmapAsync
   WaitForAsync(SoftwareBitmap)
   DllCall(NumGet(NumGet(OcrEngine+0)+6*A_PtrSize), "ptr", OcrEngine, ptr, SoftwareBitmap, "ptr*", OcrResult)   ; RecognizeAsync
   WaitForAsync(OcrResult)
   DllCall(NumGet(NumGet(OcrResult+0)+6*A_PtrSize), "ptr", OcrResult, "ptr*", LinesList)   ; get_Lines
   DllCall(NumGet(NumGet(LinesList+0)+7*A_PtrSize), "ptr", LinesList, "int*", count)   ; count
   loop % count
   {
      DllCall(NumGet(NumGet(LinesList+0)+6*A_PtrSize), "ptr", LinesList, "int", A_Index-1, "ptr*", OcrLine)
      DllCall(NumGet(NumGet(OcrLine+0)+7*A_PtrSize), "ptr", OcrLine, "ptr*", hText) 
      buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
      text .= StrGet(buffer, "UTF-16") "`n"
      ObjRelease(OcrLine)
   }
   Close := ComObjQuery(IRandomAccessStream, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
   DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
   ObjRelease(Close)
   Close := ComObjQuery(SoftwareBitmap, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
   DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
   ObjRelease(Close)
   ObjRelease(IRandomAccessStream)
   ObjRelease(BitmapDecoder)
   ObjRelease(BitmapFrame)
   ObjRelease(BitmapFrameWithSoftwareBitmap)
   ObjRelease(SoftwareBitmap)
   ObjRelease(OcrResult)
   ObjRelease(LinesList)
   return text
}



CreateClass(string, interface, ByRef Class){
   CreateHString(string, hString)
   VarSetCapacity(GUID, 16)
   DllCall("ole32\CLSIDFromString", "wstr", interface, "ptr", &GUID)
   result := DllCall("Combase.dll\RoGetActivationFactory", "ptr", hString, "ptr", &GUID, "ptr*", Class)
   if (result != 0)
   {
      if (result = 0x80004002)
         msgbox No such interface supported
      else if (result = 0x80040154)
         msgbox Class not registered
      else
         msgbox error: %result%
      ExitApp
   }
   DeleteHString(hString)
}

CreateHString(string, ByRef hString){
    DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
}

DeleteHString(hString){
   DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
}

WaitForAsync(ByRef Object){
   AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
   loop
   {
      DllCall(NumGet(NumGet(AsyncInfo+0)+7*A_PtrSize), "ptr", AsyncInfo, "uint*", status)   ; IAsyncInfo.Status
      if (status != 0)
      {
         if (status != 1)
         {
            DllCall(NumGet(NumGet(AsyncInfo+0)+8*A_PtrSize), "ptr", AsyncInfo, "uint*", ErrorCode)   ; IAsyncInfo.ErrorCode
            msgbox AsyncInfo status error: %ErrorCode%
            ExitApp
         }
         ObjRelease(AsyncInfo)
         break
      }
      sleep 10
   }
   DllCall(NumGet(NumGet(Object+0)+8*A_PtrSize), "ptr", Object, "ptr*", ObjectResult)   ; GetResults
   ObjRelease(Object)
   Object := ObjectResult
}


!e::edit
^esc::exitapp
esc::reload


;#classes
class note{
	static initVar := 1++

	__new(){
		msgbox, % initvar
	}
}


lv(folder) {
    Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListView2 AltSubmit, Name
        Loop, Files, % folder "\*", D
        {
            LV_Add("", A_LoopFileName, A_LoopFileSizeKB)
            LV_ModifyCol()  ; Auto-size each column to fit its contents.
            LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
            FolderList .= A_LoopFileName . "`n"
        }
    Gui, Show
    return 

GuiContextMenu2:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListView2")  ; This check is optional. It displays the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

MyListView2:
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
front(filename,dir){
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

getCode(Order) { ; to fill in the second parameter of Template
    return repeat(1, Order) "," repeat(2, Order) "," repeat(3, Order)
     . "," repeat(4, Order) "," repeat(5, Order) "," repeat(6, Order)
}

repeat(str, n) { ; return str repeated n*n times
    Result := ""
    Loop, % n * n
        Result .= str
    return Result
}

fun(){
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

StrAppendEachLine(str, appendix){
 
    return, RegExReplace(str, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix)
}
fileAppendEachLine(filename, appendix){
    hmm := FileOpen(filename, "r`n").read()
    FileOpen(filename, "w`n").write(RegExReplace(hmm, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix))
    return
}

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

chrome_label2:
;WinActivate, dkz
;scan := new Shinsimagescanclass(dkz)
;scan.pixelregion()
;0xF6F6F6
;DD4D11
;if (scan.Pixel(0x8AB4F8,,x,y)) {
 ;   tooltip % "Found a pixel at " x "," y
;    mousemove,  x , y  
  ;  MouseClick, r, X, Y, 1, 
;}
return

chrome_name(num:=0){  

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
return

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
}
findstring(string, filepattern = "*.*", rec = 0, case = 0){
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

findstring1(string, filepattern = "*.*", rec = 1, case = 0){
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

IsInteger(str) {
    if str is integer
        return true
    else
        return false
}

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
Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
`;[Settings]
`;hotkey=^LButton    `;!=Alt +=Shift ^=Ctrl #=Win 

[Settings]
hotkey=^LButton 
)
  FileAppend,%ini%,%applicationname%.ini
}
IniRead,hotkey,%applicationname%.ini,Settings,hotkey
If (hotkey="" Or hotkey="ERROR")
  hotkey=^LButton 
Hotkey,%hotkey%,captainHOTKEY,On
Return


SETTINGS:
;Hotkey, KeyName [, Label, Options]
;Hotkey,%hotkey%,captainHOTKEY,Off
;;;;;;;;;;;;;;;;;;;;;;;Hotkey, KeyName [, Label, Options]
Gui,Destroy
;FileRead,ini,%applicationname%.ini
Gui,Font,Courier New
Gui,Add,Edit,Vnewini -Wrap W400,%ini%
Gui,Font
Gui,Add,Button,GSETTINGSOK Default W75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel

Gui,Show,%applicationname%
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
Hotkey,%hotkey%,HOTKEY,On
Return


EXIT:
ExitApp


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
Return






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

;#include <>
;#include <>
;#include <>
#include <vis2>
#Include <Gdip_All> ;.ahk


;#include globalcoder-captain.ahk
#include globalcoder-windows.ahk
#include globalcoder-references.ahk
#include globalcoder-chrome.ahk
#include globalcoder-image.ahk
#include globalcoder-minimizer.ahk
#include globalcoder-misc.ahk




;#include ((support))-white.ahk

 /* ### default key shortcuts ###



my key shortcuts
#sublime#
alt+shift+ 2 --- 2 column
alt+shift+ 8 --- 2 row

*/



 /* Folder Structure Reference & Dotnet cli commands
\\ solution folder
\\|
\\|__ project folder
\\|-----.vscode
\\|
\\|__ project folder_classlibrary

dotnet new sln -n "VsCodeIntroSolution"
dotnet new console -n "IntroUI"
dotnet new classlib -n "IntroLibrary"
dotnet sln VSCodeIntroSolution.sln add **/*.csproj       (only works in git bash, any folder below where we are at, if any .csproj exist, add it)
dotnet add IntroUI/IntroUI.csproj reference IntroLibrary/Introlibrary.csproj
*/




;       ### Considerations ###
;;==============================[]=================================[]
; C:/Program Files/Git/bin/bash.exe -i -l

; notefrontproject
; codefrontproject
; dirfrontproj


;#include <Gdip_all>


/* commands taken from this tutorial on c# by Tim Corey.
https://www.youtube.com/watch?v=r5dtl9Uq9V0
*/

/*

*/



/* TODO::
;TODO -- 

#questioner
--logs question
--launches googler
--

;running a dotnet project via commandline without being in the directory



Verifyglobals() - write to ini file on setup
noteviewer()
MapPageviewer() - common static commands/references
PhotoSnipper()
CodeSnipper()




#TEAMS
TeamsTimeLiner()
-transcript reader
-logging of video points
;================
chatgrabber()
-Linkgrabber
-picsaver

#sql
- statement helper i.e. *from::FROM

#git 
-cli 

#ProjectMapper

#ConventionInjector
ex. pasting a do..while loop into code, pre formatted.
--- asking the while first, with a description ( self commenting code ),
--- then, brings cursor within loop section




*/

; "frontproject" is a directory that contains the last accessed/created folder location,
; and can be used to send subsequent items i.e 

;newsubject() -> creates a new dir and sets frontproject to that dir
;newnote() -> creates a new note inside 'frontproject' dir
;snipewindow() -> creates image inside frontproject/pics/ ??%datetime% - possibly name decided by the ocr on that pic


;setting variables as global in the auto-execute section implicitely makes them "super-globals", i.e
; they do not need to be 'returned' or declared global inside of functions/methods and remain available
;at all times.


;just placeholder declerations. changing values here matters little.
