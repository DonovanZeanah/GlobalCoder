#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

if (ok := FindText(&outX, &outY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0.05, 0.05, "|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8")) { ; Call FindText to look for the "auto" image. outX and outY will be set to X and Y coordinates for the first found result. Search ranges top left corner is (0;0) and bottom right corner (A_ScreenWidth; A_ScreenHeight), which should search the whole screen, but might not work properly if using multiple monitors. Error margins are set to 5% for both "1"s and "0"s. Results will be stored in the "ok" variable. If "ok" contains results, then the "if" condition will be successful.
    for k, v in ok { ; Loop over all the search results in "ok". "k" will be the nth result, and "v" will contain the result itself.
        MsgBox("Result number " k " is located at X" v.x " Y" v.y " and it has a width of " v.w " and a height of " v.h ". Additionally it has a comment text of `"" v.id "`"") ; v.x is equivalent to ok[k].x, v.id is equivalent to ok[k].id, and so on.
    }
} else {
    MsgBox("The image/Text was not found. Is everything set up correctly and the image is visible in Paint?") ; It seems "ok" was left empty, so nothing was found.
}