#Requires Autohotkey v2.0-
#SingleInstance Force
;*******************************************************************************************************************
; Want a clear path for learning AutoHotkey? Take a look at our AutoHotkey courses.                                *
; They're structured in a way to make learning AHK EASY. You can learn more  here: https://the-Automator.com/Learn *
;*******************************************************************************************************************

:*:r.ahk::
{
	oldClip := ClipboardAll()
	A_Clipboard := ""

	A_Clipboard := "
	(
	This thread will be dedicated to creating AutoHotkey scripts.  For all my requests please use the following preferences
	•	When assigning a value to a variable use ':='   I.e. 'myVar:=”blah”'
	•	Camel case all created variables and make sure they are at between 5 and 25 characters long.  
	•	Camel case all functions and classes.  The names should be long and clearly explain what they do.
	•	Do not use external libraries or dependencies.
	•	Every function you create should be implemented.
	•	Function and class definitions should be at the end of the script.
	•	Annotate all provided code with inline comments explaining what they do to a beginner programmer.
	•	When possible, use AutoHotkey functions over AutoHotkey commands.
	•	When possible, Force an expression:  I.e. use 'msgbox % “hi ” var' instead of 'msgbox hi %var%'
	•	I prefer less-complicated scripts, that might be longer, over denser, more advanced, solutions.
	•	Use One True Brace formatting for Functions, Classes, loops, and If statements.
	•	Write the code for the current authotkey v1 language
	Add at the beginning of each script
	•	#Requires Autohotkey v1.1.36+
	•	#SingleInstance, Force ;Limit one running version of this script
	•	#NoEnv ;prevents empty variables from being looked up as potential environment variables
	•	DetectHiddenWindows, On ;ensure can find hidden windows
	•	ListLines On ;on helps debug a script-this is already on by default
	•	SendMode, Input  ; Recommended for new scripts due to its superior speed and reliability.
	•	SetBatchLines, -1 ;run at maximum CPU utilization
	•	SetWorkingDir, % A_ScriptDir ;Set the working directory to the scripts directory
	•	SetTitleMatchMode 2 ;Sets matching behavior of the WinTitle parameter in commands such as WinWait-  2 is match anywhere
	•	Always use the PCRE regex engine for regular expressions
	The following hotkeys should be added after the AutoExecute section of the script a
	•	^+e::Edit ;Control+Shift+E to Edit the current script
	•	^+Escape::Exitapp ;Control Shift + Escape will Exit the app
	•	^+r::Reload ;Reload the current script
	)"



	ClipWait 0
	Send '^v'
	Sleep 100
	A_Clipboard := oldClip
}
