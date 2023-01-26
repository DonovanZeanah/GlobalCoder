#Requires AutoHotkey v2.0- 
#include lib/webview2.ah2
; #warn all, off

 main := Gui()
 p1h := main.Add("text","w400 h400")
 p1h.add()
 main.Show("w1200 h1350")

 wv := webview2.create(p1h.hwnd)
 wv.corewebview2.navigate("https://maps.google.com")
wv.CoreWebView2.add_NavigationCompleted(WebView2.Handler(navigationcompletedeventhandler))


 return 

navigationcompletedeventhandler(handler, e)