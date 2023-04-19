#warn all, off

#include "D:\lib\V2\SQLite\cSQLite.ahk"
#include "D:\lib\V2\class_json.ahk"

loggerObj := Logger()
timelineObj := Timeline(loggerObj)

timelineObj.logEventjson("First event")
sleep(1000)
timelineObj.logEventjson("Second event")



timeline1 := Timeline(loggerobj)
timeline1.AddEvent("start", A_TickCount)
Sleep(1000)
timeline1.AddEvent("middle", A_TickCount)
Sleep(1000)
timeline1.AddEvent("end", A_TickCount)

timeline1.logevents()
;timeline1.logeventsjson()

startTime := timeline1.GetEventTime("start")
middleTime := timeline1.GetEventTime("middle")
endTime := timeline1.GetEventTime("end")

MsgBox("Start time:" startTime "`nMiddle time:" middleTime "`nEnd time:" endTime)
return

 



;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
WriteFile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
}
AppendFile(whichFile, text) {
    if FileExist(whichFile)
        fileObj := FileOpen(whichFile, "a")
    else
        fileObj := FileOpen(whichFile, "w")
    fileObj.Seek(0, 2)
    fileObj.Write(text)
    fileObj.Close()
}
ReadFile(whichFile) {
   fileObj := FileOpen(whichFile, "r")
   fileObj.Seek(0, 0)
   text := fileObj.Read()
   fileObj.Close()
   return text
}
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
class Employee{
    ; Constructor method
    __New(age, name, title)
    {
        this.age := age
        this.name := name
        this.title := title
    }

    ; Method to display employee info
    ShowInfo()
    {
        MsgBox ("Name: " . this.name . "`nAge: " . this.age . "`nTitle: " . this.title)
    }
    
}
class Logger {
    fileObj := {}
    
    __New() {
        this.fileObj := FileOpen(A_WorkingDir . "\logfile2.txt", "a", "UTF-8")
    }
    
    logEvent(event) {
		if IsObject(event) {
			event := this.convertObjectToString(event)
		}
        this.fileObj.Write(A_Now . ": " . event . "`n")
    }
	convertObjectToString(obj) {
    if (obj.HasMethod("ToString")) {
        return obj.ToString()
    } else {
        ;return JSON.stringify(obj)
        return JSON.stringify(obj)
    	}
	}
    
    __Delete() {
		this.fileObj.Write(";\\========" . "`n")
        this.fileObj.Close()
    }
}
class Timeline {
    logger := {}
    
    __New(loggerObj) {
        this.logger := loggerObj
		this.events := []

    }
    
    logEvent(event) {
        this.logger.logEvent(event)
    }
	AddEvent(name, time) {
        event := { name: name, time: time }
        ;event := { name: name, time: time, note: note }
        this.events.push(event)
		;this.logEvents()
		;this.logeventsjson()
		;event2 := Map("name", name, "time", time)
    }
    
    GetEventTime(name) {
        for i, event in this.events {
            if (event.name = name) {
                return msgbox(event.time)
            }
        }
        return 0  ; event not found
    }
	LogEvents() {
        for i, event in this.events {
            if (event.HasProp("name")) {
                 ;msgbox(event.time)
				 this.logevent(event.name)
				 ;this.logger.logevent(event)
            }
			else 
			{
				 msgbox("no event")
				 return 0
			}
        }
        return 1  ; event not found
    }
	LogEventsJson() {
        for i, event in this.events {
            if (event.HasProp("name")) {
                 ;msgbox(event.time)
				 ;this.logevent(event.name)
				 this.logger.logevent(event)
            }
			else 
			{
				 msgbox("no event")
				 return 0
			}
        }
        return 1  ; event not found
    }
}
/* class JSON {
    static Encode(obj) {
        local out
        switch VarType(obj) {
            case "Array":
                out := "["
                loop(obj.MaxIndex)
				{
				
                {
                    if (A_Index > 1)
					
                        out .= ","
                    out .= JSON.Encode(obj[A_Index])
                }
                out .= "]"
                break
				}
            case "Object":
                out := "{"
                first := 1
                for key, val in obj 
				{
                    if (!first)
					{
                        out .= ","
                    first := 0
                    out .= JSON.Encode(key) . ":" . JSON.Encode(val)
                }
                out .= "}"
                break
				}
            case "String":
			
                out := "''" . EscapeString(obj) . "''"
                break
            case "Number":
                out := obj
                break
            case "Float":
                out := Float(obj) ;, "0.0")
                break
            case "Integer":
                out := obj
                break
            case "Boolean":
                out := obj ? "true" : "false"
                break
            case "Null":
                out := "null"
                break
            default:
                out := "null"
                break
        }
        return out
    }

    static EscapeString(str) {
        return RegExReplace(str, "(?<!\\)\\'", "\\\'")
    } 
}*/


class Database {
    __New(databaseFile) {
        ; open database connection
        this.connection := SQLite3_Open(databaseFile)
    }

