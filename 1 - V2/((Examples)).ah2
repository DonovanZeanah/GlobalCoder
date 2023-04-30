#warn all, off
esc::exitapp

^!o::
{
open
}
^!k::{
    listhotkeys
}
^!l::{
    listlines
}
^!v::{
    var1 := "foo"
    var2 := "bar"
    obj := []
    ListVars
    Pause
}

^!d::{
    run "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" /Debug "D:\(github)\GlobalCoder\gc\GlobalCoder\1 - V2\((classes)).ah2" ;/ErrorStdOut %programfiles%\autohotkey\v2\autohotkey.exe ;"d:\globalcoder\globalcoder.ahk"

}
; This prevents the main window from hiding on minimize:
OnMessage 0x0112, PreventAutoMinimize ; WM_SYSCOMMAND = 0x0112
OnMessage 0x0005, PreventAutoMinimize ; WM_SIZE = 0x0005
; This prevents owned GUI windows (but not dialogs) from automatically minimizing:
OnMessage 0x0018, PreventAutoMinimize
Persistent

OnError LogError
i := Integer("cause_error")

msgbox A_ScriptHwnd

PreventAutoMinimize(wParam, lParam, uMsg, hwnd) {
    if (uMsg = 0x0112 && wParam = 0xF020 && hwnd = A_ScriptHwnd) { ; SC_MINIMIZE = 0xF020
        WinMinimize
        return 0 ; Prevent main window from hiding.
    }
    if (uMsg = 0x0005 && wParam = 1 && hwnd = A_ScriptHwnd) ; SIZE_MINIMIZED = 1
        return 0 ; Prevent main window from hiding.
    if (uMsg = 0x0018 && lParam = 1) ; SW_PARENTCLOSING = 1
        return 0 ; Prevent owned window from minimizing.
}


/*
    LogError(exception, mode) {
        FileAppend "Error on line " exception.Line ": " exception.Message "`n"
            , "errorlog.txt"
        return true
}*/

; Minimize Window to Tray Menu
; https://www.autohotkey.com
; This script assigns a hotkey of your choice to hide any window so that
; it becomes an entry at the bottom of the script's tray menu.  Hidden
; windows can then be unhidden individually or all at once by selecting
; the corresponding item on the menu.  If the script exits for any reason,
; all the windows that it hid will be unhidden automatically.

; CONFIGURATION SECTION: Change the below values as desired.

; This is the maximum number of windows to allow to be hidden (having a
; limit helps performance):
g_MaxWindows := 50
ListVars
Pause
; This is the hotkey used to hide the active window:
g_Hotkey := "^!h"  ; Win+H

; This is the hotkey used to unhide the last hidden window:
g_UnHotkey := "^!u"  ; Win+U

; If you prefer to have the tray menu empty of all the standard items,
; such as Help and Pause, use False. Otherwise, use True:
g_StandardMenu := false

; These next few performance settings help to keep the action within the
; A_HotkeyModifierTimeout period, and thus avoid the need to release and
; press down the hotkey's modifier if you want to hide more than one
; window in a row. These settings are not needed if you choose to have
; the script use the keyboard hook via InstallKeybdHook or other means:
A_HotkeyModifierTimeout := 100
SetWinDelay 10
SetKeyDelay 0

#SingleInstance  ; Allow only one instance of this script to be running.
Persistent

; END OF CONFIGURATION SECTION (do not make changes below this point
; unless you want to change the basic functionality of the script).

g_WindowIDs := []
g_WindowTitles := []

Hotkey g_Hotkey, Minimize
Hotkey g_UnHotkey, UnMinimize

; If the user terminates the script by any means, unhide all the
; windows first:
OnExit RestoreAllThenExit

if g_StandardMenu = true
    A_TrayMenu.Add
else
{
    A_TrayMenu.Delete
    A_TrayMenu.Add "E&xit and Unhide All", RestoreAllThenExit
}
A_TrayMenu.Add "&Unhide All Hidden Windows", RestoreAll
A_TrayMenu.Add  ; Another separator line to make the above more special.

g_MaxLength := 260  ; Reduce this to restrict the width of the menu.

Minimize(*)
{
    if g_WindowIDs.Length >= g_MaxWindows
    {
        MsgBox "No more than " g_MaxWindows " may be hidden simultaneously."
        return
    }

    ; Set the "last found window" to simplify and help performance.
    ; Since in certain cases it is possible for there to be no active window,
    ; a timeout has been added:
    if !WinWait("A",, 2)  ; It timed out, so do nothing.
        return

    ; Otherwise, the "last found window" has been set and can now be used:
    ActiveID := WinGetID()
    ActiveTitle := WinGetTitle()
    ActiveClass := WinGetClass()
    if ActiveClass ~= "Shell_TrayWnd|Progman"
    {
        MsgBox "The desktop and taskbar cannot be hidden."
        return
    }
    ; Because hiding the window won't deactivate it, activate the window
    ; beneath this one (if any). I tried other ways, but they wound up
    ; activating the task bar. This way sends the active window (which is
    ; about to be hidden) to the back of the stack, which seems best:
    Send "!{esc}"
    ; Hide it only now that WinGetTitle/WinGetClass above have been run (since
    ; by default, those functions cannot detect hidden windows):
    WinHide

    ; If the title is blank, use the class instead. This serves two purposes:
    ; 1) A more meaningful name is used as the menu name.
    ; 2) Allows the menu item to be created (otherwise, blank items wouldn't
    ;    be handled correctly by the various routines below).
    if ActiveTitle = ""
        ActiveTitle := "ahk_class " ActiveClass
    ; Ensure the title is short enough to fit. ActiveTitle also serves to
    ; uniquely identify this particular menu item.
    ActiveTitle := SubStr(ActiveTitle, 1, g_MaxLength)

    ; In addition to the tray menu requiring that each menu item name be
    ; unique, it must also be unique so that we can reliably look it up in
    ; the array when the window is later unhidden. So make it unique if it
    ; isn't already:
    for WindowTitle in g_WindowTitles
    {
        if WindowTitle = ActiveTitle
        {
            ; Match found, so it's not unique.
            ActiveIDShort := Format("{:X}" ,ActiveID)
            ActiveIDShortLength := StrLen(ActiveIDShort)
            ActiveTitleLength := StrLen(ActiveTitle)
            ActiveTitleLength += ActiveIDShortLength
            ActiveTitleLength += 1 ; +1 the 1 space between title & ID.
            if ActiveTitleLength > g_MaxLength
            {
                ; Since menu item names are limted in length, trim the title
                ; down to allow just enough room for the Window's Short ID at
                ; the end of its name:
                TrimCount := ActiveTitleLength
                TrimCount -= g_MaxLength
                ActiveTitle := SubStr(ActiveTitle, 1, -TrimCount)
            }
            ; Build unique title:
            ActiveTitle .= " " ActiveIDShort
            break
        }
    }

    ; First, ensure that this ID doesn't already exist in the list, which can
    ; happen if a particular window was externally unhidden (or its app unhid
    ; it) and now it's about to be re-hidden:
    AlreadyExists := false
    for WindowID in g_WindowIDs
    {
        if WindowID = ActiveID
        {
            AlreadyExists := true
            break
        }
    }

    ; Add the item to the array and to the menu:
    if AlreadyExists = false
    {
        A_TrayMenu.Add ActiveTitle, RestoreFromTrayMenu
        g_WindowIDs.Push(ActiveID)
        g_WindowTitles.Push(ActiveTitle)
    }
}


RestoreFromTrayMenu(ThisMenuItem, *)
{
    A_TrayMenu.Delete ThisMenuItem
    ; Find window based on its unique title stored as the menu item name:
    for WindowTitle in g_WindowTitles
    {
        if WindowTitle = ThisMenuItem  ; Match found.
        {
            IDToRestore := g_WindowIDs[A_Index]
            WinShow IDToRestore
            WinActivate IDToRestore  ; Sometimes needed.
            g_WindowIDs.RemoveAt(A_Index)  ; Remove it to free up a slot.
            g_WindowTitles.RemoveAt(A_Index)
            break
        }
    }
}


; This will pop the last minimized window off the stack and unhide it.
UnMinimize(*)
{
    ; Make sure there's something to unhide.
    if g_WindowIDs.Length > 0 
    {
        ; Get the id of the last window minimized and unhide it
        IDToRestore := g_WindowIDs.Pop()
        WinShow IDToRestore
        WinActivate IDToRestore
        
        ; Get the menu name of the last window minimized and remove it
        MenuToRemove := g_WindowTitles.Pop()
        A_TrayMenu.Delete MenuToRemove
    }
}


RestoreAllThenExit(*)
{
    RestoreAll()
    ExitApp  ; Do a true exit.
}


RestoreAll(*)
{
    for WindowID in g_WindowIDs
    {
        IDToRestore := WindowID
        WinShow IDToRestore
        WinActivate IDToRestore  ; Sometimes needed.
        ; Do it this way vs. DeleteAll so that the sep. line and first
        ; item are retained:
        MenuToRemove := g_WindowTitles[A_Index]
        A_TrayMenu.Delete MenuToRemove
    }
    ; Free up all slots:
    global g_WindowIDs := []
    global g_WindowTitles := []
}
; IntelliSense (based on the v1 script by Rajat)
; https://www.autohotkey.com
; This script watches while you edit an AutoHotkey script.  When it sees you
; type a command followed by a comma or space, it displays that command's
; parameter list to guide you.  In addition, you can press Ctrl+F1 (or
; another hotkey of your choice) to display that command's page in the help
; file. To dismiss the parameter list, press Escape or Enter.

; CONFIGURATION SECTION: Customize the script with the following variables.

; The hotkey below is pressed to display the current command's page in the
; help file:
g_HelpHotkey := "^F1"

; The string below must exist somewhere in the active window's title for
; IntelliSense to be in effect while you're typing.  Make it blank to have
; IntelliSense operate in all windows.  Make it Pad to have it operate in
; editors such as Metapad, Notepad, and Textpad.  Make it .ahk to have it
; operate only when a .ahk file is open in Notepad, Metapad, etc.
g_Editor := ".ahk"

; If you wish to have a different icon for this script to distinguish it from
; other scripts in the tray, provide the filename below (leave blank to have
; no icon). For example: E:\stuff\Pics\icons\GeoIcons\Information.ico
g_Icon := ""

; END OF CONFIGURATION SECTION (do not make changes below this point unless
; you want to change the basic functionality of the script).

SetKeyDelay 0
#SingleInstance

