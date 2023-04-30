

#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

Text:="|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8"
Text.="|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s"
MsgBox("Looking for `"auto`" and `"hot`"")
WinActivate("Examples.png")
WinWaitActive("Examples.png")
ok:=FindText(&X,&Y,,,,,,,Text) ; FindText will return all locations of both "auto" and "key" separately
for k, v in ok
    FindText().MouseTip(v.mx, v.my)

MsgBox("Looking for `"auto`" followed by `"hot`"")
WinActivate("Examples.png")
WinWaitActive("Examples.png")
ok:=FindText(&X,&Y,,,,,,,Text,,,1) ; FindText will return all locations of "auto" followed by "key", where "key" can be a maximum of 20 pixels away from "auto" in the x-axis and 10 pixels away in the y-axis
for k, v in ok
    FindText().MouseTip(v.mx, v.my)