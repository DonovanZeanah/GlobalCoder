#include d:\lib\Vis2.ahk ; https://www.autohotkey.com/boards/viewtopic.php?t=36047
y := x := 100, height := width := 400
pToken := Gdip_Startup()
snap := Gdip_BitmapFromScreen(x "|" y "|" width "|" height) ; x|y|width|height
base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(snap, "JPG")
bitmap := GDIp_BitmapFromBase64(base64)
hBitmap := Gdip_CreateHBITMAPFromBitmap(bitmap)
Gdip_DisposeImage(snap), Gdip_DisposeImage(bitmap)
Gdip_Shutdown(pToken)
Gui, New
; https://www.autohotkey.com/boards/viewtopic.php?p=117639#p117639
Gui, Add, Pic, vPic +Border, % "HBITMAP:*" hBitmap
Gui, Show


;****************************************************************************************************************************************************************************
#Include d:\lib\gdip.ahk

;****************************************************************************************************************************************************************************
#SingleInstance, Force
SetBatchlines, -1
GDIP_STARTUP()

Main := {}
Main.InputPBitmap := ""
Main.InputHBitmap := ""
Main.OutPBitmap := ""
Main.OutHBitmap := ""
Main.OGBit := 60

Main.Position := { X: 0 , Y: 0 , W: 60 , H: 60 }
Main.SliderValue := Main.Position.W


Gui, New, +AlwaysOnTop hwndhwnd
Main.GuiHwnd := hwnd
Gui, Add, Text, xm ym w200 hwndhwnd , % Main.SliderValue
Main.TextHwnd := hwnd
Gui, Add, Button, xm  w300 gCaptureScreen, Capture New Icon
Gui, Add, Picture, xm w300 h300 hwndhwnd 0xE
Main.PicHwnd := hwnd
Gui, Add, Slider, xm w300 Range10-300 hwndhwnd AltSubmit ToolTip gAdjustSlider, % Main.SliderValue
Main.SliderHwnd := hwnd
Gui, Add, Button, xm w300 gClipboardBase64 , Clipboard Base64
Gui, Show

Main.Gui1 := New PopUpWindow( { AutoShow: 1 , X: 1200 , Y: 100 , W: 300 , H: 300 , Options: " -DPIScale +AlwaysOnTop +ToolWindow " } )

return
GuiClose:
GuiContextMenu:
*ESC::ExitApp

RAlt::PopUpWindow.Helper()

ClipboardBase64:
  Clipboard := ""
  sleep, 100
   ;Main.OutPBitmap ;<--------- output pBitmap
   ;Main.OutHBitmap ;<--------- output hBitmap
   
  ;******
  
  return

AdjustSlider:
  GuiControlGet, out,, % Main.SliderHwnd
  Main.Position.H := Main.Position.W := Main.SliderValue := out
  Gdip_DisposeImage( Main.OutPBitmap )
  DeleteObject( Main.OutHBitmap )
  Main.OutPBitmap := Gdip_CreateBitmap( Main.SliderValue  , Main.SliderValue ) , G := Gdip_GraphicsFromImage( Main.OutPBitmap ) , Gdip_SetSmoothingMode( G , 2 )
  Gdip_DrawImage( G , Main.InputPBitmap , 0 , 0 , Main.SliderValue , Main.SliderValue , 0 , 0 , Main.OGBit , Main.OGBit ) 
  ;~ Pen := Gdip_CreatePen( "0xFF000000" , 3 ) , Gdip_DrawEllipse( G , Pen , 1 , 1 , Main.SliderValue - 3 , Main.SliderValue - 3 ) , Gdip_DeletePen( Pen )
  Gdip_DeleteGraphics( G )
  Main.OutHBitmap := Gdip_CreateHBITMAPFromBitmap( Main.OutPBitmap )
  SetImage( Main.PicHwnd , Main.OutHBitmap )
  GuiControl, % Main.GuiHwnd ":" , % Main.TextHwnd , % Main.Position.W
  return
  
