;*******************************************************
; Want a clear path for learning AutoHotkey; Take a look at our AutoHotkey Udemy courses.  They're structured in a way to make learning AHK EASY
; Right now you can  get a coupon code here: https://the-Automator.com/Learn
;*******************************************************
#SingleInstance,Force
SetBatchLines,-1 ;Set run w/o any sleeping between things
#MaxMem,4095 ;Increase the variable allowance to max just in case a massive file
;~ https://p.ahkscript.org/?p=519c9979
#include d:/lib/_libflat/

1::
;***********Get row count of file and display headers*******************
Path:= Explorer_GetSelected() ;Explorer Function that gets paths of selected files
SplitPath,Path,File_Name ;grab the file name w/o the path
Loop, read, % Path
    last_line++ ;increment lines

rows:=RegExReplace(last_line,"(?:^[^1-9.]*[1-9]\d{0,2}|(?<=.)\G\d{3})(?=(?:\d{3})+(?:\D|$))", "$0,") ;Add commas to the number
MsgBox,4,, % rows " lines found in: " File_Name "`n`nDisplay headers?"  ;Display rows and ask if want to see headers
IfMsgBox Yes
{
    FileReadLine,Header, % Path, 1 ;read first row
    Comma:={"name":"Comma","char":",","Count":StrSplit(Header,",").count() -1} ;Create Comma object
    Pipe:={"name":"Pipe", "char":"|","Count":StrSplit(Header,"|").count() -1} ;Create Pipe Object
    Tab:={"name":"Tab",  "char":"`t","Count":StrSplit(Header,"`t").count() -1} ;Create Tab object
    Delim:={"name":"Tab",Count:"0","Char":"`t"} ;Set tab to the default
    obj:={"Comma":Comma,"Tab":Tab,"Pipe":Pipe,"Delim":Delim} ;Shove it all into one object
    ;********************Now iterate over each count.  Whichever one has the most, use that one as the Delim***********
    for, k, v in Obj{
        if(v.count>obj.Delim.Count) {
            Obj.Delim.Count:=v.Count
            Obj.Delim.Name:=v.Name
            Obj.Delim.Char:=v.Char
        }
    }
    
    Transposed:=StrReplace(Header,obj.Delim.Char,"`n"obj.Delim.char) ;Transpose header
    MsgBox,,% "The delimmiters are probaly a " obj.Delim.Name " " Obj.Delim.Char ,% Transposed ;Display it all
    return
}
