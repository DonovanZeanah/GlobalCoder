#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

Text:="|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8" ; Image of the "auto" part in "autohotkey.com". Id of the image is "auto" (between < and > characters).
ok := FindText(&outX, &outY,,,,,,,Text) ; Call FindText to look for the "auto" image. outX and outY will be set to X and Y coordinates for the first found result. Search range coordinates, err1 and err0 are left empty to use the default values (searching the whole screen, and looking for an exact match). Results will be stored in the "ok" variable.
if ok.Length { ; Check if "ok" is not set to 0
    MsgBox(ok.Length " results were found.") ; ok.Length should return how many search results were found.
    MsgBox("The image (Text) was first found at coordinates X: " outX " Y: " outY) ; Display outX and outY
    MsgBox("The first found image is located at X" ok[1].x " Y" ok[1].y ". It has a width of " ok[1].w " and a height of " ok[1].h ". Additionally it has a id of `"" ok[1].id "`"")
    if ok.Length > 1 ; ok[1] contains the first result, ok[2] contains the second result, etc... Check if ok[2] exists and if yes, display some of its contents.
        MsgBox("The second found image is located at X" ok[2].x " Y" ok[2].y " and it has a width of " ok[2].w " and a height of " ok[2].h ". Additionally it has a comment text of `"" ok[2].id "`"")
} else {
    MsgBox("The image/Text was not found. Is everything set up correctly and the image is visible in Paint?") ; It seems "ok" was left empty, so nothing was found.
}