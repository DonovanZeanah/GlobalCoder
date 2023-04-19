#Hotstring EndChars `t
SendMode, Input
#InputLevel,1
:OB0:#If:: [, Expression]
:OB0:#IfWinActive:: [, WinTitle, WinText]
:OB0:#IfWinExist:: [, WinTitle, WinText]
:OB0:#IfWinNotActive:: [, WinTitle, WinText]
:OB0:#IfWinNotExist:: [, WinTitle, WinText]
:OB0:#InputLevel:: [, Level]
:OB0:#SingleInstance:: [force|ignore|off]
:OB0:#UseHook:: [On|Off]
:OB0:#Warn:: [, WarningType, WarningMode]
:OB0:Abs::(Number)
:OB0:ACos::(Number)
:OB0:Asc::(String)
:OB0:ASin::(Number)
:OB0:ATan::(Number)
:OB0:AutoTrim::, On|Off
:OB0:Bind::(Parameters)
:OB0:BlockInput::, Mode
:OB0:Break:: [, LoopLabel]
:OB0:Ceil::(Number)
:OB0:Chr::(Number)
:OB0:ClipWait:: [, SecondsToWait, 1]
:OB0:Clone::()
:OB0:Close::()
:OB0:ComObjActive::(CLSID)
:OB0:ComObjArray::(VarType, Count1 [, Count2, ... Count8])
:OB0:ComObjConnect::(ComObject [, Prefix])
:OB0:ComObjCreate::(CLSID [, IID])
:OB0:ComObject::(VarType, Value [, Flags])
:OB0:ComObjEnwrap::(DispPtr)
:OB0:ComObjError::([Enable])
:OB0:ComObjFlags::(ComObject [, NewFlags, Mask])
:OB0:ComObjGet::(Name)
:OB0:ComObjMissing::()
:OB0:ComObjQuery::(ComObject, [SID,] IID)
:?OB0:ComObjType::
	Send,(ComObject)
return
:?O:(ComObject)::
	Send,(ComObject, "Name")
return
:?O:(ComObject, "Name")::
	Send,(ComObject, "IID")
return
:?O:(ComObject, "IID")::
	Send,(ComObject)
