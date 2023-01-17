CurHK:="F1"                                    ;Have a starting/default key
Hotkey % CurHK,DDHK                            ;Set that key as a default

Gui Add,DropDownList,gChange vNewHK,F1|F2|F3   ;Create a DDL with the keys
Gui Show                                       ;Show the Gui
Return                                         ;Done here

Change:                                        ;Triggered when DDL changed
  Gui Submit,NoHide                            ;  Get the Gui's contents
  HotKey % CurHK,,Off                          ;  Disable old key
  HotKey % NewHK,DDHK                          ;  Assign new key (from DDL)
  MsgBox % CurHK " is Off.`n" NewHK " is On."  ;  Show it's been done
  CurHK:=NewHK                                 ;  Assign new variable to old
Return                                         ;End code block

DDHK:                                          ;DDL hotkey triggered
  MsgBox % "You tiggered " CurHK "!"           ;  Show it's been fired
Return                                         ;End code block