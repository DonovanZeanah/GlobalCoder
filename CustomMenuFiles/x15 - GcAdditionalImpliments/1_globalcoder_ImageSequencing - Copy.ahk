#SingleInstance,Force
ListLines,Off
#NoEnv
SetBatchLines,-1
Coordmode,Mouse,screen
CoordMode,Pixel,Screen
global CapActive:=0,SP,XCAP,YCAP,WCAP,HCAP,OB:=0,CAPIT:=0,PlayBackActive,PlaybackWindow:={}
global CapWin:={},Monitors := New MonitorClass()
Gdip_Startup()
global TXC,TYC,BB:=New_Brush("000000","88"),GB:=New_Brush("00ff00","55"),RB:=New_Brush("ff0000","55")
IfNotExist,% A_ScriptDir "\Recordings Folder" 
{
	FileCreateDir,% A_ScriptDir "\Recordings Folder"
}
SetWorkingDir,% A_ScriptDir "\Recordings Folder"
IfNotExist,% A_WorkingDir "\Default Recording Folder"
{
	FileCreateDir,% A_WorkingDir "\Default Recording Folder"
}

Gui,1:+AlwaysOnTop -DPIScale +hwndGUI1HWND
Gui,1:Color,333333,222222
Gui,1:Font,cWhite s10 ,Segoe UI

Gui,1:Add,DDL,xm ym w250 r20 hwndFLDDL vRecordingFileDDL gSelectFolder,% FileList
PostMessage, 0x153, -1, 18,, ahk_id %FLDDL% ; Adjust the default height of the DDL 
UpdateFileList()
GuiControl,1:Choose,RecordingFileDDL,Default Recording Folder
GuiControlGet,RecordingFileDDL
Gui,1:Add,Button,x+20 w100 h25 -Theme gOpenSelectedFolder,Open Folder

Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Checkbox,xm y+10 vFileDeleteLock gUnlockDeleteFolderButton,Unlock Delete Folder Button
Gui,1:Add,Button,x+20 w100 h25 -Theme Disabled vDeleteFolderButton gDeleteFolder,Delete Folder


Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Text,xm y+10 0x200,New Folder Name:
Gui,1:Add,Edit,x+10 w200 h22 vNewFolderName,
Gui,1:Add,CheckBox,xm y+10 vNewFolderLock gUnlockNewFolderButton,UnLock New Folder Controls
Gui,1:Add,Button,x+20 w100 h25 -Theme Disabled vNewFolderButton gCreateNewFolder,Create Folder


Gui,1:Add,Text,xm y+10,_________________________________________________________________


Gui,1:Add,Checkbox,xm vRamUse gSelectRamUse,Use Ram
Gui,1:Add,Button,x+30 w150 h25 -Theme vSetCapButton gSet_Capture_Area,Set Capture Area

Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Radio,xm y+10 Checked group vRecordPositionChoice gSubmitRecordPositionChoice,Record Set Position
Gui,1:Add,Radio,x+10 gSubmitRecordPositionChoice,Record Monitor Number
MLIST:=""
Loop,% Monitors.MonitorCount
	MLIST.=A_Index "|"
Gui,1:Add,DDL,x+10 w50 r5 Choose1 hwndmlisthwnd vMONITORCHOICE gSubmitMONITORCHOICE,% MLIST
PostMessage, 0x153, -1, 18,, ahk_id %mlisthwnd% ; Adjust the default height of the DDL 

Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Text,xm y+10 w20 h22 0x200,X:
Gui,1:Add,Edit,x+0 w60 h22 Center vXPosEdit gSubmit_Positions
Gui,1:Add,Text,x+10 w20 h22 0x200,Y:
Gui,1:Add,Edit,x+0 w60 h22 Center vYPosEdit gSubmit_Positions
Gui,1:Add,Text,x+10 w20 h22 0x200,W:
Gui,1:Add,Edit,x+0 w60 h22 Center vWPosEdit gSubmit_Positions
Gui,1:Add,Text,x+10 w20 h22 0x200,H:
Gui,1:Add,Edit,x+0 w60 h22 Center vHPosEdit gSubmit_Positions

Gui,1:Add,Text,xm y+10 h22 0x200,Recording Speed:
Gui,1:Add,Edit,x+10 w60 h22 Center vRecordingSpeedEdit gSubmitRecordingSpeed,30

Gui,1:Add,Text,x+20 h22 0x200,Playback Speed:
Gui,1:Add,Edit,x+10 w60 h22 Center vPlaybackSpeedEdit gSubmitPlaybackSpeed,30


Gui,1:Add,Text,xm y+20 ,Frames To Record:
Gui,1:Add,Edit,x+10 w100 h22 vRecordFrames gSubmitRecordFrames,100

