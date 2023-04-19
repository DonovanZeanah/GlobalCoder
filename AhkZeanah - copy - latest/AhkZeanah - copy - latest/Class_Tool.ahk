#Requires AutoHotkey v1.1.34.03
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
  ;  #include P:\app\repos-github\biga.ahk\biga.ahk

;powerdriver := new tool("powerdriver","craftsman", "powerdriver", 1 , 100.00, 1, "yokota exchange", 09.10.2022)
;powerdriver.addItems(100)

;msgbox % powerdriver.stock

screwdriver := new tool("screwdriver","tool")
screwdriver.givevalues("screws", 100)


for k,v in screwdriver.item 
{
    s .= v "`n"
msgbox % "[looping] `n" k ":" v
}

screwdriver.givevalues("screws", 105)

msgbox, % s "`n this was s"

screwdriver.savetofile(s,this.ppath)
screwdriver.showfile()
thisvar := screwdriver.readfile()
;screwdriver.check()


msgbox % thisvar












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



    __New(Item,type,ppath := "", unit := "",price:= "",stock:= 0,source:= ""){
        
        tool.tooltotal++
        this.items := items := {}
        this.item := item := {}
        this.ppath := ppath
        this.unit := unit
        this.price := price
        this.stock := stock 
        this.source := source

        if (ppath){
            this.ppath := A_Desktop . "\" . ppath . ".txt"
            this.frontproject := this.ppath
        } else {
            this.ppath :=  A_Desktop . "\project.txt"
            this.frontproject := this.ppath
        }

        tool.frontproject := this.frontproject
        

        if !FileExist(this.ppath){
            FileAppend, % "`n" item "," DateTime,  this.ppath
            ;MsgBox, % "5: `n didnt exist, created: " this.ppath "`n appended: " item 
        }
        ;MsgBox, % "0: `n  already existed"
        if (item = "screwdriver"){
            this.timetounscrew := 7.5
        } else if(item = "powerdriver"){
            this.timeToUnscrew := 5 
            ;MsgBox, % "0: `n passed in a powerdriver: " this.timetoUnscrew
        }

        ;static price :=
        ;return timeToUnscrew
    }
    addItems(param_x := 0) {
        this.stock += param_x
    }
    check(){
        MsgBox, % "10: `n tool.frontproject: " tool.frontproject . "10: `n this.frontproject: " this.frontproject . "10: `n frontproject: " frontproject . "2: `n " this.timeToUnscrew " seconds"
        return 
    }

    givevalues(item, x := 0){
        this.item := item
       if (this.item.haskey(item) ){

       ;if (!IsObject(this.item)) {
        this.items.push(item) := {}
        this.item := item := {"name": item, "quantity": x}
        msgbox % this.item.quantity " " item.name "'s added!" this.item.name

        for k,v in this.item 
        msgbox % k ":" v
        return this.item
        }
        if (!this.item.HasKey(item))
        this.item := item := {}


        if (this.item.quantity != "")
         {
        msgbox, % this.item.quantity " " this.item.name "'s `n exist, so add to it"

           this.item.quantity +=  x
           ; this.item.quantity := this.item + x 
            msgbox, % this.item.quantity "`n object existed"
            return this.item ;.quantity
        }

        tool.frontproject := this.frontproject
        ;msgbox % item
      
        item.quantity := x 
        msgbox, % item.quantity "`n object didnt exist yet"

        return this.item
    }

    
    readfile(path := ""){
        tool.frontproject := this.frontproject

        if this.ppath != "" or fileexist(A_Desktop . this.ppath)
        {
            MsgBox, % "9: `n " this.frontproject
          MsgBox, % "0: `n " this.ppath
            this.frontproject := "c:\test"
            ;this.filepath := "C:\Users\dkzea\OneDrive\Desktop" . path
            this.filepath := path
            FileRead, Contents, % "C:\Users\dkzea\OneDrive\Desktop" . path ;A_Desktop "/Test.txt"
            StringReplace, Contents, Contents, `r,, All ; makes sure only `n separates the lines
            aFile := {}

            loop, parse, data, `n
        {
           temparr := strsplit(A_LoopField, ",")
           if (afile[temparr [1]] = "")
              afile[temparr [1]] := temparr[2]
           else
           {
              if afile[temparr [1]].count() < 1
                 afile[temparr [1]] := [afile[temparr [1]], temparr[2]]
              else
                 afile[temparr [1]].push(temparr[2])
           }
        }

        for k, v in Afile
        {
          if isobject(v)
            for _, value in v
              sum += value
          else
            sum := v
          msgbox, % "the sum of " k " is " sum
        }
    }
    return
}


    showfile(data := "item"){
        tool.frontproject := this.frontproject

        for k,v in %data%
        {
        MsgBox, % "4: `n " k "-" v
        eachvalue .= v
        total += v 
        }
        Gui,+AlwaysOnTop ;Sets the Gui as forward priority in the window hierarchy.
        Gui, Color, 000000 ;Sets the Gui color to black
        Gui, +Delimiterspace
        Gui, Add, DropDownList,, %total%
        Gui, Add, DropDownList,, %eachvalue%
        Gui, Add, Button, x5 y370 w290 gSaveExit, Save and Exit
        Gui, Show

        saveexit:
        msgbox % "press ok to exit"

        return
        return total
        }
    savetofile(data,ppath := ""){
        msgbox % "saving to file is happening"
        tool.frontproject := this.frontproject
        FileAppend,  % "`n" data . "," . DateTime  , % this.ppath
        FileAppend,  % "`n" data . "," . DateTime  , % this.filepath

        MsgBox, % "0: `n " data
        MsgBox, % "0: `n " this.ppath
        MsgBox, % "6: `n " this.filepath
      

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