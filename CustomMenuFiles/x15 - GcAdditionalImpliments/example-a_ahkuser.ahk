#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force


#Include %A_ScriptDir%\JSONData.ahk


SETTINGS_FILE := A_ScriptDir . "\manifest.json"
Settings := new JSONData(SETTINGS_FILE) ; create a new instance of JSONData base object
if (ErrorLevel) { ; specifically, ErrorLevel is set to 'ERROR_FILE_NOT_FOUND' if the file doesn't exist and to 'ERROR_PARSE_ERROR' if the file is badly formatted
	MsgBox, 64,, % "Could not read or parse: " . SETTINGS_FILE . "`r`nSpecifically: " . ErrorLevel . "`r`n`r`nThe program will exit."
ExitApp
}
data := Settings.__data__ ; get a reference to the data themselves

; =========== retrieve a specific datum ===========
MsgBox % JSONData.stringify(data, A_Tab) ; displays all data as a string using the stringify base method; A_Tab will insert a tab character into the output JSON string for readability purposes
MsgBox % data.options.outputDebug ; the dot is the easiest way to retrieve a specific datum
MsgBox % (data.parameters)[0] ; using brackets, the parenthesis are required when used in combination with the dot syntax; also, indexes start with 0
MsgBox % (data.parameters).join("~") ; each time  an array or object is retrieved it is question of the javascript one so one can operate upon it using javascript methods supported by the type of the value retrieved
MsgBox % data["some key"] ; if key contains spaces, it must be enclosed in brackets
MsgBox % data["[AA]BB[CC]"] ; brackets are  here required to avoid an ambiguous use of the dot > .[

; =========== operate upon data using a enumerator object ===========
enum := new JSONData.Enumerator(data.hotkeys.keyboard.hotkeys) ; enumerator object similar to the ahk one, usefull to enumerate all items in a collection
while enum.next(k, v)
	MsgBox % k . "," . v
	
; =========== delete data ===========
JSONData.delete(data, "hotkeys") ; let's delete some key using the delete base method
MsgBox % JSONData.stringify(data) ; displays data as a string to see changes
Settings.restore() ; undo changes
data := Settings.__data__ ; restore data which still contains the previous data
MsgBox % JSONData.stringify(data)

; =========== retrieve keys ===========
keys := Settings.getKeys("hotkeys", "keyboard", "hotkeys") ; get all the key which belongs to an associative array using the getKeys instance method
MsgBox % keys.join("|") ; one can use the join javascript method upon string values (usefull to populate a DropDownList from a settings file for example)
Loop % keys.length ; one must use javascript length property and not the eponymous ahk method since getKeys return a javascript array
{
MsgBox % keys[ a_index - 1 ] ; same as above: indexes start with 0
}

; =========== create and save various type of data ===========
if (Settings.getKeys().indexOf("test_array_of_objects") = -1) ; if the key 'test_array_of_objects' still not exists yet...
	data.test_array_of_objects := new JSONData.Array() ; ...create a new array
obj := new JSONData.Object() ; create a new object
obj.a := "some text"
obj.b := 3
obj.c := ""
obj.d := false
obj.e := new JSONData.Object()
obj.f := new JSONData.Array()
data.test_array_of_objects.push(obj) ; appends the object to the array
Settings.updateData() ; updates the file
run, notepad %SETTINGS_FILE% ; run the files to see changes
