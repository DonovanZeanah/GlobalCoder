

FileSelectFile, chosenfile,,d:/globalcoder,Choose file, .ahk
run, %A_ProgramFiles%/autohotkey/autohotkey.exe "%chosenfile%"


^#s:: ; Open Startup Folder
    Run shell:Startup
Return

^#p:: ; Open Programs Folder
    Run shell:ProgramFiles
Return

^#i:: ; Open Pictures Folder
    Run shell:my Pictures
Return

^#t:: ; Open SendTo Folder
    Run shell: sendto

^F12:: ; autohotkeys helop window
    MsgBox, 4160, Hidden Folder Hotkeys
            , `nCTRL+WIN+S`tStartup Folder
            ,`nCTRL+WIN+P`tPrograms Folder
            ,`nCTRL+WIN+I`tPictures Folder
            ,`nCTRL+WIN+T`tSendTo Folder