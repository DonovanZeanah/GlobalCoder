#Persistent
old_prog = StartUp 

; set location and header row for the output file 
filename = %A_MyDocuments%\%A_UserName%_%a_mm%-%a_dd%-%a_yyyy%.txt 
titlerow = StartTime%A_Tab%EndTime%A_Tab%UserName%A_Tab%ProgramName%A_Tab%WindowTitle`r`n 

; set initial start time 
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt 

SetTimer, ActiveProgLog, 5000 

ActiveProgLog: 
if (old_prog = WinExist("A"))   ; if hWnd values match 
   return   ; go back and wait for next execution of time 
; else set end time 
WinGet, program_name, ProcessName, A 
WinGetActiveTitle, window_name 
FormatTime, EndTime,,MM/dd/yy hh:mm:ss tt 

; save values for output file 
datarow = %StartTime%%A_Tab%%EndTime%%A_Tab%%A_UserName%%A_Tab%%program_name%%A_Tab%%window_name%`r`n 

; save data output 
IfNotExist,%filename%   ; if log does not exist, create it 
   FileAppend, %titlerow%, %filename% 
FileAppend, %datarow%, %filename%   ; append time stamp/prog data 
old_prog :=   WinExist("A")   ; set old_prog with hWnd of new active window 
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt   ; reset StartTime with new time 
return

;==========================================================
^!9::
A:=20110721205500
B:=20110721221002
;B:=A_Now
B-=A,seconds     ; difference B-A in seconds
C:=A_Now

Transform hr,floor, (b/3600)
Transform min,floor, (b/60) - hr*60
sec := b - min*60 - hr*3600
If ( sec < 10 )
   sec = 0%sec%
If ( min < 10 )
   min = 0%min%

msgbox,STARTTIME=%a%`nENDTIME   =%c%`nDuration=%hr%:%min%:%sec%
return

;=======================================
;-------- saved at Donnerstag, 21. Juli 2011 20:45:56 --------------
;-------- http://www.autohotkey.com/forum/topic74395.html ---
^!l::
old_prog = StartUp

; set location and header row for the output file
filename = %a_scriptdir%/testlogs/%a_mm%-%a_dd%-%a_yyyy%.txt
titlerow = StartTime%A_Tab%EndTime%A_Tab%UserName%A_Tab%ProgramName%A_Tab%WindowTitle`r`n



; set initial start time
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt
SetTimer, ActiveProgLog, 5000
return
;--------------------------------------------------


ActiveProgLog2:
if (old_prog = WinExist("A"))                ; if hWnd values match
   return                                    ; go back and wait for next execution of time
; else set end time
WinGet, program_name, ProcessName, A
WinGetActiveTitle, window_name
FormatTime, EndTime,,MM/dd/yy hh:mm:ss tt
ENDTIME1=%A_now%


A:=(STARTTIME1)
B:=(ENDTIME1)
B-=A,seconds
;C:=A_Now

Transform hr,floor, (b/3600)
Transform min,floor, (b/60) - hr*60
sec := b - min*60 - hr*3600
If ( sec < 10 )
   sec = 0%sec%
If ( min < 10 )
   min = 0%min%

Duration1=%hr%:%min%:%sec%

; save values for output file
datarow = %StartTime%%A_Tab%%EndTime%%A_Tab%Duration=%Duration1%%A_TAB%%A_UserName%%A_Tab%%program_name%%A_Tab%%window_name%`r`n



; save data output
IfNotExist,%filename%                         ; if log does not exist, create it
   FileAppend, %titlerow%, %filename%

FileAppend, %datarow%, %filename%             ; append time stamp/prog data
old_prog :=   WinExist("A")                   ; set old_prog with hWnd of new active window
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt   ; reset StartTime with new time
StartTime1=%A_now%



return
;--------------------------------------------------



!l::
old_prog = StartUp

; set location and header row for the output file
filename = %A_MyDocuments%\TimeTracker\%A_UserName%_%a_yyyy%-%a_mm%.txt
titlerow = StartTime%A_Tab%EndTime%A_Tab%Duration%A_Tab%Day of Week%A_Tab%Year-Week%A_Tab%Day%A_Tab%Month%A_Tab%Year%A_Tab%UserName%A_Tab%ProgramName%A_Tab%WindowTitle`r`n



; set initial start time
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt
SetTimer, ActiveProgLog, 5000
return
;--------------------------------------------------


ActiveProgLog3:
if (old_prog = WinExist("A"))                ; if hWnd values match
   return                                    ; go back and wait for next execution of time
; else set end time
WinGet, program_name, ProcessName, A
WinGetActiveTitle, window_name
FormatTime, EndTime,,MM/dd/yy hh:mm:ss tt
FormatTime, day_of_week,,dddd           ;the full day of the week variable
FormatTime, day,,dd             ;day of the month variable
FormatTime, month,,MMM              ;month number variable
FormatTime, year,,yyyy              ;full 4 digit year variable
FormatTime, week,,YWeek             ;week number variable, in the format of YYYYWW
ENDTIME1=%A_now%


A:=(STARTTIME1)
B:=(ENDTIME1)
B-=A,seconds
;C:=A_Now

Transform hr,floor, (b/3600)
Transform min,floor, (b/60) - hr*60
sec := b - min*60 - hr*3600
If ( sec < 10 )
   sec = 0%sec%
If ( min < 10 )
   min = 0%min%

Duration1=%hr%:%min%:%sec%

; save values for output file
datarow = %StartTime%%A_Tab%%EndTime%%A_Tab%%Duration1%%A_Tab%%day_of_week%%A_Tab%%week%%A_Tab%%day%%A_Tab%%month%%A_Tab%%year%%A_TAB%%A_UserName%%A_Tab%%program_name%%A_Tab%%window_name%`r`n



; save data output
IfNotExist,%filename%                         ; if log does not exist, create it
   FileAppend, %titlerow%, %filename%

FileAppend, %datarow%, %filename%             ; append time stamp/prog data
old_prog :=   WinExist("A")                   ; set old_prog with hWnd of new active window
FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt   ; reset StartTime with new time
StartTime1=%A_now%

return