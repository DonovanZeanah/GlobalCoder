Menu, MyMenu, Add, TestToggle&Check
checkedFlag := 0
return

TestToggle&Check:
	Menu, MyMenu, ToggleCheck, TestToggle&Check
	checkedFlag := !checkedFlag
	if (checkedFlag) {
		MsgBox, OK
	}
	else {
		MSgBox, Not OK
	}
return

#Z::Menu, MyMenu, Show