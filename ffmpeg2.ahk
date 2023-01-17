
#NoTrayIcon
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
ffmpeg = d:/ffmpeg/bin/ffmpeg.exe

;-- CHOOSE FRAME RATE

GUI, Font, Bold
GUI, Add, GroupBox, x11 y11 w100 h70 , FRAME RATE
GUI, Font, Norm
GUI, Add, Radio, x21 y31 vFilm, 23.976 fps
GUI, Add, Radio, x21 y51 vVideo, 29.97 fps
GUI, Add, Radio, x21 y71 vFPS_NoChange, stet

;-- CHOOSE AUDIO SETTINGS

GUI, Font, Bold
GUI, Add, GroupBox, x141 y11 w100 h70 , AUDIO
GUI, Font, Norm
GUI, Add, Radio, x151 y31 vMono, Mono
GUI, Add, Radio, x151 y51 vStereo, Stereo
GUI, Add, Radio, x151 y71 vAudio_NoChange, stet

;-- CHOOSE ASPECT RATIO

GUI, Font, Bold
GUI, Add, GroupBox, x11 y101 w230 h50 , ASPECT RATIO
GUI, Font, Norm
GUI, Add, Radio, x21 y121 vFullscreen, 4:3
GUI, Add, Radio, x96 y121 vWidescreen, 16:9
GUI, Add, Radio, x171 y121 vStandard, 1.85:1
GUI, Add, Radio, x21 y141 vTodd_AO, 2.20:1
GUI, Add, Radio, x96 y141 vCinemascope, 2.35:1
GUI, Add, Radio, x171 y141 vAR_NoChange, stet

; -- SPECIAL CASES

GUI, Font, Bold
GUI, Add, GroupBox, x11 y171 w230 h30 , PRESETS
GUI, Font, Norm
GUI, Add, CheckBox, x21 y191 gDeselect vPhone, Cell Phone
GUI, Add, CheckBox, x96 y191 gDeselect vPAL_to_NTSC, PAL-NTSC
GUI, Add, Checkbox, x171 y191 gDeselect vAudio_Rip, Rip Audio

;-- CHOOSE CROPPINGS (if any)

GUI, Font, Bold
GUI, Add, GroupBox, x11 y221 w230 h30 , CROPPING
GUI, Font, Norm
GUI, Add, Text, x20 y241 w15 h15 vCropLText , L
GUI, Add, Edit, x27 y239 w40 h17 vCropLEdit Limit3 Number
GUI, Add, UpDown, vCropL Range0-640 wrap 0x80, 0
GUI, Add, Text, x75 y241 w15 h15 vCropRText, R
GUI, Add, Edit, x82 y239 w40 h17 vCropREdit Limit3 Number
GUI, Add, UpDown, vCropR Range0-640 wrap 0x80, 0
GUI, Add, Text, x130 y241 w15 h15 vCropTText, T
GUI, Add, Edit, x137 y239 w40 h17 vCropTEdit Limit3 Number
GUI, Add, UpDown, vCropT Range0-360 wrap 0x80, 0
GUI, Add, Text, x185 y241 w15 h15 vCropBText, B
GUI, Add, Edit, x192 y239 w40 h17 vCropBEdit Limit4 Number
GUI, Add, UpDown, vCropB Range0-360 wrap 0x80, 0

;-- CHOOSE TIMINGS (if needed)

GUI, Font, Bold
GUI, Add, GroupBox, x11 y271 w230 h55 , TIME
GUI, Font, Norm
GUI, Add, Text, x91 y281 w205 h15 , Hours  /  Mins  /  Secs
GUI, Add, Text, x21 y296 w205 h15 , Start Time
GUI, Add, Edit, x91 y296 w35 h17 vStartHEdit Limit2 Number
GUI, Add, UpDown, vStartH Range0-23 wrap 0x80,  0
GUI, Add, Edit, x131 y296 w35 h17 vStartMEdit Limit2 Number
GUI, Add, UpDown, vStartM Range0-59 wrap 0x80, 0
GUI, Add, Edit, x171 y296 w35 h17 vStartSEdit Limit2 Number
GUI, Add, UpDown, vStartS Range0-59 wrap 0x80, 0
GUI, Add, Text, x21 y316 w205 h15 , Duration
GUI, Add, Edit, x91 y316 w35 h17 vDurationHEdit Limit2 Number
GUI, Add, UpDown, vDurationH Range0-23 wrap 0x80, 0
GUI, Add, Edit, x131 y316 w35 h17 vDurationMEdit Limit2 Number
GUI, Add, UpDown, vDurationM Range0-59 wrap 0x80, 0
GUI, Add, Edit, x171 y316 w35 h17 vDurationSEdit Limit2 Number
GUI, Add, UpDown, vDurationS Range0-59 wrap 0x80, 0

