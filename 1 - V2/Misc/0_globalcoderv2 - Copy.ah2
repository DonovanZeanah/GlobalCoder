;*******************************************************

;**************************************
#Warn all, OutputDebug
#ErrorStdOut
#Requires AutoHotkey v2.0-beta
msgbox("ello")

#include json.ah2
msgbox("ello")



^a::{
myinput := InputBox(Enter Something, UserInputBox, Options, Default)
msgbox(myinput)
return
MsgBox(objstring)


}
;Creates a popup window.
1::
{
    MyGui := Gui(, "Title of Window")
MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button.
MyGui.Add("Text",, "Some text to display.")
;MyGui.Add("Button", "OK", "ok")
MyGui.Show("NoActivate")  ; NoActivate avoids deactivating the currently active window.
}

;Creates a simple input-box that asks for the first and last name.
 
 2::
 {
MyGui := Gui(, "Title of Window")
MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button.
MyGui := Gui(, "Simple Input Example")
MyGui.Add("Text",, "First name:")

 MyGui.Add("Text",, "Last name:")
MyGui.Add("Edit", "vinput ym")
MyGui.Add("Edit", "vFirstName ym")  ; The ym option starts a new column of controls.
MyGui.Add("Edit", "vLastName")
MyGui.Add("Button", "default", "OK").OnEvent("Click", ProcessUserInput)
MyGui.OnEvent("Close", ProcessUserInput)
MyGui.Show("NoActivate")

ProcessUserInput(*)
{
    Saved := MyGui.Submit()  ; Save the contents of named controls into an object.
    MsgBox("You entered '" Saved.FirstName " " Saved.LastName "'.")
}}
; Creates a tab control with multiple tabs, each containing different controls to interact with.

3::
{
    MyGui := Gui(, "Title of Window")
    MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button
   ; MyGui := Gui()
Tab := MyGui.Add("Tab3",, ["First Tab","Second Tab","Third Tab"])
MyGui.Add("Checkbox", "vMyCheckbox", "Sample checkbox") 
Tab.UseTab(2)
MyGui.Add("Radio", "vMyRadio", "Sample radio1")
MyGui.Add("Radio",, "Sample radio2")
Tab.UseTab(3)
MyGui.Add("Edit", "vMyEdit r5")  ; r5 means 5 rows tall.
Tab.UseTab()  ; i.e. subsequently-added controls will not belong to the tab control.
Btn := MyGui.Add("Button", "default xm", "OK")  ; xm puts it at the bottom left corner.
Btn.OnEvent("Click", ProcessUserInput2)    
MyGui.OnEvent("Close", ProcessUserInput2)
MyGui.OnEvent("Escape", ProcessUserInput2)
MyGui.Show("NoActivate")

ProcessUserInput2(*)
{
    Saved := MyGui.Submit()  ; Save the contents of named controls into an object.
    MsgBox("You entered:`n" Saved.MyCheckbox "`n" Saved.MyRadio "`n" Saved.MyEdit)
}
}
; Creates a ListBox control containing files in a directory.

4::
{
    MyGui := Gui(, "Title of Window")
    MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button.
    MyGui := Gui()
    MyGui.Add("Text",, "Pick a file to launch from the list below.")
    LB := MyGui.Add("ListBox", "w640 r10")
    LB.OnEvent("DoubleClick", LaunchFile)
    Loop Files,  "d:\globalcoder\*.*"  ; Change this folder and wildcard pattern to suit your preferences.
        ;OutputDebug, a_userdesktop
    ;4test := OutputDebug(a_userdesktop)
    ;Loop Files, "C:\Users\dylan\desktop\*.*"  ; Change this folder and wildcard pattern to suit your preferences.
    LB.Add([A_LoopFilePath])
    MyGui.Add("Button", "Default", "OK").OnEvent("Click", LaunchFile)
    MyGui.Show("NoActivate")

LaunchFile(*)
{
    if MsgBox("Would you like to launch the file or document below?`n`n" LB.Text,, 4) = "No"
        return
    ; Otherwise, try to launch it:
    try Run(LB.Text)
    if A_LastError
        MsgBox("Could not launch the specified file. Perhaps it is not associated with anything.")
}
}
; Displays a context-sensitive help (via ToolTip) whenever the user moves the mouse over a particular control.

