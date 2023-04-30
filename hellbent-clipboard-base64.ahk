;****************************************************************************************************************************************************************************
;Written By: Hellbent
;Date Started: Mar 25th, 2022
;Last Edit: Mar 26th, 2022
;Name: Quick Icon Maker v1.1
;resources: 
;     https://www.autohotkey.com/boards/viewtopic.php?f=76&t=101960&p=453285#p453181 ;export Base64
;     https://www.autohotkey.com/boards/viewtopic.php?f=76&t=101960&p=453285#p453292 ;crop image
;****************************************************************************************************************************************************************************
#Include d:/lib/gdip.ahk ;  <---------       GDIP.ahk
;****************************************************************************************************************************************************************************
#SingleInstance, Force
SetBatchlines, -1
GDIP_STARTUP()

Main := {}

Main.DivAmount := 15000 ;output split string count

Main.Change := 0

Main.InputPBitmap := ""
Main.InputHBitmap := ""
Main.OutPBitmap := ""
Main.OutHBitmap := ""
Main.OGBit := 60

Main.Position := { X: 0 , Y: 0 , W: 60 , H: 60 }
Main.SliderValue := Main.Position.W

Main.RingColor := "000000"
Main.RingAlpha := "FF"

Main.MasterPBitmap := Gdip_CreateBitmap( 300 , 300 )
Main.MasterG := Gdip_GraphicsFromImage( Main.MasterPBitmap ) , Gdip_SetSmoothingMode( Main.MasterG , 2 )
Main.MasterHBitmap := ""

Main.OutputVarName := "QuickIcon"

Gui, New, +AlwaysOnTop hwndhwnd
Main.GuiHwnd := hwnd

;~ Gui, Color, 32363a , 22262a
;~ Gui, Font, cffff00

Gui, Add, CheckBox, xm ym w90 Checked hwndhwnd gAdjustSlider , Add Border
Main.CheckBoxHwnd := hwnd

Gui, Add, Edit, x+10 w70 r1 Center Limit2 hwndhwnd gAdjustSlider , % Main.RingAlpha
Main.Edit1Hwnd := hwnd

Gui, Add, Edit, x+10 w120 r1 Center Limit6 hwndhwnd gAdjustSlider , % Main.RingColor
Main.Edit2Hwnd := hwnd

Gui, Add, Radio, xm w50 hwndhwnd Group gAdjustSlider , 1px
Main.Radio1Hwnd := hwnd

Gui, Add, Radio, x+10 w50 Checked hwndhwnd gAdjustSlider , 3px
Main.Radio2Hwnd := hwnd

Gui, Add, Radio, x+10 w50 hwndhwnd gAdjustSlider , 5px
Main.Radio3Hwnd := hwnd

Gui, Add, Button, xm  w300 gCaptureScreen, Capture New Icon

Gui, -DPIScale

Gui, Add, Picture, xm w300 h300 hwndhwnd 0xE
Main.PicHwnd := hwnd

Gui, +DPIScale

Gui, Add, Text, xm  w200 hwndhwnd , % Main.SliderValue
Main.TextHwnd := hwnd

Gui, Add, Slider, xm w300 Range10-300 hwndhwnd AltSubmit gAdjustSlider, % Main.SliderValue
Main.SliderHwnd := hwnd

Gui, Add, Edit, c0000FF xm w300 hwndhwnd Center, % Main.OutputVarName
Main.Edit3Hwnd := hwnd

Gui, Add, Button, xm w300 gClipboardBase64 , Clipboard Base64

Gui, Add, Button, xm w300 gClipboardBitmapFunction , Clipboard [ B64  ->  pBitmap ] Function

Gui, Show,, Quick Icon Maker

Main.Gui1 := New PopUpWindow( { AutoShow: 1 , X: 1200 , Y: 100 , W: 300 , H: 300 , Options: " -DPIScale +AlwaysOnTop +ToolWindow " } )

