;#Requires AutoHotkey v2.0-beta.7
#warn all,off
#ErrorStdOut
;#Requires AutoHotkey v2.0-beta
esc:: ExitApp

^q:: {
   ; Set the name of the placeholder Model
   modelName := "MyModel"

   ; Define the template controller content
   controllerTemplate := (
      " test "
      )
      .Replace("s ", modelName)

; Set the output file name
outputFileName := " TemplateController.cs "

; Create and write the controller template to the output file
FileOpen(outputFileName, " w ").Write(controllerTemplate)
MsgBox(" Template controller file has been generated as " . outputFileName)
}

^g::
{
   g := gui2() ; (," Test Gui ")
   OnMessage(0x200,g.msg1) ; WM_MOUSEMOVE
   OnMessage(0x201,g) ; WM_LBUTTONDOWN
   OnMessage(0x202,g) ; WM_LBUTTONUP
   g.OnEvent(" close "," gui_close ")
   g.Add(" Edit "," vMyEdit1 w200 r4 ").OnCommand(0x300," some_event ") ; same as " Change " for OnEvent ; EN_CHANGE
   g.Add(" Edit "," vMyEdit2 ReadOnly w200 r2 ")
   g.Add(" Edit "," vMyEdit3 ReadOnly w200 r2 ")
   g.Add(" Edit "," vMyEdit4 ReadOnly w200 h100 ")

   g.Show()
}
numpad0::
{

	mygui := gui()
	fakelink := mygui.add(" text ", " ", " click2launch ")
	fakelink.setfont(" underline cblue ")
	fakelink.onevent(" click ", launchgoogle)

	mygui.add(" hotkey ", " vChosenHotkey ", " enter ")

		mygui.add(" link ",, 'click <a href=" www.google.com ">here </a> to launch google.')
		mygui.show()




}
numpad1::
{
	guiobj := gui()
	guiobj.setfont(" s20 "," Times New Roman ")
	guiobj.add(" text ",," some text ")
	guiobj.show(" autosize ")
}
F2:: {

   ;txt := {}
    ;txt := g
	MsgBox(txt, testtitle)
    txt .= " test property: " . g.test2 . "`n "
    txt .= " super class name: " . g.test3
    Msgbox(txt)
}


Global g

/**
 * @param a --- {Array} 
   *  @---{    
 * @@=> return => {Integer} 
 */
fn(a*) {
  /** @type {Map} */
  d := Map()
  /**
   * @var {Map} e
   * @var {Object} f
   */
  e := Map(), f := {}
  /** @type {(a,b)=>Integer} */
  cb := (a, b) => a + b
  /** @type {ComObject<Excel.Sheet.12,Workbook>} */
  wb := ComObject('Excel.Sheet.12')
  return a[1] + a[2]
}

class abc {
  /** @prop {Map} p */
  p := dosomethingandreturnmap()
}

class gui2 extends gui {
   /**
 * @param 
 * @return {Integer}
 */

    test2 := " property1Value "
    test3 := super.__Class ; super class name (Gui)
    
    __New(opt:=" ", title:=" ") {
        super.__New(opt, title, this)  ; Specify the event sink for the GUI obj as this subclass.
                                          ; your calling the __new() method of the gui() class
                                          ; and telling  it to use this class (the 'super's' extended class) 
                                          ; as the event sink for the gui object.
                                      
        this.msg1 := ObjBindMethod(this," msg1 ")   ; Required when func obj is needed and using a user class.
                                                      ; makes this.msg1 a func obj that can be used with OnMessage()
                                                      ; and can be passed as a parameter to other functions.
      MsgBox(this.msg1)

    }
    test() {
        return " method added "
    }
    some_event(ctl) {                   ; the " event sink " for WM_COMMAND notifications, used with Gui " event sink " (EventObj)
        this[" MyEdit4 "].Value := " Title: " ctl.Name "`r`n`r`n " ctl.value 
    }
    gui_close(*) {                      ; embedded method for close event; used with Gui " event sink "
        Msgbox " Now closing "
        ExitApp
    }
    msg(wParam, lParam, msg, hwnd) {    ; embedded OnMessage method, used with Gui " event sink "
   this[" MyEdit2 "].Value := " Mouse Move / wParam: " wParam "`r`n lParam: " lParam " / hwnd: " hwnd
    }
    Call(wParam, lParam, msg, hwnd) {   ; Custom user function when func obj is needed.
        state := (wParam) ? " Down " : " Up "
        this[" MyEdit3 "].Value := " LB " state " / wParam: " wParam "`r`nlParam: " lParam " / hwnd: " hwnd
    }
}

class editor{

	__new(){

	}
	gotosettings() {
		
	}
	gotokeyboardshortcuts(){


	}
	activatemenu(){
		
	}
	activatetoolbar(){
		
	}
	openfile(){
	}
	saveas(){
	}
	
	
}


/* ; ^t - test concepts
^t::
   {
      arr := [" first value ", 250, variable]

   mappy := map(
      " Key ", " value ",
      " hammer ", " nail ",
      " pen ", " paper "
      )

   arr.Length
   arr.push()
   arr.pop()

   mappy.caseSense
   mappy.count
   mappy.has()

   obj := { prop1: "value", prop2: 100 }


   obj := {
      meth: msgbox.bind()
   }

   obj.meth()

   funk() {
      name := "hammer",
         price := 19.00
      subject := "metalworking"
      return { name: name, price: price, subject: subject }
   }

   obj := funk()

   ;msgbox('help, ima' obj.name "i cost " obj.price "and used for " obj.subject )

   ;arrow func
   ;settimer(() => msgbox("hi"), -1000)

   ;bind method
   ;settimer(msgbox.bind("hi"), -1000)

   ;both
   ;settimer(boundfunky.bind("joe"), -1000)

   boundfunky(text) {
      msgbox(text)
   }
   ;
   ;----
   ;Msgbox("hi")

   ;; creating a function object "that already has parameters set".
   ;-----------------------------------------------------------

   funky(text) {
      msgbox(text)
   }

   ;this is a type of object thats called a {bound function}
   shoutyall := funky.bind("hey, yall")
   shoutyall()
}
* /


launchgoogle(*) {
   run("www.google.com")
}