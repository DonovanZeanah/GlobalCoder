;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
;**************************************
#Requires AutoHotkey v2.0-beta
#Include lib\WebView2.ahk

main := Gui('+Resize')
main.OnEvent('Close', (*) => (wvc := wv := 0))
main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))

wvc := WebView2.create(main.Hwnd)
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com')
wv.AddHostObjectToScript('ahk', {str:'str from ahk',func:MsgBox})
wv.OpenDevToolsWindow()


/* ; Run the following JS code from the console of the DevToolsWindow:

obj = await window.chrome.webview.hostObjects.ahk;
obj.func('call "MsgBox" from edge\n' + (await document.title))

*/

Sleep 1000
MsgBox("Open the source code of this script and run the JS code mentioned there from the console of the DevToolsWindow. 👍")