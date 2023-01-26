;\Lib\references
;Lib\notes\keyboard.md
;logs/queries.txt
/*
filepaths := {}
filePaths := { 1 : ""
, 2 : A_ScriptDir . ""
, 3 : A_ScriptDir . ""
, 4 : A_ScriptDir . ""
, 5 : A_ScriptDir . ""
}
static urls := { 0: ""
        , 1 : "https://www.google.com/search?hl=en&q="
        , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
        , 3 : "https://www.google.com/maps/search/"
        , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
filepaths.push(A_ScriptDir . "path\to\file.txt")

*/

filePath := A_ScriptDir . "\lib\ref\globalcoder.txt"

menu := new menubuilder()
menu.ProcessFile(filePath)

msgbox, % "Number of lines in file: "  menu.fileLines.MaxIndex()




menu.build(codeManipulator.readFile(filePath))


; check the number of lines in the file

; check the content of the file
msgbox, % "Line 1: " . codeManipulator.fileLines[1]







class FileHandler {
    _ReadFile(filePath) {
    	;msgbox, % "_fh: " filePath
        FileRead, fileContent, % filePath
       fileLines := []
        Loop, Parse, fileContent, `n, `r
        {
            fileLines.Push(A_LoopField)
        }
        Return fileLines
    }

    ProcessFile(file) {
    	    ;	msgbox, % "Fh: "filePath
        this.fileLines := this._ReadFile(file)
    }
}

class CodeManipulator extends FileHandler {
    countFold := 0
    countUnfold := 0
    foldReturns := []
    unfoldReturns := []

    FoldCode(code) {

        this.countFold += 1
        code := StrReplace(code, "`r`n", "")
        code := StrReplace(code, "`n", "")
        code := StrReplace(code, "`t", " ")
        this.foldReturns.Push(code)
        Return code
    }

    UnfoldCode(code) {
        this.countUnfold += 1
        code := StrReplace(code, " ", "`t")
        code := StrReplace(code, "`r`n", "`n")
        this.unfoldReturns.Push(code)
        Return code
    }
}

class GuiBuilder extends FileHandler {

__new(){

}
build(filelines){




/*file := FileOpen("C:\example.txt", "r")
file_contents := file.Read()
file.Close()

lines := StrSplit(file_contents, "`n")

y := 10

Loop, % lines.MaxIndex()
{
    line := lines[A_Index]
    Gui, Add, Button, x10 y%y% w150 h25, %line%
    y += 30
}
This script reads the contents of a file called "example.txt" and splits it into an array of lines. Then it creates a button for each line in the file, with the button's label being the text of the line. The button's position will be in a vertical alignment.

*/



/*; Read the contents of the file into a variable
FileRead, FileContents, C:\example.txt

; Split the file contents into an array of lines
StringSplit, Lines, FileContents, `n

; Loop through each line
Loop, % Lines0
{
    ; Split the current line into an array of words
    StringSplit, Words, Lines%A_Index%, %A_Space%

    ; Create a new GUI for each word
    Loop, % Words0
    {
        Gui, Add, Text, , %Words%A_Index%
    }

    Gui, Show
}
*/







; Read the contents of the file into a variable
; Split the file contents into an array of lines
; Loop through each line
; Split the current line into an array of words
; Create a new GUI for each word



/*
    ReadFile(filePath) {
        FileRead, fileContent, % filePath
        fileLines := []
        Loop, Parse, fileContent, `n, `r
        {
            fileLines.Push(A_LoopField)
        }
        Return fileLines
    }

    ProcessFile(file) {
        this.fileLines := this.ReadFile(file)
    }
}

class CodeManipulator extends FileHandler {
    countFold := 0
    countUnfold := 0
    foldReturns := []
    unfoldReturns := []

    FoldCode(code) {
        this.countFold += 1
        code := StrReplace(code, "`r`n", "")
        code := StrReplace(code, "`n", "")
        code := StrReplace(code, "`t", " ")
        this.foldReturns.Push(code)
        Return code
    }

    UnfoldCode(code) {
        this.countUnfold += 1
        code := StrReplace(code, " ", "`t")
        code := StrReplace(code, "`r`n", "`n")
        this.unfoldReturns.Push(code)
        Return code
    }
}








menubuilder(){ 
	FileRead, FileContents, C:\example.txt
	StringSplit, Lines, FileContents, `n
	Loop, % Lines0
	{
		;StrSplit(String, [Delimiters, OmitChars])
	    StringSplit, Words, Lines%A_Index%, %A_Space%
	    Loop, % Words0
	    {
	        Gui, Add, Text, , % Words%A_Index%
	    }
	    Gui, Show
	}
}
*/
; Read the contents of the file into a variable
; Split the file contents into an array of lines
; Loop through each line
; Split the current line into an array of words
; Create a new GUI for each word