return
:OB0:ComObjUnwrap::(ComObject)
:OB0:ComObjValue::(ComObject)
:OB0:Continue:: [, LoopLabel]
:OB0:Control::, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlClick:: [, Control-or-Pos, WinTitle, WinText, WhichButton, ClickCount, Options, ExcludeTitle, ExcludeText]
:OB0:ControlFocus:: [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlGet::, OutputVar, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlGetFocus::, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlGetPos:: [, X, Y, Width, Height, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlGetText::, OutputVar [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlMove::, Control, X, Y, Width, Height [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlSend:: [, Control, Keys, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ControlSetText:: [, Control, NewText, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:CoordMode::, ToolTip|Pixel|Mouse|Caret|Menu [, Screen|Window|Client]
:OB0:Cos::(Number)
:OB0:Critical:: [, Off]
:OB0:CtrlEvent::(CtrlHwnd, GuiEvent, EventInfo, ErrorLevel:="")
:OB0:DetectHiddenText::, On|Off
:OB0:DetectHiddenWindows::, On|Off
:OB0:DllCall::("[DllFile\]Function" [, Type1, Arg1, Type2, Arg2, "Cdecl ReturnType"])
:OB0:Drive::, Sub-command [, Drive , Value]
:OB0:DriveGet::, OutputVar, Cmd [, Value]
:OB0:DriveSpaceFree::, OutputVar, Path
:OB0:EnvAdd::, Var, Value [, TimeUnits]
:OB0:EnvDiv::, Var, Value
:OB0:EnvGet::, OutputVar, EnvVarName
:OB0:EnvMult::, Var, Value
:OB0:EnvSet::, EnvVar, Value
:OB0:EnvSub::, Var, Value [, TimeUnits]
:OB0:Exit:: [, ExitCode]
:OB0:ExitApp:: [, ExitCode]
:OB0:ExitFunc::(ExitReason, ExitCode)
:OB0:Exp::(N)
:OB0:FileAppend:: [, Text, Filename, Encoding]
:OB0:FileCopy::, SourcePattern, DestPattern [, Flag]
:OB0:FileCopyDir::, Source, Dest [, Flag]
:OB0:FileCreateDir::, DirName
:OB0:FileCreateShortcut::, Target, LinkFile [, WorkingDir, Args, Description, IconFile, ShortcutKey, IconNumber, RunState]
:OB0:FileDelete::, FilePattern
:OB0:FileEncoding:: [, Encoding]

:OB0:FileGetAttrib::, OutputVar [, Filename]
:OB0:FileGetShortcut::, LinkFile [, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState]
:OB0:FileGetSize::, OutputVar [, Filename, Units]
:OB0:FileGetTime::, OutputVar [, Filename, WhichTime]
:OB0:FileGetVersion::, OutputVar [, Filename]
:OB0:FileInstall::, Source, Dest [, Flag]
:OB0:FileMove::, SourcePattern, DestPattern [, Flag]
:OB0:FileMoveDir::, Source, Dest [, Flag]
:OB0:FileOpen::(Filename, Flags [, Encoding])
:?OB0:FileRead::
	Send,, OutputVar, Filename
return
:?O:, OutputVar, Filename::
	Send,, OutputVar, *Pnnn Filename
return
:?O:, OutputVar, *Pnnn Filename::
	Send,, OutputVar, Filename
return
:OB0:FileReadLine::, OutputVar, Filename, LineNum
:OB0:FileRecycle::, FilePattern
:OB0:FileRecycleEmpty:: [, DriveLetter]
:OB0:FileRemoveDir::, DirName [, Recurse?]
:OB0:FileSelectFile::, OutputVar [, Options, RootDir\Filename, Prompt, Filter]
:OB0:FileSelectFolder::, OutputVar [, StartingFolder, Options, Prompt]
:OB0:FileSetAttrib::, Attributes [, FilePattern, OperateOnFolders?, Recurse?]
:OB0:FileSetTime:: [, YYYYMMDDHH24MISS, FilePattern, WhichTime, OperateOnFolders?, Recurse?]
:OB0:Floor::(Number)
:OB0:For:: Key [, Value] in Expression
:OB0:FormatTime::, OutputVar [, YYYYMMDDHH24MISS, Format]
:OB0:Func::(FunctionName)
:OB0:GetAddress::(Key)
:?OB0:GetCapacity::
	Send,()
return
:?O:()::
	Send,(Key)
return
:?O:(Key)::
	Send,()
return
:OB0:GetKeyName::(Key)
:OB0:GetKeySC::(Key)
:?OB0:GetKeyState::
	Send,, OutputVar, KeyName [, Mode]
return
:?O:, OutputVar, KeyName [, Mode]::
	Send,("KeyName" [, "Mode"])
return
:?O:("KeyName" [, "Mode"])::
	Send,, OutputVar, KeyName [, Mode]
return
:OB0:GetKeyVK::(Key)
:OB0:Gosub::, Label
:OB0:Goto::, Label
:OB0:GroupActivate::, GroupName [, R]
:OB0:GroupAdd::, GroupName [, WinTitle, WinText, Label, ExcludeTitle, ExcludeText]
:OB0:GroupClose::, GroupName [, A|R]
:OB0:GroupDeactivate::, GroupName [, R]
:OB0:Gui::, sub-command [, Param2, Param3, Param4]
:OB0:GuiContextMenu::(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
:OB0:GuiControl::, Sub-command, ControlID [, Param3]
:OB0:GuiControlGet::, OutputVar [, Sub-command, ControlID, Param4]
:OB0:GuiSize::(GuiHwnd, EventInfo, Width, Height)
:OB0:HasKey::(Key)
:?OB0:Hotkey::
	Send,, KeyName [, Label, Options]
return
:?O:, KeyName [, Label, Options]::
	Send,, IfWinActive/Exist [, WinTitle, WinText]
return
:?O:IfWinActive/Exist [, WinTitle, WinText]::
	Send,{BS 2}, If [, Expression]
return
:?O:, If [, Expression]::
	Send,, KeyName [, Label, Options]
return
:OB0:if ::(expression)
:OB0:IfEqual::, var, value
:OB0:IfExist::, FilePattern
:OB0:IfGreater::, var, value
:OB0:IfGreaterOrEqual::, var, value
:OB0:IfInString::, var, SearchString
:OB0:IfLess::, var, value
:OB0:IfLessOrEqual::, var, value
:OB0:IfMsgBox::, ButtonName
:OB0:IfNotEqual::, var, value
:OB0:IfNotExist::, FilePattern
:OB0:IfNotInString::, var, SearchString
:OB0:IfWinActive:: [, WinTitle, WinText,  ExcludeTitle, ExcludeText]
:OB0:IfWinExist:: [, WinTitle, WinText,  ExcludeTitle, ExcludeText]
:OB0:IfWinNotActive:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:IfWinNotExist:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:ImageSearch::, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ImageFile
:OB0:IniDelete::, Filename, Section [, Key]
:?OB0:IniRead::
	Send,, OutputVar, Filename, Section, Key [, Default]
return
:?O:Var, Filename, Section, Key [, Default]::
	Send,{BS 8}, OutputVarSection, Filename, Section
return
:?O:, OutputVarSection, Filename, Section::
	Send,, OutputVarSectionNames, Filename
return
:?O:, OutputVarSectionNames, Filename::
	Send,, OutputVar, Filename, Section, Key [, Default]
return
:?OB0:IniWrite::
	Send,, Value, Filename, Section, Key
return
:?O:, Value, Filename, Section, Key::
	Send,, Pairs, Filename, Section
return
:?O:, Pairs, Filename, Section::
	Send,, Value, Filename, Section, Key
return
:OB0:Input:: [, OutputVar, Options, EndKeys, MatchList]
:OB0:InputBox::, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
:OB0:Insert::(StringOrObjectKey, Value)
:OB0:InsertAt::(Pos, Value1 [, Value2, ... ValueN])
:OB0:InStr::(Haystack, Needle [, CaseSensitive = false, StartingPos = 1, Occurrence = 1])
:?OB0:IsByRef::
	Send,(UnquotedVarName)
return
:?O:(UnquotedVarName)::
	Send,(ParamIndex)
return
:?O:(ParamIndex)::
	Send,(UnquotedVarName)
return
:OB0:IsFunc::(FunctionName)
:OB0:IsLabel::(LabelName)
:OB0:IsObject::(ObjectValue)
:OB0:IsOptional::(ParamIndex)
:OB0:KeyWait::, KeyName [, Options]
:OB0:Length::()
:OB0:ListLines:: [, On|Off]
:OB0:Ln::(Number)
:OB0:LoadPicture::(Filename [, Options, ByRef ImageType])
:OB0:Log::(Number)
:?OB0:Loop::
	Send,%A_Space%[, Count]
return
:?O: [, Count]::
	Send,, Files, FilePattern [, Mode]
return
:?O:, Files, FilePattern [, Mode]::
	Send,, FilePattern [, IncludeFolders?, Recurse?]
return
:?O:lePattern [, IncludeFolders?, Recurse?]::
	Send,{BS 4}, Parse, InputVar [, Delimiters, OmitChars]
return
:?O:rse, InputVar [, Delimiters, OmitChars]::
	Send,{BS 4}, Read, InputFile [, OutputFile]
return
:?O:, Read, InputFile [, OutputFile]::
	Send,, Reg, RootKey[\Key, Mode]
return
:?O:, Reg, RootKey[\Key, Mode]::
	Send,, RootKey [, Key, IncludeSubkeys?, Recurse?]
return
:?O:tKey [, Key, IncludeSubkeys?, Recurse?]::
	Send,{BS 5} [, Count]
return
:OB0:LTrim::(String, OmitChars = " `t")
:OB0:MaxIndex::()
:OB0:Menu::, MenuName, Cmd [, P3, P4, P5]
:OB0:MenuGetHandle::(MenuName)
:OB0:MenuGetName::(Handle)
:OB0:MinIndex::()
:OB0:Mod::(Dividend, Divisor)
:OB0:MouseClick:: [, WhichButton , X, Y, ClickCount, Speed, D|U, R]
:OB0:MouseClickDrag::, WhichButton, X1, Y1, X2, Y2 [, Speed, R]
:OB0:MouseGetPos::, [OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3]
:OB0:MouseMove::, X, Y [, Speed, R]
:?OB0:MsgBox::
	Send,, Text
return
:?O:, Text::
	Send,%A_Space%[, Options, Title, Text, Timeout]
return
:?O: [, Options, Title, Text, Timeout]::
	Send,, Text
return
:OB0:Next::(OutputVar1 [, OutputVar2, ...])
:OB0:NumGet::(VarOrAddress [, Offset = 0][, Type = "UPtr"])
:OB0:NumPut::(Number, VarOrAddress [, Offset = 0][, Type = "UPtr"])
:OB0:ObjAddRef::(Ptr)
:OB0:ObjBindMethod::(Obj, Method, Params)
:OB0:ObjRawSet::(Object, Key, Value)
:OB0:ObjRelease::(Ptr)
:OB0:OnClipboardChange::(Func [, AddRemove])
:OB0:OnExit:: [, Label]
:?OB0:OnMessage::
	Send,(MsgNumber [, Function, MaxThreads])
return
:?O:(MsgNumber [, Function, MaxThreads])::
	Send,(MsgNumber, "FunctionName")
return
:?O:(MsgNumber, "FunctionName")::
	Send,(MsgNumber, "")
return
:?O:(MsgNumber, "")::
	Send,(MsgNumber)
return
:?O:(MsgNumber)::
	Send,(MsgNumber, FuncObj)
return
:?O:(MsgNumber, FuncObj)::
	Send,(MsgNumber, FuncObj, 1)
return
:?O:(MsgNumber, FuncObj, 1)::
	Send,(MsgNumber, FuncObj, -1)
return
:?O:(MsgNumber, FuncObj, -1)::
	Send,(MsgNumber, FuncObj, 0)
return
:?O:(MsgNumber, FuncObj, 0)::
	Send,(MsgNumber [, Function, MaxThreads])
return
:OB0:_NewEnum::()
:OB0:Ord::(String)
:OB0:OutputDebug::, Text
:OB0:Pause:: [, On|Off|Toggle, OperateOnUnderlyingThread?]
:OB0:PixelGetColor::, OutputVar, X, Y [, Alt|Slow|RGB]
:OB0:PixelSearch::, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID [, Variation, Fast|RGB]
:OB0:Pop::()
:OB0:PostMessage::, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:Process::, Cmd [, PID-or-Name, Param3]
:?OB0:Progress::
	Send,, Off
return
:?O:, Off::
	Send,, ProgressParam1 [, SubText, MainText, WinTitle, FontName]
return
:?O: SubText, MainText, WinTitle, FontName]::
	Send,{BS 19}, Off
return
:OB0:Push::([ Value, Value2, ..., ValueN ])
:?OB0:Random::
	Send,, OutputVar [, Min, Max]
return
:?O:, OutputVar [, Min, Max]::
	Send,, , NewSeed
return
:?O:, , NewSeed::
	Send,, OutputVar [, Min, Max]
return
:OB0:RawRead::(VarOrAddress, Bytes)
:OB0:RawWrite::(VarOrAddress, Bytes)
:OB0:ReadLine::()
:OB0:ReadNumType::()
:OB0:RegDelete::, RootKey, SubKey [, ValueName]
:OB0:RegExMatch::(Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPosition = 1])
:OB0:RegExReplace::(Haystack, NeedleRegEx [, Replacement = "", OutputVarCount = "", Limit = -1, StartingPosition = 1])
:OB0:RegisterCallback::("FunctionName" [, Options = "", ParamCount = FormalCount, EventInfo = Address])
:OB0:RegRead::, OutputVar, RootKey, SubKey [, ValueName]
:OB0:RegWrite::, ValueType, RootKey, SubKey [, ValueName, Value]
:OB0:Remove::(FirstKey, LastKey)
:OB0:RemoveAt::(Pos [, Length])
:OB0:Return:: [, Expression]
:OB0:Round::(Number [, N])
:OB0:RTrim::(String, OmitChars = " `t")
:OB0:Run::, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]
:OB0:RunAs:: [, User, Password, Domain]
:OB0:RunWait::, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]
:OB0:Seek::(Distance [, Origin = 0])
:OB0:SendLevel::, Level
:OB0:SendMessage::, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]
:?OB0:SetBatchLines::
	Send,, 20ms
return
:?O:, 20ms::
	Send,, LineCount
return
:?O:, LineCount::
	Send,, 20ms
return
:?OB0:SetCapacity::
	Send,(MaxItems)
return
:?O:(MaxItems)::
	Send,(Key, ByteSize)
return
:?O:(Key, ByteSize)::
	Send,(MaxItems)
return
:OB0:SetCapsLockState:: [, State]
:OB0:SetControlDelay::, Delay
:OB0:SetDefaultMouseSpeed::, Speed
:OB0:SetEnv::, Var, Value
:OB0:SetFormat::, NumberType, Format
:OB0:SetKeyDelay:: [, Delay, PressDuration, Play]
:OB0:SetMouseDelay::, Delay [, Play]
:OB0:SetNumLockState:: [, State]
:OB0:SetRegView::, RegView
:OB0:SetScrollLockState:: [, State]
:OB0:SetStoreCapslockMode::, On|Off
:OB0:SetTimer:: [, Label, Period|On|Off|Delete, Priority]
:?OB0:SetTitleMatchMode::
	Send,, MatchMode
return
:?O:, MatchMode::
	Send,, Fast|Slow
return
:?O:, Fast|Slow::
	Send,, MatchMode
return
:OB0:SetWinDelay::, Delay
:OB0:SetWorkingDir::, DirName
:OB0:Shutdown::, Code
:OB0:Sin::(Number)
:OB0:Sleep::, DelayInMilliseconds
:OB0:Sort::, VarName [, Options]
:OB0:SoundBeep:: [, Frequency, Duration]
:OB0:SoundGet::, OutputVar [, ComponentType, ControlType, DeviceNumber]
:OB0:SoundGetWaveVolume::, OutputVar [, DeviceNumber]
:OB0:SoundPlay::, Filename [, wait]
:OB0:SoundSet::, NewSetting [, ComponentType, ControlType, DeviceNumber]
:OB0:SoundSetWaveVolume::, Percent [, DeviceNumber]
:?OB0:SplashImage::
	Send,, Off
return
:?O:, Off::
	Send,%A_Space%[, ImageFile, Options, SubText, MainText, WinTitle, FontName]
return
:?O: SubText, MainText, WinTitle, FontName]::
	Send,{BS 23}, Off
return
:OB0:SplashTextOn:: [, Width, Height, Title, Text]
:OB0:SplitPath::, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive]
:OB0:Sqrt::(Number)
:OB0:StatusBarGetText::, OutputVar [, Part#, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:StatusBarWait:: [, BarText, Seconds, Part#, WinTitle, WinText, Interval, ExcludeTitle, ExcludeText]
:OB0:StrGet::(Address [, Length] [, Encoding = None ] )
:OB0:StringCaseSense::, On|Off|Locale
:OB0:StringGetPos::, OutputVar, InputVar, SearchText [, L#|R#, Offset]
:OB0:StringLeft::, OutputVar, InputVar, Count
:OB0:StringLen::, OutputVar, InputVar
:OB0:StringLower::, OutputVar, InputVar [, T]
:OB0:StringMid::, OutputVar, InputVar, StartChar [, Count , L]
:OB0:StringReplace::, OutputVar, InputVar, SearchText [, ReplaceText, ReplaceAll?]
:OB0:StringRight::, OutputVar, InputVar, Count
:OB0:StringSplit::, OutputArray, InputVar [, Delimiters, OmitChars]
:OB0:StringTrimLeft::, OutputVar, InputVar, Count
:OB0:StringTrimRight::, OutputVar, InputVar, Count
:OB0:StringUpper::, OutputVar, InputVar [, T]
:OB0:StrLen::(InputVar)
:?OB0:StrPut::
	Send,(String [, Encoding = None ] )
return
:?O:(String [, Encoding = None ] )::
	Send,(String, Address [, Length] [, Encoding = None ] )
return
:?O:dress [, Length] [, Encoding = None ] )::
	Send,{BS 11}(String [, Encoding = None ] )
return
:OB0:SubStr::(String, StartingPos [, Length])
:OB0:Suspend:: [, Mode]
:OB0:SysGet::, OutputVar, Sub-command [, Param3]
:OB0:Tan::(Number)
:OB0:Tell::()
:?OB0:Thread::
	Send,, NoTimers [, false]
return
:?O:, NoTimers [, false]::
	Send,, Priority, n
return
:?O:, Priority, n::
	Send,, Interrupt [, Duration, LineCount]
return
:?O:, Interrupt [, Duration, LineCount]::
	Send,, NoTimers [, false]
return
:OB0:Throw:: [, Expression]
:OB0:ToolTip:: [, Text, X, Y, WhichToolTip]
:OB0:Transform::, OutputVar, Cmd, Value1 [, Value2]
:OB0:TrayTip:: [, Title, Text, Seconds, Options]
:OB0:Trim::(String, OmitChars = " `t")
:OB0:UrlDownloadToFile::, URL, Filename
:OB0:VarSetCapacity::(UnquotedVarName [, RequestedCapacity, FillByte])
:OB0:WinActivate:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinActivateBottom:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinActive::("WinTitle", "WinText", "ExcludeTitle", "ExcludeText")
:OB0:WinClose:: [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]
:OB0:WinExist::("WinTitle", "WinText", "ExcludeTitle", "ExcludeText")
:OB0:WinGet::, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinGetActiveStats::, Title, Width, Height, X, Y
:OB0:WinGetActiveTitle::, OutputVar
:OB0:WinGetClass::, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinGetPos:: [, X, Y, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinGetText::, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinGetTitle::, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinHide:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinKill:: [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]
:OB0:WinMaximize:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinMenuSelectItem::, WinTitle, WinText, Menu [, SubMenu1, SubMenu2, SubMenu3, SubMenu4, SubMenu5, SubMenu6, ExcludeTitle, ExcludeText]
:OB0:WinMinimize:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:?OB0:WinMove::
	Send,, X, Y
return
:?O:, X, Y::
	Send,, WinTitle, WinText, X, Y [, Width, Height, ExcludeTitle, ExcludeText]
return
:?O:dth, Height, ExcludeTitle, ExcludeText]::
	Send,{BS 31}, X, Y
return
:OB0:WinRestore:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinSet::, Attribute, Value [, WinTitle, WinText,  ExcludeTitle, ExcludeText]
:?OB0:WinSetTitle::
	Send,, NewTitle
return
:?O:, NewTitle::
	Send,, WinTitle, WinText, NewTitle [, ExcludeTitle, ExcludeText]
return
:?O: NewTitle [, ExcludeTitle, ExcludeText]::
	Send,{BS 20}, NewTitle
return
:OB0:WinShow:: [, WinTitle, WinText, ExcludeTitle, ExcludeText]
:OB0:WinWait:: [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]
:OB0:WinWaitActive:: [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]
:OB0:WinWaitClose:: [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]
:OB0:WinWaitNotActive:: [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]
:OB0:Write::(String)
:OB0:WriteLine::([String])
:OB0:WriteNumType::(Num)