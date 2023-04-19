;
#SingleInstance, Force
DetectHiddenWindows, on


Hotkey, ~^LButton, ClickThrough, On

^!Lbutton::
hwnd := WinActive("A")
MsgBox, % "0: `n " %hwnd%
Return

ClickThrough:
MouseGetPos, x, y, hwnd
WinSet, AlwaysOnTop, On, ahk_id %hwnd%
WinSet, Transparent, 100, ahk_id %hwnd%
WinSet, ExStyle, +0x00000020, ahk_id %hwnd%
Return



;#Include Class_CustomFont.ahk
font1 := New CustomFont("CHOCD TRIAL___.otf")

Gui, Margin, 30, 10
Gui, Color, DECFB2
Gui, Font, s100 c510B01, Chocolate Dealer
Gui, Add, Text, w400, Chocolate
Gui, Show
Return

GuiClose:
ExitApp

Struct(Structure,pointer:=0,init:=0){
			return new _Struct(Structure,pointer,init)
		}
; AHK Structures
_AHKDerefType := "LPTSTR marker,{_AHKVar *var,_AHKFunc *func},BYTE is_function,BYTE param_count,WORD length"
_AHKExprTokenType := "{__int64 value_int64,double value_double,struct{{PTR *object,_AHKDerefType *deref,_AHKVar *var,LPTSTR marker},{LPTSTR buf,size_t marker_length}}},UINT symbol,{_AHKExprTokenType *circuit_token,LPTSTR mem_to_free}"
_AHKArgStruct := "BYTE type,BYTE is_expression,WORD length,LPTSTR text,_AHKDerefType *deref,_AHKExprTokenType *postfix"
_AHKLine := "BYTE ActionType,BYTE Argc,WORD FileIndex,UINT LineNumber,_AHKArgStruct *Arg,PTR *Attribute,*_AHKLine PrevLine,*_AHKLine NextLine,*_AHKLine RelatedLine,*_AHKLine ParentLine"
_AHKLabel := "LPTSTR name,*_AHKLine JumpToLine,*_AHKLabel PrevLabel,*_AHKLabel NextLabel"
_AHKFuncParam := "*_AHKVar var,UShort is_byref,UShort default_type,{default_str,Int64 default_int64,Double default_double}"
If (A_PtrSize = 8)
	_AHKRCCallbackFunc := "UINT64 data1,UINT64 data2,PTR stub,UINT_PTR callfuncptr,BYTE actual_param_count,BYTE create_new_thread,event_info,*_AHKFunc func"
else
	_AHKRCCallbackFunc := "ULONG data1,ULONG data2,ULONG data3,PTR stub,UINT_PTR callfuncptr,ULONG data4,ULONG data5,BYTE actual_param_count,BYTE create_new_thread,event_info,*_AHKFunc func"
_AHKFunc := "PTR vTable,LPTSTR name,{PTR BIF,*_AHKLine JumpToLine},*_AHKFuncParam Param,Int ParamCount,Int MinParams,*_AHKVar var,*_AHKVar LazyVar,Int VarCount,Int VarCountMax,Int LazyVarCount,Int Instances,*_AHKFunc NextFunc,BYTE DefaultVarType,BYTE IsBuiltIn"
_AHKVar := "{Int64 ContentsInt64,Double ContentsDouble,PTR object},{char *mByteContents,LPTSTR CharContents},{UINT_PTR Length,_AHKVar *AliasFor},{UINT_PTR Capacity,UINT_PTR BIV},BYTE HowAllocated,BYTE Attrib,BYTE IsLocal,BYTE Type,LPTSTR Name"

