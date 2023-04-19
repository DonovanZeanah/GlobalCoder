
#include 1parseahk.ahk

class FileSystem {
    class FileSystemElement {
        getAttributes() { ;flag string see AutoHotkey Help: FileExist for more infos
            return FileExist( this.name )
        }
        changeAttributes( changeAttributeString ) { ;see FileSetAttrib for more infos
            FileSetAttrib, % changeAttributeString, % this.name
        }
        getPath() {
            return this.name
        }
        getPathName() {
            SplitPath, % this.name, fileName
            return fileName
        }
        getPathDir() { ;same as getDirectory
            return This.getPathDirectory()
        }
        getPathDirectory() {
            SplitPath, % this.name, , fileDirectory
            return fileDirectory
        }
        getPathExtension() {
            SplitPath, % this.name , , , fileExtension
            return fileExtension
        }
        getPathNameNoExtension() {
            SplitPath, % this.name, , , , fileNameNoExtension
            return fileNameNoExtension
        }
        getPathDrive() {
            SplitPath, % this.name, , , , , fileDrive
            return fileDrive
        }
        getTimeAccessed() { ;in YYYYMMDDHH24MISS see AutoHotkey help for more infos
            FileGetTime, timeCreated, % this.name, A
            return timeCreated
        }
        setTimeAccessed( timeAccessed ) {
            FileSetTime, % timeAccessed, % this.name, A
        }
        getTimeModified() {
            FileGetTime, timeModified, % this.name, M
            return timeModified
        }
        setTimeModified( timeModified ) {
            FileSetTime, % timeModified, % this.name, M
        }
        getTimeCreated() {
            FileGetTime, timeCreated, % this.name, C
            return timeCreated
        }
        setTimeCreated( timeCreated ) {
            FileSetTime, % timeCreated, % this.name, C
        }
    }
    class File extends FileSystem.FileSystemElement {
        __New( fileName ) {
            if ( !fileExist( fileName ) )
                Throw exception( "File """ . path . """ doesn't exist", "__New", "Exist test returned false" )
            if ( inStr( fileExist( fileName ), "D" ) ) ;if file is a folder or a drive
                Throw exception( "Error creating File", "__New", "Path points to Folder" )
            Loop, Files, % strReplace(fileName,"/","\"), F ;since the fileName refers to a single file this loop will only execute once
                this.name := A_LoopFileLongPath ;and there it will set the path to the value we need
        }
        open( p* ) {
            return FileOpen( this.name, p* )
        }
        getSize( unit := "" ) {
            FileGetSize, fileSize, % this.name, % unit
            return fileSize
        }
        move( newFilePath, overwrite := 0 ) {
            FileMove, % this.name, % newFilePath, % overwrite
        }
        copy( newFilePath, overwrite := 0 ) {
            FileCopy, % this.name, % newFilePath, % overwrite
        }
        delete() {
            FileDelete, % this.name
        }
    }
    class FileContainer extends FileSystem.FileSystemElement {
        getPathName() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getPathExtension() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getPathNameNoExtension() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
    }
    class Directory extends FileSystem.FileContainer {
    }
    class Drive extends FileSystem.FileContainer {
        changeAttributes( changeAttributeString ) {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getPathDir() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getPathDirectory() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getTimeAccessed() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        setTimeAccessed( timeStamp ) {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getTimeModified() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        setTimeModified( timeStamp ) {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        getTimeCreated() {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
        setTimeCreated( timeStamp ) {
            Throw exception( "Couldn't find method" , A_ThisFunc, "Method: " . A_ThisFunc . " is not available for objects of Class: " . this.__class )
        }
    }
}

class Gfiles extends fileContainer {
    __new()
    {

    }

}




/*class FileSystemElement {
    getAttributes() { ;flag string see AutoHotkey Help: FileExist for more infos
        return FileExist( this.name )
    }
    changeAttributes( changeAttributeString ) { ;see FileSetAttrib for more infos
        FileSetAttrib, % changeAttributeString, % this.name
    }
    getPath() {
        return this.name
    }
    getPathName() {
        SplitPath, % this.name, fileName
        return fileName
    }
    getPathDir() { ;same as getDirectory
        return This.getPathDirectory()
    }
    getPathDirectory() {
        SplitPath, % this.name, , fileDirectory
        return fileDirectory
    }
    getPathExtension() {
        SplitPath, % this.name , , , fileExtension
        return fileExtension
    }
    getPathNameNoExtension() {
        SplitPath, % this.name, , , , fileNameNoExtension
        return fileNameNoExtension
    }
    getPathDrive() {
        SplitPath, % this.name, , , , , fileDrive
        return fileDrive
    }
    getTimeAccessed() { ;in YYYYMMDDHH24MISS see AutoHotkey help for more infos
        FileGetTime, timeCreated, % this.name, A
        return timeCreated
    }
    setTimeAccessed( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, A
    }
    getTimeModified() {
        FileGetTime, timeCreated, % this.name, M
        return timeCreated
    }
    setTimeModified( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, M
    }
    getTimeCreated() {
        FileGetTime, timeCreated, % this.name, C
        return timeCreated
    }
    setTimeCreated( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, C
    }
}
class File extends FileSystemElement {
    open( p* ) {
        return FileOpen( this.name, p* )
    }
    getSize( unit := "" ) {
        FileGetSize, fileSize, % this.name, % unit
        return fileSize
    }
    move( newFilePath, overwrite := 0 ) {
        FileMove, % this.name, % newFilePath, % overwrite
    }
    copy( newFilePath, overwrite := 0 ) {
        FileCopy, % this.name, % newFilePath, % overwrite
    }
    delete() {
        FileDelete, % this.name
    }
}
class FileContainer extends FileSystemElement {
}
class Directory extends FileContainer {
}
class Drive extends FileContainer {
}

*/
/*
class File {
    __New( fileName ) {
        if ( !fileExist( fileName ) )
            Msgbox File doesn't exist
        if ( inStr( fileExist( fileName ), "D" ) ) ;if file is a folder or a drive
            Msgbox File is not a valid File
        Loop, Files, % fileName, F ;since the fileName refers to a single file this loop will only execute once
            this.name := A_LoopFileLongPath ;and there it will set the path to the value we need
    }
    getPath() {
        return this.name
    }
    getPathName() {
        SplitPath, % this.name, fileName
        return fileName
    }
    getPathDir() { ;same as getDirectory
        return This.getPathDirectory()
    }
    getPathDirectory() {
        SplitPath, % this.name, , fileDirectory
        return fileDirectory
    }
    getPathExtension() {
        SplitPath, % this.name , , , fileExtension
        return fileExtension
    }
    getPathNameNoExtension() {
        SplitPath, % this.name, , , , fileNameNoExtension
        return fileNameNoExtension
    }
    getPathDrive() {
        SplitPath, % this.name, , , , , fileDrive
        return fileDrive
    }
    move( newFilePath, overwrite := 1 ) {
        FileMove, % this.name, % newFilePath, % overwrite
    }
    copy( newFilePath, overwrite := 1 ) {
        FileCopy, % this.name, % newFilePath, % overwrite
    }
    open( p* ) {
        return FileOpen( this.name, p* )
    }
    getSize( unit := "" ) {
        FileGetSize, fileSize, % this.name, % unit
        return fileSize
    }
    getAttributes() { ;flag string see AutoHotkey Help: FileExist for more infos
        return FileExist( this.name )
    }
    changeAttributes( changeAttributeString ) { ;see FileSetAttrib for more infos
        FileSetAttrib, % changeAttributeString, % this.name
    }
    getTimeAccessed() { ;in YYYYMMDDHH24MISS see AutoHotkey help for more infos
        FileGetTime, timeCreated, % this.name, A
        return timeCreated
    }
    setTimeAccessed( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, A
    }
    getTimeModified() {
        FileGetTime, timeCreated, % this.name, M
        return timeCreated
    }
    setTimeModified( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, M
    }
    getTimeCreated() {
        FileGetTime, timeCreated, % this.name, C
        return timeCreated
    }
    setTimeCreated( timeStamp ) {
        FileSetTime, % timeStamp, % this.name, C
    }
    delete() {
        FileDelete, % this.name
    }
}
*/
/*
class File {
    /*__New( fileName ) {
        if ( !fileExist( fileName ) )
            Msgbox File doesn't exist
        if ( inStr( fileExist( fileName ), "D" ) ) ;if file is a folder or a drive
            Msgbox File is not a valid File
        this.name := fileName
    }

__New( fileName ) {
        if ( !fileExist( fileName ) )
            Msgbox File doesn't exist
        if ( inStr( fileExist( fileName ), "D" ) ) ;if file is a folder or a drive
            Msgbox File is not a valid File
        Loop, Files, % fileName, F ;since the fileName refers to a single file this loop will only execute once
            this.name := A_LoopFileLongPath ;and there it will set the path to the value we need
    }
    getPath() {
        return this.name
    }
    getPathName() {
        SplitPath, % this.name, fileName
        return fileName
    }
    getPathDir() { ;same as getDirectory
        return This.getPathDirectory()
    }
    getPathDirectory() {
        SplitPath, % this.name, , fileDirectory
        return fileDirectory
    }
    getPathExtension() {
        SplitPath, % this.name , , , fileExtension
        return fileExtension
    }
    getPathNameNoExtension() {
        SplitPath, % this.name, , , , fileNameNoExtension
        return fileNameNoExtension
    }
    getPathDrive() {
        SplitPath, % this.name, , , , , fileDrive
        return fileDrive
    }
    getSize( unit := "" ) {
        FileGetSize, fileSize, % this.name, % unit
        return fileSize
    }
    getAttributes() { ;flag string see AutoHotkey Help: FileExist for more infos
        return FileExist( this.name )
    }
    getTimeAccessed() { ;in YYYYMMDDHH24MISS see AutoHotkey help for more infos
        FileGetTime, timeCreated, % this.name, A
        return timeCreated
    }
    getTimeModified() {
        FileGetTime, timeCreated, % this.name, M
        return timeCreated
    }
    getTimeCreated() {
        FileGetTime, timeCreated, % this.name, C
        return timeCreated
    }
}


*/












/*
    June 27, 2020 This version of the script is a work in progress. Most of
    the new items listed in the menu bar are currently non-functional. I'm
    posting this (and subsequent) version(s) for those who are following
    along with the blogs explaining the changes. While the script works,
    the items in the menu bar will become active one at a time.
    
    July 5, 2020 Some of the GUI menu bar items work.
    
    July 12, 2020 Minor changes—mostly to the Save/Append menu items.

    July 19, 2020 Changed Save routine notification from MsgBox to
    Progress Bar. Implemented new .hsf file extension name.

    July 27, 2020 Added "Set default file" subroutine to the File menu in the GUI
    menubar for loading at startup (Ctrl+D). Added option to disable a default file.
  
    
    ======================================================
    InstantHotstring.ahk by Jack Dunning—November 13, 2019
    ======================================================
    
    The InstantHotstring.ahk script saves newly created Hotstrings in a
    DropDownList GUI control. When setting a Hotstring, AutoHotkey
    immediately activates it and adds it to the DropDownList. You can
    deactivate/activate Hotstrings using the Toggle Hotstring On/Off
    button. The GUI window includes an Edit GUI control Hotstring Test
    Pad for checking the behavior of any newly set Hotstrings. (The Test
    Pad in the image shows the results of the Hotstrings, “lol”, “Lol”, and
    “LOL”, respectively.) The Save Hotstrings button stores all currently
    active Hotstrings to a file. The Load Hotstrings button restores and
    activates Hotstring code stored in a file. The Start Clean button reloads
    the script wiping out all of the Hotstrings currently running in
    InstantHotstrings.ahk.
    
    January 8, 2019, Color and bold added to Text controls. Buttons take bold
    but not color.
    
    January 12, 2019, Changed IF-ELSE conditionals to ternary operators. Also
    added the C1 option for removing all case sensitivity—including default
    initial cap and all caps. To enterC1 mode, add and remove the C option.
    Each time you reset the Hotstring with the C option,it cycles through
    C1 => C0 => [option removed].
    
    The C1 options added complications to the script. I dealt with it as an exception which
    I plan to discuss at a later date.
    
    Each time you click the Set Hotstring button, all unnecessary options (e.g. B0, *0, etc) are
    removed from the string.
    
    January 15, 2019, I added the FileSelectFile command to allow the naming of saved Hotstring
    files and the opening of named Hotstring files. The script stores the saved files in the
    %A_ScriptDir%\Hotstrings\ folder with .ahk extensions. You can directly load the Hotstrings
    either by running the AutoHotkey file or loading the same file into the InstantHotstring.ahk
    app.
    
    January 16, 2019, The AddSaveSample subroutine now adds a sample saved Hotstring file
(SampleSaveFile.ahk) in the %A_ScriptDir%\Hotstrings\ folder whenever it's not found when
loading or reloading.

January 23, 2019, Added a trap to exclude same line comments (;) when loading from Hotstring
files.

February 16, 2019, A number of fixes including the use of the progress bar control when loading
from a file. Saves a huge amount of time when loading large Hotstring files.

February 18, 2019, Changed the CheckOption() Function to use GuiControl rather than Control command
since, by default, Control does not work with hidden (when loading from file) GUI pop-ups. I could
have turned on DetectHiddenWindows…but I didn't.

February 28, 2019, Cannot use "DetectHiddenWindows On" since it slows down the process as if the GUI
window were active. For now, this version optimizes file loading speed, although the I disabled the
Hotstring duplicate checking. Therefore, loading the same file again causes duplicates to appear in the
DropDownList control.

March 22, 2019, I've added a subroutine for toggling the Hotstring Options CheckBox controls to red
when active and black when inactive.

March 25, 2019, Rewrote the LoadHotstrings subroutine to reduce the slow loading times. Rather than
using previous routines to set Hotstrings it loads and sets directly from the file.

April 3, 2019, The problem with X option corrected in Version 1.1.30.02 - April 1, 2019, so I eliminated the
extra Hotstring activation for the option, but you must install the latest version of AutoHotkey.

April 23, 2019, Found a bug in the file loading subroutine which caused a problem when creating new
Hotstrings using Hotstring from the file (included `r). Believe it's fixed now.

October 6, 2019, Added default file loading for Windows Registry. Option to set default file when saving.

November 6, 2019, Used Run command to clear Hotstrings (reload) without using default Hotstring file.



=============================================
AutoExecute Subroutine HotstringAutoExec:
=============================================
To add to another script #Include the file and add "GoSub HotstringAutoExec"
to the Auto-execute section of the main script.


HotstringAutoExec:

; Added for reloading while passing parameters
#SingleInstance, Force

Global CapCheck, TotalHotstringCount

 ; , LoadHotstrings
; LoadHotstrings := 0

Gui, Hotstring:Font, s14 cBlue Bold , Arial
Gui, Hotstring:Add, Text, Section vText1 , Enter Hotstring
Gui, Hotstring:Font, s12 cBlack Norm
Gui, Hotstring:Add, Edit, w50 vNewString ys,
Gui, Hotstring:Font, s14 cBlue Bold
Gui, Hotstring:Add, Text,  xs vText2, Enter Replacement Text
Gui, Hotstring:Font, s12 cBlack Norm
Gui, Hotstring:Add, Edit, w400 vTextInsert xs, <Enter Hotkey Text>
Gui, Hotstring:Add, DropDownList, w400 vStringCombo xs gViewString Sort AltSubmit,

; The GroupBox control merely describes the enclosed controls and makes it
; easy to relocate the entire group of controls

Gui, Hotstring:Font, s14 cBlue Bold
Gui, Hotstring:Add, GroupBox, section w400 h110, Hotstring Options
Gui, Hotstring:Font, s12 cBlack Norm
Gui, Hotstring:Add, CheckBox, vCaseSensitive gCapsCheck xp+15 ys+25, Case Sensitive (C)
Gui, Hotstring:Add, CheckBox, vNoBackspace gCapsCheck xp+210 yp+0, No Backspace (B0)
Gui, Hotstring:Add, CheckBox, vImmediate gCapsCheck  xp-210 yp+20, Immediate Execute (*)
Gui, Hotstring:Add, CheckBox, vInsideWord gCapsCheck  xp+210 yp+0, Inside Word (?)
Gui, Hotstring:Add, CheckBox, vNoEndChar gCapsCheck  xp-210 yp+20, No End Char (O)
Gui, Hotstring:Add, CheckBox, vRaw gCapsCheck  xp+210 yp+0, Raw Text Mode (T)
Gui, Hotstring:Add, CheckBox, vExecute gCapsCheck  xp-120 yp+20, Labels/Functions (X)

Gui, Hotstring:Font, Bold
Gui, Hotstring:Add, Button, gAddHotstring section xm, Set Hotstring
Gui, Hotstring:Add, Button, gToggleString vDisable ys, Toggle Hotstring On/Off

Gui, Hotstring:Font, s14 cBlue
Gui, Hotstring:Add, Text,  xm vText3, Hotstring Test Pad
Gui, Hotstring:Font, s12 Norm
Gui, Hotstring:Add, Edit,  xm r4 w400  cGreen,

Gui, Hotstring:Font, Bold
Gui, Hotstring:Add, Button, gSaveHotstrings section xm, Save Hotstrings
Gui, Hotstring:Add, Button, gLoadHotstrings ys, Load Hotstrings

Gui, Hotstring:Add, Button, gReload ys, Start Clean

Menu, Tray, Add, Show Instant Hotstrings, ShowHotstrings

Menu, FileMenu, Add, &Open File`tCtrl+O, MenuBarAction
Menu, FileMenu, Add, &Activate Hotstrings from File`tCtrl+Alt+O, MenuBarAction
Menu, FileMenu, Add, &Save`tCtrl+S, InstantHotstringSave
Menu, FileMenu, Disable, &Save`tCtrl+S
Menu, FileMenu, Add, &Save as…`tCtrl+Shift+S, SaveHotstrings
Menu, FileMenu, Add, A&ppend Hotstrings to File`tCtrl+Shift+A, SaveHotstrings
Menu, FileMenu, Add, Set &default file`tCtrl+D, SetDefaultFile
Menu, FileMenu, Add, &Clear Hotstrings`tCtrl+K, MenuBarAction
Menu, FileMenu, Add, E&xit`tCtrl+X, MenuBarAction

Menu, EditMenu, Add, &New Hotstring`tCtrl+N, MenuBarAction
Menu, EditMenu, Add, S&et Hotstring`tCtrl+E, MenuBarAction
Menu, EditMenu, Add, &Disable/Enable Hotstring`tCtrl+D, MenuBarAction
Menu, EditMenu, Add, &Find Hotstring`tCtrl+F, MenuBarAction

Menu, HelpMenu, Add, &Help`tCtrl+F1, MenuBarAction
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Edit, :EditMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Hotstring:Menu, MyMenuBar

If !FileExist(A_ScriptDir . "\Hotstrings\SampleSaveFile.ahk")
  GoSub, AddSaveSample

; Drops-through to show GUI on initial load. Thereafter, use the right-click
; system tray menu item (added above) to open the GUI window.

; The next conditional checks for load parameter passed to script by Run command
If (!A_Args[1])
  LoadDefault := 1
Else
  LoadDefault := 0

ShowHotstrings:
  Gui, Hotstring:Show, , Instant Hotstrings %OpenFile%

; First loading add default Hotstrings
;If LoadDefault = 1
;{
  Gosub, LoadHotstrings
;}
Return


=============================================
Hotstring Viewing Subroutine ViewString:
=============================================
Sets the GUI fields to the selected DropDownList item.


ViewString:
  ControlGet, Select, Choice ,, ComboBox1, A
  HotString := StrSplit(Select, ":",,5)
  GuiControl, , Edit1, % HotString[3]
  GuiControl, , Edit2, % HotString[5]

  GoSub SetOptions

; Sets controls for disabled/enabled
 If InStr(HotString[5], "🛑")
  {
    GuiControl,, Disable , % "🛑 Enable Hotstring"
    GuiControl, , Edit2, % SubStr(HotString[5],1,-11)
  }
  Else
  {
    GuiControl,, Disable , Disable Hotstring
    GuiControl, , Edit2, % HotString[5]
  }

; Cleans and sets cursor to Test Pad
  SetTestPad()

Return

=============================================
Hotstring Setting Subroutine AddHotstring:
=============================================
The following AddHotstring subroutines adds new or updates old Hotstrings.
It searches for and matches old Hotstrings for updating and activates the Hotstrings
with new options or replacement text.


AddHotstring:

Gui, Hotstring:+OwnDialogs
Gui, Submit, NoHide

; Trap for blank Hotstring
If (Trim(NewString) ="")
{
  MsgBox Enter a Hotstring!
    Return
}

; Trap for blank Replacement Text
If (Trim(TextInsert) ="")
{
  MsgBox Replacement text cannot be blank!
    Return
}

; Trap for non-existent Label or function when using the X option.
MsgBox % TextInsert . " " . IsFunc(TextInsert)
RegExMatch(TextInsert, "(.*)\(" , FuncMatch)
If (Execute = 1) and (IsLabel(TextInsert) = 0) and (IsFunc(FuncMatch1) = 0)
{
  MsgBox, Replacement text must be a Label or function!
  Return
}

; Variable to save any previously set options.
OldOptions := ""

; Delete target item from DropDownList control.
; ControlGet and Control commands do not work for hidden windows,
; therefore, Hotstrings loaded from files are not checked for duplicates.

;If (LoadHotstrings != 1)     ; Skip when loading from file
;{
  ControlGet, Items, List,, ComboBox1, A
  Loop, Parse, Items, `n
  {
    If InStr(A_LoopField, ":" . NewString . "::", CaseSensitive)
    {
      HotString := StrSplit(A_LoopField, ":",,5)
      OldOptions := HotString[2]
      Control, Delete, %A_Index% , ComboBox1
      Break
    }
  }
;}

; Added this conditional to prevent Hotstrings from a file losing the C1 option caused by
; cascading ternary operators when creating the options string. CapCheck set to 1 when
; a Hotstring from a file contains the C1 option.

If (CapCheck = 1) and ((OldOptions = "") or (InStr(OldOptions,"C1"))) and (Instr(Hotstring[2],"C1"))
    OldOptions := StrReplace(OldOptions,"C1") . "C"
CapCheck := 0

GuiControl,, Disable , Toggle Hotstring On/Off

GoSub OptionString   ; Writes the Hotstring options string


; Check for # in Web URL TextInsert and add curly brackets
If (InStr(TextInsert,"{#}") = 0
    and InStr(TextInsert,"http")
    and (InStr(Options,"T") = 0
    or InStr(Options,"T0")))
{
  If InStr(Options,"T0")
  {
    Options := StrReplace(Options,"T0","T")
    Options := StrReplace(Options,"O0","O")
  }
  Else
  {
    Options := Options . "O"
    Options := Options . "T"
  }
  Control, Check, , Button7, A  ; Raw Text Mode
  Control, Check, , Button6, A  ; Raw Text Mode
}


This conditional routine looks for Hotkey modifiers in the replacement
text giving you the chance to set the mode to raw.


If RegExMatch(TextInsert, "[!+#^{}]" , Modifier)
    and RegExMatch(TextInsert, "{.*}") = 0
    and (InStr(Options,"T") = 0 or InStr(Options,"T0"))
;    and (LoadHotstrings = 0)
      MsgBox,3,Modifier Found, Hotkey modifier %modifier% found!`rSet Raw Text Mode?
        IfMsgBox Yes
        {
          If InStr(Options,"T0")
            Options := StrReplace(Options,"T0","T")
          Else
            Options := Options . "T"
          Control, Check, , Button7, A  ; Raw Text Mode
        }



; Add new/changed target item in DropDownList
GuiControl,, ComboBox1 , % ":" . Options . ":" . NewString . "::" . TextInsert

; Select target item in list
GuiControl, ChooseString, ComboBox1, % ":" . Options . ":" NewString "::" TextInsert

; If case sensitive (C) or inside a word (?) first deactivate Hotstring
If (CaseSensitive or InsideWord or InStr(OldOptions,"C")
     or InStr(OldOptions,"?"))
     Hotstring(":" . OldOptions . ":" . NewString , TextInsert , "Off")

; Create Hotstring and activate
Hotstring(":" . Options . ":" . NewString, TextInsert, "On")

; Cleans and sets cursor to Test Pad
  SetTestPad()
If (!InStr(WindowTitle,"*") and WindowTitle)
{
  WindowTitle .= "*"
  WinSetTitle, %WindowTitle%
  Menu, FileMenu, Enable, &Save`tCtrl+S
}
Return


=============================================
SetTestPad() Function
=============================================
Clears and sets cursor to Test Pad


SetTestPad()
{
  GuiControl, Focus, Edit3
  GuiControl, , Edit3,
}


=============================================
Subroutine ToggleString: Deactivte/Activates Hotstrings
=============================================
Disables and enables selected Hotstrings.


ToggleString:

Gui, Hotstring:+OwnDialogs
If (NewString ="")
{
    MsgBox Create and set Hotstring!
    Return
}

  ControlGet, Select, Choice ,, ComboBox1, A

  HotString := StrSplit(Select, ":",,5)

  GuiControlGet, Pick ,, ComboBox1
  Control, Delete, %Pick% , ComboBox1


; Disables/enables and marks Hotstrings
If InStr(HotString[5], "🛑")
{
  GuiControl,, ComboBox1 , % ":" . HotString[2] . ":" . HotString[3] . "::" . SubStr(HotString[5],1,-11) . "||"
  GuiControl,, Disable , Disable Hotstring
  Hotstring(":" . HotString[2] . ":" . HotString[3] , SubStr(HotString[5],1,-11), "On")
}
Else
{
  GuiControl,, ComboBox1 , % ":" . HotString[2] . ":" . HotString[3] . "::" . HotString[5] . "🛑 Stopped!||"
  GuiControl,, Disable , 🛑 Enable Hotstring
  Hotstring(":" . HotString[2] . ":" . HotString[3] , HotString[5], "Off")
}

Return


=============================================
Subroutine SetOptions Checks Options CheckBoxes
=============================================
Set CheckBox controls based on the Hotstring options string.
The set of ternary operators use the CheckOption() function to set
check/uncheck the appropriate CheckBox.


SetOptions:

; This next conditional checks for the R option (Raw) in imported Hotstrings
; replacing each with the newer T option (Text Mode Raw).

If InStr(Hotstring[2],"R")
   Hotstring[2] := StrReplace(Hotstring[2],"R","T")

OptionSet := ((Instr(Hotstring[2],"C0")) or (Instr(Hotstring[2],"C1")) or (Instr(Hotstring[2],"C") = 0))
    ? CheckOption("No",2)  :  CheckOption("Yes",2)
;Msgbox % Hotstring[2]
OptionSet := Instr(Hotstring[2],"B0") ? CheckOption("Yes",3)  :  CheckOption("No",3)
OptionSet := Instr(Hotstring[2],"*0") or InStr(Hotstring[2],"*") = 0 ? CheckOption("No",4)
                  :  CheckOption("Yes",4)
OptionSet := Instr(Hotstring[2],"?") ? CheckOption("Yes",5)  :  CheckOption("No",5)
OptionSet := (Instr(Hotstring[2],"O0") or (InStr(Hotstring[2],"O") = 0)) ? CheckOption("No",6)
                  :  CheckOption("Yes",6)
OptionSet := (Instr(Hotstring[2],"T0") or (InStr(Hotstring[2],"T") = 0)) ? CheckOption("No",7)
                  :  CheckOption("Yes",7)
OptionSet := (Instr(Hotstring[2],"X0") or (InStr(Hotstring[2],"X") = 0)) ? CheckOption("No",8)
                  :  CheckOption("Yes",8)
CapCheck := 0

Return


===========================================
Subroutine OptionString Writes the Options String
=============================================
Write the Hotstring options string based upon the CheckBox values.
Reverse of the SetOptions subroutine.


OptionString:

Options := ""

Options := CaseSensitive = 1 ? Options . "C"
     : (Instr(OldOptions,"C1")) ?  Options . "C0"
     : (Instr(OldOptions,"C0")) ?  Options
     : (Instr(OldOptions,"C")) ? Options . "C1" : Options

Options := NoBackspace = 1 ?  Options . "B0"
   : (NoBackspace = 0) and (Instr(OldOptions,"B0"))
  ? Options . "B" : Options

Options := (Immediate = 1) ?  Options . "*"
     : (Instr(OldOptions,"*0")) ?  Options
     : (Instr(OldOptions,"*")) ? Options . "*0" : Options

Options := InsideWord = 1 ?  Options . "?" : Options

Options := (NoEndChar = 1) ?  Options . "O"
     : (Instr(OldOptions,"O0")) ?  Options
     : (Instr(OldOptions,"O")) ? Options . "O0" : Options

Options := Raw = 1 ?  Options . "T"
     : (Instr(OldOptions,"T0")) ?  Options
     : (Instr(OldOptions,"T")) ? Options . "T0" : Options

Options := Execute = 1 ?  Options . "X" : Options

; Added to ensure that Hotstring[2] contains current options
Hotstring[2] := Options

Return


=============================================
CheckOption() Function
=============================================
Set CheckBox control based upon yes/no and button number


CheckOption(State,Button)
{
If (State = "Yes")
  {
    State := 1
    GuiControl, , Button%Button%, 1
  }
Else
  {
    State := 0
    GuiControl, , Button%Button%, 0
  }
  Button := "Button" . Button

; If (LoadHotstrings = 0)
  CheckBoxColor(State,Button)
}


=============================================
Subroutine SaveHotstrings: for Writing Hotstrings to a File
=============================================
Saves currently enabled Hotstrings to the Hotstring folder to a selected
or created .ahk filename.


SaveHotstrings:

Gui, Hotstring:+OwnDialogs
If (InStr(FileExist(A_WorkingDir . "\Hotstrings"), "D") = 0)
    FileCreateDir, %A_WorkingDir%\Hotstrings

SaveFileSelect:

; msgbox %filepath%

FileSelectFile, SelectFile , S, %FilePath%\%SelectFile%, , Hotstrings(*.ahk;*.hsf)

If ErrorLevel     ; "Cancel" button, close, or Escape
   Return

    If (A_ThisMenuItemPos = 5)
        {
          Goto AppendFile
        }


;SaveFile := StrReplace(SaveFile, ".ahk", "")
If !InStr(SelectFile,".hsf")
  SelectFile .= ".hsf"
FileReadLine, FileHeader, %SelectFile%, 1
If FileExist(SelectFile) and !InStr(FileHeader,"InstantHotkey generated file")
  MsgBox, 3, , Not an InstantHotstring Generated file
                    !`rMay overwrite other code!Continue
                    ?`rYes — Write HotString (.hsf) File
                    !`rNo — Select New Filename!
     IfMsgBox, Cancel
       Return
     IfMsgBox, No
       GoTo SaveFileSelect
If FileExist(SelectFile)   ; . ".ahk")
  MsgBox, 3, , Yes — Overwrite Old Hotstrings
                    !`rNo — Append New Hotstrings!
     IfMsgBox, Cancel
       Return
     IfMsgBox, Yes
       {
          FileCopy, %SelectFile%, %SelectFile%.bak, 1
          FileDelete, %SelectFile%
        }


InstantHotstringSave:

    If (A_ThisMenuItemPos = 3)
        {
          SelectFile := FilePath . "\" . StrReplace(WindowTitle, "*")
          FileReadLine, FileHeader, %SelectFile%, 1
          If InStr(FileHeader,"InstantHotkey generated file")
            {
              FileCopy, %SelectFile%, %SelectFile%.bak, 1
              FileDelete, %SelectFile%
            }
            Else
            {
              MsgBox Not an InstantHotkey Generated File!
                Return
            }
        }

AppendFile:

If (A_ThisMenuItemPos != 5 and !FileExist(SelectFile))
  {
    SplitPath, SelectFile, CurrentFile, FilePath
    WindowTitle := CurrentFile
    WinSetTitle, %WindowTitle%
    Menu, FileMenu, Disable, &Save`tCtrl+S
  }


Head := "; InstantHotkey generated file https://tinyurl.com/ydcjgzuk"
FileAppend , %Head%`r`n, %SelectFile%, UTF-8

ControlGet, Items, List,, ComboBox1, A

Progress, R0-%TotalHotstringCount% x640 y540, Saving %TotalHotstringCount% Hotstrings!



Loop, Parse, Items, `n
{
  If (InStr(A_LoopField, "🛑 Stopped!") = 0)
  {
      FileAppend , %A_LoopField%`r`n, %SelectFile%, UTF-8
      Progress, %A_Index%
  }
}

Progress, Off

;MsgBox Hotstrings added to the %SelectFile% file!

Return


===============================================================================
Subroutine SetDefaultFile: Sets Selected File as the default file on startup
===============================================================================
On startup loads Hotstrings from the selected (FileSelectFile) file save in
Windows Registry.


SetDefaultFile:

    RegRead, OpenFile, HKCU\Software\InstantHotstring, DefaultFile
    If (OpenFile = 0 or !OpenFile)
        DefaultFileName := "No current default file"
    Else
        DefaultFileName := "Current default file" . OpenFile

    MsgBox, 3, , %DefaultFileName%
                    !`rChange default file
                    ?`rYes       — Change current file on Startup
                    !`rNo        — Remove setting (no default)
                    !`rCancel  — Keep current default file!
    IfMsgBox, No
    {
        RegWrite, REG_SZ, HKCU\Software\InstantHotstring, DefaultFile, 0
        Return
    }
    IfMsgBox, Cancel
        Return


If WindowTitle !=""
    SaveFile := WindowTitle
;MsgBox %A_WorkingDir%
If (OpenFile = 0 or !OpenFile or !FilePath)
    FileSelectFile, SaveFile , S, %A_WorkingDir%\Hotstrings, , Hotstrings(*.ahk;*.hsf)
Else
    FileSelectFile, SaveFile , S, %FilePath%\%SaveFile%, , Hotstrings(*.ahk;*.hsf)
If ErrorLevel     ; "Cancel" button, close, or Escape
   Return
RegWrite, REG_SZ, HKCU\Software\InstantHotstring, DefaultFile, %SaveFile%


Return


=============================================
Subroutine LoadHotstrings: Loads Hotstrings from the Selected File
=============================================
Loads Hotstrings from the selected (FileSelectFile) file replacing or updating
duplicate Hotstrings from the file.


LoadHotstrings:

Gui, Hotstring:+OwnDialogs
  If (InStr(FileExist("\Hotstrings"), "D") = 0)
      FileCreateDir, Hotstrings


If (LoadDefault != 1)
{
  FileSelectFile, OpenFile , , %A_ScriptDir%\Hotstrings\, , Hotstrings(*.ahk;*.hsf)
  If ErrorLevel
     Return
}
Else
{
  RegRead, OpenFile, HKCU\Software\InstantHotstring, DefaultFile
  If (Openfile = 0 or !OpenFile)
    Return
  LoadDefault := 0
}
  FileReadLine, FileHeader, %OpenFile%, 1
  If InStr(FileHeader,"InstantHotkey generated file")
  {
    SplitPath, OpenFile, FileName, FilePath
    WindowTitle := FileName
    WinGetTitle, WinName, A
    WinSetTitle, %WinName%, ,%WindowTitle%
  }

; Use *P65001 to read UTF-8 file *P1200 for UTF-16
FileRead, AddHotstring, *P65001 %OpenFile%
; msgbox %addhotstring%
StrReplace(AddHotstring, "`n" , "`n", OutputVarCount)

HotstringCount := 0
DupCount := 0
UpdateCount := 0

StartTime := A_TickCount
GuiControl, Disable, Button12
Progress, R0-%OutputVarCount% x640 y540,%OutputVarCount% lines in file,Loading Hotstrings  •   •   • ,%OpenFile%

ControlGet, DropDown, List, , ComboBox1, A
If (DropDown != "")
  DropDown := DropDown . "`n"

Loop, Parse, AddHotstring, `n
{
  If (A_Loopfield ~= "^:.*?:.+?::[^\s]")  ; Check for valid Hotstring
  {
    Hotstring := StrSplit(A_LoopField, ":", ,5)
    HotText := StrSplit(A_LoopField, A_Space . ";")    ; Removes comments on same line

    If (InStr(DropDown, RTrim(HotText[1]," `r")))
    {
      DupCount++
      Continue
    }

    UpdateCheck := ":" . Hotstring[3] . "::"
;    msgbox %updatecheck%
    If (InStr(DropDown, UpdateCheck))
    {
       RegExMatch(DropDown, ":[\w?*]*:" .  Hotstring[3] . "::.*?(`r|`n)", HotstringMatch)

;      MsgBox % HotstringMatch
;      MsgBox % HotText[1]

      DropDown := StrReplace(DropDown, HotstringMatch , RTrim(HotText[1]," `r") . "`n")
;      msgbox %DropDown%
      UpdateCount++
    }
    Else
    {
      DropDown := DropDown . RTrim(HotText[1]," `r") . "`n"
      TotalHotstringCount++
    }

      HotText := StrSplit(HotString[5], A_Space . ";")    ; Removes comments on same line
      Hotstring(":" . HotString[2] . ":" . HotString[3], RTrim(HotText[1]," `r") , "On")

      HotstringCount++
  }
  Progress, %A_Index%      ,%A_Index% of %OutputVarCount% lines in file
}
Progress, Off
NewList := "|" . StrReplace(Dropdown,"`n","|")
GuiControl,Hotstring: , ComboBox1, %NewList%
; GuiControl, , ComboBox1, %NewList%

ControlGet, test, List, , ComboBox1, A
;msgbox %test%
GuiControl, Enable, Button12

GuiControl, Hotstring:Choose, ComboBox1, 1

GoSub ViewString


ElapsedTime :=format("{1:0.3f}" ,(A_TickCount - StartTime)/1000)
MsgBox, %HotstringCount% Hotstrings Loaded
     !`r%DupCount% Duplicates
     !`r%UpdateCount% Updates
     !`r%TotalHotstringCount% Total Hotstrings Loaded!
     !`r%ElapsedTime% Seconds!

Return


=============================================
Subroutine CapsCheck: Deal with Peculiarities of the C Option
=============================================
This subroutine checks for the C1 options and sets CapCheck to 1 if true


CapsCheck:
  If (Instr(HotString[2], "C1"))
       CapCheck := 1
  GuiControlGet, OutputVar1, Focus
  GuiControlGet, OutputVar2, , %OutputVar1%
; If (LoadHotstrings =0)
  CheckBoxColor(OutputVar2,OutputVar1)

Return


=============================================
Function CheckBoxColor(State,Button) Changes CheckBox Text Red
=============================================


CheckBoxColor(State,Button)
{
  If (State = 1)
    Gui, Hotstring:Font, cRed Norm
  Else
    Gui, Hotstring:Font, cBlack Norm
  GuiControl, Hotstring:Font, %Button%
}

=============================================
Subroutine Reload: Clears All Hotstrings by Reloading the Script
=============================================
Reload the script.


Reload:
  Gui, Hotstring:+OwnDialogs
  MsgBox, 4,, All Hotstrings will be deleted!`r`rContinue?
  IfMsgBox Yes
    Run, AutoHotkey.exe InstantHotstring.ahk "2"
Return


=============================================
Subroutine AddSaveSample: Creates the Hotstring Subdirectory and
Saves a Sample File
=============================================
Add a sample saved file to the /Hotstrings/ folder.
Using the continuation parentheses allows including Hotstring or Hotkey
code without activating the code when first loading the file:
https://autohotkey.com/docs/Scripts.htm#continuation-section


AddSaveSample:

; https://autohotkey.com/docs/Scripts.htm#continuation-section
; https://lexikos.github.io/v2/docs/Scripts.htm#continuation-section

SampleFile := "
(
; InstantHotkey generated file https://tinyurl.com/ydcjgzuk

This SampleSaveFile.ahk represents the file type saved by the
InstantHotstring.ahk script. You can use it to load the Hotstrings
into the InstantHotstring app or run the Hotstrings directly with
AutoHotkey.


:*:btw::by the way
:*:fyi::for your information
:*:imho::in my humble opinion
:*:imo::in my opinion
:*:lol::laugh out loud
:*:tmi::too much information
:OT:cew::http://www.computoredge.com
)"
    
    If (InStr(FileExist("\Hotstrings"), "D") = 0)
        FileCreateDir, Hotstrings
    
    ;MsgBox, % A_ScriptDir . "\Hotstrings\SampleSaveFile.ahk Created"
    FileName := A_ScriptDir . "\Hotstrings\SampleSaveFile.ahk"
    If !FileExist(A_ScriptDir . "\Hotstrings\SampleSaveFile.ahk")
        FileAppend , %SampleFile%, %FileName%, UTF-8
    
    Return
    
    MenuBarAction:
    
    MsgBox %A_ThisMenuItem% not yet implemented!
    
    Return
    
    
    =============================================
    You Can Use the Following Subroutine and Function to Test the
    X Option—Click1: and Click()
    =============================================
    To use more subroutines or functions with the  X option, either add
    them to this script prior to implementation or #Include them in this script.


; Sample Label subroutine for use with X Hotstring option.

Click1:
Gui, Hotstring:+OwnDialogs
MsgBox,,, Click Label!, 5
Return

; Sample function for use with X Hotstring option.

Click()
{
    Gui, Hotstring:+OwnDialogs
    MsgBox,,, Click function!, 5
}

; Another sample subroutine for use with X Hotstring option.
; Each Tags Hotstring must be activated separately

Tags:
; msgbox, %A_ThisHotkey%
If (InStr(A_ThisHotkey,"[u"))
    SendInput, [url][/url]{left 6}
If (InStr(A_ThisHotkey,"[i"))
    SendInput, [img][/img]{left 6}
If (InStr(A_ThisHotkey,"[d"))
    SendInput, [docs][/docs]{left 7}
If (InStr(A_ThisHotkey,"[c"))
    SendInput, [code][/code]{left 7}
If (InStr(A_ThisHotkey,"(`"))
    SendInput, (){left 1}
Return


    =============================================
    Hotstring Menu Function TextMenu(TextOptions) and Subroutine MenuAction:
    =============================================
    The following function and subroutine creates a menu of replacement option when
    activating the a Hotstring. Call the function in the form:
    :x:flux::TextMenu("Flux | &0,Flux #&1,Flux #&2")
    The vertical bar delimiter | allows the addition of descriptive tags and single-key
    shortcuts (e.g. &0 for the zero key) which will not appear in the replacement text.


TextMenu(TextOptions)
{
    ;  StringSplit, MenuItems, TextOptions , `,
    MenuItems := StrSplit(TextOptions, "`,")
    Loop % MenuItems.MaxIndex()
    {
        Item := MenuItems[A_Index]
        Menu, MyMenu, add, %Item%, MenuAction
    }
    Menu, MyMenu, Show ,%A_CaretX%,%A_CaretY%
    ;  Menu, MyMenu, Show
    Menu, MyMenu, DeleteAll ;Moved from MenuAction:
}

MenuAction:
InsertText := StrSplit(A_ThisMenuItem, "|")
;  StringSplit, InsertText, A_ThisMenuItem,¦
TextOut := StrReplace(RTrim(InsertText[1]), "&")
SendInput {raw}%TextOut%%A_EndChar%
Return



    =============================================
    Subroutine Reset: to Block External Hotstring Action
    =============================================
    Use with the  X option to block Hotstring in other running scripts.


Reset:
;Msgbox %A_ThisHotkey%

Send, % SubStr(A_ThisHotkey,4)
Click, %A_CaretX%, %A_CaretY%
Send, % A_EndChar

Return

; Sample Formats for calling X option Hotstrings embedded in any script—
; not loaded or activated with InstantHotstring.ahk script.


    
    ; :X:wer::click()
    ;:X:asd::gosub, click1
    ;::ibus::^iitalics^i ^bbold^b ^uunderline^u !+dstrikethrough!+d :
    ;::add::Jack Dunning{enter}1234 Main Street{enter}Anytown, USA
    
    
    
    :x*?:$``::TextMenu("¢,£,¥,€")
    :x*?:f``::TextMenu("⅒,⅑,⅛,⅐,⅙,⅕,¼,⅓,⅜,⅖,½,⅗,⅝,⅔,¾,⅘,⅚,⅞")
    :x*?:s``::TextMenu("©|Copyright,®|Registered,™|Trademark,°,•,·,…,¶")
    :x*?:m``::TextMenu("±,×,÷,≈,≅,∑,ƒ,¹,²,³")
    :x*?:a``::TextMenu("⇐,⇔,⇒,⇑,⇓")
    :x*?:b``::TextMenu("🦄 | Unicorn &1,🐀 | Rat &2
    ,🐁 | Mouse &3,🐂 | Ox &4,🐃 | Water Buffalo &5
    ,🐄 | Cow &6,❓ | Red &7,❔ | White &8")
    :x:flux::TextMenu("Flux|&0,Flux #&1,Flux #&2")
    


*/
