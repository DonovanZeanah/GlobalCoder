
Menu, Tray, Add, Search Food.com, ^!r

Gui, Add, Edit, vMySearch
 Gui, Add, Button, Default gSearch, Search 
 Return 

 ^!r:: 
 Gui, Show 
 send, {tab}
 Return 


 Search: 
 Gui, Submit, ;Nohide 
 Run, http://www.food.com/recipe-finder/all/%MySearch% 
 MySearch := ""
  Guicontrol,, MySearch ;Nohide 

 Return