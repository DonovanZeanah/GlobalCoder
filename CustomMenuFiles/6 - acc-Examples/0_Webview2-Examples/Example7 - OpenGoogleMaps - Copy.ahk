;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
; Example taken from: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=95666&start=60
;**************************************
#Requires AutoHotkey v2.0-beta
#Include lib/WebView2.ahk

main := Gui("+Resize")
main.Show("w800 h600")
wv := WebView2.create(main.Hwnd)
;wv.CoreWebView2.Navigate("https://localhost:44303/")
wv.CoreWebView2.Navigate("https://localhost:44382/?k=#sample-projects-machine-learning")
;wv.CoreWebView2.Navigate("file://D:\API Example.html")
return