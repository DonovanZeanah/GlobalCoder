Menu, ContextMenu, add,  Menu1, MenuHandler
Menu, ContextMenu, add,  Menu2, MenuHandler
Menu, NewMenu, add, New Sub 1, MenuHandler
Menu, NewMenu, add, New Sub 2, MenuHandler
Menu, ContextMenu, Add, &New Menu, :NewMenu
hMenu:=MI_GetMenuHandle("ContextMenu")
OnMessage(0x0122 , "WM_MENURBUTTONUP"), OnMessage( 0x211, "WM_ENTERMENULOOP" )
RButton_Click:=false
return

CapsLock::
Menu_Show( hMenu, A_ScriptHwnd) ;The user can select menu items with both the left and right mouse buttons.
return

MenuHandler:

MsgBox, % "Detecting the menu plus the menu item`n"
      . "Menu: " A_ThisMenu "`n"
      . "Menu Item: " A_ThisMenuItem "`n"
      . "Button: " (RButton_Click ? "Right" : "Left")
RButton_Click:=false ; always do this, so that you can differentiate between normal or right click
return
WM_MENURBUTTONUP(wparam, lparam){
  Global RButton_Click
MouseGetPos,,, w
ControlSend,, {enter}, ahk_id %w%
RButton_Click:=true
return
}
WM_ENTERMENULOOP(){ ; Notifies an application's main window procedure that a menu modal loop has been entered.
          ; by returning true, the AHK doesn't halt processing Messages, timers, hotkeys... (the default behavior)
return, true
}
Menu_Show( hMenu, hWnd=0, mX="", mY="", Flags=0x1 ) {
 ; http://ahkscript.org/boards/viewtopic.php?p=7088#p7088
 ; Flags: TPM_RECURSE := 0x1, TPM_RETURNCMD := 0x100, TPM_NONOTIFY := 0x80
 VarSetCapacity( POINT, 8, 0 ), DllCall( "GetCursorPos", UInt,&Point )
 mX := ( mX <> "" ) ? mX : NumGet( Point,0 )
 mY := ( mY <> "" ) ? mY : NumGet( Point,4 )
Return DllCall( "TrackPopupMenu", UInt,hMenu, UInt,Flags ; TrackPopupMenu()  goo.gl/CosNig
               , Int,mX, Int,mY, UInt,0, UInt,hWnd ? hWnd : WinActive("A"), UInt,0 )
}


;________________Lexikos (www.autohotkey.com/board/topic/20253-menu-icons-v2/) in Menu Icons MI.ahk
; Gets a menu handle from a menu name.
; Adapted from Shimanov's Menu_AssignBitmap()
;   http://www.autohotkey.com/forum/topic7526.html
MI_GetMenuHandle(menu_name){
    static   h_menuDummy
    ; v2.2: Check for !h_menuDummy instead of h_menuDummy="" in case init failed last time.
    If !h_menuDummy
    {
        Menu, menuDummy, Add
        Menu, menuDummy, DeleteAll

        Gui, 99:Menu, menuDummy
        ; v2.2: Use LastFound method instead of window title. [Thanks animeaime.]
        Gui, 99:+LastFound

        h_menuDummy := DllCall("GetMenu", "uint", WinExist())

        Gui, 99:Menu
        Gui, 99:Destroy
       
        ; v2.2: Return only after cleaning up. [Thanks animeaime.]
        if !h_menuDummy
            return 0
    }

    Menu, menuDummy, Add, :%menu_name%
    h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )
    DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400 )
    Menu, menuDummy, Delete, :%menu_name%
   
    return h_menu
}
Esc::
ExitApp
return