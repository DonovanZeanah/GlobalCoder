class MyTextEditor {
    __New(title) {
        ; The constructor method that is called when a new instance of the class is created
        ; It takes one argument, the title of the form
        this.title := title
        this.form := GuiCreate(this.title)
        ; Create the edit control on the form
        this.edit := GuiControl, , Edit, , , this.form
        Gui, Show, % "w300 h200, " this.title
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
            FileRead, firstLine, %filepath%, 1
            return firstLine
        } else {
            MsgBox, 16, Error, File not found
            return ""
        }
    }
    
    HandleFile(filepath) {
        ; Method that takes a filepath and handle the file according to its first line content 
        firstLine := this.ReadFirstLine(filepath)
        if (firstLine == "")
        {
        return
        }
        return firstline := switch(firstLine)
        }
    
        
        ; switch statement to handle different cases
        /*switch(firstLine) {
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
        */
        }
            
        }
        switch(firstLine) {
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
            
        }
    }