Gui,1:Add,Text,x+30 ,Current Frame:
Gui,1:Add,Edit,x+10 w100 h22 ReadOnly vCurrentFrame,0

Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Button,xm y+10 w150 h25 -Theme gStartRecording,Start Recording
Gui,1:Add,Button,x+10 w150 h25 -Theme gStopRecording,Stop Recording
Gui,1:Add,Button,x+10 w150 h25 -Theme gPauseRecording,Pause Recording


Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Button,xm y+10 w150 h25 -Theme gStartPlayBack,Start Playback
Gui,1:Add,Button,x+10 w150 h25 -Theme gStopPlayback,Stop Playback
Gui,1:Add,Button,x+10 w150 h25 -Theme gPausePlayback,Pause Playback

Gui,1:Add,Text,xm y+10,_________________________________________________________________

Gui,1:Add,Radio,xm y+10 Checked Group vOverWrite gSubmitOverWrite,Prevent OverWriting
Gui,1:Add,Radio,x+20 yp gSubmitOverWrite,Allow OverWriting
Gui,1:Add,Radio,x+20 yp gSubmitOverWrite,Append To End

Gui,1:Show, ,Snap It Recorder
Gui,1:Submit,NoHide
OnMessage(0x201,"MovePreviewWindow")
return
GuiClose:
	ExitApp
	
MovePreviewWindow(){
	if(WinActive("ahk_ID " PlaybackWindow.hwnd))
		PostMessage,0xA1,2
}


