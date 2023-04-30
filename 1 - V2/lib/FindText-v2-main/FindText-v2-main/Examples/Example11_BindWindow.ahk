#include ..\FindText.ahk

SetTitleMatchMode(2)
FindText().BindWindow(WinExist("Paint ahk_class MSPaintApp")) ; bind FindText to Paint
Text:="|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s"
if FindText(&X, &Y, 72-150000, 228-150000, 72+150000, 228+150000, 0, 0, Text).Length ; Paint can be obscured by another window, but FindText still finds Text
    FindText().MouseTip(X, Y)
FindText().BindWindow(0) ; unbind Paint from FindText
