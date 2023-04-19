; Press AppsKey and Alt in any order, then slash (/).
#HotIf GetKeyState("AppsKey", "P")
Alt & /::MsgBox "Hotkey activated."

; If the keys are swapped, Alt must be pressed first (use one at a time):
#HotIf GetKeyState("Alt", "P")
AppsKey & /::MsgBox "Hotkey activated."

; [ & ] & \::
#HotIf GetKeyState("[") && GetKeyState("]")
\::MsgBox