
; https://autohotkey.com/board/topic/33506-read-ini-file-in-one-go/

ReadIni( filename := 0 )
; Read a whole .ini file and creates variables like this:
; %Section%_%Key% := %value%
{
Local s, c, p, key, k

	if not filename
		filename := SubStr(A_ScriptName, 1, -3) . "ini"

	s := Fileread(filename)

	Loop Parse, s, "`n`r", A_Space "" A_Tab
	{
		c := SubStr(A_LoopField, 1, 1)
		if (c="[")											; Section Header
			key := SubStr(A_LoopField, 2, -1)
		else if (c=";")										; Comments
			continue
		else {
			p := InStr(A_LoopField, "=")						; = position
			if p {
				k := SubStr(A_LoopField, 1, p-1)
				%key%_%k% := SubStr(A_LoopField, (p+1)<1 ? (p+1)-1 : (p+1))
			}
		}
	}
}

setUpHotkey(hk, handler, settingPaths) 
; Set-up key-bindings dynamically
; If key is bound previously, an error will be thrown
;
 ;hk := %header%_%settings%
 ;handler := function_name(){...}
 ;settingPaths := error message (e.g. settings.ini [Hotkeys]Shortcut)
{
    if (hk = "= `"`"")
      return

    Hotkey(hk, handler, "UseErrorLevel")
    if (ErrorLevel <> 0) {
        MsgBox("One or more keyboard shortcut settings have been defined incorrectly in the settings file: `n" settingPaths ". `n`nPlease read the README for instructions.", "Error", 16)
       ; Exit
    }
}