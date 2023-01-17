#Requires AutoHotkey v2.0-beta.3

#HotIf WinActive("ahk_class CabinetWClass")
    && WinExist("PopupHost ahk_class Xaml_WindowedPopupClass")

e::ForEachSelectedFile(item => item.InvokeVerb("edit"))
d::ForEachSelectedFile(item => item.InvokeVerb("delete"))
+d::Send("{Esc}"), WinWaitClose(,, 1) && Send("+{Delete}")

ForEachSelectedFile(action) {
    if WinExist("PopupHost ahk_class Xaml_WindowedPopupClass")
        Send "{Esc}"
    hwnd := WinExist("A")
    for window in ComObject("Shell.Application").Windows
        if window.HWND = hwnd
            for item in window.Document.SelectedItems
                action(item)
}