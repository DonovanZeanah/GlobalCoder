/*

    CTRL+WIN+3  StartupToggle
    CTRL+WIN+4  Peek at Notes in AHK file from Windows File Explorer
    CTRL+WIN+5  Reloads/Updates System Tray icon menu

The AutoStartupControl.ahk script builds a System Tray menu from the Windows shortcuts
found in the Startup folder. By accessing this right-click menu various actions can be
performed on the programs or AutoHotkey script targeted by each shortcut.

The AutoStartupControl.ahk script also includes the Hotkey (CTRL+WIN+3) for creating/removing
Windows shortcuts in the StartUp folder from the AutoStartupToggle.ahk script for files selected 
in Windows File Explorer. Select the .exe or .ahk file in Windows File Explorer and use the Hotkey 
combination CTRL+WIN+3 to either add a shortcut to the target file in the StartUp folder, or, if it 
already exists, remove the shortcut from the StartUp folder.

CTRL+WIN+5 Reloads/Updates the menu.

January 10, 2021 — Added "Notes" submenu item which uses ScriptNotes subroutine to extract
comments from the .ahk files targeted by Startup folder shortcuts. Display comments between
the slash/asterisk* and asterisk*slash/ boundaries in a MsgBox.

January 17, 2021 — Switched from MsgBox to GUI window for display notes since the GUI has less
formatting issues.

January 21, 2021 — Added the Hotkey combination CTRL+WIN+4 to run the AHK file ScriptNotes
subroutine for any .ahk file selected in Windows File Explorer. The new Hotkey first runs the 
Standard AutoHotkey Clipboard Routine:

https://jacks-autohotkey-blog.com/2016/03/23/autohotkey-windows-clipboard-techniques-for-swapping-letters-beginning-hotkeys-part-9/#clipboard

then uses a GoTo statement to skip the Windows Shortcut reading command then uses the same 
subroutine to displays the file notes.

January 31, 2021 — Added the Link GUI control and a RegEx to make URLs hot to the ReadNotes
subroutine.

*/

#SingleInstance Force
Menu, Tray, UseErrorLevel



AutoStart:

    Loop %A_Startup%\*.*
    {
        FileGetShortcut, %A_LoopFileFullPath%, Location, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
        If ErrorLevel
            Continue
            Menu, %A_LoopFileName%, Add, Notes, ScriptNotes
            Menu, %A_LoopFileName%, Add, Open, MenuAction
            Menu, %A_LoopFileName%, Add, Restart, ProgRestart
            Menu, Tray, Add , %A_LoopFileName%, :%A_LoopFileName%
            If (OutIcon != "")
                Menu, Tray, Icon, %A_LoopFileName%, %OutIcon%, %OutIconNum%
    }

Menu, Tray, Icon, Shell32.dll, 85

Return



^#3::                 ; Activates with CTRL+WIN+3
  Clipboard =    ; Empties Clipboard
  Send, ^c          ; Copies filename and path
  ClipWait 0       ; Waits for copy
  SplitPath, Clipboard, Name, Dir, Ext, Name_no_ext, Drive
  IfExist, %A_Startup%\%Name_no_ext%.lnk
  {
    MsgBox, 4, Found in Startup Folder, %Name% exists in Startup folder! Remove?
    IfMsgBox Yes
        FileDelete, %A_Startup%\%Name_no_ext%.lnk
    else
        Return
     MsgBox, %Name% removed from the Startup folder.
  }
  Else
  {
    FileCreateShortcut, "%clipboard%"
           , %A_Startup%\%Name_no_ext%.lnk
           , %Dir%  ,  , , "%clipboard%"  ; Line-wrapped using AutoHotkey line continuation
    MsgBox, %Name% added to Startup folder for auto-launch with Windows.
  }
Return

^#5::Reload



MenuAction:
    Shortcut := A_Startup "/" A_ThisMenu
    FileGetShortcut, %A_Startup%/%A_ThisMenu%, Location
    If InStr(Location,".ahk")
        Run, subl %Location%
    If InStr(Location,".exe")
    {
        explorerpath:= "explorer /select," Location
        Run, %explorerpath%
    }

Return

ProgRestart:
    FileGetShortcut, %A_Startup%/%A_ThisMenu%, Location
    If InStr(Location,".ahk")
        Run *RunAs "%A_AhkPath%" /restart "%Location%"
    If InStr(Location,".exe")
         Run *RunAs "%Location%" /restart
Return

^#4::
        Clip0 := ClipboardAll        ; Backup current clipboard's content
        Clipboard :=                      ; Clear clipboard
        SendInput, ^c                    ; copy selected file's path to clipboard
        ClipWait 0
          If FileExist(Clipboard)
            {
               Location := Clipboard
             }
          Else
            {
               MsgBox, No file selected!
               Clipboard := Clip0           ; Restore original ClipBoard
               Return
            }

        Clipboard := Clip0           ; Restore original ClipBoard
        Goto ReadNotes  

ScriptNotes:
    FileGetShortcut, %A_Startup%/%A_ThisMenu%, Location

ReadNotes:
    SplitPath, Location, Name, Dir, Ext, Name_no_ext, Drive
    If InStr(Location,".exe")
        Location := StrReplace(Location, ".exe" , ".ahk")
    If !FileExist(Location)
    {
        MsgBox No notes found!
        Return
    }

    FileRead, FileVar, % Location
    found := RegExMatch(FileVar, "s)/\*(.*?)\*/" , NotesVar)
    NotesVar1 := RegExReplace(NotesVar1, "(http.*?)(\s)" , "<a href=""$1"">$1</a>$2")
    NotesVar1 := StrReplace(NotesVar1, "`t" , "     ")
    Gui, Add, Button, , Open File
    Gui, Add, Link,  , %Location%`r%NotesVar1%
    Gui, Show,  , %Name_no_ext%

Return

ButtonOpenFile:

    Run, Notepad %Location%

Return

GuiClose:
    GUI, Destroy
Return