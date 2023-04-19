#+r::
	Send ^c
	Sleep 100
	CreateMenu("mRef", menuReferenceTools, "ReferenceTools")
	Menu mRef, Show
Return

ReferenceTools:
	RunMenuItem(menuReferenceTools, A_ThisMenuItemPos)
Return

CreateMenu(_menuName, _menuDef, _menuLabel){
	Loop Parse, _menuDef, `n
	{
		If (Mod(A_Index, 2) = 1) ; Odd
		{
			Menu %_menuName%, Add, %A_LoopField%, %_menuLabel%
		}
	}
}

RunMenuItem(_menuDef, _index){
	Loop Parse, _menuDef, `n
	{
		If (_index * 2 = A_Index)
		{
			StringReplace toRun, A_LoopField, @@, %Clipboard%, All
			Run %toRun%
			Break
		}
	}
}

menuReferenceTools =
(
opt&1
func.1
opt&2
func.2
opt&3
func.3
/*Google &Images

&Dictionary.com
The &Free Dictionary
&Merriam-Webster
http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=@@
http://en.wikipedia.org/w/wiki.phtml?search=@@
http://columbia.thefreedictionary.com/@@
&Encarta Encyclopedia
&AutoHotkey manual
*/
)