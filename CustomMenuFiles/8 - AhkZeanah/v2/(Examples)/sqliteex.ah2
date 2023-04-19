;**************
; REQUIREMENTS*
;**************

; AutoHotkey Version 2 (AutoHotkey_2.0-a100-52515e2)
; https://www.autohotkey.com/download/2.0/AutoHotkey_2.0-a100-52515e2.zip
; sqlite3.exe located in A_ScriptDir (i.e., the directory that contains this .ahk file)
; https://www.sqlite.org/2019/sqlite-tools-win32-x86-3270200.zip
; Chinese-English glossary file (excerpt from CC-CEDICT) in A_ScriptDir
; https://pastebin.com/BS3KnzRL
; Official link to complete CC-CEDICT
; https://cc-cedict.org/editor/editor_export_cedict.php?c=zip

;*************
; DISCLAIMER:*
;*************

; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the
; use of this software.

;*******************************************
; SPECIFY NAME FOR DATABASE AND DATA SOURCE*
;*******************************************

db_file := A_ScriptDir . "\ce_glossary.sqlite"
;source_files := A_ScriptDir . "\chinese_english\*.txt"
source_files := A_ScriptDir . "\CC-CEDICT.txt"

;****************************************
; FUNCTIONS FOR EXECUTING SQL STATEMENTS*
;****************************************

ExecuteSql(statement_type, sql_cmd)
{
	; SQLite3.exe user manual with explanation of "dot-commands": https://www.sqlite.org/cli.html
	; Other statement types can be added as needed
	
	global db_file
	db_file := RegExReplace(db_file, "\\", "\\") ; sqlite.exe needs double backslashes
	result := ''
	
	If statement_type = "CREATE"
	{
		sql_cmd_file := ReadInFile(sql_cmd)
		log_file := LogFile()
		RunWait(A_ScriptDir . '\sqlite3.exe ' . db_file . ' ".log ' . log_file . '"' . ' ".read ' . sql_cmd_file . '"',, "Hide")
		CheckForError(log_file)
	}
	Else If (statement_type = "INSERT")
	{
		sql_cmd_file := ReadInFile(sql_cmd)
		log_file := LogFile()
		RunWait(A_ScriptDir . '\sqlite3.exe ' . db_file . ' ".log ' . log_file . '"' . ' ".read ' . sql_cmd_file . '"',, "Hide")
		CheckForError(log_file)
	}
	Else If (statement_type = "QUERY")
	{
		sql_cmd_file := ReadInFile(sql_cmd)
		log_file := LogFile()
		sql_out_file := OutputFile()
		RunWait(A_ScriptDir . '\sqlite3.exe ' . db_file . ' ".log ' . log_file . '"' . ' ".output ' . sql_out_file . '"' . ' ".read ' . sql_cmd_file . '"',, "Hide")
		CheckForError(log_file)
		result := FileRead(sql_out_file, "UTF-8-RAW")
	}
	Else
	{
		MsgBox("The statement type you specified is incorrect or not implemented yet. Aborting...")
		ExitApp()
	}
	Return(result)
}

ReadInFile(sql_cmd)
{
	; Return value used with the sqlite3.exe .read "dot-command"
	
	sql_cmd_file := A_ScriptDir . "\sql_command_file.txt" ; write commands to file for read-in (needed for non-ascii charsets)
	FileDelete(sql_cmd_file)
	FileAppend(sql_cmd, sql_cmd_file, "UTF-8-RAW") ; sqlite3.exe needs UTF-8 without BOM
	sql_cmd_file := RegExReplace(sql_cmd_file, "\\", "\\") ; sqlite3.exe needs double backslashes
	Return(sql_cmd_file)
}

LogFile()
{
	; Return value used with the sqlite3.exe .log "dot-command"
	
	log_file := A_ScriptDir . "\log_file.txt" ; write log messages such as errors to file
	FileDelete(log_file)
	log_file := RegExReplace(log_file, "\\", "\\")
	Return(log_file)
}

