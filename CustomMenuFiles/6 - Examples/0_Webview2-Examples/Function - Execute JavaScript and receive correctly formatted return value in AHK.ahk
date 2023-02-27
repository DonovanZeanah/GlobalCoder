; Execute JavaScript in the WebView and get correctly formatted return value
;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
; Example taken from: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=95666&start=60
;**************************************
#Requires AutoHotkey v2.0-beta
#Include <JsON> ; Needs the jxon-library to interpret JSON correctly.

static response_handler := WebView2.Handler(myhandler)
wb.ExecuteScript('document.URL', response_handler) ; Example JavaScript-command: document.URL (the currently opened URL)
myHandler(response_handler, errorCode, result){
	result_json := strget(result)
	url := jxon_load(&result_json)
}