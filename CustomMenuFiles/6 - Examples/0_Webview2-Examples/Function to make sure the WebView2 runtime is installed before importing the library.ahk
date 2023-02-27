;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
; Example taken from: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=95666&start=60
;**************************************
#Requires AutoHotkey v2.0-beta
; Run this before importing the library to make sure the WebView2 runtime is installed. If not, ask the user if he wants to install it. If the runtime is not installed and you try importing the library anyway AHK will show an error.
makeSureWebView2isInstalled()
{
	if !RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}", "pv", false) && !RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}", "pv", false)
		askUserToInstallWebView2()

	askUserToInstallWebView2()
	{
		result := MsgBox("Damit dieses Programm funktioniert, muss die neue WebView2-Runtime von Microsoft auf Ihrem System installiert sein. Möchten Sie das jetzt tun?", "Paragrafen-App", "YN")
			if result == "Yes"
				Run A_ScriptDir "\lib\MicrosoftEdgeWebview2Setup.exe"

			ExitApp
	}
}