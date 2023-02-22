;***********************************************************************************************************
#Include, <My Altered GDIP LIB> ; <<<<<-------------  GDIP.AHK 
;***********************************************************************************************************
#SingleInstance, Force
SetBatchlines, -1
ListLines, Off
#NoEnv
Gdip_Startup()
Theme1 := HBCustomButton()
GuiButtonType1.SetSessionDefaults( Theme1.All , Theme1.Default , Theme1.Hover , Theme1.Pressed )
hBitmap := HB_BITMAP_MAKER()
Gui, 1:+AlwaysOnTop -Caption +ToolWindow hwndGuiHwnd 

Gui, 1:Color, 22262a
Gui, 1:Margin, 0 , 0
Gui, 1:Add, Picture, xm ym w160 h500 hwndpicHwnd 0xE
SetImage( picHwnd , hBitmap )

Button1 := New HButton( { Owner: 1 , X: 20 , Y: y := 60 , W: 120 , H: 30 , Text: "Recommend" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button2 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Consent" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button3 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "OmmuR" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button4 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Delete" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button5 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Orders" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button6 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Form" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button7 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Copy Info" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button8 := New HButton( { Owner: 1 , X: 20 , Y: y += 130 , W: 120 , H: 30 , Text: "Help" , Label: "ButtonHelp" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )
Button9 := New HButton( { Owner: 1 , X: 20 , Y: y += 30 , W: 120 , H: 30 , Text: "Terminate" , Label: "TestFunction" } , { BackgroundColor: "0xFF32363A" , FontSize: 12} )

Gui, 1:Show, % "x" A_ScreenWidth - 200 " y0 h500 NA Hide"

Gui, 2:+AlwaysOnTop -Caption +ToolWindow
Gui, 2:Color, 880000
Gui, 2:Add, Text, x0 y0 w15 h40 gOpenMenu
Gui, 2:Show, % "x" A_ScreenWidth - 15 " y" ( A_ScreenHeight - 40 ) / 2 " w15 h40 NA"

return
*ESC::ExitApp

ButtonHelp:
	Active := 10
	Gui, 2:Show, NA
	Gui, 1:Hide,
	Msgbox, 1, Help, Faciltator will work best when Chrome is maximized and IntakeQ and Registry are the only two tabs open. Right Click Menu Buttons to get help on each of the other buttons.
	Return

TestFunction:
	Active := 10
	Gui, 2:Show, NA
	Gui, 1:Hide,
	return

OpenMenu:
2GuiContextMenu:
	Active := 0
	Gui, 1:Show, NA
	Gui, 2:Hide,
	SetTimer, WatchCursor, 500
	return

GuiContextMenu:
	Active := 10
	Gui, 2:Show, NA
	Gui, 1:Hide,
	return

WatchCursor:
	MouseGetPos,,, win 
	( Win = GuiHwnd && !Active && Active := 1)
	(Active) ? ( Active++ )	
	if( Win != GuiHwnd && Active > 3 ){
		Active := 0
		Gui, 2:Show, NA
		Gui, 1:Hide,
		SetTimer, WatchCursor, Off
	}
	return

;*****************************************************************************************************************************************************************************************
;*****************************************************************************************************************************************************************************************
;*****************************************************************************************************************************************************************************************
HB_BITMAP_MAKER(){
	;Bitmap Created Using: HB Bitmap Maker
	pBitmap := Gdip_CreateBitmap( 160 , 500 ) , G := Gdip_GraphicsFromImage( pBitmap ) , Gdip_SetSmoothingMode( G , 2 )
	Brush := Gdip_BrushCreateSolid( "0xFF22262a" ) , Gdip_FillRectangle( G , Brush , -10 , -10 , 200 , 550 ) , Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF02060A" , 1 ) , Gdip_DrawRectangle( G , Pen , 0 , 0 , 159 , 499 ) , Gdip_DeletePen( Pen )
	Brush := Gdip_CreateLineBrushFromRect( 10 , 13 , 138 , 36 , "0xFFF0F0F0" , "0xFF000000" , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 20 , 10 , 120 , 30 , 5 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF222222" ) , Gdip_FillRoundedRectangle( G , Brush , 21 , 11 , 118 , 28 , 5 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" ) , Gdip_TextToGraphics( G , "TERMINATOR" , "s12 Center vCenter Bold c" Brush " x23 y13" , "Segoe UI" , 118 , 28 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFFFFF00" ) , Gdip_TextToGraphics( G , "TERMINATOR" , "s12 Center vCenter Bold c" Brush " x21 y11" , "Segoe UI" , 118 , 28 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF02060A" ) , Gdip_FillRectangle( G , Brush , 10 , 50 , 140 , 440 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_CreateLineBrushFromRect( 13 , 50 , 132 , 437 , "0xFF333333" , "0xFF000000" , 1 , 1 ) , Gdip_FillRectangle( G , Brush , 11 , 51 , 138 , 438 ) , Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF32363a" ) , Gdip_FillRectangle( G , Brush , 12 , 52 , 136 , 436 ) , Gdip_DeleteBrush( Brush )
	Gdip_DeleteGraphics( G )
	hBitmap := Gdip_CreateHBITMAPFromBitmap( pBitmap )
	return hBitmap
}
HBCustomButton(){
	local MyButtonDesign := {}
	MyButtonDesign.All := {}
	MyButtonDesign.Default := {}
	MyButtonDesign.Hover := {}
	MyButtonDesign.Pressed := {}
	;********************************
	;All
	MyButtonDesign.All.W := 200 , MyButtonDesign.All.H := 65 , MyButtonDesign.All.Text := " Button " , MyButtonDesign.All.Font := "Arial" , MyButtonDesign.All.FontSize := "16" , MyButtonDesign.All.BackgroundColor := "0xFF22262A" , MyButtonDesign.All.ButtonAddGlossy := "0"
	;********************************
	;Default
	MyButtonDesign.Default.W := 200 , MyButtonDesign.Default.H := 65 , MyButtonDesign.Default.Text := "Button" , MyButtonDesign.Default.Font := "Arial" , MyButtonDesign.Default.FontOptions := " Bold Center vCenter " , MyButtonDesign.Default.FontSize := "16" , MyButtonDesign.Default.H := "0xFF02112F" , MyButtonDesign.Default.TextBottomColor2 := "0xFF02112F" , MyButtonDesign.Default.TextTopColor1 := "0xFFFFFFFF" , MyButtonDesign.Default.TextTopColor2 := "0xFFFFFFFF" , MyButtonDesign.Default.TextOffsetX := "0" , MyButtonDesign.Default.TextOffsetY := "0" , MyButtonDesign.Default.TextOffsetW := "0" , MyButtonDesign.Default.TextOffsetH := "0" , MyButtonDesign.Default.BackgroundColor := "0xFF22262A" , MyButtonDesign.Default.ButtonOuterBorderColor := "0xFF161B1F" , MyButtonDesign.Default.ButtonCenterBorderColor := "0xFF262B2F" , MyButtonDesign.Default.ButtonInnerBorderColor1 := "0xFF3F444A" , MyButtonDesign.Default.ButtonInnerBorderColor2 := "0xFF24292D" , MyButtonDesign.Default.ButtonMainColor1 := "0xFF197E9C" , MyButtonDesign.Default.ButtonMainColor2 := "0xFF12595B" , MyButtonDesign.Default.ButtonAddGlossy := "0" , MyButtonDesign.Default.GlossTopColor := "0x11FFFFFF" , MyButtonDesign.Default.GlossTopAccentColor := "05FFFFFF" , MyButtonDesign.Default.GlossBottomColor := "33000000"
	;********************************
	;Hover
	MyButtonDesign.Hover.W := 200 , MyButtonDesign.Hover.H := 65 , MyButtonDesign.Hover.Text := "Button" , MyButtonDesign.Hover.Font := "Arial" , MyButtonDesign.Hover.FontOptions := " Bold Center vCenter " , MyButtonDesign.Hover.FontSize := "16" , MyButtonDesign.Hover.H := "0xff02112F" , MyButtonDesign.Hover.TextBottomColor2 := "0xff02112F" , MyButtonDesign.Hover.TextTopColor1 := "0xFFFFFFFF" , MyButtonDesign.Hover.TextTopColor2 := "0xFFFFFFFF" , MyButtonDesign.Hover.TextOffsetX := "0" , MyButtonDesign.Hover.TextOffsetY := "0" , MyButtonDesign.Hover.TextOffsetW := "0" , MyButtonDesign.Hover.TextOffsetH := "0" , MyButtonDesign.Hover.BackgroundColor := "0xFF22262A" , MyButtonDesign.Hover.ButtonOuterBorderColor := "0xFF161B1F" , MyButtonDesign.Hover.ButtonCenterBorderColor := "0xFF262B2F" , MyButtonDesign.Hover.ButtonInnerBorderColor1 := "0xFF3F444A" , MyButtonDesign.Hover.ButtonInnerBorderColor2 := "0xFF24292D" , MyButtonDesign.Hover.ButtonMainColor1 := "0xFF39C9F7" , MyButtonDesign.Hover.ButtonMainColor2 := "0xFF197E9C" , MyButtonDesign.Hover.ButtonAddGlossy := "0" , MyButtonDesign.Hover.GlossTopColor := "0x11FFFFFF" , MyButtonDesign.Hover.GlossTopAccentColor := "05FFFFFF" , MyButtonDesign.Hover.GlossBottomColor := "33000000"
	;********************************
	;Pressed
	MyButtonDesign.Pressed.W := 200 , MyButtonDesign.Pressed.H := 65 , MyButtonDesign.Pressed.Text := "Button" , MyButtonDesign.Pressed.Font := "Arial" , MyButtonDesign.Pressed.FontOptions := " Bold Center vCenter " , MyButtonDesign.Pressed.FontSize := "16" , MyButtonDesign.Pressed.H := "0xff02112F" , MyButtonDesign.Pressed.TextBottomColor2 := "0xff02112F" , MyButtonDesign.Pressed.TextTopColor1 := "0xFFFFFFFF" , MyButtonDesign.Pressed.TextTopColor2 := "0xFFFFFFFF" , MyButtonDesign.Pressed.TextOffsetX := "0" , MyButtonDesign.Pressed.TextOffsetY := "0" , MyButtonDesign.Pressed.TextOffsetW := "0" , MyButtonDesign.Pressed.TextOffsetH := "0" , MyButtonDesign.Pressed.BackgroundColor := "0xFF22262A" , MyButtonDesign.Pressed.ButtonOuterBorderColor := "0xFF62666a" , MyButtonDesign.Pressed.ButtonCenterBorderColor := "0xFF262B2F" , MyButtonDesign.Pressed.ButtonInnerBorderColor1 := "0xFF151A20" , MyButtonDesign.Pressed.ButtonInnerBorderColor2 := "0xFF151A20" , MyButtonDesign.Pressed.ButtonMainColor1 := "0xFF12595B" , MyButtonDesign.Pressed.ButtonMainColor2 := "0xFF197E9C" , MyButtonDesign.Pressed.ButtonAddGlossy := "0" , MyButtonDesign.Pressed.GlossTopColor := "0x11FFFFFF" , MyButtonDesign.Pressed.GlossTopAccentColor := "05FFFFFF" , MyButtonDesign.Pressed.GlossBottomColor := "33000000"
	;********************************
	
	return MyButtonDesign
}
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
Class HButton	{
	;Gen 3 Button Class By Hellbent
	static init , Button := [] , Active , LastControl , HoldCtrl 
	
	__New( Input := "" , All := "" , Default := "" , Hover := "" , Pressed := "" ){
		
		local hwnd 
		
			;If this is the first time the class is being used.
		if( !HButton.init && HButton.init := 1 )
			
				;Set a timer to watch to see if the cursor goes over one of the controls.
			HButton._SetHoverTimer()
			
		This._CreateNewButtonObject( hwnd := This._CreateControl( Input ) , Input )
		
		This._BindButton( hwnd , Input )
		
		This._GetButtonBitmaps( hwnd , Input , All , Default , Hover , Pressed )
		
		This._DisplayButton( hwnd , HButton.Button[hwnd].Bitmaps.Default.hBitmap )
		
		return hwnd
	}

	_DisplayButton( hwnd , hBitmap){
		
		SetImage( hwnd , hBitmap )
		
	}
	
	_GetButtonBitmaps( hwnd , Input := "" , All := "" , Default := "" , Hover := "" , Pressed := "" ){
	
		HButton.Button[hwnd].Bitmaps := GuiButtonType1.CreateButtonBitmapSet( Input , All , Default , Hover , Pressed )
		
	}
	
	_CreateNewButtonObject( hwnd , Input ){
		
		local k , v  
		
		HButton.Button[ hwnd ] := {}
		
		for k , v in Input
			
			HButton.Button[ hwnd ][ k ] := v
		
		HButton.Button[ hwnd ].Hwnd := hwnd
		
	}
	
	_CreateControl( Input ){
		
		local hwnd
		
		Gui , % Input.Owner ":Add" , Pic , % "x" Input.X " y" Input.Y " w" Input.W " h" Input.H " hwndhwnd 0xE"  
		
		return hwnd
		
	}
	
	_BindButton( hwnd , Input ){
		
		local bd
		
		bd := This._OnClick.Bind( This )
		
		GuiControl, % Input.Owner ":+G" , % hwnd , % bd
		
	}
	
	_SetHoverTimer( timer := "" ){
		
		local HoverTimer 

		if( !HButton.HoverTimer ) 
			
			HButton.HoverTimer := ObjBindMethod( HButton , "_OnHover" ) 
		
		HoverTimer := HButton.HoverTimer
		
		SetTimer , % HoverTimer , % ( Timer ) ? ( Timer ) : ( 100 )
		
	}
	
	_OnHover(){
		
		local Ctrl
		
		MouseGetPos,,,,ctrl,2
		
		if( HButton.Button[ ctrl ] && !HButton.Active ){
			
			HButton.Active := 1
			
			HButton.LastControl := ctrl
			
			HButton._DisplayButton( ctrl , HButton.Button[ ctrl ].Bitmaps.Hover.hBitmap )
			
		}else if( HButton.Active && ctrl != HButton.LastControl ){
			
			HButton.Active := 0
			
			HButton._DisplayButton( HButton.LastControl , HButton.Button[ HButton.LastControl ].Bitmaps.Default.hBitmap )

		}
		
	}
	
	_OnClick(){
		
		local Ctrl, last
		
		HButton._SetHoverTimer( "Off" )
		
		MouseGetPos,,,, Ctrl , 2
		last := ctrl
		HButton._SetFocus( ctrl )
		HButton._DisplayButton( last , HButton.Button[ last ].Bitmaps.Pressed.hBitmap )
		
		While(GetKeyState("LButton"))
			sleep, 60
		
		HButton._SetHoverTimer()
		
		loop, 2
			This._OnHover()
		
		MouseGetPos,,,, Ctrl , 2
		
		if(ctrl!=last){
			
			HButton._DisplayButton( last , HButton.Button[ last ].Bitmaps.Default.hBitmap )
		
		}else{
			HButton._DisplayButton( last , HButton.Button[ last ].Bitmaps.Hover.hBitmap )
			if( HButton.Button[ last ].Label ){
			
			if(IsFunc( HButton.Button[ last ].Label ) )
				
				fn := Func( HButton.Button[ last ].Label )
				, fn.Call()
				
			else 
				
				gosub, % HButton.Button[ last ].Label
			}
		
		}
		
	}
	
	_SetFocus( ctrl ){
		
		GuiControl, % HButton.Button[ ctrl ].Owner ":Focus" , % ctrl
		
	}
	
	DeleteButton( hwnd ){
		
		for k , v in HButton.Button[ hwnd ].Bitmaps
				Gdip_DisposeImage( HButton.Button[hwnd].Bitmaps[k].pBitmap )
				, DeleteObject( HButton.Button[ hwnd ].Bitmaps[k].hBitmap )
				
		GuiControl , % HButton.Button[ hwnd ].Owner ":Move", % hwnd , % "x-1 y-1 w0 h0" 
		HButton.Button[ hwnd ] := ""
	}
	
}
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
;****************************************************************************************************************************************************************************************
Class GuiButtonType1	{

	static List := [ "Default" , "Hover" , "Pressed" ]
	
	_CreatePressedBitmap(){
		
		local arr := [] , Bitmap := {} , fObj := This.CurrentBitmapData.Pressed
		
		Bitmap.pBitmap := Gdip_CreateBitmap( fObj.W , fObj.H ) , G := Gdip_GraphicsFromImage( Bitmap.pBitmap ) , Gdip_SetSmoothingMode( G , 2 )
		
		Brush := Gdip_BrushCreateSolid( fObj.BackgroundColor ) , Gdip_FillRectangle( G , Brush , -1 , -1 , fObj.W+2 , fObj.H+2 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_BrushCreateSolid( fObj.ButtonOuterBorderColor ) , Gdip_FillRoundedRectangle( G , Brush , 3 , 4 , fObj.W-7 , fObj.H-7 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , fObj.W , fObj.H , fObj.ButtonInnerBorderColor1 , fObj.ButtonInnerBorderColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 2 , 3 , fObj.W-5 , fObj.H-8 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , fObj.W-7 , fObj.H-10 , fObj.ButtonMainColor1 , fObj.ButtonMainColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 5 , 5 , fObj.W-11 , fObj.H-12 , 5 ) , Gdip_DeleteBrush( Brush )
			
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextBottomColor1 , fObj.TextBottomColor2 , 1 , 1 )
		
		arr := [ { X: -1 , Y: -1 } , { X: 0 , Y: -1 } , { X: 1 , Y: -1 } , { X: -1 , Y: 0 } , { X: 1 , Y: 0 } , { X: -1 , Y: 1 } , { X: 0 , Y: 1 } , { X: 1 , Y: 1 } ]
		
		Loop, % 8
			
			Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 1 + arr[A_Index].X + fObj.TextOffsetX " y" 3 + arr[A_Index].Y + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextTopColor1 , fObj.TextTopColor2 , 1 , 1 )
		
		Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 1 + fObj.TextOffsetX " y" 3 + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
	if( fObj.ButtonAddGlossy ){
		
		Brush := Gdip_BrushCreateSolid( fObj.GlossTopColor ) , Gdip_FillRectangle( G , Brush , 5 , 10 , fObj.W-11 , ( fObj.H / 2 ) - 10   ) , Gdip_DeleteBrush( Brush )

		Brush := Gdip_BrushCreateSolid( fObj.GlossTopAccentColor ) , Gdip_FillRectangle( G , Brush , 10 , 12 , fObj.W-21 , fObj.H / 15 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_BrushCreateSolid( fObj.GlossBottomColor ) , Gdip_FillRectangle( G , Brush , 5  , 10 + ( fObj.H / 2 ) - 10 , fObj.W-11 , ( fObj.H / 2 ) - 7 ) , Gdip_DeleteBrush( Brush )
				
	}

		Gdip_DeleteGraphics( G )
		
		Bitmap.hBitmap := Gdip_CreateHBITMAPFromBitmap( Bitmap.pBitmap )
		
		return Bitmap
	}
	
	_CreateHoverBitmap(){
		
		local arr := [] , Bitmap := {} , fObj := This.CurrentBitmapData.Hover
		
		Bitmap.pBitmap := Gdip_CreateBitmap( fObj.W , fObj.H ) , G := Gdip_GraphicsFromImage( Bitmap.pBitmap ) , Gdip_SetSmoothingMode( G , 2 )
		
		Brush := Gdip_BrushCreateSolid( fObj.BackgroundColor ) , Gdip_FillRectangle( G , Brush , -1 , -1 , fObj.W+2 , fObj.H+2 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_BrushCreateSolid( fObj.ButtonOuterBorderColor ) , Gdip_FillRoundedRectangle( G , Brush , 2 , 3 , fObj.W-5 , fObj.H-7 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_BrushCreateSolid( fObj.ButtonCenterBorderColor ) , Gdip_FillRoundedRectangle( G , Brush , 3 , 4 , fObj.W-7 , fObj.H-9 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , fObj.W , fObj.H-10 , fObj.ButtonInnerBorderColor1 , fObj.ButtonInnerBorderColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 4 , 5 , fObj.W-9 , fObj.H-11 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 5 , 7 , fObj.W-11 , fObj.H-14 , fObj.ButtonMainColor1 , fObj.ButtonMainColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 5 , 7 , fObj.W-11 , fObj.H-14 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextBottomColor1 , fObj.TextBottomColor2 , 1 , 1 )
		
		arr := [ { X: -1 , Y: -1 } , { X: 0 , Y: -1 } , { X: 1 , Y: -1 } , { X: -1 , Y: 0 } , { X: 1 , Y: 0 } , { X: -1 , Y: 1 } , { X: 0 , Y: 1 } , { X: 1 , Y: 1 } ]
		
		Loop, % 8
			
			Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 0 + arr[A_Index].X + fObj.TextOffsetX " y" 2 + arr[A_Index].Y + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextTopColor1 , fObj.TextTopColor2 , 1 , 1 )
		
		Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 0 + fObj.TextOffsetX " y" 2 + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
		if( fObj.ButtonAddGlossy = 1 ){
			
			Brush := Gdip_BrushCreateSolid( fObj.GlossTopColor ) , Gdip_FillRectangle( G , Brush , 6 , 10 , fObj.W-13 , ( fObj.H / 2 ) - 10   ) , Gdip_DeleteBrush( Brush )
			
			Brush := Gdip_BrushCreateSolid( fObj.GlossTopAccentColor ) , Gdip_FillRectangle( G , Brush , 10 , 12 , fObj.W-21 , fObj.H / 15 ) , Gdip_DeleteBrush( Brush )
			
			Brush := Gdip_BrushCreateSolid( fObj.GlossBottomColor ) , Gdip_FillRectangle( G , Brush , 6  , 10 + ( fObj.H / 2 ) - 10 , fObj.W-13 , ( fObj.H / 2 ) - 7 ) , Gdip_DeleteBrush( Brush )
					
		}
	
		Gdip_DeleteGraphics( G )
		
		Bitmap.hBitmap := Gdip_CreateHBITMAPFromBitmap( Bitmap.pBitmap )
		
		return Bitmap
		
	}
	
	_CreateDefaultBitmap(){
		
		local arr := [] , Bitmap := {} , fObj := This.CurrentBitmapData.Default
		
		Bitmap.pBitmap := Gdip_CreateBitmap( fObj.W , fObj.H ) , G := Gdip_GraphicsFromImage( Bitmap.pBitmap ) , Gdip_SetSmoothingMode( G , 2 )
	
		Brush := Gdip_BrushCreateSolid( fObj.BackgroundColor ) , Gdip_FillRectangle( G , Brush , -1 , -1 , fObj.W+2 , fObj.H+2 ) , Gdip_DeleteBrush( Brush )
	
		Brush := Gdip_BrushCreateSolid( fObj.ButtonOuterBorderColor ) , Gdip_FillRoundedRectangle( G , Brush , 2 , 3 , fObj.W-5 , fObj.H-7 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_BrushCreateSolid( fObj.ButtonCenterBorderColor ) , Gdip_FillRoundedRectangle( G , Brush , 3 , 4 , fObj.W-7 , fObj.H-9 , 5 ) , Gdip_DeleteBrush( Brush )
	
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , fObj.W , fObj.H-10 , fObj.ButtonInnerBorderColor1 , fObj.ButtonInnerBorderColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 4 , 5 , fObj.W-9 , fObj.H-11 , 5 ) , Gdip_DeleteBrush( Brush )
	
		Brush := Gdip_CreateLineBrushFromRect( 5 , 7 , fObj.W-11 , fObj.H-14 , fObj.ButtonMainColor1 , fObj.ButtonMainColor2 , 1 , 1 ) , Gdip_FillRoundedRectangle( G , Brush , 5 , 7 , fObj.W-11 , fObj.H-14 , 5 ) , Gdip_DeleteBrush( Brush )
		
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextBottomColor1 , fObj.TextBottomColor2 , 1 , 1 )
		
		arr := [ { X: -1 , Y: -1 } , { X: 0 , Y: -1 } , { X: 1 , Y: -1 } , { X: -1 , Y: 0 } , { X: 1 , Y: 0 } , { X: -1 , Y: 1 } , { X: 0 , Y: 1 } , { X: 1 , Y: 1 } ]
		
		Loop, % 8
			
			Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 0 + arr[A_Index].X + fObj.TextOffsetX " y" 2 + arr[A_Index].Y + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
		Brush := Gdip_CreateLineBrushFromRect( 0 , 2 , fObj.W , fObj.H , fObj.TextTopColor1 , fObj.TextTopColor2 , 1 , 1 )
		
		Gdip_TextToGraphics( G , fObj.Text , "s" fObj.FontSize " " fObj.FontOptions " c" Brush " x" 0 + fObj.TextOffsetX " y" 2 + fObj.TextOffsetY , fObj.Font , fObj.W + fObj.TextOffsetW , fObj.H + fObj.TextOffsetH )
	
		if( fObj.ButtonAddGlossy ){
		
			Brush := Gdip_BrushCreateSolid( fObj.GlossTopColor ) , Gdip_FillRectangle( G , Brush , 6 , 10 , fObj.W-13 , ( fObj.H / 2 ) - 10   ) , Gdip_DeleteBrush( Brush )
			
			Brush := Gdip_BrushCreateSolid( fObj.GlossTopAccentColor ) , Gdip_FillRectangle( G , Brush , 10 , 12 , fObj.W-21 , fObj.H / 15 ) , Gdip_DeleteBrush( Brush )
			
			Brush := Gdip_BrushCreateSolid( fObj.GlossBottomColor ) , Gdip_FillRectangle( G , Brush , 6  , 10 + ( fObj.H / 2 ) - 10 , fObj.W-13 , ( fObj.H / 2 ) - 7 ) , Gdip_DeleteBrush( Brush )
				
		}
	
		Gdip_DeleteGraphics( G )
		
		Bitmap.hBitmap := Gdip_CreateHBITMAPFromBitmap( Bitmap.pBitmap )
		
		return Bitmap
		
	}
	
	_GetMasterDefaultValues(){ ;Default State
		
		local Default := {}
		
		Default.pBitmap := "" 
		, Default.hBitmap := ""
		, Default.Font := "Arial"
		, Default.FontOptions := " Bold Center vCenter "
		, Default.FontSize := "12"
		, Default.Text := "Button"
		, Default.W := 10
		, Default.H := 10
		, Default.TextBottomColor1 := "0x0002112F"
		, Default.TextBottomColor2 := Default.TextBottomColor1
		, Default.TextTopColor1 := "0xFFFFFFFF"
		, Default.TextTopColor2 := "0xFF000000"
		, Default.TextOffsetX := 0
		, Default.TextOffsetY := 0
		, Default.TextOffsetW := 0
		, Default.TextOffsetH := 0
		, Default.BackgroundColor := "0xFF22262A"
		, Default.ButtonOuterBorderColor := "0xFF161B1F"	
		, Default.ButtonCenterBorderColor := "0xFF262B2F"	
		, Default.ButtonInnerBorderColor1 := "0xFF3F444A"
		, Default.ButtonInnerBorderColor2 := "0xFF24292D"
		, Default.ButtonMainColor1 := "0xFF272C32"
		, Default.ButtonMainColor2 := "" Default.ButtonMainColor1
		, Default.ButtonAddGlossy := 0
		, Default.GlossTopColor := "0x11FFFFFF"
		, Default.GlossTopAccentColor := "0x05FFFFFF"	
		, Default.GlossBottomColor := "0x33000000"
		
		return Default
		
	}
	
	_GetMasterHoverValues(){ ;Hover State
		
		local Default := {}
		
		Default.pBitmap := ""
		, Default.hBitmap := ""
		, Default.Font := "Arial"
		, Default.FontOptions := " Bold Center vCenter "
		, Default.FontSize := "12"
		, Default.Text := "Button"
		, Default.W := 10
		, Default.H := 10
		, Default.TextBottomColor1 := "0x0002112F"
		, Default.TextBottomColor2 := Default.TextBottomColor1
		, Default.TextTopColor1 := "0xFFFFFFFF"
		, Default.TextTopColor2 := "0xFF000000"
		, Default.TextOffsetX := 0
		, Default.TextOffsetY := 0
		, Default.TextOffsetW := 0
		, Default.TextOffsetH := 0
		, Default.BackgroundColor := "0xFF22262A"
		, Default.ButtonOuterBorderColor := "0xFF161B1F"	
		, Default.ButtonCenterBorderColor := "0xFF262B2F"	
		, Default.ButtonInnerBorderColor1 := "0xFF3F444A"
		, Default.ButtonInnerBorderColor2 := "0xFF24292D"
		, Default.ButtonMainColor1 := "0xFF373C42"
		, Default.ButtonMainColor2 := "" Default.ButtonMainColor1
		, Default.ButtonAddGlossy := 0
		, Default.GlossTopColor := "0x11FFFFFF"
		, Default.GlossTopAccentColor := "0x05FFFFFF"	
		, Default.GlossBottomColor := "0x33000000"
		
		return Default
		
	}
	
	_GetMasterPressedValues(){ ;Pressed State
		
		local Default := {}
		
		Default.pBitmap := ""
		, Default.hBitmap := ""
		, Default.Font := "Arial"
		, Default.FontOptions := " Bold Center vCenter "
		, Default.FontSize := "12"
		, Default.Text := "Button"
		, Default.W := 10
		, Default.H := 10
		, Default.TextBottomColor1 := "0x0002112F"
		, Default.TextBottomColor2 := Default.TextBottomColor1
		, Default.TextTopColor1 := "0xFFFFFFFF"
		, Default.TextTopColor2 := "0xFF000000"
		, Default.TextOffsetX := 0
		, Default.TextOffsetY := 0
		, Default.TextOffsetW := 0
		, Default.TextOffsetH := 0
		, Default.BackgroundColor := "0xFF22262A"
		, Default.ButtonOuterBorderColor := "0xFF62666a"
		, Default.ButtonCenterBorderColor := "0xFF262B2F"	
		, Default.ButtonInnerBorderColor1 := "0xFF151A20"
		, Default.ButtonInnerBorderColor2 := "0xFF151A20"
		, Default.ButtonMainColor1 := "0xFF12161a"
		, Default.ButtonMainColor2 := "0xFF33383E"
		, Default.ButtonAddGlossy := 0
		, Default.GlossTopColor := "0x11FFFFFF"
		, Default.GlossTopAccentColor := "0x05FFFFFF"	
		, Default.GlossBottomColor := "0x33000000"
	
		return Default
		
	}
	
	SetSessionDefaults( All := "" , Default := "" , Hover := "" , Pressed := "" ){ ;Set the default values based on user input
		
		This.SessionBitmapData := {} 
		, This.Preset := 1
		, This.init := 0
		
		This._LoadDefaults("SessionBitmapData")
		
		This._SetSessionData( All , Default , Hover , Pressed )
		
	}
	
	_SetSessionData( All := "" , Default := "" , Hover := "" , Pressed := "" ){
		
		local index , k , v , i , j
	
		if( IsObject( All ) ){
			
			Loop, % GuiButtonType1.List.Length()	{
				index := A_Index
				For k , v in All
					This.SessionBitmapData[ GuiButtonType1.List[ index ] ][ k ] := v
			}
		}
		
		For k , v in GuiButtonType1.List
			if( isObject( %v% ) )
				For i , j in %v%
					This.SessionBitmapData[ GuiButtonType1.List[ k ] ][ i ] := j
				
	}
	
	_LoadDefaults( input := "" ){
		
		This.CurrentBitmapData := "" , This.CurrentBitmapData := {}
			
		For k , v in This.SessionBitmapData
			This.CurrentBitmapData[k] := {}
		
		This[ input ].Default := This._GetMasterDefaultValues()
		, This[ input ].Hover := This._GetMasterHoverValues()
		, This[ input ].Pressed := This._GetMasterPressedValues()
		
	}
	
	_SetCurrentBitmapDataFromSessionData(){
		
		local k , v , i , j
			
		This.CurrentBitmapData := "" , This.CurrentBitmapData := {}
			
		For k , v in This.SessionBitmapData
		{
			This.CurrentBitmapData[k] := {}
			
			For i , j in This.SessionBitmapData[k]
				
				This.CurrentBitmapData[k][i] := j

		}
		
	}
	
	_UpdateCurrentBitmapData( All := "" , Default := "" , Hover := "" , Pressed := "" ){
		
		local k , v , i , j
		
		if( IsObject( All ) ){
			
			Loop, % GuiButtonType1.List.Length()	{
				
				index := A_Index
			
				For k , v in All
					
					This.CurrentBitmapData[ GuiButtonType1.List[ index ] ][ k ] := v
					
			}
		}
		
		For k , v in GuiButtonType1.List
			
			if( isObject( %v% ) )
				
				For i , j in %v%
					
					This.CurrentBitmapData[ GuiButtonType1.List[ k ] ][ i ] := j
				
	}
	
	_UpdateInstanceData( obj := ""){
		
		For k , v in GuiButtonType1.List	
			
			This.CurrentBitmapData[v].Text := obj.Text
			, This.CurrentBitmapData[v].W := obj.W
			, This.CurrentBitmapData[v].H := obj.H
			
	}

	CreateButtonBitmapSet( obj := "" ,  All := "" , Default := "" , Hover := "" , Pressed := ""  ){ ;Create a new button
		
		local Bitmaps := {}
		
		if( This.Preset )
				
			This._SetCurrentBitmapDataFromSessionData()
			
		else
			
			This._LoadDefaults( "CurrentBitmapData" )
			
		This._UpdateCurrentBitmapData( All , Default , Hover , Pressed )
		
		This._UpdateInstanceData( obj )
		 
		Bitmaps.Default := This._CreateDefaultBitmap()
		, Bitmaps.Hover := This._CreateHoverBitmap()
		, Bitmaps.Pressed := This._CreatePressedBitmap()
		
		return Bitmaps
		
	}
	
}