return
GuiClose:
GuiContextMenu:
*ESC::ExitApp


/*
Setup( obj ){
  
  obj.Active := 0
  obj.DivAmount := 15000 ;output split string count
  obj.Change := 0 
  
  obj.Display := {}
  obj.Display.pBitmap := ""
  obj.Display.hBitmap := ""
  obj.Display.G := ""
  obj.Display.Size := 300
  
  obj.Master := {}
  obj.Master.pBitmap := ""
  obj.Master.hBitmap := ""
  obj.Master.Size := 60
  
  
;~ Main.InputPBitmap := ""
;~ Main.InputHBitmap := ""
;~ Main.OutPBitmap := ""
;~ Main.OutHBitmap := ""
;~ Main.OGBit := 60

;~ Main.Position := { X: 0 , Y: 0 , W: 60 , H: 60 }
;~ Main.SliderValue := Main.Position.W

;~ Main.RingColor := "000000"
;~ Main.RingAlpha := "FF"

;~ Main.MasterPBitmap := Gdip_CreateBitmap( 300 , 300 )
;~ Main.MasterG := Gdip_GraphicsFromImage( Main.MasterPBitmap ) , Gdip_SetSmoothingMode( Main.MasterG , 2 )
;~ Main.MasterHBitmap := ""

;~ Main.OutputVarName := "QuickIcon"

  
  return obj 
}

CreateWindow(){
  
}


*/





;******************************************************************************************************************
;******************************************************************************************************************
;******************************************************************************************************************
;******************************************************************************************************************
;******************************************************************************************************************
;******************************************************************************************************************