5::{

    {MyGui := Gui()
        MyEdit := MyGui.Add("Edit")
        ; Store the tooltip text in a custom property:
        MyEdit.ToolTip := "This is a tooltip for the control whose name is MyEdit."
        MyDDL := MyGui.Add("DropDownList",, ["Red","Green","Blue"])
        MyDDL.ToolTip := "Choose a color from the drop-down list."
        MyGui.Add("Checkbox",, "This control has no tooltip.")
        MyGui.Show()
        OnMessage(0x0200, On_WM_MOUSEMOVE)
        
        On_WM_MOUSEMOVE(wParam, lParam, msg, Hwnd)
        {
            static PrevHwnd := 0
            if (Hwnd != PrevHwnd)
                {
                    Text := "", ToolTip() ; Turn off any previous tooltip.
                    CurrControl := GuiCtrlFromHwnd(Hwnd)
                    if CurrControl
                        {
                            if !CurrControl.HasProp("ToolTip")
                                return ; No tooltip for this control.
                            Text := CurrControl.ToolTip
                            SetTimer () => ToolTip(Text), -1000
                            SetTimer () => ToolTip(), -4000 ; Remove the tooltip.
                        }
                        PrevHwnd := Hwnd
                    }
                }}
                ; Creates an On-screen display (OSD) via transparent window.
            }

                6::{
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
}}
 ;Creates a moving progress bar overlayed on a background image.


7::{
    MyGui := Gui()
MyGui.BackColor := "White"
MyGui.Add("Picture", "x0 y0 h350 w450", A_WinDir "\Web\Wallpaper\Windows\img0.jpg")
MyBtn := MyGui.Add("Button", "Default xp+20 yp+250", "Start the Bar Moving")
MyBtn.OnEvent("Click", MoveBar)
MyProgress := MyGui.Add("Progress", "w416")
MyText := MyGui.Add("Text", "wp")  ; wp means "use width of previous".
MyGui.Show()
}
MoveBar(*)
{
    Loop Files, "d:\globalcoder\*.*"
    {
        if (A_Index > 100)
            break
    ;    MyProgress.Value := A_Index
      ;  MyText.Value := A_LoopFileName
        Sleep 50
    }
   ; MyText.Value := "Bar finished."
}
 ;Creates a simple image viewer.

8::{
    MyGui := Gui("+Resize")
MyBtn := MyGui.Add("Button", "default", "&Load New Image")
MyBtn.OnEvent("Click", LoadNewImage)
MyRadio := MyGui.Add("Radio", "ym+5 x+10 checked", "Load &actual size")
MyGui.Add("Radio", "ym+5 x+10", "Load to &fit screen")
MyPic := MyGui.Add("Pic", "xm")
MyGui.Show()
}
LoadNewImage(*)
{
    Image := FileSelect(,, "Select an image:", "Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)")
    if Image = ""
        return
    if (MyRadio.Value)  ; Display image at its actual size.
    {
        Width := 0
        Height := 0
    }
    else ; Second radio is selected: Resize the image to fit the screen.
    {
        Width := A_ScreenWidth - 28  ; Minus 28 to allow room for borders and margins inside.
        Height := -1  ; "Keep aspect ratio" seems best.
    }
    MyPic.Value := Format("*w{1} *h{2} {3}", Width, Height, Image)  ; Load the image.
    MyGui.Title := Image
    MyGui.Show("xCenter y0 AutoSize")  ; Resize the window to match the picture size.
}
; Creates a simple text editor with menu bar.

; Create the MyGui window:


numpad0::{
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
}}

;//================funcs
fileWrite(whichFile, text := "") {
    fileObj := FileOpen(whichFile, "w")
    fileObj.Write(text)
    fileObj.Close()
 }
 
 fileAppend(whichFile, text) {
     if FileExist(whichFile)
         fileObj := FileOpen(whichFile, "a")
     else
         fileObj := FileOpen(whichFile, "w")
     fileObj.Seek(0, 2)
     fileObj.Write(text)
     fileObj.Close()
 }
 
 fileRead(whichFile) {
    fileObj := FileOpen(whichFile, "r")
    fileObj.Seek(0, 0)
    text := fileObj.Read()
    fileObj.Close()
    return text
 }