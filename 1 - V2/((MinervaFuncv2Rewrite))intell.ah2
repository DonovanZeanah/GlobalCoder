;specify Editor window
#ifWinActive ahk_class EmEditorMainFrame3
ToolTipActive:=0
auEditorWin="ahk_class EmEditorMainFrame3"
^Space::AutoComplete()
^+Space::AutoComplete(1) ; first word help (command)
; uncomment next line to enable AutoHotKey help file lookup on Win-Space
;#Space::ahkHelpLookup()
#ifWinActive


AutoComplete(subCommand=0)                ;;
{  global tooltipActive
   static ahkCmds,ahkVars,ahkKeywords,ahkKeys,ahkFuncs

   timeOut=10000

   if !ahkCmds
   {  splitPath,A_AHKpath,,ahkDir
      fileRead,ahkCmds,%ahkDir%\Extras\Editors\Syntax\Commands.txt
      fileRead,ahkVars,%ahkDir%\Extras\Editors\Syntax\Variables.txt
      fileRead,ahkKeywords,%ahkDir%\Extras\Editors\Syntax\Keywords.txt
         sort,ahkKeywords
      fileRead,ahkKeys,%ahkDir%\Extras\Editors\Syntax\Keys.txt
         sort,ahkKeys
      fileRead,ahkFuncs,%ahkDir%\Extras\Editors\Syntax\Functions.txt
      ahkCmds=`r`n%ahkCmds%`r`n
      ahkVars=`r`n%ahkVars%`r`n
      ahkKeywords=`r`n%ahkKeywords%`r`n
      ahkKeys=`r`n%ahkKeys%`r`n
      ahkFuncs=`r`n%ahkFuncs%`r`n
   }

   userX:=A_CaretX
   userY:=A_CaretY
   oldClip:=Clipboard
   oldKeyDelay:=A_KeyDelay
   setKeyDelay,0
   autoTrim,on

   send,+{Home}^c
   sleep,100
   lineToLeft=%Clipboard%
   cmd:=lineToLeft

   loop,parse,cmd,%A_Space%`t()`%=:`, ,`{
      s:=A_LoopField
   cmd=%s%

   send {End}+{Home}^c
   sleep,100
   fullLine=%clipboard%
   LineIndent:=clipboard
   ifNotEqual,fullLine,,stringLeft,LineIndent,LineIndent,% inStr(LineIndent,fullLine)-1

   stringLeft,s,fullLine,1
   if (s="{")
   {  stringTrimLeft,fullLine,fullLine,1
      fullLine=%fullLine%
      stringTrimLeft,lineToLeft,lineToLeft,1
      lineToLeft=%lineToLeft%
   }

   if (subCommand=1) or !cmd
      or !inStr(ahkCmds . ahkVars . ahkKeywords . ahkKeys . ahkFuncs,"`n" cmd)
      loop,parse,fullLine,%A_Space%`t`(`=`:`, ,`{
      {  cmd:=A_LoopField
         break
      }

   setKeyDelay,%oldKeyDelay%
   Clipboard:=oldClip
   CoordMode,mouse,relative
   mousegetPos,mX,mY
   mouseClick,,%userX%,%userY%,,0
   mouseMove,%mX%,%mY%,0

   if !cmd or !inStr(ahkCmds . ahkVars . ahkKeywords . ahkKeys . ahkFuncs,"`n" cmd)
      return

   Menu, Tray, Icon, %windir%\system32\shell32.dll,24
   matchCmds:=AutoCompleteSearchArea(ahkCmds,cmd)
            . AutoCompleteSearchArea(ahkVars,cmd,":=")
            . AutoCompleteSearchArea(ahkKeywords,cmd)
            . AutoCompleteSearchArea(ahkKeys,cmd,"{","}")
            . AutoCompleteSearchArea(ahkFuncs,cmd)
   stringReplace,matchCmds,matchCmds,`r,`r,all UseErrorLevel
   matches#:=errorlevel
   if (matches#>20)
   {  i=0
      loop,parse,matchCmds,`n,`r
         if (A_Index>20)
            break
         else
            i+=strLen(A_LoopField)+1
      stringLeft,matchCmds,matchCmds,%i% ; inStr(matchCmds,"`r`n" s "`r`n")
      matchCmds=%matchCmds%`n--------------------
   }
   stringTrimRight,matchCmds,matchCmds,1

   if (matches#<=1)
      if (strLen(matchCmds)-strLen(autoCompleteRestOfCmd(matchCmds
                  ,cmd,fullLine,lineToLeft,userX,userY,timeOut))<3)
         return

   Menu ClickMenu,Add
   Menu ClickMenu,DeleteAll
   loop,parse,matchCmds,`n`r,`r
      if (a_loopField)
         Menu ClickMenu,Add, %a_LoopField%, CClick
   TooltipActive:=1
   Menu ClickMenu,Show,%userX%,% userY+16
   return

keyHelp:
   ahkHelpLookup(cmd)
CClick:
   Menu, Tray, Icon, %A_AhkPath%
   oldClip:=clipboard
   if (getKeyState("Shift","P"))
   {  stringReplace,s,A_ThisMenuItem,``t,%A_tab%,all
      stringReplace,s,s,``n,% "`n" lineIndent,all useErrorLevel
      lines#:=errorlevel
      clipboard:=s
      send ^v
      if (InStr(s,"{"))
         lines#-=1
      ifNotEqual,lines#,0,send % "{Up " lines#-1 "}"
      sleep,100
      clipboard:=oldClip
   }
   else if (matches#>1)
      autoCompleteRestOfCmd(A_ThisMenuItem,cmd,fullLine,lineToLeft,userX,userY,timeOut,1)
   Menu ClickMenu,DeleteAll
   return

TimerTooltipRemove:
   TooltipActive:=0
   tooltip,,,,20
   setTimer,TimerTooltipRemove,OFF
   Menu, Tray, Icon, %A_AhkPath%
   return
}

AutoCompleteSearchArea(byref area, cmd, prefix="",postfix="")        ;;
{
   i:=inStr(area,"`n" cmd)
   if !i
      return
   j:=inStr(area,"`n" cmd,0,0)
   j:=inStr(area,"`n",0,j+1)
   stringMid,found,area,%i%,% j-i
   stringTrimLeft,found,found,1 ; remove `r`n
   if (prefix) or (postfix)
   {  stringReplace,found,found,`r`n,%postfix%`r`n%prefix%,all
      found=%prefix%%found%
   }
   return found
}

autoCompleteRestOfCmd(syntax,cmd,fullLine,lineToLeft,x,y,timeOut,ForceReplace=0)    ;;
{  global ToolTipActive
   stringLeft,s,syntax,2
   ifEqual,s,:=,stringTrimLeft,syntax,syntax,2
   stringLeft,s,syntax,1
   ifEqual,s,{,stringTrimLeft,syntax,syntax,1
   loop,parse,syntax,%A_Space%`,(
   {  cmdFull:=A_LoopField
      break
   }

   if (cmd<>cmdFull)
   {  StringTrimLeft,s,cmdFull,% strLen(cmd)
      stringTrimLeft,fullLine,fullLine,% strLen(lineToLeft)
      stringLeft,ss,fullLine,1
      wordSymbols:="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#_@$?[]0123456789"
      userWord=0
      if (ss)
         ifInString,wordSymbols,%ss%
            userWord=1
      if (ForceReplace)
      {  if (userWord)
         {  s:=cmdFull
            mouseClick,,% x-5,%y%,2,0
         }
         clipboard:=s
         send ^v
         sleep,100
         clipboard:=oldClip
      }
      else
         if !FullLine or dllCall("CompareString",int,0x400,int,1
                  ,str,s,int,strlen(s),str,fullLine,int,strlen(s))<>2
         {  clipboard:=s
            send ^v
            sleep,100
            clipboard:=oldClip
         }
   }
   CoordMode, ToolTip, Relative
   ToolTip, %syntax%, %x%, % y+16,20
   setTimer,TimerTooltipRemove,%timeOut%
   TooltipActive:=1
   return cmdFull
}

ahkHelpLookup(c_cmd="")               ;;
{  if !c_cmd
   {
      SetWinDelay 10
      SetKeyDelay 0
      AutoTrim, On
      C_ClipboardPrev:=clipboardAll
      clipboard=
      Send, ^c
      ClipWait, 0.1
      if ErrorLevel <> 0
      {  Send, {home}+{end}^c
         ClipWait, 0.2
         if (ErrorLevel)
         {  clipboard:=C_ClipboardPrev
            return
         }
      }
      C_Cmd=%clipboard%  ; This will trim leading and trailing tabs & spaces.
      clipboard:=C_ClipboardPrev
      stringLeft,s,c_cmd,1
      ifEqual,s,{,stringMid,c_cmd,c_cmd,2,200
      c_cmd=%c_cmd%
      Loop, parse, C_Cmd, %A_Space%`,  ; The first space or comma is the end of the command.
      {  C_Cmd=%A_LoopField%
         break ; i.e. we only need one interation.
      }
   }
   IfWinNotExist, AutoHotkey Help
   {  ; Use non-abbreviated root key to support older versions of AHK:
      RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
      if ErrorLevel <> 0
         ahk_dir=%ProgramFiles%\AutoHotkey
      ahk_help_file=%ahk_dir%\AutoHotkey.chm
      IfNotExist, %ahk_help_file%
      {  traytip,,Could not find the help file: %ahk_help_file%.
         return
      }
      Run, %ahk_help_file%
      WinWait, AutoHotkey Help
   }
   ; The above has set the "last found" window which we use below:
   WinActivate
   WinWaitActive
   StringReplace, C_Cmd, C_Cmd, #, {#}
   send, !n{home}+{end}%C_Cmd%{enter}
   return
}