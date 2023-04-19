editor := new MyTextEditor("My Text Editor")


; Save paths list
editor.paths := ["d:\\test\\test.txt", "d:\\test\\test2.txt"]
for v in editor.paths
editor.SavePaths("d:\\test\\test-saved-paths.txt")

; Clear the paths list
editor.paths := []

; Load the paths from the file
editor.LoadPaths("d:\\test\\test-saved-paths.txt")

; Display the first path
for k,v in editor.paths
{
msgbox, % v

editor.ShowPathsGUI(v)
}
; Save the contents of the edit control to a file
editor.Savepaths("d:\\test\\test-saved-paths-again.txt")


; Handle a file according to its first line
editor.HandleFile(v)


;#include class mytexteditor-gpt.ahk

; Function to load the paths from a file
/*
LoadPaths(filePath) {
    paths := []
    FileRead, contents, %filePath%
    Loop, Parse, contents, `n
    {
        paths.Insert(A_LoopField)
    }
    return paths
}

; Example usage:
paths := LoadPaths("C:\\path\\to\\saved_paths.txt")
*/

;==== class imnpliment




mypathManager := new PathManager()
pathManager.paths := ["C:\\path\\to\\file1.txt", "C:\\path\\to\\file2.txt", "C:\\path\\to\\file3.txt"]
pathManager.SavePaths("C:\\path\\to\\saved_paths.txt")

pathManager.paths := []
pathManager.LoadPaths("C:\\path\\to\\saved_paths.txt")

msgbox % pathManager.paths[1]



/*class PathManager {

    paths := []

    SavePaths(filePath) {
        FileDelete, %filePath%
        Loop, % this.paths.MaxIndex()
        {
            FileAppend, % this.paths[A_Index] "`n", %filePath%
        }
    }

    LoadPaths(filePath) {
        FileRead, contents, %filePath%
        Loop, Parse, contents, `n
        {
            this.paths.Insert(A_LoopField)
        }
    }

}

;========== extend pathmanager using mytexteditor-gpt.ahk
*/
class PathManager {
    paths := []

    SavePaths(filePath) {
        FileDelete, %filePath%
        Loop, % this.paths.MaxIndex()
        {
            FileAppend, % this.paths[A_Index] "`n", %filePath%
        }
    }

    LoadPaths(filePath) {
        FileRead, contents, %filePath%
        Loop, Parse, contents, `n
        {
            this.paths.Insert(A_LoopField)
        }
    }
}

class MyTextEditor extends PathManager {
    __New(title) {
        ; The constructor method that is called when a new instance of the class is created
        ; It takes one argument, the title of the form
        this.title := title
        this.form := this.createPathsGUI(this.title)
        ; Create the edit control on the form
        this.edit := GuiControl, , Edit, , , this.form
        Gui, Show, w300 h200, % this.title
    }

    SaveFile(filepath) {
        ; Method that takes a filepath and save the current text of the editor to that file
        ; Using FileAppend to preserve linebreaks and spaces
        FileAppend, % this.edit, %filepath%, utf-8
    }

    ReadFirstLine(filepath) {
        ; Method that reads the first line of a file and return it
        ; Check if the file exists before trying to read from it
        if (FileExist(filepath)) {
            loop, FileRead, firstLine, %filepath%, 1
            return firstLine
        } else {
            MsgBox, 16, Error, File not found
            return ""
        }
    }
    HandleFile(filepath) {
    firstLine := this.ReadFirstLine(filepath)
    if(firstLine == ""){
        return
    }
    if(firstLine == "csv"){
        MsgBox, 0, , "This is a CSV file"
        ; Do something with the file
    }
    else if(firstLine == "JSON"){
        MsgBox, 0, , "This is a JSON file"
        ; Do something else with the file
    }
    else{
         MsgBox, 0, , "I don't know what type of file this is"
         ; Do a default action
    }
}

   /* HandleFile(filepath) {
        ; Method that takes a filepath and handle the file according to its first line content 
        firstLine := this.ReadFirstLine(filepath)
        if(firstLine == ""){
                    
         return
     }
         
        this.switch(firstline)
        ; switch statement to handle different cases
        }
        */

      /*  ShowPathsGUI(filepath) {
        this.paths := []
        this.LoadPaths(filepath)
        this.paths_gui := GuiCreate("Paths")
        Loop, % this.paths.MaxIndex() {
            GuiControl, , Button, % "Path " A_Index ": " this.paths[A_Index], , this.paths_gui, Path%A_Index%
        }
        Gui, Show, , Paths
    }
     */
     ShowPathsGUI(filepath) {
    this.paths := []
    this.LoadPaths(filepath)
    Gui, -Caption +Resize +AlwaysOnTop
    Gui, Add, Text, x10 y10 w80 h20, "Paths:"
    Loop, % this.paths.MaxIndex() {
        Gui, Add, Button, % "x10 y" (20*(A_Index+1)+10) " w300 h20", % "Path " A_Index ": " this.paths[A_Index]
    }
    Gui, Show, , Paths
} 
}
    
/* 
}

switch(firstline){
            case "CSV":
                MsgBox, 0, , "This is a CSV file"
                ; Do something with the file
                break
            case "JSON":
                MsgBox, 0, , "This is a JSON file"
                ; Do something else with the file
                break
            default:
                MsgBox, 0, , "I don't know what type of file this is"
                ; Do a default action
                break
        }*/

;======= example that impliment the  classes
editor := new MyTextEditor("My Text Editor")
editor.ShowPathsGUI("C:\\path\\to\\saved_paths.txt")
GuiControl, +g, Path1, MyFunction

;========


editor := new MyTextEditor("My Text Editor")

; Save paths list
editor.paths := ["C:\\path\\to\\file1.txt", "C:\\path\\to\\file2.txt", "C:\\path\\to\\file3.txt"]
editor.SavePaths("C:\\path\\to\\saved_paths.txt")

; Clear the paths list
editor.paths := []

; Load the paths from the file
editor.LoadPaths("C:\\path\\to\\saved_paths.txt")

; Display the first path
msgbox % editor.paths[1]

; Save the contents of the edit control to a file
editor.SaveFile("C:\\path\\to\\saved_file.txt")

; Handle a file according to its first line
editor.HandleFile("C:\\path\\to\\file.csv")