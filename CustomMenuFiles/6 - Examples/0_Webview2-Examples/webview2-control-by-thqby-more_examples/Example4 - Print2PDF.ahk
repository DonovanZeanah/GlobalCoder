#Requires AutoHotkey v2.0-beta
#Include lib\WebView2.ahk

g := Gui()
g.Show('w800 h600')
wvc := WebView2.create(g.Hwnd)
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com')
MsgBox('Wait for loading to complete')
PrintToPdf(wv, A_ScriptDir "\11.pdf")


PrintToPdf(wv, path) {
	set := wv.Environment.CreatePrintSettings()
	set.Orientation := WebView2.PRINT_ORIENTATION.LANDSCAPE
	waitting := true, t := A_TickCount
	wv.PrintToPdf(A_ScriptDir '\11.pdf', set, WebView2.Handler(handler))
	while waitting && A_TickCount - t < 5000
		Sleep(20)
	if waitting
		MsgBox "printtopdf timeout"
	else {
		Run(A_ScriptDir "\11.pdf")
		MsgBox ("printtopdf complete")
	}

	handler(handlerptr, result, success) {
		waitting := false
		if (!success)
			MsgBox 'PrintToPdf fail`nerr: ' result
	}
}