class Coord
{
	X:=0
	Y:=0
	__New(x,y){
		this.X:=x
		this.Y:=y
		return this
	}
}
class Rectangle
{
	Top:=0
	Left:=0
	Height:=0
	Width:=0
	__New(Top,Left,Width,Height){
		this.Top:=Top
		this.Left:=Left
		this.Width:=Width
		this.Height:=Height

	}
	GetTopLeftCoord(){
		aCoord:=new Coord
		aCoord.x:=this.Left
		aCoord.y:=this.Top
		return aCoord
	}
	GetLowerRightCoord(){
		aCoord:=new Coord
		aCoord.x:=this.Left+this.Width
		aCoord.y:=this.Top+this.Height
		return aCoord
	}
	FromCoords(c1,c2){
		r:=new Rectangle
		r.Top:=c1.y
		r.Left:=c1.x
		r.Height:=c2.y-c1.y
		r.Width:=c2.x-c1.x
		return r
	}
}

c:=new Coord(1,2)
for variable,value in c
msgbox %variable%=%value%



Rec := new Rectangle(10,20,300,400)
For key,value in Rec.Base
BaseMembers .= key "=" value "`n"	
msgbox, % BaseMembers

return


/*
	CustomFont v2.01 (2018-8-25)
	---------------------------------------------------------
	Description: Load font from file or resource, without needed install to system.
	---------------------------------------------------------
	Useage Examples:
		* Load From File
			font1 := New CustomFont("ewatch.ttf")
			Gui, Font, s100, ewatch
		* Load From Resource
			Gui, Add, Text, HWNDhCtrl w400 h200, 12345
			font2 := New CustomFont("res:ewatch.ttf", "ewatch", 80) ; <- Add a res: prefix to the resource name.
			font2.ApplyTo(hCtrl)
		* The fonts will removed automatically when script exits.
		  To remove a font manually, just clear the variable (e.g. font1 := "").
*/
Class CustomFont
{
	static FR_PRIVATE  := 0x10

	__New(FontFile, FontName="", FontSize=30) {
		if RegExMatch(FontFile, "i)res:\K.*", _FontFile)
			this.AddFromResource(_FontFile, FontName, FontSize)
		else
			this.AddFromFile(FontFile)
	}

	AddFromFile(FontFile) {
		if !FileExist(FontFile) {
			throw "Unable to find font file: " FontFile
		}
		DllCall( "AddFontResourceEx", "Str", FontFile, "UInt", this.FR_PRIVATE, "UInt", 0 )
		this.data := FontFile
	}

	AddFromResource(ResourceName, FontName, FontSize = 30) {
		static FW_NORMAL := 400, DEFAULT_CHARSET := 0x1

		nSize    := this.ResRead(fData, ResourceName)
		fh       := DllCall( "AddFontMemResourceEx", "Ptr", &fData, "UInt", nSize, "UInt", 0, "UIntP", nFonts )
		hFont    := DllCall( "CreateFont", Int,FontSize, Int,0, Int,0, Int,0, UInt,FW_NORMAL, UInt,0
		            , Int,0, Int,0, UInt,DEFAULT_CHARSET, Int,0, Int,0, Int,0, Int,0, Str,FontName )

		this.data := {fh: fh, hFont: hFont}
	}

	ApplyTo(hCtrl) {
		SendMessage, 0x30, this.data.hFont, 1,, ahk_id %hCtrl%
	}

	__Delete() {
		if IsObject(this.data) {
			DllCall( "RemoveFontMemResourceEx", "UInt", this.data.fh    )
			DllCall( "DeleteObject"           , "UInt", this.data.hFont )
		} else {
			DllCall( "RemoveFontResourceEx"   , "Str", this.data, "UInt", this.FR_PRIVATE, "UInt", 0 )
		}
	}

	; ResRead() By SKAN, from http://www.autohotkey.com/board/topic/57631-crazy-scripting-resource-only-dll-for-dummies-36l-v07/?p=609282
	ResRead( ByRef Var, Key ) {
		VarSetCapacity( Var, 128 ), VarSetCapacity( Var, 0 )
		If ! ( A_IsCompiled ) {
			FileGetSize, nSize, %Key%
			FileRead, Var, *c %Key%
			Return nSize
		}

		If hMod := DllCall( "GetModuleHandle", UInt,0 )
			If hRes := DllCall( "FindResource", UInt,hMod, Str,Key, UInt,10 )
				If hData := DllCall( "LoadResource", UInt,hMod, UInt,hRes )
					If pData := DllCall( "LockResource", UInt,hData )
						Return VarSetCapacity( Var, nSize := DllCall( "SizeofResource", UInt,hMod, UInt,hRes ) )
							,  DllCall( "RtlMoveMemory", Str,Var, UInt,pData, UInt,nSize )
		Return 0
	}
}


