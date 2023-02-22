

;scanchrome()
;chrome_group()
;chrome_name()
;chrome_class()





scanchrome(){
static loopnum := 1

;create an array of colors, to add more just seperate them by commas
;--------------------pink------orange---white--green------purple--light blue-blu------red-----yellow
chromeTabColors := [0xFF8BCB,0xFCAD70,0xDADCE0,0x81C995, 0xC58AF9,0x78D9EC,0x8AB4F8,0xF28B82,0xFDD663] 
chromeColors := {pink:0xFF8BCB,orange:0xFCAD70,white:0xDADCE0,green:0x81C995,purple:0xC58AF9,lightblue:0x78D9EC,blue:0x8AB4F8,red:0xF28B82,yellow:0xFDD663} 

WinActivate, dkz
scan := new Shinsimagescanclass(dkz)
;scan.pixelregion()

for k,v in chromeColors
{
colorinloop := v
if (scan.Pixel(colorinloop,,x,y)) {
    tooltip % "Found" k " pixel at " x "," y
    mousemove,  x , y  
    MouseClick, r, X, Y, 1, 
    } else 
    {
        MsgBox, % "0: `n damn " 
    }


}
return
}

;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
chrome_group(num := 0){
;MsgBox, % "Start: `n inside of chrome_group class : `n parameter passed in: " num
this.num := num ; A := new chrome_group(2) ; A.num is 2.
if (num = 0)
{
static count := 0
count++
;MsgBox, % "0: count:" count
WinActivate, dkz 
WinWaitActive, dkz
sleep, 100
send, !g
sleep, 100
MsgBox, % "1: chrome window is :"  dkz1 "`n "
if IfMsgBox, yes 
;Continue
{
MsgBox, % "5: put a gotosub here that uses shinsimagescan class" 
}
else IfMsgBox, cancel 
{
MsgBox, % "4:" "canceled operation"
return
}
else if (num := 1)
{
WinActivate, dkz1 
WinWaitActive, dkz1
sleep, 100
send, !g
sleep, 100
MsgBox, % "1: chrome window is :"  dkz1
;Goto, chrome_label
return

}
else if (num := 2)
{
send,{Alt 2}
send,{space 2}
send, l
send, w
send, dkz2
send,{enter}
MsgBox, % "2: chrome window is :" dkz2
return

}
}
}
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
chrome_name(num:=0){  

SetKeyDelay, 100
;MsgBox, % "1: `n " num++

if (num = 0)
{

;MsgBox, % "num: `n " num++

;MsgBox, % "0: num: " num
send,{Alt 2}
send,{space 2}
send, l
send, w
send, % "dkz" . num
send,{enter}
return num
}
if (num = 1)
{
    ;MsgBox, % "0: num is : `n " num++
;num++
send,{Alt 2}
send,{space 2}
send, l
send, w
send, % "dkz" . num
send,{enter}
MsgBox, % "1:" sent dkz1
return num

}
if (num = 2)
{

;MsgBox, % "2: `n num is : " num
send,{Alt 2}
send,{space 2}
send, l
send, w
send, % "dkz" . num
send,{enter}
MsgBox, % "2:" sent dkz2
return
}
}
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]

class chrome_class
{
;use it: example := new Chrome_group(2)

    static count := 0

  

    __new(num:=0){

    ;Gui +HwndMyGuiHwnd

    ;gui, Show, noactivate
    ;MsgBox, % "count: " this.count++ ;:= count++ "`n" . "focus window to change" ";;;" count
    ;MsgBox, % "count: " this.count ;:= count++ "`n" . "focus window to change" ";;;" count


    ;MsgBox, % "Start: `n inside of chrome_group class :" this.count . " `n parameter passed in: " num
;     MsgBox, % "7: this.num:" this.num
   ; this.num := num ; A := new chrome_group(2) ; A.num is 2.
   ;  MsgBox, % "8: this.num := *num* : " this.num

   if num = 2 

   return this
    }

    winset(){

    }
    winactivate(){

    }

    /*
    use:


    */
/*
*/
}
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]