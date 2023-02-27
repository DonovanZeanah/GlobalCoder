


MButton::
  if Not IsObject(menu_o) {
    menu_o:=new imenu("menuconf","",32)
    menu_o.add("Checkable 1","gcheck",A_AhkPath "|2")
    menu_o.add("selectable 1","gsel",A_AhkPath "|2",16,0)
    menu_o.add("Selectable 2","gsel",A_AhkPath "|-206",24,-1)
    menu_o.add("Selectable 3","gsel",A_AhkPath "|-207",16,0)
    menu_o.add() ;separator
    menu_o.add("Checkable 2","gcheck",A_AhkPath ,48,0)
    menu_o.add("Disabled 1","gcheck",A_AhkPath "|-207",0,"",0)
  }
  menu_o.show()
return

gcheck:
  sel:=menu_o.getlast()
  menu_o.check(sel,menu_o.getcheck(sel)<>1?1:0,1)
return

gsel:
  menu_o.check(menu_o.getlast(),-1,1)
return


class imenu {
    __New(menuname,icondir="", iconsize=0) { ; delete if exist before
        Menu, % menuname, add
        Menu, % menuname, delete
       MouseGetPos, lastX, lastY
        this.menuname:=menuname, this.iconsize:=iconsize, this.icondir:=icondir, this.lastX:=lastX, this.lastY:=lastY,
    }
    __Delete() {
        Menu, % this.menuname , add
        Menu, % this.menuname, delete
    }
   add(text="",label="",icon="",iconsize="", check="",enable=1) { ;add item to menu. icon can me "file|position"
        rtext:=(check=0?"    ":(check=1 or check=-1)?"  " chr(149) "  ":"") text
        this.Insert(("item_" text),{rtext: rtext,check: check,label: label,fileicon: "",iconsize:  iconsize=""?this.iconsize:iconsize})
        Menu, % this.menuname, add, %rtext%, %label%
       if (text="") ;menu separator
        return
        if (icon<>"") {
            StringSplit,nicon,icon,|
            
            fileicon:=this.icondir<>""?this.icondir nicon1 ".png":nicon1
;            msgbox, % "Icon=" rtext ", " fileicon "," nicon "," this["item_" text].iconsize
            nicon:=nicon0>1?nicon2:""
            if FileExist(fileicon) {
;                msgbox, % "Icon=" rtext ", " fileicon "," nicon "," this["item_" text].iconsize
                Menu, % this.menuname, Icon, % rtext, % fileicon ,% nicon, % this["item_" text].iconsize
             this["item_" text].fileicon:=fileicon, this["item_" text].nicon:=nicon
           }
        }
        if (enable=0)
            Menu, % this.menuname , Disable, %rtext%
     }
    check(text,check=1,show=0) { ;check=-1 means select => unselect all preselected subitems from same label
        rtext:=this["item_" text].rtext, this["item_" text].rtext:=ntext:=(check=0?"    ":(check=1 or check=-1)?"  " chr(149) "  ":"") text
       if (rtext<>ntext)
        Menu, % this.menuname,Rename, % rtext , % ntext
       if  (this["item_" text].fileicon<>"")
        Menu, % this.menuname, Icon, % ntext, % this["item_" text].fileicon ,% this["item_" text].nicon, % this["item_" text].iconsize
        if (check=-1 or this["item_" text].check=-1) { ; select means uncheck all of options of same label
            label:=this["item_" text].label
            for k,v in this
                if (v.label=label and text<>SubStr(k,6) and (v.check=1 or v.check=-1)) { ;quitamos select
                    rtext:=v.rtext, v.rtext:="    " SubStr(k,6)
                if (rtext<>v.rtext)
                 Menu, % this.menuname,Rename, % rtext , % v.rtext
                if  (v.fileicon<>"")
                 Menu, % this.menuname, Icon, % v.rtext, % v.fileicon ,% v.nicon, % v.iconsize
                }
            }
       this["item_" text].check:=check
        if show
        this.show()
       }
    getcheck(text) {
     return this["item_" text].check
    }
    getlast() {
     for k,v in this
       if (v.rtext=A_ThisMenuItem)
        return SubStr(k,6)
     return ""
    }
    show(x="",y="") {
     if (x="" or y="")
       Menu,% this.menuname, Show, % this.lastX, % this.lastY
     else
       Menu,% this.menuname, Show, % x , % y
     }
}

