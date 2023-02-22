; namespace DBA

class SQLite
{
	GetVersion(){
		return SQLite_LibVersion()
	}
	
	SQLiteExe(dbFile, commands, &output){
		return SQLite_SQLiteExe(dbFile, commands, output)
	}
	
	__New(){
		throw Exception("This is a static Class. Don't create Instances from it!",-1)
	}
}

/*
	Represents a Connection to a SQLite Database
*/
class DataBaseSQLLite extends DBA.DataBase
{
	_handleDB := 0
	
	__New(handleDB){
		this._handleDB := handleDB
		if(!this.IsValid())
		{
			throw Exception("Can not create a DataBaseSQLLite instance, because the connection handle is not valid!")
		}
		gDBA_ArchLogger.Log("New DataBaseSQLLite: Handle @" handleDB)
	}
	
	
	Close(){
		;gDBA_ArchLogger.Log("DataBaseSQLLite: Close DB Handle @" handleDB)
		return SQLite_CloseDB(this._handleDB)
	}
	
	IsValid(){
		return (this._handleDB != 0)
	}
	
	GetLastError(){
		code := 0
		SQLite_ErrCode(this._handleDB, code)
		return code
	}
	
	GetLastErrorMsg(){
		msg := ""
		SQLite_ErrMsg(this._handleDB, msg)
		return msg
	}
	
	SetTimeout(timeout := 1000){
		return SQLite_SetTimeout(this._handleDB, timeout)
	}
	
	
   ErrMsg() {
      if (RC := DllCall("SQLite3\sqlite3_errmsg", "UInt", this._handleDB, "Cdecl UInt"))
         return StrGet(RC, "UTF-8")
      return ""
   }

   ErrCode() {
      return DllCall("SQLite3\sqlite3_errcode", "UInt", this._handleDB, "Cdecl UInt")
   }

   Changes() {
      return DllCall("SQLite3\sqlite3_changes", "UInt", this._handleDB, "Cdecl UInt")
   }
	
	
	/*
		Querys the DB and returns a RecordSet
	*/
	OpenRecordSet(sql, editable := false){
		
		if( this.IsValid() )
		{
			rs := new DBA.RecordSetSqlLite(this, SQlite_Query(this._handleDB, sql))
			;myliters := new DBA.RecordSetSqlLite
			;myrs := new DBA.RecordSet
			
			;MsgBox % "DBA.RecordSetSqlLite params:`t" rs.TestRecordSet()
			;MsgBox % "DBA.RecordSetSqlLite:`t"myliters.TestRecordSet()
			;MsgBox % "DBA.RecordSet:`t" myrs.TestRecordSet()
			
			return rs
		}else
			throw Exception("NotSupportedException: There is no valid DB Connection, OpenRecordSet requires a valid connection.",-1)
	}
	
