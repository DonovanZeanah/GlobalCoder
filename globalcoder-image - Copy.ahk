savepic(){
pToken := Gdip_Startup()
WinGet, hwnd, ID, A
pBitmap := Gdip_BitmapFromHWND(hwnd)
Gdip_SaveBitmapToFile(pBitmap, A_Desktop "\TestOutput.png")
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)


ToolTip, Timed ToolTip`nThis will be displayed for 5 seconds.
SetTimer, RemoveToolTip, -1000
return
}
RemoveToolTip:
tooltip, off 
return