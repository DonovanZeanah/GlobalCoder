#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
; #Warn  ; Enable warnings to assist with detecting common errors.
#Requires AutoHotkey v1.1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

String:= "NewTitle [, WinTitle, WinText, ExcludeTitle, ExcludeText]"


Ahk_Xml:={}

OutputText :=""
loop, Files, %A_ScriptDir%\AutoHotkey_L-Docs-2\docs\objects\*
{

	FileRead, ContentBuffer, %A_LoopFileFullPath%
	
	;Used for testing on a specific file
	if !InStr(A_LoopFileFullPath, "StrPut"){
		;~ Continue
	}
	
	Content := ContentBuffer
	Loop, 
	{
		h1 := RegExReplace(Content, "sS).*?<h1>([^>]*?)</h1>.*", "$1", RegexCount)
		;~ h1 := RegExReplace(Content, "sS).*?</h\d>.*?<p>(.*?)</p>[^>]*?<pre class=""[^>]*Syntax"">.*", "$1", RegexCount)
		h1 := RegexCount>0 ? h1 : ""
		Description := RegExReplace(Content, "sS).*?</h\d[^>]*>.*?<p>(.*?)</p>[^>]*?<pre class=""[^>]*Syntax"">.*", "$1", RegexCount)
		Description := RegExReplace(Description, "sS).*<p>(.*?)$", "$1")
		Description := RegExReplace(Description, "<a[^>]*>", "")
		Description := RegExReplace(Description, "</a>", "")
		Description := RegexCount>0 ? Description : ""
		;~ Description := RegExReplace(Description, "<[^>]*>", "")
		Syntax := RegExReplace(Content, "sS).*?</h\d>.*?<pre class=""[^>]*Syntax"">(.*?)</pre>.*", "$1", RegexCount)
		
		Syntax := RegExReplace(Syntax, "sS)<span class=""optional"">(.*?)</span>", "[$1]")
		Syntax := RegexCount>0 ? Syntax : ""
		
		SyntaxText := RegExReplace(Syntax, "[\[\]]", "", RegexCount)
		SyntaxText := Syntax
		aSyntax := StrSplit(SyntaxText, "`n", "`r")
		
		OutputText .="Command: " h1 "`nDescription: " Description "`n"
		ParametersText := RegExReplace(Content, "sS).*?<h\d id=""Parameters"">Parameters</h\d>.*?<dl>(.*)</dl>.*", "$1", RegexCount)
		ParametersText := RegexCount>0 ? ParametersText : ""
		
		;~ OutputText .= "ParametersText: " ParametersText "`n"
		Parameter_old:=""
		aParameters:={}
		loop, {
			ParametersText_Buffer := ParametersText
			Parameter := RegExReplace(ParametersText_Buffer, "sS)^.*?<dt[^>]*>([^<]*?)</dt>.*", "$1", ParameterCount)
			Parameter := RegExReplace(Parameter, "\n", "")
			if (Parameter_old != Parameter){
				Parameter := ParameterCount>0 ? Parameter : ""
				ParameterChoices:=""
				OutputText .= Parameter!="" ? "Parameter: " Parameter "`n" : ""
			}
			if (Parameter=""){
				Break
			}
			
			ParameterText := RegExReplace(ParametersText, "sS)^.*?<dt[^>]*>([^>]*?)</dt>(.*?)</dd>(.*)", "$2")
			; Remove the note element
			
			Loop, Parse, ParameterText, `n, `r
			{
				ParameterValue := RegExReplace(A_LoopField, "sS)^\s*(<p[^>]*>|)<strong>(.*?):?</strong>.*", "$2", ParameterValueCount)
				if (ParameterValue!="note"){
					ParameterChoices .= ParameterValueCount>0 ? ParameterChoices="" ? "" ParameterValue : "|" ParameterValue : ""
				}
			}
			OutputText .= ParameterChoices="" ? "" : "[" Parameter "]`: " ParameterChoices "`n"
			aParameters[RegExReplace(Parameter, "\s", "")] := ParameterChoices="" ? "" : ParameterChoices 
			ParametersText := RegExReplace(ParametersText, "sS)^.*?<dt[^>]*>(.*?)</dt>(.*?)</dd>(.*)", "$3")
			Parameter_old := Parameter
		}
		
		loop, % aSyntax.Length()
		{
			if (aSyntax[A_Index]=""){
				Continue
			}
			
			Type := "Command"
			Function := RegExReplace(aSyntax[A_Index], "sS)<span class=""func"">(.*?)</span>.*", "$1", RegexCount)
			Function := RegexCount>0 ? Function : ""
			Function := RegExReplace(Function, "sS)^\s*\w+\s*?:=\s(.*)", "$1")
			SyntaxParameters := RegExReplace(aSyntax[A_Index], "sS)<span class=""func"">.*?</span>(.*)", "$1", RegexCount)
			SyntaxParameters := RegexCount>0 ? SyntaxParameters : ""
			SyntaxParameters := RegExReplace(SyntaxParameters, "sS)^\s*\w+\s*?:=\s(.*)", "$1")
			
			if (InStr(SyntaxParameters,"(") and InStr(SyntaxParameters,")")){
				Type := "Function"
			}
			if (SubStr(Function,1, 1) = "#"){
				Type := "Directive"
			}
			
			OutputText .= Type!="" ? "Type: " Type "`n" : ""
			SyntaxParameters := RegExReplace(SyntaxParameters, "<[^>]*>", "")
			SyntaxParameters := RegExReplace(SyntaxParameters, """", "&quot;")
			
			if (SyntaxParameters=": Same parameters as above."){
				SyntaxParameters:= SyntaxParameters_prev
			}
			SyntaxParameters_prev:= SyntaxParameters
			
			String := SyntaxParameters
			SyntaxParameters:= ""
			; Loop to replace the parameters by the options
			loop, {
				
				Prefix := RegExReplace(String, "^(.*?)(\w+)(.*)$", "$1", RegexCount)
				Parameter := RegExReplace(String, "^(.*?)(\w+)(.*)$", "$2", RegexCount)
				if (aParameters[Parameter]!=""){
					Parameter := aParameters[Parameter]
					if (A_Index=1 and Function!= ""){
						if InStr(Function, "#"){
							Function2:= StrReplace(Function, "#")
							Ahk_Xml["Content"] .= "`t`t<" Function2 ">`n`t`t`t<list add=""#"" list=""" 
							Ahk_Xml["Content"] .=  StrReplace(Parameter, "|", " ") """>" Function2 "</list>`n`t`t</" Function2 ">`n"
						}
						else{
							Ahk_Xml["Content"] .= "`t`t<" Function ">`n`t`t`t<list list=""" StrReplace(Parameter, "|", " ") """>" Function "</list>`n`t`t</" Function ">`n"
						}
					}
					else if (Function!= ""){
						if InStr(Function, "#"){
							Function2:= StrReplace(Function, "#")
							Ahk_Xml["Content2"] .= "`t`t<" Function2 ">`n`t`t`t<list add=""#"" list=""" 
							Ahk_Xml["Content2"] .=  StrReplace(Parameter, "|", " ") """>" Function2 "</list>`n`t`t</" Function2 ">`n"
						}
						else{
							Ahk_Xml["Content2"] .= "`t`t<" Function ">`n`t`t`t<list list=""" StrReplace(Parameter, "|", " ") """>" Function "</list>`n`t`t</" Function ">`n"
						}
					}
				}
				String := RegExReplace(String, "^(.*?)(\w+)(.*)$", "$3", RegexCount)
				if (RegexCount=0){
					SyntaxParameters .= String
					Break
				}
				SyntaxParameters .= Prefix  Parameter
			}
			
			OutputText .= "Syntax: " Function "" SyntaxParameters "`n"
			OutputText .= "`t`t<syntax syntax=""" SyntaxParameters """>" Function "</syntax>`n"
			if (Function!= ""){
				Ahk_Xml[Type] .= "`t`t<syntax syntax=""" SyntaxParameters "``n" Description """>" Function "</syntax>`n"
				
				;If also seen as a function in examples
				if (Type!="Function" and RegExMatch(ContentBuffer, "sS).*\b" Function "\(.*\)")){
					Ahk_Xml["Function"] .= "`t`t<syntax syntax=""(" Trim(SyntaxParameters) ")``n" Description """>" Function "</syntax>`n"
				}
			}
		}
		Content := RegExReplace(Content, "sS)^.*?<pre class=""[^>]*Syntax"">.*?</pre>.*?(<h\d\sid.*?<pre .*)$", "$1", RegexCount)
		
		if (RegexCount=0){
			Break
		}
	}
	
	OutputText .= "`n"
	
}
DebugWindow(OutputText,Clear:=0)

DebugWindow("`t<Command>`n" Ahk_Xml["Command"] "`t</Command>`n",Clear:=0)
DebugWindow("`t<Directive>`n" Ahk_Xml["Directive"] "`t</Directive>`n",Clear:=0)
DebugWindow("`t<Function>`n" Ahk_Xml["Function"] "`t</Function>`n",Clear:=0)
DebugWindow("`t<Content>`n" Ahk_Xml["Content"] "`t</Content>`n",Clear:=0)
DebugWindow("`t<Content2>`n" Ahk_Xml["Content2"] "`t</Content2>`n",Clear:=0)

ExitApp
