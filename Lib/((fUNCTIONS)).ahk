#include d:/lib/gdip_all.ahk ;C:\Program Files\AutoHotkey\Lib\gdip_all.ahk





Menu, Tray, Icon , Shell32.dll, 14 , 1

:*:gindex::
        go("INDEX")
        return
:*:ghotstrings::
        go("HOTSTRINGS")
        return
:*:gruns::
        go("RUNS") 
        return                
:*:gwindows::
        go("WINDOWS") 
        return             
:*:gspecial::
        go("FORMATTING & SPECIALS") 
        return 
:*:gword::
        go("WORD") 
        return                
:*:gchrome::
        go("CHROME") 
        return              
:*:gincludes::
        go("INCLUDES") 
        return


go(string){
SetKeyDelay, 50,
MsgBox, % "0: `n " string
rawstring := string
clipboard := "x=[mid" . rawstring
MsgBox, % "0: `n " rawstring

send, ^f 
send, {backspace}
send, ^v
send, {enter}
clipboard := ""
if string != index
;send, {f3 2}
send, ^+{left 10}
prefix := "=["
bracketstring := "" . rawstring . "]"

clipboard := "" prefix . "mid" . bracketstring
send, ^v
return
}






savepic(){
pToken := Gdip_Startup()
WinGet, hwnd, ID, A
pBitmap := Gdip_BitmapFromHWND(hwnd)
Gdip_SaveBitmapToFile(pBitmap, A_Desktop "\TestOutput.png")
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)


ToolTip, Timed ToolTip`nThis will be displayed for 5 seconds.
SetTimer, RemoveToolTip, -1000
return
}

winset(){
window := WinExist("A")
msgbox % "window: " window
return window
}




WinActivate(window){
msgbox % "win: " window
msgbox % "win: " window
WinActivate,  %window%
return
}
;================;================bb
class chrome_class
{
;use it: example := new Chrome_group(2)

    static count := 0

  

    __new(num:=0){

    ;Gui +HwndMyGuiHwnd

    ;gui, Show, noactivate
    ;MsgBox, % "count: " this.count++ ;:= count++ "`n" . "focus window to change" ";;;" count
    ;MsgBox, % "count: " this.count ;:= count++ "`n" . "focus window to change" ";;;" count


    ;MsgBox, % "Start: `n inside of chrome_group class :" this.count . " `n parameter passed in: " num
;     MsgBox, % "7: this.num:" this.num
   ; this.num := num ; A := new chrome_group(2) ; A.num is 2.
   ;  MsgBox, % "8: this.num := *num* : " this.num

   if num = 2 

   return this
    }

    winset(){

    }
    winactivate(){

    }

    /*
    use:


    */
/*
*/
}



RemoveToolTip:
ToolTip
return  

class ManualArray1
{
    __Call(vFunc, oParams*)
    {
        ;MsgBox, % vFunc " " oParams.1 " " oParams.2
        static obj
        static obj2
        if !IsObject(obj)
            obj := {}, obj2 := {}
        if (vFunc = "Get")
            return obj[oParams.1]
        if (vFunc = "Set")
        {
            if !ObjHasKey(obj, oParams.1)
                ObjPush(obj2, oParams.1)
            ObjRawSet(obj, oParams.1, oParams.2)
        }
        if (vFunc = "Address")
            return &obj
        if (vFunc = "Address2")
            return &obj2
        if (vFunc = "Count")
            return NumGet(&obj + 4*A_PtrSize)
        if (vFunc = "GetKey")
            return obj2[oParams.1]
        if (vFunc = "GetValue")
            return obj[obj2[oParams.1]]
    }
}
class MyClassTestDefine
{
    a := "A"
    b := {}
    b.c := "C"
    d := {}
    d.e := {}
    d.e.f := "F"
    now := A_Now " " A_MSec
    MyMethod()
    {
        static g
        g++
        MsgBox, % "2 " this.a " " this.b.c " " this.d.e.f " " this.now " " g
    }
}
class ManualArray
{
    obj:=[]
    obj2:=[]
    __Call(vFunc, oParams*)
    {
        if (vFunc = "Get")
            return this.obj[oParams.1]
        if (vFunc = "Set")
        {
            if !objHasKey(this.obj, oParams.1)
                objPush(this.obj2, oParams.1)
            objRawSet(this.obj, oParams.1, oParams.2)
        }
        if (vFunc = "Address")
            return &this.obj
        if (vFunc = "Address2")
            return &this.obj2
        if (vFunc = "Count")
            return NumGet(&this.obj + 4*A_PtrSize)
        if (vFunc = "GetKey")
            return this.obj2[oParams.1]
        if (vFunc = "GetValue")
            return this.obj[this.obj2[oParams.1]]
    }
}
class fileobj1{ 
count := __enum
;static count := 1++
}
class parsefile{
fileobj := file
}



Class Window3{
   __New(){
   static num := new tmp
;    Class Tmp{
       A:=1++
        Static B:=1++
       
   msgbox % num
;}   
}
    
    Get(){
        WingetTitle TitleVar, A ; Get title from Active window.
        This.Title:=TitleVar ; Set TitleVar to This.Title
        
        WinGet IDVar,ID,A ; Get ID from Active window.
        This.ID:=IDVar ; Set IDVar to This.ID
    }

    Activate(){ ;Activates window with Title - This.Title 
        IfWinExist, % "ahk_id "This.ID
            WinActivate % "ahk_id " This.ID
        else
            MsgBox % "There is no Window with ID: "This.ID
    }  
    AnnounceWinProps(){ ;Create message box with title and ID
    
        MsgBox % "Title is: " This.Title "`n ID is: " This.ID
    }
}

Class log{
    Title:= "log" ;Variable Title
    
    Activate() ;Activates window with Title - This.Title
    { 
        IfWinExist, % This.Title
            WinActivate 
        else
            MsgBox % "There is no Window: "This.Title "`nPleas Run Notepad!"

    }   
}


Class Window1{
    Title:= "Untitled - Notepad" ;Variable Title
    Activate() ;Activates window with Title - This.Title
    { 
        IfWinExist, % This.Title
            WinActivate 
        else
            MsgBox % "There is no Window: "This.Title "`nPleas Run Notepad!"

    }   
}

ArrayHasKey(Array, MultiDimKey*) {
    If !IsObject(Array)
        return
    For each, key in MultiDimKey {
        If !Array.HasKey(key)
            return false
        Array := Array[key]
    } return true
}

run(path){

    run % path
    return
}

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

/*
send,{Alt 2}
send,{space 2}
send, l
send, w
send, dkz
send,{enter}
return
*/
}