g_ThisCmd := ""
g_HelpOn := ""
g_Cmds := []
g_FullCmds := []
g_Word := ""

if g_HelpHotkey != ""
    Hotkey g_HelpHotkey, HelpHotkey

; Change tray icon (if one was specified in the configuration section above):
if g_Icon != ""
    if FileExist(g_Icon)
        TraySetIcon g_Icon

; Determine AutoHotkey's location:
try
    ahk_dir := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoHotkey", "InstallDir")
catch  ; Not found, so look for it in some other common locations.
{
    if A_AhkPath
        SplitPath A_AhkPath,, &ahk_dir
    else if FileExist("..\..\AutoHotkey.chm")
        ahk_dir := "..\.."
    else if FileExist(A_ProgramFiles "\AutoHotkey\AutoHotkey.chm")
        ahk_dir := A_ProgramFiles "\AutoHotkey"
    else
    {
        MsgBox "Could not find the AutoHotkey folder."
        ExitApp
    }
}

g_AhkHelpFile := ahk_dir "\AutoHotkey.chm"

; Read command syntaxes; can be found in AHK Basic, but it's outdated:
Loop Read, ahk_dir "\Extras\Editors\Syntax\Commands.txt"
{
    FullCmd := A_LoopReadLine

    ; Directives have a first space instead of a first comma.
    ; So use whichever comes first as the end of the command name:
    cPos := InStr(FullCmd, "(")
    sPos := InStr(FullCmd, "`s")
    if (!cPos or (cPos > sPos and sPos))
        EndPos := sPos
    else
        EndPos := cPos

    if EndPos
        CurrCmd := SubStr(FullCmd, 1, EndPos - 1)
    else  ; This is a directive/command with no parameters.
        CurrCmd := A_LoopReadLine
    
    CurrCmd := StrReplace(CurrCmd, "[")
    CurrCmd := StrReplace(CurrCmd, "`s")
    FullCmd := StrReplace(FullCmd, "``n", "`n")
    FullCmd := StrReplace(FullCmd, "``t", "`t")
    
    ; Make arrays of command names and full cmd syntaxes:
    g_Cmds.Push(CurrCmd)
    g_FullCmds.Push(FullCmd)
}

; Use the Input function to watch for commands that the user types:
Loop
{
    ; Editor window check:
    if !WinActive(g_Editor)
    {
        ToolTip
        Sleep 500
        Continue
    }
    
    ; Get all keys till endkey:
    Hook := Input("V", "{Enter}{Escape}{Space},")
    g_Word := Hook.Input
    EndKey := Hook.EndKey
    
    ; ToolTip is hidden in these cases:
    if EndKey = "Enter" or EndKey = "Escape"
    {
        ToolTip
        Continue
    }

    ; Editor window check again!
    if !WinActive(g_Editor)
    {
        ToolTip
        Continue
    }

    ; Compensate for any indentation that is present:
    g_Word := StrReplace(g_Word, "`s")
    g_Word := StrReplace(g_Word, "`t")
    if g_Word = ""
        Continue
    
    ; Check for commented line:
    Check := SubStr(g_Word, 1, 1)
    if (Check = ";" or g_Word = "If")  ; "If" seems a little too annoying to show tooltip for.
        Continue

    ; Match word with command:
    Index := ""
    for Cmd in g_Cmds
    {
        ; The value put into g_ThisCmd is also used by the HelpHotkey function:
        g_ThisCmd := Cmd
        if (g_Word = g_ThisCmd)
        {
            Index := A_Index
            g_HelpOn := g_ThisCmd
            break
        }
    }
    
    ; If no match then resume watching user input:
    if Index = ""
        Continue
    
    ; Show matched command to guide the user:
    ThisFullCmd := g_FullCmds[Index]
    CaretGetPos &CaretX, &CaretY
    ToolTip ThisFullCmd, CaretX, CaretY + 20
}



; This script was originally written for AutoHotkey v1.
; Input() is a rough reproduction of the Input command.
Input(Options:="", EndKeys:="", MatchList:="") {
    static ih
    ;if IsSet(&ih) && ih.InProgress
        ;ih.Stop()
    ih := InputHook(Options, EndKeys, MatchList)
    ih.Start()
    ih.Wait()
    return ih
}



HelpHotkey(*)
{
    global g_ThisCmd  ; Declared because this function modifies it.
    
    if !WinActive(g_Editor)
        return

    ToolTip  ; Turn off syntax helper since there is no need for it now.

    SetTitleMatchMode 1  ; In case it's 3. This setting is in effect only for this thread.
    if !WinExist("AutoHotkey Help")
    {
        if !FileExist(g_AhkHelpFile)
        {
            MsgBox "Could not find the help file: " g_AhkHelpFile
            return
        }
        Run g_AhkHelpFile
        WinWait "AutoHotkey Help"
    }

    if g_ThisCmd = ""  ; Instead, use what was most recently typed.
        g_ThisCmd := g_Word

    ; The above has set the "last found" window which we use below:
    WinActivate
    WinWaitActive
    g_ThisCmd := StrReplace(g_ThisCmd, "#", "{#}")  ; Replace leading #, if any.
    Send "!n{home}+{end}" g_HelpOn "{enter}"
}

