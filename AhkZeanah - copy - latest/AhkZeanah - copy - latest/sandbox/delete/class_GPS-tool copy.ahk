#Requires AutoHotkey v1.1.34.03
;#include P:\app\repos-github\biga.ahk\biga.ahk
;works task := new fp.tool()
;#Requires AutoHotkey v1.1.34.03

;class tool{
;__new(Item, ppath:="")
;check() 
;givevalues(x := "") 
;readfile(ath := "")
;showfile(data := "")
;savetofile()
;total()

;__New(Item,type,ppath := "", unit := 0,price:= 0.00,stock:= 0,source:= "", datepurchased := 00.00.0000){

;savetofile accepts a frontproject path (already established path)
;readfile returns afile object, with k,v pairs ex. k = screws, v = 305
;showfile accepts afile object thats returned by this.readfile()
;the "frontproject" should always be the last accessed object

screwdriver := new tool()
;screwdriver.givevalues("screws", 100)
;screwdriver.givevalues("screws", 100)

screwdriver.givevalues("screws", 105)
screwdriver.savetofile()
screwdriver.givevalues("nails", 1000)
screwdriver.savetofile()

;gui, edit, % screwsriver.afile.sum
;Gui, add, edit, % screwdriver.afile.sum

loopvar := screwdriver.showfile(this.readfile(this.ppath))


;for k,v in loopvar
    ;MsgBox, % "3: `n " k " " v


;thisvar := screwdriver.readfile()
;msgbox % screwdriver.items.screws
;screwdriver.check()
;print(screwdriver.items)


return 
esc::exitapp 

class experiment{

__new(name, tool, description, taskinput := "", taskoutput :="")
    {
        return this
    }
}


class tool{
;__new(Item, ppath:="")
;check() 
;givevalues(x := "") 
;readfile(ath := "")
;showfile(data := "")
;savetofile()
;total()

static tooltotal := 1
static frontproject := "c:\tester"


;    __New(Item,type,ppath := "", unit := "",price:= "",stock:= 0,source:= ""){

    __New(ppath := ""){
        
        tool.tooltotal++
        this.items := {}
        ;this.item := {}
        this.ppath := ppath
        this.unit := unit
        this.price := price
        this.stock := stock 
        this.source := source

        if (ppath != ""){
            this.ppath := A_Desktop . "\" . ppath . ".txt"
            this.frontproject := this.ppath
        } else {
            this.ppath :=  A_Desktop . "\project.txt"
            this.frontproject := this.ppath
        }

        

        if !FileExist(this.ppath){
            FileAppend, % "`n" item "," a_now,  this.ppath
        }
        if (item = "screwdriver"){
            this.timetounscrew := 7.5
        } else if(item = "powerdriver"){
            this.timeToUnscrew := 5 
        }

    }
     addItems(param_x := 0){

        this.stock += param_x
    }


    check(){

        MsgBox, % "10: `n tool.frontproject: " tool.frontproject . "10: `n this.frontproject: " this.frontproject . "10: `n frontproject: " frontproject . "2: `n " this.timeToUnscrew " seconds"
        return 
    }

    givevalues(item, x := 0){

       if (!this.items.haskey(item)){
        this.items[item] := x 
        MsgBox, % "0: `n first " x " " item " added "
       }
       else {
        this.items[item] += x
        MsgBox, % "1: `n " x " " item " added" 
       }   
    }

    
    readfile(ppath := ""){
        tool.frontproject := this.frontproject

        if this.ppath != "" or fileexist(A_Desktop . this.ppath)
        {
            ;MsgBox, % "9: `n " this.frontproject
           ; MsgBox, % "0: `n " this.ppath
           ; this.frontproject := "c:\test"
            ;this.filepath := "C:\Users\dkzea\OneDrive\Desktop" . path
            this.filepath := ppath
            FileRead, Contents, %  ppath ;A_Desktop "/Test.txt"
            StringReplace, Contents, Contents, `r,, All ; makes sure only `n separates the lines
            this.aFile := {} ;this.afile := {}

            loop, parse, contents, `n
{
   temparr := strsplit(A_LoopField, ",")
   if (this.afile[temparr [1]] = "")
      this.afile[temparr [1]] := temparr[2]
   else
   {
      if this.afile[temparr [1]].count() < 1
         this.afile[temparr [1]] := [this.afile[temparr [1]], temparr[2]]
      else
         this.afile[temparr [1]].push(temparr[2])
   }
}

for k, v in this.Afile
{
    sum := 0
  if isobject(v)
    for _, value in v
      sum += value
  else
    sum := v
 ; msgbox, % "the sum of " k " is " sum 

}


return this.afile
        }
    }
           
    showfile(data := ""){
        tool.frontproject := this.frontproject
        if (data = ""){
            data := this.readfile(this.frontproject)
        }
        this.data := data
           
        ; }
        Gui,+AlwaysOnTop ;Sets the Gui as forward priority in the window hierarchy.
        Gui, +Delimiterspace
        Gui, Add, edit,, %sum%
        Gui, Add, edit,, %eachvalue%

        for k, v in this.afile {
            for k,v in k {
            ;if (v)
            sum += v
            }
                gui add, text,, % k ": " v ": " sum
        }

        Gui, Add, Button, x5 y370 w290 gSaveExit, Save and Exit
        Gui, Show

        saveexit:
        msgbox % "press ok to exit"
        return this.data
        
    
        
    }
    savetofile(){
    tool.frontproject := this.frontproject

    for k,v in this.items{
        s .= K "," v "`n"
    }

        FileAppend,  %  s , % this.ppath

        ;MsgBox, % "0: `n " s
        ;MsgBox, % "0: `n " this.ppath
        ;MsgBox, % "6: `n " this.filepath
        ;run, % this.ppath

        MsgBox, % "savetofile(): `n  saved to path `n" this.ppath

        return
    }

    total(){
            tool.frontproject := this.frontproject

            for k,v in data
        {
            MsgBox, % "4: `n " k "-" v
            eachvalue .= v
            total += v 
        }
        return
    }

}

^1::

; Create the array, initially empty:
Array := [] ; or Array := Array()

; Write to the array:
Loop, Read, %A_WinDir%\system.ini ; This loop retrieves each line from the file, one at a time.
{
    Array.Push(A_LoopReadLine) ; Append this line to the array.
}

; Read from the array:
; Loop % Array.MaxIndex()   ; More traditional approach.
for index, element in Array ; Enumeration is the recommended approach in most cases.
{

    MsgBox % "Element number " . index . " is " . element
}

; 'traditional' approach

  ; Each array must be initialized before use:
  Array := []

  Array[j] := A_LoopField
  Array[j, k] := A_LoopReadLine
  ArrayCount := 0
  Loop, Read, %A_WinDir%\system.ini
  {
      ArrayCount += 1
      Array[ArrayCount] := A_LoopReadLine
  }

  Loop % ArrayCount
  {
      element := Array[A_Index]
      MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
  }
  

;ArrayCount is left as a variable for convenience, but can be stored in the array itself with Array.Count := n or it can be removed and Array.MaxIndex() used in its place.
; If a starting index other than 1 is desired, Array.MinIndex() can also be used.
return





class fp{
    class tool{
        static val := "test"
        __new(){
        MsgBox, % "fp.tool class : `n " this.val
        return
    }
    }
}