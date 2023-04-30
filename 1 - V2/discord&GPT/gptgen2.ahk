; AutoHotkey v2 script to replace case-sensitive instances of 'placeholder' in a file called 'placeholderController.cs'
; Create an instance of the PlaceholderReplacer class

replacer := new PlaceholderReplacer1()

; Replace placeholders in the 'placeholderController.cs' file
replacer.ReplaceInFile("placeholderController.cs")


class PlaceholderReplacer {
    static searchWord := "placeholder"
    static replacementWord := "yourReplacementWord"
   
    ReplaceInFile(filePath) {
        FileRead(this.content, filePath)
       
        ; Use RegExReplace to perform the case-sensitive replacement
        this.caseSensitiveContent := RegExReplace(this.content, "i)" . this.searchWord, this.replacementWord)
       
        ; Backup the original file by renaming it
        FileMove(filePath, filePath . "_backup")
       
        ; Save the modified content to the original file
        FileWrite(filePath, this.caseSensitiveContent)
       
        MsgBox("The replacement process is complete.")
    }
}