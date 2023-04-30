#include ..\FindText.ahk
SetTitleMatchMode(2)
WinActivate("Examples.png")
WinWaitActive("Examples.png")

Text:="|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8" ; Image of the "auto" part in "autohotkey.com". Id of the image is "auto" (between < and > characters).
Text.="|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s" ; Append an image of the "hot" part in "autohotkey.com" to the Text variable (note the ".=" operator which appends, when previously we used ":=" to set). Id of the image is "hot".
; The last two lines are the same as Text:="|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s"

WinGetPos(&pX, &pY, &pW, &pH, "Examples.png") ; Get the Paint application location and size.

if !(ok := FindText(&X, &Y, pX, pY, pX+pW, pY+pH, 0.000001,, Text)) { ; Call FindText to look for either "auto" or "hot" images. X and Y will be set to X and Y coordinates for the first found result. The search range will be only the Paint application. Setting one or both of the error margins to a small non-zero value will avoid the second search with 5% error margins. Results will be stored in the "ok" variable. If "ok" doesn't contain anything ("!" is the "not" operator) then exit, otherwise continue on.
    MsgBox("The image/Text was not found. Is everything set up correctly and the image is visible in Paint?") ; It seems "ok" was left empty, so nothing was found.
    ExitApp
}
; Anything after this part will happen only if any of the Text was found (either "hot" or "auto" image).

for key, value in ok { ; Loop over all the search results in "ok". "key" will be the nth result, and "value" will contain the result itself.
    FindText().MouseTip(value.mx, value.my) ; Show a blinking red box at the center of the result.
    MsgBox("Result number " key " is located at X" value.x " Y" value.y " and it has a width of " value.w " and a height of " value.h ". Additionally it has a comment text of `"" value.id "`"") ; value.x is equivalent to ok[k].x, value.id is equivalent to ok[k].id, and so on.
    if (value.id == "auto")
        MsgBox("Here we found the `"auto`" image.")
    WinActivate("Examples.png")
    WinWaitActive("Examples.png")
}