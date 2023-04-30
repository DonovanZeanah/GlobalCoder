#singleinstance,force
#include shinsoverlayclass.ahk


overlay := new ShinsOverlayClass(x,y,width,height,0,0,1)
opacity := 0xBB

hotKeyText := ""
inputText := ""
;overlay := new ShinsOverlayClass("title")
settimer,draw,10
Return


f1::
hotKeyText := "Pressed F1"
return

f2::
hotKeyText := "Pressed F2"
return

f3::
inputbox,inpText,input text here, input text here
if (inpText != "") {
  inputText := inpText
}
Return


draw:
if (Overlay.BeginDraw()) {
  if (hotKeyText != "") { ;or any other type of comparison if needed
    overlay.DrawText(hotKeyText,50,50,28)
  }
  
  overlay.DrawText(inputText,50,150,28) ;this also works without a comparison, just draws empty string when empty

  Overlay.EndDraw()
}
return