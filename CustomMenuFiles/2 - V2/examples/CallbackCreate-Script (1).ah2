TextBackgroundColor := 0xFFBBBB  ; A custom color in BGR format.
TextBackgroundBrush := DllCall("CreateSolidBrush", "UInt", TextBackgroundColor)

MyGui := Gui()
Text := MyGui.Add("Text",, "Here is some text that is given`na custom background color.")

; 64-bit scripts must call SetWindowLongPtr instead of SetWindowLong:
SetWindowLong := A_PtrSize=8 ? "SetWindowLongPtr" : "SetWindowLong"

WindowProcNew := CallbackCreate(WindowProc)  ; Avoid fast-mode for subclassing.
WindowProcOld := DllCall(SetWindowLong, "Ptr", MyGui.Hwnd, "Int", -4  ; -4 is GWL_WNDPROC
    , "Ptr", WindowProcNew, "Ptr") ; Return value must be set to "Ptr" or "UPtr" vs. "Int".

MyGui.Show

WindowProc(hwnd, uMsg, wParam, lParam)
{
    Critical
    if (uMsg = 0x0138 && lParam = Text.Hwnd)  ; 0x0138 is WM_CTLCOLORSTATIC.
    {
        DllCall("SetBkColor", "Ptr", wParam, "UInt", TextBackgroundColor)
        return TextBackgroundBrush  ; Return the HBRUSH to notify the OS that we altered the HDC.
    }
    ; Otherwise (since above didn't return), pass all unhandled events to the original WindowProc.
    return DllCall("CallWindowProc", "Ptr", WindowProcOld, "Ptr", hwnd, "UInt", uMsg, "Ptr", wParam, "Ptr", lParam)
}