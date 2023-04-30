
; Usage example:
filePath := "logfile2.txt" ; Provide the path to your .txt file
processor := TextFileProcessor(filePath)

; Access the original file content, each line, and the processed results
fileContent := processor.GetFileContent()
lines := processor.GetLines()
processedLines1 := processor.GetProcessedLines()

 ;Display the processed results for each line
for index, processedLine in processedLines1 {
    MsgBox("Processed line " . index . ":`n" . processedLine)
}


; ; Display the GUI with processed lines
; processor.DisplayGUI()

; ; Continue running the script until the GUI is closed
; SetTimer, CheckGui, 100
; return

; CheckGui:
; if !WinExist("ahk_class AutoHotkeyGUI")
;     ExitApp
; return

; ; Button's g-label subroutine
; CopyToClipboard:
;     processor.CopyToClipboard()
; return

;The DisplayGUI() method creates a new GUI with an edit control and a button. The edit control contains the processed lines separated by newline characters. The button has a g-label subroutine named CopyToClipboard, which calls the CopyToClipboard() method of the TextFileProcessor class when clicked.
;The CopyToClipboard() method copies the selected text from the edit control to the clipboard and shows a message box to confirm the action.
;To use this updated version, simply call the DisplayGUI() method after creating an instance of the TextFileProcessor class. The script will continue running until the GUI is closed.
;Make sure to provide the correct path to your .txt file when initializing the TextFileProcessor instance.
processor.DisplayGUI()

; Button's g-label subroutine
CopyToClipboard() {
    processor.CopyToClipboard()
}





class TextFileProcessor {
    __New(filePath) 
	{
		this.filecontent := ""
		;this.processedlines := {}
        this.filePath := filePath
        this.ReadFileContent()
        this.ProcessLines()
    }

    ReadFileContent() 
	{
		file1 := fileread(this.filepath)
		;this.filecontents
        ;FileRead(this.fileContent, this.filePath)
        this.lines := StrSplit(file1, "`n")
    }

    ProcessLines() 
	{
        this.processedLines := []
        for index, line in this.lines {
			            this.processedLines.Push(StrReplace(line, "\\", "`r`n"))

            ;this.processedLines.Push(StrReplace(line, "//", "`n"))
        }
    }

    GetFileContent() 
	{
        return this.fileContent
    }

    GetLines() 
	{
        return this.lines
    }

    GetProcessedLines() 
	{
        return this.processedLines
    }
	  DisplayGUI() {
		; this.gui := Gui()
        ; processedText := StrJoin("`r`n", this.processedLines)
        ; this.gui.Add("Edit", "vMyEdit w600 h300", processedText)
        ; this.gui.Add("Button", "x+m y+m Default", "Copy to Clipboard").OnEvent("Click", Func(this, "CopyToClipboard"))
        ; this.gui.OnEvent("Close", Func("ExitApp"))
        ; this.gui.Show()

		 static looper := 0
         this.gui1 := Gui()

		 for k,v in this.processedlines
		 {
         	this.gui1.Add("Edit"  , "vMyEdit" . ++looper " w200 h50", v) ;, StrJoin("`r`n", this.processedLines))
		 }
		 	this.gui1.Add("Button", " ", "Copy to Clipboard").OnEvent("Click", Func(this, "CopyToClipboard"))
         	this.gui1.OnEvent("Close", Func("ExitApp"))
        
         this.gui1.Show()
    }
	
 gui_close(*) {                      ; embedded method for close event; used with Gui " event sink "
        Msgbox " Now closing "
        ExitApp
    }
    CopyToClipboard(*) {
        global gui1
        selectedText := gui1["MyEdit"].Value
        clipboard := selectedText
        MsgBox("Selected text has been copied to the clipboard.")
    }

	;    DisplayGUI() {
    ;     Gui, New
    ;     Gui, Add, Edit, vMyEdit w600 h300, % StrJoin("`r`n", this.processedLines)
    ;     Gui, Add, Button, x+m y+m Default gCopyToClipboard, Copy to Clipboard
    ;     Gui, Show
    ; }

    ; CopyToClipboard() {
    ;     GuiControlGet, selectedText,, MyEdit
    ;     Clipboard := selectedText
    ;     MsgBox, "Selected text has been copied to the clipboard."
    ; }

}