;-- DRAW BUTTONS AND GUI

GUI, Add, Button, x101 y341 w48 h28, Cancel
GUI, Show, x200 y200 w254 h380, Convert Video to MP4
RETURN

;-- GET FILES and FILE NAMES

GUIDropFiles:

  Loop, Parse, A_GUIEvent, `n
    {
    File_Name=%A_LoopField%
    GUI, Submit, NoHide
    SplitPath, File_Name, Name, Dir, Ext, Prefix, Drive
    If !(Ext="avi" or Ext="mpg" or Ext="mp4" or Ext="mkv" or Ext="vob" or Ext="flv")
      Return
    GoSub, SET_OUTPUT_NAME
    If (Audio_Rip=1 and !(Phone=1))
      GoTo RIP_AUDIO_and_EXIT
    
;-- DEFINE VARIABLES

    GoSub, SET_CONSTANTS
    GoSub, CROP_SETTINGS
    GoSub, TIME_SETTINGS
    GoSub, FRAME_RATE_SETTINGS
    GoSub, ASPECT_RATIO_SETTINGS
    GoSub, AUDIO_SETTINGS
    GoSub, FILTER_SETTINGS
    
;-- EXECUTE
 
    RunWait,%ComSpec% /c ""%ffmpeg%" -threads 4 -y %Start% -i "%File_Name%" -f mp4 ^
      -c:v libx264 %Frame_Rate% %Filter% %Aspect_Ratio% %Quality% %Options% ^
      -c:a libvo_aacenc %Audio% %Duration% "%NewName%"
    }
    GoTo GUI_Close

SET_OUTPUT_NAME:

  If (Audio_Rip=1 and !(Phone=1))
    NewName = %Dir%\%Prefix% (AUDIO).wav
  Else If (Phone=1)
    NewName = %Dir%\%Prefix% (PHONE).mp4
  Else If (PAL_to_NTSC=1)
    NewName = %Dir%\%Prefix% (NTSC).mp4
  Else NewName = %Dir%\%Prefix% (NEW).mp4
    
RETURN

SET_CONSTANTS:

  Options = -deinterlace -sn -map_chapters -1
  If (Phone=1)
    Quality = -crf 30 -preset fast -tune fastdecode -coder 1
  Else
    Quality = -crf 23 -maxrate 960k -bufsize 4M -coder 1
  Stretch = '25025/24000*(PTS)'
  Resample = aresample=48000:async=1:min_comp=0.01:comp_duration=1:max_soft_comp=100000000:min_hard_comp=0.3
   
RETURN

CROP_SETTINGS:

  If (CropL=0 and CropR=0 and CropT=0 and CropB=0)
    Crop = none
  Else
    Crop = crop=iw-%CropL%-%CropR%:ih-%CropT%-%CropB%:%CropL%+1:%CropT%+1

RETURN

TIME_SETTINGS:

  If (StartH="0" and StartM="0" and StartS="0")
    Start =
  Else
    Start = -ss %StartH%:%StartM%:%StartS%
 
  If (DurationH="0" and DurationM="0" and DurationS="0")
    Duration =
  Else
    Duration = -t %DurationH%:%DurationM%:%DurationS%

RETURN

FRAME_RATE_SETTINGS:

  If (Phone=1)
    Frame_Rate = -r:v 12
  Else If (Film=1 or PAL_to_NTSC=1)
    Frame_Rate = -r:v 23.976
  Else If (Video=1)
    Frame_Rate = -r:v 29.97
  Else If (FPS_NoChange=1)
    Frame_Rate =
  Else
    {
    MsgBox Choose Frame Rate or Select Preset
      GoTo GUIDropFiles
    }
    
RETURN

ASPECT_RATIO_SETTINGS:

If (Phone=1)
  {
  Scale = scale=480:270
  Aspect_Ratio = -aspect 16:9
  }
  Else If (Fullscreen=1)
  {
    Aspect_Ratio = -aspect 4:3
    Scale = scale=640:480
  }
  Else If (Widescreen=1)
  {
    Aspect_Ratio = -aspect 16:9
    Scale = scale=720:404
  }
  Else If (Standard=1)
  {
    Aspect_Ratio = -aspect 1.85
    Scale = scale=720:388
  }
  Else If (Todd_AO=1)
  {
    Aspect_Ratio = -aspect 2.20
    Scale = scale=720:328
  }
  Else If (Cinemascope=1)
  {
    Aspect_Ratio = -aspect 2.35
    Scale = scale=720:306
  }
  Else If (AR_NoChange=1 or PAL_to_NTSC=1)
  {
    Aspect_Ratio =
    Scale = none
  }
  Else
    {
    MsgBox Choose Aspect Ratio or Select Preset
    GoTo GUIDropFiles
    }
    
RETURN

AUDIO_SETTINGS:

  If (Phone=1)
    Audio = -ar 24000 -sample_fmt s16 -b:a 24k -ac 1
  Else If (PAL_to_NTSC=1)
    If (Mono=1)
      Audio = -ar 48000 -sample_fmt s16 -b:a 48k -ac 1 -af asetpts=%Stretch%`,%Resample%  
    Else If (Stereo=1)
      Audio = -ar 48000 -sample_fmt s16 -b:a 96k -ac 2 -af asetpts=%Stretch%`,%Resample%  
    Else
      Audio = -af asetpts=%Stretch%`,%Resample%  
  Else If (Mono=1)
    Audio = -ar 48000 -sample_fmt s16 -b:a 48k -ac 1
  Else If (Stereo=1)
    Audio = -ar 48000 -sample_fmt s16 -b:a 96k -ac 2
  Else If (Audio_NoChange=1)
    Audio =
  Else
    {
    MsgBox Choose Audio Mode or Select Preset
    GoTo GUIDropFiles
    }
    