StartRecording:
	PAUSERECORDING:=0
	STOPRECORDING:=0
	Recording_Array:=""
	Recording_Array:=[]
	ICount:=0
	Loop,% A_WorkingDir "\" RecordingFileDDL "\*.*"  ;Added Dec 18th,2019
		ICount++
	if(Overwrite=1&&ICount){ ;Added Dec 18th,2019
		Gui,1:+OwnDialogs
		msgbox,The current folder already contains images
		return
	}else if(Overwrite=2){
		CurrentFrame:=1
	}else if(Overwrite=3){
		CurrentFrame:=ICount+1
	}
	if((XPosEdit=null||YPosEdit=null||!WPosEdit||!HPosEdit||!RecordingFileDDL)&&RecordPositionChoice!=0){
		Loop 3
			SoundBeep,500
		Gui,1:+OwnDialogs
		MsgBox,Something is missing
		return
	}
	ml:=Monitors.Monitor[MONITORCHOICE].Left
	mt:=Monitors.Monitor[MONITORCHOICE].Top
	mr:=Monitors.Monitor[MONITORCHOICE].Right-Monitors.Monitor[MONITORCHOICE].Left
	mb:=Monitors.Monitor[MONITORCHOICE].Bottom-Monitors.Monitor[MONITORCHOICE].Top
	if(!RamUse){
		While(!STOPRECORDING&&CurrentFrame<RecordFrames+1){
			if(!PAUSERECORDING){
				GuiControl,1:,CurrentFrame,% CurrentFrame
				if(RecordPositionChoice=1)
					TempBitmap:=Gdip_BitmapFromScreen(XPosEdit "|" YPosEdit "|" WPosEdit "|" HPosEdit)
				else
					TempBitmap:=Gdip_BitmapFromScreen(ml "|" mt "|" mr "|" mb)
				
				Gdip_SaveBitmapToFile(TempBitmap,A_WorkingDir "\" RecordingFileDDL "\HB_Snap_" CurrentFrame++ ".png", 100)
				Gdip_DisposeImage(TempBitmap)
				if(RecordingSpeedEdit)
					Sleep,%RecordingSpeedEdit%
			}else	{
				Sleep,10
			}
		}
	}else if(RamUse) {
		While(!STOPRECORDING&&CurrentFrame<RecordFrames+1){
			if(!PAUSERECORDING){
				GuiControl,1:,CurrentFrame,% CurrentFrame
				if(RecordPositionChoice=1)
					Recording_Array[CurrentFrame++]:=Gdip_BitmapFromScreen(XPosEdit "|" YPosEdit "|" WPosEdit "|" HPosEdit)
				else
					Recording_Array[CurrentFrame++]:=Gdip_BitmapFromScreen(ml "|" mt "|" mr "|" mb)
				
				if(RecordingSpeedEdit)
					Sleep,%RecordingSpeedEdit%
			}else	{
				Sleep,10
			}
		}
		SoundBeep,500
		traytip,,Saving
		CurrentFrame:=1
		Loop,% Recording_Array.Length(){
			GuiControl,1:,CurrentFrame,% CurrentFrame
			Gdip_SaveBitmapToFile(Recording_Array[CurrentFrame],A_WorkingDir "\" RecordingFileDDL "\HB_Snap_" CurrentFrame ".png", 100)
			Gdip_DisposeImage(Recording_Array[CurrentFrame])
			CurrentFrame++
		}
		Recording_Array:=""
	}
	Loop 3
		SoundBeep,800
	TrayTip,,Done
	return

StopRecording:
	STOPRECORDING:=1
	return

PauseRecording:
	PAUSERECORDING:=!PAUSERECORDING
	return

Move_Window:
	PostMessage,0xA1,2
	return
	
StartPlayBack:
	PB:=""
	STOPPLAYBACK:=0
	PAUSEPLAYBACK:=0
	Image_Count:=0
	PlaybackWindow:=""
	PlaybackWindow:={}
	PlayBackActive:=1
	Loop,% A_WorkingDir "\" RecordingFileDDL "\*.*"
	{
		Image_Count++
	}
	if(Image_Count=0){
		TrayTip,,No Clips
		return
	}	
	
	PB:=Gdip_CreateBitmapFromFile(A_WorkingDir "\" RecordingFileDDL "\HB_Snap_1.png")
	Gdip_GetDimensions(PB,Width,Height)
	Gdip_DisposeImage(PB)
	PB:=""
	PlaybackWindow:=LWS(Width,Height)
	Current_Frame:=1
	While(!STOPPLAYBACK){
		if(!PAUSEPLAYBACK){
			tick:=A_TickCount
			GuiControl,1:,CurrentFrame,% Current_Frame
			PB:=Gdip_CreateBitmapFromFile(A_WorkingDir "\" RecordingFileDDL "\HB_Snap_" Current_Frame++ ".png")
			Gdip_DrawImage(PlaybackWindow.G, PB,0,0,width,height)
			UpdateLayeredWindow(PlaybackWindow.hwnd, PlaybackWindow.hdc)
			Gdip_DisposeImage(PB)
			PB:=""
			if(PlaybackSpeedEdit&&(A_TickCount-tick)<PlaybackSpeedEdit)
				Sleep,% PlaybackSpeedEdit - (A_TickCount-tick)
		}else	{
			Sleep,100
		}
		if(Current_Frame>Image_Count)
			Current_Frame:=1
	}
	Gdip_DisposeImage(PB)
	PB:=""
	Layered_Shutdown(PlaybackWindow)
	Gui,3:Destroy
	PlayBackActive:=0
	return



LWS(w,h){
	global
	Layered:={}
	Gui,3: +E0x80000 +LastFound -Caption -DPIScale 
	;~ Gui,3:Add,Text,x0 y0 w%w% h%h% gMove_Window
	Gui,3:Show,% " w" w " h" h,HB Playback
	Layered.hwnd:=winExist()
	Layered.hbm := CreateDIBSection(w,h)
	Layered.hdc := CreateCompatibleDC()
	Layered.obm := SelectObject(Layered.hdc,Layered.hbm)
	Layered.G := Gdip_GraphicsFromHDC(Layered.hdc)
	Gdip_SetSmoothingMode(Layered.G,1)
	UpdateLayeredWindow(Layered.hwnd, Layered.hdc,(A_ScreenWidth-w)/2,(A_ScreenHeight-h)/2,width,height)
	return Layered
}
Layered_Shutdown(This){
	SelectObject(This.hdc,This.obm)
	DeleteObject(This.hbm)
	DeleteDC(This.hdc)
	gdip_deleteGraphics(This.g)
}

StopPlayback:
3GuiContextMenu:
	STOPPLAYBACK:=1
	return

PausePlayback:
	PAUSEPLAYBACK:=!PAUSEPLAYBACK
	return

UnlockNewFolderButton:
	GuiControlGet,NewFolderLock
	if(NewFolderLock){
		GuiControl,1:Enable,NewFolderButton
	}else	{
		GuiControl,1:Disable,NewFolderButton
	}
	return

UnlockDeleteFolderButton:
	GuiControlGet,FileDeleteLock
	if(FileDeleteLock){
		GuiControl,1:Enable,DeleteFolderButton
	}else	{
		GuiControl,1:Disable,DeleteFolderButton
	}
	return

Set_Capture_Area:
	Create_Capture_Size_Window()
	return

SubmitRecordingSpeed:
	GuiControlGet,RecordingSpeedEdit
	return
	
SubmitRecordPositionChoice:
	GuiControlGet,RecordPositionChoice
	if(RecordPositionChoice=0){
		XCAP:=Monitors.Monitor[MONITORCHOICE].Left
		YCAP:=Monitors.Monitor[MONITORCHOICE].Top
		WCAP:=Monitors.Monitor[MONITORCHOICE].Right-Monitors.Monitor[MONITORCHOICE].Left
		HCAP:=Monitors.Monitor[MONITORCHOICE].Bottom-Monitors.Monitor[MONITORCHOICE].Top
		GuiControl,1:,WPosEdit,% WCAP
		GuiControl,1:,HPosEdit,% HCAP
		GuiControl,1:,XPosEdit,% XCAP
		GuiControl,1:,YPosEdit,% YCAP
	}else	{
		XCAP:=YCAP:=WCAP:=HCAP:=""
		GuiControl,1:,WPosEdit,
		GuiControl,1:,HPosEdit,
		GuiControl,1:,XPosEdit,
		GuiControl,1:,YPosEdit,
	}
	return
	
SubmitMONITORCHOICE:
	GuiControlGet,MONITORCHOICE
	if(RecordPositionChoice=0){
		XCAP:=Monitors.Monitor[MONITORCHOICE].Left
		YCAP:=Monitors.Monitor[MONITORCHOICE].Top
		WCAP:=Monitors.Monitor[MONITORCHOICE].Right-Monitors.Monitor[MONITORCHOICE].Left
		HCAP:=Monitors.Monitor[MONITORCHOICE].Bottom-Monitors.Monitor[MONITORCHOICE].Top
		GuiControl,1:,WPosEdit,% WCAP
		GuiControl,1:,HPosEdit,% HCAP
		GuiControl,1:,XPosEdit,% XCAP
		GuiControl,1:,YPosEdit,% YCAP
	}
	return

SubmitOverWrite:
	Gui,1:Submit,NoHide
	return

SubmitPlaybackSpeed:
	GuiControlGet,PlaybackSpeedEdit
	return

Submit_Positions:
	GuiControlGet,XPosEdit
	GuiControlGet,YPosEdit
	GuiControlGet,WPosEdit
	GuiControlGet,HPosEdit
	return

SelectRamUse:
	GuiControlGet,RamUse
	return

SubmitRecordFrames:
	GuiControlGet,RecordFrames
	return

SelectFolder:
	GuiControlGet,RecordingFileDDL
	return
CreateNewFolder:
	GuiControlGet,NewFolderName
	IfExist,% A_WorkingDir "\" NewFolderName
	{
		Gui,1:+OwnDialogs
		SoundBeep,400
		Msgbox, That Folder Already Exists
		GuiControl,1:Choose,RecordingFileDDL,%NewFolderName%
		GuiControlGet,RecordingFileDDL
	}
	IfNotExist,% A_WorkingDir "\" NewFolderName
	{	
		FileCreateDir,% A_WorkingDir "\" NewFolderName
		SoundBeep,400
		UpdateFileList()
		GuiControl,1:,NewFolderLock,0
		gosub,UnlockNewFolderButton
	}
	return

DeleteFolder:
	if(RecordingFileDDL){
		FileRemoveDir, % A_WorkingDir "\" RecordingFileDDL , 1
		if(RecordingFileDDL="Default Recording Folder"){
			FileCreateDir,% A_WorkingDir "\" RecordingFileDDL   
		}
		SoundBeep,400
		UpdateFileList()
		GuiControl,1:,FileDeleteLock,0
		gosub,UnlockDeleteFolderButton
	}
	return

UpdateFileList(){
	global
	FileList:=""
	Loop,Files,% A_WorkingDir "\*"  , DR
	{
		len:=StrLen(A_WorkingDir)
		FileList.=(A_Index>1)?(SubStr(A_LoopFileFullPath,len+2) "|"):(SubStr(A_LoopFileFullPath,len+2) "||")
	}
	GuiControl,1:,RecordingFileDDL,|
	GuiControl,1:,RecordingFileDDL,% FileList
	GuiControl,1:Choose,RecordingFileDDL,%NewFolderName%
	GuiControlGet,RecordingFileDDL
}

OpenSelectedFolder:
	try
		Run, % A_WorkingDir "\" RecordingFileDDL
	catch
		SoundBeep,1500
	return

UpdateMainGui(){
	global
	GuiControl,1:,XPosEdit,% XCAP
	GuiControl,1:,YPosEdit,% YCAP
	GuiControl,1:,WPosEdit,% WCAP
	GuiControl,1:,HPosEdit,% HCAP
}

Create_Capture_Size_Window(){
	static ft
	Gui,2:Destroy
	CapWin:=Layered_Window_SetUp(3,0,0,A_ScreenWidth,A_ScreenHeight,"2","+AlwaysOnTop -DPIScale -Caption +Owner1")
	Max:=Monitors.Get_Largest_Monitor_Size()
	CapWin.hbm:=CreateDIBSection(Max.Width,Max.Height)
	CapWin.hdc := CreateCompatibleDC()
	CapWin.obm := SelectObject(CapWin.hdc,CapWin.hbm),CapWin.G := Gdip_GraphicsFromHDC(CapWin.hdc)
	Gdip_SetSmoothingMode(CapWin.G,3)
	if(!ft){
		Monitors.Set_Window_Move_Timer(GUINAME:=2,GUIHWND:=CapWin.hwnd,TCount:=300,xpOff:=0,ypOff:=0,xr:=1,yr:=1,Fill_Screen:=1)
		ft:=1
	}else 	{
		Monitors.Window_Move_Obj.GUIHWND:=CapWin.hwnd
		Monitors.Turn_On_Window_Move_Timer()
	}
	CapActive:=1,SP:=0,OB:=0
	SetTimer,Set_Positions,10
}

Set_Positions(){ ;Changed Dec 18th, 2019
	static ttx,tty
	Coordmode,Mouse,Window
	If(!WinActive("ahk_Id" CapWin.Hwnd)){
		WinActivate,% "ahk_Id" CapWin.Hwnd
	}
	Gdip_GraphicsClear(CapWin.g)
	MouseGetPos,tx,ty
	if(SP=0){
		Fill_Box(CapWin.G,BB,tx,0,1,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Bottom-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top)
		Fill_Box(CapWin.G,BB,0,ty,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Right-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,1)
		TXC:=tx,TYC:=ty,ttx:=tx,tty:=ty
		GuiControl,1:,XPosEdit,% TXC+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left
		GuiControl,1:,YPosEdit,% TYC+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top
	}else if(SP=1){
		Fill_Box(CapWin.G,BB,TXC,0,1,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Bottom-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top)
		Fill_Box(CapWin.G,BB,0,TYC,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Right-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,1)
		Fill_Box(CapWin.G,BB,tx,0,1,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Bottom-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top)
		Fill_Box(CapWin.G,BB,0,ty,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Right-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,1)
		if(TXC<tx&&TYC<ty){
			Fill_Box(CapWin.G,GB,TXC,TYC,tx-TXC,ty-TYC)
			WCAP:=tx-TXC,HCAP:=ty-TYC,OB:=0
			XCAP:=TXC+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,YCAP:=TYC+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top
			GuiControl,1:,WPosEdit,% WCAP
			GuiControl,1:,HPosEdit,% HCAP
		}else if(TXC>tx&&TYC<ty){
			Fill_Box(CapWin.G,GB,tx,TYC,TXC-tx,ty-TYC)
			XCAP:=tx+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,YCAP:=TYC+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top,WCAP:=ttx-tx,HCAP:=ty-TYC
			GuiControl,1:,XPosEdit,% XCAP
			GuiControl,1:,YPosEdit,% YCAP
			GuiControl,1:,WPosEdit,% WCAP
			GuiControl,1:,HPosEdit,% HCAP
			OB:=0
		}else if(TXC>tx&&TYC>ty){
			Fill_Box(CapWin.G,GB,tx,ty,TXC-tx,TYC-ty)
			XCAP:=tx+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,YCAP:=Ty+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top,WCAP:=ttx-tx,HCAP:=TYC-ty
			GuiControl,1:,XPosEdit,% XCAP
			GuiControl,1:,YPosEdit,% YCAP
			GuiControl,1:,WPosEdit,% WCAP
			GuiControl,1:,HPosEdit,% HCAP
			OB:=0
		}else if(TXC<tx&&TYC>ty){
			Fill_Box(CapWin.G,GB,TXC,ty,tx-TXC,TYC-ty)
			XCAP:=ttx+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,YCAP:=Ty+Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top,WCAP:=tx-ttx,HCAP:=TYC-ty
			GuiControl,1:,XPosEdit,% XCAP
			GuiControl,1:,YPosEdit,% YCAP
			GuiControl,1:,WPosEdit,% WCAP
			GuiControl,1:,HPosEdit,% HCAP
			OB:=0
		}
	}
	UpdateLayeredWindow(CapWin.hwnd, CapWin.hdc,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top,Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Right-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Left, Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Bottom-Monitors.Monitor[Monitors.Window_Move_Obj.Current_Monitor].Top)
}

#IF (CapActive=1)
	LButton::
		if(SP=0)
			SP:=1
		else if(SP=1&&OB=0){
			Monitors.Turn_Off_Window_Move_Timer()
			CapActive:=0
			SelectObject(CapWin.hdc,CapWin.obm),DeleteObject(CapWin.hbm),DeleteDC(CapWin.hdc),gdip_deleteGraphics(CapWin.g)
			CapWin:="",SP:=0
			Gui,2:Destroy
			SetTimer,Set_Positions,Off
			UpdateMainGui()
		}
		return
	
	RButton::  ;Added Dec 13th, 2019
		Monitors.Turn_Off_Window_Move_Timer()
		CapActive:=0
		SelectObject(CapWin.hdc,CapWin.obm),DeleteObject(CapWin.hbm),DeleteDC(CapWin.hdc),gdip_deleteGraphics(CapWin.g)
		CapWin:="",SP:=0
		Gui,2:Destroy
		SetTimer,Set_Positions,Off
		XCAP:=YCAP:=WCAP:=HCAP:=""
		GuiControl,1:,WPosEdit,
		GuiControl,1:,HPosEdit,
		GuiControl,1:,XPosEdit,
		GuiControl,1:,YPosEdit,
		return
#IF


;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------

class MonitorClass	{
	__New(){
		This._SetMonCount()
		This._SetPrimeMonitor()
		This._Set_Bounds()
	}
	_SetMonCount(){
		local MC
		SysGet, MC, MonitorCount 
		This.MonitorCount := MC
	}
	_SetPrimeMonitor(){
		local PM
		SysGet, PM, MonitorPrimary
		This.PrimeMonitor := PM
	}
	_Set_Bounds(){
		local bmon,bmonLeft,bmonRight,bmonTop,bmonBottom
		This.Monitors:=[]
		Loop,% This.MonitorCount	{
			SysGet, bmon, Monitor, % A_Index
			This.Monitor[A_Index]:=	{ Left		: 	bmonLeft
									, Top		: 	bmonTop
									, Right		: 	bmonRight
									, Bottom	: 	bmonBottom 	}
		}
	}
	Get_Current_Monitor(){
		local x,y
		CoordMode,Mouse,Screen
		MouseGetPos,x,y
		Loop,% This.MonitorCount	{
			if(x>=This.Monitor[A_Index].Left&&x<=This.Monitor[A_Index].Right&&y>=This.Monitor[A_Index].Top&&y<=This.Monitor[A_Index].Bottom){
				return A_Index
			}
		}
	}
	Get_New_Window_Position(curMon,xpOff,ypOff,xr,yr){
		local tposa:="",tposa:={}
		if(xr=1) ; 1 xr = relative to the left side ; 2 xr = relative to the right side
			tposa.x:=This.Monitor[curMon].Left+xpOff
		else 
			tposa.x:=This.Monitor[curMon].Right-xpOff
		if(yr=1) ; 1 yr = relative to the top  ; 2 yr = relative to the bottom
			tposa.y:=This.Monitor[curMon].Top+ypOff
		else 
			tposa.y:=This.Monitor[curMon].Bottom-ypOff
		return tposa
	}
	Set_Window_Move_Timer(GUINAME:=1,GUIHWND:="",TCount:=500,xpOff:=0,ypOff:=0,xr:=1,yr:=1,Fill_Screen:=0){
		
		local Window_Timer
		
		This.Window_Move_Obj:=	{ 	Interval		:	TCount
								,	GUINAME			:	GUINAME
								,	FILLSCREEN		:	Fill_Screen
								,	GUIHWND			:	GUIHWND
								,	XPOFF			:	xpOff
								,	YPOFF			:	ypOff
								,	XRelative		:	xr
								,	YRelative		:	yr	
								,	Current_Monitor	:	This.Get_Current_Monitor()
								,	Old_Monitor		:	This.Get_Current_Monitor()	
								,	NEW_GUI_POS		:	This.Get_New_Window_Position(This.Get_Current_Monitor(),xpOff,ypOff,xr,yr)	}
								
		This.Window_Timer := Window_Timer :=  ObjBindMethod(This, "_Window_Move_Timer")
		
		This._Set_TFTime()
		
		SetTimer,%Window_Timer%,%TCount%

	}
	Get_Largest_Monitor_Size(){
		local tempMSW:="",tempMSH:=""
		Loop,% This.MonitorCount	{
			if(This.Monitor[A_Index].Right-This.Monitor[A_Index].Left>=This.Monitor[A_Index+1].Right-This.Monitor[A_Index+1].Left&&This.Monitor[A_Index].Right-This.Monitor[A_Index].Left>=This.Monitor[tempMSW].Right-This.Monitor[tempMSW].Left)
				tempMSW:=A_index
			if(This.Monitor[A_Index].Bottom-This.Monitor[A_Index].Top>=This.Monitor[A_Index+1].Bottom-This.Monitor[A_Index+1].Top&&This.Monitor[A_Index].Bottom-This.Monitor[A_Index].Top>=This.Monitor[tempMSH].Bottom-This.Monitor[tempMSH].Top)
				tempMSH:=A_index
		}
		This.Max_Monitor_Dimensions := {Width: This.Monitor[tempMSW].Right-This.Monitor[tempMSW].Left, Height: This.Monitor[tempMSH].Bottom-This.Monitor[tempMSH].Top}
		return This.Max_Monitor_Dimensions
	}
	_Window_Move_Timer(){
		This.Window_Move_Obj.Current_Monitor := This.Get_Current_Monitor()
		if(This.Window_Move_Obj.Current_Monitor!=This.Window_Move_Obj.Old_Monitor&&!DllCall("IsIconic", "Ptr", This.Window_Move_Obj.GUIHWND, "UInt")){
			This.Window_Move_Obj.NEW_GUI_POS:=This.Get_New_Window_Position(This.Window_Move_Obj.Current_Monitor,This.Window_Move_Obj.XPOFF,This.Window_Move_Obj.YPOFF,This.Window_Move_Obj.XRelative,This.Window_Move_Obj.YRelative)
			This._Move_Window()
			This.Window_Move_Obj.Old_Monitor := This.Window_Move_Obj.Current_Monitor
		}
	}
	_Set_TFTime(){
		This.Window_Move_Obj.Current_Monitor := This.Get_Current_Monitor()
		This.Window_Move_Obj.NEW_GUI_POS:=This.Get_New_Window_Position(This.Window_Move_Obj.Current_Monitor,This.Window_Move_Obj.XPOFF,This.Window_Move_Obj.YPOFF,This.Window_Move_Obj.XRelative,This.Window_Move_Obj.YRelative)
		This.Window_Move_Obj.Old_Monitor := This.Window_Move_Obj.Current_Monitor
		This._Move_Window()
	}
	_Move_Window(){
		if(!This.Window_Move_Obj.FILLSCREEN)
			Gui,% This.Window_Move_Obj.GUINAME ":Show",% "x" This.Window_Move_Obj.NEW_GUI_POS.X " y" This.Window_Move_Obj.NEW_GUI_POS.Y " NA"
		else
			Gui,% This.Window_Move_Obj.GUINAME ":Show",% "x" This.Window_Move_Obj.NEW_GUI_POS.X " y" This.Window_Move_Obj.NEW_GUI_POS.Y " w" This.Monitor[This.Window_Move_Obj.Current_Monitor].Right " h" This.Monitor[This.Window_Move_Obj.Current_Monitor].Bottom " NA"
	}
	Turn_Off_Window_Move_Timer(){
		local Window_Timer
		Window_Timer := This.Window_Timer
		SetTimer,%Window_Timer%,Off
	}
	Turn_On_Window_Move_Timer(){
		local Window_Timer
		Window_Timer := This.Window_Timer
		This._Set_TFTime()
		SetTimer,%Window_Timer%,On
	}
	GetGuiPos(){
		local x,y
		WinGetPos,x,y,,,% "ahk_id " This.Window_Move_Obj.GUIHWND 
		return x
	}
}
;######################################################################################################################################
;#####################################################   					    #######################################################
;#####################################################  	  Gdip LITE		    #######################################################
;#####################################################  					    #######################################################
;######################################################################################################################################
Layered_Window_SetUp(Smoothing,Window_X,Window_Y,Window_W,Window_H,Window_Name:=1,Window_Options:=""){
	Layered:={}
	Layered.W:=Window_W,Layered.H:=Window_H,Layered.X:=Window_X,Layered.Y:=Window_Y
	Layered.Name:=Window_Name,Layered.Options:=Window_Options
	;~ Layered.Token:=Gdip_Startup()
	Create_Layered_GUI(Layered),Layered.hwnd:=winExist()
	;~ Layered.hbm := CreateDIBSection(Window_W,Window_H),Layered.hdc := CreateCompatibleDC()
	;~ Layered.obm := SelectObject(Layered.hdc,Layered.hbm),Layered.G := Gdip_GraphicsFromHDC(Layered.hdc)
	;~ Gdip_SetSmoothingMode(Layered.G,Smoothing)
	return Layered
}
Create_Layered_GUI(Layered){
	Gui,% Layered.Name ": +E0x80000 +LastFound " Layered.Options 
	Gui,% Layered.Name ":Show",% "x" Layered.X " y" Layered.Y " w" Layered.W " h" Layered.H ;" NA"
}	
Layered_Window_ShutDown(This){
	SelectObject(This.hdc,This.obm),DeleteObject(This.hbm),DeleteDC(This.hdc)
	gdip_deleteGraphics(This.g),Gdip_Shutdown(This.Token)
}
New_Brush(colour:="000000",Alpha:="FF"){
	new_colour := "0x" Alpha colour 
	return Gdip_BrushCreateSolid(new_colour)
}
New_Pen(colour:="000000",Alpha:="FF",Width:= 5){
	new_colour := "0x" Alpha colour 
	return Gdip_CreatePen(New_Colour,Width)
}	
Fill_Box(pGraphics,pBrush,x,y,w,h)	{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillRectangle", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; Modifed by Rseding91 using fincs 64 bit compatible Gdip library 5/1/2013
;#####################################################################################
Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdipGetImageWidth", Ptr, pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", Ptr, pBitmap, "uint*", Height)
}
DestroyIcon(hIcon)
{
	return DllCall("DestroyIcon", A_PtrSize ? "UPtr" : "UInt", hIcon)
}

;#####################################################################################

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
    Return pBitmap
}


Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}


Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, "float", dx
				, "float", dy
				, "float", dw
				, "float", dh
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}


Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height){
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}
Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"
	
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))
		
		VarSetCapacity(buf, BufSize, 0)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)
			
			if !hIcon
				continue

			if !DllCall("GetIconInfo", Ptr, hIcon, Ptr, &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			
			hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4))
			hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4))
			if !(hbmColor && DllCall("GetObject", Ptr, hbmColor, "int", BufSize, Ptr, &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", Ptr, hdc, "int", 0, "int", 0, Ptr, hIcon, "uint", Width, "uint", Height, "uint", 0, Ptr, 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}
		
		VarSetCapacity(dib, 104)
		DllCall("GetObject", Ptr, hbm, "int", A_PtrSize = 8 ? 104 : 84, Ptr, &dib) ; sizeof(DIBSECTION) = 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize
		Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0)) ; padding
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, Ptr, Bits, PtrA, pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height)
		G := Gdip_GraphicsFromImage(pBitmap)
		, Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if (!A_IsUnicode)
		{
			VarSetCapacity(wFile, 1024)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sFile, "int", -1, Ptr, &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &wFile, PtrA, pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &sFile, PtrA, pBitmap)
	}
	
	return pBitmap
}


BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster=""){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdi32\BitBlt", Ptr, dDC, "int", dx, "int", dy, "int", dw, "int", dh, Ptr, sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}
Gdip_SetImageAttributesColorMatrix(Matrix){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}
Gdip_GetImageWidth(pBitmap){
   DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
   return Width
}
Gdip_GetImageHeight(pBitmap){
   DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
   return Height
}
Gdip_DeletePen(pPen){
   return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}
Gdip_DeleteBrush(pBrush){
   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}
Gdip_DisposeImage(pBitmap){
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}
Gdip_DeleteGraphics(pGraphics){
   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr){
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}
CreateCompatibleDC(hdc=0){
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
SelectObject(hdc, hgdiobj){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}
DeleteObject(hObject){
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}
GetDC(hwnd=0){
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}
GetDCEx(hwnd, flags=0, hrgnClip=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
    return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}
DeleteDC(hdc){
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4, "uint"), NumPut(h, bi, 8, "uint"), NumPut(40, bi, 0, "uint"), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16, "uInt"), NumPut(bpp, bi, 14, "ushort")
	hbm := DllCall("CreateDIBSection", Ptr, hdc2, Ptr, &bi, "uint", 0, A_PtrSize ? "UPtr*" : "uint*", ppvBits, Ptr, 0, "uint", 0, Ptr)
	if !hdc
		ReleaseDC(hdc2)
	return hbm
}
Gdip_GraphicsFromHDC(hdc){
    DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
    return pGraphics
}
Gdip_GetDC(pGraphics){
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}
Gdip_Startup(){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}
Gdip_CreatePen(ARGB, w){
   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
   return pPen
}
Gdip_BrushCreateSolid(ARGB=0xff000000){
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0){
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
CreateRectF(ByRef RectF, x, y, w, h){
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
CreatePointF(ByRef PointF, x, y){
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillRectangle", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0){
   return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_ResetClip(pGraphics){
   return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode){
   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}
Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff){
    return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")
	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
	return DllCall("UpdateLayeredWindow", Ptr, hwnd, Ptr, 0, Ptr, ((x = "") && (y = "")) ? 0 : &pt, "int64*", w|h<<32, Ptr, hdc, "int64*", 0, "uint", 0, "UInt*", Alpha<<16|1<<24, "uint", 2)
}
Gdip_BitmapFromScreen(Screen=0, Raster=""){
	if (Screen = 0){
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}
	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1
	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}
Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension
	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2
	If (A_IsUnicode){
		StrGet_Name := "StrGet"
		Loop, %nCount%
		{
			sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+idx
			break
		}
	} else {
		Loop, %nCount%
		{
			Location := NumGet(ci, 76*(A_Index-1)+44)
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+76*(A_Index-1)
			break
		}
	}
	if !pCodec
		return -3
	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			Loop, % NumGet(EncoderParameters, "UInt")      ;%
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
					break
				}
			}      
		}
	}
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &wOutput, Ptr, pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &sOutput, Ptr, pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}
Gdip_Shutdown(pToken){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}
Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}
