
;----------------------------------------------| FUNCTIONS |---------------------------------------------;
; ---- Handlers ----

; Case not known; try to open the file
Handler_Default2(PATH)
{
	Handler_LaunchProgram(PATH)
}

; contents of .txt should be copied to clipboard and pasted. This is fast.
Handler_txt2(PATH)
{
	FileRead, Clipboard, %PATH%
	
	; Gets amount of words (spaces) in file just pasted
	GetWordCount()						
	; Sleep, 50
	
	; Adds Info to file
	AddAmountFile(A_ThisMenuItem, TotalWords)
	; Sleep, 50
	
	; Paste content of clipboard
	Send, ^v
}

; If program is executable, simply launch it
Handler_LaunchProgram2(FilePath)
{
	run, %FilePath%
}

; .rtf files should be opened with a ComObject, that silently opens the file and copies the formatted text. Then paste
Handler_COM2(FilePath)
{
	; Clears clipboard. Syntax looks werid, but it is right.
	Clipboard :=                     
	; Sleep, 200
	
	try{
		; Load contents of file into memory
		oDoc := ComObjGet(FilePath)
		; Sleep, 250
		
		; Copy contents of file into clipboard
		oDoc.Range.FormattedText.Copy
		; Sleep, 250
		
		; Wait up to two seconds for content to appear on the clipboard
		ClipWait ;, 2
		if ErrorLevel
		{
			MsgBox, The attempt to copy text onto the clipboard failed.
			return
		}
		
		; File is no longer needed, close it
		oDoc.Close(0)
		; Sleep, 250
		
		; Gets amount of words (spaces) in file just pasted
		GetWordCount()						
		; Sleep, 50
		
		; Add amount words to the AmountFile
		AddAmountFile(A_ThisMenuItem, TotalWords)
		; Sleep, 50
		
		; Then Paste 
		Send, ^v
		; Sleep, 50
	}
	catch ex{

	}
}


; Attemps to start all other files in the specified path.
RunOtherScripts2(PATH)
{
	Loop, Files, %PATH%\* , F
	{
		;~ MsgBox, % "Including:`n" A_LoopFilePath
		run, %A_LoopFilePath%
	}
}