ClipboardBase64:
  if( !Main.Change )
    gosub, AdjustSlider
  Clipboard := ""
  sleep, 100
  GuiControlGet, out , % Main.GuiHwnd ":" , % Main.Edit3Hwnd  
  ( ( Main.OutputVarName := out ) = "" ) ? ( "QuickIcon" )
  out :=  Main.OutputVarName  Main.SliderValue "x" Main.SliderValue " := """ Gdip_EncodeBitmapTo64string( Main.OutPBitmap , "PNG" , 100 ) """"
  startpos := 1 
  Loop, % loopCount := Ceil( StrLen( out ) / Main.DivAmount ) {
    if( A_Index = 1 )
      output := SubStr( out , startpos , Main.DivAmount ) """"
    else
      output .= "`n" Main.OutputVarName  Main.SliderValue "x" Main.SliderValue " .= """ SubStr( out , startpos , Main.DivAmount ) """"
    StartPos += Main.DivAmount
  }
  Clipboard := substr( output , 1 , StrLen( output ) - 1 )
  GuiControl, % Main.GuiHwnd ":" , % Main.Edit3Hwnd , % Main.OutputVarName
  sleep, 300
  SoundBeep
  return

ClipboardBitmapFunction:
  Clipboard := ""
  sleep, 100
  Clipboard := ClipBitmapFunction()
  SoundBeep
  return
;******************************************************************************************************************
;******************************************************************************************************************

AdjustSlider:
  GuiControlGet, out,, % Main.SliderHwnd
  out += Mod( out , 2 )
  Main.Position.H := Main.Position.W := Main.SliderValue := out
  Gdip_DisposeImage( Main.OutPBitmap )
  DeleteObject( Main.OutHBitmap )
  Main.OutPBitmap := Gdip_CreateBitmap( Main.SliderValue  , Main.SliderValue ) , G := Gdip_GraphicsFromImage( Main.OutPBitmap ) , Gdip_SetSmoothingMode( G , 2 ) , Gdip_SetInterpolationMode( G , 7 )
  Gdip_DrawImage( G , Main.InputPBitmap , 0 , 0 , Main.SliderValue , Main.SliderValue , 0 , 0 , Main.OGBit , Main.OGBit ) 
  DrawRing( Main , G )
  Gdip_DeleteGraphics( G )
  Main.OutHBitmap := Gdip_CreateHBITMAPFromBitmap( Main.OutPBitmap )
  SetImage( Main.PicHwnd , Main.OutHBitmap )
  GuiControl, % Main.GuiHwnd ":" , % Main.TextHwnd , % Main.Position.W
  Main.Change := 1
  return
;******************************************************************************************************************
;******************************************************************************************************************
  
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
  Main.InputPBitmap := Gdip_BitmapFromScreen( Main.Gui1.X "|" Main.Gui1.Y "|" Main.Position.W "|" Main.Position.H ) 
  CreateCroppedIconBitmap( Main ) 
  DrawImage( Main )
  Main.OGBit := Main.Position.W
  Main.Active := 0
  GuiControl, % Main.GuiHwnd ":" , % Main.TextHwnd , % Main.Position.W
  Main.Change := 0
  return
;******************************************************************************************************************
;******************************************************************************************************************

DrawRing( obj , G ){
  GuiControlGet, check , % obj.GuiHwnd ":" , %  obj.CheckBoxHwnd
  if( check ){
    GuiControlGet, alpha , % obj.GuiHwnd ":" , % obj.Edit1Hwnd
    ( alpha = "" ) ? ( alpha := "FF" )
    GuiControlGet, color , % obj.GuiHwnd ":" , % obj.Edit2Hwnd
    ( color = "" ) ? ( color := "000000" )
    loop, 3 {
      GuiControlGet, ringWidth , % obj.GuiHwnd ":" , % obj[ "Radio" A_Index "Hwnd" ]
      if( ringWidth ){
        ringWidth := A_Index * 2 - 1
        break
      }
    }
    Pen := Gdip_CreatePen( "0x" alpha color , ringWidth ) 
    
    , Gdip_DrawEllipse( G , Pen 
                , ( ringWidth = 1 ) ? ( 1 ) : ( ( ringWidth = 3 ) ? ( 1 ) : ( 2 ) )                                       ;x
                , ( ringWidth = 1 ) ? ( 1 ) : ( ( ringWidth = 3 ) ? ( 1 ) : ( 3 ) )                                       ;y
                
                ;~ , ( ringWidth = 5 ) ? ( obj.Position.H - ringWidth - 1 ) : ( obj.Position.H - ringWidth ) 
                , ( ringWidth = 1 ) ? ( obj.Position.H - 2 ) : ( obj.Position.H - ringWidth )                                   ;w
                
                ;~ , ( ringWidth = 5 ) ? ( obj.Position.H - ringWidth - 1 ) : ( obj.Position.H - ringWidth ) ) 
                , ( ringWidth = 1 ) ? ( obj.Position.H - 2 ) : ( ( ringWidth = 5 ) ? ( obj.Position.H - ringWidth - 1 ) : ( obj.Position.H - ringWidth ) ) )  ;h
    
    , Gdip_DeletePen( Pen )
  }
}

;******************************************************************************************************************
;******************************************************************************************************************

DrawImage( obj ){
  Gdip_GraphicsClear( obj.MasterG )
  Gdip_DrawImage( obj.MasterG , obj.InputPBitmap , 0 , 0 , obj.Position.W , obj.Position.H )
  DrawRing( obj , obj.MasterG )
  obj.InputHBitmap := Gdip_CreateHBITMAPFromBitmap( obj.MasterPBitmap )
  SetImage( obj.PicHwnd , obj.InputHBitmap )
  DeleteObject( obj.InputHBitmap )
}

CreateCroppedIconBitmap( main ){ ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=101960&p=453285#p453292 
  Main.HBM1 := Gdip_CreateHBITMAPFromBitmap( Main.InputPBitmap )
  Main.HDC1 := CreateCompatibleDC()
  Main.OBM1 := SelectObject( Main.HDC1 , Main.HBM1 )
  
  Main.HBM2 := CreateDIBSection( Main.Position.W , Main.Position.H )
  Main.HDC2 := CreateCompatibleDC()
  Main.OBM2 := SelectObject( Main.HDC2 , Main.HBM2 )
  
  Main.G1 := Gdip_GraphicsFromHDC( Main.HDC2 )
  Gdip_SetSmoothingMode( Main.G1 , 4 ) ;, Gdip_SetInterpolationMode( Main.G1 , 7 )
  Brush := Gdip_BrushCreateSolid( "0xFFFFFFFF" ) , Gdip_FillEllipse( Main.G1 , Brush , 1 , 1 , Main.Position.W - 2 , Main.Position.H - 2 ) , Gdip_DeleteBrush( Brush )
  BitBlt( Main.HDC1 , 0 , 0 , Main.Position.W , Main.Position.H , Main.HDC2 , 0 , 0 , 0x008800C6 ) ;SRCAND
  
  SelectObject( Main.HDC1 , Main.OBM1 ) , SelectObject( Main.HDC2 , Main.OBM2 )
  DeleteDC( Main.HDC1 ), DeleteDC( Main.HDC2 ) , DeleteObject( Main.HBM2 )
  Gdip_DisposeImage( Main.InputPBitmap )

  VarSetCapacity(BITMAP, size := 16 + A_PtrSize*2, 0)
  DllCall("GetObject", "Ptr", Main.HBM1 , "UInt", size, "Ptr", &BITMAP)
  pPix := NumGet(BITMAP, 16 + A_PtrSize)
  
  Main.InputPBitmap := Gdip_CreateBitmap( Main.Position.W , Main.Position.H )
  Gdip_LockBits( Main.InputPBitmap , 0 , 0 , Main.Position.W , Main.Position.H , Stride , Scan0 , data )
  
  Loop % Main.Position.W
     DllCall("RtlMoveMemory", "Ptr", Scan0 + Stride * ( Main.Position.W - A_Index ) , "Ptr" , pPix + Stride*(A_Index - 1), "Ptr", Stride)
     
  Gdip_UnlockBits( Main.InputPBitmap , data )
  DeleteObject( Main.HBM1 )
}
;******************************************************************************************************************
;******************************************************************************************************************
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

;******************************************************************************************************************
;******************************************************************************************************************
Gdip_EncodeBitmapTo64string(pBitmap, ext, Quality=75) { ;Excised from https://www.autohotkey.com/boards/viewtopic.php?t=36047
  if Ext not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
        return -1
  Extension := "." Ext
  DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
  VarSetCapacity(ci, nSize)
  DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
  if !(nCount && nSize)
    return -2
  Loop, % nCount {
    sString := StrGet(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
    if !InStr(sString, "*" Extension)
      continue
    pCodec := &ci+idx
    break
  }
  if !pCodec
    return -3
  if (Quality != 75){
    Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
    if Extension in .JPG,.JPEG,.JPE,.JFIF
    {
      DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
      VarSetCapacity(EncoderParameters, nSize, 0)
      DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
      Loop, % NumGet(EncoderParameters, "UInt") {
        elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
        if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6){
          p := elem+&EncoderParameters-pad-4
          NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
          break
        }
      }
    }
  }
  DllCall("ole32\CreateStreamOnHGlobal", "ptr",0, "int",true, "ptr*",pStream)
  DllCall("gdiplus\GdipSaveImageToStream", "ptr",pBitmap, "ptr",pStream, "ptr",pCodec, "uint",p ? p : 0)
    DllCall("ole32\GetHGlobalFromStream", "ptr",pStream, "uint*",hData)
  pData := DllCall("GlobalLock", "ptr",hData, "uptr")
  nSize := DllCall("GlobalSize", "uint",pData)
  VarSetCapacity(Bin, nSize, 0)
  DllCall("RtlMoveMemory", "ptr",&Bin , "ptr",pData , "uint",nSize)
  DllCall("GlobalUnlock", "ptr",hData)
  DllCall(NumGet(NumGet(pStream + 0, 0, "uptr") + (A_PtrSize * 2), 0, "uptr"), "ptr",pStream)
  DllCall("GlobalFree", "ptr",hData)
  DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint",0x01, "ptr",0, "uint*",base64Length)
  VarSetCapacity(base64, base64Length*2, 0)       
  ;*************************  
  ;https://www.autohotkey.com/boards/viewtopic.php?f=76&t=101960&p=453367#p453387
  DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint", 0x40000001 , "ptr",&base64, "uint*",base64Length) ; [ 0x40000001 = CRYPT_STRING_NOCRLF ( 0x40000000 ) And CRYPT_STRING_BASE64 ( 0x00000001 ) ]
  ;*************************
  Bin := ""
  VarSetCapacity(Bin, 0)
  VarSetCapacity(base64, -1)
  return  base64
}
;******************************************************************************************************************
;******************************************************************************************************************

;Layered window class
;####################################################################################################################################################################################
;####################################################################################################################################################################################
;####################################################################################################################################################################################
;####################################################################################################################################################################################
class PopUpWindow {
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
}
;**********************************************************************
;**********************************************************************
ClipBitmapFunction(){
  local abc 
  abc =
  ( `join`r`n
B64ToPBitmap( Input ){
  local ptr , uptr , pBitmap , pStream , hData , pData , Dec , DecLen , B64
  VarSetCapacity( B64 , strlen( Input ) << !!A_IsUnicode )
  B64 := Input
  If !DllCall("Crypt32.dll\CryptStringToBinary" ( ( A_IsUnicode ) ? ( "W" ) : ( "A" ) ), Ptr := A_PtrSize ? "Ptr" : "UInt" , &B64, "UInt", 0, "UInt", 0x01, Ptr, 0, "UIntP", DecLen, Ptr, 0, Ptr, 0)
    Return False
  VarSetCapacity( Dec , DecLen , 0 )
  If !DllCall("Crypt32.dll\CryptStringToBinary" (A_IsUnicode ? "W" : "A"), Ptr, &B64, "UInt", 0, "UInt", 0x01, Ptr, &Dec, "UIntP", DecLen, Ptr, 0, Ptr, 0)
    Return False
  DllCall("Kernel32.dll\RtlMoveMemory", Ptr, pData := DllCall("Kernel32.dll\GlobalLock", Ptr, hData := DllCall( "Kernel32.dll\GlobalAlloc", "UInt", 2,  UPtr := A_PtrSize ? "UPtr" : "UInt" , DecLen, UPtr), UPtr) , Ptr, &Dec, UPtr, DecLen)
  DllCall("Kernel32.dll\GlobalUnlock", Ptr, hData)
  DllCall("Ole32.dll\CreateStreamOnHGlobal", Ptr, hData, "Int", True, Ptr "P", pStream)
  DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  Ptr, pStream, Ptr "P", pBitmap)
  return pBitmap
}
  )
  return abc
}
HB_BITMAP_MAKER( obj := "" , ScaleFactor := 1 ){
  pBitmap := Gdip_CreateBitmap( 301 * ScaleFactor , 301 * ScaleFactor ) , G := Gdip_GraphicsFromImage( pBitmap ) , Gdip_SetSmoothingMode( G , 3 )
  Pen := Gdip_CreatePen( "0xFFff0000" , 1 ) , Gdip_DrawRectangle( G , Pen , 0 * ScaleFactor , 0 * ScaleFactor , obj.W * ScaleFactor , obj.H * ScaleFactor ) , Gdip_DeletePen( Pen )
  Gdip_SetSmoothingMode( G , 2 )
  Pen := Gdip_CreatePen( "0xFF3399FF" , 1 ) , Gdip_DrawEllipse( G , Pen , 0 * ScaleFactor , 0 * ScaleFactor , obj.W * ScaleFactor , obj.H * ScaleFactor ) , Gdip_DeletePen( Pen )
  Gdip_DeleteGraphics( G )
  return pBitmap
}