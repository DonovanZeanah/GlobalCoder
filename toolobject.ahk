#persistent
#include A_ScriptDir ." class_json.ahk





hammer := new inventory("hammer", "small-tool")
;hammer.saveStatus()
MsgBox, % "0: `n " hammer.stock 
return

esc::exitapp

f13 & 1::
hammer.starttime := hammer.time()

hammer.input()
hammer.endtime := hammer.time()
hammer.timepassed := hammer.endttime - hammer.starttime
MsgBox, % "1: `n " hammer.timepassed
return 

f13 & 2::
session := {}
name := askUser()
class := askUser()
session[name] := new inventory(name)
return 

f13 & 3::
hammer.t := new inventory.t("tooltimer")
hammer.t.setTimer("timer", 1500)
return


class inventory {
    static instances := 0    
    

    __New(name, category:="misc", price:=1, stock:=1, source:=""){
        this.instances++
        inventory.instances++

        this.timer1 := new inventory.t("2 min timer")
        this.timer1.setTimer("timer", 120000)


        MsgBox, % "2: `n " this.instances
        MsgBox, % "1: initialization of class: `n instances: " this.instances " , "inventory.instances 
        ; read from default filepath if none specified
        if (source == "") {
            this.filePath := A_ScriptDir "\" name ".json"
        } else {
            this.filePath := source
        }
        FileRead, OutputVar, % this.filePath
        ; if the file was not valid for any reason
        
    ;this interferes and the else is never ran
        ; if (JSON.test(OutputVar)) {
        ;     this.name := name
        ;     this.category := category
        ;     this.price := price
        ;     this.stock := stock
        ;     this.source := source
        ; } else {



            ; parse the json file


            ; obj := JSON.parse(OutputVar)
            ; ; assign object to this properties
            ; this.name := name
            ; this.category := obj.category
            ; this.price := obj.price
            ; this.stock := obj.stock
            ; this.source := obj.source
             ; parse the json file
            obj := JSON.parse(OutputVar)
            ; merge all properties in the saved file to this memory object
            return this := obj
        
        }
        ;return this
    }
    
    run(){
        run, % this.filepath
        }

    
    addItems(param_x := 0) {
        this.stock += param_x
        }

    
    input(){
        inputbox, inp
        this.stock += inp
        print(this.stock)
        }

    mytimer(id=1, reset=0){
        ;this.timer := (switch := !switch) ?
        static switch := !switch
        MsgBox, % "0: `n " switch
        ;(expression) ? val1 : val2
        if (switch = 1){
            
        }
        }
    boundfunctimer(){

        }

    sincelasttimer(id=1, reset=0){
        global t
        static arr:=array()
        if (reset=1)
        {
           ((id=0) ? arr:=[] : (arr[id, 0]:=arr[id, 1]:="", arr[id, 2]:=0))
           return
        }
        arr[id, 2]:=!arr[id, 2]
        arr[id, arr[id, 2]]:=A_TickCount  
        ;msgbox % "abs var:" abs
        return global abs(arr[id,1]-arr[id,0])
        }
    saveStatus() {
        string := JSON.stringify(this)
        FileDelete, % this.filePath
        FileAppend, % string, % this.filePath
        }

    Exiting(){
        MsgBox, exiting method. inventory object is cleaning up prior to exiting...
        this.savestatus()
        run, % this.ppath
        }

    __delete(){
        MsgBox, __delete method. inventory object is cleaning up prior to exiting...
        this.savestatus()
        run, % this.filepath
        exitapp
        }
    

; Nested class (timer)
class t {
	__new(name){
		this.name := name
	}
	setTimer(method, period){
		local
		fn := this[method].bind(this)	; To delete the timer you need to save this reference.
		settimer % fn, % period
	}
	timer(){
		msgbox % this.name
	}
}





askuser(){
    inputbox, name
    ;inputbox, class

    %name% := new inventory(name)
    return 
}

OnExit(ObjBindMethod(inventory, "Exiting"))



timer(id=1, reset=0){
   global t
   static arr:=array()
   if (reset=1)
   {
      ((id=0) ? arr:=[] : (arr[id, 0]:=arr[id, 1]:="", arr[id, 2]:=0))
      return
   }
   arr[id, 2]:=!arr[id, 2]
   arr[id, arr[id, 2]]:=A_TickCount  
   ;msgbox % "abs var:" abs
   return global abs(arr[id,1]-arr[id,0])
}

;f13 & 2::
;ToolTip, % ggg.="1 :: " timeSinceLastCall(1)/1000 * wps  "¢`n"
;return
;f14 & 3::ToolTip, % ggg.="2 :: " timeSinceLastCall(2) "`n"
;f14 & 4::ggg:="", timeSinceLastCall(0,1) ; reset everything