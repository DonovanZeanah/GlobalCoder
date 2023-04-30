; AutoHotkey v2 class to replace all instances of the word 'placeholder' (case-insensitive) in a file called 'PlaceholderController.cs'

; Create an instance of the PlaceholderReplacer class
replacer := PlaceholderReplacer()

; Replace placeholders in the 'PlaceholderController.cs' file
replacer.ReplaceInFile("PlaceholderController.cs")


class PlaceholderReplacer2{
    static searchWord := "placeholder"
    static replacementWord := "yourReplacementWord"
    
    ReplaceInFile(filePath) {
        FileRead(this.content, filePath)
        
        ; Use RegExReplace to perform the case-insensitive replacement
        this.caseInsensitiveContent := RegExReplace(this.content, "(?i)" . this.searchWord, this.replacementWord)
        
        ; Backup the original file by renaming it
        FileMove(filePath, filePath . "_backup")
        
        ; Save the modified content to the original file
        FileWrite(filePath, this.caseInsensitiveContent)
        
        MsgBox("The replacement process is complete.")
    }
}









