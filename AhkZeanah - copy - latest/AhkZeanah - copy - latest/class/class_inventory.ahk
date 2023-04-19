;#include class/class_json.ahk


hammer := new inventory("hammer", "small-tool")
hammer.saveStatus()
MsgBox, % "0: `n " hammer.stock 
return


class inventory {
    __New(name, category:="misc", price:=100, stock:=0, source:="") {
        ; read from default filepath if none specified
        if (source == "") {
            this.filePath := A_ScriptDir "\" name ".json"
        } else {
            this.filePath := source
        }
        FileRead, OutputVar, % this.filePath
        ; if the file was not valid for any reason
        if (JSON.test(OutputVar)) {
            this.name := name
            this.category := category
            this.price := price
            this.stock := stock
            this.source := source
        } else {
            ; parse the json file
            obj := JSON.parse(OutputVar)
            ; assign object to this properties
            this.name := name
            this.category := obj.category
            this.price := obj.price
            this.stock := obj.stock
            this.source := obj.source
        }
        return this
    }

    addItems(param_x := 0) {
        this.stock += param_x
    }

    saveStatus() {
        string := JSON.stringify(this)
        msgbox, % string
        FileDelete, % this.filePath
        FileAppend, % string, % this.filePath
    }

    
}