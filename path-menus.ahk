FolderMenu(path, menu)
{   
    global
    local f_FolderList, nextmenu, f_FileList, f_LenFileName, f_MenuItemName, varname, MenuName
    If menu =
    MenuName := String2Hex(path)
    else
    MenuName := menu
    Loop, %path%\*, 2
    f_FolderList = %f_FolderList%`n%A_LoopFileFullPath%
    Sort, f_FolderList
    Loop, parse, f_FolderList, `n
    {
    If A_LoopField =
        continue
    f_MenuItemName := FileShortName(A_LoopField)
    nextmenu := FolderMenu(A_LoopField,"")
    varname := MenuName . "path" . String2Hex(f_MenuItemName)
    %varname% = %A_LoopField%
    Menu, %MenuName%, add, %f_MenuItemName%, :%nextmenu%
    }
    Loop, %path%\*, 0
    f_FileList = %f_FileList%`n%A_LoopFileFullPath%
    Sort, f_FileList
    Loop, parse, f_FileList, `n
    {
    If A_LoopField =
        continue
    f_MenuItemName := FileShortName(A_LoopField)
    varname := MenuName . "path" . String2Hex(f_MenuItemName)
    %varname% = %A_LoopField%
    Menu, %MenuName%, add, %f_MenuItemName%, FolderMenuHandler
    }
    return MenuName
}

FolderMenuHandler:
    If menu_RButton = true
    {
    Msgbox, Right Click
    menu_RButton = false
    }
    varname := A_ThisMenu . "path" . String2Hex(A_ThisMenuItem)
    cmd := %varname%
    If cmd = 
    return
    else
    Run, %cmd%
return

FileShortName(path)
{
    StringSplit, tokens, path, \/
    last := tokens%tokens0%
    StringSplit, half, last, .
    If half1 =
    return last
    else
    return half1
}

String2Hex(x)                 ; Convert a string to a huge hex number starting with X
{
   StringLen Len, x
   format = %A_FormatInteger%
   SetFormat Integer, H
   hex = X
   Loop %Len%
   {
      Transform y, ASC, %x%   ; ASCII code of 1st char, 15 < y < 256
      StringTrimLeft y, y, 2  ; Remove leading 0x
      hex = %hex%%y%
      StringTrimLeft x, x, 1  ; Remove 1st char
   }
   SetFormat Integer, %format%
   Return hex
}