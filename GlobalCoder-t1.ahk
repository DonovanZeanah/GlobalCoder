Menu MyMenu, Add, Item 1, no
Menu MyMenu, Add, Item 2, no
Menu MyMenu, Add, Item B, no

; Retrieve the number of items in a menu.
item_count := DllCall("GetMenuItemCount", "ptr", MenuGetHandle("MyMenu"))

; Retrieve the ID of the last item.
last_id := DllCall("GetMenuItemID", "ptr", MenuGetHandle("MyMenu"), "int", item_count-1)

MsgBox, MyMenu has %item_count% items, and its last item has ID %last_id%.

no:
return