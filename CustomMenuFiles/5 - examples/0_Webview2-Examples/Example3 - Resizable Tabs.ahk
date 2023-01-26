﻿;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
;**************************************
#Requires AutoHotkey v2.0-beta
#Include lib\WebView2.ahk

main := Gui("+Resize"), main.MarginX := main.MarginY := 0
main.OnEvent("Close", _exit_)
main.OnEvent('Size', gui_size)
tab := main.AddTab2(Format("w{} h{}", A_ScreenWidth * 0.6, A_ScreenHeight * 0.6), ['tab1'])
tab.UseTab(1), tabs := []
tabs.Push(ctl := main.AddText('x0 y25 w' (A_ScreenWidth * 0.6) ' h' (A_ScreenHeight * 0.6)))
tab.UseTab()
main.Show()
ctl.wvc := wvc := WebView2.create(ctl.Hwnd)
wv := wvc.CoreWebView2
ctl.nwr := wv.NewWindowRequested(NewWindowRequestedHandler)
wv.Navigate('https://autohotkey.com')

gui_size(GuiObj, MinMax, Width, Height) {
	if (MinMax != -1) {
		tab.Move(, , Width, Height)
		for t in tabs {
			t.move(, , Width, Height - 23)
			try t.wvc.Fill()
		}
	}
}

NewWindowRequestedHandler(handler, wv2, arg) {
	argp := WebView2.NewWindowRequestedEventArgs(arg)
	deferral := argp.GetDeferral()
	tab.Add(['tab' (i := tabs.Length + 1)])
	tab.UseTab(i), tab.Choose(i)
	main.GetClientPos(,,&w,&h)
	tabs.Push(ctl := main.AddText('x0 y25 w' w ' h' (h - 25)))
	tab.UseTab()
	ctl.wvc := WebView2.create(ctl.Hwnd, ControllerCompleted_Invoke, WebView2.Core(wv2).Environment)
	return 0
	ControllerCompleted_Invoke(wvc) {
		argp.NewWindow := wv := wvc.CoreWebView2
		ctl.nwr := wv.NewWindowRequested(NewWindowRequestedHandler)
		deferral.Complete()
	}
}

_exit_(*) {
	for t in tabs
		t.wvc := t.nwr := 0
	ExitApp()
}

