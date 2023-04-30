; ======================================================================================================================
; Script Function:  Sample script for Class_SQLiteDB.ah2
; AHK Version:      v2 beta-1
; Tested on:        Win 10 Pro (x64)
; Author:           just me
; ======================================================================================================================
; AHK Settings
; ======================================================================================================================
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
OnExit((*) => Main_Close())
; ======================================================================================================================
; Includes
; ======================================================================================================================
#Include Class_SQLiteDB.ah2
; ======================================================================================================================
; Start & GUI
; ======================================================================================================================
CBBSQL := ["SELECT * FROM Test"]
DBFileName := A_ScriptDir . "\TEST.DB"
Title := "SQL Query/Command ListView Function GUI"
If FileExist(DBFileName)
   Try FileDelete(DBFileName)
Main := Gui("+Disabled +LastFound +OwnDialogs", Title)
Main.MarginX := 10
Main.MarginY := 10
Main.OnEvent("Close", Main_Close)
Main.OnEvent("Escape", Main_Close)
Main.AddText("w100 h20 0x200 vTX", "SQL statement:")
Main.AddComboBox("x+0 ym w590 Choose1 Sort vSQL", CBBSQL)
Main["SQL"].GetPos(&X, &Y, &W, &H)
Main["TX"].Move( , , , H)
Main.AddButton("ym w80 hp Default", "Run").OnEvent("Click", RunSQL)
Main.AddText("xm h20 w100 0x200", "Table name:")
Main.AddEdit("x+0 yp w150 hp vTable", "Test")
Main.AddButton("Section x+10 yp wp hp", "Get Table").OnEvent("Click", GetTable)
Main.AddButton("x+10 yp wp hp", "Get RecordSet").OnEvent("Click" , GetRecordSet)
Main.AddGroupBox("xm w780 h330", "Results")
LV := Main.AddListView("xp+10 yp+18 w760 h300 vResultsLV +LV0x00010000")
SB:= Main.AddStatusBar()
Main.Show()
; ======================================================================================================================
; Use Class SQLiteDB : Initialize and get lib version
; ======================================================================================================================
SB.SetText("SQLiteDB new instance")
DB := SQLiteDB()
Sleep(1000)
SB.SetText("Version")
Main.Title := Title . " - SQLite3.dll v " . SQLiteDB.Version
Sleep(1000)
; ======================================================================================================================
; Use Class SQLiteDB : Open/Create database and table
; ======================================================================================================================
SB.SetText("OpenDB")
If !DB.OpenDB(DBFileName) {
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
   ExitApp
}
Sleep(1000)
SB.SetText("Exec: CREATE TABLE")
SQL := "CREATE TABLE Test (Name, Fname, Phone, Room, PRIMARY KEY(Name ASC, FName ASC));"
If !DB.Exec(SQL)
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
Sleep(1000)
SB.SetText("Exec: INSERT 1000 rows")
Start := A_TickCount
DB.Exec("BEGIN TRANSACTION;")
SQLStr := ""
_SQL := "INSERT INTO Test VALUES('Näme#', 'Fname#', 'Phone#', 'Room#');"
Loop 1000 {
   SQL := StrReplace(_SQL, "#", A_Index)
   SQLStr .= SQL
}
If !DB.Exec(SQLStr)
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
DB.Exec("COMMIT TRANSACTION;")
SQLStr := ""
SB.SetText("Exec: INSERT 1000 rows done in " . (A_TickCount - Start) . " ms")
Sleep(1000)
; ======================================================================================================================
; Use Class SQLiteDB : Using Exec() with callback function
; ======================================================================================================================
SB.SetText("Exec: Using a callback function")
SQL := "SELECT COUNT(*) FROM Test;"
DB.Exec(SQL, SQLiteExecCallBack)
; ======================================================================================================================
; Use Class SQLiteDB : Get some informations
; ======================================================================================================================
SB.SetText("LastInsertRowID")
If !DB.LastInsertRowID(&RowID)
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
LV.Opt("-Redraw")
LV.Delete()
Loop LV.GetCount("Col")
   LV.DeleteCol(1)
LV.InsertCol(1,"", "LastInsertedRowID")
LV.Add("", RowID)
LV.Opt("+Redraw")
Sleep(1000)
; ======================================================================================================================
; Start of query using GetTable() : Get the first 10 rows of table Test
; ======================================================================================================================
SQL := "SELECT * FROM Test;"
SB.SetText("SQLite_GetTable : " . SQL)
Result := ""
If !DB.GetTable(SQL, &Result, 10)
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
ShowTable(LV, Result)
Sleep(1000)
; ======================================================================================================================
; Start of query using Query() : Get the column names for table Test
; ======================================================================================================================
SQL := "SELECT * FROM Test;"
SB.SetText("Query : " . SQL)
RecordSet := ""
If !DB.Query(SQL, &RecordSet)
   MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
LV.Opt("-ReDraw")
LV.Delete()
ColCount := LV.GetCount("Col")
Loop ColCount
   LV.DeleteCol(1)
LV.InsertCol(1,"", "Column names")
Loop RecordSet.ColumnCount
   LV.Add("", RecordSet.ColumnNames[A_Index])
