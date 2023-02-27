Class JSONData {
	
	Init() {
	static __ := JSONData.Init()
	__HTMLFile := "<!DOCTYPE html>"
				. "<html>"
					. "<head>"
					. "<meta http-equiv=""X-UA-Compatible"" content=""IE=edge"">"
					. "<meta charset=""utf-8"" />"
					. "<title>HTMLFile</title>"
					. "<script>"
					. "var _null = null;"
					. "var JSONData = new Array();"
					. "function _delete(__o, __k) {"
					. "delete __o[__k];"
					. "}"
					. "</script>"
					. "</head>"
				. "<body>"
				. "</body>"
				. "</html>"
	(JSONData.oHTML:=ComObjCreate("HTMLFile")).write(__HTMLFile)
	}
	
	__New(__fileFullPath, __restore:=false) {
	
	static __i := -1

		if not (__f:=FileOpen(this.fileFullPath:=__fileFullPath, "r", "utf-8"))
	return false, ErrorLevel := (A_LastError == 2) ? "ERROR_FILE_NOT_FOUND" : (A_LastError == 3) ? "ERROR_PATH_NOT_FOUND" : A_LastError ; https://msdn.microsoft.com/fr-fr/library/windows/desktop/ms681382(v=vs.85).aspx
	
		try {
		(JSONData.oHTML.parentWindow.JSONData)[ (__restore) ? this.index : this.index:=++__i ] := JSONData.parse(__f.Read())
		} catch {
			__f.Close()
		return false, ErrorLevel:="ERROR_PARSE_ERROR"
		}
		__f.Close()
	
	return this
	}
	
		Class Enumerator {
			
			i := -1
			
			__New(__object) {
			try this.count := (this.keys:=JSONData.oHTML.parentWindow.Object.keys(this.object:=__object).slice()).length
			}
			next(ByRef __k:="", ByRef __v:="") {
				
				if (++this.i < this.count) {
					__k := (this.keys)[ this.i ], __v := (this.object)[__k]
				return true
				} return false, this.i:=-1
			
			}
		
		}
		
		stringify(__obj, __space:="") {
		return JSONData.oHTML.parentWindow.JSON.stringify(__obj,, __space)
		}
		parse(__str) {
		return JSONData.oHTML.parentWindow.JSON.parse(__str)
		}
		
			delete(__o, __k) {
			JSONData.oHTML.parentWindow._delete(__o, __k)
			}
		
		; ___________________________________________
		
		Class String {
		__New() {
		return JSONData.oHTML.parentWindow.String()
		}
		}
		Class Number {
		__New() {
		return JSONData.oHTML.parentWindow.Number()
		}
		}
		Class Object {
		__New() {
		return JSONData.oHTML.parentWindow.Object()
		}
		}
		Class Array {
		__New() {
		return JSONData.oHTML.parentWindow.Array()
		}
		}
		
		; ___________________________________________
		
		restore() {
		this := this.__New(this.fileFullPath, true)
		}
		updateData(__prettify:=4) {
		(__f:=FileOpen(this.fileFullPath, "w", "utf-8")).Write(JSONData.stringify(this.__data__, __prettify))
		__f.Close()
		}
	
			__data__[__args*] {
				get {
				return (JSONData.oHTML.parentWindow.JSONData)[ this.index ]
				}
				set {
				(JSONData.oHTML.parentWindow.JSONData)[ this.index ] := value
				}
			}
			
	getKeys(__prm*) {
	__o := this.__data__
		for __k, __v in __prm
			__o := (__o)[__v]
	return JSONData.oHTML.parentWindow.Object.getOwnPropertyNames(__o)
	}

}
