#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


tile_w := 48, tile_h := 48
temp_x := 0, temp_y := 0

loop, Files, %a_scriptDir%\*.*
{
	if (instr("jpg,png,bmp",a_loopfileext)) {
		counter++
		picList .= a_loopfilename ";"
	}
}

msgbox % piclist
msgbox % counter

;StringSplit, OutputArray, InputVar [, Delimiters, OmitChars]

;this is splitting piclist by ";" and outputting piccontrol1, piccontrol2, piccontrol3 
;etc
stringsplit,picControl,picList,`;

grid_dim := ceil(sqrt(counter)), counter := 0
msgbox % grid_dim

loop % grid_dim {
	loop % grid_dim {
		counter++
		gui 1: add,picture,x%temp_x% y%temp_y% w%tile_w% h-1 gPicClick vpicControl%counter%, % picControl%counter%
		temp_x += tile_w
	}
	temp_y += tile_h, temp_x := 0
}
gui_w := tile_w*grid_dim*3, gui_h := tile_h*grid_dim*2
Gui 2: Show, w%gui_w% h%gui_h%, GridMap
gui_w := tile_w*ceil(sqrt(c)), gui_h := tile_h*ceil(sqrt(c))
Gui 1: Show, w%gui_w% h%gui_h%, Sprites
return



PicClick:
gui 1: submit,nohide
gui2c++
gridPicControl%gui2c% := %a_guicontrol%
gui 2: add,picture,x0 y0 w%tile_w% h-1 +wantreturn vgridPicControl%gui2c% gMoveMe, % %a_guicontrol%
return
 
MoveMe:
while (getKeyState("LButton","P")) {
	mousegetpos,mx,my
	mx -= (tile_w/2), my -= (tile_h/2)*2
	if (mx != px ||my != py) {
		guicontrol,move,%a_guicontrol%, x%mx% y%my%
		px := mx, py := my
	}
}
drop_x := round(px/tile_w)*tile_w
drop_y := round(py/tile_h)*tile_h
guicontrol,move,%a_guicontrol%, x%drop_x% y%drop_y%
return


