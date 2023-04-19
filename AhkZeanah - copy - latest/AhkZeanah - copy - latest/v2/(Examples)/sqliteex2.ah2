;**************
; REQUIREMENTS*
;**************

; AutoHotkey Version 2 (AutoHotkey_2.0-a100-52515e2)
; https://www.autohotkey.com/download/2.0/AutoHotkey_2.0-a100-52515e2.zip
; sqlite3.dll located in A_ScriptDir (i.e., the directory that contains this .ahk file)
; https://sqlite.org/2019/sqlite-dll-win32-x86-3270200.zip (32-bit)
; Or
; https://sqlite.org/2019/sqlite-dll-win64-x64-3270200.zip (64-bit)
; Class_SQLiteDB.ahk located in A_ScriptDir
; https://pastebin.com/mJ4gFVCv
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

;************************
; INCLUDE SQLITE WRAPPER*
;************************

#Include Class_SQLiteDB.ahk

;*******************************************
; SPECIFY NAME FOR DATABASE AND DATA SOURCE*
;*******************************************

db_file := A_ScriptDir . "\ce_glossary.sqlite"
;source_files := A_ScriptDir . "\chinese_english\*.txt"
source_files := A_ScriptDir . "\CC-CEDICT.txt"

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

;***********************************
; OPEN DATABASE OR CREATE A NEW ONE*
;***********************************

db := New SQLiteDb
If !db.OpenDb(db_file)
{
	MsgBox("SQLite Error OpenDb`n`nMessage: " . db.ErrorMsg . "`nCode: " . db.ErrorCode . "`nFile: " . db_file)
	ExitApp()
}

;***********************
; CREATE DATABASE TABLE*
;***********************

sql_cmd := "CREATE TABLE glossary (id INTEGER PRIMARY KEY, chinese TEXT, english TEXT)"
If !db.Exec(sql_cmd)
{
	MsgBox("SQLite CREATE Error`n`nMessage: " . db.ErrorMsg . "`nCode: " . db.ErrorCode . "`nQuery: " . sql_cmd)
	ExitApp()
}

;**********************************************************
; CREATE INSERT STATEMENT (COULD ALSO BE MEMORY INTENSIVE)*
;**********************************************************

insert_query := "INSERT INTO glossary (chinese, english) VALUES"
For key, value In dict
{
	c_e := StrSplit(key, A_Tab,, 2)
	insert_query .= '("' . c_e[1] . '", "' . c_e[2] . '"),'
}
insert_query := RegExReplace(insert_query, ',$', ';') ; replace trailing comma with semicolon

;**************************
; EXECUTE INSERT STATEMENT*
;**************************

sql_cmd := insert_query
result := db.Exec(sql_cmd)
If (result)
{
	MsgBox("Inserted " . db.Changes . " rows.")
}
Else
{
	MsgBox("SQLite Insert Error`n`nMessage: " . db.ErrorMsg . "`nCode: " . db.ErrorCode . "`nQuery: " . sql_cmd)
	ExitApp()
}

;*****************************
; MAKE A QUERY (FUZZY SEARCH)*
;*****************************

;search_query := Clipboard ; could set up a hotkey and then grab search query from clipboard
search_query := '職業'
query := "SELECT chinese, english FROM glossary WHERE chinese LIKE '%" . search_query . "%'"
sql_cmd := query
If !db.Query(sql_cmd, query_result)
{
	MsgBox("SQLite QUERY Error`n`nMessage: " . db.ErrorMsg . "`nCode: " . db.ErrorCode . "`nFile: " . db_file . "`nQuery: " . sql_cmd)
	ExitApp
}
search_result := ''
Loop
{
	result := query_result.Next(row)
	If !result
	{
		MsgBox("SQLite NEXT Error`n`nMessage: " . db.ErrorMsg . "`nCode: " . db.ErrorCode)
		ExitApp
	}
	If result = -1
	{
		Break
	}
	Loop query_result.ColumnCount
	{
		search_result .= row[A_Index] . A_Tab
	}
	search_result .= '`n'
}
query_result.Free()
MsgBox(search_result)