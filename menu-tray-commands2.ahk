;Create the last menu first, 'Sub' is the label to be executed when you click the item
Menu, Level3, Add, Item1, Sub
Menu, Level3, Add, Item2, Sub
Menu, Level3, Add, Item3, Sub
 
;Then attach it to the second menu as you create it
Menu, Level2, Add, Item1, :Level3
Menu, Level2, Add, Item2, :Level3
Menu, Level2, Add, Item3, :Level3
 
;Add this stack to the tray, 'Tray' is a special descriptor
Menu, Tray, Add, Item Menu, :Level2