$^2::
{
    ; The following values are in effect only for the duration of this hotkey thread.
    ; Therefore, there is no need to change them back to their original values
    ; because that is done automatically when the thread ends:
    SetWinDelay 10
    SetKeyDelay 0

    C_ClipboardPrev := A_Clipboard
    A_Clipboard := ""
    ; Use the highlighted word if there is one (since sometimes the user might
    ; intentionally highlight something that isn't a function):
    Send "^c"
    if !ClipWait(0.1)
    {
        ; Get the entire line because editors treat cursor navigation keys differently:
        Send "{home}+{end}^c"
        if !ClipWait(0.2)  ; Rare, so no error is reported.
        {
            A_Clipboard := C_ClipboardPrev
            return
        }
    }
    C_Cmd := Trim(A_Clipboard)  ; This will trim leading and trailing tabs & spaces.
    A_Clipboard := C_ClipboardPrev  ; Restore the original clipboard for the user.
    Loop Parse, C_Cmd, "`s"  ; The first space is the end of the function.
    {
        C_Cmd := A_LoopField
        break ; i.e. we only need one interation.
    }
    if !WinExist("AutoHotkey Help")
    {
        ; Determine AutoHotkey's location:
        try
            ahk_dir := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoHotkey", "InstallDir")
        catch  ; Not found, so look for it in some other common locations.
        {
            if A_AhkPath
                SplitPath A_AhkPath,, &ahk_dir
            else if FileExist("..\..\AutoHotkey.chm")
                ahk_dir := "..\.."
            else if FileExist(A_ProgramFiles "\AutoHotkey\AutoHotkey.chm")
                ahk_dir := A_ProgramFiles "\AutoHotkey"
            else
            {
                MsgBox "Could not find the AutoHotkey folder."
                return
            }
        }
        Run ahk_dir "\AutoHotkey.chm"
        WinWait "AutoHotkey Help"
    }
    ; The above has set the "last found" window which we use below:
    WinActivate
    WinWaitActive
    C_Cmd := StrReplace(C_Cmd, "#", "{#}")
    Send "!n{home}+{end}" C_Cmd "{enter}"
}

~[::
{
    Hook := InputHook("V T5 L4 C", "{enter}.{esc}{tab}", "btw,otoh,fl,ahk,ca")
    Hook.Start()
    Hook.Wait()
    switch Hook.EndReason
    {
    case "Max":
        MsgBox 'You entered "' Hook.Input '", which is the maximum length of text.'
    case "Timeout":
        MsgBox 'You entered "' Hook.Input '" at which time the input timed out.'
    case "EndKey":
        MsgBox 'You entered "' Hook.Input '" and terminated the input with ' Hook.EndReason '.'
    default:  ; Match
        switch Hook.Input
        {
        case "btw":   Send "{backspace 3}by the way"
        case "otoh":  Send "{backspace 4}on the other hand"
        case "fl":    Send "{backspace 2}Florida"
        case "ca":    Send "{backspace 2}California"
        case "ahk":
            Send "{backspace 3}"
            Run "https://www.autohotkey.com"
        }
    }
}

~^a:: { ;Log errors caused by the script into a text file instead of displaying them to the user.
    
    OnError LogError
    i := Integer("cause_error")

    LogError(exception, mode) {
        FileAppend "Error on line " exception.Line ": " exception.Message "`n"
            , "errorlog.txt"
        return true
    }

     ;Use OnError to implement alternative error handling methods. Caveat: OnError is ineffective while Try is active.
   

    ; Call the test function which suppresses and accumulates errors.
    RearrangeWindows()
    ; Call another function to show normal error behaviour is restored.
    WinMove 0, 0, 0, 0, "non-existent window"
    }
~^b:: { ; Loop Parse 
    ;a comma-separated string.
    Colors := "red,green,blue"
    Loop parse, Colors, ","
    {
        MsgBox "Color number " A_Index " is " A_LoopField
    }
     ;Reads the lines inside a variable, one by one (similar to a file-reading loop). A file can be loaded into a variable via FileRead.

    Loop parse, FileContents, "`n", "`r"  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
    {
        Result := MsgBox("Line number " A_Index " is " A_LoopField ".`n`nContinue?",, "y/n")
    }
    until Result = "No"

     ;This is the same as the example above except that it's for the clipboard. It's useful whenever the clipboard contains files, such as those copied from an open Explorer window (the program automatically converts such files to their file names).
    Loop parse, A_Clipboard, "`n", "`r"
    {
        Result := MsgBox("File number " A_Index " is " A_LoopField ".`n`nContinue?",, "y/n")
    }
    until Result = "No"

     ;Parses a comma separated value (CSV) file.
    Loop read, "C:\Database Export.csv"
    {
        LineNumber := A_Index
        Loop parse, A_LoopReadLine, "CSV"
        {
            Result := MsgBox("Field " LineNumber "-" A_Index " is:`n" A_LoopField "`n`nContinue?",, "y/n")
            if Result = "No"
                return
        }
    }
     ;Determines which delimiter was encountered.

    ; Initialize string to search.
    Colors := "red,green|blue;yellow|cyan,magenta"
    ; Initialize counter to keep track of our position in the string.
    Position := 0

    Loop Parse, Colors, ",|;"
    {
        ; Calculate the position of the delimiter at the end of this field.
        Position += StrLen(A_LoopField) + 1
        ; Retrieve the delimiter found by the parsing loop.
        Delimiter := SubStr(Colors, Position, 1)

        MsgBox "Field: " A_LoopField "`nDelimiter: " Delimiter
    }} ;note
~^c:: { ;splitpath
    msgbox "c"
       FullFileName := "d:/test/file.txt"
          
       ; To fetch only the bare filename from the above:
        test := SplitPath FullFileName, name
        msgbox test

       ; To fetch only its directory:
       SplitPath FullFileName,, &dir

       ; To fetch all info:
       SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive
          
       ; The above will set the variables as follows:
       ; name = Address List.txt
       ; dir = C:\My Documents
       ; ext = txt
       ; name_no_ext = Address List
       ; drive = C: 

    }
~^d:: { ;loop parse string (delim)
        ;remove cr-lf's

        A_Clipboard := StrReplace(A_Clipboard, "`r`n")

        ;replace space with +
        NewStr := StrReplace(OldStr, A_Space, "+")

        ;Removes all blank lines from the text in a variable.

        Loop
        {
            MyString := StrReplace(MyString, "`r`n`r`n", "`r`n",, &Count)
            if (Count = 0)  ; No more replacements needed.
                break
        }
    } ;note ;stringreplace()
~^e:: ;array usage
    {
        grid := [[1,2,3],
                 [4,5,6],
                 [7,8,9]]
        MsgBox grid[1][3] ; 3
        MsgBox grid[3][2] ; 8

        ;A custom object can implement multi-dimensional support by defining an __Item property. For example:
        ; class Array2D extends Array {
        ;     __new(x, y) {
        ;         this.Length := x * y
        ;         this.Width := x
        ;         this.Height := y
        ;     }
        ;     __Item[x, y] {
        ;         get => super[this.Width * (y-1) + x]
        ;         set => super[this.Width * (y-1) + x] := value
        ;     }
        ; }

        grid := Array2D(4, 3)
        grid[4, 1] := "#"
        grid[3, 2] := "#"
        grid[2, 2] := "#"
        grid[1, 3] := "#"
        gridtext := ""
        Loop grid.Height {
            y := A_Index
            Loop grid.Width {
                x := A_Index
                gridtext .= grid[x, y] || "-"
            }
            gridtext .= "`n"
        }
        MsgBox gridtext
    }
~^f:: ;File/Folder Looping
    {

    ;## Reports the full path of each text file located in a directory and in its subdirectories.
            Loop Files, A_ProgramFiles "\*.txt", "R"  ; Recurse into subfolders.
            {
                Result := MsgBox("Filename = " A_LoopFilePath "`n`nContinue?",, "y/n")
                if Result = "No"
                    break
            }
    ;## Calculates the size of a folder, including the files in all its subfolders.
            FolderSizeKB := 0
            WhichFolder := DirSelect()  ; Ask the user to pick a folder.
            Loop Files, WhichFolder "\*.*", "R"
                FolderSizeKB += A_LoopFileSizeKB
            MsgBox "Size of " WhichFolder " is " FolderSizeKB " KB."
             ;Retrieves file names sorted by name (see next example to sort by date).

            FileList := ""  ; Initialize to be blank.
            
            Loop Files, "C:\*.*"
                FileList .= A_LoopFileName "`n"
            
            FileList := Sort(FileList, "R")  ; The R option sorts in reverse order. See Sort for other options.
            
            Loop Parse, FileList, "`n"
            {
                if A_LoopField = ""  ; Ignore the blank item at the end of the list.
                    continue
                Result := MsgBox("File number " A_Index " is " A_LoopField ".  Continue?",, "y/n")
                if Result = "No"
                    break
            }
    ;## Retrieves file names sorted by modification date.

            FileList := ""
            Loop Files, A_MyDocuments "\Photos\*.*", "FD"  ; Include Files and Directories
                FileList .= A_LoopFileTimeModified "`t" A_LoopFileName "`n"
            
            FileList := Sort(FileList)  ; Sort by date.
            
            Loop Parse, FileList, "`n"
            {
                if A_LoopField = "" ; Omit the last linefeed (blank item) at the end of the list.
                    continue
                FileItem := StrSplit(A_LoopField, A_Tab)  ; Split into two parts at the tab char.
                Result := MsgBox("The next file (modified at " FileItem[1] ") is:`n" FileItem[2] "`n`nContinue?",, "y/n")
                if Result = "No"
                    break
            }
    ;## Copies only the source files that are newer than their counterparts in the destination. 
            
            ;Call this function with a source pattern like "A:\Scripts\*.ahk" and an existing destination directory 
            ;like "B:\Script Backup".

            CopyIfNewer(SourcePattern, Dest)
            {
                Loop Files, SourcePattern
                {
                    copy_it := false
                    if !FileExist(Dest "\" A_LoopFileName)  ; Always copy if target file doesn't yet exist.
                        copy_it := true
                    else
                    {
                        time := FileGetTime(Dest "\" A_LoopFileName)
                        time := DateDiff(time, A_LoopFileTimeModified, "Seconds")  ; Subtract the source file's time from the destination's.
                        if time < 0  ; Source file is newer than destination file.
                            copy_it := true
                    }
                    if copy_it
                    {
                        try
                            FileCopy A_LoopFilePath, Dest "\" A_LoopFileName, 1   ; Copy with overwrite=yes
                        catch
                            MsgBox 'Could not copy "' A_LoopFilePath '" to "' Dest '\' A_LoopFileName '".'
                    }
                }
            }
    ;## Converts filenames passed in via command-line parameters to long names, 
             ;complete path, and correct uppercase/lowercase characters as stored in the file system.

            for GivenPath in A_Args  ; For each parameter (or file dropped onto a script):
            {
                Loop Files, GivenPath, "FD"  ; Include files and directories.
                    LongPath := A_LoopFilePath
                MsgBox "The case-corrected long path name of file`n" GivenPath "`nis:`n" LongPath
            }
    }
~^g:: ;Splitpath
    {
        FullFileName := "C:\My Documents\Address List.txt"
           
    ; To fetch only the bare filename from the above:
        SplitPath FullFileName, &name

    ; To fetch only its directory:
        SplitPath FullFileName,, &dir

    ; To fetch all info:
        SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive
           
        ; The above will set the variables as follows:
        ; name = Address List.txt
        ; dir = C:\My Documents
        ; ext = txt
        ; name_no_ext = Address List
        ; drive = C:
    }
~^h:: ;Ini
    {
        ;## Reads the value of a key located in section2 from a standard format .ini file and stores it in Value.
            Value := IniRead("C:\Temp\myfile.ini", "section2", "key")
            MsgBox "The value is " Value
        ;## write
            IniWrite "this is a new value", "C:\Temp\myfile.ini", "section2", "key"

    }
~^i:: ;Registry Read and Write
    {
    ;Writes a string to the registry.
        RegWrite "Test Value", "REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\TestKey", "MyValueName"
    ;Writes binary data to the registry.
        RegWrite "01A9FF77", "REG_BINARY", "HKEY_CURRENT_USER\Software\TEST_APP", "TEST_NAME"
    ;Writes a multi-line string to the registry.
        RegWrite "Line1`nLine2", "REG_MULTI_SZ", "HKEY_CURRENT_USER\Software\TEST_APP", "TEST_NAME"
    }
~^j:: ;Gui Texteditor
    {
        ; Create the MyGui window:
        MyGui := Gui("+Resize", "Untitled")  ; Make the window resizable.

        ; Create the submenus for the menu bar:
        FileMenu := Menu()
        FileMenu.Add("&New", MenuFileNew)
        FileMenu.Add("&Open", MenuFileOpen)
        FileMenu.Add("&Save", MenuFileSave)
        FileMenu.Add("Save &As", MenuFileSaveAs)
        FileMenu.Add() ; Separator line.
        FileMenu.Add("E&xit", MenuFileExit)
        HelpMenu := Menu()
        HelpMenu.Add("&About", MenuHelpAbout)

        ; Create the menu bar by attaching the submenus to it:
        MyMenuBar := MenuBar()
        MyMenuBar.Add("&File", FileMenu)
        MyMenuBar.Add("&Help", HelpMenu)

        ; Attach the menu bar to the window:
        MyGui.MenuBar := MyMenuBar

        ; Create the main Edit control:
        MainEdit := MyGui.Add("Edit", "WantTab W600 R20")

        ; Apply events:
        MyGui.OnEvent("DropFiles", Gui_DropFiles)
        MyGui.OnEvent("Size", Gui_Size)

        MenuFileNew()  ; Apply default settings.
        MyGui.Show()  ; Display the window.

        MenuFileNew(*)
        {
            MainEdit.Value := ""  ; Clear the Edit control.
            FileMenu.Disable("3&")  ; Gray out &Save.
            MyGui.Title := "Untitled"
        }

        MenuFileOpen(*)
        {
            MyGui.Opt("+OwnDialogs")  ; Force the user to dismiss the FileSelect dialog before returning to the main window.
            SelectedFileName := FileSelect(3,, "Open File", "Text Documents (*.txt)")
            if SelectedFileName = "" ; No file selected.
                return
            global CurrentFileName := readContent(SelectedFileName)
        }

        MenuFileSave(*)
        {
            saveContent(CurrentFileName)
        }

        MenuFileSaveAs(*)
        {
            MyGui.Opt("+OwnDialogs")  ; Force the user to dismiss the FileSelect dialog before returning to the main window.
            SelectedFileName := FileSelect("S16",, "Save File", "Text Documents (*.txt)")
            if SelectedFileName = "" ; No file selected.
                return
            global CurrentFileName := saveContent(SelectedFileName)
        }

        MenuFileExit(*)  ; User chose "Exit" from the File menu.
        {
            WinClose()
        }

        MenuHelpAbout(*)
        {
            About := Gui("+owner" MyGui.Hwnd)  ; Make the main window the owner of the "about box".
            MyGui.Opt("+Disabled")  ; Disable main window.
            About.Add("Text",, "Text for about box.")
            About.Add("Button", "Default", "OK").OnEvent("Click", About_Close)
            About.OnEvent("Close", About_Close)
            About.OnEvent("Escape", About_Close)
            About.Show()

            About_Close(*)
            {
                MyGui.Opt("-Disabled")  ; Re-enable the main window (must be done prior to the next step).
                About.Destroy()  ; Destroy the about box.
            }
        }

        readContent(FileName)
        {
            try
                FileContent := FileRead(FileName)  ; Read the file's contents into the variable.
            catch
            {
                MsgBox("Could not open '" FileName "'.")
                return
            }
            MainEdit.Value := FileContent  ; Put the text into the control.
            FileMenu.Enable("3&")  ; Re-enable &Save.
            MyGui.Title := FileName  ; Show file name in title bar.
            return FileName
        }

        saveContent(FileName)
        {
            try
            {
                if FileExist(FileName)
                    FileDelete(FileName)
                FileAppend(MainEdit.Value, FileName)  ; Save the contents to the file.
            }
            catch
            {
                MsgBox("The attempt to overwrite '" FileName "' failed.")
                return
            }
            ; Upon success, Show file name in title bar (in case we were called by MenuFileSaveAs):
            MyGui.Title := FileName
            return FileName
        }

        Gui_DropFiles(thisGui, Ctrl, FileArray, *)  ; Support drag & drop.
        {
            CurrentFileName := readContent(FileArray[1])  ; Read the first file only (in case there's more than one).
        }

        Gui_Size(thisGui, MinMax, Width, Height)
        {
            if MinMax = -1  ; The window has been minimized. No action needed.
                return
            ; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
            MainEdit.Move(,, Width-20, Height-20)
        }
    }
~^k:: ;transparent gui no activate
    {
        MyGui := Gui()
        MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
        MyGui.BackColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
        MyGui.SetFont("s32")  ; Set a large font size (32-point).
        CoordText := MyGui.Add("Text", "cLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
        ; Make all pixels of this color transparent and make the text itself translucent (150):
        WinSetTransColor(MyGui.BackColor " 150", MyGui)
        SetTimer(UpdateOSD, 200)
        UpdateOSD()  ; Make the first update immediate rather than waiting for the timer.
        MyGui.Show("x0 y400 NoActivate")  ; NoActivate avoids deactivating the currently active window.

        UpdateOSD(*)
        {
            MouseGetPos &MouseX, &MouseY
            CoordText.Value := "X" MouseX ", Y" MouseY
        }
    }
~^l::
    {

        ;View(viewModel())
        View(Controller(Model(3)))
      
    }
~^m::
    {

        ;gui := View()
        ;vm := ViewModel(gui)
    }
~^n::
    {
        ;1
        ;numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

       ; evenSquares := numbers.asEnumerable().where(number => (mod(number, 2) = 0)).select(number => number * number)

       ; evenSquares.foreach(square => msgbox(square))

        ;2
        words := ["apple", "banana", "cherry", "application", "an", "date", "elderberry", "fig", "grape"]

        aWords := words.asEnumerable().where(word => (substr(word, 1, 1) = "a")).orderby(word => strlen(word))

        aWords.foreach(word => msgbox(word))
        ;Usage4: Query the names and majors of all male students over the age of 20
       ; Code: Select all - Expand View - Download - Toggle Line numbers

        

        students := [Student(Name := "Alice", Age := 20, _Gender := Gender.Female, Major := "Computer Science"),
        Student(Name := "Bob", Age := 22, _Gender := Gender.Male, Major := "Mathematics"),
        Student(Name := "Charlie", Age := 21, _Gender := Gender.Male, Major := "Physics"),
        Student(Name := "David", Age := 19, _Gender := Gender.Male, Major := "Computer Science"),
        Student(Name := "Eve", Age := 20, _Gender := Gender.Female, Major := "Computer Science")]

        query := students.asEnumerable().where(student => (student.Age > 20 && student.Gender = Gender.Male)).select(student => {Name: student.Name, Major: student.Major})
        query.foreach(result => msgbox(result.Name " - " result.Major))
        ;Source Code:
        bindGetArray := ["length", "size"]
        IEnumerable.bindGet(bindGetArray)
        bindCallArray := ["aggregate", "all", "any", "asEnumerable", "average", "chunk", "clone", "combination", "concat", "conflict", "contains", "count", "defaultIfEmpty", "distinct", "each", "elementAt", "elementAtOrDefault", "every", "except", "filter", "find", "findIndex", "findLast", "findLastIndex", "first", "firstOrDefault", "forEach", "groupBy", "groupJoin", "includes", "indexOf", "indices", "innerJoin", "intersect", "isSub", "isSuper", "join", "last", "lastOrDefault", "leftJoin", "leftPad", "map", "max", "maxIndex", "maxOrDefault", "min", "minIndex", "minOrDefault", "nearBy", "nearSplit", "ofType", "orderBy", "orderByDescending", "permutation", "product", "proportion", "rand", "random", "randomOrDefault", "reverse", "rightJoin", "rightPad", "select", "single", "singleOrDefault", "skip", "skipProportion", "skipSame", "skipWhile", "take", "takeProportion", "takeSame", "takeWhile", "slice", "some", "split", "sum", "toArray", "toMap", "toObject", "union", "where", "wipe", "zip"]
        IEnumerable.bindCall(bindCallArray)
        _ := (object.defineprop)(any.prototype, "asEnumerable", {call: Enumerable.asEnumerable.bind(Enumerable)})
        _ := (object.defineprop)(string.prototype, "__enum", {call: IEnumerable.strEnum.bind(IEnumerable)})
        _ := (object.defineprop)(number.prototype, "__enum", {call: IEnumerable.strEnum.bind(IEnumerable)})

        
    }
~^o::
    {

    }
~^p::
    {

    }
~^q::
    {

    }
~^r::
    {

    }
~^s::
    {

    }
~^t::
    {

    }
~^u::
    {

    }
~^v::
    {

    }
~^w::
    {

    }
~^x::
    {

    }
~^y::
    {

    }
~^z::
    {

    }


    class Student
    {
        __new(Name, Age, Gender, Major)
        {
            this.Name := Name
            this.Age := Age
            this.Gender := Gender
            this.Major := Major
        }
    }

    class Gender
    {
        static Female := 0
        static Male := 1
    }
    class Model
    {
       __New(MaxCount, MsgNumber := 0x5555) {
          this.max_count := MaxCount
          this.msg_number := MsgNumber
          this.gui_title := "MVC Example"
          this.gui_width := 250
          this.count := 0
          SetTimer ObjBindMethod(this, "Count_Monitor")
       }
       
       Count_Monitor() {
          if this.count = this.max_count {
             SetTimer , 0
             this.Post_Message()
          }
       }
       
       Post_Message(wParam := 0, lParam := 0) {
          SetTitleMatchMode 2
          DetectHiddenWindows true
          PostMessage this.msg_number, wParam, lParam, A_ScriptHwnd
          DetectHiddenWindows false
       }
    }

    class View extends Gui
    {
       __New(controller) {
          super.__New("-MinimizeBox -MaximizeBox", controller.model.gui_title)
          
          this.button := super.Add("Button", "x100 Default", "My Button")
          this.button.OnEvent("Click", ObjBindMethod(controller, "Button_Click"))
          
          super.Show("w" controller.model.gui_width)
          super.OnEvent("Close",  ObjBindMethod(controller, "Gui_Close"))
          super.OnEvent("Escape", ObjBindMethod(controller, "Gui_Close"))
          
          OnMessage(controller.model.msg_number, ObjBindMethod(this, "Msg_Monitor"), -1)
       }
       
       Msg_Monitor(*) {
          this.button.Text := "Done"
          this.button.Enabled := false
       }
    }

    class Controller
    {
       __New(model) {
          this.model := model
          OnMessage(this.model.msg_number, ObjBindMethod(this, "Msg_Monitor"))
       }
       
       Msg_Monitor(*) {
          MsgBox "The button was clicked the maximum number of times (" this.model.count ").`n`nThe script will now exit."
          ExitApp
       }
       
       Button_Click(GuiCtrl, Info) {
          GuiCtrl.Gui.Opt("+OwnDialogs")
          MsgBox "You now have clicked the button " (++this.model.count) " time(s)."
       }
       
       Gui_Close(Gui) {
          Gui.Opt("+OwnDialogs")
          MsgBox "The button was clicked " this.model.count " time(s) in total.`n`nThe script will now exit."
          ExitApp
       }
    }

     class ViewModel extends View
     {
         Prop1
         {
             get => this._text1.Text
             set => this._text1.Text := Value
         }

         __New(parent) {
            /*super.__New()
            this._button.OnEvent("Click", ObjBindMethod(this, "ButtonClicked"))*/
            super.__New(parent, "-DPIScale")
            this._button.OnEvent("Click", ObjBindMethod(this, "ButtonClicked"))
         }

         ButtonClicked(*) {
             this.Prop1 := "Button Clicked"
             msgbox(this.prop1)
         }
     }

     class View2 extends Gui
     {
         __New() {
             super.__New("-DPIScale")
             this._text1 := super.Add("Text", "xm ym r1 w200")
             this._button := super.Add("Button", "xm y+m", "button")
             super.Show("w400 h400 Center")
         }
     }

     class Enumerable
     {
         static call(source)
         {
             return this.asEnumerable(source)
         }
         
         static asEnumerable(source)
         {
             if source is Enumerator
                 return source
             try
             {
                 if source.hasprop("__enum")
                 {
                     enum := source.__enum()
                     numput("ptr", objptr(Enumerator.prototype), objptr(enum), 0x10)
                     return enum
                 }
                 return source.ownprops()
             }
             throw typeerror("Non-iterative source.")
         }
         
         static between(start?, end?, step := 1)
         {
             _step := step
             if isset(start) && isset(end)
             {
                 _start := integer(start)
                 _end := integer(end)
             }
             else if isset(start)
             {
                 _start := 0
                 _end := integer(start)
             }
             else
                 throw valueerror("at least input end number.(default start is 0 and step is 1)")
             fn(&value)
             {
                 if _start <= _end
                 {
                     value := _start
                     _start += _step
                     return true
                 }
                 _start := fn.params[1]
                 return false
             }
             this.toEnumerator(fn)
             fn.params := [_start, _end, _step]
             return fn
         }
         
         static clone(enum)
         {
             if !(enum is Enumerator)
                 return enum.asEnumerable()
             try
             {
                 iter := objfromptraddref(numget(objptr(enum), 5 * a_ptrsize + 0x10, "ptr")).__enum()
                 numput("int", -1, objptr(iter), 6 * a_ptrsize + 0x10)
                 return iter
             }
             catch
             {
                 _func := objfromptraddref(numget(numget(objptr(enum), 0x10 + 5 * a_ptrsize, "ptr"), 0x10 + 11 * a_ptrsize, "ptr"))
                 flag := numget(objptr(_func), 0x10 + 8 * a_ptrsize, "ptr")
                 if flag
                     _func := _func.bind(objfromptraddref(flag))
                 if enum.hasprop("params")
                     return _func(enum.params*)
                 return _func()
             }
         }
         
         static from(source)
         {
             return this.asEnumerable(source)
         }
         
         static generate(generate, count := 1)
         {
             static enum := [&key1, &key2, &key3, &key4, &key5, &key6, &key7, &key8, &key9, &key10, &key11, &key12, &key13, &key14, &key15, &key16, &key17, &key18, &key19]
             iter := generate()
             fn(args*)
             {
                 if args.length != count
                     throw valueerror("Enumerator only support " count " outputs.")
                 tmp_enum := enum.clone()
                 tmp_enum.length := count
                 ret := iter(tmp_enum*)
                 if !ret
                     return false
                 for child in tmp_enum
                     %args[a_index]% := %child%
                 return true
             }
             this.toEnumerator(fn)
             fn.params := [generate, count]
             return fn
         }
         
         static range(start?, count?, step := 1)
         {
             _index := 0
             _step := step
             if isset(start) && isset(count)
             {
                 _start := integer(start)
                 _count := integer(count)
             }
             else
                 throw valueerror("at least input start and count number.(default step is 1)")
             fn(&value)
             {
                 if _index < _count
                 {
                     value := _start
                     _start += _step
                     _index++
                     return true
                 }
                 _start := fn.params[1]
                 _index := 0
                 return false
             }
             this.toEnumerator(fn)
             fn.params := [_start, _count, _step]
             return fn
         }
         
         static repeat(element?, count?)
         {
             _index := 0
             if isset(element) && isset(count)
             {
                 _element := element
                 _count := integer(count)
             }
             else
                 throw valueerror("please input element and count.")
             fn(&value)
             {
                 if _index < _count
                 {
                     value := _element
                     _index++
                     return true
                 }
                 _index := 0
                 return false
             }
             this.toEnumerator(fn)
             fn.params := [_element, _count]
             return fn
         }
         
         static toEnumerator(fn)
         {
             numput("ptr", objptr(Enumerator.prototype), objptraddref(fn), 0x10)
         }
     }

     class IEnumerable
     {
         static bindCall(bindArray)
         {
             for child in bindArray
                 Enumerator.prototype.defineprop(child, {call: this.%child%.bind(this)})
         }
         
         static bindGet(bindArray)
         {
             for child in bindArray
                 Enumerator.prototype.defineprop(child, {get: this.%child%.bind(this)})
         }
         
         static strEnum(source)
         {
             return (array.prototype.__enum)(strsplit(source))
         }
         
         static length(source)
         {
             return [Enumerable.clone(source)*].length
         }
         
         static size(source)
         {
             return [source*].length
         }
         
         static aggregate(source, seed, func, resultSelector := "")
         {
             index := 0
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                     seed := func(seed, element, index++)
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                     seed := func(seed, element)
             }
             return resultSelector ? resultSelector(seed) : seed
         }
         
         static all(source, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !isset(element)
                         return false
                 }
                 return true
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !predicate(element, index++)
                         return false
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !predicate(element)
                         return false
                 }
             }
             return true
         }
         
         static any(source, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         return true
                 }
                 return false
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         return true
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         return true
                 }
             }
             return false
         }
         
         static asEnumerable(source)
         {
             return source
         }
         
         static average(source, selector := "")
         {
             sum := 0
             index := 1
             count := 0
             if !selector
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += element
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                     count++
                 }
                 return sum / count
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += selector(element, index++)
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                     count++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += selector(element)
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                     count++
                 }
             }
             return sum / count
         }
         
         static chunk(source, chunk, offset := 0)
         {
             static enum := [&key1, &key2, &key3, &key4, &key5, &key6, &key7, &key8, &key9, &key10, &key11, &key12, &key13, &key14, &key15, &key16, &key17, &key18, &key19]
             offset := offset < 0 ? mod((mod(offset, chunk) + chunk), chunk) : offset
             index := 1
             iter := Enumerable.clone(source)
             tmp_enum := enum.clone()
             tmp_enum.length := iter.minparams
             loop offset
                 iter(tmp_enum*)
             fn(&_iter)
             {
                 array_enum := []
                 tmp_enum := enum.clone()
                 tmp_enum.length := iter.maxparams
                 loop chunk
                 {
                     tmp_array := []
                     ret := iter(tmp_enum*)
                     if !ret
                         break
                     for child in tmp_enum
                         tmp_array.push(%child%)
                     array_enum.push(tmp_array.__enum())
                 }
                 if !array_enum.length
                     return false
                 array_enum := array_enum.__enum()
                 _iter := this.chunk_base(array_enum)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, chunk, offset]
             return fn
         }
         
         static chunk_base(array_enum)
         {
             static enum := [&key1, &key2, &key3, &key4, &key5, &key6, &key7, &key8, &key9, &key10, &key11, &key12, &key13, &key14, &key15, &key16, &key17, &key18, &key19]
             fn(args*)
             {
                 count := args.length
                 tmp_enum := enum.clone()
                 tmp_enum.length := count
                 ret := array_enum(&value)
                 if !ret
                     return false
                 loop count
                     %args[a_index]% := (value(&_value), _value)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [Enumerable.clone(array_enum)]
             return fn
         }
         
         static clone(source)
         {
             return Enumerable.clone(source)
         }
         
         static combination(source, count, repeatable := false)
         {
             length := this.length(source)
             iter_pos := []
             now_pos := []
             max_pos := []
             value_pos := []
             loop count
             {
                 now_pos.push(1)
                 max_pos.push(length)
                 enum := Enumerable.clone(source)
                 iter_pos.push(enum)
                 if a_index != count
                 {
                     enum(&value)
                     value_pos.push(value)
                 }
                 else
                     value_pos.push("")
             }
             now_pos[-1] := 0
             fn(&_iter)
             {
                 point := count
                 modify := 1
                 while (point > 0)
                 {
                     now_pos[point] += modify
                     modify := now_pos[point] // (max_pos[point] + 1)
                     if !modify
                     {
                         iter_pos[point](&value)
                         value_pos[point] := value
                         break
                     }
                     now_pos[point] := mod(now_pos[point], max_pos[point])
                     enum := Enumerable.clone(source)
                     iter_pos[point] := enum
                     enum(&value)
                     value_pos[point] := value
                     point--
                 }
                 if point <= 0
                     return false
                 if !corr_array(now_pos)
                     return fn(&_iter)
                 else
                     _iter := value_pos.clone().__enum()
                 return true
                 
                 corr_array(_array)
                 {
                     if _array.length <= 1
                         return true
                     enum := _array.__enum()
                     enum(&first)
                     for child in enum
                     {
                         if repeatable
                         {
                             if child < first
                                 return false
                         }
                         else
                         {
                             if child <= first
                                 return false
                         }
                         first := child
                     }
                     return true
                 }
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, count, repeatable]
             return fn
         }
         
         static concat(source, other*)
         {
             static enum := [&key1, &key2, &key3, &key4, &key5, &key6, &key7, &key8, &key9, &key10, &key11, &key12, &key13, &key14, &key15, &key16, &key17, &key18, &key19]
             new_iter := [Enumerable.clone(source)]
             for _iter in other
                 new_iter.push(Enumerable.clone(_iter))
             index := 1
             length := new_iter.length
             fn(args*)
             {
                 tmp_enum := enum.clone()
                 tmp_enum.length := args.length
                 if !new_iter[index](tmp_enum*)
                 {
                     if index = length
                         return false
                     index++
                     return fn(args*)
                 }
                 for child in tmp_enum
                     %args[a_index]% := %child%
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other*]
             return fn
         }
         
         static conflict(source, selector := "", comparer := (key, other) => key = other)
         {
             index := 1
             temp := []
             if !selector
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     key := element
                     for other in temp
                     {
                         if comparer(key, other)
                             return true
                     }
                     temp.push(key)
                 }
                 return false
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     key := selector(element, index++)
                     for other in temp
                     {
                         if comparer(key, other)
                             return true
                     }
                     temp.push(key)
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     key := selector(element)
                     for other in temp
                     {
                         if comparer(key, other)
                             return true
                     }
                     temp.push(key)
                 }
             }
             return false
         }
         
         static contains(source, value, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             for element in iter
             {
                 if comparer(element, value)
                     return true
             }
             return false
         }
         
         static count(source, predicate := "")
         {
             if !predicate
                 return this.length(source)
             index := 1
             count := 0
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         count++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         count++
                 }
             }
             return count
         }
         
         static defaultIfEmpty(source, defaultValue)
         {
             if !this.length(source)
                 return [defaultValue].__enum()
             return source
         }
         
         static distinct(source, comparer := (key, other) => key = other)
         {
             temp := []
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 key := element
                 for other in temp
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 value := key
                 temp.push(key)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, comparer]
             return fn
         }
         
         static each(source, action := "")
         {
             static enum := [&key1, &key2, &key3, &key4, &key5, &key6, &key7, &key8, &key9, &key10, &key11, &key12, &key13, &key14, &key15, &key16, &key17, &key18, &key19]
             if !action
                 return source
             fn(args*)
             {
                 tmp_enum := enum.clone()
                 tmp_enum.length := args.length
                 if !source(tmp_enum*)
                     return false
                 for child in tmp_enum
                     %args[a_index]% := action(%child%)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, action]
             return fn
         }
         
         static elementAt(source, index)
         {
             tmp_index := index
             iter := Enumerable.clone(source)
             for element in iter
             {
                 if index-- == 1
                     return element
             }
             throw valueerror("input index " tmp_index " is out of range.")
         }
         
         static elementAtOrDefault(source, index, defaultValue)
         {
             iter := Enumerable.clone(source)
             for element in iter
             {
                 if index-- == 1
                     return element
             }
             return defaultValue
         }
         
         static every(source, callback, thisArg*)
         {
             try
                 return this.all(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.all(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static except(source, other, comparer := (key, other) => key = other)
         {
             temp := []
             others := other
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 key := element
                 for other in Enumerable.clone(others)
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 for other in temp
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 value := key
                 temp.push(key)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other, comparer]
             return fn
         }
         
         static filter(source, callback, thisArg*)
         {
             try
                 return this.where(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.where(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static find(source, callback, thisArg*)
         {
             try
                 return this.first(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.first(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static findIndex(source, callback, thisArg*)
         {
             index := 1
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if callback.bind(thisArg*)(element, index)
                         return index
                     index++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if callback.bind(thisArg*)(element)
                         return index
                     index++
                 }
             }
             return -1
         }
         
         static findLast(source, callback, thisArg*)
         {
             try
                 return this.last(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.last(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static findLastIndex(source, callback, thisArg*)
         {
             tmp_index := -1
             index := 1
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if callback.bind(thisArg*)(element, index)
                         tmp_index := index
                     index++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if callback.bind(thisArg*)(element)
                         tmp_index := index
                     index++
                 }
             }
             return tmp_index
         }
         
         static first(source, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         return element
                 }
                 throw valueerror("Cannot find value.")
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         return element
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         return element
                 }
             }
             throw valueerror("Cannot find value.")
         }
         
         static firstOrDefault(source, defalutValue, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         return element
                 }
                 return defalutValue
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         return element
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         return element
                 }
             }
             return defalutValue
         }
         
         static forEach(source, action, thisArg*)
         {
             index := 1
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                     action.bind(thisArg*)(element, index++)
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                     action.bind(thisArg*)(element)
             }
         }
         
         static groupBy(source, keySelector := (key) => key, elementSelector := (element) => element, resultSelector := (result) => result, comparer := (key, other) => key = other)
         {
             keymap := map()
             iter := Enumerable.clone(source)
             for element in iter
             {
                 key := keySelector(element)
                 truekey := this.firstOrDefault(this.where(keymap.__enum(), comparer.bind(key)), "")
                 if truekey = ""
                     keymap[key] := [elementSelector(element)]
                 else
                     keymap[truekey].push(elementSelector(element))
             }
             enum := keymap.__enum()
             fn(&_iter)
             {
                 if !enum(&key, &value)
                     return false
                 try
                     _iter := resultSelector(key, value.__enum())
                 catch
                     _iter := resultSelector([key, value.__enum()].__enum())
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, keySelector, elementSelector, resultSelector, comparer]
             return fn
         }
         
         static groupJoin(source, inner, resultSelector := (key, result) => result, outerKeySelector := (key) => key, innerKeySelector := (key) => key, comparer := (key, other) => key = other)
         {
             iter := this.groupBy(source, outerKeySelector, , (key, value) => [key, value])
             inner_iter := this.groupBy(inner, innerKeySelector, , (key, value) => [key, value])
             fn(&_iter)
             {
                 if !iter(&key_value)
                     return false
                 tmp_iter := Enumerable.clone(inner_iter)
                 for _key_value in tmp_iter
                 {
                     if comparer(key_value[1], _key_value[1])
                     {
                         _iter := resultSelector(key_value[1], _key_value[2])
                         return true
                     }
                 }
                 return fn(&_iter)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, inner, resultSelector, outerKeySelector, innerKeySelector, comparer]
             return fn
         }
         
         static includes(source, element, start := 0)
         {
             comparer := (key, other) => key = other
             iter := Enumerable.skip(source, start)
             for _element in iter
             {
                 if comparer(element, _element)
                     return true
             }
             return false
         }
         
         static indexOf(source, element, start := 0, comparer := (key, other) => key = other)
         {
             index := 1
             iter := Enumerable.skip(source, start)
             for _element in iter
             {
                 if comparer(element, _element)
                     return index
                 index++
             }
             return -1
         }
         
         static indices(source, indices)
         {
             iter := Enumerable.clone(indices)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 value := this.elementAt(source, element)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, indices]
             return fn
         }
         
         static innerJoin(source, inner, resultSelector := (key, result) => result, outerKeySelector := (key) => key, innerKeySelector := (key) => key, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             inner_iter := Enumerable.clone(inner)
             fn(&_iter)
             {
                 if !isset(element) && !iter(&element)
                     return false
                 key := outerKeySelector(element)
                 while inner_iter(&inner_element)
                 {
                     if comparer(key, innerKeySelector(inner_element))
                     {
                         _iter := [element, inner_element].__enum()
                         return true
                     }
                 }
                 element := unset
                 inner_iter := Enumerable.clone(inner)
                 return fn(&_iter)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, inner, resultSelector, outerKeySelector, innerKeySelector, comparer]
             return fn
         }
         
         static intersect(source, other, comparer := (key, other) => key = other)
         {
             temp := []
             others := other
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 key := element
                 for other in Enumerable.clone(others)
                 {
                     if comparer(key, other)
                     {
                         for _other in temp
                         {
                             if comparer(key, _other)
                                 continue 2
                         }
                         value := key
                         temp.push(key)
                         return true
                     }
                 }
                 return fn(&value)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other, comparer]
             return fn
         }
         
         static isSub(source, other, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             for element in iter
             {
                 if !this.contains(other, element, comparer)
                     return false
             }
             return true
         }
         
         static isSuper(source, other, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(other)
             for element in iter
             {
                 if !this.contains(source, element, comparer)
                     return false
             }
             return true
         }
         
         static join(source, inner, resultSelector := (key, result) => result, outerKeySelector := (key) => key, innerKeySelector := (key) => key, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             inner_iter := Enumerable.clone(inner)
             fn(&_iter)
             {
                 if !isset(element) && !iter(&element)
                     return false
                 key := outerKeySelector(element)
                 while inner_iter(&inner_element)
                 {
                     if comparer(key, innerKeySelector(inner_element))
                     {
                         _iter := [element, inner_element].__enum()
                         return true
                     }
                 }
                 element := unset
                 inner_iter := Enumerable.clone(inner)
                 return fn(&_iter)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, inner, resultSelector, outerKeySelector, innerKeySelector, comparer]
             return fn
         }
         
         static last(source, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         tmp_element := element
                 }
                 if !isset(tmp_element)
                     throw valueerror("Cannot find value.")
                 return tmp_element
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         tmp_element := element
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         tmp_element := element
                 }
             }
             if !isset(tmp_element)
                 throw valueerror("Cannot find value.")
             return tmp_element
         }
         
         static lastOrDefault(source, defalutValue, predicate := "")
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         tmp_element := element
                 }
                 if !isset(tmp_element)
                     return defalutValue
                 return tmp_element
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         tmp_element := element
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         tmp_element := element
                 }
             }
             if !isset(tmp_element)
                 return defalutValue
             return tmp_element
         }
         
         static leftJoin(source, inner, resultSelector := (key, result) => result, outerKeySelector := (key) => key, innerKeySelector := (key) => key, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             inner_iter := Enumerable.clone(inner)
             fn(&_iter)
             {
                 if !isset(element)
                 {
                     if !iter(&element)
                         return false
                     flag := false
                 }
                 key := outerKeySelector(element)
                 while inner_iter(&inner_element)
                 {
                     if comparer(key, innerKeySelector(inner_element))
                     {
                         _iter := [element, inner_element].__enum()
                         flag := true
                         return true
                     }
                 }
                 if !flag
                 {
                     _iter := [element, ].__enum()
                     element := unset
                     return true
                 }
                 element := unset
                 inner_iter := Enumerable.clone(inner)
                 return fn(&_iter)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, inner, resultSelector, outerKeySelector, innerKeySelector, comparer]
             return fn
         }
         
         static leftPad(source, length, value)
         {
             index := 1
             _length := this.length(source)
             iter := Enumerable.clone(source)
             tmp_length := length - _length
             if tmp_length <= 0
                 return source
             fn(&element)
             {
                 if index > length
                     return false
                 if index <= tmp_length
                 {
                     element := value
                     index++
                     return true
                 }
                 iter(&element)
                 index++
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, length, value]
             return fn
         }
         
         static map(source, callback, thisArg*)
         {
             try
                 return this.select(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.select(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static max(source, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             node := this.maxNode(source, selector, comparer)
             return node.element
         }
         
         static maxIndex(source, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             try
                 node := this.maxNode(source, selector, comparer)
             catch
                 return -1
             return node.index
         }
         
         static maxNode(source, selector, comparer)
         {
             index := 1
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !isset(maxNode)
                         maxNode := {element: element, index: index, value: selector(element, index)}
                     else
                     {
                         index++
                         value := selector(element, index)
                         if comparer(maxNode.value, value) <= 0
                         {
                             maxNode.element := element
                             maxNode.index := index
                             maxNode.value := value
                         }
                     }
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !isset(maxNode)
                         maxNode := {element: element, index: index, value: selector(element)}
                     else
                     {
                         index++
                         value := selector(element)
                         if comparer(maxNode.value, value) <= 0
                         {
                             maxNode.element := element
                             maxNode.index := index
                             maxNode.value := value
                         }
                     }
                 }
             }
             if !isset(maxNode)
                 throw valueerror("Empty Enumerator")
             return maxNode
         }
         
         static maxOrDefault(source, defaultValue, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             try
                 node := this.maxNode(source, selector, comparer)
             catch
                 return defaultValue
             return node.element
         }
         
         static min(source, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             node := this.minNode(source, selector, comparer)
             return node.element
         }
         
         static minIndex(source, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             try
                 node := this.minNode(source, selector, comparer)
             catch
                 return -1
             return node.index
         }
         
         static minNode(source, selector, comparer)
         {
             index := 1
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !isset(minNode)
                         minNode := {element: element, index: index, value: selector(element, index)}
                     else
                     {
                         index++
                         value := selector(element, index)
                         if comparer(minNode.value, value) >= 0
                         {
                             minNode.element := element
                             minNode.index := index
                             minNode.value := value
                         }
                     }
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if !isset(minNode)
                         minNode := {element: element, index: index, value: selector(element)}
                     else
                     {
                         index++
                         value := selector(element)
                         if comparer(minNode.value, value) >= 0
                         {
                             minNode.element := element
                             minNode.index := index
                             minNode.value := value
                         }
                     }
                 }
             }
             if !isset(minNode)
                 throw valueerror("Empty Enumerator")
             return minNode
         }
         
         static minOrDefault(source, defaultValue, selector := (value) => value, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             try
                 node := this.minNode(source, selector, comparer)
             catch
                 return defaultValue
             return node.element
         }
         
         static nearBy(source, keySelector := (key) => key, elementSelector := (element) => element, resultSelector := (result) => result, comparer := (key, other) => key = other)
         {
             keymap := map()
             iter := Enumerable.clone(source)
             for element in iter
             {
                 key := keySelector(element)
                 if !isset(last_key)
                 {
                     last_key := key
                     keymap[last_key] := [elementSelector(element)]
                     continue
                 }
                 if comparer(key, last_key)
                     keymap[last_key].push(elementSelector(element))
                 else
                 {
                     last_key := key
                     keymap[last_key] := [elementSelector(element)]
                 }
             }
             enum := keymap.__enum()
             fn(&_iter)
             {
                 if !enum(&key, &value)
                     return false
                 try
                     _iter := resultSelector(key, value.__enum())
                 catch
                     _iter := resultSelector([key, value.__enum()].__enum())
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, keySelector, elementSelector, resultSelector, comparer]
             return fn
         }
         
         static nearSplit(source, splitPredicate)
         {
             index := 1
             next_empty := false
             iter := Enumerable.clone(source)
             fn(&_iter)
             {
                 if isset(splitflag) && !splitflag
                     return false
                 splitflag := false
                 if next_empty
                 {
                     next_empty := false
                     _iter := [].__enum()
                     return true
                 }
                 if !iter(&element)
                     return false
                 try
                 {
                     if splitPredicate(element, index++)
                         array_enum := [element]
                     else
                     {
                         _iter := [].__enum()
                         return true
                     }
                     while iter(&element)
                     {
                         if !splitPredicate(element, index++)
                         {
                             splitflag := true
                             break
                         }
                         array_enum.push(element)
                     }
                 }
                 catch
                 {
                     if splitPredicate(element)
                         array_enum := [element]
                     else
                     {
                         _iter := [].__enum()
                         return true
                     }
                     while iter(&element)
                     {
                         if !splitPredicate(element)
                         {
                             splitflag := true
                             break
                         }
                         array_enum.push(element)
                     }
                 }
                 _iter := array_enum.__enum()
                 next_empty := splitflag ? true : false
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, splitPredicate]
             return fn
         }
         
         static ofType(source, type)
         {
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 if element is type
                 {
                     value := element
                     return true
                 }
                 else
                     return fn(&value)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, type]
             return fn
         }
         
         static orderBy(source, keySelector := (key) => key, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             array_enum := this.toArray(source)
             QuickSort(array_enum, 1, array_enum.length)
             return array_enum.__enum()
             QuickSort(arr, left, right)
             {
                 if (left < right)
                 {
                     pivotIndex := Partition(arr, left, right)
                     QuickSort(arr, left, pivotIndex - 1)
                     QuickSort(arr, pivotIndex + 1, right)
                 }
             }
             Partition(arr, left, right)
             {
                 pivot := keySelector(arr[left])
                 i := left + 1
                 j := right
                 while (i <= j)
                 {
                     while (i <= j && comparer(keySelector(arr[i]), pivot) <= 0)
                         i++
                     while (i <= j && comparer(keySelector(arr[j]), pivot) > 0)
                         j--
                     if (i < j)
                     {
                         temp := arr[i]
                         arr[i] := arr[j]
                         arr[j] := temp
                     }
                 }
                 temp := arr[left]
                 arr[left] := arr[j]
                 arr[j] := temp
                 return j
             }
         }
         
         static orderByDescending(source, keySelector := (key) => key, comparer := (key, other) => (key > other) ? 1 : (key < other) ? -1 : 0)
         {
             array_enum := this.toArray(source)
             QuickSort(array_enum, 1, array_enum.length)
             return array_enum.__enum()
             QuickSort(arr, left, right)
             {
                 if (left < right)
                 {
                     pivotIndex := Partition(arr, left, right)
                     QuickSort(arr, left, pivotIndex - 1)
                     QuickSort(arr, pivotIndex + 1, right)
                 }
             }
             Partition(arr, left, right)
             {
                 pivot := keySelector(arr[left])
                 i := left + 1
                 j := right
                 while (i <= j)
                 {
                     while (i <= j && comparer(keySelector(arr[i]), pivot) >= 0)
                         i++
                     while (i <= j && comparer(keySelector(arr[j]), pivot) < 0)
                         j--
                     if (i < j)
                     {
                         temp := arr[i]
                         arr[i] := arr[j]
                         arr[j] := temp
                     }
                 }
                 temp := arr[left]
                 arr[left] := arr[j]
                 arr[j] := temp
                 return j
             }
         }
         
         static permutation(source, count, repeatable := false)
         {
             length := this.length(source)
             iter_pos := []
             now_pos := []
             max_pos := []
             value_pos := []
             loop count
             {
                 now_pos.push(1)
                 max_pos.push(length)
                 enum := Enumerable.clone(source)
                 iter_pos.push(enum)
                 if a_index != count
                 {
                     enum(&value)
                     value_pos.push(value)
                 }
                 else
                     value_pos.push("")
             }
             now_pos[-1] := 0
             fn(&_iter)
             {
                 point := count
                 modify := 1
                 while (point > 0)
                 {
                     now_pos[point] += modify
                     modify := now_pos[point] // (max_pos[point] + 1)
                     if !modify
                     {
                         iter_pos[point](&value)
                         value_pos[point] := value
                         break
                     }
                     now_pos[point] := mod(now_pos[point], max_pos[point])
                     enum := Enumerable.clone(source)
                     iter_pos[point] := enum
                     enum(&value)
                     value_pos[point] := value
                     point--
                 }
                 if point <= 0
                     return false
                 if !repeatable && !corr_array(now_pos)
                     return fn(&_iter)
                 else
                     _iter := value_pos.clone().__enum()
                 return true
                 
                 corr_array(_array)
                 {
                     tmp_map := map()
                     if _array.length <= 1
                         return true
                     enum := _array.__enum()
                     for child in enum
                     {
                         if tmp_map.has(child)
                             return false
                         else
                             tmp_map[child] := ""
                     }
                     return true
                 }
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, count, repeatable]
             return fn
         }
         
         static product(source, selector := "")
         {
             prod := 0
             index := 1
             if !selector
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     prod *= element
                     if string(prod) = "inf" || string(prod) = "nan"
                         return prod
                 }
                 return prod
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     prod *= selector(element, index++)
                     if string(prod) = "inf" || string(prod) = "nan"
                         return prod
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     prod *= selector(element)
                     if string(prod) = "inf" || string(prod) = "nan"
                         return prod
                 }
             }
             return prod
         }
         
         static proportion(source, predicate := "")
         {
             index := 1
             count := 0
             total := this.length(source)
             if !total
                 return 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                         count++
                 }
                 return count / total
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index++)
                         count++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                         count++
                 }
             }
             return count / total
         }
         
         static rand(source, count := 0)
         {
             length := this.length(source)
             array_enum := []
             if !count
             {
                 loop length
                     array_enum.push(a_index)
                 loop length
                 {
                     rand := random(1, length)
                     tmp := array_enum[a_index]
                     array_enum[a_index] := array_enum[rand]
                     array_enum[rand] := tmp
                 }
             }
             else
             {
                 loop count
                 {
                     rand := random(1, length)
                     array_enum.push(rand)
                 }
             }
             array_enum := array_enum.__enum()
             fn(&value)
             {
                 if !array_enum(&index)
                     return false
                 iter := Enumerable.clone(source)
                 loop index - 1
                     iter(&element)
                 iter(&value)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, count]
             return fn
         }
         
         static random(source)
         {
             length := this.length(source)
             if !length
                 throw valueerror("Empty Enumerator")
             rand := random(1, length)
             iter := Enumerable.clone(source)
             loop rand
                 iter(&element)
             return element
         }
         
         static randomOrDefault(source, defaultValue)
         {
             length := this.length(source)
             if !length
                 return defaultValue
             rand := random(1, length)
             iter := Enumerable.clone(source)
             loop rand
                 iter(&element)
             return element
         }
         
         static reduce(source, callback, initialValue)
         {
             try
                 return this.aggregate(source, initialValue, (seed, element, index) => callback(seed, element, index))
             catch
                 return this.aggregate(source, initialValue, (seed, element, index) => callback(seed, element))
         }
         
         static reduceRight(source, callback, initialValue)
         {
             try
                 return this.reverse(source).aggregate(source, initialValue, (seed, element, index) => callback(seed, element, index))
             catch
                 return this.reverse(source).aggregate(source, initialValue, (seed, element, index) => callback(seed, element))
         }
         
         static reverse(source)
         {
             array_enum := this.toArray(array_enum)
             new_enum := []
             for element in array_enum
                 new_enum.insertat(1, element)
             return new_enum.__enum()
         }
         
         static rightJoin(source, inner, resultSelector := (key, result) => result, outerKeySelector := (key) => key, innerKeySelector := (key) => key, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             inner_iter := Enumerable.clone(inner)
             fn(&_iter)
             {
                 if !isset(inner_element)
                 {
                     if !inner_iter(&inner_element)
                         return false
                     flag := false
                 }
                 key := innerKeySelector(inner_element)
                 while iter(&element)
                 {
                     if comparer(key, outerKeySelector(element))
                     {
                         _iter := [element, inner_element].__enum()
                         flag := true
                         return true
                     }
                 }
                 if !flag
                 {
                     _iter := [, inner_element].__enum()
                     element := unset
                     return true
                 }
                 inner_element := unset
                 iter := Enumerable.clone(source)
                 return fn(&_iter)
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, inner, resultSelector, outerKeySelector, innerKeySelector, comparer]
             return fn
         }
         
         static rightPad(source, length, value)
         {
             index := 1
             _length := this.length(source)
             iter := Enumerable.clone(source)
             if _length >= length
                 return source
             fn(&element)
             {
                 if index > length
                     return false
                 if index > _length
                 {
                     element := value
                     index++
                     return true
                 }
                 iter(&element)
                 index++
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, length, value]
             return fn
         }
         
         static select(source, selector := (value) => value)
         {
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 value := selector(element)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, selector]
             return fn
         }
         
         static sequenceEqual(source, other, comparer := (key, other) => key = other)
         {
             iter_length := this.length(source)
             other_iter_length := this.length(other)
             if iter_length != other_iter_length
                 return false
             iter := Enumerable.clone(source)
             other_iter := Enumerable.clone(other)
             loop iter_length
             {
                 iter(&element)
                 other_iter(&_element)
                 if !comparer(element, _element)
                     return false
             }
             return true
         }
         
         static single(source, predicate := "")
         {
             return this.singleNode(source, predicate).element
         }
         
         static singleOrDefault(source, defaultValue, predicate := "")
         {
             try
                 return this.singleNode(source, predicate).element
             return defaultValue
         }
         
         static singleNode(source, predicate)
         {
             index := 1
             if !predicate
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if isset(element)
                     {
                         if isset(single)
                             throw valueerror("Too many elements find in Enumerator.")
                         single := {element: element, index: index}
                     }
                     index++
                 }
                 if !isset(single)
                     throw valueerror("No such element in Enumerator.")
                 return single
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element, index)
                     {
                         if isset(single)
                             throw valueerror("Too many elements find in Enumerator")
                         single := {element: element, index: index}
                     }
                     index++
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     if predicate(element)
                     {
                         if isset(single)
                             throw valueerror("Too many elements find in Enumerator")
                         single := {element: element, index: index}
                     }
                     index++
                 }
             }
             if !isset(single)
                 throw valueerror("No such element in Enumerator.")
             return single
         }
         
         static skip(source, count)
         {
             length := this.length(source)
             if count > length
                 return [].__enum()
             if count <= 0
                 return Enumerable.clone(source)
             iter := Enumerable.clone(source)
             loop count
                 iter(&value)
             return iter
         }
         
         static skipProportion(source, proportion)
         {
             length := this.length(source)
             count := floor(proportion * length)
             return this.skip(source, count)
         }
         
         static skipSame(source, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             if !iter(&first)
                 return false
             fn(&value)
             {
                 skipFlag := true
                 if !skipFlag
                 {
                     if !iter(&element)
                         return false
                     value := element
                     return true
                 }
                 while skipFlag
                 {
                     if !iter(&element)
                         return false
                     if comparer(first, element)
                         continue
                     else
                     {
                         value := element
                         skipFlag := false
                         return true
                     }
                 }
                 return false
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, comparer]
             return fn
         }
         
         static skipWhile(source, predicate := "")
         {
             index := 0
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 skipFlag := true
                 if !skipFlag
                 {
                     index++
                     if !iter(&element)
                         return false
                     value := element
                     return true
                 }
                 while skipFlag
                 {
                     index++
                     if !iter(&element)
                         return false
                     if !predicate
                     {
                         if isset(element)
                             continue
                         else
                         {
                             value := unset
                             skipFlag := false
                             return true
                         }
                     }
                     try
                     {
                         if predicate(element, index)
                             continue
                         else
                         {
                             value := element
                             skipFlag := false
                             return true
                         }
                     }
                     catch
                     {
                         if predicate(element)
                             continue
                         else
                         {
                             value := element
                             skipFlag := false
                             return true
                         }
                     }
                 }
                 return false
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, predicate]
             return fn
         }
         
         static slice(source, start := 1, end := "inf")
         {
             index := start
             iter := this.skip(source, start - 1)
             fn(&value)
             {
                 if (end != "inf" && index++ > end) || !iter(&element)
                     return false
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, start, end]
             return fn
         }
         
         static some(source, callback, thisArg*)
         {
             try
                 return this.any(source, (element, index) => callback.bind(thisArg*)(element, index))
             catch
                 return this.any(source, (element, index) => callback.bind(thisArg*)(element))
         }
         
         static split(source, splitPredicate)
         {
             index := 1
             iter := Enumerable.clone(source)
             fn(&_iter)
             {
                 if isset(splitflag) && !splitflag
                     return false
                 splitflag := false
                 if !iter(&element)
                     return false
                 try
                 {
                     if splitPredicate(element, index++)
                         array_enum := [element]
                     else
                     {
                         _iter := [].__enum()
                         return true
                     }
                     while iter(&element)
                     {
                         if !splitPredicate(element, index++)
                         {
                             splitflag := true
                             break
                         }
                         array_enum.push(element)
                     }
                 }
                 catch
                 {
                     if splitPredicate(element)
                         array_enum := [element]
                     else
                     {
                         _iter := [].__enum()
                         return true
                     }
                     while iter(&element)
                     {
                         if !splitPredicate(element)
                         {
                             splitflag := true
                             break
                         }
                         array_enum.push(element)
                     }
                 }
                 _iter := array_enum.__enum()
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, splitPredicate]
             return fn
         }
         
         static sum(source, selector := "")
         {
             sum := 0
             index := 1
             if !selector
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += element
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                 }
                 return sum
             }
             try
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += selector(element, index++)
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                 }
             }
             catch
             {
                 iter := Enumerable.clone(source)
                 for element in iter
                 {
                     sum += selector(element)
                     if string(sum) = "inf" || string(sum) = "nan"
                         return sum
                 }
             }
             return sum
         }
         
         static symmetric(source, other, comparer := (key, other) => key = other)
         {
             temp := []
             others := this.intersect(source, other, comparer)
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 key := element
                 for other in Enumerable.clone(others)
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 for other in temp
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 value := key
                 temp.push(key)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other, comparer]
             return fn
         }
         
         static take(source, count)
         {
             index := 1
             if count <= 0
                 return [].__enum()
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if index > count || !iter(&element)
                     return false
                 index++
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, count]
             return fn
         }
         
         static takeProportion(source, proportion)
         {
             length := this.length(source)
             count := floor(proportion * length)
             return this.take(source, count)
         }
         
         static takeSame(source, comparer := (key, other) => key = other)
         {
             iter := Enumerable.clone(source)
             if !iter(&first)
                 return false
             firstFlag := true
             fn(&value)
             {
                 if firstFlag
                 {
                     firstFlag := false
                     value := first
                     return true
                 }
                 if !iter(&element) || !comparer(first, element)
                     return false
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, comparer]
             return fn
         }
         
         static takeWhile(source, predicate := "")
         {
             index := 1
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 if !predicate
                 {
                     if isset(element)
                     {
                         value := element
                         return true
                     }
                     else
                         return false
                 }
                 try
                 {
                     if !predicate(element, index++)
                         return false
                 }
                 catch
                 {
                     if !predicate(element)
                         return false
                 }
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, predicate]
             return fn
         }
         
         static toArray(source)
         {
             return [Enumerable.clone(source)*]
         }
         
         static toMap(source, keySelector := (key) => key, valueSelector := (value) => value, comparer := (key, other) => key = other)
         {
             enum_map := map()
             iter := Enumerable.clone(source)
             for element in iter
             {
                 key := keySelector(element)
                 truekey := this.firstOrDefault(this.where(enum_map.__enum(), comparer.bind(key)), "")
                 if truekey = ""
                     enum_map[key] := valueSelector(element)
                 else
                     enum_map[truekey] := valueSelector(element)
             }
             return enum_map
         }
         
         static toObject(source, keySelector := (key) => key, valueSelector := (value) => value, comparer := (key, other) => key = other)
         {
             enum_object := {}
             iter := Enumerable.clone(source)
             for element in iter
             {
                 key := keySelector(element)
                 truekey := this.firstOrDefault(this.where(enum_object.ownprops(), comparer.bind(key)), "")
                 if truekey = ""
                     enum_object.%key% := valueSelector(element)
                 else
                     enum_object.%truekey% := valueSelector(element)
             }
             return enum_object
         }
         
         static union(source, other, comparer := (key, other) => key = other)
         {
             temp := []
             iter := Enumerable.clone(source)
             other_iter := Enumerable.clone(other)
             iterFlag := true
             fn(&value)
             {
                 if iterFlag && !iter(&element)
                     iterFlag := false
                 if !iterFlag && !other_iter(&element)
                     return false
                 key := element
                 for other in temp
                 {
                     if comparer(key, other)
                         return fn(&value)
                 }
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other, comparer]
             return fn
         }
         
         static where(source, predicate := "")
         {
             index := 1
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 if !predicate
                 {
                     if !isset(element)
                         return fn(&value)
                     value := element
                     return true
                 }
                 try
                 {
                     if !predicate(element, index++)
                         return fn(&value)
                 }
                 catch
                 {
                     if !predicate(element)
                         return fn(&value)
                 }
                 value := element
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, predicate]
             return fn
         }
         
         static wipe(source, predicate := "", count := 0)
         {
             index := 0
             if !count
                 count := this.length(source)
             iter := Enumerable.clone(source)
             fn(&value)
             {
                 if !iter(&element)
                     return false
                 if !predicate
                 {
                     if isset(element)
                     {
                         count--
                         return fn(&value)
                     }
                     value := unset
                     return true
                 }
                 try
                 {
                     if predicate(element, index++)
                     {
                         count--
                         return fn(&value)
                     }
                     value := element
                     return true
                 }
                 catch
                 {
                     if predicate(element)
                     {
                         count--
                         return fn(&value)
                     }
                     value := element
                     return true
                 }
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, predicate, count]
             return fn
         }
         
         static zip(source, other, resultSelector := (result, other) => [result, other].__enum())
         {
             iter := Enumerable.clone(source)
             other_iter := Enumerable.clone(other)
             fn(&_iter)
             {
                 if !iter(&element) || !other_iter(&_element)
                     return false
                 _iter := resultSelector(element, _element)
                 return true
             }
             Enumerable.toEnumerator(fn)
             fn.params := [source, other, resultSelector]
             return fn
         }
     }

