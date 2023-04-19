#Requires AutoHotkey v2.0-beta.7 
#warn all, off

testfile := A_WorkingDir . "/text.txt"
test := ReadFile(testfile)
MsgBox(test)



WriteFile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
}

AppendFile(whichFile, text) {
    if FileExist(whichFile)
        fileObj := FileOpen(whichFile, "a")
    else
        fileObj := FileOpen(whichFile, "w")
    fileObj.Seek(0, 2)
    fileObj.Write(text)
    fileObj.Close()
}

ReadFile(whichFile) {
   fileObj := FileOpen(whichFile, "r")
   fileObj.Seek(0, 0)
   text := fileObj.Read()
   fileObj.Close()
   return text
}