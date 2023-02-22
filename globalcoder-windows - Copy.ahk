
;winset()
;winactivate()
;window(){class}




winset(){
window := WinExist("A")
msgbox % "window: " window
return window
}




WinActivate(window){
msgbox % "win: " window
msgbox % "win: " window
WinActivate,  %window%
return
}

Class Window{
   __New(){
   static num := new tmp
;    Class Tmp{
       A:=1++
        Static B:=1++
       
   msgbox % num
;}   
}
    
    Get(){
        WingetTitle TitleVar, A ; Get title from Active window.
        This.Title:=TitleVar ; Set TitleVar to This.Title
        
        WinGet IDVar,ID,A ; Get ID from Active window.
        This.ID:=IDVar ; Set IDVar to This.ID
    }

    Activate(){ ;Activates window with Title - This.Title 
        IfWinExist, % "ahk_id "This.ID
            WinActivate % "ahk_id " This.ID
        else
            MsgBox % "There is no Window with ID: "This.ID
    }  
    AnnounceWinProps(){ ;Create message box with title and ID
    
        MsgBox % "Title is: " This.Title "`n ID is: " This.ID
    }
}