AccumulateErrors()
    {
        local ea := ErrorAccumulator()
        ea.Start()
        return ea
    }

    ; class ErrorAccumulator
    ; {
    ;     Errors := []                        ; Array for accumulated errors.
    ;     _cb := AccumulateError.Bind(this.Errors)
    ;     Start() => OnError(this._cb, -1)    ; Register our cb before others.
    ;     Stop() => OnError(this._cb, 0)      ; Unregister our cb.
    ;     Last => this.Errors[-1]             ; Most recent error.
    ;     Count => this.Errors.Length         ; Number of accumulated errors.
    ;     __item[i] => this.Errors[i]         ; Shortcut for indexing.
    ;     __delete() => this.Stop()           ; For tying to function scope.
    ; }

    ; This is the OnError callback function. 'errors' is given a value via Bind().
AccumulateError(errors, e, mode)
    {
        if mode != "Return" ; Not continuable.
            return
        if e.What = "" ; Expression defect or similar, not a built-in function.
            return
        try {
            ; Try to print the error to stdout.
            FileAppend Format("{1} ({2}) : ({3}) {4}`n", e.File, e.Line, e.What, e.Message), "*"
            if HasProp(e, "extra")
                FileAppend "     Specifically: " e.Extra "`n", "*"
        }
        errors.Push(e)
        return -1 ; Continue.
    }
RearrangeWindows()
    {
        ; Start accumulating errors in 'err'.
        local err := AccumulateErrors()

        ; Do some things that might fail...
        MonitorGetWorkArea , &left, &top, &right, &bottom
        width := (right-left)//2, height := bottom-top
        WinMove left, top, width, height, A_ScriptFullPath
        WinMove left+width, top, width, height, "AutoHotkey v2 Help"

        ; Check if any errors occurred.
        if err.Count
            MsgBox err.Count " error(s); last error at line #" err.Last.Line
        else
            MsgBox "No errors"

        ; Stop is called automatically when the variable goes out of scope,
        ; since only we have a reference to the object.  This causes OnError
        ; to be called to unregister the callback.
        ;err.Stop()
    }
LogError(exception, mode) {
        FileAppend "Error on line " exception.Line ": " exception.Message "`n"
            , "errorlog.txt"
        return true
    }