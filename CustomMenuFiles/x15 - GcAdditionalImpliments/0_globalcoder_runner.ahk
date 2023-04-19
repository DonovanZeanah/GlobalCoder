#persistent
 #ErrorStdOut
;Menu, Tray, Icon , Shell32.dll, 32 , 1
menu, tray, icon ,  %A_ScriptDir%\ico\heat\campfire.ico


_obj := {}
_obj.push("C:\Users\donov\AppData\Roaming\Sublime Text\Packages\User")

string:="C:\Users\donov\AppData\Roaming\Sublime Text\Packages\User" ;
runstring(string)

runobj(_obj){
    for k,v in _obj
    {
    msgbox, % k "-" v
    run, % v
    }
}
runstring(string_path){

    string := string_path
    ;run(string){
    run, % string_path
}

;//================


;in console
;subl "p:\app\app\!.ahk"
;"c:/program files/autohotkey/v2/autohotkey.exe" "d:/eventtrigger.ah2"
;"C:\Program Files\AutoHotkey\AutoHotkey.exe" /ErrorStdOut "My Script.ahk" 2>&1 |clip
;//Note: 2>&1 causes stderr to be redirected to stdout, while 2>Filename redirects only stderr to a file.
f24 & e::edit

f24 & esc:: 
    run sublime_text.exe "0_globalcoder.ahk" ;;"%A_ScriptFullPath%" run, d:/ 
    run sublime_text.exe "scratch\globalcoderv2.ah2" ;;"%A_ScriptFullPath%" run, d:/ 
    run, "C:\Program Files\AutoHotkey\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoder.ahk" ;/ErrorStdOut %programfiles%\autohotkey\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
    run, "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" /ErrorStdOut "d:\globalcoder\0_globalcoderv2.ah2" ;/ErrorStdOut %programfiles%\autohotkey\v2\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"
return

f24 & w::
    WinGet, id, List,,, Program Manager
    Loop, %id%
    {
        this_id := id%A_Index%
        WinActivate, ahk_id %this_id%
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        MsgBox, 4, , Visiting All Windows`n%A_Index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
        IfMsgBox, NO, break
    }

    WinGet, ActiveControlList, ControlList, A
    Loop, Parse, ActiveControlList, `n
    {
        MsgBox, 4,, Control #%A_Index% is "%A_LoopField%". Continue?
        IfMsgBox, No
            break
    }
return

f24 & d::
    run("d:/Globalcoder/")
return  



getlog(){
      ;  Loop, Read, InputFile [, OutputFile]
    Loop, Read, A_ScriptDir\logs\q-google.txt , file
    for k,v in file
    msgbox % A_Index is A_LoopField
} ;
getwin() {
    global log
    FormatTime, time, , MMdd-HH-mm
    WinGetActiveTitle, Title
    WinGet, win_proc, ProcessName, A
    WinGet, uniq_id, ID, A
    ; ASCII 30 octal 036 Record Separator
    if %uniq_id%
    FileAppend, %A_Tab%%time%%A_Tab%%uniq_id%%A_Tab%%win_proc%%A_Tab%%Title%`n, *%log%
} ;
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
} ;
target(c){
    send, !d
    send, ^a
    send, {delete}
return
} ;
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
} ;
fs(){
    app := "z:/"
    run explorer.exe 
    WinWaitActive ahk_exe explorer.exe  
    send, {f4} 
    send, ^a
    send, %app%
    send, {enter}
    return
} ;
GetTime(){
    FormatTime, OutputVar
    MsgBox, The time is %OutputVar%
} ;
GetTime2(){
    FormatTime, OutputVar
    Return OutputVar   ;value returned to calling variable
} ;
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
} ;
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
} ;
ss(){
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
}  ;
pdrive(){

    send, !d
    ;send, ^a
    ;send, {del}
    send, p:
    send, {enter}
    return
} ;
CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY){
    static LoadedPic
    LastEL := ErrorLevel
    Gui, Pict:Add, Pic, vLoadedPic, % RegExReplace(File, "^(\*\w+\s)+")
    GuiControlGet, LoadedPic, Pict:Pos
    Gui, Pict:Destroy
    CoordX += LoadedPicW // 2
    CoordY += LoadedPicH // 2
    ErrorLevel := LastEL
} ;
goexplore(){
    WinActive("ahk_exe explorer.exe")
    WinWaitActive, ahk_exe explorer.exe
    WinActivate, ahk_exe explorer.exe
    send, !d
    send, ^a 
    send, {delete}
    send, %frontproject%
} ;
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
} ;
searchahk(answer,outputdir){
    msgbox % outputdir
        SetWorkingDir, outputdir
       ; FileSelectFolder, Outputdir , *StartingFolder, , Prompt
        msgbox % outputdir
        SetWorkingDir, outputdir
    msgbox,% findstring("%answer%", outputdir "/*.ahk")
    return
} ;


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
} ;
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
} ;
run(path:=""){
    if (path = "" )
        path = %frontproject%

        ;run, %path%
        run, % path
        return
}  ;



/*
findstring(string, filepattern = "*.*", rec = 0, case = 0){
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

;ms marktcap 2.7t, 200b annual r