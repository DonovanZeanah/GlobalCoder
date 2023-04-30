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

;default key shortcuts
;
;
;
;


#Persistent
#Requires AutoHotkey v1.1.34.03
SetKeyDelay, 100
SetTitleMatchMode, 2

/*
commands taken from this tutorial on c# by Tim Corey.
https://www.youtube.com/watch?v=r5dtl9Uq9V0
*/

;declaring here makes the variables "super-global" implicitely i.e. 
;they are available both inside and outside functions
;as well as the main auto-execute section, etc.

global frontproject := "d:/code/mssa/.notes" ; super-global ( exist inside and outside of functions/methods ) holds path of last folder selected.
global rootfolder := "c:/mssa"
global projname := ""
global ConsoleName := ""
global LibraryName := ""
new()



return
; end auto-execute section - rest of the code are functions, GoTo labels & ...
; more importantly key-activatable blocks

^esc::reload


!enter::
selectsubject()
return

^1::
terminal()
setup()
;clone(setup())
return

^2::
sendvs(generateMain())
return

^3::
generateNamespace()
return

^down::
newsubject()
return

^right::
newnote()
return

^up::
run()
return

:*:dotnetnew::
setup()
return


new(){
	inputbox, rootfolder ,, "Enter a complete path as root folder `n Right arrow to accept auto-suggest" ,,,,,,,, D:/mssa/code
	MsgBox, % " ^1 means ctrl + 1 will activate the key block `n i.e press ^1 to start setup of c# project" 
	MsgBox, % " ^esc  auto-reloads/'aborts' current thread "
	return
}
terminal(){
	run, cmd.exe, 
	WinActivate, ahk_exe WindowsTerminal.exe
	WinWaitActive, ahk_exe WindowsTerminal.exe
	send, ^+5 ; this is MY shortcut to open git bash inside windows terminal
	
	WinWaitActive,  MINGW64:/c/Users/%A_UserName%
	clipboard = cd d:/code/MSSA ; add your root folder path here
	SendEvent, ^v
	send, {enter}
}

setup(){ ;activate anywhere
	dir = d:/code/mssa
	inputbox, ProjName,, "Name your Project: `n this is the SLN file created. `n`n Make sure GIT BASH is under this dialogue box `n unless v2 version `n which will require manual paste of generated CLI commands." `n  ,,,,,,,,SLN_
	dir := dir "/" . projName
	;FileCreateDir, % dir "/" . projName
	FileCreateDir, % dir
	WinActivate, MINGW64:/d/code/mssa
	;WinWaitActive,  MINGW64:/c/Users/%A_UserName%

	send("cd " . ProjName, "folder created. ")
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
sendVS(string){
	clipboard = %string% ;sets clipboard to function input (string) variable
	send, ^v
	return
}
generateMain(){
	string := "using " . LibraryName . "; `n`n namespace " ProjName "{ `n`n }"
	return string
}
generateNamespace(){

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
	path := frontproject

	;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
	InputBox, subject ,, "enter a subject"
	frontproject := "D:\code\mssa\.notes\" . subject ;".txt"
	if fileexist(frontproject . "note.txt"){
	MsgBox, already exists.
	return frontproject
	 }

	filecreatedir, % frontproject
	fileappend,"init", % frontproject "\note.txt"  
	return frontproject
	}

newnote(path := ""){
	if (path = "")
	path := frontproject

	;inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
	InputBox, note,, % frontproject - "new note:"
	fileappend, `n %note% , % frontproject "\note.txt"
	return
}
selectsubject(path := ""){
	if (path = "")
	path := frontproject

	Gui, Add, ListView, background000000 cFFFFFF -Hdr r20 w200 h200 gMyListView3, Name
	Loop, d:\code\mssa\.notes\* , 2 ; 2 = folders only
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
		frontproject = d:\code\mssa\.notes\%filename%
		GuiControl,, Folder, %frontproject%
		gui, destroy
	
}
return frontproject
}
run(path := ""){
	run, %frontproject%
}





;dotnet new sln -n "VsCodeIntroSolution"
;dotnet new console -n "IntroUI"
;dotnet new classlib -n "IntroLibrary"

;dotnet sln VSCodeIntroSolution.sln add ./IntroUI/IntroUI.csproj
;or
;*in git bash*
;dotnet sln VSCodeIntroSolution.sln add **/*.csproj //any folder below where we are at, if any .csproj exist, use it

;dotnet add IntroUI/IntroUI.csproj reference IntroLibrary/Introlibrary.csproj

;cd IntroUI
;code .