OutputFile()
{
	; Return value used with the sqlite3.exe .output "dot-command"
	
	sql_out_file := A_ScriptDir . "\sql_output_file.txt" ; writes output to file (needed for non-ascii charsets)
	FileDelete(sql_out_file)
	sql_out_file := RegExReplace(sql_out_file, "\\", "\\")
	Return(sql_out_file)
}

CheckForError(log_file)
{
		
	; SQLite3 result and error codes: https://sqlite.org/rescode.html
	; We log notices and warnings (codes 27, 28 respectively), but log and abort for all other codes
	
	If (FileExist(log_file) And FileGetSize(log_file))
	{
		sqlite_error := FileRead(log_file, "UTF-8-RAW")
		If RegExMatch(sqlite_error, "m)^\(((?:(?!27\))(?!28\))\d)\d*)\)") ; check for any error code except 27 or 28
		{
			MsgBox("There was an sqlite3.exe error:`n" . sqlite_error)
			FileAppend("`n" . A_Now . "`n" . sqlite_error, A_ScriptDir . "\sqlite_log.txt", "UTF-8-RAW")
			ExitApp()
		}
		Else
		{
			FileAppend("`n" . A_Now . "`n" . sqlite_error, A_ScriptDir . "\sqlite_log.txt", "UTF-8-RAW")
			MsgBox("Check your log file for notices and warnings!")
		}
	}
}

CleanUp()
{
	FileDelete(A_ScriptDir . "\sql_command_file.txt")
	FileDelete(A_ScriptDir . "\log_file.txt")
	FileDelete(A_ScriptDir . "\sql_output_file.txt")
}

;***********************************************************************************
; READ IN DATA (COULD BE MEMORY INTENSIVE STORING ALL ENTRIES IN ASSOCIATIVE ARRAY)*
;***********************************************************************************

dict := {} ; use associative array to remove duplicates
FileEncoding("UTF-8")
Loop Files, source_files
{
	Loop Read, A_LoopFileFullPath
	{
		dict[A_LoopReadLine] := 1
	}
}

;***************************
; CREATE DATABASE AND TABLE*
;***************************

sql_cmd := "CREATE TABLE IF NOT EXISTS glossary (id INTEGER PRIMARY KEY, chinese TEXT, english TEXT)"
ExecuteSql("CREATE", sql_cmd)

;**********************************************************
; CREATE INSERT STATEMENT (COULD ALSO BE MEMORY INTENSIVE)*
;**********************************************************

counter := 0
insert_query := "INSERT INTO glossary (chinese, english) VALUES"
For key, value In dict
{
	counter++
	c_e := StrSplit(key, A_Tab,, 2)
	insert_query .= '("' . c_e[1] . '", "' . c_e[2] . '"),'
}
insert_query := RegExReplace(insert_query, ',$', ';') ; replace trailing comma with semicolon

;**************************
; EXECUTE INSERT STATEMENT*
;**************************

sql_cmd := insert_query
ExecuteSql("INSERT", sql_cmd)
MsgBox(counter . " row(s) inserted.")

;*****************************
; MAKE A QUERY (FUZZY SEARCH)*
;*****************************

;search_query := Clipboard ; could set up a hotkey and then grab search query from clipboard
search_query := '職業'
sql_cmd := "SELECT chinese, english FROM glossary WHERE chinese LIKE '%" . search_query . "%'"
result := ExecuteSql("QUERY", sql_cmd)
;MsgBox(result)

;***********************************
; PROCESS RESULTS IN AHK (OPTIONAL)*
;***********************************

counter := 0
result_string := ' search query results for: ' . search_query . '`n'
Loop Parse, result, "`n", "`r"
{
	If InStr(A_LoopField, '|')
	{
		counter++
		c_e := StrSplit(A_LoopField, '|',, 2)
		result_string .= A_Tab . c_e[1] . A_Tab . c_e[2] . '`n'
	}
}
result_string := counter . result_string
MsgBox(result_string)

;****************************************
; CLEAN UP FILES PRODUCED BY SQLITE3.EXE*
;****************************************

CleanUp()