
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("GET", "http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/AHKL_ChangeLog.htm")
WebRequest.Send()
RegExMatch(WebRequest.ResponseText, "(?<=<h2>).*?(?=</h2>)", ver)
;MsgBox % ver
WebRequest := ""


sd := ComObjCreate("Scripting.Dictionary")

;// Add Items
sd.Add("Name", "AutoHotkey")
sd.Add("Abv", "AHK")
sd.Item("URL") := "www.autohotkey.com"

;// Get Item
MsgBox "Name = " sd.item("Name")

;// Get Number of Items
;MsgBox, , Item Count, % "Total Items: " sd.Count

;// Check for Key Existance
;MsgBox, , Key Exist?
  , % "Abv Exist: " sd.Exists("Abv") "`n"
  . "Test Exist: " sd.Exists("Test")

;// Remove a Key
sd.Remove("Abv")
MsgBox, , Removed: "Abv", % "Abv Exist: " sd.Exists("Abv")

;// Enumerate Keys
for Key in sd
  list .= Key " = " sd.item(Key) "`n"
MsgBox, , Enumerated Keys, %list%

;// Clear the Dictionary
sd.RemoveAll()
MsgBox, , Removed All Keys, % "Total Items: " sd.Count

sd := ComObjCreate("Scripting.Dictionary")

;// Case Sensitive Keys
sd.item("ahk") := "autohotkey"
sd.item("AHK") := "AutoHotkey"
MsgBox % sd.item("ahk") "`n" sd.item("AHK")

sd.RemoveAll()

;// Enumerate Keys in Order of Creation
Loop, 5
  sd.item(6-A_Index) := "Value " A_Index
for key in sd
  t .= key " = " sd.item(key) "`n"
MsgBox %t%