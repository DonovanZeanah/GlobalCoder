/*
April 24, 2018

This version of the AutoHotkey Script Reference app is under development. While 
this script currently works, it's not without its problems—particularly in the INI 
file. Specifically, the INI lookup table needs more work to correlate V1.1 terms
with V2.0 terms. On occasion, the script generates an unwieldy message box.

Since the old AutoHotkey reference script no longer works, I'm making
this one available in spite of its inadequacies.

Select a V1.1 command and use the Hotkey combination CTRL+ALT+J. Currently, a 
message box pops up displaying key information for both V1.1 and V2.0. Use buttons
to load pages. For more information see:

☻
6https://jacksautohotkeyblog.wordpress.com/2018/03/15/building-a-lookup-table-with-an-ini-file-autohotkey-reference-tip/
6
The script requires the AHKVer2Ref.INI file in the same working directory. Internet 
access required.

*/



^!j::

If (ConnectedToInternet() = 0)
  {
    MsgBox Internet not connected!
	Return
  }


 Jump := ""
 Gui +OwnDialogs
 OldClipboard := ClipboardAll
 Clipboard := ""
 SendInput ^c ; copies selected text
 ClipWait 0
 If ErrorLevel
   {
     MsgBox, No Text Selected!
     Return
   }
 IniRead, OutputVar, AHKVer2Ref.ini, Commands, %Clipboard%, Not Found
; MsgBox, The value is %OutputVar%.
 If (OutputVar = "Not Found")
    {
     MsgBox Command not found in lookup table!
	Return
	}
 
; IniRead, Clipboard, Ver2AHKRef.ini, Commands, between
 OutputVar := RegExReplace(OutputVar,"<.*?>")
 ; msgbox %OutputVar%

 command_array := StrSplit(OutputVar, "|")
;  msgbox, % command_array[2] . "*" . command_array[3] . "*" .  command_array[4] . "*" .  command_array[5]
 ; sendinput  %OutputVar%

 
 page := command_array[2]
command_array[3] := StrReplace(command_array[3],"&lt;","<")
command_array[3] := StrReplace(command_array[3],"&gt;",">")


V1Page := GetWebPage("https://autohotkey.com/docs/commands/" . page)
If command_array[4] = ""
   V2Page := GetWebPage("https://lexikos.github.io/v2/docs/commands/" . page)
Else
	If command_array[4] ~= "objects"
	{
       V2Page := GetWebPage("https://lexikos.github.io/v2/docs/" . command_array[4])
	   jumpother := RegExReplace(command_array[5],"id=""(.*?)""\.\*\?","#$1")
	}
	Else
       V2Page := GetWebPage("https://lexikos.github.io/v2/docs/commands/" . command_array[4])
; msgbox %v2page%
If command_array[2] = "Math.htm"
	{
     V1Command := RegExReplace(V1Page,".*?" . command_array[5] . "<pre.*?>(.*?)</pre.*","$1",1)
	 jump := "#" . command_array[1]
	}
Else
	{
     V1Command := RegExReplace(V1Page,".*?<pre.*?>(.*?)</pre.*","$1",1)
	}
V1Command := RegExReplace(V1Command,"<.*?>")
V1Command := StrReplace(V1Command,"&lt;","<")
V1Command := StrReplace(V1Command,"&gt;",">")

If command_array[2] != "Math.htm"
	{
	Related1 := RegExReplace(V1Page,".*?Related.*?<p.*?>(.*?)</p.*","$1",1)
	Related1 := RegExReplace(Related1,"<.*?>")
	Related1 := "`r`rRelated V1.1:`r" .  Related1
	}
