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
 
global frontproject := "d:/code/mssa/.notes" ; super-global ( exist inside and outside of functions/methods ) holds path of last folder selected.
global rootfolder := "d:/(github)/.NET"
global projname := "Project1"
global ConsoleName := "Console_SLN_Project1"
global LibraryName := "Console_SLN_Project1Library"
new()
 
^+!u::
ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"

    nTime := A_TickCount
    sURL := GetActiveBrowserURL()
    WinGetClass, sClass, A
    If (sURL != "")
        MsgBox, % "The URL is """ sURL """`nEllapsed time: " (A_TickCount - nTime) " ms (" sClass ")"
    Else If sClass In % ModernBrowsers "," LegacyBrowsers
        MsgBox, % "The URL couldn't be determined (" sClass ")"
    Else
        MsgBox, % "Not a browser or browser not supported (" sClass ")"
;;exitapp
    nTime := A_TickCount
    sURL := GetActiveBrowserURL()
    WinGetClass, sClass, A
    If (sURL != "")
        MsgBox, % "The URL is """ sURL """`nEllapsed time: " (A_TickCount - nTime) " ms (" sClass ")"
    Else If sClass In % ModernBrowsers "," LegacyBrowsers
        MsgBox, % "The URL couldn't be determined (" sClass ")"
    Else
        MsgBox, % "Not a browser or browser not supported (" sClass ")"

;;exitapp
Return

GetActiveBrowserURL() {
    global ModernBrowsers, LegacyBrowsers
    WinGetClass, sClass, A
    If sClass In % ModernBrowsers
        Return GetBrowserURL_ACC(sClass)
    Else If sClass In % LegacyBrowsers
        Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
    Else
        Return ""
}
; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
    WinGet, sServer, ProcessName, % "ahk_class " sClass
    StringTrimRight, sServer, sServer, 4
    iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
    DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
    hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
    hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
    hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
    hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
    hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
    sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
    DllCall("DdeUnaccessData", "UPtr", hData)
    DllCall("DdeFreeDataHandle", "UPtr", hData)
    DllCall("DdeDisconnect", "UPtr", hConv)
    DllCall("DdeUninitialize", "UPtr", idInst)
    csvWindowInfo := StrGet(&sData, "CP0")
    StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
    Return sWindowInfo2
}
GetBrowserURL_ACC(sClass) {
    global nWindow, accAddressBar
    If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
    {
        nWindow := WinExist("ahk_class " sClass)
        accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
    }
    Try sURL := accAddressBar.accValue(0)
    If (sURL == "") {
        WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo (TO DO: check if still needed)
        If (nWindows > 1) {
            accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
            Try sURL := accAddressBar.accValue(0)
        }
    }
    If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
        sURL := "http://" sURL
    If (sURL == "")
        nWindow := -1 ; Don't remember the window if there is no URL
    Return sURL
}
; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687
GetAddressBar(accObj) {
    Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
        Return accObj
    Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
        Return accObj
    For nChild, accChild in Acc_Children(accObj)
        If IsObject(accAddressBar := GetAddressBar(accChild))
            Return accAddressBar
}
IsURL(sURL) {
    Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}
; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516
Acc_Init(){
    static h
    If Not h
        h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0){
    Acc_Init()
    If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
    Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
    Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
    If ComObjType(Acc,"Name") != "IAccessible"
        ErrorLevel := "Invalid IAccessible Object"
    Else {
        Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
        If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
            Loop %cChildren%
                i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
            Return Children.MaxIndex()?Children:
        } Else
            ErrorLevel := "AccessibleChildren DllCall Failed"
    }
}


^esc::reload
 
!enter::
selectsubject()
return
 
^1::
terminal()
;setup()
;clone(setup())
return
^2::
;sendvs(generateMain())
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
    inputbox, rootfolder ,, "Enter a complete path as root folder `n Right arrow to accept auto-suggest" ,,,,,,,, % rootfolder . "/"
    ;MsgBox, % " ^1 means ctrl + 1 will activate the key block `n i.e press ^1 to start setup of c# project" 
    ;MsgBox, % " ^esc  auto-reloads/'aborts' current thread "
}

terminal(){
    static isActive := 0

if (winactive("ahk_exe chrome.exe"))
{
send, !d
send, ^c
sURL := clipboard
isActive := 1
}

;msgbox, % "not isActive"


  /*  If (sURL != "")
        MsgBox, % "The URL is """ sURL """`nEllapsed time: " (A_TickCount - nTime) " ms (" sClass ")"
    Else If sClass In % ModernBrowsers "," LegacyBrowsers
        MsgBox, % "The URL couldn't be determined (" sClass ")"
    Else
        MsgBox, % "Not a browser or browser not supported (" sClass ")"
*/

    run, "C:\Program Files\Git\git-bash.exe" --cd-to-home
    WinActivate, ahk_exe mintty.exe ;WindowsTerminal.exe
    WinWaitActive, ahk_exe mintty.exe ;WindowsTerminal.exe
    ;send, ^+5 ; this is MY shortcut to open git bash inside windows terminal
    
    WinWaitActive,  MINGW64:/c/Users/%A_UserName%
    prevclip := clipboard
    clipboard :="mkdir '" . rootfolder . "' && cd '" . rootfolder . "'" ;d:/code/MSSA ; add your root folder path here
    send, ^+{insert} ;cd SLN_

    ;SendEvent, ^v
    send, {enter}
    

    if (isActive := 1) ; := 1
    {
        clipboard := "git clone " . sURL
        send, ^+{insert}
    }
    clipboard := prevclip
    return 
}
 
console(){
    inputbox, consoleName
    string := "dotnet new console -n """ "" consoleName """ "
    send(string)
    string := "dotnet new classlib -n """ "" consoleName . "library" """ "
    send(string)
}
;for Console
setup(){ ;activate anywhere
    dir := rootfolder 
    inputbox, ProjName,, " Name your Project: `n this is the SLN file created. " ,,,,,,,,SLN_
    dir := dir "/" . projName
    ;FileCreateDir, % dir "/" . projName
    FileCreateDir, % dir
    WinActivate, MINGW64:/d/code/mssa
    ;WinWaitActive,  MINGW64:/c/Users/%A_UserName%
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
 
    ;send("cd " . ConsoleName)
    send("explorer .")
 
    return dir
}
 
send(string, Msg:=""){ ;send within console
 
    send, {backspace 5} ;ensures blank terminal line before inputting to terminal  via clipboard
    clipboard = %string% ;sets clipboard to function input (string) variable
    ;MsgBox, % "message: " . Msg . "Command placed in clipboard :  `n " string " `n paste results in git bash then press ok to continue. " 
    if winactive("ahk_exe mintty.exe"){
        send, ^+{insert}
    } else {
      send, ^v ; paste clipboard  
    }

    send, {enter}
    return
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
 

 ;exitapp
 ;Return

 
 
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