LV.ModifyCol(1, "AutoHdr")
RecordSet.Free()
LV.Opt("+ReDraw")
; ======================================================================================================================
; End of query using Query()
; ======================================================================================================================
Main.Opt("-Disabled")
Return
; ======================================================================================================================
; Gui Subs
; ======================================================================================================================
Main_Close(*) {
   If !DB.CloseDB()
      MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
   ExitApp
}
; ======================================================================================================================
; Other Subs
; ======================================================================================================================
; "One step" query using GetTable()
; ======================================================================================================================
GetTable(GuiCtrl, Info) {
   Table := Main["Table"].Text
   SQL := "SELECT * FROM " . Table . ";"
   SB.SetText("GetTable: " . SQL)
   Start := A_TickCount
   Result := ""
   If !DB.GetTable(SQL, &Result)
      MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
   ShowTable(LV, Result)
   SB.SetText("GetTable: " . SQL . " done (including ListView) in " . (A_TickCount - Start) . " ms")
}
; ======================================================================================================================
; Show results for prepared query using Query()
; ======================================================================================================================
GetRecordSet(GuiCtrl, Info) {
   Table := Main["Table"].Text
   SQL := "SELECT * FROM " . Table . ";"
   SB.SetText("Query: " . SQL)
   Start := A_TickCount
   RecordSet := ""
   If !DB.Query(SQL, &RecordSet)
      MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
   ShowRecordSet(LV, RecordSet)
   SB.SetText("Query: " . SQL . " done (including ListView) in " . (A_TickCount - Start) . " ms")
}
; ======================================================================================================================
; Execute SQL statement using Exec() / GetTable()
; ======================================================================================================================
RunSQL(CtrlObj, Info) {
   SQL := Trim(Main["SQL"].Text)
   If (SQL = "") {
      SB.SetText("No SQL statement entered!")
      Return
   }
   If (Main["SQL"].Value = 0)
      Main["SQL"].Add([SQL])
   If (SubStr(SQL, -1) != ";")
      SQL .= ";"
   Result := ""
   If RegExMatch(SQL, "i)^\s*SELECT\s") {
      SB.SetText("GetTable: " . SQL)
      If !DB.GetTable(SQL, &Result)
         MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
      Else
         ShowTable(LV, Result)
      SB.SetText("GetTable: " . SQL . " done!")
   }
   Else {
      SB.SetText("Exec: " . SQL)
      If !DB.Exec(SQL)
         MsgBox("Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode, "SQLite Error", 16)
      Else
         SB.SetText("Exec: " . SQL . " done!")
   }
}
; ======================================================================================================================
; Exec() callback function sample
; ======================================================================================================================
SQLiteExecCallBack(DB, ColumnCount, ColumnValues, ColumnNames) {
   This := ObjFromPtrAddRef(DB)
   Main.Opt("+OwnDialogs") ; required for the MsgBox
   MsgBox("SQLite version: " . SQLiteDB.Version . "`n" .
          "SQL statement: " . This.SQL . "`n" .
          "Number of columns: " . ColumnCount . "`n" .
          "Name of first column: " . StrGet(NumGet(ColumnNames, "Ptr"), "UTF-8") . "`n" .
          "Value of first column: " . StrGet(NumGet(ColumnValues, "Ptr"), "UTF-8"),
          A_ThisFunc, 0)
   Return 0
}
; ======================================================================================================================
; Show results
; ======================================================================================================================
ShowTable(LV, Table) {
   LV.Opt("-Redraw")
   LV.Delete()
   Loop LV.GetCount("Col")
      LV.DeleteCol(1)
   If (Table.HasNames) {
      Loop Table.ColumnCount
         LV.InsertCol(A_Index, "", Table.ColumnNames[A_Index])
      If (Table.HasRows) {
         Loop Table.Rows.Length
            LV.Add("", Table.Rows[A_Index]*)
      }
      Loop Table.ColumnCount
         LV.ModifyCol(A_Index, "AutoHdr")
   }
   LV.Opt("+Redraw")
}
; ----------------------------------------------------------------------------------------------------------------------
ShowRecordSet(LV, RecordSet) {
   LV.Opt("-Redraw")
   LV.Delete()
   Loop LV.GetCount("Col")
      LV.DeleteCol(1)
   If (RecordSet.HasNames) {
      Loop RecordSet.ColumnCount
         LV.InsertCol(A_Index, "", RecordSet.ColumnNames[A_Index])
   }
   If (RecordSet.HasRows) {
      If (RecordSet.Next(&Row) < 1) {
         MsgBox("Msg:`t" . RecordSet.ErrorMsg . "`nCode:`t" . RecordSet.ErrorCode, A_ThisFunc, 16)
         Return
      }
      Loop
         LV.Add("", Row*)
      Until (RC := RecordSet.Next(&Row)) < 1
   }
   If (RC = 0)
      MsgBox("Msg:`t" . RecordSet.ErrorMsg . "`nCode:`t" . RecordSet.ErrorCode, A_ThisFunc, 16)
   Loop RecordSet.ColumnCount
      LV.ModifyCol(A_Index, "AutoHdr")
   LV.Opt("+Redraw")
}