    Query(sql) {
        ; execute SQL statement and get result set
        result := SQLite3_Query(this.connection, sql)
        
        ; loop through result set and do something with each row
        While SQLite3_Fetch(result)
        {
            MsgBox(SQLite3_Column(result, 0) . " " . SQLite3_Column(result, 1))
        }
        
        ; close result set
        SQLite3_Free(result)
    }

    __Delete() {
        ; close database connection when object is deleted
        SQLite3_Close(this.connection)
    }
}
class Repository {
    __New(database) {
        this.database := database
    }
    
    GetUser(userId) {
        sql := "SELECT * FROM Users WHERE Id = " . userId
        this.database.Query(sql)
        ; parse query result and return user object
    }
}
class UserService {
    __New(repository) {
        this.repository := repository
    }
    
    GetUser(userId) {
        return this.repository.GetUser(userId)
    }
}
class MFile {

	__New(fileName, mode := "r", encoding := "UTF-8") {
		this.fileName := fileName
		this.mode := mode
		this.encoding := encoding
		this.file := FileOpen(this.fileName, this.mode, this.encoding)
	}
	WriteLn(str) {
        ; write string to file followed by a line break
        super.Write(str . "`n")
    }
	Writefile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
	}
	Runfile(whichFile, text := "") {
		run(whichfile) 
		return
	}
	ReadFile(whichFile) {
	fileObj := FileOpen(whichFile, "r")
	fileObj.Seek(0, 0)
	text := fileObj.Read()
	fileObj.Close()
	return text
	}
	
	Close() {
		FileClose(this.file)
	}
	__Delete() {
		this.Close()
	}
}




/* class MyFile extends File {
    __New(fileName, mode := "r", encoding := "UTF-8") {
        ; call parent constructor to create file object
        ;super.__New(fileName, mode, encoding)
    } 
    WriteLn(str) {
        ; write string to file followed by a line break
        super.Write(str . "`n")
    }
    ReadAll() {
        ; read the entire file and return its contents as a string
        super.Seek(0)  ; move to the beginning of the file
        return super.Read(super.Length())
    }
	WriteFile(whichFile, text := "") {
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
   fileObj.Close()
	}
	ReadFile(whichFile) {
	fileObj := FileOpen(whichFile, "r")
	fileObj.Seek(0, 0)
	text := fileObj.Read()
	fileObj.Close()
	return text
	}
	Append(whichFile, text) {
		if FileExist(whichFile)
			fileObj := FileOpen(whichFile, "a")
		else
			fileObj := FileOpen(whichFile, "w")
		fileObj.Seek(0, 2)
		fileObj.Write(text)
		fileObj.Close()
	}
} */

/* class Logger {
    __New() {
        ;this.logFile := "C:\log.txt"  ; change this to your desired log file path
		this.logFile := a_workingdir . "\log.txt"  ; change this to your desired log file path
    }
    
    Log(msg) {
        now := DateTime.Now
        logMsg := "[" . now.ToString("{yyyy}-{MM}-{dd}__{HH}:{mm}:{ss}") . "] " . msg . "`n"
        writefile(this.logFile, logMsg)
		Run(this.logFile)
		MsgBox(this.logFile)
    }
	Writefile(whichFile, text := "") {
		    if !FileExist(whichFile)
   fileObj := FileOpen(whichFile, "w")
   fileObj.Write(text)
  ; fileObj.Close()
	}
	AppendFile(whichFile, text) {
    if FileExist(whichFile)
        fileObj := FileOpen(whichFile, "w")
    fileObj.Seek(0, 2)
    fileObj.Write(text)
    fileObj.Close()
}
}
class Timeline { 
    __New() {
        this.events := []
    }
    
    AddEvent(name, time) {
        event := { name: name, time: time }
        this.events.push(event)
		event2 := Map("name", name, "time", time)
    }
    
    GetEventTime(name) {
        for i, event in this.events {
            if (event.name = name) {
                return msgbox(event.time)
            }
        }
        return 0  ; event not found
    }
}
*/

/* testfile := A_WorkingDir . "/text.txt"
test := ReadFile(testfile)
MsgBox(test)

; example usage
file1 := MFile(A_ScriptDir . "\test.txt", "w", "UTF-8")
file1.WriteFile(file1.fileName, "Hello world!")
file1.runfile(file1.fileName)
fileval := file1.Readfile(file1.fileName)
MsgBox(fileval)



databasefile := "D:\(github)\GlobalCoder\gc\GlobalCoder\WordlistLearned.db"

connectionString := "Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;"
database1 := Database(databasefile)
;database1 := Database(connectionString)
repository1 := Repository(database1)
userService1 := UserService(repository1)

user := userService1.GetUser(123)


; Create an instance of Employee with age 25, name John and title Manager
emp1 := Employee(25, "John", "Manager")
; Call ShowInfo method on emp1 object
emp1.ShowInfo()
MsgBox(emp1.age) */