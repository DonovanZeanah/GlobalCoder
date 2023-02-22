; ***********************************************
 ; * *
 ; * *
 ; * LOGGING FUNCTIONS *
 ; * *
 ; * *
 ; ***********************************************

; TOTAL USEAGE COUNT (GLOBAL COUNT OF ALL NOTES)
 IniRead, UseageCount, UseageLog.ini, TotalUses, Count
 UseageCount++
 iniwrite, %UseageCount%, UseageLog.ini, TotalUses, Count

; TOTAL USEAGE COUNT BY NOTE TYPE
 IniRead, UseageCount, UseageLog.ini, TotalUses, PA Review
 UseageCount++
 iniwrite, %UseageCount%, UseageLog.ini, TotalUses, PA Review

; TOTAL USEAGE COUNT BY USER
 IniRead, UseageCount, UseageLog.ini, %A_UserName%, Total Uses
 UseageCount++
 iniwrite, %UseageCount%, UseageLog.ini, %A_UserName%, Total Uses

; TOTAL USEAGE COUNT BY NOTE TYPE FOR EACH USER
 IniRead, UseageCount, UseageLog.ini, %A_UserName%, PA Review
 UseageCount++
 iniwrite, %UseageCount%, UseageLog.ini, %A_UserName%, PA Review

; DATE/TIME/USER/NOTE TYPE
 UseDate = %A_DD%/%A_MM%/%A_YYYY%
 UseTime = %A_Hour%:%A_Min%
 FileAppend
   ,%UseDate% %A_Space% %UseTime% %A_Space% %A_UserName% %A_Space% (PA Review)`n
   , UserTimeDate.log
;===============
  /* FunctionLog(Parameter1,Parameter2)
{
  IniRead, UseageCount, UseageLog.ini, %Parameter1%, %Parameter2%
  UseageCount++
  Iniwrite, %UseageCount%, UseageLog.ini, %Parameter1%, %Parameter2%
}
*/
  ;=============
/*FunctionLog(Section,Key)
{
  IniRead, UseageCount, UseageLog.ini, %Section%, %Key%
  UseageCount++
  Iniwrite, %UseageCount%, UseageLog.ini, %Section%, %Key%
}
*/
;===============
/*FunctionLog("TotalUses","Count")
FunctionLog("TotalUses","PA Review")
FunctionLog(A_UserName,"Total Uses")
FunctionLog(A_UserName,"PA Review")
*/
;===============***
;AutoHotkey can also call a function by setting a variable equal to its output:

Test := returnTest()
MsgBox % Test

returnTest() {
  return 123
}

;=====================
;You can expand the flexibility of the function by adding more parameters. For example, what if you want to use it with various INI files? Merely add another parameter inside the parentheses for the filename:
;Then, you could use the function with any INI file by merely supplying the filename when calling the function:

FunctionLog(Section,Key,Filename)
{
  IniRead, UseageCount, %a_workingdir%/testlogs/%Filename%, %Section%, %Key%
  UseageCount++
  Iniwrite, %UseageCount%, %a_workingdir%/testlogs/%Filename%, %Section%, %Key%
}

FunctionLog("TotalUses","Count","UseageLog1.ini")
FunctionLog("TotalUses","PA Review","UseageLog1.ini")
FunctionLog(A_UserName,"Total Uses","UseageLog2.ini")
FunctionLog(A_UserName,"PA Review","UseageLog2.ini")