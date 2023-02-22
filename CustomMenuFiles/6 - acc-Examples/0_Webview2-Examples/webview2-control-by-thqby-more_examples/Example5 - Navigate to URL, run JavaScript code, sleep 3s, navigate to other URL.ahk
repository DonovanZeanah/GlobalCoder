; Example taken from: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=95666&start=60

#Include 'lib\WebView2.ahk'

g := Gui()
g.Show('w600 h500')
wv := WebView2.create(g.Hwnd)
wv.CoreWebView2.add_NavigationCompleted(WebView2.Handler(NavigationCompletedEventHandler))
wv.CoreWebView2.Navigate('https://www.gesetze-im-internet.de/bgb/__2.html')

NavigationCompletedEventHandler(handler, ICoreWebView2, NavigationCompletedEventArgs) {
	; WebView2.Core(ICoreWebView2) is same as wv.CoreWebView2
	wv.CoreWebView2.ExecuteScript('document.body.style.backgroundColor = "green"', 0)
	; wv.CoreWebView2.ExecuteScript('1+2+3+4', WebView2.Handler(ExecuteScriptCompletedHandler))

	ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
		; MsgBox 'errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson)
	}
}

Sleep 3000

wv.CoreWebView2.Navigate('https://www.dejure.org')