	/*
		Querys the DB and returns a ResultTable or true/false
	*/
	Query(sql){
		
		ret := gDBA_null
		
			if (RegExMatch(sql, "i)^\s*SELECT\s")){ ; check if this is a selection query
				
				try
				{
					ret := this._GetTableObj(sql)
				} catch e
					throw Exception("Select Query failed.`n`n" sql "`n`nChild Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line, -1)
			} else {
				 
				try
				{
					ret := SQLite_Exec(this._handleDB, sql)
				} catch e
					throw Exception("Non Selection Query failed.`n`n" sql "`n`nChild Exception:`n" e.What " `n" e.Message, -1)
			}
			
		return ret
	}
	
	EscapeString(str){
		; StrReplace() is not case sensitive
		; check for StringCaseSense in v1 source script
		; and change the CaseSense param in StrReplace() if necessary
		str := StrReplace(str, "'", "''") ; replace all single quotes with double single-quotes. pascal escape'
		return str
	}
	
	QuoteIdentifier(identifier) {
		; ` characters are actually valid. Technically everthing but a literal null U+0000.
		; Everything else is fair game: http://dev.mysql.com/doc/refman/5.0/en/identifiers.html
		; StrReplace() is not case sensitive
		; check for StringCaseSense in v1 source script
		; and change the CaseSense param in StrReplace() if necessary
		identifier := StrReplace(identifier, "`, ```, All",,,, 1)
		return "``" identifier "``"
	}
	
	
	BeginTransaction(){
		this.Query("BEGIN TRANSACTION;")
	}
	
	EndTransaction(){
		this.Query("COMMIT TRANSACTION;")
	}
	
	Rollback(){
		this.Query("ROLLBACK TRANSACTION;")
	}
	
	InsertMany(records, tableName){
		if(!is(records, Collection) || records.IsEmpty())
			return false
		
		colString := ""
		valString := ""
		columns := {}
		
		for column, value in records.First()
		{
			colString .= "," this.QuoteIdentifier(column)
			valString .= ",?"
			columns[column] := A_Index
		}
		sql := "INSERT INTO " this.QuoteIdentifier(tableName) "`n(" SubStr(colstring, 2) ")`nVALUES`n(" SubStr(valString, 2) ")" 
		
		
		types := []
		for i,row in this._GetTableObj("PRAGMA table_info(" this.QuoteIdentifier(tableName) ")").Rows
		{
			if (columns.Has(row.name)){
				;MsgBox,0,Error,  % "row name found: " row.name "`nTypes: " row.type  ; #DEBUG
				types[columns[row.name]] := row.types
			}
		}
		
		
		this.BeginTransaction()
		
		query := SQLite_Query(this._handleDB, sql) ;prepare the query
		if ErrorLevel
			MsgBox(ErrorLevel)
		
		try
		{
			for i, record in records
			{
				for col, val in record
				{
					if (!columns.Has(col))
						throw Exception("Irregular params: Column not found: [" col "] in`nTable Columns:" this.printKeys(columns))
					fieldType := "auto"
					if(types.Has(columns[col]))
						fieldType := types[columns[col]]
					
					ret := SQLite_bind(query, columns[col], val, fieldType)
					;MsgBox % " bind returned " ret
				}
				SQLite_Step(query)
				SQLite_Reset(query)
			}
		}
		catch e
		{
			this.Rollback()
			throw Exception("InsertMany failed.`n`nChild Exception:`n" e.What " `n" e.Message, -1)
		}
		SQLite_QueryFinalize(query)
		this.EndTransaction()
		return True
	}
	
	printKeys(arr){
		str := ""
		for key, val in arr
		{
			str .= key ","
		}
		return str
	}
	
	Insert(record, tableName){
		col := new Collection()
		col.Add(record)
		return this.InsertMany(col, tableName)
	}
	
	/*
		deprecated
	*/
	_GetTableObj(sql, maxResult := -1) {
		
		err := 0, rc := 0, GetRows := 0
		i := 0
		rows := cols := 0
		names := new Collection()
		dbh := this._handleDB

		SQLite_LastError(" ")

		if(!_SQLite_CheckDB(dbh)) {
			SQLite_LastError("ERROR: Invalid database handle " . dbh)
			ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
			return False
		}

		if (maxResult < -1)
			maxResult := -1
		mytable := ""
		Err := 0
		
		_SQLite_StrToUTF8(SQL, UTF8)
		RC := DllCall("SQlite3\sqlite3_get_table", "Ptr", dbh, "Ptr", UTF8, "Ptr*", &mytable, "Ptr*", &rows, "Ptr*", &cols, "Ptr*", &err, "Cdecl Int")
				   
		If (ErrorLevel) {
		  SQLite_LastError("ERROR: DLLCall sqlite3_get_table failed!")
		  Return False
		}
		If (rc) {
		  SQLite_LastError(StrGet(err, "UTF-8"))
		  DllCall("SQLite3\sqlite3_free", "Ptr", err, "cdecl")
		  ErrorLevel := rc
		  return false
		}

		

	   if (maxResult = 0) {
		  DllCall("SQLite3\sqlite3_free_table", "Ptr", mytable, "Cdecl")   
		  If (ErrorLevel) {
			 SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
			 Return False
		  }
		  Return True
	   }
	   
	   if (maxResult = 1)
		  GetRows := 0
	   else if (maxResult > 1) && (maxResult < rows)
		  GetRows := MaxResult
	   else
		  GetRows := rows
	   Offset := 0
	   
	   Loop cols
	   {
		  names.Add(StrGet(NumGet(mytable+0, Offset), "UTF-8"))
		  Offset += A_PtrSize
	   }

		myRows := new Collection()
		Loop GetRows {
			i := A_Index
			fields := new Collection()
			Loop Cols
			{
				fields.Add(StrGet(NumGet(mytable+0, Offset), "UTF-8"))
				Offset += A_PtrSize
			}
			myRows.Add(new DBA.Row(Names, fields))
		}
		tbl := new DBA.Table(myRows, Names)
		
		; Free Results Memory
		DllCall("SQLite3\sqlite3_free_table", "Ptr", mytable, "Cdecl")   
		if (ErrorLevel) {
			SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
			return false
		}
		return tbl
	}
	

   ReturnCode(RC) {
      static RCODE := {SQLITE_OK: 0                     , SQLITE_ERROR: 1                     , SQLITE_INTERNAL: 2                     , SQLITE_PERM: 3                     , SQLITE_ABORT: 4                     , SQLITE_BUSY: 5                     , SQLITE_LOCKED: 6                     , SQLITE_NOMEM: 7                     , SQLITE_READONLY: 8                     , SQLITE_INTERRUPT: 9                     , SQLITE_IOERR: 10                     , SQLITE_CORRUPT: 11                     , SQLITE_NOTFOUND: 12                     , SQLITE_FULL: 13                     , SQLITE_CANTOPEN: 14                     , SQLITE_PROTOCOL: 15                     , SQLITE_EMPTY: 16                     , SQLITE_SCHEMA: 17                     , SQLITE_TOOBIG: 18                     , SQLITE_CONSTRAINT: 19                     , SQLITE_MISMATCH: 20                     , SQLITE_MISUSE: 21                     , SQLITE_NOLFS: 22                     , SQLITE_AUTH: 23                     , SQLITE_FORMAT: 24                     , SQLITE_RANGE: 25                     , SQLITE_NOTADB: 26                     , SQLITE_ROW: 100                     , SQLITE_DONE: 101}          ; Successful result
      return RCODE.Has(RC) ? RCODE[RC] : ""
   }	
}
