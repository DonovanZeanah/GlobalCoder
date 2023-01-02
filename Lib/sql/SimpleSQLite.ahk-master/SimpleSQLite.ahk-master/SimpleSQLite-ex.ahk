#include simplesqlite.ahk

DBFileName := A_WorkingDir "\DBFile2.db"
DB := new SQLite3Connector(DBFileName)
DB.OpenDB(DBFileName)
sql := "CREATE TABLE contacts (contact_id INTEGER PRIMARY KEY,first_name TEXT NOT NULL,last_name TEXT NOT NULL,email TEXT NOT NULL UNIQUE,phone TEXT NOT NULL UNIQUE);"
DB.Exec(SQL)
return