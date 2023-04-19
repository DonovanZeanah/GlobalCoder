#Requires AutoHotkey v1.1.34+
#Include class/class_json.ahk
;#include export.ahk


#Include %A_ScriptDir%\class\node_modules
#Include stringc.ahk\export.ahk
#Include string-similarity.ahk\export.ahk
#include biga.ahk/export.ahk


; requires https://www.npmjs.com/package/string-similarity.ahk
A := new biga() ; requires https://www.npmjs.com/package/biga.ahk

FileRead, OutputVar, % A_ScriptDir "\google.txt"
array := A.split(OutputVar, "/\s{10,100}\w{3}, \w{3}\s\d+,\s\d{4}\sat\s\d*\:\d*\s\w{2}\s/")
filteredArray := fn_removeSimilar(array, 0.98)
output := A.join(filteredArray, "`n")
FileAppend, %output%, % A_ScriptDir "\output.txt"
msgbox, % "done: " filteredArray.count() " vs " array.count()

FileRead, OutputVar, output.txt
Sort, OutputVar, u
sleep, 300
FileAppend, %OutputVar%,%A_SCRIPTDIR%\output-completed.txt
return

fn_removeSimilar(inputArr, threshold)
{
	arr := inputArr.clone()
	outputArr := []

	loop, % arr.count() {
		value := arr.removeAt(1)
		scoredStrings := stringsimilarity.findBestMatch(value, arr)
		for key2, value2 in scoredStrings.ratings {
			if (value2.rating > threshold) {
				continue 2
			}
		}
		outputArr.push(value)
	}
	return outputArr
}



;Including the module provides a class `stringc` with three methods: `.compare`, `.compareAll`, and `.bestMatch`

;#include class/stringc.ahk/export.ahk


a := new biga()


; screwdriver := new inventory("screwdriver", "small tool", 2)
; screwdriver.addItems(100)
; screwdriver.addItems(66)
; screwdriver.addItems(10)
; screwdriver.saveStatus()



hammer := new inventory("hammer")
hammer.savestatus()

^1::
hammer.input()
return
;hammer.savestatus()


return


;;have exitapp call savestatus method rather than always saving after inputting values.


class inventory {
    __New(name, category:="misc", price:=1.00, stock:=1, source:="") {
        ; read from default filepath if none specified
        if (source == "") {
            this.filePath := A_ScriptDir "\" name ".json"
            FileRead, OutputVar, % this.filePath
            ; if the file was blank
            if (strLen(OutputVar) < 3) {
                this.name := name
                this.category := category
                this.price := price
                this.stock := stock
                this.source := source
                return this
            }
            obj := JSON.parse(OutputVar)
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
    input(){ ;method to add object values via inputbox
        InputBox, inp
        if inp = """"
            {
            return
            } 
        this.stock += inp 
        this.saveStatus()
 
    
}
}