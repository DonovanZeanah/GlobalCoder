inst:=0								; "inst" stands for "instance"
coord:=100							; coord variable is used just to move the guis so that they are visible 

F1::
inst+=1										; Increment "inst" to be able to create new GUIs 
coord+=100									; Increment "coord" just so that the GUIs are visible
Gui, %inst%:New								; Create extra GUI
Gui, %inst%:Show, W100 H100 X%coord% Y%coord%		; Show the GUI 
CloseInstance(inst)	   ; Call CloseInstance function
return

CloseInstance(instnum) {				; The function is supposed to close each instance after that exact instance has existed for a certain amount of time
	fn := Func("CloseGui").Bind(instnum)
	SetTimer, % fn, -2000	        ; The timer should work after 2 seconds
	return						
}

CloseGui(instnum) {
	Gui, %instnum%:Destroy		; Close the GUI
}

Esc::ExitApp