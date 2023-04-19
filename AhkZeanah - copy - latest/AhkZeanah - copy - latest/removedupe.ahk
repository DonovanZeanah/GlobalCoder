;- modified = 20220523
;- example try to remove doublelines and convertdatetime
;-
;-
;- script modified , because I didn't found these / here small modified for test   : ( if found then converted ) 
;Date: Fri, Jan 3, 2020 at 11:58 AM  > Date:=星期五 一月 2020-01-03  11:58
;Date: Fri, Jan 3, 2020 at 11:58 PM  > Date:=星期五 一月 2020-01-03  23:58
;Cc: kelly@DeSilvaGroup.com <kelly@ajogroup.com>, , Bill
;-
#MaxMem 4095
transform,k,chr,44   ;- ' , '
;-
;- https://www.autohotkey.com/boards/viewtopic.php?p=462736#p462736  /  sampletext.txt"  - file at page-1  34.44-kB
url:="https://www.autohotkey.com/boards/download/file.php?id=17830"
F1:=a_scriptdir "\sampletext.txt"
ifnotexist,%f1%
 urldownloadtofile,%url%,%f1%
F2:=a_scriptdir "\" . a_now . "_sampletext_new.txt"
;-
Out:="" 
Obj := FileOpen(F1, "r",UTF-8)
var := Obj.Read()
stringreplace,var,var,%k%,$$,all   ;- or  stringreplace,var,var,`,,$$,all
Obj.Close()
Loop,parse,var,`n,`r
 {
 x:= A_LoopField
 if x=
   continue
 x=%x%                     ;- remove leading spaces
 If out not contains %x%   ;- can this work with big files ( ? )
   {
   stringmid,x1,x,1,5
   if (x1="Date:")         ;- convert 'Date: Fri, Jan 3, 2020 at 11:59 PM' > Date:=星期五 一月 2020-01-03  23:59
     {
	 stringmid,x2,x,6,40
	 stringreplace,x2,x2,$$,%k%,all
	 timex:=DateParse(x2)
	 timex2:=timex . "00"                                         ;- 20200103235900
	 FormatTime,TS,%timex2% L0x0804, dddd MMMM yyyy-MM-dd  HH:mm  ;- example china / change country and format
	 x:="Date:=" . TS
	 x1:=""
	 }
   out .= x . "`r`n"
   }
 }
stringreplace,out,out,$$,%k%,all 
ifnotexist,%f2%
 {
 FileOpen(F2, "w", "UTF-8").Write(out)
 try
   run,%f2%
 }
out=
x= 
exitapp
;================

;- https://www.autohotkey.com/board/topic/18760-date-parser-convert-any-date-format-to-yyyymmddhh24miss/
;-----------------------------------------------------------------------------------------------
DateParse(str, americanOrder=0) {
	static monthNames := "(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*"
		, dayAndMonth := "(?:(\d{1,2}|" . monthNames . ")[\s\.\-\/,]+)?(\d{1,2}|" . monthNames . ")"
	If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
		. "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
		. "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i) ;ISO 8601 timestamps
		year := i1, month := i3, day := i4, t1 := i5, t2 := i7, t3 := i8
	Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t){
		RegExMatch(str, "i)(\d{1,2})"					;hours
				. "\s*:\s*(\d{1,2})"				;minutes
				. "(?:\s*:\s*(\d{1,2}))?"			;seconds
				. "(?:\s*([ap]m))?", t)				;am/pm
		StringReplace, str, str, %t%
		If Regexmatch(str, "i)(\d{4})[\s\.\-\/,]+" . dayAndMonth, d) ;2004/22/03
			year := d1, month := d3, day := d2
		Else If Regexmatch(str, "i)" . dayAndMonth . "[\s\.\-\/,]+(\d{2,4})", d)  ;22/03/2004 or 22/03/04
			year := d3, month := d2, day := d1
		If (RegExMatch(day, monthNames) or americanOrder and !RegExMatch(month, monthNames)) ;try to infer day/month order
			tmp := month, month := day, day := tmp
	}
	f = %A_FormatFloat%
	SetFormat, Float, 02.0
	d := (StrLen(year) == 2 ? "20" . year : (year ? year : A_YYYY))
		. ((month := month + 0 ? month : InStr(monthNames, SubStr(month, 1, 3)) // 4 ) > 0 ? month + 0.0 : A_MM)
		. ((day += 0.0) ? day : A_DD) 
		. t1 + (t1 == 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "pm" ? 12.0 : 0.0)
		. t2 + 0.0 . t3 + 0.0
	SetFormat, Float, %f%
	return, d
}
;===========================================================================