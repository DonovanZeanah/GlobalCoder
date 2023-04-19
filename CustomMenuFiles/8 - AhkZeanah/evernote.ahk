;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;     Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

;  Here's the basic hotkey syntax - reference.
;  #n::Run Notepad     ; this means the Win+n
;  !n::Run Notepad     ; this means Alt+n
;  ^n::Run Notepad     ; this means Ctrl+n
;  F6::Run Notepad     ; F6
;  ^F6::Run Notepad    ; Ctrl+F6
;  ^!n::Run Notepad    ; Ctrl+Alt+n
;  NumLock & n::       ; Numlock+n

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. Backup file will be saved in the scripts location.

; the following line disables the numlock key - this makes it available as a hotkey modifier
SetNumlockState,Alwayson

;Inventory form to paste info into Evernote.

; Here's the hotkey used to launch the form - ALT I

!I::

;The following sets the default text in the "Location:" field of the form - Can leave blank.
DefaultLocation = Living Room

; The following variable defines the background color of the form - uses HTML color codes (must be all CAPS).
CustomColor = ADD8E6


; The following variable sets the font size (in points) the form text will use.
CustomFont = s12


BackupFile = invnote.txt ; Backup filename

FormatTime, RightNow

Gui, Color, %CustomColor%

Gui, font, %CustomFont%
Gui, Add, Text,, Description:
Gui, Add, Text,, Location:
Gui, Add, Text,, Item Barcode:
Gui, Add, Text,, Category:
Gui, Add, Text,, 
;Gui, Add, Text,, 
Gui, Add, Text,, Serial Number:
Gui, Add, Text,, UPC Barcode:
Gui, Add, Text,, Value:
Gui, Add, Text,, Weight:
Gui, Add, Text,, Where Purchased:
Gui, Add, Text,, Purchase Date:
Gui, Add, Text,, Warranty end date:
Gui, Add, Text,, Location of receipt:
Gui, Add, Text,, Sell?:
Gui, Add, Text,, Notes:

Gui, Add, Edit, vDescription w240 ym, ; The ym option starts a new column of controls.,
Gui, Add, Edit, vLocation w120, %DefaultLocation%
Gui, Add, Edit, vBarcode w120,
Gui, Add, ListBox, w400 h80 multi vcategoryList, Computer|Electronics|Music|Automotive|Photography|Office Supplies|Home Theatre|Game|Tools|Media|Misc
Gui, Add, Edit, vser w120,
Gui, Add, Edit, vupc w120,
Gui, Add, Edit, vValue w120,
Gui, Add, Edit, vweight w120,
Gui, Add, Edit, vpur w120,
Gui, Add, Edit, vpdate w120,
Gui, Add, Edit, vwar w120,
Gui, Add, Edit, vrec w120, N/A
Gui, Add, Edit, vsell w120, No
Gui, Add, Edit, vnotes r15 w500

Gui, Add, Button, h30 , Enter ; The label ButtonEnter will be run when the button is pressed.
Gui, Add, Button, h30 , Cancel ; The label ButtonCancel will cancel action and close gui but keep script running.
Gui, Add, Button, h30 , Open File ; The label ButtonOpenFile will be run when the button is pressed.


Gui, Show,, Evernote Inventory Item Input
return 

; The action performed when the "Open File" button is clicked.
ButtonOpenFile:
Run, %BackupFile%
return

;The following section is the action performed when the enter button is clicked. 
;The first part is to save all of the field variables to the clipboard formatted for Evernote. ;The second part is to check that Evernote is open - if not it will open the program.
;The third part the clipboard is pasted to Evernote.
;The fourth part the raw form data is appended to the backup text file to store locally.
;The last part destroys the gui form - this closes the form window.

ButtonEnter:
store := clipboard
Gui, Submit
Clipboard = Description: %Description%`r`nLocation: %Location%`r`nBarcode: %Barcode%`r`nCategory: %categorylist%`r`nSerialNumber: %ser%`r`nUPC Barcode: %upc%`r`nValue: %Value%`r`nWeight: %weight%`r`nWhere Purchased: %pur%`r`nPurchase Date: %pdate%`r`nWarranty end date: %war%`r`nLocation of receipt: %rec%`r`nSell?: %sell%`r`nNotes: %notes%

{
IfWinExist, ahk_class ENMainFrame
WinActivate
Else
Run Evernote.exe, %A_ProgramFiles%\Evernote\Evernote\
Sleep 5000
}

;The following line pastes the form fields in Evernote - you should have the inventory notebook open in Evernote

Send ^!v ;Paste clipboard into Evernote as a new note
Sleep 1000


;the following formats and pastes the form data to the backup text file.
FormatTime, EndNow,, M/d/yyyy h:mm tt
FileAppend, %Description%`,%Location%`,%Barcode%`,%categorylist%`,%ser%`,%upc%`,%Value%`,%weight%`,%pur%`,%pdate%`,%war%`,%rec%`,%sell%`,%notes%`,%EndNow%`n, %BackupFile%

;The following defines the action taken when the cancel button is clicked - it also closes the form after the data is pasted.

ButtonCancel:
Gui,Destroy

