;header
#include <getheader>
getheader(string_dirpaths, obj_filepaths)
{
    if (string_dirpath IsObject(filesystem.di))
}


/*
Hotstring Menu Function HotstringMenu(TextList) and Subroutine HotstringMenuAction:
=============================================
Found at:
http://www.computoredge.com/AutoHotkey/Free_AutoHotkey_Scripts_and_Apps_for_Learning_and_Generating_Ideas.html#HotstringMenu

Originally, discussed the in the book, "Beginning AutoHotkey Hotstrings: 
A Practical Guide for Creative AutoCorrection, Text Expansion and Text Replacement", found at:
https://www.computoredgebooks.com/Beginning-AutoHotkey-Hotstrings-All-File-Formats_c40.htm?sourceCode=AHKScript

The following function and subroutine creates a menu of replacement option when
activating the a Hotstring. Call the function in the form:


:x:flux::TextMenu("Flux | &0,Flux #&1,Flux #&2")
The vertical bar delimiter | allows the addition of descriptive tags and single-key
shortcuts (e.g. &0 for the zero key) which will not appear in the replacement text.

November 22, 2019, Now includes the three-parameter variadic function 
HotstringMenuV(MenuType,Handle,MenuArray*) for using simple and associative
arrays.
*/

; Examples of arrays being set up in the auto-execute section:

Fractions := ["⅒","⅑","⅛","⅐","⅙","⅕","¼","⅓","⅜","⅖","½","⅗","⅝","⅔","¾","⅘","⅚","⅞"]
FractionsA := {⅒: "one-tenth",⅑: "one-ninth",⅛: "one-eight",⅐: "one-seventh",⅙: "one-sixth Brk",⅕: "one-fifth",¼: "one-fourth",⅓: "one-third Brk",⅜: "three-eights",⅖: "two-fifths",½: "one-half",⅗: "three-fifths",⅝: "five-eights",⅔: "two-thirds",¾: "three-fourths",⅘: "four-fifths",⅚: "five-sixths",⅞: "seven-eights"}
ArrowsA := {⇐: "Left arrow &1"
          ,⇔: "Double arrow &5",⇒: "Right arrow &3"
          ,⇑: "Up arrow &2",⇓: "Down arrow &4"}

Return
:x:flux::TextMenu("Flux | &0,Flux #&1,Flux #&2")

; Original HotstringMenu() function:

HotstringMenu(TextList)
{
  MenuItems := StrSplit(TextList, "`,")
  Loop % MenuItems.MaxIndex()
  {
    Menu, MyMenu, add, % MenuItems[A_Index], HotstringMenuAction
  }
  Menu, MyMenu, Show
  Menu, MyMenu, DeleteAll
}

; Original called menu Label subroutine
HotstringMenuAction:
  InsertText := StrSplit(A_ThisMenuItem, "|")
  TextOut := StrReplace(RTrim(InsertText[1]), "&")
  SendInput {raw}%TextOut%%A_EndChar%
Return


;1
;1 Variadic function HotstringMenuV(MenuType,Handle,MenuArray*)
HotstringMenuV(MenuType,Handle,MenuArray*)
{
  For Each, Item in MenuArray
    If (MenuType = "A")         ; Add alphabetic single-key menu shortcuts
      Menu, MyMenu, Add, % "&" Chr(Each+96) " " Item, % Handle
    Else If (MenuType = "N")   ; Add numeric single-key menu shortcuts
      Menu, MyMenu, Add, % "&" Each "  " Item, % Handle
    Else If (MenuType = "T")    ; For use with associative arrays
      If (InStr(Item,"Brk"))      ; Add column breaks to long menus
        Menu, MyMenu, Add, % Each " | " StrReplace(Item,"Brk"), % Handle, +BarBreak
      Else
        Menu, MyMenu, Add, % Each " | " Item, % Handle
    Else    ; Default menu item. Use "" in calling function
      Menu, MyMenu, add, % Item , % Handle
  Menu, MyMenu, Show
  Menu, MyMenu, DeleteAll
}

; Additional menu Label subroutine for variadic function:

MenuShortcut:
  TextOut := SubStr(A_ThisMenuItem, 4)
  SendInput {raw}%TextOut%%A_EndChar%
Return

; HotstringMenu() Sample Menus
; Delete or comment out /* … */ to remove.

:x*?:$``::HotstringMenu("¢,£,¥,€")
:x*?:f``::HotstringMenu("⅒,⅑,⅛,⅐,⅙,⅕,¼,⅓,⅜,⅖,½,⅗,⅝,⅔,¾,⅘,⅚,⅞")
:x*?:s``::HotstringMenu("© | Copyright,® | Registered TradeMark,™|Trademark,° | Degree,• | Bullet,· | Dot,… | ellipsis,¶  | Paragraph")
:x*?:m``::HotstringMenu("±,×,÷,≈,≅,∑,ƒ,¹,²,³")
:x*?:b``::HotstringMenu("🦄 | Unicorn &1,🐀 | Rat &2
          ,🐁 | Mouse &3,🐂 | Ox &4,🐃 | Water Buffalo &5
          ,🐄 | Cow &6,❓ | Red &7,❔ | White &8")
:x:flux::HotstringMenu("Flux|&0,Flux #&1,Flux #&2")

; HotstringMenuV() Sample Menus
; Delete or comment out /* … */ to remove.

:x:brb::HotstringMenuV("C","HotstringMenuAction","FractionA")
:x*:frt::HotstringMenuV("A","MenuShortcut",Fractions*)
:x*:frct::HotstringMenuV("T","HotstringMenuAction",FractionsA*)
:x:bn::HotstringMenuV("N","MenuShortcut","Ox","Water Buffalo","Cow")
:x:ba::HotstringMenuV("A","MenuShortcut","Ox","Water Buffalo","Cow")
:x*?:b2``::HotstringMenuV("" ,"HotstringMenuAction","🦄 | Unicorn &1","🐀 | Rat &2"
                                       ,"🐁 | Mouse &3","🐂 | Ox &4","🐃 | Water Buffalo &5"
                                       ,"🐄 | Cow &6","❓ | Red &7","❔ | White &8")
:x*?:c``::HotstringMenuV("T","HotstringMenuAction",ArrowsA*)
:x*?:a``::HotstringMenuV("T","HotstringMenuAction",{⇐: "Left arrow &1",⇔: "Double arrow &5",⇒: "Right arrow &3",⇑: "Up arrow &2",⇓: "Down arrow &4"}*)
:x*?:c``::HotstringMenuV("","HotstringMenuAction",["⇐ | Left arrow &1","⇔ | Double arrow &2","⇒ | Right arrow &3","⇑ | Up arrow &4","⇓ |Down arrow &5"]*)


