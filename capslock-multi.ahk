CapsLockMenu(){
Menu, test, Add, 1
Menu, test, Add, 2
Menu, test, Add, 3
	GoSub ShowMenu
	return
}

$CapsLock::
    KeyWait CapsLock, T0.25
        if ErrorLevel
        {
            CapsLockMenu()
        }
        else
        {
            KeyWait CapsLock, D T0.25
            if ErrorLevel
            {
            	MsgBox, % "damn"
               /* 
               Send {Ctrl down}a{Ctrl up}
                Sleep 100
                Send {Ctrl down}{Alt down}1{Ctrl up}{Alt up}
                Sleep 100
                Send {Ctrl down}b{Ctrl up}
                Sleep 100
                Send {Ctrl down}u{Ctrl up}
                Sleep 100
                Send {Ctrl down}i{Ctrl up}
                */
            }
            else
            {
            	            	MsgBox, % "dang"

                /*
                Send {Ctrl down}a{Ctrl up}
                Sleep 100
                Send {Ctrl down}{Alt down}2{Ctrl up}{Alt up}
                Sleep 100
                Send {Ctrl down}b{Ctrl up}
                Sleep 100
                Send {Ctrl down}u{Ctrl up}
                Sleep 100
                Send {Ctrl down}i{Ctrl up}
                */
            }
        }
    KeyWait CapsLock
return




	

ShowMenu:

		
;F1::
Menu, test, Show
;F2::
;Try Gosub, %item%

1:
2:
3:
switch A_ThisLabel
{
case "1":  msgbox, % "1"
case "2":  msgbox, % "2"
case "3":  function()
}
Return

function(){
	static myedit

	MsgBox, % "function"
	Gui, add, edit, vmyedit w200 h50,
		Gui, add, button, gmybutton w200 h50,

	gui,show
	KeyWait, q
	;KeyWait, esc
	;gui Submit
	;msgbox, % myedit 
	return myedit
}
;Send % item := A_ThisLabel
mybutton:
msgbox, % myedit 

gui submit
msgbox, % myedit 
return


	Menu SM, Show
	return