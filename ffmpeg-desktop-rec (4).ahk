#SingleInstance,Force ;ensure only 1 version running
SetTitleMatchMode, 3 ;to make sure winMinimize and Sending Control C to ConsoleWindowClass works down below
DetectHiddenWindows,On ;Added becauase minimizing the window

; General Documentation := https://ffmpeg.org/ffmpeg-devices.html#gdigrab  Documentation on gdigrab from ffmpeg.
; Get list of devices ffmpeg:= ffmpeg -list_devices true -f dshow -i dummy
; Cropping specific area := https://stackoverflow.com/questions/6766333/capture-windows-screen-with-ffmpeg/47591299
;********************Control+Shift+R=Start Recording***********************************
^+r::
ffmpeg = d:\ffmpeg\bin\ffmpeg.exe -list_devices true -f dshow -i dummy

;FFMPEG=D:\ffmpeg\bin\ffmpeg.exe
FileDelete, %A_ScriptDir%\temp.mp4
sleep, 50

ff_params = -rtbufsize 1500M  -thread_queue_size 512 -f gdigrab -video_size 1920x1080  -i desktop -f dshow -i audio="Microphone (Yeti Stereo Microphone)" -crf 0  -filter:a "volume=1.5" -vcodec libx264 temp.mp4
runwait,%comspec% /c %ffmpeg% %ff_params%
;run ffmpeg %ff_params% ;run ffmpeg with command parameters

sleep, 150 ;Wait for Command window to appear
;WinMinimize, ahk_class ConsoleWindowClass ;minimize the CMD window
return

;********************Control+Shift+S= Stop Recording***********************************
^+s::
ControlSend, , ^c, ahk_class ConsoleWindowClass  ; send ctrl-c to command window which stops the recording
sleep, 500
InputBox, New_File_Name,File name,What would you like to name your .mp4 file?,,300,130 ;Get a file name for your new video
if (New_File_Name = "") or (Error = 1) ;If you don't give it a name, it won't rename it and won't run it
	return 

Run, explore %A_ScriptDir% ;Open the working folder
FileMove, %A_ScriptDir%\temp.mp4, %A_ScriptDir%\%New_File_Name%.mp4  ; Rename the temp file to your new file.
Run, %A_ScriptDir%\%New_File_Name%.mp4 ;Now play the new file name
return

^i::
ffmpeg = d:\ffmpeg\bin\ffmpeg.exe -list_devices true -f dshow -i dummy
return