RETURN

FILTER_SETTINGS:

  If (Crop="none")
    If (Scale="none")
      If !(PAL_to_NTSC=1)
        Filter =
      Else
        Filter = -vf setpts=%Stretch%
    Else
      If !(PAL_to_NTSC=1)
        Filter = -vf %Scale%
      Else
        Filter = -vf "%Scale%,setpts=%Stretch%"
  Else
    If (Scale="none")
      If !(PAL_to_NTSC=1)
        Filter = -vf %Crop%
      Else
        Filter = -vf "%Crop%,setpts=%Stretch%"
    Else
      If !(PAL_to_NTSC=1)
        Filter = -vf "%Crop%,%Scale%"
      Else
        Filter = -vf "%Crop%,%Scale%,setpts=%Stretch%"
      
RETURN

RIP_AUDIO_and_EXIT:

  RunWait,%ComSpec% /c ""%ffmpeg%" -threads 4 -y -i "%File_Name%" -vn -sample_fmt s16 -ac 2 -f wav "%NewName%"
  GoTo GUI_Close

;-- EXIT

GUIEscape:
ButtonCancel:
GUI_Close:
  GUI, Destroy
  ExitApp

;-- TOGGLES

Deselect:

  If (A_GUIControl="Phone")
    {
    GUIControlGet, Test,,Phone
    If (Test)
      {
      GoSub Disable_Buttons_Frame_Rate
      GoSub Disable_Buttons_Aspect_Ratio
      GoSub Disable_Buttons_Audio
      GUIControl,Disable,PAL_to_NTSC
      GUIControl,Disable,Audio_Rip
      }
    Else
      {
      GoSub Enable_Buttons_Frame_Rate
      GoSub Enable_Buttons_Aspect_Ratio
      GoSub Enable_Buttons_Audio
      GUIControl,Enable,PAL_to_NTSC      
      GUIControl,Enable,Audio_Rip
      }
    }
  Else If (A_GUIControl="PAL_to_NTSC")
    {    
    GUIControlGet, Test,,PAL_to_NTSC
    If (Test)
      {
      GoSub Disable_Buttons_Frame_Rate
      GUIControl,Disable,Phone
      GUIControl,Disable,Audio_Rip
      }
    Else
      {
      GoSub Enable_Buttons_Frame_Rate
      GUIControl,Enable,Phone
      GUIControl,Enable,Audio_Rip
      }
    }
  Else If (A_GUIControl="Audio_Rip")
    {    
    GUIControlGet, Test,,Audio_Rip
    If (Test)
      {
      GoSub Disable_Buttons_Frame_Rate
      GoSub Disable_Buttons_Aspect_Ratio
      GoSub Disable_Buttons_Audio
      GoSub Disable_Cropping
      GoSub Disable_Timing_Controls
      GUIControl,Disable,Phone
      GUIControl,Disable,PAL_to_NTSC
      }
    Else
      {
      GoSub Enable_Buttons_Frame_Rate
      GoSub Enable_Buttons_Aspect_Ratio
      GoSub Enable_Buttons_Audio
      GoSub Enable_Cropping
      GoSub Enable_Timing_Controls
      GUIControl,Enable,Phone
      GUIControl,Enable,PAL_to_NTSC
      }
    }
 