chrome_group(num := 0){
;MsgBox, % "Start: `n inside of chrome_group class : `n parameter passed in: " num
this.num := num ; A := new chrome_group(2) ; A.num is 2.
if (num = 0)
{
static count := 0
count++
;MsgBox, % "0: count:" count
WinActivate, ahk_exe chrome.exe
chrome_name()
sleep, 100
send, !g
sleep, 100
MsgBox, % "1: chrome window is :"  dkz1 "`n "
if IfMsgBox, yes 
;Continue
{
MsgBox, % "5: put a gotosub here that uses shinsimagescan class" 
}
else IfMsgBox, cancel 
{
MsgBox, % "4:" "canceled operation"
return
}
else if (num := 1)
{
WinActivate, dkz1 
WinWaitActive, dkz1
sleep, 100
send, !g
sleep, 100
MsgBox, % "1: chrome window is :"  dkz1
Goto, chrome_label
return

}
else if (num := 2)
{
send,{Alt 2}
send,{space 2}
send, l
send, w
send, dkz2
send,{enter}
MsgBox, % "2: chrome window is :" dkz2
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

;return

/*WinActivate, dkz 
WinWaitActive, dkz
sleep, 100
send, !g
sleep, 100
return
*/
}




    /*
    use:


    */
/*
*/

}




   
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
ClipChanged(Type) {
    ToolTip Clipboard data type: %Type%
    Sleep 1000
    ToolTip  ; Turn off the tip.
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
















; ==================================================================================================================================
; Function:       Notifies about changes within folders.
;                 This is a rewrite of HotKeyIt's WatchDirectory() released at
;                    http://www.autohotkey.com/board/topic/60125-ahk-lv2-watchdirectory-report-directory-changes/
; Tested with:    AHK 1.1.23.01 (A32/U32/U64)
; Tested on:      Win 10 Pro x64
; Usage:          WatchFolder(Folder, UserFunc[, SubTree := False[, Watch := 3]])
; Parameters:
;     Folder      -  The full qualified path of the folder to be watched.
;                    Pass the string "**PAUSE" and set UserFunc to either True or False to pause respectively resume watching.
;                    Pass the string "**END" and an arbitrary value in UserFunc to completely stop watching anytime.
;                    If not, it will be done internally on exit.
;     UserFunc    -  The name of a user-defined function to call on changes. The function must accept at least two parameters:
;                    1: The path of the affected folder. The final backslash is not included even if it is a drive's root
;                       directory (e.g. C:).
;                    2: An array of change notifications containing the following keys:
;                       Action:  One of the integer values specified as FILE_ACTION_... (see below).
;                                In case of renaming Action is set to FILE_ACTION_RENAMED (4).
;                       Name:    The full path of the changed file or folder.
;                       OldName: The previous path in case of renaming, otherwise not used.
;                       IsDir:   True if Name is a directory; otherwise False. In case of Action 2 (removed) IsDir is always False.
;                    Pass the string "**DEL" to remove the directory from the list of watched folders.
;     SubTree     -  Set to true if you want the whole subtree to be watched (i.e. the contents of all sub-folders).
;                    Default: False - sub-folders aren't watched.
;     Watch       -  The kind of changes to watch for. This can be one or any combination of the FILE_NOTIFY_CHANGES_...
;                    values specified below.
;                    Default: 0x03 - FILE_NOTIFY_CHANGE_FILE_NAME + FILE_NOTIFY_CHANGE_DIR_NAME
; Return values:
;     Returns True on success; otherwise False.
; Change history:
;     1.0.03.00/2021-10-14/just me        -  bug-fix for addding, removing, or updating folders.
;     1.0.02.00/2016-11-30/just me        -  bug-fix for closing handles with the '**END' option.
;     1.0.01.00/2016-03-14/just me        -  bug-fix for multiple folders
;     1.0.00.00/2015-06-21/just me        -  initial release
; License:
;     The Unlicense -> http://unlicense.org/
; Remarks:
;     Due to the limits of the API function WaitForMultipleObjects() you cannot watch more than MAXIMUM_WAIT_OBJECTS (64)
;     folders simultaneously.
; MSDN:
;     ReadDirectoryChangesW          msdn.microsoft.com/en-us/library/aa365465(v=vs.85).aspx
;     FILE_NOTIFY_CHANGE_FILE_NAME   = 1   (0x00000001) : Notify about renaming, creating, or deleting a file.
;     FILE_NOTIFY_CHANGE_DIR_NAME    = 2   (0x00000002) : Notify about creating or deleting a directory.
;     FILE_NOTIFY_CHANGE_ATTRIBUTES  = 4   (0x00000004) : Notify about attribute changes.
;     FILE_NOTIFY_CHANGE_SIZE        = 8   (0x00000008) : Notify about any file-size change.
;     FILE_NOTIFY_CHANGE_LAST_WRITE  = 16  (0x00000010) : Notify about any change to the last write-time of files.
;     FILE_NOTIFY_CHANGE_LAST_ACCESS = 32  (0x00000020) : Notify about any change to the last access time of files.
;     FILE_NOTIFY_CHANGE_CREATION    = 64  (0x00000040) : Notify about any change to the creation time of files.
;     FILE_NOTIFY_CHANGE_SECURITY    = 256 (0x00000100) : Notify about any security-descriptor change.
;     FILE_NOTIFY_INFORMATION        msdn.microsoft.com/en-us/library/aa364391(v=vs.85).aspx
;     FILE_ACTION_ADDED              = 1   (0x00000001) : The file was added to the directory.
;     FILE_ACTION_REMOVED            = 2   (0x00000002) : The file was removed from the directory.
;     FILE_ACTION_MODIFIED           = 3   (0x00000003) : The file was modified.
;     FILE_ACTION_RENAMED            = 4   (0x00000004) : The file was renamed (not defined by Microsoft).
;     FILE_ACTION_RENAMED_OLD_NAME   = 4   (0x00000004) : The file was renamed and this is the old name.
;     FILE_ACTION_RENAMED_NEW_NAME   = 5   (0x00000005) : The file was renamed and this is the new name.
;     GetOverlappedResult            msdn.microsoft.com/en-us/library/ms683209(v=vs.85).aspx
;     CreateFile                     msdn.microsoft.com/en-us/library/aa363858(v=vs.85).aspx
;     FILE_FLAG_BACKUP_SEMANTICS     = 0x02000000
;     FILE_FLAG_OVERLAPPED           = 0x40000000
; ==================================================================================================================================

/*

WatchFolder(Folder, UserFunc, SubTree := False, Watch := 0x03) {
   Static DummyObject := {Base: {__Delete: Func("WatchFolder").Bind("**END", "")}}
   Static TimerID := "**" . A_TickCount
   Static TimerFunc := Func("WatchFolder").Bind(TimerID, "")
   Static MAXIMUM_WAIT_OBJECTS := 64
   Static MAX_DIR_PATH := 260 - 12 + 1
   Static SizeOfLongPath := MAX_DIR_PATH << !!A_IsUnicode
   Static SizeOfFNI := 0xFFFF ; size of the FILE_NOTIFY_INFORMATION structure buffer (64 KB)
   Static SizeOfOVL := 32     ; size of the OVERLAPPED structure (64-bit)
   Static WatchedFolders := {}
   Static EventArray := []
   Static WaitObjects := 0
   Static BytesRead := 0
   Static Paused := False
   ; ===============================================================================================================================
   If (Folder = "")
      Return False
   SetTimer, % TimerFunc, Off
   RebuildWaitObjects := False
   ; ===============================================================================================================================
   If (Folder = TimerID) { ; called by timer
      If (ObjCount := EventArray.Count()) && !Paused {
         ObjIndex := DllCall("WaitForMultipleObjects", "UInt", ObjCount, "Ptr", &WaitObjects, "Int", 0, "UInt", 0, "UInt")
         While (ObjIndex >= 0) && (ObjIndex < ObjCount) {
            Event := NumGet(WaitObjects, ObjIndex * A_PtrSize, "UPtr")
            Folder := EventArray[Event]
            If DllCall("GetOverlappedResult", "Ptr", Folder.Handle, "Ptr", Folder.OVLAddr, "UIntP", BytesRead, "Int", True) {
               Changes := []
               FNIAddr := Folder.FNIAddr
               FNIMax := FNIAddr + BytesRead
               OffSet := 0
               PrevIndex := 0
               PrevAction := 0
               PrevName := ""
               Loop {
                  FNIAddr += Offset
                  OffSet := NumGet(FNIAddr + 0, "UInt")
                  Action := NumGet(FNIAddr + 4, "UInt")
                  Length := NumGet(FNIAddr + 8, "UInt") // 2
                  Name   := Folder.Name . "\" . StrGet(FNIAddr + 12, Length, "UTF-16")
                  IsDir  := InStr(FileExist(Name), "D") ? 1 : 0
                  If (Name = PrevName) {
                     If (Action = PrevAction)
                        Continue
                     If (Action = 1) && (PrevAction = 2) {
                        PrevAction := Action
                        Changes.RemoveAt(PrevIndex--)
                        Continue
                     }
                  }
                  If (Action = 4)
                     PrevIndex := Changes.Push({Action: Action, OldName: Name, IsDir: 0})
                  Else If (Action = 5) && (PrevAction = 4) {
                     Changes[PrevIndex, "Name"] := Name
                     Changes[PrevIndex, "IsDir"] := IsDir
                  }
                  Else
                     PrevIndex := Changes.Push({Action: Action, Name: Name, IsDir: IsDir})
                  PrevAction := Action
                  PrevName := Name
               } Until (Offset = 0) || ((FNIAddr + Offset) > FNIMax)
               If (Changes.Length() > 0)
                  Folder.Func.Call(Folder.Name, Changes)
               DllCall("ResetEvent", "Ptr", Event)
               DllCall("ReadDirectoryChangesW", "Ptr", Folder.Handle, "Ptr", Folder.FNIAddr, "UInt", SizeOfFNI
                                              , "Int", Folder.SubTree, "UInt", Folder.Watch, "UInt", 0
                                              , "Ptr", Folder.OVLAddr, "Ptr", 0)
            }
            ObjIndex := DllCall("WaitForMultipleObjects", "UInt", ObjCount, "Ptr", &WaitObjects, "Int", 0, "UInt", 0, "UInt")
            Sleep, 0
         }
      }
   }
   ; ===============================================================================================================================
   Else If (Folder = "**PAUSE") { ; called to pause/resume watching
      Paused := !!UserFunc
      RebuildObjects := Paused
   }
   ; ===============================================================================================================================
   Else If (Folder = "**END") { ; called to stop watching
      For Event, Folder In EventArray {
         DllCall("CloseHandle", "Ptr", Folder.Handle)
         DllCall("CloseHandle", "Ptr", Event)
      }
      WatchedFolders := {}
      EventArray := []
      Paused := False
      Return True
   }
   ; ===============================================================================================================================
   Else { ; called to add, update, or remove folders
      Folder := RTrim(Folder, "\")
      VarSetCapacity(LongPath, MAX_DIR_PATH << !!A_IsUnicode, 0)
      If !DllCall("GetLongPathName", "Str", Folder, "Ptr", &LongPath, "UInt", MAX_DIR_PATH)
         Return False
      VarSetCapacity(LongPath, -1)
      Folder := LongPath
      If (WatchedFolders.HasKey(Folder)) { ; update or remove
         Event :=  WatchedFolders[Folder]
         FolderObj := EventArray[Event]
         DllCall("CloseHandle", "Ptr", FolderObj.Handle)
         DllCall("CloseHandle", "Ptr", Event)
         EventArray.Delete(Event)
         WatchedFolders.Delete(Folder)
         RebuildWaitObjects := True
      }
      If InStr(FileExist(Folder), "D") && (UserFunc <> "**DEL") && (EventArray.Count() < MAXIMUM_WAIT_OBJECTS) {
         If (IsFunc(UserFunc) && (UserFunc := Func(UserFunc)) && (UserFunc.MinParams >= 2)) && (Watch &= 0x017F) {
            Handle := DllCall("CreateFile", "Str", Folder . "\", "UInt", 0x01, "UInt", 0x07, "Ptr",0, "UInt", 0x03
                                          , "UInt", 0x42000000, "Ptr", 0, "UPtr")
            If (Handle > 0) {
               Event := DllCall("CreateEvent", "Ptr", 0, "Int", 1, "Int", 0, "Ptr", 0)
               FolderObj := {Name: Folder, Func: UserFunc, Handle: Handle, SubTree: !!SubTree, Watch: Watch}
               FolderObj.SetCapacity("FNIBuff", SizeOfFNI)
               FNIAddr := FolderObj.GetAddress("FNIBuff")
               DllCall("RtlZeroMemory", "Ptr", FNIAddr, "Ptr", SizeOfFNI)
               FolderObj["FNIAddr"] := FNIAddr
               FolderObj.SetCapacity("OVLBuff", SizeOfOVL)
               OVLAddr := FolderObj.GetAddress("OVLBuff")
               DllCall("RtlZeroMemory", "Ptr", OVLAddr, "Ptr", SizeOfOVL)
               NumPut(Event, OVLAddr + 8, A_PtrSize * 2, "Ptr")
               FolderObj["OVLAddr"] := OVLAddr
               DllCall("ReadDirectoryChangesW", "Ptr", Handle, "Ptr", FNIAddr, "UInt", SizeOfFNI, "Int", SubTree
                                              , "UInt", Watch, "UInt", 0, "Ptr", OVLAddr, "Ptr", 0)
               EventArray[Event] := FolderObj
               WatchedFolders[Folder] := Event
               RebuildWaitObjects := True
            }
         }
      }
      If (RebuildWaitObjects) {
         VarSetCapacity(WaitObjects, MAXIMUM_WAIT_OBJECTS * A_PtrSize, 0)
         OffSet := &WaitObjects
         For Event In EventArray
            Offset := NumPut(Event, Offset + 0, 0, "Ptr")
      }
   }
   ; ===============================================================================================================================
   If (EventArray.Count() > 0)
      SetTimer, % TimerFunc, -100
   Return (RebuildWaitObjects) ; returns True on success, otherwise False
}
*/

/*  


*/


;test
/*
||||=====================
||||=====================
||||
||||
||||
||||
||||=====================
||||=====================
||||
||||
||||
||||
||||
||||
*/

replaceFile(File, Content){
    FileDelete, %File%
    FileAppend, %Content%, %File%
}
Return
; .......
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

/*replaceFile(File, Content){
    FileDelete, %File%
    FileAppend, %Content%, %File%
}
*/

ini( filename = 0, updatemode = 0 ){
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

findHWND(controlNames,executableName){

    WinGet, windowIds, List,% "ahk_exe " . executableName                       
    Loop, %windowIds%                                                   ; Note: ControlList gives a `n delimited string, and List gives a pseudo array.
    {
        WinGet,tmpList,ControlList,% "ahk_id " . windowIds%A_Index%     ; From doc: "Controls are sorted according to their Z-order, 
        if (tmpList=controlNames)                                       ; which is usually the same order as TAB key navigation if the window supports tabbing" so the order should be well defined.
            return windowIds%A_Index%                                   ; Window found, return its HWND.
    }
    
    return 0                                                            ; Window not found. 
}

Explorer_GetSelection(hwnd="") {
    hwnd := hwnd ? hwnd : WinExist("A")
    WinGetClass class, ahk_id %hwnd%
    if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
        for window in ComObjCreate("Shell.Application").Windows
            if (window.hwnd==hwnd)
    sel := window.Document.SelectedItems
    for item in sel
    ToReturn .= item.path "`n"
    return Trim(ToReturn,"`n")
}

m(x*){
    static Buttons:={YNC:"Yes,No,Cancel",YN:"Yes,No",OC:"OK,Cancel",ARI:"Abort,Retry,Ignore"}
    m:=New MsgBox(),Default:=1
    for a,b in x{
        Cmd:=StrSplit(b,":")
        if(Cmd.1="Btn")
            Btn:=Buttons[Cmd.2]
        else if(Cmd.1="HTML"){
            HTML:=1
        }else if(Cmd.1="Def"){
            Default:=Cmd.2
        }else{
            Msg.=IsObject(b)?Obj2String(b):b "`r`n"
        }
    }
    m[HTML?"SetHTML":"SetText"](Msg)
    if(Btn)
        m.SetButtons(Btn)
    return m.Show("Win",Default)
}

Obj2String(Obj,FullPath:=1,BottomBlank:=0){
    static String,Blank
    if(FullPath=1)
        String:=FullPath:=Blank:=""
    if(IsObject(Obj)&&!Obj.XML){
        for a,b in Obj{
            if(IsObject(b)&&b.OuterHtml)
                String.=FullPath "." a " = " b.OuterHtml
            else if(IsObject(b)&&!b.XML)
                Obj2String(b,FullPath "." a,BottomBlank)
            else{
                if(BottomBlank=0)
                    String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
                else if(b!="")
                    String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
                else
                    Blank.=FullPath "." a " =`n"
            }
        }
    }else if(Obj.XML)
        String.=FullPath Obj.XML "`n"
    return String Blank
}

Class MsgBox{
    static Keep:=[]
    _Event(Name,Event){
        local
        static
        Node:=Event.srcElement
        CTRL:=this
        if(Name="MouseDown"){
            Mode:=A_CoordModeMouse,Delay:=A_WinDelay
            SetWinDelay,-1
            CoordMode,Mouse,Screen
            if(Node.ID="Title"){
                MouseGetPos,XX,YY
                WinGetPos,X,Y,,,% this.ID
                OffX:=XX-X,OffY:=YY-Y,LastX:=XX,LastY:=YY
                while(GetKeyState("LButton")){
                    MouseGetPos,X,Y
                    if(LastX!=X||LastY!=Y)
                        WinMove,% this.ID,,% X-OffX,% Y-OffY
                    LastX:=X,LastY:=Y
                    Sleep,20
                }
            }
            CoordMode,Mouse,%Mode%
            SetWinDelay,%Delay%
        }else if(Name="OnClick"){
            if(Node.ID="Close"){
                this.ResultValue:=Chr(127)
                Gui,% this.Win ":Destroy"
            }else if(Node.ID="Settings"){
                return m("Settings Coming Soon")
                TT:=this
                SetTimer,ShowSettingsWindow,-1
                return
                ShowSettingsWindow:
                Gui,MsgBoxSettings:Destroy
                Gui,MsgBoxSettings:Default
                Gui,Color,0,0
                Gui,Font,c0xAAAAAA
                Gui,Add,Text,,% "Settings For: " TT.ParentTitle
                Gui,Show
                return
            }else if(Node.ID="Testing"){
                this.ResultValue:=Node.Value
            }if(Node.NodeName="Button"){
                this.ResultValue:=Node.Value
            }
        }
    }__New(Options:=""){
        local
        global MsgBox
        static wb
        Win:="MyMsgBox" A_TickCount
        WinGetActiveTitle,Title
        Gui,%Win%:Destroy
        Gui,%Win%:Default
        Gui,-Caption +HWNDMain +LabelMsgBox. ;+Resize
        Gui,Margin,0,0
        WinGet,HWND,ID,A
        Ver:=this.FixIE(11)
        MsgBox.Keep[Main]:=this
        Gui,Add,ActiveX,vwb HWNDIE,mshtml
        this.FixIE(Ver),this.Owner:=HWND,this.HWND:=IE,this.Win:=Win,this.ParentTitle:=Title,this.ID:="ahk_id" Main+0,this.KeyResult:=[],this.BoundResult:=this.Result.Bind(this),this.CSS:=[]
        RegRead,CheckReg,HKCU\SOFTWARE\Microsoft\Windows\DWM,ColorizationColor
        Color:=(CC:=SubStr(Format("{:x}",CheckReg+0),-5))?CC:"AAAAAA",this.ThemeColor:="#" Color,wb.Navigate("About:Blank")
        for a,b in {Border:DllCall("GetSystemMetrics",Int,33,Int)-1}
            this[a]:=b
        Gui,Color,% "0x" Color,% "0x" Color
        for a,b in {Color:"Grey",Background:"#000000"}
            this[a]:=b
        for a,b in Options
            this[a]:=b
        IconCode:=(II:=Icons[this.Icon]).Code
        while(wb.ReadyState!=4)
            Sleep,10
        this.Doc:=wb.Document,Master:=this.CreateElement("Div",,"-MS-User-Select:None;Margin:0px;Width:100%","Master"),Root:=this.CreateElement("Div",Master,"","Root"),this.Doc.Body.SetAttribute("Style","Background-Color:" this.Background ";Margin:0px;Display:Flex"),this.NormalCSS:=[],this.ButtonCSS:=[],Style:=this.Doc.Body.Style
        for a,b in {ScrollBarBaseColor:this.Background,ScrollBarFaceColor:this.ThemeColor,ScrollBarArrowColor:this.ThemeColor,ScrollBarTrackColor:this.Background}
            Style[a]:=b
        Outer:=this.CreateElement("Div",Root,,"Outer"),this.Outer:=Outer,Header:=this.CreateElement("Div",Outer,"Cursor:Move;Width:100%","Header")
        for a,b in [["Title","Div",Header,"Float:Left;Align-Items:Center;-MS-User-Select:None;text-overflow:ellipsis;overflow:hidden;white-space:nowrap;","Window Title"]
                 ,["Settings","Div",Header,"Position:Absolute;Float:Left;Cursor:Hand;Background-Color:Pink;Display:Flex;Justify-Content:Center;Align-Items:Center;Color:Black;-MS-User-Select:None","S"]
                 ,["Close","Div",Header,"Position:Absolute;Float:Left;Cursor:Hand;Background-Color:Red;Display:Flex;Justify-Content:Center;Align-Items:Center;Color:Black;-MS-User-Select:None","X"]]
            New:=this.CreateElement(b.2,b.3,b.4),New.ID:=b.1,New.InnerText:=b.5,New.SetAttribute("Class","Header")
        Icon:=this.CreateElement("Div",Master,"Display:Inline-Block;Padding-Left:4px;Padding-Right:4px;User-Select:Text;Float:Left;Justify-Content:Center;Align-Items:Center","Icon"),Icon.SetAttribute("Class","Icon"),this.Text:=this.CreateElement("Div",Master,"Display:Block;OverFlow:Auto;-MS-User-Select:Text;White-Space:NoWrap","Text")
        if(II.Color!="")
            Icon.Style.Color:=II.Color
        this.Text.SetAttribute("Class","Text")
        Hotkey,IfWinActive,% this.ID
        for a,b in {Esc:this.Escape.Bind(this),Space:(Enter:=this.Enter.Bind(this)),Enter:Enter
                 ,Left:(Arrows:=this.Arrows.Bind(this)),Right:Arrows,Up:Arrows,Down:Arrows}
            Hotkey,%a%,%b%,On
        this.ButtonDiv:=this.CreateElement("Div",Master,,"Buttons"),this.SetButtons(),this.CreateElement("Div",Master,"Visibility:Hidden;Position:Absolute;Width:Auto;Height:Auto","GetSize"),Script:=this.CreateElement("Script",Root),Script.InnerText:="onclick=function(event){ahk_event('OnClick',event);" "};ondblclick=function(event){ahk_event('OnDoubleClick',event);" "};onmousedown=function(event){ahk_event('MouseDown',event);" "};",Settings.ID:="Settings",Close.ID:="Close",Button.ID:="Testing",this.Doc.ParentWindow.ahk_event:=this._Event.Bind(this)
        if(this.Gradient)
            this.SetBackground({0:this.ThemeColor,100:"#000"}),this.SetBackground({0:this.ThemeColor,100:"#000"},"Icon")
        this.CSS.Button:=this.CreateElement("Style",Root),this.CSS.Header:=this.CreateElement("Style",Root),this.CSS.GetSize:=this.CreateElement("Style",Root),this.CSS.Text:=this.CreateElement("Style",Root),this.CSS.Icon:=this.CreateElement("Style",Root),this.SetCSS({"Header":{Size:20,Background:this.ThemeColor},"Button":{Size:20},"Icon":{Size:120}}),this.SetIcon(this.Icon),this.SetCSS({Text:{Color:this.Color},Header:{Color:this.Color},Button:{Color:this.Color,Background:(this.Gradient?"-ms-linear-gradient(Top," this.ThemeColor " 0%,#383838 70%,#000000 100%)":this.ThemeColor),Border:"1px Solid " this.Background}})
        return this
    }Arrows(){
        local
        Button:=this.GetActive().Value,ID:=this.OrderTab[Button],ID:=ID+(A_ThisHotkey~="i)\b(Up|Left)\b"?-1:1),ID:=ID>this.TabOrder.MaxIndex()?1:ID<=0?this.TabOrder.MaxIndex():ID,this.TabOrder[ID].Obj.Focus()
    }BuildCSS(Obj){
        local
        for a,b in {Size:"Font-Size"}
            if(Value:=Obj[a])
                Obj[b]:=Value "px",Obj.Delete(a)
        Total:="{"
        for a,b in Obj
            Total.=a ":" b ";"
        return Total "}"
    }BuildGradient(Color){
        local
        Start:="Top"
        for a,b in Color{
            if(a="Start")
                Start:=b
            else
                Gradient.=b " " a "%,"
        }return Color:=Gradient?"-ms-linear-gradient(" Start "," Trim(Gradient,",") ")":Color
    }ClearHotkeys(){
        Hotkey,IfWinActive,% this.ID
        for a,b in this.KeyResult
            Hotkey,%a%,Off
        this.KeyResult:=[]
    }CreateElement(Type,Parent:="",Style:="",ID:=""){
        local
        New:=this.Doc.CreateElement(Type),(Parent?Parent.AppendChild(New):this.Doc.Body.AppendChild(New))
        if(Style)
            New.SetAttribute("Style",Style)
        if(ID)
            New.ID:=ID
        return New
    }Enter(){
        this.GetActive().Click()
    }Escape(){
        Gui,% this.Win ":Destroy"
    }FixIE(Version=0){ ;Thanks GeekDude
        local
        static Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
        Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Version:=Versions[Version]?Versions[Version]:Version
        if(A_IsCompiled)
            ExeName:=A_ScriptName
        else
            SplitPath,A_AhkPath,ExeName
        RegRead,PreviousValue,HKCU,%Key%,%ExeName%
        if(!Version)
            RegDelete,HKCU,%Key%,%ExeName%
        else
            RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
        return PreviousValue
    }GetActive(){
        return this.Doc.ActiveElement
    }GetID(ID){
        return this.Doc.GetElementById(ID)
    }Monitor(Monitor:=""){
        local
        SysGet,Count,MonitorCount
        SysGet,Primary,MonitorPrimary
        Obj:=[]
        while(A_Index<=Count){
            SysGet,Mon,MonitorWorkArea,%A_Index%
            Obj[A_Index]:={Left:MonLeft,Top:MonTop,Right:MonRight,Bottom:MonBottom,W:MonRight-MonLeft,H:MonBottom-MonTop}
        }return Obj.Count()=1?Obj.1:Obj[Monitor]?Obj[Monitor]:Obj[Primary]
    }Result(){
        local
        this.ResultValue:=this.KeyResult[A_ThisHotkey]
    }SetBackground(Color,ID:="Text"){
        local
        this.SetCSS({(ID):{Background:this.BuildGradient(Color)}})
    }SetButtons(ButtonsCSV:="OK",Default:="Clipboard,ClipExit,E&xitApp,FileDump"){
        local
        this.ClearHotkeys()
        for a,b in this.ButtonsCSS
            b.ParentNode.RemoveChild(b)
        Buttons:=StrSplit(ButtonsCSV,","),this.OrderTab:=[],this.TabOrder:=[],ID:=1,this.ButtonsCSS:=[]
        while(aa:=this.Doc.GetElementsByTagName("Button").Item[0])
            aa.ParentNode.RemoveChild(aa)
        for a,b in StrSplit(Default,",")
            Buttons.Push(b)
        if(FileExist(A_MyDocuments "\AutoHotkey\Lib\Studio.ahk"))
            Buttons.Push("Studio")
        this.Hotkeys:=[]
        for a,Text in Buttons{
            Button:=this.CreateElement("Button",this.ButtonDiv)
            Button.Value:=RegExReplace(Text,"&")
            Button.ID:="Button" ++ID
            if(RegExMatch(Text,"O)&(.)",Found)){
                if(this.Hotkeys[Found.1])
                    Letter:=this.GetHotkey(Text)
                else
                    Letter:=Found.1
            }else
                Letter:=this.GetHotkey(Text)
            if(Letter)
                this.SetHotkey(Letter,Button.Value)
            Button.InnerHTML:=RegExReplace(Button.Value,Letter,"<u>" Letter "</u>")
            this.OrderTab[Button.Value]:=this.TabOrder.Push({ID:Button.Value,Obj:Button,ButtonID:ID}),Style:=Button.Style,Style.Cursor:="Hand",Button.SetAttribute("Class","Button"),this.Buttons[Button.Value]:=Button,Button.SetAttribute("ButtonID",ID)
        }
    }GetHotkey(Text){
        for a,Letter in StrSplit(RegExReplace(Text,"(\W|\s)")){
            if(!this.Hotkeys[Letter])
                return Letter,this.Hotkeys[Letter]:=1
        }
    }SetButtonCSS(Object){
        local
        for Name,Obj in Object{
            if(!Button:=this.ButtonCSS[Name])
                Button:=this.ButtonCSS[Name]:=[]
            for a,b in Obj
                Button[a]:=(a="Background"?this.BuildGradient(b):b)
            if(!OO:=this.ButtonsCSS[Name])
                OO:=this.ButtonsCSS[Name]:=this.CreateElement("Style")
            OO.InnerText:="#Button" this.Buttons[Name].GetAttribute("ButtonID") this.BuildCSS(Button)
    }}SetCSS(Object){
        local
        for Type,Obj in Object{
            if(!Normal:=this.NormalCSS[Type])
                Normal:=this.NormalCSS[Type]:=[]
            for a,b in Obj
                Normal[a]:=b
            this.CSS[Type].InnerText:="." Type this.BuildCSS(Normal)
            if(Type="Header"&&(VV:=OO["Font-Size"]))
                if(RegExMatch(VV,"O)(\d+)",Found))
                    this.GetID("Close").Style.Width:=Round(Found.1*1.5) "px",Found:=""
    }}SetHotkey(Key,Value){
        local
        Result:=this.BoundResult
        Hotkey,%Key%,%Result%,On
        this.KeyResult[Key]:=Value
    }SetHTML(Text*){
        local
        for a,b in Text
            (a=HTML&&b=1?(HTML:=1):(Msg.=(IsObject(b)?this.Obj2String(b):b)))
        this.Text.InnerHTML:=RegExReplace(Msg,"\R","<br>")
    }SetIcon(Icon){
        local
        static Icons:={"!":{Code:"&#x26A0;",Color:"Yellow"},X:{Code:"&#x2297;",Color:"Red"},"?":{Code:"&#x2753;",Color:"Blue"},I:{Code:"&#x24D8;",Color:"Blue"}},Img
        IconObj:=this.GetID("Icon")
        if(!Icon)
            IconObj.Style.Display:="None"
        else
            IconObj.Style.Display:="Flex"
        if(InStr(Icon,"http")&&!Image)
            (Img:=this.CreateElement("Img",this.GetID("Icon"))),Img.SRC:=this.Icon,Img.Style.MaxWidth:=200,Img.Style.MaxHeight:=200,IconObj.Style.Display:="Flex"
        else
            IconObj.InnerHTML:=(II:=Icons[Icon])?II.Code:Icon
        if(II.Color)
            this.SetCSS({"Icon":{Color:II.Color}})
    }SetText(Text*){
        local
        for a,b in Text
            Msg.=(IsObject(b)?this.Obj2String(b):b)
        this.GetID("Text").InnerText:=Msg
    }Show(Name:="",Default:=1,Ico:=""){
        local
        this.ResultValue:="",this.Doc.GetElementsByTagName("Button").Item[Default-1].Focus(),Text:=this.GetID("Text"),Mon:=this.Monitor(),this.Name:=Name?Name:this.Name,(TT:=this.Doc.GetElementById("Title")).InnerText:=this.Name
        Gui,% this.Win ":Show",w0 h0 Hide
        Ico:=this.Doc.GetElementById("Icon"),IcoWidth:=Ico.ScrollWidth,IcoHeight:=Ico.ScrollHeight,this.Doc.GetElementById("Header").Style.Height:=TT.ScrollHeight,ButtonWidth:=0,Height:=[],Sub:=0
        for a,b in [Close:=this.GetID("Close"),Settings:=this.GetID("Settings")]
            Obj:=this.Doc.GetElementById(b),Sub+=Obj.ClientWidth
        Title:=this.GetID("Title"),this.SetCSS({"Header":{Height:Title.ScrollHeight}})
        for a,b in this.TabOrder
            Rect:=b.Obj.GetBoundingClientRect(),ButtonWidth+=Ceil(Rect.Right-Rect.Left),Height[Ceil(Rect.Height)]:=1
        if(ButtonWidth>Mon.W)
            return this.SetCSS({"Button":{Size:20}}),this.Show(Name)
        MaxW:=W:=A_ScreenWidth-100,MaxH:=H:=A_ScreenHeight-100,HH:=Height.MaxIndex(),AddW:=Text.OffSetWidth-Text.ClientWidth,AddH:=Text.OffSetHeight-Text.ClientHeight
        if((NH:=Text.ScrollHeight+Title.ScrollHeight+HH+AddH)<Mon.H)
            H:=NH,AddW:=0
        if((NH:=IcoHeight+Title.ScrollHeight+HH+AddH)>H)
            H:=NH
        if((NW:=Text.ScrollWidth+IcoWidth+AddW)<Mon.W)
            W:=NW
        if(W<ButtonWidth)
            W:=ButtonWidth
        Width:=Floor(Close.ScrollWidth/2),Close.Style.PaddingLeft:=Width,Close.Style.PaddingRight:=Width
        if(W<Settings.ScrollWidth+Close.ScrollWidth)
            return this.SetCSS({"Header":{Size:30,Height:""}}),this.Show(Name)
        Gui,% this.Win ":Show",xCenter yCenter w%W% h%H%
        ButtonWidth:=0
        for a,b in this.TabOrder
            Rect:=b.Obj.GetBoundingClientRect(),ButtonWidth+=Ceil(Rect.Right-Rect.Left),Height[Ceil(Rect.Height)]:=1
        if(ButtonWidth>Mon.W)
            return this.SetCSS({"Button":{Size:20}}),this.Show(Name)
        if(W<ButtonWidth)
            Gui,% this.Win ":Show",xCenter yCenter w%ButtonWidth% h%H%
        Gui,% this.Win ":+Owner" this.Owner " +MinSize" ButtonWidth "x" TT.ScrollHeight+Height.MaxIndex()+10
        while(!this.ResultValue)
            Sleep,400
        if(this.ResultValue="ClipExit"){
            Clipboard:=Trim(RegExReplace(this.Doc.GetElementById("Text").InnerText,"\<\/?br\>","`r`n"),"`r`n")
            ExitApp
        }
        if(this.ResultValue="FileDump"){
            x:=ComObjActive("{DBD5A90A-A85C-11E4-B0C7-43449580656B}")
            Text:=Trim(RegExReplace(this.Doc.GetElementById("Text").InnerText,"\<\/?br\>","`r`n"),"`r`n")
            x.TempFile(Text)
            ExitApp
        }
        this.ResultValue:=this.ResultValue=Chr(127)?"":this.ResultValue
        if(this.ResultValue="Clipboard"){
            Clipboard:=Trim(RegExReplace(this.Doc.GetElementById("Text").InnerText,"\<\/?br\>","`r`n"),"`r`n")
            Gui,% this.Win ":Destroy"
            return "Clipboard"
        }else if(this.ResultValue="ExitApp")
            ExitApp
        else if(this.ResultValue="Studio"){
            if(x:=ComObjActive("{DBD5A90A-A85C-11E4-B0C7-43449580656B}"))
                x.DebugWindow(Trim(RegExReplace(this.Doc.GetElementById("Text").InnerText,"\<\/?br\>","`r`n"),"`r`n"))
            ExitApp
        }Gui,% this.Win ":Hide"
        return this.ResultValue
    }Size(a:="",W:="",H:=""){
        local Settings,Close,Height,Title
        static Pos:=[]
        this:=IsObject(this)?this:MsgBox.Keep[this]
        WinGet,Style,Style,% this.ID
        if(!W||!H)
            W:=Pos.W,H:=Pos.H
        Pos:={W:W,H:H},Close:=this.GetID("Close"),Settings:=this.GetID("Settings"),Border:=Style&0x40000!=0?this.Border:0
        ControlMove,,%Border%,%Border%,%W%,%H%,% "ahk_id" this.HWND
        Close.Style.Right:="0"
        Settings.Style.Right:=Close.ClientWidth
        Pos1:=Close.GetBoundingClientRect()
        this.Doc.GetElementById("Title").Style.Width:=W-(Close.ScrollWidth+Settings.ScrollWidth)
        Height:=this.Doc.GetElementsByTagName("Button").Item[0].OffSetHeight
        Title:=this.GetID("Title").ScrollHeight
        this.Doc.GetElementById("Icon").Style.Height:=H-Height-Title
        this.Doc.GetElementById("Text").Style.Height:=H-Height-Title
    }
}

Distances(lat1,lon1,lat2,lon2){
    Dist:={} ;Create object for storage
    static p:=0.017453292519943295 ;1 degree in radian
    Dist.Kilometers:=12742*ASin(Sqrt(0.5-Cos((lat2-lat1)*p)/2+Cos(lat1*p)*Cos(lat2*p)*(1-Cos((lon2-lon1)*p))/2)) ;Formula borrowed from Internet search
    Dist.Meters:=Dist.Kilometers*1000 ;meters
    Dist.Miles:=Dist.Kilometers/1.609344 ;miles
    Dist.Feet:=Dist.Kilometers/0.0003048 ;feet
    Dist.Yards:=Dist.Feet/3
    return Dist
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




removespace(ans){

;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
;Fronttext := clipboard
NewStr := StrReplace(ans, A_Space, "_")
;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
clipboard := newstr
return newStr 
}

TrayIcon_GetInfo(sExeName := ""){
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

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Hide
; Description ..: Hide or unhide a tray icon.
; Parameters ...: IDcmd - Command identifier associated with the button.
; ..............: bHide - True for hide, False for unhide.
; ..............: sTray - 1 or Shell_TrayWnd || 0 or NotifyIconOverflowWindow.
; Info .........: TB_HIDEBUTTON message - http://goo.gl/oelsAa
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_Hide(IDcmd, sTray := "Shell_TrayWnd", bHide:=True){
    (sTray == 0 ? sTray := "NotifyIconOverflowWindow" : sTray == 1 ? sTray := "Shell_TrayWnd" : )
    DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
    idxTB := TrayIcon_GetTrayBar()
    SendMessage, 0x404, IDcmd, bHide, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_HIDEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class %sTray%
    DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Delete
; Description ..: Delete a tray icon.
; Parameters ...: idx - 0 based tray icon index.
; ..............: sTray - 1 or Shell_TrayWnd || 0 or NotifyIconOverflowWindow.
; Info .........: TB_DELETEBUTTON message - http://goo.gl/L0pY4R
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_Delete(idx, sTray := "Shell_TrayWnd"){
    (sTray == 0 ? sTray := "NotifyIconOverflowWindow" : sTray == 1 ? sTray := "Shell_TrayWnd" : )
    DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
    idxTB := TrayIcon_GetTrayBar()
    SendMessage, 0x416, idx, 0, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_DELETEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class %sTray%
    DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Remove
; Description ..: Remove a tray icon.
; Parameters ...: hWnd, uID.
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_Remove(hWnd, uID){
        NumPut(VarSetCapacity(NID,(A_IsUnicode ? 2 : 1) * 384 + A_PtrSize * 5 + 40,0), NID)
        NumPut(hWnd , NID, (A_PtrSize == 4 ? 4 : 8 ))
        NumPut(uID  , NID, (A_PtrSize == 4 ? 8  : 16 ))
        Return DllCall("shell32\Shell_NotifyIcon", "Uint", 0x2, "Uint", &NID)
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Move
; Description ..: Move a tray icon.
; Parameters ...: idxOld - 0 based index of the tray icon to move.
; ..............: idxNew - 0 based index where to move the tray icon.
; ..............: sTray - 1 or Shell_TrayWnd || 0 or NotifyIconOverflowWindow.
; Info .........: TB_MOVEBUTTON message - http://goo.gl/1F6wPw
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_Move(idxOld, idxNew, sTray := "Shell_TrayWnd"){
    (sTray == 0 ? sTray := "NotifyIconOverflowWindow" : sTray == 1 ? sTray := "Shell_TrayWnd" : )
    DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
    idxTB := TrayIcon_GetTrayBar()
    SendMessage, 0x452, idxOld, idxNew, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_MOVEBUTTON
    DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Set
; Description ..: Modify icon with the given index for the given window.
; Parameters ...: hWnd       - Window handle.
; ..............: uId        - Application defined identifier for the icon.
; ..............: hIcon      - Handle to the tray icon.
; ..............: hIconSmall - Handle to the small icon, for window menubar. Optional.
; ..............: hIconBig   - Handle to the big icon, for taskbar. Optional.
; Return .......: True on success, false on failure.
; Info .........: NOTIFYICONDATA structure  - https://goo.gl/1Xuw5r
; ..............: Shell_NotifyIcon function - https://goo.gl/tTSSBM
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_Set(hWnd, uId, hIcon, hIconSmall:=0, hIconBig:=0){
    d := A_DetectHiddenWindows
    DetectHiddenWindows, On
    ; WM_SETICON = 0x0080
    If ( hIconSmall ) 
        SendMessage, 0x0080, 0, hIconSmall,, ahk_id %hWnd%
    If ( hIconBig )
        SendMessage, 0x0080, 1, hIconBig,, ahk_id %hWnd%
    DetectHiddenWindows, %d%

    VarSetCapacity(NID, szNID := ((A_IsUnicode ? 2 : 1) * 384 + A_PtrSize*5 + 40),0)
    NumPut( szNID, NID, 0                           )
    NumPut( hWnd,  NID, (A_PtrSize == 4) ? 4   : 8  )
    NumPut( uId,   NID, (A_PtrSize == 4) ? 8   : 16 )
    NumPut( 2,     NID, (A_PtrSize == 4) ? 12  : 20 )
    NumPut( hIcon, NID, (A_PtrSize == 4) ? 20  : 32 )
    
    ; NIM_MODIFY := 0x1
    Return DllCall("Shell32.dll\Shell_NotifyIcon", UInt,0x1, Ptr,&NID)
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_GetTrayBar
; Description ..: Get the tray icon handle.
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_GetTrayBar(Tray:="Shell_TrayWnd"){
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

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_GetHotItem
; Description ..: Get the index of tray's hot item.
; Info .........: TB_GETHOTITEM message - http://goo.gl/g70qO2
; ----------------------------------------------------------------------------------------------------------------------
TrayIcon_GetHotItem(){
    idxTB := TrayIcon_GetTrayBar()
    SendMessage, 0x447, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_GETHOTITEM
    Return ErrorLevel << 32 >> 32
}

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: TrayIcon_Button
; Description ..: Simulate mouse button click on a tray icon.
; Parameters ...: sExeName - Executable Process Name of tray icon.
; ..............: sButton  - Mouse button to simulate (L, M, R).
; ..............: bDouble  - True to double click, false to single click.
; ..............: index    - Index of tray icon to click if more than one match.
; ----------------------------------------------------------------------------------------------------------------------

TrayIcon_Button(sExeName, sButton := "L", bDouble := false, index := 1){
    DetectHiddenWindows, % (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" :
    WM_MOUSEMOVE      = 0x0200
    WM_LBUTTONDOWN    = 0x0201
    WM_LBUTTONUP      = 0x0202
    WM_LBUTTONDBLCLK = 0x0203
    WM_RBUTTONDOWN    = 0x0204
    WM_RBUTTONUP      = 0x0205
    WM_RBUTTONDBLCLK = 0x0206
    WM_MBUTTONDOWN    = 0x0207
    WM_MBUTTONUP      = 0x0208
    WM_MBUTTONDBLCLK = 0x0209
    sButton := "WM_" sButton "BUTTON"
    oIcons := {}
    oIcons := TrayIcon_GetInfo(sExeName)
    msgID  := oIcons[index].msgID
    uID    := oIcons[index].uID
    hWnd   := oIcons[index].hWnd
    if bDouble
        PostMessage, msgID, uID, %sButton%DBLCLK, , ahk_id %hWnd%
    else
        PostMessage, msgID, uID, %sButton%DOWN, , ahk_id %hWnd%
        PostMessage, msgID, uID, %sButton%UP, , ahk_id %hWnd%
    
    DetectHiddenWindows, %Setting_A_DetectHiddenWindows%
    return
}

;==============================[]=================================[]

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
        MsgBox Could not open "%FileDir%\%FileName%".
}
return


}


;==============================[]=================================[]

sendword(){

send := clipboard . "`n"
send := send . "`n"
clipboard := send
oWord := ComObjActive("Word.Application")
oWord.Selection.PasteAndFormat(0)  ; Original Formatting
send := ""
clipboard := ""

/*
WinGet, firsthwnd, id, A
 sub := WinActive("A")

WinActivate, ahk_exe WINWORD.EXE
WinWaitActive, ahk_exe WINWORD.EXE
;send, #5
sleep, 100
send, ^end
send, {enter}
send, ^v 
sleep,100
;send, %clipboard%
send, {enter}
sleep, 5000
WinMinimize, A

WinWaitNotActive, ahk_exe WINWORD.EXE
WinActivate, ahk_id %firsthwnd%
WinActivate, ahk_id %sub%
*/
  }
return
;----Open the selected favorite