;A CLSID example. Allows the user to select a folder in the "My Computer" directory.

FileSelectFolder, OutputVar, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}  ; My Computer.
;=========


FullFileName := "C:\My Documents\Address List.txt"
   
; To fetch only the bare filename from the above:
SplitPath, FullFileName, name

; To fetch only its directory:
SplitPath, FullFileName,, dir

; To fetch all info:
SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
   
; The above will set the variables as follows:
; name = Address List.txt
; dir = C:\My Documents
; ext = txt
; name_no_ext = Address List
; drive = C:


if FileExist("D:\")
    MsgBox, The drive exists.
 ;Shows a message box if at least one text file does exist in a directory.

if FileExist("D:\Docs\*.txt")
    MsgBox, At least one .txt file exists.
 ;Shows a message box if a file does not exist.

if !FileExist("C:\Temp\FlagFile.txt")
    MsgBox, The target file does not exist.

;==============
front(filename,dir){
;StringSplit, OutputArray, InputVar , Delimiters, OmitChars

    InputBox, name, "name,path"
 random, ranVar, 1, 100000000
 msgbox % ranvar
 ranvar := StrSplit(ranvar, ",", %a_space% " `t")

TestString := "This is a test."
StringSplit, word_array, TestString, %A_Space%, .  ; Omits periods.
MsgBox, The 4th word is %word_array4%.

colors := "red,green,blue"
for index, color in StrSplit(colors, ",")
    MsgBox % "Color number " index " is " color

    return global frontfile, frontproject
}

getCode(Order) { ; to fill in the second parameter of Template
    return repeat(1, Order) "," repeat(2, Order) "," repeat(3, Order)
     . "," repeat(4, Order) "," repeat(5, Order) "," repeat(6, Order)
}

repeat(str, n) { ; return str repeated n*n times
    Result := ""
    Loop, % n * n
        Result .= str
    return Result
}

fun(){
    global myfun
    myfun:=new fun()
}

class fun{
    __new(){
        return this
    }
    fun(){
        
    }
}

StrAppendEachLine(str, appendix){
 
    return, RegExReplace(str, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix)
}
fileAppendEachLine(filename, appendix){
    hmm := FileOpen(filename, "r`n").read()
    FileOpen(filename, "w`n").write(RegExReplace(hmm, "m`n)^(.+?)(?<!" appendix ")$", "$1" appendix))
    return
}

z_stringreplace(string, find, rep ){
    MsgBox, % "0: `n " find rep
   ; StringReplace, r, s, - , ||| , All
    StringReplace, r, s, %find% , %rep% , All
return r
}




removespace(ans){

;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
;Fronttext := clipboard
NewStr := StrReplace(ans, A_Space, "_")
;ReplacedStr := StrReplace(Haystack, Needle , ReplaceText, OutputVarCount, Limit)
clipboard := newstr
return newStr 
}


;==================

Run,  C:\Users\dustychops\Dropbox (Work Team)\Desktop\%workOrder%\%TagVar%-%workOrder%
Run,  % "C:\Users\dustychops\Dropbox (Work Team)\Desktop\" workOrder "\" TagVar "-" workOrder ; this is fine syntax-wise


FormatTime, TimeString
MsgBox The current time and date (time first) is %TimeString%.

FormatTime, TimeString, R
MsgBox The current time and date (date first) is %TimeString%.

FormatTime, TimeString,, Time
MsgBox The current time is %TimeString%.

FormatTime, TimeString, T12, Time
MsgBox The current 24-hour time is %TimeString%.

FormatTime, TimeString,, LongDate
MsgBox The current date (long format) is %TimeString%.

FormatTime, TimeString, 20050423220133, dddd MMMM d, yyyy hh:mm:ss tt
MsgBox The specified date and time, when formatted, is %TimeString%.

FormatTime, TimeString, 200504, 'Month Name': MMMM`n'Day Name': dddd
MsgBox %TimeString%

FormatTime, YearWeek, 20050101, YWeek
MsgBox January 1st of 2005 is in the following ISO year and week number: %YearWeek%
;================
 ;Changes the date-time stamp of a file.
FileSelectFile, FileName, 3,, Pick a file
if (FileName = "")  ; The user didn't pick a file.
    return
FileGetTime, FileTime, %FileName%
FormatTime, FileTime, %FileTime%   ; Since the last parameter is omitted, the long date and time are retrieved.
MsgBox The selected file was last modified at %FileTime%.
;================

 ;Converts the specified number of seconds into the corresponding number of hours, minutes, and seconds (hh:mm:ss format).
MsgBox % FormatSeconds(7384)  ; 7384 = 2 hours + 3 minutes + 4 seconds. It yields: 2:03:04

FormatSeconds(NumberOfSeconds)  ; Convert the specified number of seconds to hh:mm:ss format.
{
    time := 19990101  ; *Midnight* of an arbitrary date.
    time += NumberOfSeconds, seconds
    FormatTime, mmss, %time%, mm:ss
    return NumberOfSeconds//3600 ":" mmss
    /*
    ; Unlike the method used above, this would not support more than 24 hours worth of seconds:
    FormatTime, hmmss, %time%, h:mm:ss
    return hmmss
    */
}


;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]

Support := "SupportName :D"

; Directory test!
; dirName := "c:test\temp.test."	; Autokorrigera bort punkt
; dirName := "c:temp\test\"	; Autocorrigera
; dirName := "c:\test."	; Fungerar inte i windows (.) försvinner och test skapas men FileExist kan inte hitta)
; dirName := "c:test\test.1"
; dirName := "c:\test\test."	; OK!
; dirName := "c:\test\test.1\"	; OK!
; dirName := "c:test"	; auto correct to "c:\test\" OK!
; dirName := "c:test\"	; auto correct to "c:\test\" OK!
; dirName := "c:\temp\test"	; auto correct to "c:\temp\test\" OK!
; dirName := "c:\temp\test\"	; OK!
; dirName := "c:\temp\test\*.*"	; filename *.* - failed
dirName := "c:\temp\"



fileName := "c:temp\t."
; fileName := "c:temp\t.*"		; a fileName?
; fileName := "c:\temp\t.txt" ; a fileName
; fileName := "\"				; Not a fileName
; fileName :=						; Not checked
; fileName := "temp\t*.txt"	; Not a fileName
; fileName = 1					; Not a fileName


; CheckDir(dirName, "Testinfo", A_LineNumber)
CheckDir(dirName, "Testinfo", A_LineNumber, fileName)
MsgBox ,, Rad %A_LineNumber% -> %A_ScriptName%, Ready!
ExitApp

CheckDir( fullPath, Info, Line, fDelete := "" )
{	; Version 17 maj 2020
	;
	; 1) Funktionen kontrollerar om "fullPath" är en katalog
	; 		Om "fullPath" saknas - fråga om den skall skapas
	;		Både "c:\test\" och "c:\test" är giltiga kataloger.
	; 		Autokorrigerar "c:test" till "c:\test\"
	;
	; 2) Funktionen kontrollerar om "fDelete" är ett filnamn
	; 		Om "fDelete" existerar - radera.
	; 
	; 3) Vid problem avslutas programmet!
	;
	; - Path 
	;		Konrollera att Path är en sökväg till katalog (inte ett filnamn)
	;		(dvs. får bara innehålla "dirDrive" och "dirPath")
	;		Om "Path" INTE existerar - Skapa katalog!
	; - Info
	; 		Innehåller information som beskriver eventuella problem
	;		ex. testinformation, fel vid test eller ...
	; -Line
	;		Radnummer i programmet som anropet till funktionen() kom i från
	;		(A_LineNumber vid funktions anrop) underlättar ev. felsökning
	; -fDelete
	;		Kontrollera om "fDelete" innehåler ett giltigt filnamn.
	;		Måste innehålla filnamn, sökväg och drive (ex c:)
	;
	
	Global Support
	
	; Om variabeln fullPath saknar värde - avsluta!
	If !fullPath
	{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
		( LTrim 
		 %	"Ingen katalog har angivits!
		 	Funktionsanrop från rad .: " Line "`n
			Kontakta .: " Support "`n
			Detta program avslutas!"
		)
		ExitApp
	}
	
	; Kontrollera om "fullPath" är ett giltigt katalognamn
	SplitPath fullPath, dirFileName, dirPath, dirExt, dirNoExt, dirDrive
	; MsgBox ,, Rad %A_LineNumber% -> %A_ScriptName%, % fullPath "`n`n- " dirFileName "`n- " dirPath "`n- " dirExt "`n- " dirNoExt "`n- " dirDrive

	; Om sökvägen saknar ":\" efter enhetsnamnet(c:test\) - koorigera till (c:\test\)
	If	!inStr(fullPath, ":\")
	{	Kolon := inStr(fullPath, ":")
		fullPath := SubStr(fullPath, 1, Kolon) "\" SubStr(fullPath, Kolon+1)
		SplitPath fullPath, dirFileName, dirPath, dirExt, dirNoExt, dirDrive
	}
	
	; Om sökvägen avslutas med "." (punkt) - radera punkten
	If ( SubStr(fullPath, StrLen(fullPath), 1) = "." )
	{	fullPath := SubStr(fullPath, 1, StrLen(fullPath)-1)
	}

	; Om sökvägen saknar "\" sist i sökvägen - lägg till "\" - inget filnamn förväntas!
	If dirFileName and !dirExt
	{	fullPath .= "\"
		SplitPath fullPath, dirFileName, dirPath, dirExt, dirNoExt, dirDrive
	}
	; MsgBox ,, Rad %A_LineNumber% -> %A_ScriptName%, % fullPath "`n`n- " dirFileName "`n- " dirPath "`n- " dirExt "`n- " dirNoExt "`n- " dirDrive
	
	; Om sökvägen innehåller ett filnamn - problem!
	If dirFileName
	{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
		( LTrim 
		 %	"Ogiltigt katalognamn!
		 	Funktionsanrop från rad .: " Line "`n
			Angiven sökväg .: " fullPath "
			Förslag .:
			`tInnehåller ett filnamn .: ( " dirFileName " )
			`t(eller saknar ett `\ efter sökvägen)`n
			Kontakta .: " Support "`n
			Detta program avslutas!"
		)
		ExitApp
	}
	
	; Om drive och sökväg saknas - problem!
	If !dirDrive or !dirPath
	{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
		( LTrim 
		 %	"Ogiltigt katalognamn!`n
			Angiven katalog .: " fullPath "
			`tSaknas enhetsnamn - tex. c: ? .: " dirDrive ")
			`tSaknas sökväg? .: " dir Path ")
			Funktionsanrop från rad .: " Line "`n
			Kontakta .: " Support "`n
			Detta program avslutas!"
		)
		ExitApp
	}
	
	If !InStr(dirDrive, ":")
	{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
		( LTrim 
		 %	"Ogiltigt enhetsnamn!`n
			Angiven katalog .: " fullPath "
			Enhetsnamn .: " dirDrive "
			Funktionsanrop från rad .: " Line "`n
			Kontakta .: " Support "`n
			Detta program avslutas!"
		)
		ExitApp
	}

	If !FileExist(fullPath) ; Om sökväg saknas!
	{	MsgBox 20, Rad %A_LineNumber% -> %A_ScriptName%,
		( LTrim
		 %	"Önskad katalog saknas!
			(Dit " Info " senare skall sparas)`n
			Stämmer katalognamnet? .: " fullPath "`n
			Skall katalogen ovan skapas ?"
		)
		IfMsgBox Yes
		{	; FileCreateDir %fullPath%
			MsgBox ,, Rad %A_LineNumber% -> %A_ScriptName%, Run .: FileCreateDir %fullPath%
			If ErrorLevel
			{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
				( LTrim
				 %	"Katalog kunde inte skapas!
				 	Funktionsanrop från rad .: " Line "`n
					Önskad katalog för " Info " .:
					`t" fullPath "`n
					ErrorLevel .: " ErrorLevel " ( Orsak okänd! )`n
					Kontakta .: " Support "`n
					Detta program avslutas!"
				)
				ExitApp
			}

			; Kolla att katalogen verkligen skapats
			If !FileExist(fullPath)
			{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
				( LTrim
				 %	"Fortfarande saknas katalogen!
					Funktionsanrop från rad .: " Line "`n
					(Hit skulle " Info " sparas)
					Katalognamn .: " fullPath "`n
					Kontakta .: " Support "`n
					Detta program avslutas!"
				)
				ExitApp
			}

		}
		else
		{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
			( LTrim
				Ingen katalog skapades! `n
				Detta program avslutas! `n
			), 2
			ExitApp
		}
	}



	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; Om fDelete innehåller ett giltigt filnamn som existerar - radera filen
	If fDelete
	{	SplitPath fDelete, deleteFileName, deletePath, deleteExt, deleteNameNoExt, deleteDrive		
		
		; Om sökvägen i filnamnet saknar ":\" efter enhetsnamnet(c:test\...) - koorigera till (c:\test\...)
		If	!inStr(fDelete, ":\")
		{	Kolon := inStr(fDelete, ":")
			fDelete := SubStr(fDelete, 1, Kolon) "\" SubStr(fDelete, Kolon+1)
			SplitPath fDelete, deleteFileName, deletePath, deleteExt, deleteNameNoExt, deleteDrive
		}
	
		; Om filnamnet avslutas med "." (punkt) - radera punkten
		If ( SubStr(fDelete, StrLen(fDelete), 1) = "." )
		{	fDelete := SubStr(fDelete, 1, StrLen(fDelete)-1)
		}
		; MsgBox % fDelete "`n`n- " deleteFileName "`n- " deletePath "`n- " deleteExt "`n- " deleteNameNoExt "`n- " deleteDrive	
		
		; Kontrollera om fDelete har drive, path, namn
		If !deleteDrive or !deletePath or !deleteNameNoExt
		{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
			( LTrim 
			 %	"Ofullständigt filnamn eller sökväg!
				Funktionsanrop från rad .: " Line "`n
				Önskat filnamn .: " deleteFileName "
				Sökväg .: " deletePath "
				Enthet (ex. c:} .: " deleteDrive "`n
				Kontakta .: " Support "`n
				Detta program avslutas!"
			)
			ExitApp
		}
		
		If !InStr(deleteDrive, ":")
		{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
			( LTrim 
			%	"Ogiltigt enhetsnamn!`n
				Filnamn .: " deleteFileName "
				Sökväg .: " deletePath "`n
				( enhetsnamn (ex. c:) .: " deleteDrive "
				Funktionsanrop från rad .: " Line "`n
				Kontakta .: " Support "`n
				Detta program avslutas!"
			)
			ExitApp
		}
		
		If FileExist(fDelete)
		{	; FileDelete % fDelete
			MsgBox ,, Rad %A_LineNumber% -> %A_ScriptName%, FileDelete %fDelete%
			If ErrorLevel
			{	MsgBox 16, Rad %A_LineNumber% -> %A_ScriptName%,
				( LTrim
				%	"Problem vid radering av fil(er)!
					`t( Orsak okänd! )`n
					Filnamn .: " deleteFileName "
					Sökväg .: " deletePath "`n
					ErrorLevel (antal ej raderade filer) .: " ErrorLevel "
					Funktionsanrop från rad .: " Line "`n
					Kontakta .: " Support "`n
					Detta program avslutas!"
				)
				ExitApp
			}
		}
	}
}

