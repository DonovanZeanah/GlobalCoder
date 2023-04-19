;fast version
 
; Dotnet cli commands
/* //general c# folder structure
 
\\ solution folder
\\|
\\|__ project folder
\\|__ project folder_classlibrary
 
dotnet new sln -n "VsCodeIntroSolution"
dotnet new console -n "IntroUI"
dotnet new classlib -n "IntroLibrary"
 
;dotnet sln VSCodeIntroSolution.sln add ./IntroUI/IntroUI.csproj OR, *in git bash*:
 
dotnet sln VSCodeIntroSolution.sln add **/*.csproj //any folder below where we are at, if any .csproj exist, add it
dotnet add IntroUI/IntroUI.csproj reference IntroLibrary/Introlibrary.csproj
cd IntroUI
code .
 
++ launch and task .json
 
*/
 
;vscode key shortcuts
 
#Persistent
#Requires AutoHotkey v1.1.34.03
SetKeyDelay, 100
SetTitleMatchMode, 2
 

global frontproject := "d:/mssa/webapp1/.notes" ; edit before run
global projname := "Project1"
global ConsoleName := "Console_SLN_Project1"
global LibraryName := "Console_SLN_Project1Library"
new()
 
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
sendvs(generateNamespace())
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
 
;this is a hotstring. typing this string inside git bash will run the setup() function.
:*:dotnetnew::
setup()
return
 
;Functions section
 
new(){
    inputbox, rootfolder ,, "Enter a complete path as root folder `n Right arrow to accept auto-suggest" ,,,,,,,, D:/mssa/
    MsgBox, % " ^1 means ctrl + 1 will activate the key block `n i.e press ^1 to start setup of c# project" 
    MsgBox, % " ^esc  auto-reloads/'aborts' current thread "
}
terminal(){
    run, "C:\Program Files\Git\git-bash.exe" --cd-to-home
    ;WinActivate, ahk_exe WindowsTerminal.exe
   ; WinWaitActive, ahk_exe WindowsTerminal.exe
    ;send, ^+5 ; this is MY shortcut to open git bash inside windows terminal
    
    WinWaitActive,  MINGW64:/c/Users/%A_UserName%
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
    dir = d:/code/mssa
    inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
    dir := dir "/" . projName
    ;FileCreateDir, % dir "/" . projName
    FileCreateDir, % dir
    WinActivate, MINGW64:/d/code/mssa
    ;WinWaitActive,  MINGW64:/c/Users/%A_UserName%
    send, % "mkdir " . ProjName
        SendInput, {enter} 

    send, % "cd " . ProjName
    SendInput, {enter} 
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
 
    return dir
}
 
send(string, Msg:=""){ ;send within console
 
    send, {backspace 5} ;ensures blank terminal line before inputting to terminal  via clipboard
    clipboard = %string% ;sets clipboard to function input (string) variable
    ;MsgBox, % "message: " . Msg . "Command placed in clipboard :  `n " string " `n paste results in git bash then press ok to continue. " 
    send, +insert ; paste clipboard
    send, {enter}
}
sendVS(string){
    clipboard = %string% ;sets clipboard to function input (string) variable
    send, ^v
    return
}
generateMain(){
    string := "using System; `nusing " . LibraryName . "; `n`n namespace " ConsoleName "`n `t{ `n `t`t class Program `n `t`t`t"
    return string
}
generateNamespace(){
    string := " namespace " LibraryName "`n { `n `t`t public class Placeholder"
    return string
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
    frontproject := "D:\code\mssa\" . subject ;".txt"
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