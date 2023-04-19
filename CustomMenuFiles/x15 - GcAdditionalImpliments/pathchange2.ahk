#SingleInstance, Force
#NoEnv ; somewhat ironic...
    
    ; this won't work in vista/7 if it's not run as an administrator.
    ; i'm too lazy to request it manually so the easiest way is to 
    ; compile this script, and then under Compatibility tab in the 
    ; compiled exe's Properties select "Run as Administrator"
    
    RegRead, P, HKLM, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, PATH
    
    Gui, +Delimiter`;
    
    width := 400
    Gui, Add, Text, w%width%, Double Click an entry to modify it. Click Add to make a new entry and Delete to remove the selected entry.
    Gui, Add, ListBox, vSysPath w%width% r8 +0x100 gEditEntry AltSubmit, %P%
    Gui, Font, s12
    Gui, Add, Button, gNew    w70 section  , New
    Gui, Add, Button, gDelete w70 ys xs+74 , Delete
    Gui, Add, Button, gExit   w70 ys xs+330, Cancel
    Gui, Add, Button, gSubmit w70 ys xp-74, Submit
    Gui, Show, , SysEnv -- Change System Environment Variable
return

EditEntry:
    if (a_guievent == "DoubleClick" && a_eventinfo) {
        Gui +OwnDialogs
        RegExMatch(P, "P)^(?:(?<E>[^;]*)(?:;|$)){" a_eventinfo "}", _)
        _En := IB( "Edit PATH entry", substr(P, _PosE, _LenE))
        if (ErrorLevel == 0)
        {
            if (InStr(FileExist(ExpEnv(_En)),"D"))
            {
                rP := substr(P, 1, _PosE-1) _En (_PosE+_LenE+1 < strlen(P) ? ";" substr(P, _PosE+_LenE+1) : "")
                P := rP
                GuiControl, , SysPath, `;%P%
            }
            else
                MsgBox, , SysEnv, Path is not a directory.
        }
    }
return

New:
    add := IB( "Add PATH entry" )
    if (instr(fileexist(ExpEnv(add)),"D")) {
        P .= (strlen(P) > 0 ? ";" : "") add
        GuiControl, , SysPath, `;%P%
    }
return

Delete:
    GuiControlGet, entry, , SysPath
    if (entry) {
        Gui, +OwnDialogs
        MsgBox, 4, SysEnv -- Confirm, Remove entry #%entry% from PATH?
        IfMsgBox Yes
        {
            RegExMatch(P, "P)^(?:(?<E>[^;]*)(?:;|$)){" entry "}", _)
            P := SubStr(P, 1, max(_PosE-2,0)) (_PosE+_LenE+1 < strlen(P) ? ";" substr(P, _PosE+_LenE+1) : "")
            GuiControl, , SysPath, `;%P%
        }
    }
return

Submit:
    Gui, +OwnDialogs
    MsgBox, 1, SysEnv -- Save Changes, Change system PATH to:`n`n%P%
    IfMsgBox, OK
    {
        RegWrite, REG_EXPAND_SZ, HKLM, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, PATH, %P%
        If !ErrorLevel
            MsgBox, 0, SysEnv -- Success!, Modifying the PATH variable was successful!
        Else
            MsgBox,  , SysEnv, Error has occurred and new PATH variable was not saved.
    }
    Else
        MsgBox, , SysEnv -- Cancelled, Exiting now.

Exit:
GuiClose:
GuiEscape:
GuiEsc:
ExitApp

IB( prompt, default="" ) {
    InputBox, out, SysEnv -- %prompt%, %prompt%:, , , , , , , , %default%
    return out
}

max( a, b ) {
    return a > b ? a : b
}

ExpEnv(str) { 
    ; by Lexikos: http://www.autohotkey.com/forum/viewtopic.php?p=327849#327849
    if sz:=DllCall("ExpandEnvironmentStrings", "uint", &str, "uint", 0, "uint", 0)
    {
        VarSetCapacity(dst, A_IsUnicode ? sz*2:sz)
        if DllCall("ExpandEnvironmentStrings", "uint", &str, "str", dst, "uint", sz)
            return dst
    }
    return ""
}