Return

DISABLE_BUTTONS_FRAME_RATE:

  GUIControl,Disable,Film
  GUIControl,Disable,Video
  GUIControl,Disable,FPS_NoChange

Return

DISABLE_BUTTONS_ASPECT_RATIO:

  GUIControl,Disable,FullScreen
  GUIControl,Disable,Widescreen
  GUIControl,Disable,Standard
  GUIControl,Disable,Todd_AO
  GUIControl,Disable,Cinemascope
  GUIControl,Disable,AR_NoChange
 
Return

DISABLE_BUTTONS_AUDIO:

  GUIControl,Disable,Mono
  GUIControl,Disable,Stereo  
  GUIControl,Disable,Audio_NoChange
 
Return

DISABLE_CROPPING:
 
  GUIControl,Disable,CropLText
  GUIControl,Disable,CropLEdit
  GUIControl,Disable,CropL
  GUIControl,Disable,CropRText
  GUIControl,Disable,CropREdit
  GUIControl,Disable,CropR
  GUIControl,Disable,CropTText
  GUIControl,Disable,CropTEdit
  GUIControl,Disable,CropT
  GUIControl,Disable,CropBText
  GUIControl,Disable,CropBEdit
  GUIControl,Disable,CropB
 
Return

DISABLE_TIMING_CONTROLS:
 
  GUIControl,Disable,StartHEdit
  GUIControl,Disable,StartH
  GUIControl,Disable,StartMEdit
  GUIControl,Disable,StartM
  GUIControl,Disable,StartSEdit
  GUIControl,Disable,StartS
  GUIControl,Disable,DurationHEdit
  GUIControl,Disable,DurationH
  GUIControl,Disable,DurationMEdit
  GUIControl,Disable,DurationM
  GUIControl,Disable,DurationSEdit
  GUIControl,Disable,DurationS
 
Return

ENABLE_BUTTONS_FRAME_RATE:

  GUIControl,Enable,Film
  GUIControl,Enable,Video
  GUIControl,Enable,FPS_NoChange

Return

ENABLE_BUTTONS_ASPECT_RATIO:

  GUIControl,Enable,FullScreen
  GUIControl,Enable,Widescreen
  GUIControl,Enable,Standard
  GUIControl,Enable,Todd_AO
  GUIControl,Enable,Cinemascope
  GUIControl,Enable,AR_NoChange

Return

ENABLE_BUTTONS_AUDIO:

  GUIControl,Enable,Mono
  GUIControl,Enable,Stereo  
  GUIControl,Enable,Audio_NoChange  

Return

ENABLE_CROPPING:
 
  GUIControl,Enable,CropLText
  GUIControl,Enable,CropLEdit
  GUIControl,Enable,CropL
  GUIControl,Enable,CropRText
  GUIControl,Enable,CropREdit
  GUIControl,Enable,CropR
  GUIControl,Enable,CropTText
  GUIControl,Enable,CropTEdit
  GUIControl,Enable,CropT
  GUIControl,Enable,CropBText
  GUIControl,Enable,CropBEdit
  GUIControl,Enable,CropB
 
Return

ENABLE_TIMING_CONTROLS:
 
  GUIControl,Enable,StartHEdit
  GUIControl,Enable,StartH
  GUIControl,Enable,StartMEdit
  GUIControl,Enable,StartM
  GUIControl,Enable,StartSEdit
  GUIControl,Enable,StartS
  GUIControl,Enable,DurationHEdit
  GUIControl,Enable,DurationH
  GUIControl,Enable,DurationMEdit
  GUIControl,Enable,DurationM
  GUIControl,Enable,DurationSEdit
  GUIControl,Enable,DurationS
 
Return