CaptureScreen:
  CoordMode, Mouse, Screen
  CoordMode, ToolTip, Screen
  MouseGetPos, x, y
  Main.Gui1.UpdateSettings( { X: x - ( Main.Position.W / 2 ) , Y: y - ( Main.Position.H / 2 ) } )
  Main.Gui1.DrawBitmap( HB_BITMAP_MAKER( Main.Position ) , { X: 0 , Y: 0 , W: Main.Gui1.W , H: Main.Gui1.H } , dispose := 1 , AutoUpdate := 1 )
  Main.Active := 1
  lw := ""
  While( !GetKeyState( "ctrl" ) ){
    ToolTip, Press "Ctrl" to capture icon. `nUse Wheel And Arrow Keys To Adjust Size Position ( Shift ) , x + Main.Position.W , y + Main.Position.W
    if( lw != Main.Position.W && lw := Main.Position.W )
      GuiControl, % Main.GuiHwnd ":" , % Main.TextHwnd , % Main.Position.W
      
    MouseGetPos, x, y
    Main.Gui1.UpdateSettings( { X: x - ( Main.Position.W / 2 ) , Y: y - ( Main.Position.H / 2 ) } )
    Main.Gui1.ShowWindow()
  }
  ToolTip,
  Main.Gui1.ClearWindow( 1 )
  Main.SliderValue := Main.Position.W
  GuiControl, % Main.GuiHwnd ":" , % Main.SliderHwnd , % Main.SliderValue
  
  ;Capture screen clip. 
  Main.InputPBitmap := Gdip_BitmapFromScreen( Main.Gui1.X "|" Main.Gui1.Y "|" Main.Position.W "|" Main.Position.H ) 
  ;*************************************************
  ; In here I need to create a bitmap of the cropped image and draw a border ring around it
  ;
  ;
  ;************************************************
  G := Gdip_GraphicsFromImage( Main.InputPBitmap ) , Gdip_SetSmoothingMode( G , 2 )
  ;~ Pen := Gdip_CreatePen( "0xFF000000" , 3 ) , Gdip_DrawEllipse( G , Pen , 1 , 1 , Main.Position.W - 3 , Main.Position.H - 3 ) , Gdip_DeletePen( Pen )
  Gdip_DeleteGraphics( G )
  Main.OGBit := Main.Position.W
  Main.InputHBitmap := Gdip_CreateHBITMAPFromBitmap( Main.InputPBitmap )
  SetImage( Main.PicHwnd , Main.InputHBitmap )
  Main.Active := 0
  GuiControl, % Main.GuiHwnd ":" , % Main.TextHwnd , % Main.Position.W
  return

#If ( Main.Active )
  
  +WheelUp::
    ( ( Main.Position.W -= 2 ) < 10 ) ? ( Main.Position.W := 10 ) : ( Main.Position.H := Main.Position.W , Main.Gui1.ClearWindow() , Main.Gui1.DrawBitmap( HB_BITMAP_MAKER( Main.Position ) , { X: 0 , Y: 0 , W: Main.Gui1.W , H: Main.Gui1.H } , dispose := 1 , AutoUpdate := 1 ) )
    sleep, 30
    return
  +WheelDown::
    ( ( Main.Position.W += 2 ) > 300 ) ? ( Main.Position.W := 300 ) : ( Main.Position.H := Main.Position.W , Main.Gui1.ClearWindow() , Main.Gui1.DrawBitmap( HB_BITMAP_MAKER( Main.Position ) , { X: 0 , Y: 0 , W: Main.Gui1.W , H: Main.Gui1.H } , dispose := 1 , AutoUpdate := 1 ) )
    sleep, 30
    return
  
  *Up::
    if( GetKeyState( "Shift" ) )
      MouseMove, 0, -10, 0, R
    else
      MouseMove, 0, -1, 0, R
    return
  *Down::
    if( GetKeyState( "Shift" ) )
      MouseMove, 0, +10, 0, R
    else
      MouseMove, 0, +1, 0, R
    return  
  *Left::
    if( GetKeyState( "Shift" ) )
      MouseMove, -10, 0, 0, R
    else
      MouseMove, -1, 0, 0, R
    return  
  *Right::
    if( GetKeyState( "Shift" ) )
      MouseMove, +10, 0, 0, R
    else
      MouseMove, +1, 0, 0, R
    return        
#If

HB_BITMAP_MAKER( obj := "" , ScaleFactor := 1 ){
  ;Bitmap Created Using: HB Bitmap Maker
  pBitmap := Gdip_CreateBitmap( 301 * ScaleFactor , 301 * ScaleFactor ) , G := Gdip_GraphicsFromImage( pBitmap ) , Gdip_SetSmoothingMode( G , 3 )
  Pen := Gdip_CreatePen( "0xFFff0000" , 1 ) , Gdip_DrawRectangle( G , Pen , 0 * ScaleFactor , 0 * ScaleFactor , obj.W * ScaleFactor , obj.H * ScaleFactor ) , Gdip_DeletePen( Pen )
  Gdip_SetSmoothingMode( G , 2 )
  Pen := Gdip_CreatePen( "0xFF3399FF" , 1 ) , Gdip_DrawEllipse( G , Pen , 0 * ScaleFactor , 0 * ScaleFactor , obj.W * ScaleFactor , obj.H * ScaleFactor ) , Gdip_DeletePen( Pen )
  Gdip_DeleteGraphics( G )
  return pBitmap
}


;Layered window class
;####################################################################################################################################################################################
;####################################################################################################################################################################################
;####################################################################################################################################################################################
;####################################################################################################################################################################################
class PopUpWindow {
;PopUpWindow v2.2
;Date Written: Oct 28th, 2021
;Last Edit: Feb 7th, 2022 :Changed the trigger method.
;Written By: Hellbent aka CivReborn
;SpcThanks: teadrinker , malcev 
  static Index := 0 , Windows := [] , Handles := [] , EditHwnd , HelperHwnd
  __New( obj := "" ){
    This._SetDefaults()
    This.UpdateSettings( obj )
    This._CreateWindow()
    This._CreateWindowGraphics()
    if( This.AutoShow )
      This.ShowWindow( This.Title )
  }
  _SetDefaults(){
    This.X := 10
    This.Y := 10
    This.W := 10
    This.H := 10
    This.Smoothing := 2
    This.Options := " -DPIScale +AlwaysOnTop "
    This.AutoShow := 0
    This.GdipStartUp := 0
    This.Title := ""
    
    This.Controls := []
    This.Handles := []
    This.Index := 0 
  }
  AddTrigger( obj ){
    local k , v , cc , bd
    
    This.Controls[ ++This.Index ] := {  X:    10
                    , Y:    10
                    , W:    10
                    , H:    10  }
    for k, v in obj
      This.Controls[ This.Index ][ k ] := obj[ k ] 
    cc := This.Controls[ This.Index ]
    Gui, % This.Hwnd ":Add", Text, % "x" cc.X " y" cc.Y " w" cc.W " h" cc.H " hwndhwnd"
    This.Handles[ hwnd ] := This.Index
    This.Controls[ This.Index ].Hwnd := hwnd
    
    if( IsObject( cc.Label ) ){
      bd := cc.Label
      GuiControl, % This.Hwnd ":+G" , % hwnd , % bd
    }else{
      bd := This._TriggerCall.Bind( This )
      GuiControl, % This.Hwnd ":+G" , % hwnd , % bd
    }
    return hwnd
    
  }
  _TriggerCall(){
    MouseGetPos,,,, ctrl, 2
    Try
      ;~ SetTimer, % This.Controls[ This.Handles[ ctrl ] ].Label, -0
      gosub, % This.Controls[ This.Handles[ ctrl ] ].Label
    
        
  }
  DrawTriggers( color := "0xFFFF0000" , AutoUpdate := 0 ){
    local brush , cc 
    Brush := Gdip_BrushCreateSolid( color ) 
    Gdip_SetSmoothingMode( This.G , 3 )
    loop, % This.Controls.Length()  {
      cc := This.Controls[ A_Index ]
      Gdip_FillRectangle( This.G , Brush , cc.x , cc.y , cc.w , cc.h )
    
    }
    Gdip_DeleteBrush( Brush )
    Gdip_SetSmoothingMode( This.G , This.Smoothing )
    if( AutoUpdate )
      This.UpdateWindow()
  }
  UpdateSettings( obj := "" , UpdateGraphics := 0 ){
    local k , v
    if( IsObject( obj ) )
      for k, v in obj
        This[ k ] := obj[ k ]
    ( This.X = "Center" ) ? ( This.X := ( A_ScreenWidth - This.W ) / 2 )  
    ( This.Y = "Center" ) ? ( This.Y := ( A_ScreenHeight - This.H ) / 2 )   
    if( UpdateGraphics ){
      This._DestroyWindowsGraphics()
      This._CreateWindowGraphics()
    }
  }
  _CreateWindow(){
    local hwnd
    Gui , New, % " +LastFound +E0x80000 hwndhwnd -Caption  " This.Options
    PopUpWindow.Index++
    This.Index := PopUpWindow.Index
    PopUpWindow.Windows[ PopUpWindow.Index ] := This
    This.Hwnd := hwnd
    PopUpWindow.Handles[ hwnd ] := PopUpWindow.Index
    if( This.GdipStartUp && !PopUpWindow.pToken )
      PopUpWindow.pToken := GDIP_STARTUP()
  }
  _DestroyWindowsGraphics(){
    Gdip_DeleteGraphics( This.G )
    SelectObject( This.hdc , This.obm )
    DeleteObject( This.hbm )
    DeleteDC( This.hdc )
  }
  _CreateWindowGraphics(){
    This.hbm := CreateDIBSection( This.W , This.H )
    This.hdc := CreateCompatibleDC()
    This.obm := SelectObject( This.hdc , This.hbm )
    This.G := Gdip_GraphicsFromHDC( This.hdc )
    Gdip_SetSmoothingMode( This.G , This.Smoothing )
  }
  ShowWindow( Title := "" ){
    Gui , % This.Hwnd ":Show", % "x" This.X " y" This.Y " w" This.W " h" This.H " NA", % Title
  }
  HideWindow(){
    Gui , % This.Hwnd ":Hide",
  }
  UpdateWindow(){
    UpdateLayeredWindow( This.hwnd , This.hdc , This.X , This.Y , This.W , This.H )
  }
  ClearWindow( AutoUpdate := 0 ){
    Gdip_GraphicsClear( This.G )
    if( Autoupdate )
      This.UpdateWindow()
  }
  DrawBitmap( pBitmap , obj , dispose := 1 , AutoUpdate := 0 ){
    Gdip_DrawImage( This.G , pBitmap , obj.X , obj.Y , obj.W , obj.H )
    if( dispose )
      Gdip_DisposeImage( pBitmap )
    if( Autoupdate )
      This.UpdateWindow()
  }
  PaintBackground( color := "0xFF000000" , AutoUpdate := 0 ){
    if( isObject( color ) ){
      Brush := Gdip_BrushCreateSolid( ( color.HasKey( "Color" ) ) ? ( color.Color ) : ( "0xFF000000" ) ) 
      if( color.Haskey( "Round" ) )
        Gdip_FillRoundedRectangle( This.G , Brush , color.X , color.Y , color.W , color.H , color.Round )
      else
        Gdip_FillRectangle( This.G , Brush , color.X , color.Y , color.W , color.H ) 
    }else{
      Brush := Gdip_BrushCreateSolid( color ) 
      Gdip_FillRectangle( This.G , Brush , -1 , -1 , This.W + 2 , This.H + 2 ) 
    }
    Gdip_DeleteBrush( Brush )
    if( AutoUpdate )
      This.UpdateWindow()
  }
  DeleteWindow( GDIPShutdown := 0 ){
    Gui, % This.Hwnd ":Destroy"
    SelectObject( This.hdc , This.obm )
    DeleteObject( This.hbm )
    DeleteDC( This.hdc )
    Gdip_DeleteGraphics( This.G )
    hwnd := This.Hwnd
    for k, v in PopUpWindow.Windows[ Hwnd ]
      This[k] := ""
    PopUpWindow.Windows[ Hwnd ] := ""
    if( GDIPShutdown ){
      Gdip_Shutdown( PopUpWindow.pToken )
      PopUpWindow.pToken := ""
    }
  }
  _OnClose( wParam ){
    if( wParam = 0xF060 ){  ;SC_CLOSE ;[ clicking on the gui close button ]
      Try{
        Gui, % PopUpWindow.HelperHwnd ":Destroy"
        SoundBeep, 555
      }
    }
  }
  CreateCachedBitmap( pBitmap , Dispose := 0 ){
    local pCachedBitmap
    if( This.CachedBitmap )
      This.DisposeCachedbitmap()
    DllCall( "gdiplus\GdipCreateCachedBitmap" , "Ptr" , pBitmap , "Ptr" , this.G , "PtrP" , pCachedBitmap )
    This.CachedBitmap := pCachedBitmap
    if( Dispose )
      Gdip_DisposeImage( pBitmap )
  }
  DrawCachedBitmap( AutoUpdate := 0 ){
    DllCall( "gdiplus\GdipDrawCachedBitmap" , "Ptr" , this.G , "Ptr" , This.CachedBitmap , "Int" , 0 , "Int" , 0 )
    if( AutoUpdate )
      This.UpdateWindow()
  }
  DisposeCachedbitmap(){
    DllCall( "gdiplus\GdipDeleteCachedBitmap" , "Ptr" , This.CachedBitmap )
  }
  Helper(){
    local hwnd , MethodList := ["__New","UpdateSettings","ShowWindow","HideWindow","UpdateWindow","ClearWindow","DrawBitmap","PaintBackground","DeleteWindow" , "AddTrigger" , "DrawTriggers", "CreateCachedBitmap" , "DrawCachedBitmap" , "DisposeCachedbitmap" ]
    Gui, New, +AlwaysOnTop +ToolWindow +HwndHwnd
    PopUpWindow.HelperHwnd := hwnd
    Gui, Add, Edit, xm ym w250 r1 Center hwndhwnd, Gui1
    PopUpWindow.EditHwnd := hwnd
    loop, % MethodList.Length() 
      Gui, Add, Button, xm y+1 w250 r1 gPopUpWindow._HelperClip, % MethodList[ A_Index ]
    Gui, Show,,
    OnMessage( 0x112 , This._OnClose.Bind( hwnd ) )
  }
  _HelperClip(){
    local ClipList 
    
    GuiControlGet, out, % PopUpWindow.HelperHwnd ":", % PopUpWindow.EditHwnd  
    
    ClipList :=     {   __New:          " := New PopUpWindow( { AutoShow: 1 , X: 0 , Y: 0 , W: A_ScreenWidth , H: A_ScreenHeight , Options: "" -DPIScale +AlwaysOnTop "" } )"
              , UpdateSettings:     ".UpdateSettings( { X: """" , Y: """" , W: """" , H: """" } , UpdateGraphics := 0 )"
              , ShowWindow:       ".ShowWindow( Title := """" )"
              , HideWindow:       ".HideWindow()"
              , UpdateWindow:     ".UpdateWindow()"
              , ClearWindow:      ".ClearWindow( AutoUpdate := 0 )"
              , DrawBitmap:       ".DrawBitmap( pBitmap := """" , { X: 0 , Y: 0 , W: " Out ".W , H: " Out ".H } , dispose := 1 , AutoUpdate := 0 )"
              , PaintBackground:    ".PaintBackground( color := ""0xFF000000"" , AutoUpdate := 0 )  "  ";{ Color: ""0xFF000000"" , X: 2 , Y: 2 , W: " Out ".W - 4 , H: " Out ".H - 4 , Round: 10 }"
              , DeleteWindow:     ".DeleteWindow( GDIPShutdown := 0 )"
              , AddTrigger:       ".AddTrigger( { X: """" , Y: """" , W: """" , H: """" , Value: """" , Label: """" } )"  
              , DrawTriggers:     ".DrawTriggers( color := ""0xFFFF0000"" , AutoUpdate := 0 )"  
              , CreateCachedBitmap:   ".CreateCachedBitmap( pBitmap , Dispose := 0 )" 
              , DrawCachedBitmap:     ".DrawCachedBitmap( AutoUpdate := 0 )"  
              , DisposeCachedbitmap:  ".DisposeCachedbitmap()"  }
              
    clipboard := Out ClipList[ A_GuiControl ]
    
  }
}

GDIp_BitmapFromBase64(base64) {
 If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64, "UInt", 0, "UInt"
  , 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
  Return False
 VarSetCapacity(Dec, DecLen, 0)
 If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64, "UInt", 0, "UInt"
  , 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
  Return False
 ; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
 ; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
 ;modified by nnnik to return a pBitmap instead
 hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
 pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
 DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
 DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
 DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
 DllCall("Gdiplus.dll\GdipCreateBitmapFromStreamICM",  "Ptr", pStream, "PtrP", pBitmap)
 Return pBitmap
}
