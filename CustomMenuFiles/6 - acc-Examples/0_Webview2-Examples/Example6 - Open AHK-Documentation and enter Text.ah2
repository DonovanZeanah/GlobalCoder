#Requires AutoHotkey v2.0-beta
#Include lib\WebView2.ahk

g := Gui()
g.Show(Format("w{} h{}", A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))
wv := WebView2.create(g.Hwnd)
wv.CoreWebView2.Navigate("https://lexikos.github.io/v2/docs/AutoHotkey.htm")
wv.CoreWebView2.add_NavigationCompleted(WebView2.Handler(NavigationCompletedEventHandler))

NavigationCompletedEventHandler(handler, ICoreWebView2, NavigationCompletedEventArgs) {
	script:= "document.querySelector('#menu-0 > div > div > div > div.mbr-navbar__column.mbr-navbar__menu > nav > div > ul > li:nth-child(2) > a').click()"
	wv.CoreWebView2.ExecuteScript(script, WebView2.Handler(ExecuteScriptCompletedHandler)) ;click on documentation
	
	ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
		script:= "document.querySelector('#head > div > div.h-tabs > ul > li:nth-child(3) > button').click()" 
		wv.CoreWebView2.ExecuteScript(script, WebView2.Handler(ExecuteScriptCompletedHandler2)) ;click on "search"
	}
	ExecuteScriptCompletedHandler2(handler, errorCode, resultObjectAsJson) {
		script:= "document.querySelector('#left > div.tab.search.shrinked > div.input > input[type=search]').value='testing'"
		wv.CoreWebView2.ExecuteScript(script, WebView2.Handler(ExecuteScriptCompletedHandler3)) ;set search text to "testing"
	}
	ExecuteScriptCompletedHandler3(handler, errorCode, resultObjectAsJson) {
	}
}