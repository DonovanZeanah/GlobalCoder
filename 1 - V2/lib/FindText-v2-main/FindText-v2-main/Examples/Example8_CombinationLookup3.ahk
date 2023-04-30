#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

Text:="|<A>*162$7.472VF4WzkMA"
Text.="|<A>*165$8.61UI92NWTYD1U"
Text.="|<s>**50$5.Tb3klz"
Text.="|<s>**50$5.Tb3klx"
Text.="|<a>**50$6.SH3TnnTU"
Text.="|<a>*152$5.x4/slz"
; Text now contains two fonts of "A", "s" and "a"
ok:=FindText(&X, &Y, , , , , 0.1, 0.1, Text,, 1,["Asa"]) ; FindText will find all instances of the word "Asa" using the provided character set
for k, v in ok
    FindText().MouseTip(v.mx, v.my)