Else
    {
	Related1 := ""
	}

 If V1Page ~= "<strong>Deprecated:</strong>"
    {
     If V1Page ~= "<h2 id=""function"">"
	    {
	       V1Function := RegExReplace(V1Page,".*?<h2 id=""function"">.*?<pre.*?>(.*?)</pre.*","$1",1)
	    }
	If Else V1Page ~= "Use the <a href=""#new"">new syntax</a> instead."
	    {
		   V1Function := "Use new syntax shown above."
		}
	Else
	    {
		  V3Page := GetWebPage("https://autohotkey.com/docs/commands/" . command_array[4]) 
          V1Function := RegExReplace(V3Page,".*?<pre.*?>(.*?)</pre.*","$1",1)
		}
         V1Function := RegExReplace(V1Function,"<.*?>")
   }
 Else
    {
      V1Function := "No parallel V1.1 function."
    }

 If V2Page ~= "<title>Error!</title>"
     V2Function := "No matching page"
 Else
  {
;     V2Found := "https://lexikos.github.io/v2/docs/commands/" . page
     V2Function := RegExReplace(V2Page,".*?" . command_array[5] . "<pre.*?>(.*?)</pre.*","$1",1)
     V2Function := RegExReplace(V2Function,"<.*?>")
   }
   
If (command_array[2] != "Math.htm") and (InStr(command_array[4],"objects/GuiControl") = 0)
	{
	If (InStr(command_array[4],"objects"))
	  {
	   Related2 := RegExReplace(V2Page,".*?id=""Related"".*?<p>(.*?)</p>.*","$1",1)
	   Related2 := RegExReplace(Related2,"<.*?>")
	   Related2 := "`r`rRelated V2.0:`r" .  Related2
	  }	
	Else
	  {
	   Related2 := RegExReplace(V2Page,".*?Related.*?<p.*?>(.*?)</p.*","$1",1)
	   Related2 := RegExReplace(Related2,"<.*?>")
	   Related2 := "`r`rRelated V2.0:`r" .  Related2
	  }
	}
Else
    {
	Related2 := ""
	}
   
 OnMessage(0x53, "WM_HELP")
 SetTimer, ChangeButtonNamesVar, 50
 MsgBox, 16387, % command_array[1], % V1Command 
       . "`r`rV1.1 Function (recommended, if available)`r" .  V1Function
       . Related1
       . "`r`rV2.0 Function`r" .  V2Function
       . Related2
       . "`r`r" . command_array[3] ; command_array[4]  command_array[5]  
; Run https://autohotkey.com/docs/commands/%page%
; V2Page := GetWebPage("https://lexikos.github.io/v2/docs/commands/" . page)
; MsgBox % V2Page
IfMsgBox Yes
	Run https://autohotkey.com/docs/commands/%page%%jump%
IfMsgBox No
  If command_array[4] = ""
	Run https://lexikos.github.io/v2/docs/commands/%page%%jump%
  Else
 	If command_array[4] ~= "objects"
       Run % "https://lexikos.github.io/v2/docs/" . command_array[4] . jumpother
	Else If command_array[5] ~= "Remarks"
	   Run % "https://lexikos.github.io/v2/docs/commands/" . command_array[4] . "#Remarks"	
	Else
	   Run % "https://lexikos.github.io/v2/docs/commands/" . command_array[4] . jump
Return

ChangeButtonNamesVar: 
  If WinExist(command_array[1]) = 0
    Return  ; Keep waiting.
  SetTimer, ChangeButtonNamesVar, off 
  WinActivate 
  ControlSetText, Button1, V1.1 Page, % command_array[1]
  ControlSetText, Button2, V2.0 Page, % command_array[1]
  ControlSetText, Button3, Cancel, % command_array[1]
  ControlSetText, Button4, Help, % command_array[1]
Return


GetWebPage(WebPage)
{
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")   
   whr.Open("GET", WebPage, true)
   whr.Send()
   ; Using 'true' above and the call below allows the script to remain responsive.
   whr.WaitForResponse()
   RefSource := whr.ResponseText
   Return RefSource
}


WM_HELP()
{
   MsgBox,4096, Info!, Click "V1.1 Page" to accesss V1.1 Web page.`rClick "V2.0 Page" accesss V2.0 Web page.`rClick "Cancel" to Exit.
}

ConnectedToInternet(flag=0x40) { 
Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
}
