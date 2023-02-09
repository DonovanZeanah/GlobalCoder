;OK, I decided: using squares, color represents frequency amongst the viewable squares (to some extent)
;the current level gives you a count for a given square, the average for the next-level-down both over
;the entire square period and for only the active period(s) in that square.

;Create a GUI to show File IO information
;
;
;

;Re-write the words per time indexer function(s)

/*
#NoEnv
#KeyHistory, 0
#HotkeyInterval, 200
#MaxHotkeysPerInterval, 2000
#SingleInstance, Ignore
Thread, Interrupt, 30, 2000
Coordmode, Mouse, Screen
ListLines, Off
SetBatchLines, -1
SetFormat, FloatFast, 0.15

Ptr := A_PtrSize ? "Ptr" : "UInt"
SkipExitSub := True ;Disables save-on-exit until the Startup() function is finished
;As long as the above is set to True and the Startup() function is never executed the script
;will not execute any critical code and can sit in a pre-Startup() state forever.

Name := "M&K Counter 2.0"
VersionNumber := 1.79
Package_FileVersion := 2.2
Pixel_FileVersion := 1.1
Save_FileVersion := 1.2
HD_FileVersion := 1.0

MouseMovement_IndexVersion := 1.36
Key_IndexVersion := 1.2
WordsTyped_IndexVersion := 1.25

MouseMovement_Number := 189
WordsPerTime_Number := 190

OnExit, ExitSub
Startup()
Return

*/

Startup()
{
    Global
    
    Local MyDocuments, Critical_Error, I, L, P1, P2, Var, Var2, Errors, SkipCustomIcon, Override
    
    ;Prevents hotkeys from being fired before everything is configured correctly
    Critical, On
    
    ;Menu, Tray, NoStandard
    
    ;Initialize the key ID ranges
    Ranges_Initialize()
    
    ;Save method default - 1 = registry, 2 = options file
    Save_SettingsMethod := 2
    
    ;Autostart at logon
    Autostart_AtLogon := Autostart("Check")
    
    ;Gets the location of MyDocuments
    VarSetCapacity(MyDocuments, 65 * 1024, 0) ;Set to above the maximum it might ever need
    , DllCall("Shell32.dll\SHGetFolderPath" . (A_IsUnicode ? "W" : "A"), Ptr, 0, "Int", 5, Ptr, 0, "UInt", 0, Ptr, &MyDocuments) ;CSIDL_PERSONAL = 0x0005;
    , VarSetCapacity(MyDocuments, -1)
    
    ;Sets the variables to the defaults so files can be found
    RootDirectory := MyDocuments "\GlobalCoder"
    
    ;Checks if the override ini is present next to the script
    If (ELP_FileExists(A_ScriptDir "\Override.ini", 1, 0, 0))
    {
        Override := ELP_FileRead(A_ScriptDir "\Override.ini")
        
        Loop, Parse, Override, `n, `r
        {
            If (SubStr(A_LoopField, 1, 14) = "Root_Directory")
            {
                RootDirectory := SubStr(A_LoopField, InStr(A_LoopField, "=") + 1)
                RootDirectory = %RootDirectory%
            } Else If (SubStr(A_LoopField, 1, 18) = "Ignore_IconWarning")
            {
                SuppressInvalidFolderPath := SubStr(A_LoopField, InStr(A_LoopField, "=") + 1)
                SuppressInvalidFolderPath = %SuppressInvalidFolderPath%
            }
        }
        
        While (InStr(RootDirectory, "%"))
        { ;Expands any A_Var references in RootDirectory
            P1 := InStr(RootDirectory, "%") + 1
            , P2 := InStr(RootDirectory, "%", False, P1)
            , Var := SubStr(RootDirectory, P1, P2 - P1)
            
            If (SubStr(Var, 1, 2) != "A_")  ;Environment variable
                EnvGet, Var2, % Var
            Else
                Var2 := % %Var%             ;Built in A_... variable
            
            StringReplace, RootDirectory, RootDirectory, % "%" Var "%", % Var2, A
        }
        
        ;Trims trailing \s
        While (SubStr(RootDirectory, 0) = "\")
            RootDirectory := SubStr(RootDirectory, 1, StrLen(RootDirectory) - 1)
        
        If (!IsValidRootDirectory(RootDirectory))
        {
            SkipCustomIcon := True
            
            If (!SuppressInvalidFolderPath)
            {
                Var =
                (LTrim Join`n
                    The override root directory isn't valid for normal Windows file commands:
                    Folder names can't end with a space or a period.
                    
                    The script will still function but the normal tray icon can't be set.
                    
                    This warning can be suppressed by adding "Ignore_IconWarning=true" to the Override.ini file."
                )
                ;" Syntax highlighting gets messed up here and this fixes it.
                
                MsgBox % Var
                Var := ""
            }
        }
    }
    
    ;Trims trailing \s
    While (SubStr(RootDirectory, 0) = "\")
        RootDirectory := SubStr(RootDirectory, 1, StrLen(RootDirectory) - 1)
    
    ;The location to store all of the files the script may use
    If (!ELP_FileExists(RootDirectory, 1, 0, 0))
    {
        If (ELP_FileCreateDirectory(RootDirectory) Or !ELP_FileExists(RootDirectory, 1, 0, 0))
        {
            MsgBox, 0x1, Invalid Root_Directory, The root directory can't be created:`n`n%RootDirectory%`n`nClick OK to try an use the default directory or cancel to quit the script:`n`n%MyDocuments%\M&K Counter 2.0
            
            IfMsgBox, Cancel
                ExitApp
            
            RootDirectory := MyDocuments "\GlobalCoder"
            , ELP_FileCreateDirectory(RootDirectory)
        }
    }
    
    
    ELP_FileCreateDirectory(RootDirectory . "\" . A_ComputerName)
    , KeyDirectory := RootDirectory "\" A_ComputerName "\Keys"
    , MouseMovementDirectory := RootDirectory "\" A_ComputerName "\Mouse Movement"
    , WordDirectory := RootDirectory "\" A_ComputerName "\Word Speed"
    , SaveDirectory := RootDirectory "\" A_ComputerName
    
    If (!SkipCustomIcon And !Generate_Icon(RootDirectory "\gc.ico"))
        Menu, Tray, Icon, % RootDirectory "\gc.ico"
    
    ELP_FileCreateDirectory(KeyDirectory)
    , ELP_FileCreateDirectory(MouseMovementDirectory)
    , ELP_FileCreateDirectory(WordDirectory)
    
    ;Final validation that all of the directories needed exist
    If (!ELP_FileExists(RootDirectory, 1, 0, 0))
        Critical_Error := "Failed to create the root directory needed to store files: " RootDirectory
    Else If (!ELP_FileExists(KeyDirectory, 1, 0, 0))
        Critical_Error := "Failed to create the key directory needed to store files: " KeyDirectory
    Else If (!ELP_FileExists(MouseMovementDirectory, 1, 0, 0))
        Critical_Error := "Failed to create the mouse movement directory needed to store files: " MouseMovementDirectory
    Else If (!ELP_FileExists(WordDirectory, 1, 0, 0))
        Critical_Error := "Failed to create the word directory needed to store files: " WordDirectory
    
    If (Critical_Error)
    {
        SkipExitSub := True
        
        MsgBox, 0x30, Error!, A critical error has occurred!`n`n%Critical_Error%`n`nThe script will now exit.
        
        ExitApp
    }
    
    ;Checks if the settings where saved in one of the 2 ways possible
    ;If settings are found they are loaded and the Save_Settings function is setup for future saves
    ;(minimizes i/o when a setting is changed later)
    If (Load_Settings())
        Save_Settings(1)
    
    
    ;
    ; Validates all of the loaded settings (or sets them if they where not loaded)
    ;
    
    ;Sets default capture accuracy (how accurate the stored timestamps are)
    ;1 | Minutes
    ;2 | Seconds
    ;3 | Milliseconds
    If (Capture_Accuracy != 1 And Capture_Accuracy != 2 And Capture_Accuracy != 3)
        Capture_Accuracy := 1
    
    ;Maximum amount of RAM to use for save method 1
    ;More RAM means the program can run longer before it has to access the hard drive
    If MB_RamUse Is Not Number
        MB_RamUse := 6
    Else If ((MB_RamUse - 6) < 1)
        MB_RamUse := 6
    Else If (MB_RamUse > 255)
        MB_RamUse := 255
    
    ;The method to use to save captured data
    ;Method 1 - save to variables first and save to disk on exit/auto save/as needed
    ;Method 2 - save directly to hard disk
    If (Save_DataMethod != 1 And Save_DataMethod != 2)
        Save_DataMethod := 1
    
    ;The amount of time in seconds to autosave any buffered data
    If AutoSave_Interval Is Not Number
        AutoSave_Interval := 60
    
    ;Enable/disable counting mouse clicks and scrolls
    If (CountMouse != 1 And CountMouse != 0)
        CountMouse := 1
    
    ;Enable/disable counting keyboard presses
    If (CountKeyboard != 1 And CountKeyboard != 0)
        CountKeyboard := 1
    
    ;Enable/disable counting the pixels the mouse moves
    If (CountPixelsMoved != 1 And CountPixelsMoved != 0)
        CountPixelsMoved := 1
    
    ;Enable/disable tracking word speed
    If (CountWPT != 1 And CountWPT != 0)
        CountWPT := 1
    
    ;Enable/Disable counting the number of bytes read/written by the script
    If (CountHDActivity != 1 And CountHDActivity != 0)
        CountHDActivity := 1
    
    ;Enable/Disable showing all computer(s) information in the traytip
    If (Show_AllComputers != 1 And Show_AllComputers != 0)
        Show_AllComputers := 0
    
    ELP_MasterSettings("Set", "Count_BytesWritten", CountHDActivity)
    , ELP_MasterSettings("Set", "Count_BytesRead", CountHDActivity)
    
    ;The size(s) of the screen(s)
    If (!ScreenSizes)
    {
        Critical, Off
        
        ScreenSizes := Get_ScreenSizes()
        
        Critical, On
    }
    
    
    ;Enable/Disable autosave
    If AutoSave_State Is Not Number
        AutoSave_State := 1
    
    If (Show_CountsInConvertedUnits != 1 And Show_CountsInConvertedUnits != 0)
        Show_CountsInConvertedUnits := 0
    
    If (Show_TodaysCount != 1 And Show_TodaysCount != 0)
        Show_TodaysCount := 0
    
    
    ;Sets up needed variables for the rest of the script to run
    
    Bytes_PerHotKey := ((MB_RamUse - 5) * 1024 * 1024) // Count_HotKeys()
    , Max_HotKeyCount := Bytes_PerHotKey // 8
    , WPT_Max := 12 * 1024
    , MMD_Max := 12 * 1024
    , Pixel_CacheMaxSize := 130 * 1024
    , Pixel_CacheAutoExpandMax := Pixel_CacheMaxSize * 2
    , VarSetCapacity(MouseMovementData, MMD_Max, 0)
    , MovementDataVarOffset := 0
    , VarSetCapacity(WPTData, WPT_Max, 0)
    , WPTOffset := 0
    , VarSetCapacity(Pixel_Cache, Pixel_CacheMaxSize, 0)
    , Pixel_CacheOffset := 0
    
;   If (Save_DataMethod = 1){
;       I := Range0_Lower + 1 ;Skip range 1
;       
;       Loop, % Range0_Used - 1 ;Skip range 1
;       {
;           L := Range%I%_Lower
;           
;           Loop, % Range%I%_Used
;           {
;               VarSetCapacity(K%L%, Bytes_PerHotKey, 0)
;               , K%L%_Count := 0
;               , K%L%_MaxCount := Max_HotKeyCount
;               , L ++
;           }
;           
;           I ++
;       }
;   }
    
    If (AutoSave_State)
        SetTimer, AutoSave, % AutoSave_Interval * 1000
    
    UpdateCounts(1)
    , UpdateToolTip()
    
    SetTimer, UpdateToolTip, 1000
    
    Build_TrayMenu()
    , Save_Settings()
    
    If (CountPixelsMoved)
        SetTimer, MonitorMouseMovement, -1
    
    SkipExitSub := False ;Enables save-on-exit if applicable
    
    Critical, Off
}

Record_KeyPress(_Key)
{
    Global
    Static Pressed_Keys := 0
    Local Now, BNow, Temp_WPTData
    
    If (_Key >= Range13_Lower And _Key <= Range13_Upper)
    { ;Range 13 is the mouse
        If (!CountMouse) ;Has to be on its own line else normal mouse presses when keyboard is disabled won't trigger
            Return
    } Else If (!CountKeyboard) ;Because the above didn't trigger anything else is the keyboard
        Return
    
    If (Capture_Accuracy = 1) ;Minutes
        Now := A_YYYY . A_MM . A_DD . A_Hour . A_Min . 00000
    Else If (Capture_Accuracy = 3) ;Milliseconds
        Now := A_Now . A_MSec
    Else If (Capture_Accuracy = 2) ;Seconds
        Now := A_Now . 000
    
    K%_Key%_TotalCount ++
    
    If (CountWPT)
    {
        If ((_Key = 400020 Or _Key = 400021 Or _Key = 500002 Or (_Key >= Range5_Lower And _Key <= Range5_Upper)) And Pressed_Keys)
        { ;_Key 400020 is space, 400021 is Enter, 500002 is Numpad Enter and range 5 is special characters `~!@#$%^&*()-_=+[{]}\|;:'", <.>/?
            If (Save_DataMethod = 1)
            {
                If ((WPTOffset + 16) > WPT_Max)
                    WPT_Max += 1 * 1024 ;Auto expand as needed
                    , Save_WPTData()
                
                NumPut(Now, WPTData, WPTOffset, "Int64")
                , WPTOffset += 8
                , NumPut(Pressed_Keys, WPTData, WPTOffset, "Int64")
                , WPTOffset += 8
                
                If (Show_TodaysCount)
                    TodaysWordCount ++
            } Else If (Save_DataMethod = 2)
            {
                VarSetCapacity(Temp_WPTData, 16, 0)
                , NumPut(Now, Temp_WPTData, 0, "Int64")
                , NumPut(Pressed_Keys, Temp_WPTData, 8, "Int64")
                , ELP_WriteData(WPT_Handle, &Temp_WPTData, 16)
                , WPT_Pointer += 16
                , ELP_SetFilePointer(WPT_Handle, WPT_Pointer)
                
                If (Show_TodaysCount)
                    TodaysWordCount ++
            }
            
            Pressed_Keys := 0
            , TotalWordCount ++
        } Else If ((_Key >= Range2_Lower And _Key <= Range2_Upper) ;Lowercase letters
                Or (_Key >= Range3_Lower And _Key <= Range3_Upper) ;Uppercase letters
                Or (_Key >= Range4_Lower And _Key <= Range4_Upper) ;Standard numbers
                Or (_Key >= Range10_Lower And _Key <= Range10_Upper)) ;Numpad numbers
            Pressed_Keys ++
    }
    
    If (Save_DataMethod = 1) ;Buffer
    {
        If (K%_Key%_Count = "") ;Dynamically allocates RAM for key buffers the first time each key is pressed
            VarSetCapacity(K%_Key%, Bytes_PerHotKey, 0)
            , K%_Key%_Count := 0
            , K%_Key%_MaxCount := Max_HotKeyCount
        Else If (K%_Key%_Count >= K%_Key%_MaxCount)
            Save_IndividualKey(_Key)
        
        NumPut(Now, K%_Key%, K%_Key%_Count++ * 8, "Int64")
    } Else If (Save_DataMethod = 2) ;Direct to disk
        VarSetCapacity(BNow, 8, 0)
        , NumPut(Now, BNow, 0, "Int64")
        , ELP_WriteData(KH%_Key%, &BNow, 8)
        , KFP%_Key% += 8
        , ELP_SetFilePointer(KH%_Key%, KFP%_Key%)
}

Update_StateKeys()
{
    Global CapsLock_S, NumLock_State, Insert_State, ScrollLock_State, LShift_S, RShift_S
    
    CapsLock_S := GetKeyState("CapsLock", "T")
    , NumLock_State := GetKeyState("NumLock", "T")
    , Insert_State := GetKeyState("Insert", "T")
    , ScrollLock_State := GetKeyState("ScrollLock", "T")
    , LShift_S := GetKeyState("LShift", "P")
    , RShift_S := GetKeyState("RSight", "P")
}

KP(_Key)
{
    ;This is used so that multiple commands can be triggered
    ;by the press of a single hotkey
    Static TimeSinceLastForcedUpdate
    
    If (SkipExitSub) ;This is only ever set before the script is finished loading or when it is uninstalling
        Return
    
    If _Key Is Number
    {
        ;This force updates the various key states if they haven't been force updated in the past second to ensure they don't get stuck in the wrong state.
        CTickCount := A_TickCount ;Ensures it's persistent between or statements below
        If (!TimeSinceLastForcedUpdate Or (CTickCount - TimeSinceLastForcedUpdate) > 1000 Or (CTickCount - TimeSinceLastForcedUpdate) < 0)
            Update_StateKeys()
            , TimeSinceLastForcedUpdate := A_TickCount
        
        Record_KeyPress(_Key)
    }
}

MonitorMouseMovement()
{
    Static
    Static Setup, CYear, CMonth, CHour, CDay, CMinute
    , Pixel_CacheAutoExpandMax
    
    Global Show_TodaysCount
    , ScreenSizes
    , CountPixelsMoved
    , Save_DataMethod
    , TodaysPixelsMoved
    , TodaysDistanceMoved
    , TotalPixelsMoved
    , TotalDistanceMoved
    , Pixel_Cache
    , Pixel_CacheOffset
    , Pixel_CacheMaxSize
    , Name
    
    
    If (!Setup)
    {
        MouseGetPos, Old_MX, Old_MY
        SysGet, Old_Monitor_Count, 80
        
        CYear := A_YYYY, CMonth := A_MM
        , CDay := A_DD, CHour := A_Hour
        , CMinute := A_Min
        , Setup := 2
    }
    
    If (!CountPixelsMoved)
    {
        SavePixelData(1)
        Return 1
    }
    
    MouseGetPos, New_MX, New_MY
    
    If (New_MX = Old_MX And New_MY = New_MY)
        Return
    
    XMoved := Abs(Old_MX - New_MX)
    , YMoved := Abs(Old_MY - New_MY)
    , Old_MX := New_MX, Old_MY := New_MY
    
    If (XMoved > 20000 Or YMoved > 20000)
        Return
    
    If (CMinute != A_Min)
    {
        If (Pixel_CacheOffset)
        {
            Compile_PixelCache()
            
            If (Save_DataMethod = 2)
                SavePixelData()
        }
        
        CYear := A_YYYY, CMonth := A_MM
        , CDay := A_DD, CHour := A_Hour
        , CMinute := A_Min
    }
    
    SysGet, Monitor_Count, 80
    
    If (Monitor_Count != Old_Monitor_Count)
    {
        Old_Monitor_Count := Monitor_Count
        TrayTip, % Name, You appear to have changed the number of monitors connected to your computer.`nPlease confirm that the monitor size(s) setting is still correct.
    }
    
    C_Mon := 0
    
    Loop, % Monitor_Count
    {
        I := A_Index
        SysGet, Mon, Monitor, % I
        
        M%I%_Left := MonLeft, M%I%_Right := MonRight
        , M%I%_Top := MonTop, M%I%_Bottom := MonBottom
        
        If (M%I%_Left != M%I%_OldLeft Or M%I%_Right != M%I%_OldRight Or M%I%_Top != M%I%_OldTop Or M%I%_Bottom != M%I%_OldBottom)
        {
            If (!CRSplit)
            {
                StringSplit, SSize_, ScreenSizes, |
                CRSplit := True
            }
            
            If (!SSize_%I%)
                SSize_%I% := SSize_1 ? SSize_1 : 1
            
            MChanged := True
            , PPI%I% := Sqrt(((MonRight - MonLeft) * (MonRight - MonLeft)) + ((MonBottom - MonTop) * (MonBottom - MonTop))) / SSize_%I%
        }
        
        If (New_MX >= MonLeft And New_MX < MonRight And New_MY >= MonTop And New_MY < MonBottom)
            C_Mon := A_Index
        
        M%I%_OldLeft := MonLeft, M%I%_OldRight := MonRight
        , M%I%_OldTop := MonTop, M%I%_OldBottom := MonBottom
    }
    
    If (MChanged)
    {
        PPI0 := 0
        
        Loop, % Monitor_Count
            PPI0 += PPI%A_Index%
        
        PPI0 := PPI0 / Monitor_Count
        , Old_MX := New_MX, Old_MY := New_MY
        , MChanged := False
        , Setup := 1
        
        Return
    }
    
    TPMoved := Floor(Sqrt((XMoved * XMoved) + (YMoved * YMoved)))
    If (TPMoved)
    {
        
        If (Pixel_CacheOffset + 32 > Pixel_CacheMaxSize)
        {
            If ((Pixel_CacheMaxSize + 1 * 1024) <= Pixel_CacheAutoExpandMax)
                Pixel_CacheMaxSize += 1 * 1024
            
            Compile_PixelCache()
        }
        
        NumPut(CYear CMonth CDay CHour CMinute A_Sec 000, Pixel_Cache, Pixel_CacheOffset, "Int64")
        , Pixel_CacheOffset += 8
        , NumPut(C_Mon, Pixel_Cache, Pixel_CacheOffset, "Int64")
        , Pixel_CacheOffset += 8
        , NumPut(TPMoved, Pixel_Cache, Pixel_CacheOffset, "Int64")
        , Pixel_CacheOffset += 8
        , NumPut(TPMoved / PPI%C_Mon%, Pixel_Cache, Pixel_CacheOffset, "Double")
        , Pixel_CacheOffset += 8
        
        If (Show_TodaysCount)
            TodaysPixelsMoved += TPMoved
            , TodaysDistanceMoved += TPMoved / PPI%C_Mon%
        
        TotalPixelsMoved += TPMoved
        , TotalDistanceMoved += TPMoved / PPI%C_Mon%
    }
    
    CRSplit := False
}

Compile_PixelCache()
{
    Global Pixel_Cache, Pixel_CacheOffset, Pixel_CacheMaxSize
    , MouseMovementData, MovementDataVarOffset, Capture_Accuracy
    , MMD_Max
    
    C_Offset := Monitor_Count := 0
    
    Loop, % Pixel_CacheOffset // 32
    {
        C_Offset += 8
        , C_Mon := NumGet(Pixel_Cache, C_Offset, "Int64")
        , C_Offset += 24

        If (!InStr("|" Found_Monitors "|", "|" C_Mon "|"))
        {
            Found_Monitors .= Found_Monitors ? "|" C_Mon : C_Mon
            
            If (Capture_Accuracy = 1)
                VarSetCapacity(Mon_%C_Mon%_Data, 32, 0)
                , Mon_%C_Mon%_Offset := 0
            Else If (Capture_Accuracy = 2 Or _Capture_Accuracy = 3)
                VarSetCapacity(Mon_%C_Mon%_Data, Pixel_CacheOffset, 0)
                , Mon_%C_Mon%_Offset := 0
        }
    }
    
    C_Offset := 0
    
    If (Capture_Accuracy = 1) ;Minutes
    {
        Loop, % Pixel_CacheOffset // 32
            C_Date := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , C_Mon := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , P_Moved := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , D_Moved := NumGet(Pixel_Cache, C_Offset, "Double"), C_Offset += 8
            , NumPut(C_Date, Mon_%C_Mon%_Data, 0, "Int64")
            , NumPut(C_Mon, Mon_%C_Mon%_Data, 8, "Int64")
            , NumPut(P_Moved + NumGet(Mon_%C_Mon%_Data, 16, "Int64"), Mon_%C_Mon%_Data, 16, "Int64")
            , NumPut(D_Moved + NumGet(Mon_%C_Mon%_Data, 24, "Double"), Mon_%C_Mon%_Data, 24, "Double")
        
        Loop, Parse, Found_Monitors, |
        {
            If ((MovementDataVarOffset + 32) > MMD_Max)
                MMD_Max += 128 * 1024 ;auto-expand
                , SavePixelData()
            
            NumPut(NumGet(Mon_%A_LoopField%_Data, 0, "Int64"), MouseMovementData, MovementDataVarOffset, "Int64"), MovementDataVarOffset += 8
            , NumPut(NumGet(Mon_%A_LoopField%_Data, 8, "Int64"), MouseMovementData, MovementDataVarOffset, "Int64"), MovementDataVarOffset += 8
            , NumPut(NumGet(Mon_%A_LoopField%_Data, 16, "Int64"), MouseMovementData, MovementDataVarOffset, "Int64"), MovementDataVarOffset += 8
            , NumPut(NumGet(Mon_%A_LoopField%_Data, 24, "Double"), MouseMovementData, MovementDataVarOffset, "Double"), MovementDataVarOffset += 8
            , VarSetCapacity(Mon_%A_LoopField%_Data, 32, 0)
            , VarSetCapacity(Mon_%A_LoopField%_Data, 0)
        }
    } 
    
    /*
    ;This can't be used for now but I want to keep the code around
    Else If (Capture_Accuracy = 2 Or Capture_Accuracy = 3){ ;Seconds (also Milliseconds)
        ;Sort the data by monitor
        Loop, % Pixel_CacheOffset // 32
        {
            C_Date := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , C_Mon := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , P_Moved := NumGet(Pixel_Cache, C_Offset, "Int64"), C_Offset += 8
            , D_Moved := NumGet(Pixel_Cache, C_Offset, "Double"), C_Offset += 8
            
            , NumPut(C_Date, Mon_%C_Mon%_Data, Mon_%C_Mon%_Offset, "Int64"), Mon_%C_Mon%_Offset += 8
            , NumPut(C_Mon, Mon_%C_Mon%_Data, Mon_%C_Mon%_Offset, "Int64"), Mon_%C_Mon%_Offset += 8
            , NumPut(P_Moved , Mon_%C_Mon%_Data, Mon_%C_Mon%_Offset, "Int64"), Mon_%C_Mon%_Offset += 8
            , NumPut(D_Moved , Mon_%C_Mon%_Data, Mon_%C_Mon%_Offset, "Double"), Mon_%C_Mon%_Offset += 8
        }
        
        Loop, Parse, Found_Monitors, |
        {
            If ((MovementDataVarOffset + 32) > MMD_Max)
                SavePixelData()
            
            MovementDataVarOffset += 32
            , Mon := A_LoopField
            , LastDate := SubStr(NumGet(Mon_%Mon%_Data, 0, "Int64"), 1, 14) . 000
            , C_Offset := 0
            
            Loop, % Mon_%Mon%_Offset // 32
            {
                C_Date := SubStr(NumGet(Mon_%Mon%_Data, C_Offset, "Int64"), 1, 14) . 000, C_Offset += 8
                , C_Mon := NumGet(Mon_%Mon%_Data, C_Offset, "Int64"), C_Offset += 8
                , P_Moved := NumGet(Mon_%Mon%_Data, C_Offset, "Int64"), C_Offset += 8
                , D_Moved := NumGet(Mon_%Mon%_Data, C_Offset, "Double"), C_Offset += 8
                
                If (C_Date != LastDate){
                    If ((MovementDataVarOffset + 32) > MMD_Max)
                        SavePixelData()
                    
                    MovementDataVarOffset += 32
                    , LastDate := C_Date
                }
                
                NumPut(C_Date, MouseMovementData, MovementDataVarOffset - 32, "Int64")
                , NumPut(C_Mon, MouseMovementData, MovementDataVarOffset - 24, "Int64")
                , NumPut(P_Moved + NumGet(MouseMovementData, MovementDataVarOffset - 16, "Int64"), MouseMovementData, MovementDataVarOffset - 16, "Int64")
                , NumPut(D_Moved + NumGet(MouseMovementData, MovementDataVarOffset - 8, "Double"), MouseMovementData, MovementDataVarOffset - 8, "Double")
            }
            
            VarSetCapacity(Mon_%Mon%_Data, Mon_%Mon%_Offset, 0)
            , VarSetCapacity(Mon_%Mon%_Data, 0)
        }
    }
    */
    
    VarSetCapacity(Pixel_Cache, Pixel_CacheMaxSize, 0)
    , Pixel_CacheOffset := 0
}

Get_ScreenSizes(I_Sizes = "")
{
    Static
    Static CMTI := 0.393700787
    , N := 4
    , IsShowing := False
    Global Waiting_ForMonSizeGui
    
    If (IsShowing)
        Return
    
    IsShowing := True
    
    Gui, %N%:Default
    Gui, %N%:Font, S10
    Gui, %N%:+LabelScreenSizes
    Gui, %N%:Add, Text,, Please set the sizes for your monitor(s)
    
    YPos := 38
    
    SysGet, Monitor_Count, 80
    
    StringSplit, CMS_, I_Sizes, |
    
    Loop, % Monitor_Count
    {
        I := A_Index
        SysGet, Mon, Monitor, % I
        
        Gui, %N%:Add, Text, vText%I% x12 y%YPos%, % "Monitor " I " (" MonRight - MonLeft "x" MonBottom - MonTop "): "
        YPos += 25
        GuiControlGet, Current, Pos, Text%I%
        
        CurrentY -= 3
        Gui, %N%:Add, Edit, vEdit%I% x150 y%CurrentY% w55, % Round(CMS_%I%, 2)
        
        Gui, %N%:Add, DropDownList, vDropDown%I% x216 y%CurrentY% w95 AltSubmit, Inches||Centimeters
    }
    
    YPos += 6
    Gui, %N%:Add, Button, x12 y%YPos% w298 Default gScreenSizesOk, Ok
    
    Gui, %N%:Show,, Set monitor(s) size
    Waiting_ForMonSizeGui := True
    
    Loop
    {
        If (Waiting_ForMonSizeGui)
        {
            If (Waiting_ForMonSizeGui = 2)
            {
                If (I_Sizes)
                {
                    Gui, %N%:Destroy
                    IsShowing := False
                    
                    Return I_Sizes
                } Else
                    Waiting_ForMonSizeGui := True
            }
            Sleep, 50
            Continue
        }
        
        Gui, %N%:Submit, NoHide
        
        Filled := True
        
        Loop, % Monitor_Count
        {
            If Edit%A_Index% Is Not Number
                Filled := False
            
            If (StrLen(Edit%A_Index%) > 5)
                Filled := False
            Else If (Edit%A_Index% < 1)
                Filled := False
            Else If (DropDown%A_Index% = 2 And Round(Edit%A_Index% * CMTI, 2) < 1)
                Filled := False
        }
        
        If (Filled = True)
            Break
        Else {
            MsgBox, 0x4, Required fields, In order to use this program you must fill in the screen sizes.`n`nDo you want to close the program?
            
            IfMsgBox, Yes
                ExitApp
        }
        
        Waiting_ForMonSizeGui := True
    }
    
    Gui, %N%:Destroy
    
    IsShowing := False
    , Sizes := ""
    
    Loop, % Monitor_Count
    {
        If (DropDown%A_Index% = 1)
            Sizes .= Sizes != "" ? "|" Edit%A_Index% : Edit%A_Index%
        Else If (DropDown%A_Index% = 2)
            Sizes .= Sizes != "" ? "|" Round(Edit%A_Index% * CMTI, 2) : Round(Edit%A_Index% * CMTI, 2)
    }
    
    Return Sizes
}

Save_IndividualKey(Key)
{
    Global
    Local FileSize = 0
    , H
    
    If (Save_DataMethod = 2)
        Return
    
    If (K%Key%_Count > 0)
    {
        ELP_FileCreateDirectory(RootDirectory)
        , ELP_FileCreateDirectory(KeyDirectory)
        
        Critical, On
        
        H := ELP_OpenFileHandle(KeyDirectory "\Key " Key, "Write", FileSize)
        , ELP_SetFilePointer(H, FileSize)
        , ELP_WriteData(H, &K%Key%, K%Key%_Count * 8)
        , ELP_CloseFileHandle(H)
        , VarSetCapacity(K%Key%, 0) ;Required if Bytes_PerHotKey is smaller then before
        , VarSetCapacity(K%Key%, Bytes_PerHotKey, 0)
        , K%Key%_Count := 0
        
        Critical, Off
    }
}

Save_AllData(Override = False)
{
    Global
    Local FileSize := 0
    , BytesWritten := 0
    , TotalKeysWritten := 0
    , KeysWritten
    , H
    , I
    , L
    
    Critical, On
    
    SavePixelData(Override)
    , Save_WPTData()
    
    If (Save_DataMethod = 2)
        Return
    
    ELP_FileCreateDirectory(RootDirectory)
    , ELP_FileCreateDirectory(KeyDirectory)
    
    I := Range0_Lower + 1 ;Skip range 1
    Loop, % Range0_Used - 1 ;Skip range 1
    {
        L := Range%I%_Lower
        Loop, % Range%I%_Used
        {
            If (K%L%_Count > 0)
                H := ELP_OpenFileHandle(KeyDirectory "\Key " L, "Write", FileSize)
                , ELP_SetFilePointer(H, FileSize)
                , ELP_WriteData(H, &K%L%, K%L%_Count * 8)
                , ELP_CloseFileHandle(H)
                , VarSetCapacity(K%L%, 0) ;Required if Bytes_PerHotKey is smaller then before
                , VarSetCapacity(K%L%, Bytes_PerHotKey, 0)
                , BytesWritten += K%L%_Count * 8
                , K%L%_Count := 0
                , TotalKeysWritten ++
                , KeysWritten .= (KeysWritten ? "|" : "") . L
                , H := ""
                , FileSize := ""
            
            L ++
        }
        I ++
    }
    
    
    Critical, Off
    
    Return TotalKeysWritten "|" BytesWritten "|" KeysWritten
}

Get_DataFileSize(Which = "All")
{ ;This is used by the export package function
    Global
    Local Total_FileSize := 0, FileSize, H, I, L
    
    ;Gets key data sizes
    If (Which = "All" Or Which = "Keys")
    {
        I := Range0_Lower + 1 ;Skip range 1
        
        Loop, % Range0_Used - 1 ;Skip range 1
        {
            L := Range%I%_Lower
            
            Loop, % Range%I%_Used
            {
                H := ELP_OpenFileHandle(KeyDirectory "\Key " L, "Read", FileSize)
                , ELP_CloseFileHandle(H)
                
                If (FileSize)
                    Total_FileSize += FileSize
                    , Total_FileSize += 8 ;8 bytes to store the key identifier number
                    , Total_FileSize += 8 ;8 bytes to store the length of the key data
                
                L ++
            }
            
            I ++
        }
    }
    
    ;Gets mouse movement data sizes
    If (Which = "All" Or Which = "Mouse Movement Data")
    {
        H := ELP_OpenFileHandle(MouseMovementDirectory "\Mouse Movement Data", "Read", FileSize)
        , ELP_CloseFileHandle(H)
        
        If (FileSize)
            Total_FileSize += FileSize
            , Total_FileSize += 8 ;8 bytes to store the mouse movement data number (189)
            , Total_FileSize += 8 ;8 bytes to store the length of the mouse movement data
    }
    
    ;Gets words per time data sizes
    If (Which = "All" Or Which = "Words Per Time Data")
    {
        H := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Read", FileSize)
        , ELP_CloseFileHandle(H)
        
        If (FileSize)
            Total_FileSize += FileSize
            , Total_FileSize += 8 ;8 bytes to store the words per time data number (190)
            , Total_FileSize += 8 ;8 bytes to store the length of the words per time data
    }
    
    Return Total_FileSize
}

Export_ToPackage()
{
    Global
    Local KeyData
    , MouseData
    , WordData
    , H
    , FileSize
    , PackageData
    , Offset := 0
    , Total_PackageSize := 0
    , SaveName
    , I
    , L
    
    FileSelectFile, SaveName, S, %A_Desktop%\%A_Computername% - %A_Username% - %A_Now%, Select location to save
    
    If (SaveName = "")
        Return
    
    Critical, On
    
    If (Save_DataMethod = 1)
        Save_AllData(1)
    Else If (Save_DataMethod = 2)
        Close_FileHandles()
    
    Total_PackageSize := 8 + Get_DataFileSize()
    , VarSetCapacity(PackageData, Total_PackageSize, 0)
    
    
    ;Start Metadata section
    
    If ((Offset + 8) > Total_PackageSize)
        Return -1
    NumPut(Package_FileVersion, PackageData, Offset, "Double")
    , Offset += 8
    
    ;End Metadata section
    
    
    ;Stores key data
    I := Range0_Lower + 1 ;Skip range 1
    
    Loop, % Range0_Used - 1 ;Skip range 1
    {
        L := Range%I%_Lower
        
        Loop, % Range%I%_Used
        {
            H := ELP_OpenFileHandle(KeyDirectory "\Key " L, "Read", FileSize)
            
            If (FileSize != 0)
            {
                If ((Offset + 8) > Total_PackageSize)
                    Return -2
                
                NumPut(L, PackageData, Offset, "Int64")
                , Offset += 8
                
                If ((Offset + 8) > Total_PackageSize)
                    Return -3
                
                NumPut(FileSize, PackageData, Offset, "Int64")
                , Offset += 8
                
                If ((Offset + FileSize) > Total_PackageSize)
                    Return -4
                
                VarSetCapacity(KeyData, FileSize, 0)
                , ELP_ReadData(H, &KeyData, FileSize)
                , DllCall("RtlMoveMemory", Ptr, &PackageData + Offset, Ptr, &KeyData, "UInt", FileSize)
                , Offset += FileSize
                , VarSetCapacity(KeyData, FileSize, 0)
                , VarSetCapacity(KeyData, 0)
            }
            
            ELP_CloseFileHandle(H)
            , L ++
        }
        I ++
    }
    
    ;Stores mouse movement data
    H := ELP_OpenFileHandle(MouseMovementDirectory "\Mouse Movement Data", "Read", FileSize)
    
    If (FileSize != 0)
    {
        If ((Offset + 8) > Total_PackageSize)
            Return -5
        
        NumPut(MouseMovement_Number, PackageData, Offset, "Int64")
        , Offset += 8
        
        If ((Offset + 8) > Total_PackageSize)
            Return -6
        
        NumPut(FileSize, PackageData, Offset, "Int64")
        , Offset += 8
        
        If ((Offset + FileSize) > Total_PackageSize)
            Return -7
        
        VarSetCapacity(MouseData, FileSize, 0)
        , ELP_ReadData(H, &MouseData, FileSize)
        , DllCall("RtlMoveMemory", Ptr, &PackageData + Offset, Ptr, &MouseData, "UInt", FileSize)
        , Offset += FileSize
        , VarSetCapacity(MouseData, FileSize, 0)
        , VarSetCapacity(MouseData, 0)
    }
    
    ELP_CloseFileHandle(H)
    
    ;Stores word per time data
    H := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Read", FileSize)
    
    If (FileSize != 0)
    {
        If ((Offset + 8) > Total_PackageSize)
            Return -8
        
        NumPut(WordsPerTime_Number, PackageData, Offset, "Int64")
        , Offset += 8
        
        If ((Offset + 8) > Total_PackageSize)
            Return -9
        
        NumPut(FileSize, PackageData, Offset, "Int64")
        , Offset += 8
        
        If ((Offset + FileSize) > Total_PackageSize)
            Return -10
        
        VarSetCapacity(WordData, FileSize, 0)
        , ELP_ReadData(H, &WordData, FileSize)
        , DllCall("RtlMoveMemory", Ptr, &PackageData+Offset, Ptr, &WordData, "UInt", FileSize)
        , Offset += FileSize
        , VarSetCapacity(WordData, FileSize, 0)
        , VarSetCapacity(WordData, 0)
    }
    
    ELP_CloseFileHandle(H)
    
    
    ;Saves all of the collected data to the package file
    
    H := ELP_OpenFileHandle(SaveName, "Write")
    , ELP_WriteData(H, &PackageData, Total_PackageSize)
    , ELP_CloseFileHandle(H)
    
    If (Save_DataMethod = 2)
        Open_FileHandlesWrite()
    
    Critical, Off
    
    TrayTip, Export finished, Package export finished.
}

DisableCriticle(_R)
{
    Critical, Off
    Return _R
}

Import_Package(How)
{
    Global
    Local PackageName
    , PackageData
    , PackageSize
    , FileSize
    , H
    , Offset := 0
    , _Number
    , KeyData
    , KeyDataLength
    , ExistingOffset
    , File_FileFormat
    , MouseMovementData
    , MouseMovementDataLength
    , ExistingMouseMovementCount
    , IsCompatible
    , WordsPerData
    , WordsPerDataLength
    , I
    , L
    , KeyConversion
    
    Loop
    {
        FileSelectFile, PackageName,, %A_Desktop%, Select package to load
        
        If (PackageName = "")
            Return
        
        If (ELP_FileExists(PackageName, 1, 0, 0))
            Break
        
        PackageName := ""
    }
    
    Critical, On
    
    If (Save_DataMethod = 1){
        Save_AllData(1)
    } Else If (Save_DataMethod = 2){
        Close_FileHandles()
    }
    
    H := ELP_OpenFileHandle(PackageName, "Read", PackageSize)
    
    If (PackageSize = 0){
        ELP_CloseFileHandle(H)
        Return DisableCriticle(-1)
    }
    
    VarSetCapacity(PackageData, PackageSize, 0)
    , ELP_ReadData(H, &PackageData, PackageSize)
    , ELP_CloseFileHandle(H)
    
    If (!File_FileFormat := NumGet(PackageData, Offset, "Double"))
        Return DisableCriticle(-2)
    
    Offset += 8
    
    If File_FileFormat Is Not Float
        Return DisableCriticle(-3)
    
    If (File_FileFormat = Package_FileVersion)
        IsCompatible := True
    Else If (File_FileFormat = 2.1)
    {
        IsCompatible := True
        , KeyConversion := True
    }
    
    If (!IsCompatible)
        Return DisableCriticle(-4)
    
    If (How = 2){
        ELP_FileDelete(MouseMovementDirectory . "\Mouse movement data", 1, 0)
        , VarSetCapacity(TMouseMovementData, 8 * 3, 0)
        , PMoved := 0
        , ELP_FileDelete(WordDirectory . "\Words per time data", 1, 0)
        
        I := Range0_Lower + 1 ;Skip range 1
        
        Loop, % Range0_Used - 1 ;Skip range 1
        {
            L := Range%I%_Lower
            
            Loop, % Range%I%_Used
            {
                If (ELP_FileExists(KeyDirectory . "\Key " L, 1, 0, 0)){
                    If (ELP_FileDelete(KeyDirectory . "\Key " . L, 1, 0))
                        Return DisableCriticle(-8)
                }
                
                L ++
            }
            
            I ++
        }
    }
    
    Loop
    {
        If (Offset = PackageSize)
            Break
        Else If (Offset + 8 > PackageSize)
            Return -5
        _Number := NumGet(PackageData, Offset, "Int64")
        , Offset += 8
        
        If (_Number = MouseMovement_Number)
        {
            If (How = 2)
            {
                If (ELP_FileExists(MouseMovementDirectory . "\Mouse movement data", 1, 0, 0))
                {
                    If (ELP_FileDelete(MouseMovementDirectory . "\Mouse movement data", 1, 0))
                        Return DisableCriticle(-5)
                }
                VarSetCapacity(TMouseMovementData, 8 * 3, 0)
                , PMoved := 0
            }
            
            MouseMovementDataLength := NumGet(PackageData, Offset, "Int64")
            , Offset += 8
            
            If (MouseMovementDataLength)
            {
                VarSetCapacity(MouseMovementData, MouseMovementDataLength, 0)
                , DllCall("RtlMoveMemory", Ptr, &MouseMovementData, Ptr, &PackageData+Offset, "UInt", MouseMovementDataLength)
                , Offset += MouseMovementDataLength
                , H := ELP_OpenFileHandle(MouseMovementDirectory "\Mouse movement data", "Write", ExistingOffset)
                
                If (How = 1)
                { ;Merge
                    If (ExistingOffset != 0)
                    {
                        ELP_SetFilePointer(H, ExistingOffset)
                        , ELP_WriteData(H, &MouseMovementData + 8, MouseMovementDataLength - 8)
                    } Else
                        ELP_WriteData(H, &MouseMovementData, MouseMovementDataLength)
                } Else If (How = 2)
                { ;Replace
                    ELP_WriteData(H, &MouseMovementData, MouseMovementDataLength)
                } Else if (How = 3)
                { ;Merge-replace
                    If (ELP_FileExists(MouseMovementDirectory . "\Mouse movement data", 1, 0, 0))
                    {
                        If (ELP_FileDelete(MouseMovementDirectory . "\Mouse movement data", 1, 0))
                            Return DisableCriticle(-6)
                    }
                    
                    VarSetCapacity(TMouseMovementData, 8 * 3, 0)
                    , PMoved := 0
                    , ELP_WriteData(H, &MouseMovementData, MouseMovementDataLength)
                }
                
                ELP_CloseFileHandle(H)
                , VarSetCapacity(MouseMovementData, MouseMovementDataLength, 0)
                , VarSetCapacity(MouseMovementData, 0)
            }
        } Else if (_Number = WordsPerTime_Number)
        {
            If (!WordsPerDataLength := NumGet(PackageData, Offset, "Int64"))
                Return DisableCriticle(-10)
            Offset += 8
            
            VarSetCapacity(WordsPerData, WordsPerDataLength, 0)
            , DllCall("RtlMoveMemory", Ptr, &WordsPerData, Ptr, &PackageData+Offset, "UInt", WordsPerDataLength)
            , Offset += WordsPerDataLength
            , H := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Write", ExistingOffset)
            
            If (How = 1)
            { ;Merge
                ELP_SetFilePointer(H, ExistingOffset)
                , ELP_WriteData(H, &WordsPerData, WordsPerDataLength)
                , VarSetCapacity(WordsPerData, WordsPerDataLength, 0)
            } Else If (How = 2)
            { ;Replace
                ELP_SetFilePointer(H, 0)
                , ELP_WriteData(H, &WordsPerData, WordsPerDataLength)
                , VarSetCapacity(WordsPerData, WordsPerDataLength, 0)
            } Else if (How = 3)
            { ;Merge-replace
                If (ExistingOffset)
                {
                    ELP_CloseFileHandle(H)
                    
                    If (ELP_FileDelete(WordDirectory . "\Words per time data", 1, 0))
                        Return DisableCriticle(-10)
                    
                    H := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Write")
                }
                
                ELP_WriteData(H, &WordsPerData, WordsPerDataLength)
                , VarSetCapacity(WordsPerData, WordsPerDataLength, 0)
            }
            
            ELP_CloseFileHandle(H)
        } Else {
            If (!KeyDataLength := NumGet(PackageData, Offset, "Int64"))
                Return -9
            Offset += 8
            
            If (KeyConversion)
            {
                _Number := Convert_KeyFile(_Number, 0, 1)
                
                If (_Number <= 0)
                    Return DisableCriticle(-10)
            }
            
            VarSetCapacity(KeyData, KeyDataLength, 0)
            , DllCall("RtlMoveMemory", Ptr, &KeyData, Ptr, &PackageData+Offset, "UInt", KeyDataLength)
            , Offset += KeyDataLength
            , H := ELP_OpenFileHandle(KeyDirectory "\Key " _Number, "Write", ExistingOffset)
            
            If (How = 1)
            { ;Merge
                ELP_SetFilePointer(H, ExistingOffset)
                , ELP_WriteData(H, &KeyData, KeyDataLength)
                , VarSetCapacity(KeyData, KeyDataLength, 0)
            } Else If (How = 2)
            { ;Replace
                ELP_SetFilePointer(H, 0)
                , ELP_WriteData(H, &KeyData, KeyDataLength)
                , VarSetCapacity(KeyData, KeyDataLength, 0)
            } Else if (How = 3)
            { ;Merge-replace
            
                If (ELP_FileExists(KeyDirectory . "\Key " . _Number, 1, 0, 0))
                {
                    ELP_CloseFileHandle(H)
                    
                    If (ELP_FileDelete(KeyDirectory . "\Key " . _Number, 1, 0))
                        Return DisableCriticle(-11)
                    
                    H := ELP_OpenFileHandle(KeyDirectory "\Key " _Number, "Write")
                }
                
                ELP_WriteData(H, &KeyData, KeyDataLength)
                , VarSetCapacity(KeyData, KeyDataLength, 0)
            }
            
            ELP_CloseFileHandle(H)
        }
    }
    
    UpdateCounts()
    , UpdateToolTip()
    
    If (Save_DataMethod = 2)
        Open_FileHandlesWrite()
    
    Critical, Off
    
    TrayTip, Import finished, Package import finished.
}

UpdateToolTip()
{
    Global
    Static LastCountUpdate, LastBytesUpdate, LastTip, NewTip
    Local KeyboardCount := 0
    , MouseCount := 0
    , PixelCount
    , WordCount
    , I
    , L
    
    If (Show_TodaysCount)
    {
        If (LastCountUpdate = "")
            LastCountUpdate := A_YYYY A_MM A_DD
        
        If (LastCountUpdate != A_YYYY A_MM A_DD)
            UpdateCounts()
    }
    
    If (LastBytesUpdate = "")
        LastBytesUpdate := A_YYYY A_MM A_DD A_Hour A_MM
    
    If (LastBytesUpdate != A_YYYY A_MM A_DD A_Hour A_MM)
        Write_HDActivity() ;This resets the internal storebytes counter and writes the data to the file
    
    I := 2
    
    Loop, 11
    {
        L := Range%I%_Lower
        
        Loop, % Range%I%_Used
        {
            If (K%L%_TotalCount != "")
                KeyboardCount += K%L%_TotalCount
            
            L ++
        }
        
        I ++
    }
    
    L := Range13_Lower
    , MouseCount := 0
    
    Loop, % Range13_Used
    {
        MouseCount +=  K%L%_TotalCount
        , L ++
    }
    
    PixelCount := Show_TodaysCount ? TodaysPixelsMoved : TotalPixelsMoved
    , WordCount := Show_TodaysCount ? TodaysWordCount : TotalWordCount
    , DistanceCount := Show_TodaysCount ? TodaysDistanceMoved : TotalDistanceMoved
    , ByteReadCount := Show_TodaysCount ? TodaysBytesRead : TotalBytesRead
    , ByteWrittenCount := Show_TodaysCount ? TodaysBytesWritten : TotalBytesWritten
    , DistanceCount := Round(DistanceCount, 2)
    
    , NewTip .= "Mouse`n"
    . "All Buttons: " MouseCount "`n"
    . "Pixels: " PixelCount "`n"
    . "Inches: " DistanceCount "`n`n"
    . "Keyboard`n"
    . "All Keys: " KeyboardCount "`n"
    . "Words: " WordCount
    
    If (Show_CountsInConvertedUnits or StrLen(NewTip) > 127){
        NewTip := "Mouse`n"
        . "All Buttons: " Convert_Unit(MouseCount) "`n"
        . "Pixels: " Convert_Unit(PixelCount) "`n"
        . "Inches: " Convert_Unit(DistanceCount) "`n`n"
        . "Keyboard`n"
        . "All Keys: " Convert_Unit(KeyboardCount) "`n"
        . "Words: " Convert_Unit(WordCount)
    }
    
    If (NewTip != LastTip)
    {
        Menu, Tray, Tip, %NewTip%
        LastTip := NewTip
    }
    
    LastCountUpdate := A_YYYY A_MM A_DD
    , LastBytesUpdate := A_YYYY A_MM A_DD A_Hour A_MM
}

MenuHandler(MenuName)
{
    Global
    Local ProcessingErrors, ErrorInformation
    
    If (MenuName = "Export history to package")
    {
        If (ProcessingErrors := Export_ToPackage())
            TrayTip, Error exporting history package, There was an error exporting the package: %ProcessingErrors%
        
    } Else If (MenuName = "Import history from package (replace)")
    {
        If (ProcessingErrors := Import_Package(2))
            TrayTip, Error importing history package, There was an error importing the history package (replace): %ProcessingErrors%
        
    } Else If (MenuName = "Import history from package (merge)")
    {
        If (ProcessingErrors := Import_Package(1))
            TrayTip, Error importing history package, There was an error importing the history package (merge): %ProcessingErrors%
        
    } Else If (MenuName = "Import history from package (merge-replace)")
    {
        If (ProcessingErrors := Import_Package(3))
            TrayTip, Error importing history package, There was an error importing the history package (merge-replace): %ProcessingErrors%
        
    } Else If (MenuName = "Enable mouse counting")
    {
        CountMouse := !CountMouse
        ;If (_ShowTip)
        ;   TrayTip, Completed, % CountMouse ? "Mouse capture enabled." : "Mouse capture disabled."
        
        If (CountMouse)
            Menu, Tray, Check, Enable mouse counting
        Else
            Menu, Tray, UnCheck, Enable mouse counting
        
        Settings_GUI("Sync", MenuName, CountMouse)
        
    } Else If (MenuName = "Enable keyboard counting")
    {
        CountKeyboard := !CountKeyboard
        ;If (_ShowTip)
        ;   TrayTip, Completed, % CountKeyboard ? "Keyboard capture enabled." : "Keyboard capture disabled."
        
        If (CountKeyboard)
            Menu, Tray, Check, Enable keyboard counting
        Else
            Menu, Tray, UnCheck, Enable keyboard counting
        
        Settings_GUI("Sync", MenuName, CountKeyboard)
        
    } Else If (MenuName = "Count pixels mouse moved")
    {
        CountPixelsMoved := !CountPixelsMoved
        ;If (_ShowTip)
        ;   TrayTip, Completed, % CountPixelsMoved ? "Pixel movement counting enabled." : "Pixel movement counting disabled."
        
        If (CountPixelsMoved){
            Menu, Tray, Check, Count pixels mouse moved
            SetTimer, MonitorMouseMovement, -1
        } Else
            Menu, Tray, UnCheck, Count pixels mouse moved
        
        Settings_GUI("Sync", MenuName, CountPixelsMoved)
        
    } Else If (MenuName = "Count words per ?")
    {
        CountWPT := !CountWPT
        ;If (_ShowTip)
        ;   TrayTip, Completed, % CountWPT ? "Count words per ? enabled." : "Count words per ? disabled."
        
        If (CountWPT)
            Menu, Tray, Check, Count words per ?
        Else
            Menu, Tray, UnCheck, Count words per ?
        
        Settings_GUI("Sync", MenuName, CountWPT)
        
    } Else If (MenuName = "Count bytes read/written")
    {
        Write_HDActivity()
        
        , CountHDActivity := !CountHDActivity
        , ELP_MasterSettings("Set", "Count_BytesWritten", CountHDActivity)
        , ELP_MasterSettings("Set", "Count_BytesRead", CountHDActivity)
        
        ;If (_ShowTip)
        ;   TrayTip, Completed, % CountHDActivity ? "Count bytes read/written enabled." : "Count bytes read/written disabled."
        
        If (CountHDActivity)
            Menu, Tray, Check, Count bytes read/written
        Else
            Menu, Tray, UnCheck, Count bytes read/written
        
        Settings_GUI("Sync", MenuName, CountHDActivity)
        
    } Else If (MenuName = "Reset counters")
    {
        ResetCounters_GUI()
        
    } Else If (MenuName = "About")
    {
        About()
        
    } Else If (MenuName = "Save method 1 (buffer key counts)")
    {
        Menu, OptionsSubMenu, Check, Save method 1 (buffer key counts)
        Menu, OptionsSubMenu, UnCheck, Save method 2 (direct to disk)
        Switch_SaveMethod(1)
        , Settings_GUI("Sync", MenuName)
        
    } Else if (MenuName = "Save method 2 (direct to disk)")
    {
        Menu, OptionsSubMenu, Check, Save method 2 (direct to disk)
        Menu, OptionsSubMenu, UnCheck, Save method 1 (buffer key counts)
        Switch_SaveMethod(2)
        , Settings_GUI("Sync", MenuName)
        
    } Else If (MenuName = "Autostart at logon")
    {
        Autostart()
        Menu, OptionsSubMenu, ToggleCheck, Autostart at logon
        
        Settings_GUI("Sync", MenuName, Autostart("Check") ? 1 : 0)
        
    } Else If (MenuName = "Minutes")
    {
        Change_CaptureAccuracy(1)
        
        , Settings_GUI("Sync", MenuName)
        
    } Else If (MenuName = "Seconds")
    {
        Change_CaptureAccuracy(2)
        
        , Settings_GUI("Sync", MenuName)
        
    } Else If (MenuName = "Milliseconds")
    {
        Change_CaptureAccuracy(3)
        
        , Settings_GUI("Sync", MenuName)
        
    } Else If (MenuName = "Verify stored data")
    {
        VerifyStoredData()
        
    } Else If (MenuName = "Enable autosave")
    {
        AutoSave_State := !AutoSave_State
        
        If (!AutoSave_State)
            SetTimer, AutoSave, Off
        Else
            SetTimer, AutoSave, % Autosave_Interval * 1000
        
        Menu, OptionsSubMenu, ToggleCheck, Enable autosave
        
        Settings_GUI("Sync", MenuName, AutoSave_State)
        
    } Else If (SubStr(MenuName, 1, 15) = "Set screen size")
    {
        ScreenSizes := Get_ScreenSizes(ScreenSizes)
        
    } Else If (MenuName = "Use registry to store settings")
    {
        Save_SettingsMethod := 1
        
        Menu, OptionsSubMenu, UnCheck, Use options file to store settings
        Menu, OptionsSubMenu, Check, Use registry to store settings
        
        Save_Settings(0, 1)
        
        , Settings_GUI("Sync", MenuName)
        
    } Else If (MenuName = "Use options file to store settings")
    {
        Save_SettingsMethod := 2
        
        Menu, OptionsSubMenu, Check, Use options file to store settings
        Menu, OptionsSubMenu, UnCheck, Use registry to store settings
        
        Save_Settings(0, 1)
        
        , Settings_GUI("Sync", MenuName)
        
    } Else If (SubStr(MenuName, 1, 19) = "Set maximum RAM Use")
    {
        Get_RamUse()
        
    } Else If (SubStr(MenuName, 1, 21) = "Set autosave interval")
    {
        Get_AutosaveInterval()
        
    } Else If (MenuName = "Show hover over counts in converted units")
    {
        Show_CountsInConvertedUnits := !Show_CountsInConvertedUnits
        
        Menu, OptionsSubMenu, ToggleCheck, Show hover over counts in converted units
        
        Settings_GUI("Sync", MenuName, Show_CountsInConvertedUnits)
        
    } Else If (MenuName = "Show todays counts in hover-over tray tip")
    {
        Show_TodaysCount := !Show_TodaysCount
        , UpdateCounts()
        , UpdateToolTip()
        
        Menu, OptionsSubMenu, ToggleCheck, Show todays counts in hover-over tray tip
        
        Settings_GUI("Sync", MenuName, Show_TodaysCount)
        
    } Else If (MenuName = "Show all computers data in tray tip")
    {
        Show_AllComputers := !Show_AllComputers
        , UpdateCounts()
        , UpdateToolTip()
        
        Menu, OptionsSubMenu, ToggleCheck, Show all computers data in tray tip
        
        Settings_GUI("Sync", MenuName, Show_AllComputers)
        
    } Else If (MenuName = "Check for update")
    {
        Check_ForUpdate(1, 0, "", ErrorInformation)
        
        If (ErrorInformation = "No update was found.")
            TrayTip, No update, No update was found
        Else If (ErrorInformation != "None")
            MsgBox There was a problem checking for updates.`n`nError given: %ErrorInformation%
        
    } Else If (MenuName = "Remove this program and all of its files from this computer")
    {
        Uninstall_Script()
        
    } Else If (MenuName = "Show key/mouse counts for a specific date range")
    {
        Show_KeyInformation()
        
    } Else If (MenuName = "Show mouse movement information for a specific date range")
    {
        Show_MouseMovementInformation()
        
    } Else If (MenuName = "Show word information for a specific date range")
    {
        Show_WordInformation()
        
    } Else If (MenuName = "Settings GUI")
    {
        Settings_GUI()
        
    } Else If (MenuName = "Exit")
    {
        ExitApp
        
    }
    
    SetTimer, RemoveTrayTip, -5000
    
    Save_Settings()
}

CountPixelsMoved(_DA, _DS)
{
    Global Ptr
    Static MCodedData, MCCountPixels
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountPixelsHex =
            (LTrim Join
                4533C04883C1184C8BDA458BC8458BD0483BCA734B488BC2482BC14883C01F489983
                E21F4803C248C1F8054883F8027C1F498D43E06666660F1F8400000000004C03014C
                0349204883C140483BC87CF0493BCB73034C8B114B8D04014903C2C3498BC0C3
            )
        } Else {
            CountPixelsHex =
            (LTrim Join
                83EC088B4C240C5355565733C033D283C11833DB33ED33F633FF8944241089542414
                3B4C2420735F8B4424202BC183C01F9983E21F03C2C1F80583F8027C198B44242083
                C0E0031913690403712013792483C1403BC87CEE3B4C242073178B018B490403F313
                FD03C613CF5F5E5D8BD15B83C408C38B4424108B4C241403F313FD03C613CF8BD15F
                5E5D5B83C408C3
            )
        }
        
        VarSetCapacity(MCCountPixels, StrLen(CountPixelsHex)//2)
        Loop % StrLen(CountPixelsHex)//2
            NumPut("0x" . SubStr(CountPixelsHex, 2*A_Index-1, 2), MCCountPixels, A_Index-1, "Char")
        CountPixelsHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountPixels, Ptr, VarSetCapacity(MCCountPixels), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountPixels, Ptr, _DA, Ptr, _DA + _DS, "cdecl Int64")
}

CountDistanceMoved(_DA, _DS)
{
    Global Ptr
    Static MCodedData, MCCountDistanceMoved
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountDistanceMovedHex =
            (LTrim Join
                660F57C04883C1204C8BC2483BCA734E488BC2482BC14883C01F489983E21F4803C2
                48C1F8054883F8047C20498D40A0F20F58014883E980F20F5841A0F20F5841C0F20F
                5841E0483BC87CE4493BC8730DF20F58014883C120493BC872F3F3C3
            )
        } Else {
            CountDistanceMovedHex =
            (LTrim Join
                8B4C2404D9EE568B74240C83C1203BCE73378BC62BC183C01F9983E21F03C2C1F805
                83F8047C158D46A0DC0183E980DC41A0DC41C0DC41E03BC87CEE3BCE7309DC0183C1
                203BCE72F75EC3
            )
        }
        
        VarSetCapacity(MCCountDistanceMoved, StrLen(CountDistanceMovedHex)//2)
        Loop % StrLen(CountDistanceMovedHex)//2
            NumPut("0x" . SubStr(CountDistanceMovedHex, 2*A_Index-1, 2), MCCountDistanceMoved, A_Index-1, "Char")
        CountDistanceMovedHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountDistanceMoved, Ptr, VarSetCapacity(MCCountDistanceMoved), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountDistanceMoved, Ptr, _DA, Ptr, _DA + _DS, "cdecl double")
}

CountTodaysPixelsMoved(_DA, _DS, _Now, _Tomorrow)
{
    Global Ptr
    Static MCodedData, MCCountTodaysPixels
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountTodaysPixelsHex =
            (LTrim Join
                4883C1084533D2483BCA731E0F1F4000488B01493BC07C09493BC17D044C03511048
                83C120483BCA72E6498BC2C3
            )
        } Else {
            CountTodaysPixelsHex =
            (LTrim Join
                8B4C240483C10833C033D23B4C24087338538B5C241456578B71048B393BF37C1C7F
                063B7C241872143B7424247F0E7C063B7C2420730603411013511483C1203B4C2414
                72D25F5E5BC3
            )
        }
        
        VarSetCapacity(MCCountTodaysPixels, StrLen(CountTodaysPixelsHex)//2)
        Loop % StrLen(CountTodaysPixelsHex)//2
            NumPut("0x" . SubStr(CountTodaysPixelsHex, 2*A_Index-1, 2), MCCountTodaysPixels, A_Index-1, "Char")
        CountTodaysPixelsHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountTodaysPixels, Ptr, VarSetCapacity(MCCountTodaysPixels), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountTodaysPixels, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _Tomorrow, "cdecl Int64")
}

CountTodaysDistanceMoved(_DA, _DS, _Now, _Tomorrow)
{
    Global Ptr
    Static MCodedData, MCCountTodaysDistanceMoved
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountTodaysDistanceMovedHex =
            (LTrim Join
                660F57C04883C108483BCA731E0F1F00488B01493BC07C0A493BC17D05F20F584118
                4883C120483BCA72E5F3C3
            )
        } Else {
            CountTodaysDistanceMovedHex =
            (LTrim Join
                558BEC8B4508D9EE83C0083B450C733C568B48048B103B4D147C0C7F053B551072053
                3F646EB0233F63B4D1C7F0C7C053B5518730533C941EB0233C985F17403DC401883C0
                203B450C72C65E5DC3
            )
        }
        
        VarSetCapacity(MCCountTodaysDistanceMoved, StrLen(CountTodaysDistanceMovedHex)//2)
        Loop % StrLen(CountTodaysDistanceMovedHex)//2
            NumPut("0x" . SubStr(CountTodaysDistanceMovedHex, 2*A_Index-1, 2), MCCountTodaysDistanceMoved, A_Index-1, "Char")
        CountTodaysDistanceMovedHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountTodaysDistanceMoved, Ptr, VarSetCapacity(MCCountTodaysDistanceMoved), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountTodaysDistanceMoved, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _Tomorrow, "cdecl double")
}

CountTodaysKeyPresses(_DA, _DS, _Now, _Tomorrow)
{
    Global Ptr
    Static MCodedData, MCCountTodaysKeyPresses
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountTodaysKeyPressesHex =
            (LTrim Join
                33C0483BCA73194C8B114D3BD07C084D3BD17D0348FFC04883C108483BCA72E7F3C3
            )
        } Else {
            CountTodaysKeyPressesHex =
            (LTrim Join
                8B4C240433C033D23B4C24087338538B5C241456578B71048B393BF37C1C7F063B7C
                241872143B7424247F0E7C063B7C2420730683C00183D20083C1083B4C241472D25F
                5E5BC3
            )
        }
        
        VarSetCapacity(MCCountTodaysKeyPresses, StrLen(CountTodaysKeyPressesHex)//2)
        Loop % StrLen(CountTodaysKeyPressesHex)//2
            NumPut("0x" . SubStr(CountTodaysKeyPressesHex, 2*A_Index-1, 2), MCCountTodaysKeyPresses, A_Index-1, "Char")
        CountTodaysKeyPressesHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountTodaysKeyPresses, Ptr, VarSetCapacity(MCCountTodaysKeyPresses), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountTodaysKeyPresses, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _Tomorrow, "cdecl Int64")
}

CountTodaysWordsTyped(_DA, _DS, _Now, _Tomorrow, _CountLengths = false)
{
    Global Ptr
    Static MCodedData, MCCountTodaysWords
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            ;CountTodaysWordsHex =
            ;(LTrim Join
            ;   33C0483BCA73194C8B114D3BD07C084D3BD17D0348FFC04883C110483BCA72E7F3C3
            ;)
            
            CountTodaysWordsHex =
            (LTrim Join
                33C04C8BDA48394424287421483BCA733A4C8B114D3BD07C094D3BD17D0448034108
                4883C110483BCA72E6F3C3483BCA7319488B11493BD07C08493BD17D0348FFC04883
                C110493BCB72E7F3C3
            )
        } Else {
            ;CountTodaysWordsHex =
            ;(LTrim Join
            ;   8B4C240433C033D23B4C24087338538B5C241456578B71048B393BF37C1C7F063B7C
            ;   241872143B7424247F0E7C063B7C2420730683C00183D20083C1103B4C241472D25F
            ;   5E5BC3
            ;)
            
            CountTodaysWordsHex =
            (LTrim Join
                8B4C241C535633C033D20B4C24285774418B4C24103B4C241473738B5C241C908B71
                048B393BF37C1C7F063B7C241872143B7424247F0E7C063B7C242073060341081351
                0C83C1103B4C241472D25F5E5BC38B7424103B74241473328B5C241C8B4E048B3E3B
                CB7C1C7F063B7C241872143B4C24247F0E7C063B7C2420730683C00183D20083C610
                3B74241472D25F5E5BC3
            )
        }
        
        VarSetCapacity(MCCountTodaysWords, StrLen(CountTodaysWordsHex)//2)
        Loop % StrLen(CountTodaysWordsHex)//2
            NumPut("0x" . SubStr(CountTodaysWordsHex, 2*A_Index-1, 2), MCCountTodaysWords, A_Index-1, "Char")
        CountTodaysWordsHex := ""
        , DllCall("VirtualProtect", Ptr, &MCCountTodaysWords, Ptr, VarSetCapacity(MCCountTodaysWords), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    Return DllCall(&MCCountTodaysWords, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _Tomorrow, "Int64", _CountLengths, "cdecl Int64")
}

CountBytesReadWritten(_DA, _DS, _TBR, _TBW)
{
    Global Ptr
    Static MCodedData, MCountBytes
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountBytesHex =
            (LTrim Join
                33C04883C110498900498901483BCA7316488B014883C118490100488B41F0490101
                483BCA72EAF3C3
            )
        } Else {
            CountBytesHex =
            (LTrim Join
                8B4C240C8B54241033C0890189410489028942048B442404568B74240C83C0103BC6
                731E578B3801398B78041179048B7808013A8B780C117A0483C0183BC672E45F5EC3
            )
        }
        
        VarSetCapacity(MCountBytes, StrLen(CountBytesHex)//2)
        Loop % StrLen(CountBytesHex)//2
            NumPut("0x" . SubStr(CountBytesHex, 2*A_Index-1, 2), MCountBytes, A_Index-1, "Char")
        CountBytesHex := ""
        , DllCall("VirtualProtect", Ptr, &MCountBytes, Ptr, VarSetCapacity(MCountBytes), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    DllCall(&MCountBytes, Ptr, _DA, Ptr, _DA + _DS, Ptr, _TBR, Ptr, _TBW, "cdecl")
}

CountTodaysBytesReadWritten(_DA, _DS, _Now, _Tomorrow, _TBR, _TBW)
{
    Global Ptr
    Static MCodedData, MCountTodaysBytes
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountTodaysBytesHex =
            (LTrim Join
                4C8B5424284C8B5C243033C04883C108498902498903483BCA73290F1F440000488B
                01493BC07C13493BC17D0E488B4108490102488B41104901034883C118483BCA72DC
                F3C3
            )
        } Else {
            CountTodaysBytesHex =
            (LTrim Join
                8B4C241C8B54242033C0890189410489028942048B44240483C0083B442408734853
                8B5C241456578B70048B383BF37C2C7F063B7C241872243B7424247F1E7C063B7C24
                2073168B700801318B700C1171048B701001328B701411720483C0183B44241472C2
                5F5E5BC3
            )
        }
        
        VarSetCapacity(MCountTodaysBytes, StrLen(CountTodaysBytesHex)//2)
        Loop % StrLen(CountTodaysBytesHex)//2
            NumPut("0x" . SubStr(CountTodaysBytesHex, 2*A_Index-1, 2), MCountTodaysBytes, A_Index-1, "Char")
        CountTodaysBytesHex := ""
        , DllCall("VirtualProtect", Ptr, &MCountTodaysBytes, Ptr, VarSetCapacity(MCountTodaysBytes), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    DllCall(&MCountTodaysBytes, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _Tomorrow, Ptr, _TBR, Ptr, _TBW, "cdecl")
}

IsValidRootDirectory(_RootDirectory)
{
    R := true
    
    If (SubStr(_RootDirectory, 0) = "." Or SubStr(_RootDirectory, 0) = " ")
        R := False
    
    Return R
}

UpdateCounts(_Notify = 0)
{
    Global
    Local H, Data, FileSize, Today, Tomorrow, PixelFileFormat, PixelIsCompatible, I, L, Loaded, HD_Version, Now
    , FName, All_KeyDirectories, All_MouseMovementDirectories, All_WordDirectories, All_HDActivityDirectories
    , BTodaysBytesRead, BTodaysBytesWritten, BTotalBytesRead, BTotalBytesWritten
    Static ConvertRange_Low := 1, ConvertRange_High := 188
    
    Critical, On
    
    If (Save_DataMethod = 1)
        Save_AllData(1)
;   Else If (Save_DataMethod = 2)
;       Close_FileHandles()
    
    Tomorrow := Today := A_Year . A_Mon . A_DD . 00 . 00 . 00 . 000
    Tomorrow += 1, Days
    Tomorrow .= 000
    , Now := A_Now . 000
    , Loaded := 1
    
    If (Show_AllComputers){
        Loop
        {
            FName := ELP_LoopFilePattern(RootDirectory "\*.*", 2)
            If (!FName)
                Break
            
            If (ELP_FileExists(FName "\Keys", 2, 0, 0))
                All_KeyDirectories .= All_KeyDirectories = "" ? FName "\Keys" : "`n" FName "\Keys"
            
            If (ELP_FileExists(FName "\Mouse Movement", 2, 0, 0))
                All_MouseMovementDirectories .= All_MouseMovementDirectories = "" ? FName "\Mouse Movement" : "`n" FName "\Mouse Movement"
                
            If (ELP_FileExists(FName "\Word Speed", 2, 0, 0))
                All_WordDirectories .= All_WordDirectories = "" ? FName "\Word Speed" : "`n" FName "\Word Speed" 
            
            All_HDActivityDirectories .= All_HDActivityDirectories = "" ? FName : "`n" FName
        }
    } Else {
        All_KeyDirectories := KeyDirectory
        , All_MouseMovementDirectories := MouseMovementDirectory
        , All_WordDirectories := WordDirectory
        , All_HDActivityDirectories := SaveDirectory
    }
    
    Loop, Parse, All_KeyDirectories, `n
    {
        Loop
        {
            FName := ELP_LoopFilePattern(A_LoopField "\Key ???") ;Only finds key files with the old name structure
            If (!FName)
                Break
            
            I := SubStr(FName, InStr(FName, A_Space, False, InStr(FName, "\", False, 0))+1)
            
            If (I >= ConvertRange_Low And I <= ConvertRange_High)
                Convert_KeyFile(FName)
        }
    }
    
    ;Gets the key data counts
    I := Range0_Lower + 1 ;Skip range 1
    
    Loop, % Range0_Used
    {
        L := Range%I%_Lower
        
        Loop, % Range%I%_Used
        {
            K%L%_TotalCount := 0
            
            Loop, Parse, All_KeyDirectories, `n
            {
                If (_Notify)
                    Menu, Tray, Tip, % "Loading file: " Loaded
                
                H := ELP_OpenFileHandle(A_LoopField "\Key " L, "Read", FileSize)
                
                If (FileSize != 0)
                {
                    If (Show_TodaysCount)
                    {
                            VarSetCapacity(Data, FileSize, 0)
                            , ELP_ReadData(H, &Data, FileSize)
                            , FileSize := Validate_KeyData(&Data, FileSize, Now)
                            , K%L%_TotalCount += CountTodaysKeyPresses(&Data, FileSize, Today, Tomorrow)
                    } Else
                        K%L%_TotalCount += FileSize // 8
                }
                
                ELP_CloseFileHandle(H)
                , Loaded ++
            }
            L ++
        }
        I ++
    }
    
    
    TodaysPixelsMoved := TodaysDistanceMoved := TotalPixelsMoved := TotalDistanceMoved := 0
    
    Loop, Parse, All_MouseMovementDirectories, `n
    {
        ;Get the mouse pixel movement counts
        H := ELP_OpenFileHandle(A_LoopField "\Mouse Movement Data", "Read", FileSize)
        
        If (_Notify)
            Menu, Tray, Tip, % "Loading file: " Loaded
        If (H != -1)
            Loaded ++
        
        If (FileSize != 0){
            VarSetCapacity(Data, 8, 0)
            , ELP_ReadData(H, &Data, 8)
            , ELP_CloseFileHandle(H)
            , PixelFileFormat := NumGet(Data, 0, "Double")
            
            If (PixelFileFormat < 1 Or PixelFileFormat = 1.0){ ;old file-format - convert it to the current style
                Convert_PixelData_0And10To11(A_LoopField "\Mouse Movement Data")
                , PixelIsCompatible := True
            } Else If (PixelFileFormat = Pixel_FileVersion)
                PixelIsCompatible := True
            
            If (PixelIsCompatible)
            {
                H := ELP_OpenFileHandle(A_LoopField "\Mouse Movement Data", "Read", FileSize)
                , VarSetCapacity(Data, FileSize, 0)
                , ELP_ReadData(H, &Data, FileSize)
                , ELP_CloseFileHandle(H)
                , FileSize := Validate_MouseData(&Data, FileSize, Now)
                
                If (Show_TodaysCount)
                    TodaysPixelsMoved += CountTodaysPixelsMoved(&Data, FileSize, Today, Tomorrow)
                    , TodaysDistanceMoved += CountTodaysDistanceMoved(&Data, FileSize, Today, Tomorrow)
                    
                TotalPixelsMoved += CountPixelsMoved(&Data, FileSize)
                , TotalDistanceMoved += CountDistanceMoved(&Data, FileSize)
            } Else
                ELP_FileMove(A_LoopField "\Mouse Movement Data", A_LoopField "\Incompatible old - " A_Now " - Mouse Movement Data", 1, 1, 0)
        } Else
            ELP_CloseFileHandle(H)
    }
    
    
    TotalWordCount := TodaysWordCount := 0
    
    Loop, Parse, All_WordDirectories, `n
    {
        ;Get the words per time counts
        H := ELP_OpenFileHandle(A_LoopField "\Words per time data", "Read", FileSize)
        
        If (_Notify)
            Menu, Tray, Tip, % "Loading file: " Loaded
        If (H != -1)
            Loaded ++
        
        If (FileSize != 0)
        {
            If (Show_TodaysCount)
            {
                VarSetCapacity(Data, FileSize, 0)
                , ELP_ReadData(H, &Data, FileSize)
                , FileSize := Validate_WordData(&Data, FileSize, Now)
                , TodaysWordCount += CountTodaysWordsTyped(&Data, FileSize, Today, Tomorrow)
            }
            
            TotalWordCount += FileSize // 16
        }
        
        ELP_CloseFileHandle(H)
    }
    
    
    TodaysBytesRead := TodaysBytesWritten := TotalBytesRead := TotalBytesWritten := 0
    
    Loop, Parse, All_HDActivityDirectories, `n
    {
        ;Get the bytes read/written counts
        H := ELP_OpenFileHandle(A_LoopField "\HD activity", "Read", FileSize)
        
        If (_Notify)
            Menu, Tray, Tip, % "Loading file: " Loaded
        If (H != -1)
            Loaded ++
        
        If (FileSize != 0){
            VarSetCapacity(Data, FileSize, 0)
            , ELP_ReadData(H, &Data, FileSize)
            , ELP_CloseFileHandle(H)
            , HD_Version := NumGet(Data, 0, "Double")
            
            If (HD_Version != HD_FileVersion){
                ELP_FileMove(A_LoopField "\HD activity", A_LoopField "\HD activity - Incompatible - " A_Now, 0, 0, 0)
                , FileSize := 0
            } Else {
                If (Show_TodaysCount){
                    VarSetCapacity(BTodaysBytesRead, 8, 0)
                    , VarSetCapacity(BTodaysBytesWritten, 8, 0)
                    
                    , CountTodaysBytesReadWritten(&Data, FileSize, Today, Tomorrow, &BTodaysBytesRead, &BTodaysBytesWritten)
                    
                    , TodaysBytesRead += NumGet(BTodaysBytesRead, 0, "Int64")
                    , TodaysBytesWritten += NumGet(BTodaysBytesWritten, 0, "Int64")
                    , VarSetCapacity(BTodaysBytesRead, 0)
                    , VarSetCapacity(BTodaysBytesWritten, 0)
                }
                
                VarSetCapacity(BTotalBytesRead, 8, 0)
                , VarSetCapacity(BTotalBytesWritten, 8, 0)
                
                , CountBytesReadWritten(&Data, FileSize, &BTotalBytesRead, &BTotalBytesWritten)
                
                , TotalBytesRead += NumGet(BTotalBytesRead, 0, "Int64")
                , TotalBytesWritten += NumGet(BTotalBytesWritten, 0, "Int64")
                , VarSetCapacity(BTotalBytesRead, 0)
                , VarSetCapacity(BTotalBytesWritten, 0)
            }
        }
        
        ELP_CloseFileHandle(H)
    }
    
    VarSetCapacity(Data, 0)
    
;   If (Save_DataMethod = 2)
;       Open_FileHandlesWrite()
    
    Write_HDActivity()
    
    Critical, Off
}

Convert_PixelData_0And10To11(_FName)
{
    Global Pixel_FileVersion
    
    H := ELP_OpenFileHandle(_FName, "Read", FileSize)
    
    If (FileSize != 0){
        VarSetCapacity(OldData, FileSize, 0)
        , ELP_ReadData(H, &OldData, FileSize)
        , ELP_CloseFileHandle(H)
        , Old_Offset := 8
        , New_Offset := 0
        , NewFileSize := (((FileSize - 8) // 24 ) * 32) + 8
        , VarSetCapacity(NewData, NewFileSize, 0)
        , NumPut(Pixel_FileVersion, NewData, New_Offset, "Double")
        , New_Offset += 8
        
        Loop, % (FileSize - 8) // 24
        {
            PPI := NumGet(OldData, Old_Offset, "Double")
            , Old_Offset += 8
            , Date := NumGet(OldData, Old_Offset, "Int64")
            , Old_Offset += 8
            , PMoved := NumGet(OldData, Old_Offset, "Int64")
            , Old_Offset += 8
            , NumPut(Date, NewData, New_Offset, "Int64")
            , New_Offset += 8
            , NumPut(0, NewData, New_Offset, "Int64")
            , New_Offset += 8
            , NumPut(PMoved, NewData, New_Offset, "Int64")
            , New_Offset += 8
            , NumPut(PMoved / PPI, NewData, New_Offset, "Double")
            , New_Offset += 8
        }
        
        ELP_FileDelete(_FName, 1, 0)
        
        , H := ELP_OpenFileHandle(_FName, "Write")
        , ELP_WriteData(H, &NewData, New_Offset)
        , ELP_CloseFileHandle(H)
        , VarSetCapacity(NewData, New_Offset, 0)
        , VarSetCapacity(NewData, 0)
        , VarSetCapacity(OldData, FileSize, 0)
        , VarSetCapacity(OldData, 0)
    } Else 
        ELP_CloseFileHandle(H)
}


ResetCounters(_RootFolder, _Which = "All", _ShowWarning = 1, _UpdateCounters = 1)
{
    Global
    Local TempNumber, L, FFullPath, FName, FDirectory
    
    If (_ShowWarning)
    {
        MsgBox, 0x4, Are you sure?, Are you sure you want to reset the %_Which% counter(s)?`nOnce reset, there is no way to undo it!
        
        IfMsgBox, No
            Return
    }
    
    Critical, On
    
    /*
    If (InStr(_Which, "\"))
    {
        FFullPaths := SubStr(_Which, 1, InStr(_Which, "\", False, 0) - 1)
        , FName := SubStr(_Which, InStr(_Which, "\", False, 0)+1)
        
        If (InStr(FName, "Mouse pixel") Or InStr(FName, "Mouse Movement"))
            _Which := "Mouse pixel movement"
        Else If (InStr(FName, "Keyboard"))
            _Which := "Keyboard -- All"
        Else If (InStr(FName, "Words"))
            _Which := "Words per ?"
        Else If (InStr(FName, "Mouse"))
            _Which := "Mouse -- All"
        Else If (InStr(FName, "Bytes"))
            _Which := "Bytes read/written"
        Else If (InStr(FName, "Key "))
            _Which := SubStr(FName, InStr(FName, " ")+1) ;Key ID
        Else
            Return -1
    }
    */
    
    If (_RootFolder = "All")
    {
        Computers := Get_ComputerDataFolderNames()
        
        Loop, Parse, Computers, |
        {
            FFullPaths .= FFullPaths = "" ? "" : "`n"
            FFullPaths .= RootDirectory "\" A_LoopField
        }
    } Else
        FFullPaths := _RootFolder
    
    
    If (Save_DataMethod = 1)
    {
        Save_AllData(1)
    } Else If (Save_DataMethod = 2 And _Which != "Mouse Movement")
    {
        Close_FileHandles()
    }
    
    ReturnVal := 0
    
    Loop, Parse, FFullPaths, `n
    {
        FFullPath := A_LoopField
        
        If (_Which = "Mouse Buttons")
        {
            FDirectory := FFullPath "\Keys"
            
            TempNumber := Range13_Lower
            
            Loop, % Range13_Used
            {
                If (ELP_FileExists(FDirectory "\Key " TempNumber, 1, 0, 0)){
                    If (ELP_FileDelete(FDirectory "\Key " TempNumber, 1, 0))
                        ReturnVal --
                }

                If (ELP_FileExists(FDirectory "\Indexes\Key " TempNumber ".index", 1, 0))
                {
                    If (ELP_FileDelete(FDirectory "\Indexes\Key " TempNumber ".index", 1, 0))
                        ReturnVal --
                }
                
                TempNumber ++
            }
        } Else If (_Which = "Keyboard Keys")
        {
            FDirectory := FFullPath "\Keys"
            
            L := 2
            
            Loop, 11
            {
                TempNumber := Range%L%_Lower
                
                Loop, % Range%L%_Used
                {
                    If (ELP_FileExists(FDirectory "\Key " TempNumber, 1, 0, 0))
                    {
                        If (ELP_FileDelete(FDirectory "\Key " TempNumber, 1, 0))
                            ReturnVal --
                    }
                    
                    If (ELP_FileExists(FDirectory "\Indexes\Key " TempNumber ".index", 1, 0))
                    {
                        If (ELP_FileDelete(FDirectory "\Indexes\Key " TempNumber ".index", 1, 0))
                            ReturnVal --
                    }
                    
                    TempNumber ++
                }
                
                L ++
            }
        } Else If (_Which = "Mouse Movement")
        {
            FDirectory := FFullPath "\Mouse Movement"
            
            If (ELP_FileExists(FDirectory "\Mouse movement data", 1, 0, 0))
            {
                If (ELP_FileDelete(FDirectory "\Mouse movement data", 1, 0))
                    ReturnVal --
            }
            
            If (ELP_FileExists(FDirectory "\Mouse movement data\Index", 1, 0, 0))
            {
                If (ELP_FileRemoveDirectory(FDirectory "\Mouse movement data\Index", 1))
                    ReturnVal --
            }
            
            VarSetCapacity(MouseMovementData, MMD_Max, 0)
            , MovementDataVarOffset := 0
            , VarSetCapacity(Pixel_Cache, Pixel_CacheMaxSize, 0)
            , Pixel_CacheOffset := 0
        } Else If (_Which = "Word Data")
        {
            FDirectory := FFullPath "\Word Speed"
            
            If (ELP_FileExists(FDirectory "\Words per time data", 1, 0, 0))
            {
                If (ELP_FileDelete(FDirectory "\Words per time data", 1, 0))
                    ReturnVal --
            }
            
            If (ELP_FileExists(FDirectory "\Indexes", 1, 0, 0))
            {
                If (ELP_FileRemoveDirectory(FDirectory "\Indexes", 1))
                    ReturnVal --
            }
        } Else If (_Which = "HD Activity")
        {
            FDirectory := FFullPath
            
            If (ELP_FileExists(FDirectory "\HD activity", 1, 0, 0)){
                If (ELP_FileDelete(FDirectory "\HD activity", 1, 0))
                    ReturnVal --
            }
            
            ELP_StoreBytes("ResetRead")
            , ELP_StoreBytes("ResetWrite")
            , TodaysBytesRead := 0
            , TodaysBytesWritten := 0
            , TotalBytesRead := 0
            , TotalBytesWritten := 0
        }
    }
    
    If (_UpdateCounters)
    {
        UpdateCounts()
        , UpdateToolTip()
    }
    
    If (Save_DataMethod = 2 And _Which != "Mouse Movement")
        Open_FileHandlesWrite()
    
    Critical, Off
    
    Return ReturnVal
}

About()
{
    Global
    Local About
    
    About =
    (Ltrim Join`n
        About %Name%
        Version: %VersionNumber%
        
        Records information about mouse and keyboard use to provide
        statistics and information about mouse and keyboard use.
        
        The Other settings Menu Controls Autocompletion functionality.
        Working to port statistics to the SQLite DB, integrating with the 
        Autocompletion/Word Frequency Information.
        
        More information can be found at:
        https://www.github.com/donovanzeanah/globalcoder
    )
    
    MsgBox %About%
}

Open_FileHandlesWrite(Which = "All")
{
    Global
    Local I, L
    
    Critical, On
    
    If (Which = "All" or Which = "Words per time")
    {
        If (!WPT_Handle)
        {
            WPT_Handle := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Write", WPT_Pointer)
            , ELP_SetFilePointer(WPT_Handle, WPT_Pointer)
        }
    }
    
    
    If (Which = "All" Or Which = "Keyboard"){
        L := 2
        
        Loop, 11
        {
            I := Range%L%_Lower
            
            Loop, % Range%L%_Used
            {
                If (!KH%I%){
                    KH%I% := ELP_OpenFileHandle(KeyDirectory "\Key " I, "Write", KFP%I%)
                    , ELP_SetFilePointer(KH%I%, KFP%I%)
                }
                
                I ++
            }
            
            L ++
        }
    }
    
    If (Which = "All" Or Which = "Mouse"){
        I := Range13_Lower
        
        Loop, % Range13_Used
        {
            If (!KH%I%){
                KH%I% := ELP_OpenFileHandle(KeyDirectory "\Key " I, "Write", KFP%I%)
                , ELP_SetFilePointer(KH%I%, KFP%I%)
            }
            
            I ++
        }
    }
    
    Critical, Off
}

Close_FileHandles(Which = "All")
{
    Global
    Local I, L
    
    Critical, On
    
    If (Which = "All" or Which = "Words per time"){
        If (WPT_Handle){
            ELP_CloseFileHandle(WPT_Handle)
            
            If (WPT_Pointer = 0)
                ELP_FileDelete(WordDirectory "\Words per time data", 1, 0)
            
            WPT_Handle := WPT_Pointer := ""
        }
    }
    
    If (Which = "All" Or Which = "Keyboard"){
        L := 2
        
        Loop, 11
        {
            I := Range%L%_Lower
            
            Loop, % Range%L%_Used
            {
                If (KH%I%){
                    ELP_CloseFileHandle(KH%I%)
                    
                    If (KFP%I% = 0)
                        ELP_FileDelete(KeyDirectory "\Key " I, 1, 0)
                    
                    KH%I% := KFP%I% := ""
                }
                
                I ++
            }
            
            L ++
        }
    }
    
    If (Which = "All" Or Which = "Mouse"){
        I := Range13_Lower
        
        Loop, % Range13_Used
        {
            If (KH%I%){
                ELP_CloseFileHandle(KH%I%)
                
                If (KFP%I% = 0)
                    ELP_FileDelete(KeyDirectory "\Key " I, 1, 0)
                
                KH%I% := KFP%I% := ""
            }
            
            I ++
        }
    }
    
    Critical, Off
}

Switch_SaveMethod(Method)
{
    Global
    Local I, L
    
    Critical, On
        
    If (Method = 2){
        If (Save_DataMethod = 2)
            Return
        
        Save_AllData(1)
        , VarSetCapacity(WPTData, WPT_Max, 0)
        , VarSetCapacity(WPTData, 0)
        , WPTOffset := ""
        , Open_FileHandlesWrite()
        
        , I := Range0_Lower + 1 ;Skip range 1
        
        Loop, % Range0_Used - 1 ;Skip range 1
        {
            L := Range%I%_Lower
            
            Loop, % Range%I%_Used
            {
                VarSetCapacity(K%L%, Bytes_PerHotKey, 0)
                , VarSetCapacity(K%L%, 0)
                , K%L%_Count := K%L%_MaxCount := ""
                , L ++
            }
            
            I ++
        }
    } Else If (Method = 1){ ;Save method 1 will auto-allocate RAM as keys are pressed
        If (Save_DataMethod = 1)
            Return
        
        Close_FileHandles()
        , VarSetCapacity(WPTData, WPT_Max, 0)
        , WPTOffset := 0
    }
    
    Save_DataMethod := Method
    
    Critical, Off
}

AutoStart(Check = 0)
{
    Global Ptr
    Static Shortcut_Name := "M&K Counter 2.0"
    
    VarSetCapacity(StartupFolder, 65*1024, 0)
    , DllCall(A_IsUnicode ? "Shell32.dll\SHGetFolderPathW" : "Shell32.dll\SHGetFolderPathA", "UInt", 0, "Int", 7, "UInt", 0, "UInt", 0, Ptr, &StartupFolder)
    , VarSetCapacity(StartupFolder, -1)
    , Shortcut_Path := StartupFolder . "\" . Shortcut_Name . ".lnk"
    
    If (ELP_FileExists(Shortcut_Path, 1, 0, 0)){
        H := ELP_OpenFileHandle(Shortcut_Path, "Read", FileSize)
        , VarSetCapacity(BinaryData, FileSize, 0)
        , ELP_ReadData(H, &BinaryData, FileSize)
        , ELP_CloseFileHandle(H)
        
        VarSetCapacity(ASCIIShortcut, FileSize)
        
        Loop, % FileSize
            ASCIIShortcut .= Chr(NumGet(BinaryData, A_Index - 1, "Char"))
        
        VarSetCapacity(BinaryData, FileSize, 0)
        , VarSetCapacity(BinaryData, 0)
        
        If (InStr(ASCIIShortcut, A_ScriptFullPath))
            Shortcut_Exists := True
    }
    
    If (Check)
        Return Shortcut_Exists
    
    If (ELP_FileExists(Shortcut_Path, 1, 0, 0)){
        If (Shortcut_Exists)
            ELP_FileDelete(Shortcut_Path, 1, 0)
        Else {
            ELP_FileDelete(Shortcut_Path, 1, 0)
            FileCreateShortcut, %A_ScriptFullPath%, %Shortcut_Path%, %A_WorkingDir%,, %Shortcut_Name%, %A_ScriptFullPath%, m
        }
    } Else
        FileCreateShortcut, %A_ScriptFullPath%, %Shortcut_Path%, %A_WorkingDir%,, %Shortcut_Name%, %A_ScriptFullPath%, m
}

Change_CaptureAccuracy(ChangeTo)
{
    Global
    
    Capture_Accuracy := ChangeTo
    
    Menu, AccuracySubMenu, UnCheck, Minutes
    Menu, AccuracySubMenu, UnCheck, Seconds
    Menu, AccuracySubMenu, UnCheck, Milliseconds
    
    If (Capture_Accuracy = 1)
        Menu, AccuracySubMenu, Check, Minutes
    Else If (Capture_Accuracy = 2)
        Menu, AccuracySubMenu, Check, Seconds
    Else If (Capture_Accuracy = 3)
        Menu, AccuracySubMenu, Check, Milliseconds
}


Get_RandomResetName(_FolderRoot, _PartName)
{
    If (ELP_FileExists(_FolderRoot, 2) And SubStr(_FolderRoot, 0) != "\")
        _FolderRoot .= "\"
    
    Loop
    {
        Temp_Name := SubStr(_FolderRoot, 1, InStr(_FolderRoot, "\", False, 0)-1) "\" A_Now _PartName
        
        If (!ELP_FileExists(Temp_Name, 1, 0, 0))
            Break
        
        Sleep, 100
    }
    
    Return Temp_Name
}


SavePixelData(_Override = False)
{
    Global MouseMovementData, MovementDataVarOffset
    , RootDirectory, MouseMovementDirectory
    , Pixel_CacheOffset, Pixel_FileVersion, MMD_Max
    
    ELP_FileCreateDirectory(MouseMovementDirectory)
    
    If (!MovementDataVarOffset){
        If (!_Override)
            Return
        
        If (_Override And !Pixel_CacheOffset)
            Return
    }
    
    Critical, On
    
    H := ELP_OpenFileHandle(MouseMovementDirectory "\Mouse movement data", "Write", Offset)
    
    If (Offset = 0){
        VarSetCapacity(Number, 8, 0)
        , NumPut(Pixel_FileVersion, Number, 0, "Double")
        , ELP_WriteData(H, &Number, 8)
        , Offset := 8
    }
    
    ELP_SetFilePointer(H, Offset)
    , ELP_WriteData(H, &MouseMovementData, MovementDataVarOffset)
    , Offset += MovementDataVarOffset
    , VarSetCapacity(MouseMovementData, MMD_Max, 0)
    , MovementDataVarOffset := 0
    
    
    If (_Override And Pixel_CacheOffset){
        Compile_PixelCache()
        , ELP_SetFilePointer(H, Offset)
        , ELP_WriteData(H, &MouseMovementData, MovementDataVarOffset)
        , VarSetCapacity(MouseMovementData, MMD_Max, 0)
        , MovementDataVarOffset := 0
    }
    
    ELP_CloseFileHandle(H)
    
    Critical, Off
}

Save_Settings(SetStatics = 0, Override = 0)
{
    Global
    
    Static Last_SaveMethod, SaveNames := "Capture_Accuracy|MB_RamUse|Save_DataMethod|AutoSave_Interval|CountMouse|CountKeyboard|CountPixelsMoved|ScreenSizes|AutoSave_State|CountWPT|Show_CountsInConvertedUnits|Show_TodaysCount|CountHDActivity|Show_AllComputers"
    , Previous_Capture_Accuracy, Previous_MB_RamUse, Previous_Save_DataMethod, Previous_AutoSave_Interval, Previous_CountMouse, Previous_CountKeyboard
    , Previous_CountPixelsMoved, Previous_ScreenSizes, Previous_AutoSave_State, Previous_CountWPT, Previous_Show_CountsInConvertedUnits, Previous_Show_TodaysCount
    , Previous_CountHDActivity, Previous_Show_AllComputers
    
    Local TA_LoopField, BinaryFile, Offset, Write, H
    
    If (SetStatics){
        Loop, Parse, SaveNames, |
            Previous_%A_LoopField% := %A_LoopField%
        Last_SaveMethod := Save_SettingsMethod
        
        Return
    }
    
    If (Save_SettingsMethod != Last_SaveMethod){
        DeleteSettingsFiles()
        , Last_SaveMethod := Save_SettingsMethod
    }
    
    If (Save_SettingsMethod = 1){ ;Registry
        Loop, Parse, SaveNames, |
        {
            TA_LoopField := %A_LoopField%
            If (Previous_%A_LoopField% != TA_LoopField or Override){
                RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\M&K Counter 2.0, %A_LoopField%, %TA_LoopField%
                
                Previous_%A_LoopField% := TA_LoopField
                , Write := True
            }
        }
        
        If (Write)
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\M&K Counter 2.0, Save_SettingsMethod, 1
    } Else If (Save_SettingsMethod = 2){ ;Options file
        Loop, Parse, SaveNames, |
        {
            TA_LoopField := %A_LoopField%
            If (Previous_%A_LoopField% != TA_LoopField or Override){
                Previous_%A_LoopField% := TA_LoopField
                , Write := True
                
                Break
            }
        }
        
        If (Write or Override){
            /*
            8 - version
            1 - Capture_Accuracy
            1 - MB_RamUse
            1 - Save_DataMethod
            1 - CountMouse
            1 - CountKeyboard
            1 - CountPixelsMoved
            1 - AutoSave_State
            1 - CountWPT
            1 - Show_CountsInConvertedUnits
            1 - Show_TodaysCount
            1 - CountHDActivity
            8 - AutoSave_Interval
            8 - number of screen entries
            *repeating number above*
            8 - screen entry
            */
            
            VarSetCapacity(BinaryFile, 1 * 1024 * 1024, 0)
            , Offset := 0
            , NumPut(Save_FileVersion, BinaryFile, Offset, "Double")
            , Offset += 8
            , NumPut(Capture_Accuracy, BinaryFile, Offset++, "UChar")
            , NumPut(MB_RamUse, BinaryFile, Offset++, "UChar")
            , NumPut(Save_DataMethod, BinaryFile, Offset++, "UChar")
            , NumPut(CountMouse, BinaryFile, Offset++, "UChar")
            , NumPut(CountKeyboard, BinaryFile, Offset++, "UChar")
            , NumPut(CountPixelsMoved, BinaryFile, Offset++, "UChar")
            , NumPut(AutoSave_State, BinaryFile, Offset++, "UChar")
            , NumPut(CountWPT, BinaryFile, Offset++, "UChar")
            , NumPut(Show_CountsInConvertedUnits, BinaryFile, Offset++, "UChar")
            , NumPut(Show_TodaysCount, BinaryFile, Offset++, "UChar")
            , NumPut(CountHDActivity, BinaryFile, Offset++, "UChar")
            , NumPut(Show_AllComputers, BinaryFile, Offset++, "UChar")
            
            , NumPut(AutoSave_Interval, BinaryFile, Offset, "Int64"), Offset += 8
            
            StringReplace, ScreenSizes, ScreenSizes, |, |, UseErrorLevel
            
            NumPut(ErrorLevel + 1, BinaryFile, Offset, "Int64"), Offset += 8
            
            Loop, Parse, ScreenSizes, |
                NumPut(A_LoopField, BinaryFile, Offset, "Double"), Offset += 8
            
            If (ELP_FileExists(SaveDirectory "\Binary.Options", 1, 0, 0)){
                If (ELP_FileDelete(SaveDirectory "\Binary.Options", 1, 0)){
                    VarSetCapacity(BinaryFile, 1 * 1024 * 1024, 0)
                    , VarSetCapacity(BinaryFile, 0)
                    
                    Return -1
                }
            }
            
            H := ELP_OpenFileHandle(SaveDirectory "\Binary.Options", "Write")
            , ELP_WriteData(H, &BinaryFile, Offset)
            , ELP_CloseFileHandle(H)
            , VarSetCapacity(BinaryFile, 1 * 1024 * 1024, 0)
            , VarSetCapacity(BinaryFile, 0)
        }
    }
}

Load_Settings()
{
    Global
    Static LoadNames := "Capture_Accuracy|MB_RamUse|Save_DataMethod|AutoSave_Interval|CountMouse|CountKeyboard|CountPixelsMoved|ScreenSizes|AutoSave_State|CountWPT|Show_CountsInConvertedUnits|Show_TodaysCount|CountHDActivity|Show_AllComputers"
    Local SaveMethodCheck, FileSize, SettingsData, H, TName, NameLength, DataLength, Offset, SettingsFileVersion, IsCompatible, I
    
    RegRead, SaveMethodCheck, HKEY_CURRENT_USER, Software\M&K Counter 2.0, Save_SettingsMethod
    
    If (SaveMethodCheck = 1 and !ErrorLevel)
    { ;registry
        Loop, Parse, LoadNames, |
            RegRead, %A_LoopField%, HKEY_CURRENT_USER, Software\M&K Counter 2.0, %A_LoopField%
        
        Save_SettingsMethod := 1
        
        Return 1
    } Else { ;Options file
        If (ELP_FileExists(RootDirectory "\Binary.Options", 1, 0, 0))
            ELP_FileMove(RootDirectory "\Binary.Options", SaveDirectory "\Binary.Options", 0, 0, 0)
        
        H := ELP_OpenFileHandle(SaveDirectory "\Binary.Options", "Read", FileSize)
        If (FileSize = 0){
            ELP_CloseFileHandle(H)
            
            Return
        }
        
        VarSetCapacity(SettingsData, FileSize, 0)
        , ELP_ReadData(H, &SettingsData, FileSize)
        , ELP_CloseFileHandle(H)
        , Offset := 0
        , SettingsFileVersion := NumGet(SettingsData, Offset, "Double")
        , Offset += 8
        
        If (SettingsFileVersion = Save_FileVersion){
            /*
            8 - version
            1 - Capture_Accuracy
            1 - MB_RamUse
            1 - Save_DataMethod
            1 - CountMouse
            1 - CountKeyboard
            1 - CountPixelsMoved
            1 - AutoSave_State
            1 - CountWPT
            1 - Show_CountsInConvertedUnits
            1 - Show_TodaysCount
            1 - CountHDActivity
            1 - Show_AllComputers
            8 - AutoSave_Interval
            8 - number of screen entries
            *repeating number above*
            8 - screen entry
            */
            
            Capture_Accuracy := NumGet(SettingsData, Offset++, "UChar")
            , MB_RamUse := NumGet(SettingsData, Offset++, "UChar")
            , Save_DataMethod := NumGet(SettingsData, Offset++, "UChar")
            , CountMouse := NumGet(SettingsData, Offset++, "UChar")
            , CountKeyboard := NumGet(SettingsData, Offset++, "UChar")
            , CountPixelsMoved := NumGet(SettingsData, Offset++, "UChar")
            , AutoSave_State := NumGet(SettingsData, Offset++, "UChar")
            , CountWPT := NumGet(SettingsData, Offset++, "UChar")
            , Show_CountsInConvertedUnits := NumGet(SettingsData, Offset++, "UChar")
            , Show_TodaysCount := NumGet(SettingsData, Offset++, "UChar")
            , CountHDActivity := NumGet(SettingsData, Offset++, "UChar")
            , Show_AllComputers := NumGet(SettingsData, Offset++, "UChar")
            , AutoSave_Interval := NumGet(SettingsData, Offset, "Int64"), Offset += 8
            
            , I := NumGet(SettingsData, Offset, "Int64"), Offset += 8
            
            , ScreenSizes := ""
            
            If (((I * 8) + Offset) > FileSize){ ;Prevents runaway looping from a bad file
                TrayTip, Error, Error loading saved settings (corrupt save file)
                
                ELP_FileDelete(SaveDirectory "\Binary.Options", 1, 0)
            } Else {
                Loop, % I
                {
                    MonSize := NumGet(SettingsData, Offset, "Double")
                    
                    While (SubStr(MonSize, 0, 1) = 0)
                        MonSize := SubStr(MonSize, 1, StrLen(MonSize) - 1)
                    
                    If (SubStr(MonSize, 0, 1) = ".")
                        MonSize := SubStr(MonSize, 1, StrLen(MonSize) - 1)
                    
                    ScreenSizes .= ScreenSizes != "" ? "|" MonSize : MonSize
                    , Offset += 8
                }
            }
            
            Save_SettingsMethod := 2
        } Else If (SettingsFileVersion = 1.1){
            /*
            8 - version
            1 - Capture_Accuracy
            1 - MB_RamUse
            1 - Save_DataMethod
            1 - CountMouse
            1 - CountKeyboard
            1 - CountPixelsMoved
            1 - AutoSave_State
            1 - CountWPT
            1 - Show_CountsInConvertedUnits
            1 - Show_TodaysCount
            8 - AutoSave_Interval
            8 - number of screen entries
            *repeating number above*
            8 - screen entry
            */
            
            Capture_Accuracy := NumGet(SettingsData, Offset++, "UChar")
            , MB_RamUse := NumGet(SettingsData, Offset++, "UChar")
            , Save_DataMethod := NumGet(SettingsData, Offset++, "UChar")
            , CountMouse := NumGet(SettingsData, Offset++, "UChar")
            , CountKeyboard := NumGet(SettingsData, Offset++, "UChar")
            , CountPixelsMoved := NumGet(SettingsData, Offset++, "UChar")
            , AutoSave_State := NumGet(SettingsData, Offset++, "UChar")
            , CountWPT := NumGet(SettingsData, Offset++, "UChar")
            , Show_CountsInConvertedUnits := NumGet(SettingsData, Offset++, "UChar")
            , Show_TodaysCount := NumGet(SettingsData, Offset++, "UChar")
            , AutoSave_Interval := NumGet(SettingsData, Offset, "Int64"), Offset += 8
            
            , I := NumGet(SettingsData, Offset, "Int64"), Offset += 8
            
            , ScreenSizes := ""
            
            If (((I * 8) + Offset) > FileSize){ ;Prevents runaway looping from a bad file
                TrayTip, Error, Error loading saved settings (corrupt save file)
                
                ELP_FileDelete(SaveDirectory "\Binary.Options", 1, 0)
            } Else {
                Loop, % I
                {
                    MonSize := NumGet(SettingsData, Offset, "Double")
                    
                    While (SubStr(MonSize, 0, 1) = 0)
                        MonSize := SubStr(MonSize, 1, StrLen(MonSize) - 1)
                    
                    If (SubStr(MonSize, 0, 1) = ".")
                        MonSize := SubStr(MonSize, 1, StrLen(MonSize) - 1)
                    
                    ScreenSizes .= ScreenSizes != "" ? "|" MonSize : MonSize
                    , Offset += 8
                }
            }
            
            Save_SettingsMethod := 2
        } Else If (SettingsFileVersion = 1.0){
            Loop
            {
                If (Offset >= FileSize)
                    Break
                
                NameLength := NumGet(SettingsData, Offset, "Int64")
                , Offset += 8
                , TName := ""
                
                Loop, % NameLength
                    TName .= Chr(NumGet(SettingsData, Offset++, "Char"))
                %TName% := ""
                
                DataLength := NumGet(SettingsData, Offset, "Int64")
                , Offset += 8
                
                Loop, % DataLength
                    %TName% .= Chr(NumGet(SettingsData, Offset++, "Char"))
            }
            
            Save_Settings(0, 1)
            , Save_SettingsMethod := 2
        } Else {
            TrayTip, Error, Error loading saved settings (incompatible save file version)
            
            ELP_FileDelete(SaveDirectory "\Binary.Options", 1, 0)
        }
        
        VarSetCapacity(SettingsData, FileSize, 0)
        , VarSetCapacity(SettingsData, 0)
        
        Return 1
    }
}

DeleteSettingsFiles()
{
    Global SaveDirectory
    
    RegDelete, HKEY_CURRENT_USER, Software\M&K Counter 2.0
    ELP_FileDelete(SaveDirectory "\Binary.Options", 1, 0)
}

Get_RamUse(_Cmd = "")
{
    Global MB_RamUse
    Static New_MB_RamUse, Old_MB_RamUse, IsShowing := 0
    , N := 2
    
    GuiWidth := 320
    
    If (_Cmd = "Calculate"){
        Gui, %N%:Submit
        Gui, %N%:Destroy
        IsShowing := False
        
        MB_RamUse := New_MB_RamUse
        
        If MB_RamUse Is Not Number
            MB_RamUse := Old_MB_RamUse
        Else If ((MB_RamUse - 5) < 1)
            MB_RamUse := 6
        Else If (MB_RamUse > 255)
            MB_RamUse := 255
        
        If (MB_RamUse != Old_MB_RamUse){
            Recalculate_RamUse()
            , Build_TrayMenu(1)
            , Save_Settings()
        }
        
        Return
    } Else If (_Cmd = "Destroy"){
        Gui, %N%:Destroy
        
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := 1
    
    Old_MB_RamUse := MB_RamUse
    
    Gui, %N%:Font, S10
    Gui, %N%:+LabelRamUse
    Gui, %N%:Add, Text, Center x5 w%GuiWidth%, Please select how much RAM (in megabytes) to use.`n`nMore RAM (while autosave is disabled and the save method is set to buffer) means less hard drive access.
    Gui, %N%:Add, Edit, w%GuiWidth% vNew_MB_RamUse, %MB_RamUse%
    Gui, %N%:Add, UpDown, Range6-255, %MB_RamUse%
    Gui, %N%:Add, Button, w%GuiWidth% gRamUseOk Default, Ok
    
    GuiWidth += 10
    Gui, %N%:Show, w%GuiWidth%, Enter RAM to use
}

Recalculate_RamUse()
{
    Global
    Local I, L
    
    Critical, On
    
    Bytes_PerHotKey := ((MB_RamUse - 5) * 1024 * 1024) // Count_HotKeys()
    , Max_HotKeyCount := Bytes_PerHotKey // 8
    , Bytes_PerHotKey := Max_HotKeyCount * 8
    
    ;Flushes all data to the hard drive
    ;This will blank and reset any buffers that are in use using the new Bytes_PerHotKey value
    If (Save_DataMethod = 1)
        Save_AllData(1)
    
    Critical, Off
}

Get_AutosaveInterval(_Cmd = "")
{
    Global Autosave_Interval
    Static New_Autosave_Interval, Old_Autosave_Interval, IsShowing := 0, TimeUnits
    , N := 3
    
    GuiWidth := 280
    
    If (_Cmd = "Calculate"){
        Gui, %N%:Submit
        Gui, %N%:Destroy
        
        IsShowing := False
        , Autosave_Interval := New_Autosave_Interval
        
        If Autosave_Interval Is Not Number
            Autosave_Interval := Old_Autosave_Interval
        
        If (TimeUnits = "Days")
            Autosave_Interval := Autosave_Interval * 24 * 60 * 60
        Else If (TimeUnits = "Hours")
            Autosave_Interval := Autosave_Interval * 60 * 60
        Else If (TimeUnits = "Minutes")
            Autosave_Interval := Autosave_Interval * 60
        
        If (Autosave_Interval != Old_Autosave_Interval){
            If (Autosave_State)
                SetTimer, Autosave, % Autosave_Interval * 1000
            
            Build_TrayMenu(1)
            , Save_Settings()
        }
        
        Return
    } Else If (_Cmd = "Destroy"){
        Gui, %N%:Destroy
        
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := 1
    , Old_Autosave_Interval := Autosave_Interval
    
    Gui, %N%:Font, S10
    Gui, %N%:+LabelAutosaveInterval
    Gui, %N%:Add, Text, Center x5 w%GuiWidth%, Please enter a autosave interval.`nThe time between autosaves (if enabled)
    TGuiWidth := GuiWidth - 100
    Gui, %N%:Add, Edit, h23 w%TGuiWidth% vNew_Autosave_Interval, % Autosave_Interval
    Gui, %N%:Add, UpDown, Range1-106751991167300, % Autosave_Interval
    Gui, %N%:Add, DropdownList, x190 y45 w94 vTimeUnits, Days|Hours|Minutes|Seconds||
    Gui, %N%:Add, Button, x5 y77 w%GuiWidth% gAutosaveIntervalOk Default, Ok
    
    GuiWidth += 10
    Gui, %N%:Show, w%GuiWidth%, Enter Autosave interval
}

Save_WPTData()
{
    Global
    Local FileSize, H
    
    If (Save_DataMethod = 2)
        Return
    
    ELP_FileCreateDirectory(WordDirectory)
    
    If (WPTOffset){
        H := ELP_OpenFileHandle(WordDirectory "\Words per time data", "Write", FileSize)
        , ELP_SetFilePointer(H, FileSize)
        , ELP_WriteData(H, &WPTData, WPTOffset)
        , ELP_CloseFileHandle(H)
        
        , VarSetCapacity(WPTData, 0)
        , VarSetCapacity(WPTData, WPT_Max, 0)
        , WPTOffset := 0
    }
}

Convert_Unit(_Unit)
{
    If (_Unit >= 1000000 And _Unit <= 999999999)
        _Unit := Round(_Unit / 1000000, 2) " M"
    Else If (_Unit >= 1000000000 And _Unit <= 999999999999)
        _Unit := Round(_Unit / 1000000000, 2) " B"
    Else If (_Unit >= 1000000000000)
        _Unit := Round(_Unit / 1000000000000, 2) " T"
    
    Return _Unit
}

Convert_KeyFile(_K, _CountErrors = 0, _ReturnID = 0)
{
    Global
    Local To, Root
    
    If _K Is Not Number
    {
        Root := _K
        , _K := SubStr(_K, InStr(_K, A_Space, False, InStr(_K, "\", False, 0))+1)
        Root := SubStr(Root, 1, StrLen(Root) - StrLen(_K))
    }
    
    ;Converts ID 1-26
    Loop, 26
    {
        If (_K = A_Index)
        {
            To := Range2_Lower + (A_Index - 1)
        }
    }
    
    ;I := 1
    ;, Temp_RangeID := Range2_Lower
    
    ;Loop, 26
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 27-52
    Loop, % (52 - 27) + 1
    {
        If (_K = ((A_Index - 1) + 27))
        {
            To := Range3_Lower + (A_Index - 1)
        }
    }
    
    ;I := 27
    ;, Temp_RangeID := Range3_Lower
    
    ;Loop, 26
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 53-62
    Loop, % (62 - 53) + 1
    {
        If (_K = ((A_Index - 1) + 53))
        {
            To := Range4_Lower + (A_Index - 1)
        }
    }
    
    ;I := 53
    ;, Temp_RangeID := Range4_Lower
    
    ;Loop, 10
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 63-72
    If (_K = 63){
        To := 200012
    } Else If (_K = 64){
        To := 200003
    } Else If (_K = 65){
        To := 200004
    } Else If (_K = 66){
        To := 200005
    } Else If (_K = 67){
        To := 200006
    } Else If (_K = 68){
        To := 200007
    } Else If (_K = 69){
        To := 200008
    } Else If (_K = 70){
        To := 200009
    } Else If (_K = 71){
        To := 200010
    } Else If (_K = 72){
        To := 200011
    }
    
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 63, KeyDirectory "\Key " 200012, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 64, KeyDirectory "\Key " 200003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 65, KeyDirectory "\Key " 200004, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 66, KeyDirectory "\Key " 200005, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 67, KeyDirectory "\Key " 200006, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 68, KeyDirectory "\Key " 200007, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 69, KeyDirectory "\Key " 200008, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 70, KeyDirectory "\Key " 200009, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 71, KeyDirectory "\Key " 200010, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 72, KeyDirectory "\Key " 200011, 0, 0, 0)
    
    ;Converts ID 73-96
    Loop, % (96 - 73) + 1
    {
        If (_K = ((A_Index - 1) + 73))
        {
            To := Range6_Lower + (A_Index - 1)
        }
    }
    
    ;I := 73
    ;, Temp_RangeID := Range6_Lower
    
    ;Loop, 24
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 97-121
    If (_K = 97){
        To := 400002
    } Else If (_K = 98){
        To := 300001
    } Else If (_K = 99){
        To := 300002
    } Else If (_K = 100){
        To := 350001
    } Else If (_K = 101){
        To := 350002
    } Else If (_K = 102){
        To := 350003
    } Else If (_K = 103){
        To := 350004
    } Else If (_K = 104){
        To := 300003
    } Else If (_K = 105){
        To := 300004
    } Else If (_K = 106){
        To := 300005
    } Else If (_K = 107){
        To := 300006
    } Else If (_K = 108){
        To := 400016
    } Else If (_K = 109){
        To := 400017
    } Else If (_K = 110){
        To := 400001
    } Else If (_K = 111){
        To := 400005
    } Else If (_K = 112){
        To := 400006
    } Else If (_K = 113){
        To := 400007
    } Else If (_K = 114){
        To := 400008
    } Else If (_K = 115){
        To := 400009
    } Else If (_K = 116){
        To := 400010
    } Else If (_K = 117){
        To := 400011
    } Else If (_K = 118){
        To := 400012
    } Else If (_K = 119){
        To := 400013
    } Else If (_K = 120){
        To := 400014
    } Else If (_K = 121){
        To := 400015
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 97, KeyDirectory "\Key " 400002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 98, KeyDirectory "\Key " 300001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 99, KeyDirectory "\Key " 300002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 100, KeyDirectory "\Key " 350001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 101, KeyDirectory "\Key " 350002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 102, KeyDirectory "\Key " 350003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 103, KeyDirectory "\Key " 350004, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 104, KeyDirectory "\Key " 300003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 105, KeyDirectory "\Key " 300004, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 106, KeyDirectory "\Key " 300005, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 107, KeyDirectory "\Key " 300006, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 108, KeyDirectory "\Key " 400016, 0, 0, 0)
    ;E += ELP_FileMove(KeyDirectory "\Key " 109, KeyDirectory "\Key " 400017, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 110, KeyDirectory "\Key " 400001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 111, KeyDirectory "\Key " 400005, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 112, KeyDirectory "\Key " 400006, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 113, KeyDirectory "\Key " 400007, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 114, KeyDirectory "\Key " 400008, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 115, KeyDirectory "\Key " 400009, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 116, KeyDirectory "\Key " 400010, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 117, KeyDirectory "\Key " 400011, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 118, KeyDirectory "\Key " 400012, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 119, KeyDirectory "\Key " 400013, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 120, KeyDirectory "\Key " 400014, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 121, KeyDirectory "\Key " 400015, 0, 0, 0)
    
    ;Converts ID 122-131
    Loop, % (131 - 122) + 1
    {
        If (_K = ((A_Index - 1) + 122))
        {
            To := Range10_Lower + (A_Index - 1)
        }
    }
    
    ;I := 122
    ;, Temp_RangeID := Range10_Lower
    
    ;Loop, 10
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 132-148
    If (_K = 132){
        To := 500001
    } Else If (_K = 133){
        To := 500006
    } Else If (_K = 134){
        To := 500005
    } Else If (_K = 135){
        To := 500003
    } Else If (_K = 136){
        To := 500004
    } Else If (_K = 137){
        To := 500002
    } Else If (_K = 138){
        To := 500007
    } Else If (_K = 139){
        To := 500008
    } Else If (_K = 140){
        To := 500017
    } Else If (_K = 141){
        To := 500010
    } Else If (_K = 142){
        To := 500014
    } Else If (_K = 143){
        To := 500012
    } Else If (_K = 144){
        To := 500016
    } Else If (_K = 145){
        To := 500009
    } Else If (_K = 146){
        To := 500015
    } Else If (_K = 147){
        To := 500011
    } Else If (_K = 148){
        To := 500013
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 132, KeyDirectory "\Key " 500001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 133, KeyDirectory "\Key " 500006, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 134, KeyDirectory "\Key " 500005, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 135, KeyDirectory "\Key " 500003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 136, KeyDirectory "\Key " 500004, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 137, KeyDirectory "\Key " 500002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 138, KeyDirectory "\Key " 500007, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 139, KeyDirectory "\Key " 500008, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 140, KeyDirectory "\Key " 500017, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 141, KeyDirectory "\Key " 500010, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 142, KeyDirectory "\Key " 500014, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 143, KeyDirectory "\Key " 500012, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 144, KeyDirectory "\Key " 500016, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 145, KeyDirectory "\Key " 500009, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 146, KeyDirectory "\Key " 500015, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 147, KeyDirectory "\Key " 500011, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 148, KeyDirectory "\Key " 500013, 0, 0, 0)
    
    ;Converts ID 149-150
    If (_K = 149){
        To := 400003
    } Else If (_K = 150){
        To := 400004
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 149, KeyDirectory "\Key " 400003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 150, KeyDirectory "\Key " 400004, 0, 0, 0)
    
    ;Converts ID 151-157
    Loop, % (157 - 151) + 1
    {
        If (_K = ((A_Index - 1) + 151))
        {
            To := Range12_Lower + (A_Index - 1)
        }
    }
    
    ;I := 151
    ;, Temp_RangeID := Range12_Lower
    
    ;Loop, 7
    ;   E += ELP_FileMove(KeyDirectory "\Key " I, KeyDirectory "\Key " Temp_RangeID, 0, 0, 0)
    ;   , I ++, Temp_RangeID ++
    
    ;Converts ID 158-161
    If (_K = 158){
        To := 400018
    } Else If (_K = 159){
        To := 400019
    } Else If (_K = 160){
        To := 400020
    } Else If (_K = 161){
        To := 400021
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 158, KeyDirectory "\Key " 400018, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 159, KeyDirectory "\Key " 400019, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 160, KeyDirectory "\Key " 400020, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 161, KeyDirectory "\Key " 400021, 0, 0, 0)
    
    ;Converts ID 162-183
    If (_K = 162){
        To := 200001
    } Else If (_K = 163){
        To := 200013
    } Else If (_K = 164){
        To := 200015
    } Else If (_K = 165){
        To := 200017
    } Else If (_K = 166){
        To := 200019
    } Else If (_K = 167){
        To := 200021
    } Else If (_K = 168){
        To := 200023
    } Else If (_K = 169){
        To := 200025
    } Else If (_K = 170){
        To := 200027
    } Else If (_K = 171){
        To := 200029
    } Else If (_K = 172){
        To := 200031
    } Else If (_K = 173){
        To := 200002
    } Else If (_K = 174){
        To := 200014
    } Else If (_K = 175){
        To := 200016
    } Else If (_K = 176){
        To := 200018
    } Else If (_K = 177){
        To := 200020
    } Else If (_K = 178){
        To := 200022
    } Else If (_K = 179){
        To := 200024
    } Else If (_K = 180){
        To := 200026
    } Else If (_K = 181){
        To := 200028
    } Else If (_K = 182){
        To := 200030
    } Else If (_K = 183){
        To := 200032
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 162, KeyDirectory "\Key " 200001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 163, KeyDirectory "\Key " 200013, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 164, KeyDirectory "\Key " 200015, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 165, KeyDirectory "\Key " 200017, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 166, KeyDirectory "\Key " 200019, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 167, KeyDirectory "\Key " 200021, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 168, KeyDirectory "\Key " 200023, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 169, KeyDirectory "\Key " 200025, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 170, KeyDirectory "\Key " 200027, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 171, KeyDirectory "\Key " 200029, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 172, KeyDirectory "\Key " 200031, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 173, KeyDirectory "\Key " 200002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 174, KeyDirectory "\Key " 200014, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 175, KeyDirectory "\Key " 200016, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 176, KeyDirectory "\Key " 200018, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 177, KeyDirectory "\Key " 200020, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 178, KeyDirectory "\Key " 200022, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 179, KeyDirectory "\Key " 200024, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 180, KeyDirectory "\Key " 200026, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 181, KeyDirectory "\Key " 200028, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 182, KeyDirectory "\Key " 200030, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 183, KeyDirectory "\Key " 200032, 0, 0, 0)
    
    ;Converts ID 184-188
    If (_K = 184){
        To := 600001
    } Else If (_K = 185){
        To := 600002
    } Else If (_K = 186){
        To := 600003
    } Else If (_K = 187){
        To := 600006
    } Else If (_K = 188){
        To := 600007
    }
    
    ;E += ELP_FileMove(KeyDirectory "\Key " 184, KeyDirectory "\Key " 600001, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 185, KeyDirectory "\Key " 600002, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 186, KeyDirectory "\Key " 600003, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 187, KeyDirectory "\Key " 600006, 0, 0, 0)
    ;, E += ELP_FileMove(KeyDirectory "\Key " 188, KeyDirectory "\Key " 600007, 0, 0, 0)
    
    If (To)
    {
        If (_ReturnID)
            Return To
        
        E := ELP_FileMove(Root _K, Root To, 0, 0, 0)
    } Else
        E := -1.5
    
    If (_CountErrors)
        Return E
}

Write_HDActivity()
{
    Global SaveDirectory, CountHDActivity, HD_FileVersion, Capture_Accuracy
    
    If (!CountHDActivity)
        Return
    
    If (!ELP_StoreBytes("GetRead") And !ELP_StoreBytes("GetWrite"))
        Return
    
    ;Disables counting while this function runs
    ELP_MasterSettings("Set", "Count_BytesWritten", False)
    , ELP_MasterSettings("Set", "Count_BytesRead", False)
    
    , H := ELP_OpenFileHandle(SaveDirectory "\HD activity", "Write", FileSize)
    
    If (FileSize = 0){
        VarSetCapacity(FileVersion, 8, 0)
        , NumPut(HD_FileVersion, FileVersion, 0, "Double")
        , ELP_WriteData(H, &FileVersion, 8)
        , ELP_StoreBytes("AddWrite", 8)
        , FileSize += 8
    }
    
    ELP_SetFilePointer(H, FileSize)
    
    , VarSetCapacity(HDData, 24, 0)
    , ELP_StoreBytes("AddWrite", 24)
    
    If (Capture_Accuracy = 1) ;Minutes
        Now := A_YYYY . A_MM . A_DD . A_Hour . A_Min . 00000
    Else If (Capture_Accuracy = 3) ;Milliseconds
        Now := A_Now . A_MSec
    Else If (Capture_Accuracy = 2) ;Seconds
        Now := A_Now . 000
    
    NumPut(Now, HDData, 0, "Int64")
    , TBytesRead := ELP_StoreBytes("GetRead")
    , TBytesWritten := ELP_StoreBytes("GetWrite")
    , NumPut(TBytesRead, HDData, 8, "Int64")
    , NumPut(TBytesWritten, HDData, 16, "Int64")
    
    , ELP_WriteData(H, &HDData, 24)
    , ELP_CloseFileHandle(H)
    
    , TodaysBytesRead += TBytesRead
    , TodaysBytesWritten += TBytesWritten
    , TotalBytesRead += TBytesRead
    , TotalBytesWritten += TBytesWritten
    
    , ELP_StoreBytes("ResetRead")
    , ELP_StoreBytes("ResetWrite")
    
    , ELP_MasterSettings("Set", "Count_BytesWritten", CountHDActivity)
    , ELP_MasterSettings("Set", "Count_BytesRead", CountHDActivity)
}

Generate_Icon(_Path)
{
    Global Ptr
    ;This function "extracts" the file to the location+name you pass to it.
    Static CompiledData, Out_Data
    Static 1 = "AAABAAEAICAAAAAAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 2 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 3 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACoqKgZUVFR9VFRUzFRU"
    Static 4 = "VPNUVFTOVFRUejMzMwUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 5 = "AAAAAAAAAAAAAAAAAAAAAAAAABMTEweWFhY0VlZWf9ZWVn/WVlZ/1lZWf9ZWVn/WFhY0FJSUhkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 6 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATk5OGltbW9xcXFz/XFxc/1xcXP9cXFz/XFxc/1xcXP9cXFz/Wlp"
    Static 7 = "a2VVVVRsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFRURZf"
    Static 8 = "X1/XYGBg/2BgYP9gYGD/YGBg/2BgYP9gYGD/YGBg/2BgYP9gYGD/Xl5e21hYWB0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 9 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADY2Njx2RkZP9kZGT/ZGRk/2RkZP9kZGT/ZGRk/2RkZP9kZGT/ZGRk/2RkZP9kZGT/Y2Nj3lpaWh8AAA"
    Static 10 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGVlZXFoaGj/aGho/2hoaP9oaGj/aGho/2h"
    Static 11 = "oaP9oaGj/aGho/2hoaP9oaGj/aGho/2hoaP9oaGj/Z2dn4F1dXSEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 12 = "AAAAAAAAAAAAAAAAampqyWtra/9ra2v/a2tr/2tra/9ra2v/a2tr/2tra/9ra2v/a2tr/2tra/9ra2v/a2tr/2tra/9ra2v/ampq4mZmZiMAAAAAAAAAAAAAA"
    Static 13 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABubm7zb29v/29vb/9vb2//b29v/29vb/9vb2//b29v/29vb/9vb2//b2"
    Static 14 = "9v/29vb/9vb2//b29v/29vb/9tbW3yampqSFtbWw4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHJyctR"
    Static 15 = "zc3P/c3Nz/3Nzc/9zc3P/c3Nz/3Nzc/9zc3P/c3Nz/3Nzc/9zc3P/c3Nz/3Nzc/9zc3P/cXFx2nBwcDBycnKWcnJy5m1tbSoAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 16 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdXV1jXd3d/93d3f/d3d3/3d3d/93d3f/d3d3/3d3d/93d3f/d3d3/3d3d/93d3f/d3d3/3V1dbVxc"
    Static 17 = "XEtdnZ2yXd3d/93d3f/dnZ24WJiYg0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/f38Menp63Xt7e/97e3v/e3t7/3"
    Static 18 = "t7e/97e3v/e3t7/3t7e/97e3v/e3t7/3t7e/95eXmFeHh4SHl5eet7e3v/e3t7/3t7e/97e3v/eHh4jgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 19 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAB2dnYnfX195X5+fv9+fn7/fn5+/35+fv9+fn7/fn5+/35+fv99fX3+e3t7WXt7e1t9fX39fn5+/35+fv9+fn7/fn5+/35+"
    Static 20 = "fv99fX3UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/f38kgICA4oKCgv+CgoL/goKC/4KCgv+CgoL/g"
    Static 21 = "oKC/4CAgIl/f39Uf39/JICAgMWCgoL/goKC/4KCgv+CgoL/goKC/4GBgfMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 22 = "AAAAAAAAAAAAAAAAB8fHwhhYWF4IaGhv+Ghob/hoaG/4aGhv+FhYXFf39/NIWFhfiFhYXVf39/JIWFhcKGhob/hoaG/4aGhv+Ghob/hISEygAAAAAAAAAAAAA"
    Static 23 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/f38eiYmJ3YqKiv+Kior/iIiI7YODgymJiYnYioqK/4qKiv+J"
    Static 24 = "iYnYg4ODJYmJib6Kior/ioqK/4qKiv+IiIh2AAAAAAAAAACKioowi4uLwo2Njf+NjY3/jY2N/42Njf+NjY3/jY2N/42Njf+NjY3/jY2N/42Njf+NjY3/jIyM+"
    Static 25 = "omJiVR/f38cjIyM2o2Njf+Li4tNi4uLoI2Njf+NjY3/jY2N/42Njf+MjIzbhoaGJouLi7uNjY3/jIyMzH9/fwQAAAAAAAAAAJCQkMWRkZH/kZGR/5GRkf+RkZ"
    Static 26 = "H/kZGR/5GRkf+RkZH/kZGR/5GRkf+RkZH/kZGR/5GRkf+RkZH/kJCQ/I2NjV6FhYUZj4+PcI6Ojl2RkZH/kZGR/5GRkf+RkZH/kZGR/5GRkf+QkJDdiYmJJ4+"
    Static 27 = "Pj4aKiooYAAAAAAAAAAAAAAAAlZWV/5WVlf+VlZX/lZWV/5WVlf+VlZX/lZWV/5WVlf+VlZX/lZWV/5WVlf+VlZX/lZWV/5WVlf+VlZX/lJSU/pKSkmkAAAAA"
    Static 28 = "lJSUy5WVlf+VlZX/lZWV/5WVlf+VlZX/lZWV/5WVlf+Tk5OgAAAAAAAAAAAAAAAAAAAAAAAAAACZmZn/mZmZ/5KSkhySkpIcmZmZ/5mZmf+UlJQfAAAAAAAAA"
    Static 29 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAJSUlB+ZmZn/mZmZ/5eXl3SKiooYl5eX0ZmZmf+ZmZn/mZmZ/5mZmf+ZmZn/l5eX0ZCQkB4AAAAAAAAAAAAAAAAAAAAAAA"
    Static 30 = "AAAJycnP+cnJz/kpKSHJKSkhycnJz/nJyc/5SUlB8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlJSUH5ycnP+cnJz/nJyc/5mZmYp/f38Mmpqafpubm9G"
    Static 31 = "bm5vzm5ubzJmZmYCJiYkNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoKCg/6CgoP+goKD/oKCg/6CgoP+goKD/oKCg/6CgoP+goKD/oKCg/6CgoP+goKD/oKCg"
    Static 32 = "/6CgoP+goKD/oKCg/6CgoP+goKD/oKCg/56entOcnJxalJSUH5KSkg6bm5sunp6edJ+fn+UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACkpKT/pKSk/6SkpP+kp"
    Static 33 = "KT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/6SkpP+kpKT/pKSk/w"
    Static 34 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKioqP+oqKj/m5ubHJubmxyoqKj/qKio/5ubmxybm5scqKio/6ioqP+bm5scm5ubHKioqP+oqKj/m5ubHJubmxyoqKj"
    Static 35 = "/qKio/5ubmxybm5scqKio/6ioqP+bm5scm5ubHKioqP+oqKj/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAq6ur/6urq/+kpKQcpKSkHKurq/+rq6v/pKSkHKSk"
    Static 36 = "pByrq6v/q6ur/6SkpBykpKQcq6ur/6urq/+kpKQcpKSkHKurq/+rq6v/pKSkHKSkpByrq6v/q6ur/6SkpBykpKQcq6ur/6urq/8AAAAAAAAAAAAAAAAAAAAAA"
    Static 37 = "AAAAAAAAACvr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/"
    Static 38 = "+vr6//r6+v/6+vr/+vr6//r6+v/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALOzs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7O"
    Static 39 = "z/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAt7e3/7e3t/+t"
    Static 40 = "ra0cra2tHLe3t/+3t7f/ra2tHK2trRy3t7f/t7e3/62trRytra0ct7e3/7e3t/+tra0cra2tHLe3t/+3t7f/ra2tHK2trRy3t7f/t7e3/62trRytra0ct7e3/"
    Static 41 = "7e3t/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7u7v/u7u7/7a2thy2trYcu7u7/7u7u/+2trYctra2HLu7u/+7u7v/tra2HLa2thy7u7v/u7u7/7a2thy2tr"
    Static 42 = "Ycu7u7/7u7u/+2trYctra2HLu7u/+7u7v/tra2HLa2thy7u7v/u7u7/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL29vcW+vr7/vr6+/76+vv++vr7/vr6+/76"
    Static 43 = "+vv++vr7/vr6+/76+vv++vr7/vr6+/76+vv++vr7/vr6+/76+vv++vr7/vr6+/76+vv++vr7/vr6+/76+vv++vr7/vr6+/76+vv+9vb3CAAAAAAAAAAAAAAAA"
    Static 44 = "AAAAAAAAAAAAAAAAv7+/MMHBwcLCwsL/wsLC/8LCwv/CwsL/wsLC/8LCwv/CwsL/wsLC/8LCwv/CwsL/wsLC/8LCwv/CwsL/wsLC/8LCwv/CwsL/wsLC/8LCw"
    Static 45 = "v/CwsL/wsLC/8LCwv/CwsL/wcHBurm5uSwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Static 46 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////////j//"
    Static 47 = "//gP///wB///4AP//8AB///AAP//gAB//4AAf/+AAJ//gAEP/8ACB//gDAf/8AwH//gSB//8IQ8ABkCOAAPAXgABgD5n/MB+Z/ww/gAAH34AAAB+ZmZmfmZmZ"
    Static 48 = "n4AAAB+AAAAfmZmZn5mZmZ+AAAAfwAAAP/////8"
    
    If (!CompiledData)
    {
        VarSetCapacity(TD, 5872 * (A_IsUnicode ? 2 : 1))
        
        Loop, 48
            TD .= %A_Index%, %A_Index% := ""
        
        VarSetCapacity(Out_Data, Bytes := 4286, 0)
        , DllCall("Crypt32.dll\CryptStringToBinary" (A_IsUnicode ? "W" : "A"), Ptr, &TD, "UInt", 0, "UInt", 1, Ptr, &Out_Data, A_IsUnicode ? "UIntP" : "UInt*", Bytes, "Int", 0, "Int", 0, "CDECL Int")
        , VarSetCapacity(TD, 0)
        , CompiledData := True
    }
    
    H := ELP_OpenFileHandle(_Path, "Write", FileSize)
    If (H = -1)
        Return -1
    
    NeedWrite := True
    
    If (FileSize = 4286) ;Skips re-writing the icon if it's already valid
    {
        VarSetCapacity(TempIconData, FileSize, 0)
        , ELP_ReadData(H, &TempIconData, FileSize)
        
        If (ELP_CalcMD5(&TempIconData, FileSize) != ELP_CalcMD5(&Out_Data, 4286))
            ELP_SetEndOfFile(H, 0)
        Else
            NeedWrite := False
        
        VarSetCapacity(TempIconData, 0)
    } Else If (FileSize)
        ELP_SetEndOfFile(H, 0)
    
    If (NeedWrite)
        ELP_WriteData(H, &Out_Data, 4286)
    
    ELP_CloseFileHandle(H)
}

Check_ForUpdate(_ReplaceCurrentScript = 0, _SuppressMsgBox = 0, _CallbackFunction = "", ByRef _Information = "")
{
    Static Script_Name := "M&K Counter 2.0" ;Your script name
    , Update_URL := "http://www.autohotkey.net/~Rseding91/M%20and%20K%20Counter%202.0/Version.ini" ;The URL of the version.ini file for your script
    , Retry_Count := 3 ;Retry count for if/when anything goes wrong
    Global VersionNumber, Save_DataMethod, Ptr
    
    Random, Filler, 10000000, 99999999
    Version_File := A_Temp . "\" . Filler . ".ini"
    , Temp_FileName := A_Temp . "\" . Filler . ".tmp"
    , VBS_FileName := A_Temp . "\" . Filler . ".vbs"
    
    Loop, % Retry_Count
    {
        _Information := ""
        
        UrlDownloadToFile, % Update_URL, % Version_File
        
        IniRead, Version, % Version_File, Info, Version, N/A
        
        If (Version = "N/A"){
            FileDelete, % Version_File
            
            If (A_Index = Retry_Count)
                _Information .= "The version info file doesn't have a ""Version"" key in the ""Info"" section or the file can't be downloaded."
            Else
                Sleep, 500
            
            Continue
        }
        
        If (Version > VersionNumber){
            If (_SuppressMsgBox != 1 And _SuppressMsgBox != 3){
                MsgBox, 0x4, New version available, There is a new version of %Script_Name% available.`nCurrent version: %VersionNumber%`nNew version: %Version%`n`nWould you like to download it now?
                
                IfMsgBox, Yes
                    MsgBox_Result := 1
            }
            
            If (_SuppressMsgBox Or MsgBox_Result){
                IniRead, URL, % Version_File, Info, URL, N/A
                
                If (URL = "N/A")
                    _Information .= "The version info file doesn't have a valid URL key."
                Else {
                    SplitPath, URL,,, Extension
                    
                    If (Extension = "ahk" And A_AHKPath = "")
                        _Information .= "The new version of the script is an .ahk filetype and you do not have AutoHotKey installed on this computer.`r`nReplacing the current script is not supported."
                    Else If (Extension != "exe" And Extension != "ahk")
                        _Information .= "The new file to download is not an .EXE or an .AHK file type. Replacing the current script is not supported."
                    Else {
                        IniRead, MD5, % Version_File, Info, MD5, N/A
                        
                        Loop, % Retry_Count
                        {
                            UrlDownloadToFile, % URL, % Temp_FileName
                            
                            IfExist, % Temp_FileName
                            {
                                If (MD5 = "N/A"){
                                    _Information .= "The version info file doesn't have a valid MD5 key."
                                    , Success := True
                                    Break
                                } Else {
                                    H := ELP_OpenFileHandle(Temp_FileName, "Read", FileSize)
                                    
                                    If (FileSize != 0){
                                        VarSetCapacity(Data, FileSize, 0)
                                        , ELP_ReadData(H, &Data, FileSize)
                                        , ELP_CloseFileHandle(H)
                                        , VarSetCapacity(MD5_CTX, 104, 0)
                                        , DllCall("advapi32\MD5Init", Ptr, &MD5_CTX)
                                        , DllCall("advapi32\MD5Update", Ptr, &MD5_CTX, Ptr, &Data, "UInt", FileSize)
                                        , DllCall("advapi32\MD5Final", Ptr, &MD5_CTX)
                                        
                                        FileMD5 := ""
                                        Loop % StrLen(Hex := "123456789ABCDEF0")
                                            N := NumGet(MD5_CTX, 87 + A_Index, "Char"), FileMD5 .= SubStr(Hex, N >> 4, 1) . SubStr(Hex, N & 15, 1)
                                        
                                        VarSetCapacity(Data, FileSize, 0)
                                        , VarSetCapacity(Data, 0)
                                        
                                        If (FileMD5 != MD5){
                                            FileDelete, % Temp_FileName
                                            
                                            If (A_Index = Retry_Count)
                                                _Information .= "The MD5 hash of the downloaded file does not match the MD5 hash in the version info file."
                                            Else                                        
                                                Sleep, 500
                                            
                                            Continue
                                        } Else
                                            Success := True
                                    } Else {
                                        ELP_CloseFileHandle(H)
                                        , Success := True
                                    }
                                }
                            } Else {
                                If (A_Index = Retry_Count)
                                    _Information .= "Unable to download the latest version of the file from " . URL . "."
                                Else
                                    Sleep, 500
                                Continue
                            }
                        }
                    }
                }
            }
        } Else
            _Information .= "No update was found."
        
        FileDelete, % Version_File
        Break
    }
    
    If (_ReplaceCurrentScript And Success){
        SplitPath, URL,,, Extension
        Process, Exist
        MyPID := ErrorLevel
        
        VBS_P1 =
        (LTrim Join`r`n
            On Error Resume Next
            Set objShell = CreateObject("WScript.Shell")
            objShell.Run "TaskKill /F /PID %MyPID%", 0, 1
            Set objFSO = CreateObject("Scripting.FileSystemObject")
        )
        
        If (A_IsCompiled){
            If (Extension = "exe"){
                VBS_P2 =
                (LTrim Join`r`n
                    objFSO.CopyFile "%Temp_FileName%", "%A_ScriptFullPath%", True
                    objFSO.DeleteFile "%Temp_FileName%", True
                    objShell.Run """%A_ScriptFullPath%"""
                )
                
                Return_Val :=  Temp_FileName
            } Else { ;Extension is ahk
                SplitPath, A_ScriptFullPath,, FDirectory,, FName
                FileMove, % Temp_FileName, %FDirectory%\%FName%.ahk, 1
                FileDelete, % Temp_FileName
                
                VBS_P2 =
                (LTrim Join`r`n
                    objFSO.DeleteFile "%A_ScriptFullPath%", True
                    objShell.Run """%FDirectory%\%FName%.ahk"""
                )
                
                Return_Val := FDirectory . "\" . FName . ".ahk"
            }
        } Else {
            If (Extension = "ahk"){
                FileMove, % Temp_FileName, % A_ScriptFullPath, 1
                If (Errorlevel)
                    _Information .= "Error (" . Errorlevel . ") unable to replace current script with the latest version."
                Else {
                    VBS_P2 = 
                    (LTrim Join`r`n
                        objShell.Run """%A_ScriptFullPath%"""
                    )
                    
                    Return_Val :=  A_ScriptFullPath
                }
            } Else If (Extension = "exe"){
                SplitPath, A_ScriptFullPath,, FDirectory,, FName
                FileMove, %Temp_FileName%, %FDirectory%\%FName%.exe, 1
                FileDelete, % A_ScriptFullPath
                
                VBS_P2 =
                (LTrim Join`r`n
                    objShell.Run """%FDirectory%\%FName%.exe"""
                )
                
                Return_Val :=  FDirectory . "\" . FName . ".exe"
            } Else {
                FileDelete, % Temp_FileName
                _Information .= "The downloaded file is not an .EXE or an .AHK file type. Replacing the current script is not supported."
            }
        }
        
        VBS_P3 =
        (LTrim Join`r`n
            objFSO.DeleteFile "%VBS_FileName%", True
            Set objFSO = Nothing
            Set objShell = Nothing
        )
        
        If (_SuppressMsgBox < 2)
            VBS_P3 .= "`r`nWScript.Echo ""Update complected successfully."""
        
        FileDelete, % VBS_FileName
        FileAppend, %VBS_P1%`r`n%VBS_P2%`r`n%VBS_P3%, % VBS_FileName
        
        If (_CallbackFunction != ""){
            If (IsFunc(_CallbackFunction))
                %_CallbackFunction%()
            Else
                _Information .= "The callback function is not a valid function name."
        }
        
        
        If (Save_DataMethod = 1)
            Save_AllData(1)
        Else If (Save_DataMethod = 2)
            Close_FileHandles()
        
        RunWait, % VBS_FileName, % A_Temp, VBS_PID
        Sleep, 2000
        
        Process, Close, % VBS_PID
        _Information := "Error (?) unable to replace current script with the latest version.`r`nPlease make sure your computer supports running .vbs scripts and that the script isn't running in a pipe."
        
        If (Save_DataMethod = 2)
            Open_FileHandlesWrite()
    }
    
    _Information := _Information = "" ? "None" : _Information
    
    Return Return_Val
}

Uninstall_Script()
{
    Global RootDirectory, Save_DataMethod, Name, SkipExitSub
    
    Loop, 5
    {
        Random, C, 0, 1
        If (C = 0)
            Random, R, 65, 90
        Else
            Random, R, 97, 122
        
        Capcha .= Chr(R)
    }
    
    Message .= "Are you sure you want to delete all traces of`nthis program from your computer?"
    Message .= "`n`nPlease type the following letters into`nthe box below as confirmation: " Capcha
    
    Loop
    {
        InputBox, Output, Are you sure?, % Message,, 300
        
        If (Output = "")
            Return
        Else {
            O := "", C := ""
            
            Loop, Parse, Capcha
                C .= Asc(A_LoopField)
            Loop, Parse, Output
                O .= Asc(A_LoopField)
            
            If (O = C){
                Delete := True
                
                Break
            }
        }
    }
    
    If (Delete = True){
        Critical, On
        
        SetTimer, AutoSave, Off
        
        SkipExitSub := True
        
        If (Save_DataMethod = 2)
            Close_FileHandles()
        
        Errors := ELP_FileRemoveDirectory(RootDirectory, 1)
        
        If (Errors){
            Message := ""
            Message .= "I'm sorry, but the script was unable to delete one or more of the files."
            Message .= "`n`nMaybe a different program has one of them open or windows is just being stupid."
            Message .= "`n`nYou can try restarting your computer and running the remove operation again if you want."
            
            MsgBox, %Message%
            
            ExitApp
        } Else {
            If (AutoStart(1))
                AutoStart()
            
            Process, Exist
            MyPID := ErrorLevel
            
            Loop
            {
                Random, R, 10000, 99999
                VBS_FileName := A_Temp . "\" . R . ".vbs"
                
                If (!ELP_FileExists(VBS_FileName, 1, 0, 0))
                    Break
            }
            
            VBS =
            (LTrim Join`r`n
                On Error Resume Next
                Set objShell = CreateObject("WScript.Shell")
                objShell.Run "TaskKill /F /PID %MyPID%", 0, 1
                Set objFSO = CreateObject("Scripting.FileSystemObject")
                objFSO.DeleteFile "%A_ScriptFullPath%", True
                objFSO.DeleteFile "%VBS_FileName%", True
                Set objFSO = Nothing
                Set objShell = Nothing
                WScript.Echo "%Name% was successfully removed from your computer."
            )
            
            ELP_FileAppend(VBS, VBS_FileName)
            Run, % VBS_FileName
            
            ExitApp
        }
    }
}

Build_TrayMenu(Rebuild = 0)
{
    Global
    
    If (Rebuild)
    {
        Menu, OptionsSubMenu, DeleteAll
        Menu, AccuracySubMenu, DeleteAll
        Menu, Tray, DeleteAll
    }
    
    Menu, Tray, Add, Enable mouse counting, MenuHandler
    Menu, Tray, Add, Enable keyboard counting, MenuHandler
    Menu, Tray, Add, Count pixels mouse moved, MenuHandler
    Menu, Tray, Add, Count words per ?, MenuHandler
    Menu, Tray, Add, Count bytes read/written, MenuHandler
    Menu, Tray, Add
;/
    Menu, Tray, add, Settings, Configuration
    Menu, Tray, add, filemenu, 
    Menu, Tray, add, mymenubar, 
    Menu, Tray, add, Pause, PauseResumeScript
    IF (A_IsCompiled)
    {
       Menu, Tray, add, Exit, ExitScript
    } else {
       Menu, Tray, Standard
    }
    Menu, Tray, Default, Settings
    ;Menu, Tray, Default, Settings
    ;Initialize Tray Icon
    Menu, Tray, Icon
;//    
    If (CountMouse)
        Menu, Tray, Check, Enable mouse counting
    
    If (CountKeyboard)
        Menu, Tray, Check, Enable keyboard counting
    
    If (CountPixelsMoved)
        Menu, Tray, Check, Count pixels mouse moved
    
    If (CountWPT)
        Menu, Tray, Check, Count words per ?
    
    If (CountHDActivity)
        Menu, Tray, Check, Count bytes read/written
    
    Menu, OptionsSubMenu, Add, Autostart at logon, MenuHandler
    If (Autostart_AtLogon)
        Menu, OptionsSubMenu, Check, Autostart at logon
    Menu, OptionsSubMenu, Add, Enable autosave, MenuHandler
    If (AutoSave_State)
        Menu, OptionsSubMenu, Check, Enable autosave
    
    Menu, OptionsSubMenu, Add, Show hover over counts in converted units, MenuHandler
    If (Show_CountsInConvertedUnits)
        Menu, OptionsSubMenu, Check, Show hover over counts in converted units
    
    Menu, OptionsSubMenu, Add, Show todays counts in hover-over tray tip, MenuHandler
    If (Show_TodaysCount)
        Menu, OptionsSubMenu, Check, Show todays counts in hover-over tray tip
    
    Menu, OptionsSubMenu, Add, Show all computers data in tray tip, MenuHandler
    If (Show_AllComputers)
        Menu, OptionsSubMenu, Check, Show all computers data in tray tip
    
    Menu, OptionsSubMenu, Add, Verify stored data, MenuHandler
    Menu, OptionsSubMenu, Add, Set screen size(s), MenuHandler
    Menu, OptionsSubMenu, Add, Set maximum RAM Use (current: %MB_RamUse% MB), MenuHandler
    Menu, OptionsSubMenu, Add, Set autosave interval (current: %Autosave_Interval% seconds), MenuHandler
    Menu, OptionsSubMenu, Add, Use registry to store settings, MenuHandler
    Menu, OptionsSubMenu, Add, Use options file to store settings, MenuHandler
    If (Save_SettingsMethod = 1)
        Menu, OptionsSubMenu, Check, Use registry to store settings
    If (Save_SettingsMethod = 2)
        Menu, OptionsSubMenu, Check, Use options file to store settings
    
    Menu, OptionsSubMenu, Add
    Menu, OptionsSubMenu, Add, Reset counters, MenuHandler
    Menu, OptionsSubMenu, Add
    ;Menu, OptionsSubMenu, Add, Export history to package, MenuHandler
    ;Menu, OptionsSubMenu, Add, Import history from package (replace), MenuHandler
    ;Menu, OptionsSubMenu, Add, Import history from package (merge), MenuHandler
    ;Menu, OptionsSubMenu, Add, Import history from package (merge-replace), MenuHandler
    ;Menu, OptionsSubMenu, Add
    Menu, OptionsSubMenu, Add, Save method 1 (buffer key counts), MenuHandler
    Menu, OptionsSubMenu, Add, Save method 2 (direct to disk), MenuHandler
    If (Save_DataMethod = 1)
        Menu, OptionsSubMenu, Check, Save method 1 (buffer key counts)
    Else If (Save_DataMethod = 2)
        Menu, OptionsSubMenu, Check, Save method 2 (direct to disk)
    
    Menu, OptionsSubMenu, Add
    Menu, OptionsSubMenu, Add, Remove this program and all of its files from this computer, MenuHandler
    Menu, Tray, Add, Options, :OptionsSubMenu
    
    Menu, AccuracySubMenu, Add, Minutes, MenuHandler
    Menu, AccuracySubMenu, Add, Seconds, MenuHandler
    Menu, AccuracySubMenu, Add, Milliseconds, MenuHandler
    Menu, Tray, Add, Set capture accuracy, :AccuracySubMenu
    
    If (Capture_Accuracy = 1)
        Menu, AccuracySubMenu, Check, Minutes
    Else If (Capture_Accuracy = 2)
        Menu, AccuracySubMenu, Check, Seconds
    Else If (Capture_Accuracy = 3)
        Menu, AccuracySubMenu, Check, Milliseconds
    
    Menu, StatisticsSubMenu, Add, Show key/mouse counts for a specific date range, MenuHandler
    Menu, StatisticsSubMenu, Add, Show mouse movement information for a specific date range, MenuHandler
    Menu, StatisticsSubMenu, Add, Show word information for a specific date range, MenuHandler
    Menu, Tray, Add, Show detailed information, :StatisticsSubMenu
    
    Menu, Tray, Add, Check for update, MenuHandler
    
    Menu, Tray, Add, Settings GUI, MenuHandler
    Menu, Tray, Default, Settings GUI
    Menu, Tray, Add, About, MenuHandler
    
    Menu, Tray, Add, Exit, MenuHandler
}






;**********************************
; Key Ranges
;**********************************

Ranges_Initialize()
{
    Global
    
    Range0_Description := "All of the ranges in use"
    Range0_Keys := ""
    Range0_Lower := 1
    
    Range1_Description := "Old data structure (contains all ""keys"" for old structure)"
    Range1_Keys := ""
    Range1_Lower := 1
    Range1_Upper := 50000
    Range1_Used := 188

    Range2_Description := "Lower case letters (a-z)"
    Range2_Keys := "|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|"
    Range2_Lower := 50001
    Range2_Upper := 100000
    Range2_Used := 26

    Range3_Description := "Upper case letters (A-Z)"
    Range3_Keys := "|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|"
    Range3_Lower := 100001
    Range3_Upper := 150000
    Range3_Used := 26

    Range4_Description := "Numbers (not numpad, 0, 1, ...)"
    Range4_Keys := "|0|1|2|3|4|5|6|7|8|9|"
    Range4_Lower := 150001
    Range4_Upper := 200000
    Range4_Used := 10

    Range5_Description := "Special typeable characters (~, `, !, ...)"
    Range5_Keys := "|``|~|!|@|#|$|%|^|&|*|(|)|-|_|=|+|[|{|]|}|\|Pipe|;|:|'|""|,|<|.|>|/|?|"
    Range5_Lower := 200001
    Range5_Upper := 250000
    Range5_Used := 32

    Range6_Description := "Function keys (F1, F2, ...)"
    Range6_Keys := "|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|"
    Range6_Lower := 250001
    Range6_Upper := 300000
    Range6_Used := 24

    Range7_Description := "State modifier keys (Control, Alt, ...)"
    Range7_Keys := "|Left Shift|Right Shift|Left Control|Right Control|Left Alt|Right Alt|"
    Range7_Lower := 300001
    Range7_Upper := 350000
    Range7_Used := 6

    Range8_Description := "Toggleable keys (Capslock, Scroll lock, ...)"
    Range8_Keys := "|Caps Lock|Num Lock|Insert|Scroll Lock|"
    Range8_Lower := 350001
    Range8_Upper := 400000
    Range8_Used := 4

    Range9_Description := "Special action keys (Tab, Windows, Left, ...)"
    Range9_Keys := "|Apps Key|Tab|Help|Sleep|PrintScreen|PauseBreak|Home|Page Up|Page Down|Delete|End|Left|Up|Right|Down|Left Windows|Right Windows|Escape|BackSpace|Space|Enter|"
    Range9_Lower := 400001
    Range9_Upper := 450000
    Range9_Used := 21

    Range10_Description := "Numpad numbers (Numpad 0, Numpad 1, ...)"
    Range10_Keys := "|Numpad 0|Numpad 1|Numpad 2|Numpad 3|Numpad 4|Numpad 5|Numpad 6|Numpad 7|Numpad 8|Numpad 9|"
    Range10_Lower := 450001
    Range10_Upper := 500000
    Range10_Used := 27
    
    Range11_Description := "Numpad other keys (Numpad Del, Numpad Mult, ...)"
    Range11_Keys := "|Numpad Dot|Numpad Enter|Numpad Add|Numpad Sub|Numpad Mult|Numpad Div|Numpad Insert|Numpad End|Numpad Home|Numpad Page Down|Numpad Page Up|Numpad Clear|Numpad Delete|Numpad Left|Numpad Up|Numpad Right|Numpad Down|"
    Range11_Lower := 500001
    Range11_Upper := 550000
    Range11_Used := 17

    Range12_Description := "Media keys (Browser Back, Volume up, ...)"
    Range12_Keys := "|Browser Back|Browser Forward|Browser Refresh|Browser Stop|Browser Search|Browser Favorites|Browser Home|Volume Mute|Volume Down|Volume Up|Media Next|Media Prev|Media Stop|Media Play Pause|Launch Mail|Launch Media|Launch App 1|Launch App 2|"
    Range12_Lower := 550001
    Range12_Upper := 600000
    Range12_Used := 18

    Range13_Description := "Mouse keys (Left button, Scroll up, ...)"
    Range13_Keys := "|Left Mouse Button|Right Mouse Button|Middle Mouse Button|X Button 1|X Button 2|Mouse Wheel Up|Mouse Wheel Down|"
    Range13_Lower := 600001
    Range13_Upper := 650000
    Range13_Used := 7
    
    Range0_Upper := 9223372036854775807
    Range0_Used := 13
}

Count_HotKeys()
{
    Global
    Local Total, I, L
    
    Total := 0
    , I := Range0_Lower + 1 ;Skip range 1
    
    Loop, % Range0_Used - 1 ;Skip range 1
    {
        Total += Range%I%_Used
        
        I ++
    }
    
    Return Total
}

Translate_Key(_Key)
{
    Global
    Local I
    , PartString
    , Pos
    , ID
    
    I := Range0_Lower + 1 ;Skips range 1
    
    Loop, % Range0_Used - 1 ;Skips range 1
    {
        If (InStr(Range%I%_Keys, "|" _Key "|", True)){
            Pos := InStr(Range%I%_Keys, "|" _Key "|", True)
            
            If (Pos = 0)
                PartString := "|"
            Else
                PartString := SubStr(Range%I%_Keys, 1, Pos)
            
            StringReplace, PartString, PartString, |, |, UseErrorLevel
            
            ID := ErrorLevel - 1 + Range%I%_Lower
            
            Break
        }
        
        I ++
    }
    
    Return ID
}

Translate_KeyIDToName(_ID)
{
    Global
    Local I
    
    I := Range0_Lower + 1 ;Skips range 1
    
    Loop, % Range0_Used - 1 ;Skips range 1
    {
        If (_ID >= Range%I%_Lower And _ID <= Range%I%_Upper)
            Loop, Parse, Range%I%_Keys, |
            {
                If (A_LoopField = "")
                    Continue
                
                If ((A_Index - 2 + Range%I%_Lower) = _ID)
                    Return A_LoopField
            }
        I ++
    }
}

;**********************************
; End Key Ranges
;**********************************


;**********************************
; Indexing and reporting functions
;**********************************

Show_KeyInformation(_Cmd = "")
{
    Static StartDate, EndDate
    , StartTime, EndTime
    , KeySelection, DisplayCount
    , N := 5
    , KeysList
    , IsShowing := False
    , SelectedComputer
    , Computers
    
    Global RootDirectory
    
    If (_Cmd = "Calculate"){
        Gui, %N%:Submit, NoHide
        
        KeyID := Translate_Key(KeySelection)
        
        If (KeyID = ""){
            MsgBox Failed to lookup key: %KeySelection%`nReturned value: %KeyID%
            Return
        }
        
        Keys_ToProcess := ""
        
        Loop, Parse, Computers, |
        {
            If (A_Index = 1)
                Continue
            
            If (SelectedComputer = "All" Or SelectedComputer = A_LoopField)
                Keys_ToProcess .= Keys_ToProcess = "" ? "" : "`n"
                , Keys_ToProcess .= RootDirectory "\" A_LoopField "\Keys\Key " KeyID
        }
        
        StartDate := StartDate . SubStr(StartTime, 9)
        , EndDate := EndDate . SubStr(EndTime, 9)
        , DisplayCount := 0
        
        Loop, Parse, Keys_ToProcess, `n
        {
            If (!InStr(Validate_KeyIndex(A_LoopField, 0, 1), "not found"))
                V := Read_KeyIndex(A_LoopField, StartDate, EndDate)
            Else
                V := 0
            
            If (V > 0)
                DisplayCount += V
        }
        
        If (DisplayCount < 0)
            DisplayCount := "-"
        
        Gui, %N%:Default
        GuiControl,, DisplayCount, %DisplayCount%
        
        Return
    } Else If (_Cmd = "Destroy"){
        Gui, %N%:Destroy
        IsShowing := False
        
        Return
    } Else If (_Cmd = "Copy"){
        Clipboard := DisplayCount
        
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := True
    
    KeysList =
    (LTrim Join|
        a||b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
        A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z
        0|1|2|3|4|5|6|7|8|9
        `)|!|@|#|$|`%|^|&|*|(|``|-|=|[|]|\|`;|'|,|.|/|~|_|+|{
        }|Pipe|:|`"|<|>|?
        F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16
        F17|F18|F19|F20|F21|F22|F23|F24
        Tab|Left Shift|Right Shift|Caps Lock|Num Lock|Insert
        Scroll Lock|Left Control|Right Control|Left Alt
        Right Alt|Left Windows|Right Windows|Apps Key
        PrintScreen|PauseBreak|Home|Page Up|Page Down
        Delete|End|Left|Up|Right|Down
        Numpad 0|Numpad 1|Numpad 2|Numpad 3|Numpad 4|Numpad 5
        Numpad 6|Numpad 7|Numpad 8|Numpad 9|Numpad Dot
        Numpad Div|Numpad Mult|Numpad Add|Numpad Sub|Numpad Enter
        Numpad Insert|Numpad End|Numpad Down|Numpad Page Down
        Numpad Left|Numpad Clear|Numpad Right|Numpad Home
        Numpad Up|Numpad Page Up|Numpad Delete|Help|Sleep
        Browser Back|Browser Forward|Browser Refresh
        Browser Stop|Browser Search|Browser Favorites
        Browser Home|Escape|BackSpace|Space|Enter
        Left Mouse Button|Right Mouse Button|Middle Mouse Button
        X Button 1|X Button 2|Mouse Wheel Up|Mouse Wheel Down
        Volume Mute|Volume Down|Volume Up|Media Next|Media Prev
        Media Stop|Media Play Pause|Launch Mail|Launch Media
        Launch App 1|Launch App 2
    )
    ;"
    
    Computers := "All|" Get_ComputerDataFolderNames()
    
    Gui, %N%:Font, S10
    Gui, %N%:+LabelDisplayKeyCounts
    
    Gui, %N%:Add, Text, x10 y10 w475, Key and mouse counts, select the date/time range to show
    
    Gui, %N%:Add, Text, y+15 w225, Start date
    Gui, %N%:Add, Text, x+25 yp+0 w225, End date
    Gui, %N%:Add, MonthCal, x10 w225 vStartDate, MM/dd/yyyy
    Gui, %N%:Add, MonthCal, x+25 yp+0 w225 vEndDate, MM/dd/yyyy
    
    Gui, %N%:Add, Text, x10 y+15 w225, Start time
    Gui, %N%:Add, Text, x+25 yp+0 w225, End time
    
    Morning := A_YYYY A_MM A_DD 00 00 00
    , Night := A_YYYY A_MM A_DD 23 59 59
    
    Gui, %N%:Add, DateTime, x10 w225 Choose%Morning% vStartTime 1, hh:mm tt
    Gui, %N%:Add, DateTime, x+25 yp+0 w225 Choose%Night% vEndTime 1, hh:mm tt
    
    Gui, %N%:Add, Text, x10 y+15 w225, Select key
    Gui, %N%:Add, Text, x+25 yp+0 w225, Select Computer
    Gui, %N%:Add, DropDownList, x10 w225 r23 vKeySelection, %KeysList%
    Gui, %N%:Add, DropDownList, x+25 yp+0 w225 Choose1 vSelectedComputer, %Computers%
    
    Gui, %N%:Add, Text, x10 y+15 w175, Count
    Gui, %N%:Add, Button, x190 yp-7 gDisplayKeyCountsCopy, Copy
    Gui, %N%:Add, Edit, x10 w225 ReadOnly vDisplayCount, -
    
    Gui, %N%:Add, Button, x+24 yp-35 w227 h60 gDisplayKeyCountsCalculate, Calculate
    
    Gui, %N%:Show,, Show key and mouse information
}

Show_MouseMovementInformation(_Cmd = "")
{
    Static StartDate, EndDate
    , StartTime, EndTime
    , MonitorSelection, DisplayCount
    , MeasurementSelection, MonitorSelectionDisplay
    , N := 6
    , IsShowing := False
    , Computers
    , SelectedComputer
    , CalculateAllMonitors
    
    Global RootDirectory
    
    If (_Cmd = "Calculate"){
        Gui, %N%:Submit, NoHide
        
        If (MonitorSelection < 0 Or MonitorSelection > 2147483647)
            MonitorSelection := 1
        
        If (MeasurementSelection = "Pixels moved")
            MeasurementSelection := "Pixels"
        Else If (MeasurementSelection = "Inches moved")
            MeasurementSelection := "Inches"
        Else
            MeasurementSelection := "Pixels"
        
        Monitors_ToProcess := ""
        
        Loop, Parse, Computers, |
        {
            If (A_Index = 1)
                Continue
            
            If (SelectedComputer = "All" Or SelectedComputer = A_LoopField)
                Monitors_ToProcess .= Monitors_ToProcess = "" ? "" : "`n"
                , Monitors_ToProcess .= RootDirectory "\" A_LoopField "\Mouse Movement"
        }
        
        StartDate := StartDate . SubStr(StartTime, 9)
        , EndDate := EndDate . SubStr(EndTime, 9)
        , DisplayCount := 0
        
        Loop, Parse, Monitors_ToProcess, `n
        {
            MonitorData_FolderPath := A_LoopField
            
            If (!InStr(Validate_MouseMovementIndex(MonitorData_FolderPath, 0, 1), "not found"))
            {
                If (CalculateAllMonitors)
                    All_Monitors := Read_MouseIndex(MonitorData_FolderPath, "All", MeasurementSelection, StartDate, EndDate)
                Else
                    All_Monitors := MonitorSelection
            } Else
                All_Monitors := ""
            
            TGarbageData := 12345
            Loop, Parse, All_Monitors, `n
            {
                V := Read_MouseIndex(MonitorData_FolderPath, A_LoopField, MeasurementSelection, StartDate, EndDate, TGarbageData, !CalculateAllMonitors)
                
                If (V > 0)
                    DisplayCount += V
            }
        }
        
        If (MeasurementSelection = "Inches")
            DisplayCount := Round(DisplayCount, 5)
        
        Gui, %N%:Default
        GuiControl,, DisplayCount, %DisplayCount% %MeasurementSelection%
        
        Return
    } Else If (_Cmd = "Destroy"){
        Gui, %N%:Destroy
        IsShowing := False
        
        Return
    } Else If (_Cmd = "Copy"){
        Clipboard := DisplayCount
        
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := True
    
    Computers := "All|" Get_ComputerDataFolderNames()
    
    Gui, %N%:Font, S10
    Gui, %N%:+LabelDisplayMouseMovement
    
    Gui, %N%:Add, Text, x10 y10 w475, Mouse movement, select the date/time range to show
    
    Gui, %N%:Add, Text, y+15 w225, Start date
    Gui, %N%:Add, Text, x+25 yp+0 w225, End date
    Gui, %N%:Add, MonthCal, x10 w225 vStartDate, MM/dd/yyyy
    Gui, %N%:Add, MonthCal, x+25 yp+0 w225 vEndDate, MM/dd/yyyy
    
    Gui, %N%:Add, Text, x10 y+15 w225, Start time
    Gui, %N%:Add, Text, x+25 yp+0 w225, End time
    
    Morning := A_YYYY A_MM A_DD 00 00 00
    , Night := A_YYYY A_MM A_DD 23 59 59
    
    Gui, %N%:Add, DateTime, x10 w225 Choose%Morning% vStartTime 1, hh:mm tt
    Gui, %N%:Add, DateTime, x+25 yp+0 w225 Choose%Night% vEndTime 1, hh:mm tt
    
    Gui, %N%:Add, Text, x10 y+15 w225, Select monitor
    Gui, %N%:Add, Text, x+25 yp+0 w225, Select unit
    
    Gui, %N%:Add, Edit, x10 w225 vMonitorSelectionDisplay,
    Gui, %N%:Add, UpDown, w225 vMonitorSelection Range0-2147483647, 1
    Gui, %N%:Add, DropDownList, x+25  w225 vMeasurementSelection, Pixels moved||Inches moved
    
    Gui, %N%:Add, Text, x10 y+15 w175, Count
    Gui, %N%:Add, Button, x+5 yp-7 gDisplayMouseMovementCopy, Copy
    Gui, %N%:Add, Edit, x10 w225 ReadOnly vDisplayCount, -
    
    Gui, %N%:Add, Text, x10 y+15 w225, Select Computer
    Gui, %N%:Add, DropDownList, x10 w225 Choose1 vSelectedComputer, %Computers%
    
    Gui, %N%:Add, Button, x+25 yp-63 w225 h88 gDisplayMouseMovementCalculate, Calculate
    
    Gui, %N%:Add, CheckBox, x150 y301 vCalculateAllMonitors Checked, All Monitors
    
    Gui, %N%:Show,, Show mouse movement information
}

Show_WordInformation(_Cmd = "")
{
    Static StartDate, EndDate
    , StartTime, EndTime
    , DisplaySelection, DisplayCount
    , N := 7
    , IsShowing := False
    , Computers
    , SelectedComputer
    
    Global RootDirectory
    
    If (_Cmd = "Calculate"){
        Gui, %N%:Submit, NoHide
        
        If (DisplaySelection = "Words typed")
            DisplaySelection := "Count"
        Else If (DisplaySelection = "Words total length")
            DisplaySelection := "Lengths"
        
        Words_ToProcess := ""
        
        Loop, Parse, Computers, |
        {
            If (A_Index = 1)
                Continue
            
            If (SelectedComputer = "All" Or SelectedComputer = A_LoopField)
                Words_ToProcess .= Words_ToProcess = "" ? "" : "`n"
                , Words_ToProcess .= RootDirectory "\" A_LoopField "\Word Speed"
        }
        
        StartDate := StartDate . SubStr(StartTime, 9)
        , EndDate := EndDate . SubStr(EndTime, 9)
        , DisplayCount := 0
        
        Loop, Parse, Words_ToProcess, `n
        {
            V := Read_WordsIndex(A_LoopField, DisplaySelection, StartDate, EndDate)
            
            If (V > 0)
                DisplayCount += V
        }
        
        If (DisplayCount < 0)
            DisplayCount := "-"
        
        Gui, %N%:Default
        GuiControl,, DisplayCount, %DisplayCount%
        
        Return
    } Else If (_Cmd = "Destroy"){
        Gui, %N%:Destroy
        IsShowing := False
        
        Return
    } Else If (_Cmd = "Copy"){
        Clipboard := DisplayCount
        
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := True
    
    Computers := "All|" Get_ComputerDataFolderNames()
    
    Gui, %N%:Font, S10
    Gui, %N%:+LabelDisplayWordCounts
    
    Gui, %N%:Add, Text, x10 y10 w475, Word information, select the date/time range to show
    
    Gui, %N%:Add, Text, y+15 w225, Start date
    Gui, %N%:Add, Text, x+25 yp+0 w225, End date
    Gui, %N%:Add, MonthCal, x10 w225 vStartDate, MM/dd/yyyy
    Gui, %N%:Add, MonthCal, x+25 yp+0 w225 vEndDate, MM/dd/yyyy
    
    Gui, %N%:Add, Text, x10 y+15 w225, Start time
    Gui, %N%:Add, Text, x+25 yp+0 w225, End time
    
    Morning := A_YYYY A_MM A_DD 00 00 00
    , Night := A_YYYY A_MM A_DD 23 59 59
    
    Gui, %N%:Add, DateTime, x10 w225 Choose%Morning% vStartTime 1, hh:mm tt
    Gui, %N%:Add, DateTime, x+25 yp+0 w225 Choose%Night% vEndTime 1, hh:mm tt
    
    Gui, %N%:Add, Text, x10 y+15 w225, Select unit
    Gui, %N%:Add, Text, x+25 yp+0 w225, Select Computer
    Gui, %N%:Add, DropDownList, x10 w225 r23 vDisplaySelection, Words typed||Words total length
    Gui, %N%:Add, DropDownList, x+25 yp+0 w225 Choose1 vSelectedComputer, %Computers%
    
    Gui, %N%:Add, Text, x10 y+15 w175, Count
    Gui, %N%:Add, Button, x+5 yp-7 gDisplayWordCountsCopy, Copy
    Gui, %N%:Add, Edit, x10 w225 ReadOnly vDisplayCount, -
    
    Gui, %N%:Add, Button, x+25 yp-35 w225 h60 gDisplayWordCountsCalculate, Calculate
    
    Gui, %N%:Show,, Show word information
}


DisplayWordCountsClose:
DisplayWordCountsEscape:
    Show_WordInformation("Destroy")
Return

DisplayWordCountsCalculate:
    Show_WordInformation("Calculate")
Return

DisplayWordCountsCopy:
    Show_WordInformation("Copy")
Return


DisplayMouseMovementClose:
DisplayMouseMovementEscape:
    Show_MouseMovementInformation("Destroy")
Return

DisplayMouseMovementCalculate:
    Show_MouseMovementInformation("Calculate")
Return

DisplayMouseMovementCopy:
    Show_MouseMovementInformation("Copy")
Return


DisplayKeyCountsClose:
DisplayKeyCountsEscape:
    Show_KeyInformation("Destroy")
Return

DisplayKeyCountsCalculate:
    Show_KeyInformation("Calculate")
Return

DisplayKeyCountsCopy:
    Show_KeyInformation("Copy")
Return








Read_KeyIndex(_Which, _StartDate, _EndDate, ByRef _Data = 12345, _VerifyIndex = 1)
{
    Global Package_FileVersion
    , Pixel_FileVersion
    , Save_FileVersion
    , MouseMovement_IndexVersion
    , Key_IndexVersion
    , WordsTyped_IndexVersion
    , MouseMovement_Number
    , WordsPerTime_Number
    , RootDirectory
    , KeyDirectory
    , MouseMovementDirectory
    , WordDirectory
    , Ptr
    
    Static MCodedData
    , CountKeysUniversal
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountKeysUniversalHex =
            (LTrim Join
                4533C94C8BD24983F801754E418BD1458BC1493BCA0F8354010000498BC2482BC148
                83F8027C1F4D8D5AFF0F1F4400000FB6014883C1024803D00FB641FF4C03C0493BCB
                7CEA493BCA7304440FB609498D04104C03C8498BC1C34983F802755A4D8BC14D8BD9
                483BCA0F8300010000488BC2482BC148FFC04899482BC248D1F84883F8027C20498D
                52FE660F1F4400000FB7014883C1044C03C00FB741FE4C03D8483BCA7CEA493BCA73
                04440FB7094B8D04034C03C8498BC1C34983F80475574D8BC14D8BD9483BCA0F83A0
                000000488BC2482BC14883C003489983E2034803C248C1F8024883F8027C19498D52
                FC908B014883C1084C03C08B41FC4C03D8483BCA7CEC493BCA7303448B094B8D0403
                4C03C8498BC1C34983F80875524D8BC14D8BD9483BCA7347488BC2482BC14883C007
                489983E2074803C248C1F8034883F8027C1C498D42F80F1F8400000000004C03014C
                0359084883C110483BC87CF0493BCA73034C8B094B8D0C034C03C9498BC1C3
            )
        } Else {
            CountKeysUniversalHex =
            (LTrim Join
                83EC088B4424148B4C241853555633F657897424108974241483F80175563BCE7552
                8B4C241C8B44242033DB33ED33FF3BC80F83690100002BC183F8027C1E900FB60199
                03D80FB6410113EA9903F08B44242013FA83C102483BC87CE33B4C24200F832E0100
                000FB6019989542414E91D01000083F802755D3BCE75598B4C241C8B44242033DB33
                ED33FF3BC80F830E0100002BC140992BC2D1F883F8027C1F0FB7019903D80FB74102
                13EA9903F08B44242013FA83C10483C0FE3BC87CE13B4C24200F83CC0000000FB701
                9989542414E9BB00000083F80475593BCE75558B4C241C8B44242033DB33ED33FF3B
                C80F83AC0000002BC183C0039983E20303C2C1F80283F8027C1A8B44242083C0FC90
                031983D50003710483D70083C1083BC87CEE3B4C2420736D8B01C744241400000000
                EB5D83F80875683BCE75648B4C241C8B44242033DB33ED33FF3BC873522BC183C007
                9983E20703C2C1F80383F8027C208B44242083C0F88DA42400000000031913690403
                710813790C83C1103BC87CEE3B4C2420730D8B018B4904894C24148944241003F313
                FD01742410117C24148B4424108B5424145F5E5D5B83C408C3
            )
        }
        
        VarSetCapacity(CountKeysUniversal, StrLen(CountKeysUniversalHex) // 2)
        Loop % StrLen(CountKeysUniversalHex) // 2
            NumPut("0x" . SubStr(CountKeysUniversalHex, 2 * A_Index - 1, 2), CountKeysUniversal, A_Index - 1, "Char")
        
        CountKeysUniversalHex := ""
        , DllCall("VirtualProtect", Ptr, &CountKeysUniversal, Ptr, VarSetCapacity(CountKeysUniversal), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    If _Which Is Number
    {
        FKeyDirectory := KeyDirectory
    }
    Else
    {
        FKeyDirectory := SubStr(_Which, 1, InStr(_Which, "\", False, 0) - 1)
        _Which := SubStr(_Which, InStr(_Which, " ", False, 0) + 1)
    }
    
    If (_Data = 12345){
        H := ELP_OpenFileHandle(FKeyDirectory . "\Indexes\Key " . _Which . ".index", "Read", IndexFileSize)
        
        If (H = -1)
            Return -3
        Else If (IndexFileSize = 0){
            ELP_CloseFileHandle(H)
            Return -4
        }
        
        VarSetCapacity(Internal_IndexData, IndexFileSize, 0)
        , ELP_ReadData(H, &Internal_IndexData, IndexFileSize)
        , ELP_CloseFileHandle(H)
        , I_Address := &Internal_IndexData
    } Else
        I_Address := &_Data
    
    If (_VerifyIndex){
        I_Version := NumGet(I_Address+0, 0, "Double")
        , I_ID := NumGet(I_Address+0, 8, "Int64")
        , I_StartOffset := NumGet(I_Address+0, 16, "Int64")
        
        If (I_Version != Key_IndexVersion)
            RR := -5
        Else If (I_ID != _Which)
            RR := -6
        Else If (I_StartOffset != 0)
            RR := -7
        
        If (RR){
            VarSetCapacity(Internal_IndexData, IndexFileSize, 0)
            VarSetCapacity(Internal_IndexData, 0)
            
            Return RR
        }
    }
    
    I_StorageType := NumGet(I_Address+0, 90, "Int64")
    , I_StartDate := NumGet(I_Address+0, 98, "Int64")
    , I_EndDate := NumGet(I_Address+0, 106, "Int64")
    , I_DataLength := NumGet(I_Address+0, 114, "Int64")
    
    If (I_StorageType = 1)
        VarType := "UChar"
    Else If (I_StorageType = 2)
        VarType := "UShort"
    Else If (I_StorageType = 4)
        VarType := "UInt"
    Else If (I_StorageType = 8)
        VarType := "Int64"
    
    Start_Difference := DateDifference(_StartDate, I_StartDate, 1) * I_StorageType
    , End_Difference := DateDifference(_EndDate, I_StartDate, 1) * I_StorageType
    
    If (End_Difference < 0)
        Return 0
    Else If (End_Difference > I_DataLength)
        End_Difference := I_DataLength
    
    If (Start_Difference < 0)
        Start_Difference := 0
    
    I := I_Address + 122 + Start_Difference
    , End_Difference += I_Address + 122
    
    ; Makes the date range inclusive on both ends instead of exclusive on the end date
    If ((End_Difference + 8) <= (I_Address + 122 + I_DataLength))
        End_Difference += 8
    
    Count := DllCall(&CountKeysUniversal, Ptr, I, Ptr, End_Difference, "Int64", I_StorageType, "cdecl int64")
    
    If (_Data = 12345){
        VarSetCapacity(Internal_IndexData, IndexFileSize, 0)
        , VarSetCapacity(Internal_IndexData, 0)
    }
    
    Return Count
}


Read_MouseIndex(_IndexLocation, _WhichMon, _GetType, _StartDate, _EndDate, ByRef _Data = 12345, _VerifyIndex = 1)
{
    Global Package_FileVersion
    , Pixel_FileVersion
    , Save_FileVersion
    , MouseMovement_IndexVersion
    , Key_IndexVersion
    , WordsTyped_IndexVersion
    , MouseMovement_Number
    , WordsPerTime_Number
    , RootDirectory
    , KeyDirectory
    , MouseMovementDirectory
    , WordDirectory
    , Ptr
    
    Static MCodedData
    , CountPixelsMovedIndex
    , CountInchesMovedIndex
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountPixelsMovedIndexHex =
            (LTrim Join
                4533C04C8BDA458BC8458BD0483BCA734F488BC2482BC14883C00F489983E20F4803
                C248C1F8044883F8027C23498D43F0666666666666660F1F8400000000004C03014C
                0349104883C120483BC87CF0493BCB73034C8B114B8D04014903C2C3498BC0C3
            )

            CountInchesMovedIndexHex =
            (LTrim Join
                660F57C04883C1084C8BC2483BCA734E488BC2482BC14883C00F489983E20F4803C2
                48C1F8044883F8047C20498D40D0F20F58014883C140F20F5841D0F20F5841E0F20F
                5841F0483BC87CE4493BC8730DF20F58014883C110493BC872F3F3C3
            )
        } Else {
            CountPixelsMovedIndexHex =
            (LTrim Join
                83EC088B4C240C5355565733C033D233DB33ED33F633FF89442410895424143B4C24
                20735F8B4424202BC183C00F9983E20F03C2C1F80483F8027C198B44242083C0F003
                1913690403711013791483C1203BC87CEE3B4C242073178B018B490403F313FD03C6
                13CF5F5E5D8BD15B83C408C38B4424108B4C241403F313FD03C613CF8BD15F5E5D5B
                83C408C3
            )

            CountInchesMovedIndexHex =
            (LTrim Join
                8B4C2404D9EE568B74240C83C1083BCE73378BC62BC183C00F9983E20F03C2C1F804
                83F8047C158D46D0DC0183C140DC41D0DC41E0DC41F03BC87CEE3BCE7309DC0183C1
                103BCE72F75EC3
            )
        }
        
        VarSetCapacity(CountPixelsMovedIndex, StrLen(CountPixelsMovedIndexHex) // 2)
        Loop % StrLen(CountPixelsMovedIndexHex) // 2
            NumPut("0x" . SubStr(CountPixelsMovedIndexHex, 2 * A_Index - 1, 2), CountPixelsMovedIndex, A_Index - 1, "Char")
        
        VarSetCapacity(CountInchesMovedIndex, StrLen(CountInchesMovedIndexHex) // 2)
        Loop % StrLen(CountInchesMovedIndexHex) // 2
            NumPut("0x" . SubStr(CountInchesMovedIndexHex, 2 * A_Index - 1, 2), CountInchesMovedIndex, A_Index - 1, "Char")
        
        CountPixelsMovedIndexHex := ""
        , CountInchesMovedIndexHex := ""
        , DllCall("VirtualProtect", Ptr, &CountPixelsMovedIndex, Ptr, VarSetCapacity(CountPixelsMovedIndex), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &CountInchesMovedIndex, Ptr, VarSetCapacity(CountInchesMovedIndex), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    If (_IndexLocation = "")
        Return -1.1
    
    If (_WhichMon != "All")
    {
        If _WhichMon Is Not Number
            Return -1
    }
    
    If (_GetType != "Pixels" And _GetType != "Inches")
        Return -2
    
    If (_Data = 12345)
    {
        If (_VerifyIndex)
        {
            H := ELP_OpenFileHandle(_IndexLocation "\Index\Mouse movement data indexes.metadata", "Read", IndexMetaData_FileSize)
            
            If (H = -1)
                Return -3
            Else If (IndexMetaData_FileSize = 0){
                ELP_CloseFileHandle(H)
                Return -4
            }
            
            VarSetCapacity(Internal_IndexMetaData, IndexMetaData_FileSize, 0)
            , ELP_ReadData(H, &Internal_IndexMetaData, IndexMetaData_FileSize)
            , ELP_CloseFileHandle(H)
            
            , I_Version := NumGet(Internal_IndexMetaData, 0, "Double")
            , I_ID := NumGet(Internal_IndexMetaData, 8, "Int64")
            , I_StartOffset := NumGet(Internal_IndexMetaData, 16, "Int64")
            , I_MonNumbers := NumGet(Internal_IndexMetaData, 90, "Int64")
            
            If (I_Version != MouseMovement_IndexVersion)
                RR := -5
            Else If (I_ID != MouseMovement_Number)
                RR := -6
            Else If (I_StartOffset != 8)
                RR := -7
            
            If (!RR){
                MonFile_Exists := False
                
                Loop, % I_MonNumbers
                {
                    Mon_ID := NumGet(Internal_IndexMetaData, 98 + ((A_Index - 1) * 8), "Int64")
                    
                    If (_WhichMon = "All")
                        All_MonIDs .= All_MonIDs = "" ? Mon_ID : "`n" Mon_ID
                    Else If (Mon_ID = _WhichMon)
                    {
                        MonFile_Exists := True
                        Break
                    }
                }
            }
            
            VarSetCapacity(Internal_IndexMetaData, IndexMetaData_FileSize, 0)
            , VarSetCapacity(Internal_IndexMetaData, 0)
            
            If (RR)
                Return RR
            
            If (_WhichMon = "All")
                Return All_MonIDs
            
            If (!MonFile_Exists)
                Return -8
        }
        
        H := ELP_OpenFileHandle(_IndexLocation . "\Index\Mouse movement data " . _WhichMon . ".index", "Read", IndexData_FileSize)
            
        If (H = -1)
            Return -9
        Else If (IndexData_FileSize = 0){
            ELP_CloseFileHandle(H)
            Return -10
        }
        
        VarSetCapacity(Internal_IndexData, IndexData_FileSize, 0)
        , ELP_ReadData(H, &Internal_IndexData, IndexData_FileSize)
        , ELP_CloseFileHandle(H)
        , I_Address := &Internal_IndexData
    } Else
        I_Address := &_Data
    
    I_StartDate := NumGet(I_Address+0, 0, "Int64")
    , I_EndDate := NumGet(I_Address+0, 8, "Int64")
    
    I_DataLength := I_EndDate
    I_DataLength -= I_StartDate, Seconds
    I_DataLength := (I_DataLength // 60) * 16 + 16
    
    , Start_Difference := DateDifference(_StartDate, I_StartDate, 1) * 16
    , End_Difference := DateDifference(_EndDate, I_StartDate, 1) * 16
    
    If (End_Difference < 0)
        Return 0
    Else If (End_Difference > I_DataLength)
        End_Difference := I_DataLength - 16
    
    If (Start_Difference < 0)
        Start_Difference := 0
    
    Start_Difference += I_Address + 16
    , End_Difference += I_Address + 16
    
    ; Makes the date range inclusive on both ends instead of exclusive on the end date
    If ((End_Difference + 16) <= (I_Address + I_DataLength))
        End_Difference += 16
    
    If (_GetType = "Pixels")
        Count := DllCall(&CountPixelsMovedIndex, Ptr, Start_Difference, Ptr, End_Difference, "cdecl int64")
    Else If (_GetType = "Inches")
        Count := DllCall(&CountInchesMovedIndex, Ptr, Start_Difference, Ptr, End_Difference, "cdecl double")
    
    If (_Data = 12345){
        VarSetCapacity(Internal_IndexData, IndexData_FileSize, 0)
        , VarSetCapacity(Internal_IndexData, 0)
    }
    
    Return Count
}


Read_WordsIndex(_WhichIndex, _Which, _StartDate, _EndDate, ByRef _PData = 12345, ByRef _DData = 12345, _VerifyIndex = 1)
{
    Global Package_FileVersion
    , Pixel_FileVersion
    , Save_FileVersion
    , MouseMovement_IndexVersion
    , Key_IndexVersion
    , WordsTyped_IndexVersion
    , MouseMovement_Number
    , WordsPerTime_Number
    , RootDirectory
    , KeyDirectory
    , MouseMovementDirectory
    , WordDirectory
    , Ptr
    
    Static MCodedData
    , PPointersOffset := 114
    , CountWordsLengths
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            CountWordsLengthsHex =
            (LTrim Join
                4533C04C8BDA458BC8458BD0483BCA734F488BC2482BC14883C007489983E2074803
                C248C1F8034883F8027C23498D43F8666666666666660F1F8400000000004C03014C
                0349084883C110483BC87CF0493BCB73034C8B114B8D04014903C2C3498BC0C3
            )
        } Else {
            CountWordsLengthsHex =
            (LTrim Join
                83EC088B4C240C5355565733C033D233DB33ED33F633FF89442410895424143B4C24
                20735F8B4424202BC183C0079983E20703C2C1F80383F8027C198B44242083C0F803
                1913690403710813790C83C1103BC87CEE3B4C242073178B018B490403F313FD03C6
                13CF5F5E5D8BD15B83C408C38B4424108B4C241403F313FD03C613CF8BD15F5E5D5B
                83C408C3
            )
        }
        
        VarSetCapacity(CountWordsLengths, StrLen(CountWordsLengthsHex) // 2)
        Loop % StrLen(CountWordsLengthsHex) // 2
            NumPut("0x" . SubStr(CountWordsLengthsHex, 2 * A_Index - 1, 2), CountWordsLengths, A_Index - 1, "Char")
        
        CountWordsLengthsHex := ""
        , DllCall("VirtualProtect", Ptr, &CountWordsLengths, Ptr, VarSetCapacity(CountWordsLengths), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    If (_Which != "Count" And _Which != "Lengths")
        Return -1
    
    H := ELP_OpenFileHandle(_WhichIndex "\Words per time data", "Read", WPTDataFileSize)
    
    If (H = -1)
        Return -2
    
    VarSetCapacity(IndexDataRaw, WPTDataFileSize, 0)
    , ELP_ReadData(H, &IndexDataRaw, WPTDataFileSize)
    , ELP_CloseFileHandle(H)
    
    _EndDate += 1, Minutes
    
    If (_Which = "Count")
        Count := CountTodaysWordsTyped(&IndexDataRaw, WPTDataFileSize, _StartDate . 000, _EndDate . 000)
    Else If (_Which = "Lengths")
        Count := CountTodaysWordsTyped(&IndexDataRaw, WPTDataFileSize, _StartDate . 000, _EndDate . 000, 1)
    
    
    Return Count
    
    /*
    If (_PData = 12345){
        H := ELP_OpenFileHandle(_WhichIndex "\Indexes\Words per time data pointers.index", "Read", IndexPointers_FileSize)
        
        If (H = -1)
            Return -2
        Else If (IndexPointers_FileSize = 0){
            ELP_CloseFileHandle(H)
            Return -3
        }
        
        VarSetCapacity(Internal_IndexPointers, IndexPointers_FileSize, 0)
        , ELP_ReadData(H, &Internal_IndexPointers, IndexPointers_FileSize)
        , ELP_CloseFileHandle(H)
        
        If (_VerifyIndex){
            I_Version := NumGet(Internal_IndexPointers, 0, "Double")
            , I_ID := NumGet(Internal_IndexPointers, 8, "Int64")
            , I_StartOffset := NumGet(Internal_IndexPointers, 16, "Int64")
            
            If (I_Version != WordsTyped_IndexVersion)
                RR := -4
            Else If (I_ID != WordsPerTime_Number)
                RR := -5
            Else If (I_StartOffset != 0)
                RR := -6
        }
        
        If (RR){
            VarSetCapacity(Internal_IndexPointers, IndexPointers_FileSize, 0)
            , VarSetCapacity(Internal_IndexPointers, 0)
            
            Return RR
        }
        
        I_PAddress := &Internal_IndexPointers
    } Else
        I_PAddress := &_PData
    
    If (_DData = 12345){
        H := ELP_OpenFileHandle(_WhichIndex "\Indexes\Words per time data data.index", "Read", IndexData_FileSize)
        
        If (H = -1)
            Return -7
        Else If (IndexData_FileSize = 0){
            ELP_CloseFileHandle(H)
            Return -8
        }
        
        VarSetCapacity(Internal_IndexData, IndexData_FileSize, 0)
        , ELP_ReadData(H, &Internal_IndexData, IndexData_FileSize)
        , ELP_CloseFileHandle(H)
        , I_DAddress := &Internal_IndexData
    } Else
        I_DAddress := &_DData
    
    
    I_StartDate := NumGet(I_PAddress+0, 90, "Int64")
    , I_EndDate := NumGet(I_PAddress+0, 98, "Int64")
    
    
    , I_PDataLength := NumGet(I_PAddress+0, PPointersOffset - 8, "Int64")
    , I_DDataLength := NumGet(I_PAddress+0, PPointersOffset + I_PDataLength - 16, "Int64")
    
    , I_DDataLength += NumGet(I_PAddress+0, PPointersOffset + I_PDataLength - 8, "Int64") * 8
    
    , Start_Difference := DateDifference(_StartDate, I_StartDate, 1) * 16
    , End_Difference := DateDifference(_EndDate, I_StartDate, 1) * 16
    
    If (End_Difference < 0)
        Return 0
    Else If (End_Difference > I_PDataLength)
        End_Difference := I_PDataLength - 16
    
    If (Start_Difference < 0)
        Start_Difference := 0
    
    
    Start_Difference := I_DAddress + NumGet(I_PAddress+0, PPointersOffset + Start_Difference, "Int64")
    , I := I_DAddress + NumGet(I_PAddress+0, PPointersOffset + End_Difference, "Int64")
    End_Difference := I + (NumGet(I_PAddress+0, PPointersOffset + End_Difference + 8, "Int64") * 8)
    
    ;MsgBox % I_DAddress "`n" Start_Difference "`n" End_Difference "`n" I "`n`n" I_DDataLength "`n" IndexData_FileSize
    
    If (End_Difference > (I_DAddress + I_DDataLength)) ;Just to prevent corrupt data from crashing the script
        End_Difference := I_DAddress + I_DDataLength
    
    If (_Which = "Count"){
        Count := (End_Difference - Start_Difference) // 8
    } Else If (_Which = "Lengths")
        Count := DllCall(&CountWordsLengths, Ptr, Start_Difference, Ptr, End_Difference, "cdecl int64")
    
    /*
    If (_GetType = "Pixels")
        Count := DllCall(&CountPixelsMovedIndex, Ptr, Start_Difference, Ptr, End_Difference, "cdecl int64")
    Else If (_GetType = "Inches")
        Count := DllCall(&CountInchesMovedIndex, Ptr, Start_Difference, Ptr, End_Difference, "cdecl double")
    */
    
    /*
    If (_DData = 12345){
        VarSetCapacity(Internal_IndexData, IndexData_FileSize, 0)
        , VarSetCapacity(Internal_IndexData, 0)
    }
    
    If (_PData = 12345){
        VarSetCapacity(Internal_IndexPointers, IndexPointers_FileSize, 0)
        , VarSetCapacity(Internal_IndexPointers, 0)
    }
    
    Return Count
    */
}


Validate_KeyIndex(_Key, _LogAll = "", _Validate = 0)
{
    Global RootDirectory
    , KeyDirectory
    , MouseMovementDirectory
    , WordDirectory
    , Key_IndexVersion
    , Ptr
    
    If (InStr(_Key, "\"))
    {
        FFullPath := _Key
        , FDirectory := SubStr(_Key, 1, InStr(_Key, "\", False, 0)-1)
        , _Key := SubStr(_Key, InStr(_Key, " ", False, 0)+1)
    } Else
        FDirectory := KeyDirectory
    
    ELP_FileCreateDirectory(FDirectory . "\Indexes")
    
    
    If (_Validate And FFullPath)
        VerifyStoredData(FFullPath, 0)
    
    IndexOffset := 0
    , H := ELP_OpenFileHandle(FDirectory "\Indexes\Key " _Key ".index", "Read", IndexFileSize)
    
    If (IndexFileSize != 0){
        VarSetCapacity(IndexData, 122, 0) ;8+8+8+8+8+50+8+8+8+8
        , VarSetCapacity(IndexEntry_LastEntry, 8, 0)
        
        , ELP_ReadData(H, &IndexData, 122) ;8+8+8+8+8+50+8+8+8+8
        , ELP_SetFilePointer(H, IndexFileSize-8)
        , ELP_ReadData(H, &IndexEntry_LastEntry, 8)
        , ELP_CloseFileHandle(H)
        
        , FileVersion := NumGet(IndexData, IndexOffset, "Double")
        , IndexOffset += 8
        , IDNumber := NumGet(IndexData, IndexOffset, "Int64")
        , IndexOffset += 8
        , IsCompatible := False
        
        If (FileVersion = Key_IndexVersion)
            IsCompatible := True
        
        
        If (!IsCompatible Or IDNumber != _Key){
            VarSetCapacity(IndexData, 122, 0) ;8+8+8+8+8+50+8+8+8+8
            , VarSetCapacity(IndexData, 0)
            , VarSetCapacity(IndexEntry_LastEntry, 8, 0)
            , VarSetCapacity(IndexEntry_LastEntry, 0)
            , IndexOffset := 0
            
            , ELP_FileDelete(FDirectory . "\Indexes\Key " . _Key . ".index", 1, 0)
        }
    } Else {
        ELP_CloseFileHandle(H)
    }
    
    H := ELP_OpenFileHandle(FDirectory . "\Key " . _Key, "Read", KeyFileSize)
    
    If (KeyFileSize != 0){
        VarSetCapacity(KeyData, KeyFileSize, 0)
        , ELP_ReadData(H, &KeyData, KeyFileSize)
        , ELP_CloseFileHandle(H)
        
        
        If (IsCompatible){
            IndexEntry_StartOffset := NumGet(IndexData, IndexOffset, "Int64")
            
            If (IndexEntry_StartOffset = 0){
                IndexOffset += 8
                , IndexEntry_EndOffset := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_MD5HashLength := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset += 8
                
                
                Loop, % IndexEntry_MD5HashLength
                    IndexEntry_MD5Hash .= NumGet(IndexData, IndexOffset++, "UChar")
                
                IndexOffset += 50 - IndexEntry_MD5HashLength
                , IndexData_DataType := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_StartDate := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_EndDate := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_Length := NumGet(IndexData, IndexOffset, "Int64")
                , IndexOffset := 0
                , VarSize := IndexData_DataType
                
                If (VarSize = 1)
                    VarType := "UChar"
                Else If (VarSize = 2)
                    VarType := "UShort"
                Else If (VarSize = 4)
                    VarType := "UInt"
                Else If (VarSize = 8)
                    VarType := "Int64"
                
                IndexEntry_LastEntry := NumGet(IndexEntry_LastEntry, 8-IndexData_DataType, VarType)
                , NewMD5Hash := ELP_CalcMD5(&KeyData, IndexEntry_EndOffset)
                
                If (NewMD5Hash . "" != IndexEntry_MD5Hash . "") ; . "" forces a string comparison else they both overflow int max and compare true when they're different
                {
                    IsCompatible := False
                    
                    , ELP_FileDelete(FDirectory . "\Indexes\Key " _Key . ".index", 1, 0)
                }
                
            } Else {
                
                IndexOffset := 0
                , IndexEntry_StartOffset := ""
                , IsCompatible := False
                
                , ELP_FileDelete(FDirectory . "\Indexes\Key " . _Key . ".index", 1, 0)
            }
            
            VarSetCapacity(IndexData, 122, 0) ;8+8+8+8+8+50+8+8+8+8
            , VarSetCapacity(IndexData, 0)
            
            If (IsCompatible){
                PartDataSize := KeyFileSize - IndexEntry_EndOffset
                
                
                If (PartDataSize = 0){
                    VarSetCapacity(KeyData, KeyFileSize, 0)
                    , VarSetCapacity(KeyData, 0)
                    
                    Return
                }
                
                VarSetCapacity(PartKeyData, PartDataSize, 0)
                , DllCall("RtlMoveMemory", Ptr, &PartKeyData, Ptr, &KeyData+IndexEntry_EndOffset, "UInt", PartDataSize)
                , New_IndexDataAddress := Index_KeyData(&PartKeyData, PartDataSize, 0, VarType, 1)
                , VarSetCapacity(PartKeyData, PartDataSize, 0)
                , VarSetCapacity(PartKeyData, 0)
                
                
                If (New_IndexDataAddress = "Awwww snap!"){
                    IsCompatible := False
                    
                    , ELP_FileDelete(FDirectory . "\Indexes\Key " . _Key . ".index", 1, 0)
                } Else {
                    New_IndexDataAddress := SubStr(New_IndexDataAddress, 1, InStr(New_IndexDataAddress, "|")-1)
                    
                    , KeyData_MD5Hash := ELP_CalcMD5(&KeyData, KeyFileSize)
                    , New_IndexStartDate := NumGet(New_IndexDataAddress+0, 0, "Int64")
                    , New_IndexEndDate := NumGet(New_IndexDataAddress+0, 8, "Int64")
                    , New_IndexDataLength := NumGet(New_IndexDataAddress+0, 16, "Int64")
                    
                    
                    If (New_IndexStartDate < IndexEntry_EndDate){ ;If the start date is before the end date
                        Data_OldestDate := IndexEntry_StartDate < New_IndexStartDate ? IndexEntry_StartDate : New_IndexStartDate
                        , Data_NewestDate := IndexEntry_EndDate > New_IndexEndDate ? IndexEntry_EndDate : New_IndexEndDate
                        
                        , Difference := Data_NewestDate
                        Difference -= Data_OldestDate, Seconds
                        Difference := (Difference // 60) + 1
                        
                        
                        Combined_IndexDataLength := (Difference * VarSize) + 24 ;8 + 8 + 8
                        , VarSetCapacity(Combined_IndexData, Combined_IndexDataLength, 0)
                        , NumPut(Data_OldestDate, Combined_IndexData, 0, "Int64")
                        , NumPut(Data_NewestDate, Combined_IndexData, 8, "Int64")
                        , NumPut(Combined_IndexDataLength - 24, Combined_IndexData, 16, "Int64") ;8 - 8 - 8
                        
                        
                        H := ELP_OpenFileHandle(FDirectory "\Indexes\Key " _Key ".index", "Read")
                        , ELP_SetFilePointer(H, 122) ;8+8+8+8+8+50+8+8+8+8
                        , VarSetCapacity(Current_IndexData, IndexEntry_Length, 0)
                        , ELP_ReadData(H, &Current_IndexData, IndexEntry_Length)
                        , ELP_CloseFileHandle(H)
                        
                        , Difference_CurrentIndex := IndexEntry_StartDate
                        Difference_CurrentIndex -= Data_OldestDate, Seconds
                        Difference_CurrentIndex := (Difference_CurrentIndex // 60) * VarSize
                        
                        
                        DllCall("RtlMoveMemory", Ptr, &Combined_IndexData + 24 + Difference_CurrentIndex, Ptr, &Current_IndexData, "UInt", IndexEntry_Length)
                        , VarSetCapacity(Current_IndexData, IndexEntry_Length, 0)
                        , VarSetCapacity(Current_IndexData, 0)
                        
                        , Difference_NewIndex := New_IndexStartDate
                        Difference_NewIndex -= Data_OldestDate, Seconds
                        Difference_NewIndex := (Difference_NewIndex // 60) * VarSize
                        
                        
                        E := Merge_KeyData(&Combined_IndexData + 24 + Difference_NewIndex, New_IndexDataAddress + 24, New_IndexDataLength, VarSize)
                        , Index_KeyData(0, 0, 1) ;Erases the index data stored in the functions static variable
                        
                        If (!E){
                            H := ELP_OpenFileHandle(FDirectory . "\Indexes\Key " . _Key . ".index", "Write")
                            , VarSetCapacity(NewIndexMetaData, 66, 0) ;8+8+50
                            , NewIndexMetaDataOffset := 0
                            , NumPut(KeyFileSize, NewIndexMetaData, NewIndexMetaDataOffset, "Int64")
                            , NewIndexMetaDataOffset += 8
                            , NumPut(StrLen(KeyData_MD5Hash), NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New MD5HashLength for the index file
                            , NewIndexMetaDataOffset += 8
                            
                            
                            Loop, Parse, KeyData_MD5Hash ;New MD5 hash for the index file
                                NumPut(A_LoopField, NewIndexMetaData, NewIndexMetaDataOffset++, "UChar")
                            
                            NewIndexMetaDataOffset += 50 - StrLen(KeyData_MD5Hash)
                            , ELP_SetFilePointer(H, 24) ;8+8+8
                            , ELP_WriteData(H, &NewIndexMetaData, NewIndexMetaDataOffset)

                            , ELP_SetFilePointer(H, 98) ;8+8+8+8+8+50+8
                            , ELP_WriteData(H, &Combined_IndexData, Combined_IndexDataLength)
                            , ELP_CloseFileHandle(H)
                        }
                        
                        VarSetCapacity(Combined_IndexData, Combined_IndexDataLength, 0)
                        , VarSetCapacity(Combined_IndexData, 0)
                    
                        If (E){
                            IsCompatible := False
                            
                            
                            ELP_FileDelete(FDirectory . "\Indexes\Key " . _Key . ".index", 1, 0)
                        }
                    } Else {
                        H := ELP_OpenFileHandle(FDirectory "\Indexes\Key " _Key ".index", "Write", IndexFileSize)
                        
                        If (New_IndexStartDate != IndexEntry_EndDate){ ;Accounts for gaps between the last end date index data and the new index data start date
                            Difference_Minutes := DateDifference(New_IndexStartDate, IndexEntry_EndDate)
                            
                            
                            If (Difference_Minutes > 1){
                                Difference_Minutes -= 1
                                , New_IndexDataLength += Difference_Minutes * VarSize
                                , VarSetCapacity(BlankIndexData, Difference_Minutes * VarSize, 0)
                                
                                , ELP_SetFilePointer(H, IndexFileSize)
                                , ELP_WriteData(H, &BlankIndexData, Difference_Minutes * VarSize)
                                , VarSetCapacity(BlankIndexData, Difference_Minutes * VarSize, 0)
                                , VarSetCapacity(BlankIndexData, 0)
                                , IndexFileSize += Difference_Minutes * VarSize
                                
                            }
                        }
                        
                        VarSetCapacity(NewIndexMetaData, 98, 0) ;8+8+50+8+8+8+8
                        , NewIndexMetaDataOffset := 0
                        , NumPut(KeyFileSize, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New EndOffset for the index file
                        , NewIndexMetaDataOffset += 8
                        , NumPut(StrLen(KeyData_MD5Hash), NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New MD5HashLength for the index file
                        , NewIndexMetaDataOffset += 8
                        
                        Loop, Parse, KeyData_MD5Hash ;New MD5 hash for the index file
                            NumPut(A_LoopField, NewIndexMetaData, NewIndexMetaDataOffset++, "UChar")
                        
                        NewIndexMetaDataOffset += 50 - StrLen(KeyData_MD5Hash)
                        , NumPut(VarSize, NewIndexMetaData, NewIndexMetaDataOffset, "Int64")
                        , NewIndexMetaDataOffset += 8
                        , NumPut(IndexEntry_StartDate, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New StartDate for the index file
                        , NewIndexMetaDataOffset += 8
                        , NumPut(New_IndexEndDate, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New EndDate for the index file
                        , NewIndexMetaDataOffset += 8
                        , NumPut(New_IndexDataLength + IndexEntry_Length, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New Length for the index file
                        , NewIndexMetaDataOffset += 8
                        
                        
                        If (New_IndexStartDate = IndexEntry_EndDate){
                            New_Number := NumGet(New_IndexDataAddress+0, 24, VarType) + IndexEntry_LastEntry
                            
                            
                            If ((New_Number > 255 And VarSize = 1) Or (New_Number > 65535 And VarSize = 2) Or (New_Number > 4294967295 And VarSize = 4)){
                                ELP_CloseFileHandle(H)
                                , Index_KeyData(0, 0, 1)
                                , VarSetCapacity(NewIndexMetaData, 98, 0) ;8+8+50+8+8+8+8
                                , VarSetCapacity(NewIndexMetaData, 0)
                                , IsCompatible := False
                                
                                , ELP_FileDelete(FDirectory . "\Indexes\Key " . _Key . ".index", 1, 0)
                            } Else {
                                NumPut(New_Number, New_IndexDataAddress+0, 24, VarType)
                                , NumPut(New_IndexDataLength + IndexEntry_Length - VarSize, NewIndexMetaData, NewIndexMetaDataOffset - 8, "Int64") ;New Length for the index file
                                , ELP_SetFilePointer(H, IndexFileSize - VarSize)
                                , ELP_WriteData(H, New_IndexDataAddress + 8 + 8 + 8, NumGet(New_IndexDataAddress+0, 16, "Int64"))
                            }
                        } Else {
                            
                            ELP_SetFilePointer(H, IndexFileSize)
                            , ELP_WriteData(H, New_IndexDataAddress + 24, NumGet(New_IndexDataAddress+0, 16, "Int64")) ;8 + 8 + 8
                        }
                        
                        If (IsCompatible){
                            
                            ELP_SetFilePointer(H, 24) ;8 + 8 + 8
                            , ELP_WriteData(H, &NewIndexMetaData, NewIndexMetaDataOffset)
                            , VarSetCapacity(NewIndexMetaData, NewIndexMetaDataOffset, 0)
                            , VarSetCapacity(NewIndexMetaData, 0)
                            , Index_KeyData(0, 0, 1) ;Erases the index data stored in the functions static variable
                            , ELP_CloseFileHandle(H)
                        }
                    }
                }
            }
            
            VarSetCapacity(KeyData, KeyFileSize, 0)
            , VarSetCapacity(KeyData, 0)
        } Else {
            Data_Loaded := True
        }
        
        If (!IsCompatible){
            If (!Data_Loaded){
                H := ELP_OpenFileHandle(FDirectory . "\Key " . _Key, "Read", KeyFileSize)
                
                If (KeyFileSize != 0){
                }
            
                VarSetCapacity(KeyData, KeyFileSize, 0)
                , ELP_ReadData(H, &KeyData, KeyFileSize)
                , ELP_CloseFileHandle(H)
                
            }
            
            KeyData_MD5Hash := ELP_CalcMD5(&KeyData, KeyFileSize)
            , New_IndexDataAddress := Index_KeyData(&KeyData, KeyFileSize)
            
            
            VarSize := SubStr(New_IndexDataAddress, InStr(New_IndexDataAddress, "|")+1)
            , New_IndexDataAddress := SubStr(New_IndexDataAddress, 1, InStr(New_IndexDataAddress, "|")-1)
            , H := ELP_OpenFileHandle(FDirectory "\Indexes\Key " _Key ".index", "Write", IndexFileSize)
            
            
            VarSetCapacity(IndexMetaData, 98, 0) ;8+8+8+8+8+50+8
            , IndexMetaDataOffset := 0
            , NumPut(Key_IndexVersion, IndexMetaData, IndexMetaDataOffset, "Double") ;Key_IndexVersion for the index file
            , IndexMetaDataOffset += 8
            , NumPut(_Key, IndexMetaData, IndexMetaDataOffset, "Int64") ;ID number of the key for the index file
            , IndexMetaDataOffset += 8
            , NumPut(0, IndexMetaData, IndexMetaDataOffset, "Int64") ;StartOffset for the index file
            , IndexMetaDataOffset += 8
            , NumPut(KeyFileSize, IndexMetaData, IndexMetaDataOffset, "Int64") ;EndOffset for the index file
            , IndexMetaDataOffset += 8
            , NumPut(StrLen(KeyData_MD5Hash), IndexMetaData, IndexMetaDataOffset, "Int64") ;MD5HashLength for the index file
            , IndexMetaDataOffset += 8
            
            Loop, Parse, KeyData_MD5Hash ;MD5 hash for the index file
                NumPut(A_LoopField, IndexMetaData, IndexMetaDataOffset++, "UChar")
            
            IndexMetaDataOffset += 50 - StrLen(KeyData_MD5Hash)
            , NumPut(VarSize, IndexMetaData, IndexMetaDataOffset, "Int64")
            , IndexMetaDataOffset += 8
            
            
            ELP_WriteData(H, &IndexMetaData, IndexMetaDataOffset)
            
            , VarSetCapacity(IndexMetaData, IndexMetaDataOffset, 0)
            , VarSetCapacity(IndexMetaData, 0)
            
            , ELP_SetFilePointer(H, IndexMetaDataOffset)
            , ELP_WriteData(H, New_IndexDataAddress, 24+NumGet(New_IndexDataAddress+0, 16, "Int64")) ;8+8+8
            , ELP_CloseFileHandle(H)
            
            , Index_KeyData(0, 0, 1) ;Erases the index data stored in the functions static variable
            
            VarSetCapacity(KeyData, KeyFileSize, 0)
            , VarSetCapacity(KeyData, 0)
        }
    } Else {
        ELP_CloseFileHandle(H)
        
        
        Return "Key file " . _Key . " not found or is 0 bytes in size."
    }
}

Merge_KeyData(_MergedData, _SourceData, _SourceDataLength, _VarSize)
{
    Global Ptr
    Static MCodedData
    , MergeKeyData
    , MergeKeyDataUChar
    , MergeKeyDataUShort
    , MergeKeyDataUInt
    , MergeKeyDataInt64
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            MergeKeyDataUCharHex =
            (LTrim Join
                EB1F440FB609440FB612438D040A3DFF0000007F144502CA44880A48FFC248FFC1493BC872DC33C0C3B80
                1000000C3
            )

            MergeKeyDataUShortHex =
            (LTrim Join
                EB23440FB709440FB712438D040A3DFFFF00007F18664503CA6644890A4883C2024883C102493BC872D83
                3C0C3B801000000C3
            )

            MergeKeyDataUIntHex =
            (LTrim Join
                EB17448B114403124183FAFF77134489124883C2044883C104493BC872E433C0C3B801000000C3
            )

            MergeKeyDataInt64Hex =
            (LTrim Join
                EB204C8B1148B8FFFFFFFFFFFFFF7F4C03124C3BD07F134C89124883C2084883C108493BC872DB33C0C3B
                801000000C3
            )
        } Else {
            MergeKeyDataUCharHex =
            (LTrim Join
                53568B74240C573B74241873248B4C24148A068A110FB6F80FB6DA03FB81FFFF0000007F1402C28801414
                63B74241872E033C05F5E33D25BC333C040EBF5
            )

            MergeKeyDataUShortHex =
            (LTrim Join
                53568B74240C573B74241873268B4424140FB70E0FB7108D3C0A81FFFFFF00007F1903CA66890883C6028
                3C0023B74241872DE33C05F5E33D25BC333C040EBF5
            )

            MergeKeyDataUIntHex =
            (LTrim Join
                8B542404563B542410731B8B44240C8B0A030883F9FF7714890883C20483C0043B54241072E933C033D25
                EC333C040EBF7
            )

            MergeKeyDataInt64Hex =
            (LTrim Join
                568B7424083B742410732E8B44240C8B1603108B4E0413480481F9FFFFFF7F7F1E7C0583FAFF771789108
                9480483C60883C0083B74241072D633C033D25EC333C040EBF7
            )
        }
        
        VarSetCapacity(MergeKeyDataUChar, StrLen(MergeKeyDataUCharHex)//2)
        Loop % StrLen(MergeKeyDataUCharHex)//2
            NumPut("0x" . SubStr(MergeKeyDataUCharHex, 2*A_Index-1, 2), MergeKeyDataUChar, A_Index-1, "Char")
        MergeKeyDataUCharHex := ""
        
        VarSetCapacity(MergeKeyDataUShort, StrLen(MergeKeyDataUShortHex)//2)
        Loop % StrLen(MergeKeyDataUShortHex)//2
            NumPut("0x" . SubStr(MergeKeyDataUShortHex, 2*A_Index-1, 2), MergeKeyDataUShort, A_Index-1, "Char")
        MergeKeyDataUShortHex := ""
        
        VarSetCapacity(MergeKeyDataUInt, StrLen(MergeKeyDataUIntHex)//2)
        Loop % StrLen(MergeKeyDataUIntHex)//2
            NumPut("0x" . SubStr(MergeKeyDataUIntHex, 2*A_Index-1, 2), MergeKeyDataUInt, A_Index-1, "Char")
        MergeKeyDataUIntHex := ""
        
        VarSetCapacity(MergeKeyDataInt64, StrLen(MergeKeyDataInt64Hex)//2)
        Loop % StrLen(MergeKeyDataInt64Hex)//2
            NumPut("0x" . SubStr(MergeKeyDataInt64Hex, 2*A_Index-1, 2), MergeKeyDataInt64, A_Index-1, "Char")
        MergeKeyDataInt64Hex := ""
        
        , DllCall("VirtualProtect", Ptr, &MergeKeyDataUChar, Ptr, VarSetCapacity(MergeKeyDataUChar), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &MergeKeyDataUShort, Ptr, VarSetCapacity(MergeKeyDataUShort), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &MergeKeyDataUInt, Ptr, VarSetCapacity(MergeKeyDataUInt), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &MergeKeyDataInt64, Ptr, VarSetCapacity(MergeKeyDataInt64), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    If (_VarSize = 1)
        MergeKeyData := &MergeKeyDataUChar
    Else If (_VarSize = 2)
        MergeKeyData := &MergeKeyDataUShort
    Else If (_VarSize = 4)
        MergeKeyData := &MergeKeyDataUInt
    Else If (_VarSize = 8)
        MergeKeyData := &MergeKeyDataInt64
    
    E := DllCall(MergeKeyData, Ptr, _SourceData, Ptr, _MergedData, Ptr, _SourceData+_SourceDataLength, "cdecl int64")
    
    Return E
}

Index_KeyData(_DataAddress, _DataLength, _BlankData = 0, _VarType = "UChar", _ReturnOnError = 0) ;new one
{
    Global Ptr
    Static LI64
    , IndexKeyDataUChar
    , IndexKeyDataUShort
    , IndexKeyDataUInt
    , IndexKeyDataSInt64
    , MCodedData = 0
    , Difference
    , IndexData
    , Last_VarSize
    
    If (_BlankData){
        VarSetCapacity(IndexData, 24+(Difference * Last_VarSize), 0) ;8+8+8
        , VarSetCapacity(IndexData, 0)
        , Difference := ""
        
        Return
    }
    
    
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            Hex_IndexKeyDataUChar =
            (LTrim Join
                48895C24104C894C242055565741544155415641574883EC60448BA424C00000004C8
                BD133C048B900D0ED902E00000048898424A00000004C8BFA48894C245048B900A0DB
                215D00000048B800E876481700000048894C241048B90070C9B28B00000048BD00B86
                4D94500000048894C242048B900282E8CD100000049BD0088526A7400000048894C24
                3048B900F81B1D0001000048BA00E092651701000048894C244048B9005840FBA2000
                0004532DB48894C243848B90040B743BA0000004533C948894C242848B90010A5D4E8
                0000004D8BF048894C2408488B8C24D000000048BB00AC23FC0600000048BF0076BE3
                70700000049B80018EE840600000048BE00E288C00600000048896C24484C896C2418
                48891424483BC80F840C010000483BCD0F8403010000493BCD0F84FA00000048BD005
                840FBA2000000483BCD0F84E700000048BD0040B743BA000000483BCD0F84D4000000
                48BD0010A5D4E8000000483BCD0F84C1000000483BCA0F84B800000048BA00A0DB215
                D000000483BCA0F84A000000048BA0070C9B28B000000483BCA0F848D00000048BA00
                282E8CD1000000483BCA747E48BA00F81B1D00010000483BCA746F48BA00D0ED902E0
                00000483BCA7556418BC425030000807D07FFC883C8FCFFC085C0753CB81F85EB5141
                F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA078BC2C1E
                81F03D069D290010000443BE27505488BD6EB17498BD0EB12488B9424B8000000EB08
                488BD3EB03488BD74C8BAC24C8000000488BAC24D8000000488BBC24E0000000488BB
                424E80000004D8B02498D5C0D004803DD4803DF4803DE4C398C24B80000000F8EBC01
                00004881C6A086010048B800E87648170000004881FEE0065A000F8E340100004881C
                78096980033F64881FF8085B50D0F8E1E0100004881C500CA9A3B33FF483BEA0F8E0C
                0100004803C8BD00CA9A3B483BC80F84D8000000483B4C24480F84CD000000483B4C2
                4180F84C2000000483B4C24380F84B7000000483B4C24280F84AC000000483B4C2408
                0F84A1000000483B0C240F8497000000483B4C24100F8480000000483B4C242074794
                83B4C24307472483B4C2440746B483B4C2450757A418BC425030000807D07FFC883C8
                FCFFC085C07543B81F85EB5141F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81
                F85EB5141F7ECC1FA078BC2C1E81F03D069D290010000443BE2750C48BA00E288C006
                000000EB3B48BA0018EE8406000000EB2F48BA00AC23FC06000000EB0A48BA0076BE3
                707000000483B0C247E13488BC848B800A0724E180900004C03E841FFC4498D440D00
                4803C54803C74803C64C3BC07D2D4C3BC37C284983F90174224180FBFF74614983C20
                841FEC34D3BD6720841B901000000EB034D8B024C3BC07CD348FF8424A00000004588
                1F488BD8488B8424A000000049FFC74532DB483B8424B80000000F8C44FEFFFF498BC
                2488B9C24A80000004883C460415F415E415D415C5F5E5DC3B801000000EBE1
            )
            
            Hex_IndexKeyDataUShort =
            (LTrim Join
                48895C24104C894C242055565741544155415641574883EC60448BA424C00000004C8
                BD133C048B900D0ED902E0000004C8BFA4D8BF048894C245048B900A0DB215D000000
                48BA00E876481700000048894C241048B90070C9B28B00000049BD00B864D94500000
                048894C242048B900282E8CD100000049B800E092651701000048894C243048B900F8
                1B1D0001000048898424A000000048894C244048B90088526A74000000440FB7D8488
                94C241848B9005840FBA2000000448BC848894C243848B90040B743BA00000048BB00
                18EE840600000048894C242848B90010A5D4E800000048BF00AC23FC0600000048894
                C2408488B8C24D000000048BE0076BE370700000048BD00E288C0060000004C896C24
                484C890424483BCA0F8416010000493BCD0F840D01000048BA0088526A74000000483
                BCA0F84FA00000048BA005840FBA2000000483BCA0F84E700000048BA0040B743BA00
                0000483BCA0F84D400000048BA0010A5D4E8000000483BCA0F84C1000000493BC80F8
                4B800000048BA00A0DB215D000000483BCA0F84A000000048BA0070C9B28B00000048
                3BCA0F848D00000048BA00282E8CD1000000483BCA747E48BA00F81B1D00010000483
                BCA746F48BA00D0ED902E000000483BCA7556418BC425030000807D07FFC883C8FCFF
                C085C0753CB81F85EB5141F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85E
                B5141F7ECC1FA078BC2C1E81F03D069D290010000443BE27505488BD5EB17488BD3EB
                12488B9424B8000000EB08488BD7EB03488BD64C8BAC24C8000000488BAC24D800000
                0488BBC24E0000000488BB424E80000004D8B02498D5C0D004803DD4803DF4803DE4C
                398C24B80000000F8ED7010000C78424D0000000FFFF00004881C6A086010033C0488
                1FEE0065A000F8E3E0100004881C7809698008BF04881FF8085B50D0F8E2801000048
                81C500CA9A3B8BF8483BEA0F8E1601000048B800E8764817000000BD00CA9A3B4803C
                8483BC80F84D8000000483B4C24480F84CD000000483B4C24180F84C2000000483B4C
                24380F84B7000000483B4C24280F84AC000000483B4C24080F84A1000000483B0C240
                F8497000000483B4C24100F8480000000483B4C24207479483B4C24307472483B4C24
                40746B483B4C2450757A418BC425030000807D07FFC883C8FCFFC085C07543B81F85E
                B5141F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA078B
                C2C1E81F03D069D290010000443BE2750C48BA00E288C006000000EB3B48BA0018EE8
                406000000EB2F48BA00AC23FC06000000EB0A48BA0076BE3707000000483B0C247E13
                488BC848B800A0724E180900004C03E841FFC4498D440D004803C54803C74803C64C3
                BC07D370F1F40004C3BC37C2E4983F901742866443B9C24D000000074664983C20866
                41FFC34D3BD6720841B901000000EB034D8B024C3BC07CCD48FF8424A0000000488BD
                833C06645891F448BD8488B8424A00000004983C702483B8424B80000000F8C34FEFF
                FF498BC2488B9C24A80000004883C460415F415E415D415C5F5E5DC3B801000000EBE
                1
            )
            
            Hex_IndexKeyDataUInt =
            (LTrim Join
                48895C24104C894C242055565741544155415641574883EC60448BA424C00000004C8
                BD133C048B900D0ED902E00000048898424A00000004C8BFA48894C245048B900A0DB
                215D00000048B800E876481700000048894C241048B90070C9B28B00000048BD00B86
                4D94500000048894C242048B900282E8CD100000049BD0088526A7400000048894C24
                3048B900F81B1D0001000048BA00E092651701000048894C244048B9005840FBA2000
                0004533DB48894C243848B90040B743BA00000033DB48894C242848B90010A5D4E800
                00004D8BF048894C2408488B8C24D000000048BF0076BE370700000048BE00E288C00
                600000049B80018EE840600000049B900AC23FC0600000048896C24484C896C241848
                891424483BC80F840C010000483BCD0F8403010000493BCD0F84FA00000048BD00584
                0FBA2000000483BCD0F84E700000048BD0040B743BA000000483BCD0F84D400000048
                BD0010A5D4E8000000483BCD0F84C1000000483BCA0F84B800000048BA00A0DB215D0
                00000483BCA0F84A000000048BA0070C9B28B000000483BCA0F848D00000048BA0028
                2E8CD1000000483BCA747E48BA00F81B1D00010000483BCA746F48BA00D0ED902E000
                000483BCA7556418BC425030000807D07FFC883C8FCFFC085C0753CB81F85EB5141F7
                ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA078BC2C1E81
                F03D069D290010000443BE27505488BD6EB17498BD0EB12488B9424B8000000EB0849
                8BD1EB03488BD74C8BAC24C8000000488BAC24D8000000488BBC24E0000000488BB42
                4E80000004D8B024D8D4C0D004C03CD4C03CF4C03CE48399C24B80000000F8EBC0100
                004881C6A086010048B800E87648170000004881FEE0065A000F8E340100004881C78
                096980033F64881FF8085B50D0F8E1E0100004881C500CA9A3B33FF483BEA0F8E0C01
                00004803C8BD00CA9A3B483BC80F84D8000000483B4C24480F84CD000000483B4C241
                80F84C2000000483B4C24380F84B7000000483B4C24280F84AC000000483B4C24080F
                84A1000000483B0C240F8497000000483B4C24100F8480000000483B4C24207479483
                B4C24307472483B4C2440746B483B4C2450757A418BC425030000807D07FFC883C8FC
                FFC085C07543B81F85EB5141F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F8
                5EB5141F7ECC1FA078BC2C1E81F03D069D290010000443BE2750C48BA00E288C00600
                0000EB3B48BA0018EE8406000000EB2F48BA00AC23FC06000000EB0A48BA0076BE370
                7000000483B0C247E13488BC848B800A0724E180900004C03E841FFC4498D440D0048
                03C54803C74803C64C3BC07D2C4D3BC17C274883FB0174214183FBFF74614983C2084
                1FFC34D3BD67207BB01000000EB034D8B024C3BC07CD448FF8424A000000045891F4C
                8BC8488B8424A00000004983C7044533DB483B8424B80000000F8C44FEFFFF498BC24
                88B9C24A80000004883C460415F415E415D415C5F5E5DC3B801000000EBE1
            )
            
            Hex_IndexKeyDataSInt64 =
            (LTrim Join
                48895C24104C894C242055565741544155415641574883EC60448BA424C00000004C8
                BD133C048B900D0ED902E00000048898424A00000004C8BFA48894C245048B900A0DB
                215D00000048B800E876481700000048894C241048B90070C9B28B00000048BD00B86
                4D94500000048894C242048B900282E8CD100000049BD0088526A7400000048894C24
                3048B900F81B1D0001000048BA00E092651701000048894C244048B9005840FBA2000
                0004533DB48894C243848B90040B743BA00000033DB48894C242848B90010A5D4E800
                00004D8BF048894C2408488B8C24D000000048BF0076BE370700000048BE00E288C00
                600000049B80018EE840600000049B900AC23FC0600000048896C24484C896C241848
                891424483BC80F840C010000483BCD0F8403010000493BCD0F84FA00000048B800584
                0FBA2000000483BC80F84E700000048B80040B743BA000000483BC80F84D400000048
                B80010A5D4E8000000483BC80F84C1000000483BCA0F84B800000048B800A0DB215D0
                00000483BC80F84A000000048B80070C9B28B000000483BC80F848D00000048B80028
                2E8CD1000000483BC8747E48B800F81B1D00010000483BC8746F48B800D0ED902E000
                000483BC87556418BC425030000807D07FFC883C8FCFFC085C0753CB81F85EB5141F7
                ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA078BC2C1E81
                F03D069D290010000443BE27505488BD6EB17498BD0EB12488B9424B8000000EB0849
                8BD1EB03488BD74C8BAC24C8000000488BAC24D8000000488BBC24E0000000488BB42
                4E80000004D8B024D8D4C0D004C03CD4C03CF4C03CE48399C24B80000000F8EDD0100
                0048B8FFFFFFFFFFFFFF7F48898424D00000004881C6A08601004881FEE0065A000F8
                E460100004881C78096980033F64881FF8085B50D0F8E300100004881C500CA9A3B33
                FF483BEA0F8E1E01000048B800E8764817000000BD00CA9A3B4803C8483BC80F84E00
                00000483B4C24480F84D5000000483B4C24180F84CA000000483B4C24380F84BF0000
                00483B4C24280F84B4000000483B4C24080F84A9000000483B0C240F849F000000483
                B4C24100F8488000000483B4C24200F847D000000483B4C24307476483B4C2440746F
                483B4C24500F857A000000418BC425030000807D07FFC883C8FCFFC085C07543B81F8
                5EB5141F7ECC1FA058BC2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA07
                8BC2C1E81F03D069D290010000443BE2750C48BA00E288C006000000EB3B48BA0018E
                E8406000000EB2F48BA00AC23FC06000000EB0A48BA0076BE3707000000483B0C247E
                13488BC848B800A0724E180900004C03E841FFC4498D440D004803C54803C74803C64
                C3BC07D330F1F004D3BC17C2B4883FB0174254C3B9C24D000000074614983C20849FF
                C34D3BD67207BB01000000EB034D8B024C3BC07CD048FF8424A00000004D891F4C8BC
                8488B8424A00000004983C7084533DB483B8424B80000000F8C35FEFFFF498BC2488B
                9C24A80000004883C460415F415E415D415C5F5E5DC3B801000000EBE1
            )
            
            HexsortData := "4C8B01488B0A4C3BC17D0683C8FF4898C333C04C3BC10F9FC04898C3"
        } Else {
            Hex_IndexKeyDataUChar =
            (LTrim Join
                83EC24538B5C24445533C9568B742458578B7C2460894C241C894C2420884C2413894
                C24248D690681FE00E87648750983FF170F843B01000081FE00B864D9750983FF450F
                842A01000081FE0088526A750983FF740F841901000081FE005840FB750C81FFA2000
                0000F840501000081FE0040B743750C81FFBA0000000F84F100000081FE0010A5D475
                0C81FFE80000000F84DD00000081FE00E09265750C81FF170100000F84C900000081F
                E00A0DB21750983FF5D0F84AA00000081FE0070C9B2750C81FF8B0000000F84960000
                0081FE00282E8C750C81FFD10000000F848200000081FE00F81B1D750881FF0001000
                0747281FE00D0ED900F858400000083FF2E757F8BC3250300008079054883C8FC4075
                43B81F85EB51F7EBC1FA058BC2C1E81F03C26BC0648BD32BD0751BB81F85EB51F7EBC
                1FA078BC2C1E81F03C269C0900100002BD8750EC744245C00E288C0896C2460EB2CC7
                44245C0018EE84896C2460EB1EC744245C00AC23FC896C2460EB10C744245C0076BE3
                7C7442460070000008B6C24548B5C24588B4424388B1003EE13DF036C246489542414
                135C2468036C246C8B5004135C2470036C247489542418135C2478895C2430394C244
                C0F8C360300007F0A394C24480F862A03000081442474A0860100B900000000114C24
                780F88280200007F0E817C2474E0065A000F86180200008144246C80969800894C247
                4894C2478114C24700F88FE0100007F0E817C246C8085B50D0F86EE01000081442464
                00CA9A3B8B442468894C246C13C1894C2470894424683B4424600F8CCA0100007F0E8
                B44245C394424640F86BA01000081C600E8764883D717C744246400CA9A3B894C2468
                81FE00E87648750983FF170F845401000081FE00B864D9750983FF450F84430100008
                1FE0088526A750983FF740F843201000081FE005840FB750C81FFA20000000F841E01
                000081FE0040B743750C81FFBA0000000F840A01000081FE0010A5D4750C81FFE8000
                0000F84F600000081FE00E09265750C81FF170100000F84E200000081FE00A0DB2175
                0983FF5D0F84BF00000081FE0070C9B2750C81FF8B0000000F84AB00000081FE00282
                E8C750C81FFD10000000F849700000081FE00F81B1D750C81FF000100000F84830000
                0081FE00D0ED900F859900000083FF2E0F85900000008B4C24508BD181E2030000807
                9054A83CAFC427547B81F85EB51F7E9C1FA058BC2C1E81F03C26BC0648BD12BD0751B
                B81F85EB51F7E9C1FA078BC2C1E81F03C269C0900100002BC87512C744245C00E288C
                0C744246006000000EB64C744245C0018EE84C744246006000000EB52C744245C00AC
                23FCC744246006000000EB10C744245C0076BE37C74424600700000081FF170100007
                C287F0881FE00E09265761E8144245400A0724EBE00E87648BF170000008154245818
                090000FF4424508B4C24548B44245803CE13C7034C246413442468034C246C1344247
                0034C247413442478394424187F767C06394C2414736E8B542418EB0A8D9B00000000
                8B5C24303BD37C5A7F06396C24147252837C242401750433D27447807C2413FF0F849
                00000008B542438FE44241383C208895424383B542440720E8B542418C74424240100
                0000EB0D8B1A8B5204895C2414895424183BD07CA67F06394C2414729E8A5424138B6
                C243C8855008B542420458344241C018BD8896C243C83D200895424208BE9895C2430
                C6442413003B54244C0F8CEAFCFFFF7F0E8B4424483944241C0F82DAFCFFFF8B44243
                85F5E5D995B83C424C35F5E5DB80100000033D25B83C424C3
            )
            
            Hex_IndexKeyDataUShort =
            (LTrim Join
                83EC24538B5C24445533C9568B742458578B7C2460894C241C894C2420894C2410894
                C24248D690681FE00E87648750983FF170F843B01000081FE00B864D9750983FF450F
                842A01000081FE0088526A750983FF740F841901000081FE005840FB750C81FFA2000
                0000F840501000081FE0040B743750C81FFBA0000000F84F100000081FE0010A5D475
                0C81FFE80000000F84DD00000081FE00E09265750C81FF170100000F84C900000081F
                E00A0DB21750983FF5D0F84AA00000081FE0070C9B2750C81FF8B0000000F84960000
                0081FE00282E8C750C81FFD10000000F848200000081FE00F81B1D750881FF0001000
                0747281FE00D0ED900F858400000083FF2E757F8BC3250300008079054883C8FC4075
                43B81F85EB51F7EBC1FA058BC2C1E81F03C26BC0648BD32BD0751BB81F85EB51F7EBC
                1FA078BC2C1E81F03C269C0900100002BD8750EC744245C00E288C0896C2460EB2CC7
                44245C0018EE84896C2460EB1EC744245C00AC23FC896C2460EB10C744245C0076BE3
                7C7442460070000008B5C24548B6C24588B4424388B1003DE13EF035C246489542414
                136C2468035C246C8B5004136C2470035C247489542418136C2478896C2430394C244
                C0F8C370300007F0A394C24480F862B03000081442474A0860100B900000000114C24
                780F88280200007F0E817C2474E0065A000F86180200008144246C80969800894C247
                4894C2478114C24700F88FE0100007F0E817C246C8085B50D0F86EE01000081442464
                00CA9A3B8B442468894C246C13C1894C2470894424683B4424600F8CCA0100007F0E8
                B44245C394424640F86BA01000081C600E8764883D717C744246400CA9A3B894C2468
                81FE00E87648750983FF170F845401000081FE00B864D9750983FF450F84430100008
                1FE0088526A750983FF740F843201000081FE005840FB750C81FFA20000000F841E01
                000081FE0040B743750C81FFBA0000000F840A01000081FE0010A5D4750C81FFE8000
                0000F84F600000081FE00E09265750C81FF170100000F84E200000081FE00A0DB2175
                0983FF5D0F84BF00000081FE0070C9B2750C81FF8B0000000F84AB00000081FE00282
                E8C750C81FFD10000000F849700000081FE00F81B1D750C81FF000100000F84830000
                0081FE00D0ED900F859900000083FF2E0F85900000008B4C24508BD181E2030000807
                9054A83CAFC427547B81F85EB51F7E9C1FA058BC2C1E81F03C26BC0648BD12BD0751B
                B81F85EB51F7E9C1FA078BC2C1E81F03C269C0900100002BC87512C744245C00E288C
                0C744246006000000EB64C744245C0018EE84C744246006000000EB52C744245C00AC
                23FCC744246006000000EB10C744245C0076BE37C74424600700000081FF170100007
                C287F0881FE00E09265761E8144245400A0724EBE00E87648BF170000008154245818
                090000FF4424508B4C24548B44245803CE13C7034C246413442468034C246C1344247
                0034C247413442478394424187F717C0C394C24147369EB048B6C2430396C24187C5D
                7F06395C24147255837C242401750433D2744ABAFFFF000066395424100F849400000
                08B542438FF44241083C208895424383B542440720AC744242401000000EB0D8B2A8B
                5204896C241489542418394424187CA17F06394C24147299668B5C24108B54243C668
                91A83C2028344241C018954243C8B54242083D2008BE8895424208BD9896C2430C744
                2410000000003B54244C0F8CE9FCFFFF7F0E8B4424483944241C0F82D9FCFFFF8B442
                4385F5E5D995B83C424C35F5E5DB80100000033D25B83C424C3
            )
            
            Hex_IndexKeyDataUInt =
            (LTrim Join
                83EC24538B5C24445533C9568B742458578B7C2460894C241C894C2420894C2410894
                C24248D690681FE00E87648750983FF170F843B01000081FE00B864D9750983FF450F
                842A01000081FE0088526A750983FF740F841901000081FE005840FB750C81FFA2000
                0000F840501000081FE0040B743750C81FFBA0000000F84F100000081FE0010A5D475
                0C81FFE80000000F84DD00000081FE00E09265750C81FF170100000F84C900000081F
                E00A0DB21750983FF5D0F84AA00000081FE0070C9B2750C81FF8B0000000F84960000
                0081FE00282E8C750C81FFD10000000F848200000081FE00F81B1D750881FF0001000
                0747281FE00D0ED900F858400000083FF2E757F8BC3250300008079054883C8FC4075
                43B81F85EB51F7EBC1FA058BC2C1E81F03C26BC0648BD32BD0751BB81F85EB51F7EBC
                1FA078BC2C1E81F03C269C0900100002BD8750EC744245C00E288C0896C2460EB2CC7
                44245C0018EE84896C2460EB1EC744245C00AC23FC896C2460EB10C744245C0076BE3
                7C7442460070000008B5C24548B6C24588B4424388B1003DE13EF035C246489542414
                136C2468035C246C8B5004136C2470035C247489542418136C2478896C2430394C244
                C0F8C3A0300007F0A394C24480F862E03000081442474A0860100B900000000114C24
                780F88280200007F0E817C2474E0065A000F86180200008144246C80969800894C247
                4894C2478114C24700F88FE0100007F0E817C246C8085B50D0F86EE01000081442464
                00CA9A3B8B442468894C246C13C1894C2470894424683B4424600F8CCA0100007F0E8
                B44245C394424640F86BA01000081C600E8764883D717C744246400CA9A3B894C2468
                81FE00E87648750983FF170F845401000081FE00B864D9750983FF450F84430100008
                1FE0088526A750983FF740F843201000081FE005840FB750C81FFA20000000F841E01
                000081FE0040B743750C81FFBA0000000F840A01000081FE0010A5D4750C81FFE8000
                0000F84F600000081FE00E09265750C81FF170100000F84E200000081FE00A0DB2175
                0983FF5D0F84BF00000081FE0070C9B2750C81FF8B0000000F84AB00000081FE00282
                E8C750C81FFD10000000F849700000081FE00F81B1D750C81FF000100000F84830000
                0081FE00D0ED900F859900000083FF2E0F85900000008B4C24508BD181E2030000807
                9054A83CAFC427547B81F85EB51F7E9C1FA058BC2C1E81F03C26BC0648BD12BD0751B
                B81F85EB51F7E9C1FA078BC2C1E81F03C269C0900100002BC87512C744245C00E288C
                0C744246006000000EB64C744245C0018EE84C744246006000000EB52C744245C00AC
                23FCC744246006000000EB10C744245C0076BE37C74424600700000081FF170100007
                C287F0881FE00E09265761E8144245400A0724EBE00E87648BF170000008154245818
                090000FF4424508B4C24548B44245803CE13C7034C246413442468034C246C1344247
                0034C247413442478394424187F767C06394C2414736E8B542418EB0A8D9B00000000
                8B6C24303BD57C5A7F06395C24147252837C242401750433D27447837C2410FF0F849
                40000008B542438FF44241083C208895424383B542440720E8B542418C74424240100
                0000EB0D8B2A8B5204896C2414895424183BD07CA67F06394C2414729E8B5C24108B5
                4243C891A83C2048344241C018954243C8B54242083D2008BE8895424208BD9896C24
                30C7442410000000003B54244C0F8CE6FCFFFF7F0E8B4C2448394C241C0F82D6FCFFF
                F8B4424385F5E5D995B83C424C35F5E5DB80100000033D25B83C424C3
            )
            
            Hex_IndexKeyDataSInt64 =
            (LTrim Join
                83EC28538B5C24485533C9568B74245C578B7C2464894C2420894C2424894C2410894
                C2414894C24288D690681FE00E87648750983FF170F843B01000081FE00B864D97509
                83FF450F842A01000081FE0088526A750983FF740F841901000081FE005840FB750C8
                1FFA20000000F840501000081FE0040B743750C81FFBA0000000F84F100000081FE00
                10A5D4750C81FFE80000000F84DD00000081FE00E09265750C81FF170100000F84C90
                0000081FE00A0DB21750983FF5D0F84AA00000081FE0070C9B2750C81FF8B0000000F
                849600000081FE00282E8C750C81FFD10000000F848200000081FE00F81B1D750881F
                F00010000747281FE00D0ED900F858400000083FF2E757F8BC3250300008079054883
                C8FC407543B81F85EB51F7EBC1FA058BC2C1E81F03C26BC0648BD32BD0751BB81F85E
                B51F7EBC1FA078BC2C1E81F03C269C0900100002BD8750EC744246000E288C0896C24
                64EB2CC74424600018EE84896C2464EB1EC744246000AC23FC896C2464EB10C744246
                00076BE37C7442464070000008B5C24588B6C245C8B44243C8B1003DE13EF035C2468
                89542418136C246C035C24708B5004136C2474035C24788954241C136C247C896C243
                4394C24500F8C5F0300007F13394C244C0F8653030000EB078DA42400000000814424
                78A0860100B900000000114C247C0F88280200007F0E817C2478E0065A000F8618020
                0008144247080969800894C2478894C247C114C24740F88FE0100007F0E817C247080
                85B50D0F86EE0100008144246800CA9A3B8B44246C894C247013C1894C24748944246
                C3B4424640F8CCA0100007F0E8B442460394424680F86BA01000081C600E8764883D7
                17C744246800CA9A3B894C246C81FE00E87648750983FF170F845401000081FE00B86
                4D9750983FF450F844301000081FE0088526A750983FF740F843201000081FE005840
                FB750C81FFA20000000F841E01000081FE0040B743750C81FFBA0000000F840A01000
                081FE0010A5D4750C81FFE80000000F84F600000081FE00E09265750C81FF17010000
                0F84E200000081FE00A0DB21750983FF5D0F84BF00000081FE0070C9B2750C81FF8B0
                000000F84AB00000081FE00282E8C750C81FFD10000000F849700000081FE00F81B1D
                750C81FF000100000F848300000081FE00D0ED900F859900000083FF2E0F859000000
                08B4C24548BD181E20300008079054A83CAFC427547B81F85EB51F7E9C1FA058BC2C1
                E81F03C26BC0648BD12BD0751BB81F85EB51F7E9C1FA078BC2C1E81F03C269C090010
                0002BC87512C744246000E288C0C744246406000000EB64C74424600018EE84C74424
                6406000000EB52C744246000AC23FCC744246406000000EB10C74424600076BE37C74
                424640700000081FF170100007C287F0881FE00E09265761E8144245800A0724EBE00
                E87648BF170000008154245C18090000FF4424548B4C24588B44245C03CE13C7034C2
                4681344246C034C247013442474034C24781344247C3944241C0F8F850000007C0639
                4C2418737D8B54241CEB09EB038D49008B6C24343BD57C6A7F06395C24187262837C2
                42801750433D27457837C2410FF750E817C2414FFFFFF7F0F84A30000008344241001
                8B54243C835424140083C2088954243C3B542444720E8B54241CC744242801000000E
                B0D8B2A8B5204896C24188954241C3BD07C967F06394C2418728E8B5424408B5C2410
                891A8B5C2414895A0483C2088344242001895424408B54242483D2008BE833C089542
                4248BD9896C243489442410894424143B5424500F8CCAFCFFFF7F0E8B4C244C394C24
                200F82BAFCFFFF8B44243C5F5E5D995B83C428C35F5E5DB80100000033D25B83C428C
                3
            )
            
            HexsortData := "8B4424048B4C24088B108B4004568B318B49043BC17F167C043BD6730683C8FF995EC33BC17C0E7F043BD67608B801000000995EC333C0995EC3"
        }
        
        ;UChar indexing
        VarSetCapacity(IndexKeyDataUChar, StrLen(Hex_IndexKeyDataUChar)//2)
        Loop % StrLen(Hex_IndexKeyDataUChar)//2
            NumPut("0x" . SubStr(Hex_IndexKeyDataUChar, 2*A_Index-1, 2), IndexKeyDataUChar, A_Index-1, "Char")
        Hex_IndexKeyDataUChar := ""
        
        ;UShort indexing
        VarSetCapacity(IndexKeyDataUShort, StrLen(Hex_IndexKeyDataUShort)//2)
        Loop % StrLen(Hex_IndexKeyDataUShort)//2
            NumPut("0x" . SubStr(Hex_IndexKeyDataUShort, 2*A_Index-1, 2), IndexKeyDataUShort, A_Index-1, "Char")
        Hex_IndexKeyDataUShort := ""
        
        ;UInt indexing
        VarSetCapacity(IndexKeyDataUInt, StrLen(Hex_IndexKeyDataUInt)//2)
        Loop % StrLen(Hex_IndexKeyDataUInt)//2
            NumPut("0x" . SubStr(Hex_IndexKeyDataUInt, 2*A_Index-1, 2), IndexKeyDataUInt, A_Index-1, "Char")
        Hex_IndexKeyDataUInt := ""
        
        ;SInt64 indexing
        VarSetCapacity(IndexKeyDataSInt64, StrLen(Hex_IndexKeyDataSInt64)//2)
        Loop % StrLen(Hex_IndexKeyDataSInt64)//2
            NumPut("0x" . SubStr(Hex_IndexKeyDataSInt64, 2*A_Index-1, 2), IndexKeyDataSInt64, A_Index-1, "Char")
        Hex_IndexKeyDataSInt64 := ""
        
        ;SInt64 sort (lowest to highest)
        VarSetCapacity(LI64, StrLen(HexSortData)//2)
        Loop % StrLen(HexSortData)//2
            NumPut("0x" . SubStr(HexSortData, 2*A_Index-1, 2), LI64, A_Index-1, "Char")
        HexSortData := ""
        
        , DllCall("VirtualProtect", Ptr, &IndexKeyDataUChar, Ptr, VarSetCapacity(IndexKeyDataUChar), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &IndexKeyDataUShort, Ptr, VarSetCapacity(IndexKeyDataUShort), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &IndexKeyDataUInt, Ptr, VarSetCapacity(IndexKeyDataUInt), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &IndexKeyDataSInt64, Ptr, VarSetCapacity(IndexKeyDataSInt64), "uint", 0x40, "uint*", 0)
        , DllCall("VirtualProtect", Ptr, &LI64, Ptr, VarSetCapacity(LI64), "uint", 0x40, "uint*", 0)
        
        , MCodedData := True
    }
    
    If (_VarType = "UChar")
        VarSize := 1, MCodeDllCall := &IndexKeyDataUChar
    Else If (_VarType = "UShort")
        VarSize := 2, MCodeDllCall := &IndexKeyDataUShort
    Else If (_VarType = "UInt")
        VarSize := 4, MCodeDllCall := &IndexKeyDataUInt
    Else If (_VarType = "Int64")
        VarSize := 8, MCodeDllCall := &IndexKeyDataSInt64, _ReturnOnError := True
    
;   MsgBox % "MCodeDllCall: " . MCodeDllCall . "`n" . &IndexKeyDataUChar . "`n" . &IndexKeyDataUShort . "`n" . &IndexKeyDataUInt . "`n" . &IndexKeyDataSInt64
    
;   MsgBox % "00: " NumGet(_DataAddress + 0, 0, "Int64") "`n" NumGet(_DataAddress + 0, 8, "Int64")
    
    ;VarSetCapacity(KeyData, _DataLength, 0)
    ;, DllCall("RtlMoveMemory", Ptr, &KeyData, Ptr, _DataAddress, "UInt", _DataLength)
    
    DllCall("msvcrt\qsort", Ptr, _DataAddress, "UInt", _DataLength // 8, "UInt", 8, Ptr, &LI64)
    , StartDate := MinRange := SubStr(NumGet(_DataAddress+0, 0, "Int64"), 1, 12) . 00000
    , Difference := MaxRange := SubStr(NumGet(_DataAddress+0, _DataLength - 8, "Int64"), 1, 12) . 00000
    
    Difference -= MinRange, Seconds
    Difference := (Difference // 60) + 1
    
;   MsgBox % "01: " NumGet(KeyData, 0, "Int64") "`n" NumGet(KeyData, 8, "Int64")
    
;   MsgBox % MinRange "`n" MaxRange "`n" Difference
    
    , VarSetCapacity(IndexData, 24+(Difference * VarSize), 0) ;8+8+8
    
    , NumPut(MinRange, IndexData, 0, "Int64")
    , NumPut(MaxRange, IndexData, 8, "Int64")
    , NumPut(Difference * VarSize, IndexData, 16, "Int64")
    , Adr := &IndexData + 24 ;8+8+8
    , Year := SubStr(StartDate, 1, 4)
    , Month := SubStr(StartDate, 5, 2)
    , Day := SubStr(StartDate, 7, 2)
    , Hour := SubStr(StartDate, 9, 2)
    , Minute := SubStr(StartDate, 11, 2)
;   , Year += 0, Month += 0, Day += 0
;   , Hour += 0, Minute += 0
    , Return_Adr := &IndexData . "|" . VarSize
    
;   MsgBox % "KeyData: " . &KeyData . "`nAdr: " Adr "`nKeyData+_DataLength: " . &KeyData + _DataLength . "`n_DataLength: " _DataLength "`nYear: " Year "`nYear * 10000000000000: " Year * 10000000000000 "`nMonth * 100000000000: " Month * 100000000000 "`nDay * 1000000000: " Day * 1000000000 "`nHour * 10000000: " Hour * 10000000 "`nMinute * 100000: " Minute * 100000
    
    , Result := DllCall(MCodeDllCall
            , Ptr, _DataAddress
            , Ptr, Adr
            , "Int64", _DataAddress + _DataLength
            , "Int64", Difference
            , "Int", Year
            , "Int64", Year * 10000000000000
            , "Int64", Month * 100000000000
            , "Int64", Day * 1000000000
            , "Int64", Hour * 10000000
            , "Int64", Minute * 100000
            , "cdecl Int64")
    
;   MsgBox % "Result: " Result
    
;   MsgBox % "02: " NumGet(Adr + 0, 0, "UChar") "`n" NumGet(Adr + 0, 8, "UChar")
    
    If (Result = 1){
        ;The data overloaded the variable type maximum used
        VarSetCapacity(KeyData, _DataLength, 0)
        , VarSetCapacity(KeyData, 0)
        , VarSetCapacity(IndexData, 24+(Difference * VarSize), 0) ;8+8+8
        , VarSetCapacity(IndexData, 0)
        
        If (_ReturnOnError)
            Return "Awwww snap!"
        
        Return_Adr := Index_KeyData(_DataAddress, _DataLength, 0, _VarType = "UChar" ? "UShort" : (_VarType = "UShort" ? "UInt" : (_VarType = "UInt" ? "Int64" : "Int64")))
    } Else {
        VarSetCapacity(KeyData, _DataLength, 0)
        , VarSetCapacity(KeyData, 0)
        , Last_VarSize := VarSize
    }
    
    Return Return_Adr
}


Validate_MouseMovementIndex(_Which = "", _LogAll = 0, _Validate = 0)
{
    Global RootDirectory
    , MouseMovementDirectory
    , Pixel_FileVersion
    , MouseMovement_IndexVersion
    , MouseMovement_Number
    , Ptr
    
    If (_Which = "")
        FDirectory := MouseMovementDirectory
    Else
        FDirectory := _Which
    
    If (_Validate)
        VerifyStoredData(FDirectory "\Mouse movement data", 0)
    
    VarSetCapacity(Details_, _LogAll ? 5120 : 1024) ;5*1024 : 1*1024
    , Index_MetaData_Offset := 0
    
    , ELP_FileCreateDirectory(FDirectory . "\Index")
    
    , H := ELP_OpenFileHandle(FDirectory "\Index\Mouse movement data indexes.metadata", "Read", Index_MetadataFilesize)
    
    If (Index_MetadataFilesize != 0){
        VarSetCapacity(Index_MetaData, Index_MetadataFilesize, 0)
        , ELP_ReadData(H, &Index_MetaData, Index_MetadataFilesize)
        , ELP_CloseFileHandle(H)
        , Index_MetaData_FileVersion := NumGet(Index_MetaData, Index_MetaData_Offset, "Double")
        , Index_MetaData_Offset += 8
        , Index_IDNumber := NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
        , Index_MetaData_Offset += 8
        
        If (Index_MetaData_FileVersion = MouseMovement_IndexVersion)
            Index_IsCompatible := True
        
        If (!Index_IsCompatible or Index_IDNumber != MouseMovement_Number){
            If (!Index_IsCompatible)
                Details_ .= "The mouse movement index file found to not be compatible with this version of M&K Counter 2.0 and it was deleted.`r`n"
            If (Index_IDNumber != MouseMovement_Number)
                Details_ .= "The mouse movement index file is not the mouse movement index file. The ID number found was: " Index_IDNumber " and it was deleted.`r`n"
            
            ELP_FileDelete(FDirectory . "\Index\Mouse movement data indexes.metadata", 1, 0)
            , Index_Entries := NumGet(Index_MetaData, 90, "Int64")
            , Index_MetaData_Offset += 8
            
            Loop, % Index_Entries
                Index_MetaDataMonitors .= Index_MetaDataMonitors != "" ? "|" . NumGet(Index_MetaData, (A_Index * 8) + 90, "Int64") : NumGet(Index_MetaData, (A_Index * 8) + 90, "Int64")
            
            Details_ .= Delete_MouseDataIndexes(Index_MetaDataMonitors, FDirectory)
            , Index_Entries := ""
            , Index_MetaDataMonitors := ""
            , VarSetCapacity(Index_MetaData, Index_MetadataFilesize, 0)
            , VarSetCapacity(Index_MetaData, 0)
        }
    } Else {
        ELP_CloseFileHandle(H)
    }
    
    H := ELP_OpenFileHandle(FDirectory . "\Mouse movement data", "Read", MouseMovement_FileSize)
    
    If (MouseMovement_FileSize = 0){
        ELP_CloseFileHandle(H)
        , Details_ .= "Mouse movement data file was not found or is 0 bytes.`r`n"
        
        Return Details_
    }
    
    VarSetCapacity(MouseMovement_FileVersion, 8, 0)
    , ELP_ReadData(H, &MouseMovement_FileVersion, 8)
    , MouseMovement_FileVersion := NumGet(MouseMovement_FileVersion, 0, "Double")
    
    If (MouseMovement_FileVersion != Pixel_FileVersion){
        ELP_CloseFileHandle(H)
        
        Return "Mouse movement data file version is not compatible with this indexing function."
    }
    
    VarSetCapacity(MouseMovement_Data, MouseMovement_FileSize, 0)
    , ELP_SetFilePointer(H, 0)
    , ELP_ReadData(H, &MouseMovement_Data, MouseMovement_FileSize)
    , ELP_CloseFileHandle(H)
    
    If (Index_IsCompatible){
        Index_StartOffset := NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
        , Index_MetaData_Offset += 8
        
        , Index_EndOffset := NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
        , Index_MetaData_Offset += 8
        
        , Index_MD5HashLength := NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
        , Index_MetaData_Offset += 8
        
        Loop, % Index_MD5HashLength
            Index_MD5Hash .= NumGet(Index_MetaData, Index_MetaData_Offset++, "UChar")
        
        Index_MetaData_Offset += 50 - Index_MD5HashLength
        
        , Index_Entries := NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
        , Index_MetaData_Offset += 8
        
        Loop, % Index_Entries
        {
            Index_MetaDataMonitors .= Index_MetaDataMonitors != "" ? "|" . NumGet(Index_MetaData, Index_MetaData_Offset, "Int64") : NumGet(Index_MetaData, Index_MetaData_Offset, "Int64")
            , Index_MetaData_Offset += 8
        }
        
        MouseMovementData_PartMD5Hash := ELP_CalcMD5(&MouseMovement_Data + 8, Index_EndOffset - 8)
        
        If (Index_MD5Hash . "" != MouseMovementData_PartMD5Hash . "") ; . "" forces a string comparison else they both overflow int max and compare true when they're different
        {
            Index_IsCompatible := False
            , Details_ .= "Mouse movement index file contained invalid data (hashes didn't match) and was deleted.`r`n"
            
            
            ELP_FileDelete(FDirectory . "\Index\Mouse movement data indexes.metadata", 1, 0)
            , Details_ .= Delete_MouseDataIndexes(Index_MetaDataMonitors, FDirectory)
            , Index_MetaDataMonitors := ""
            , VarSetCapacity(Index_MetaData, Index_MetadataFilesize, 0)
            , VarSetCapacity(Index_MetaData, 0)
        }
    }
    
    Original_Index_MetaDataMonitors := Index_MetaDataMonitors
    
    If (Index_IsCompatible){
        If (Index_EndOffset = MouseMovement_FileSize){
            VarSetCapacity(Index_MetaData, Index_MetadataFilesize, 0)
            , VarSetCapacity(Index_MetaData, 0)
            
            , VarSetCapacity(MouseMovement_Data, MouseMovement_FileSize, 0)
            , VarSetCapacity(MouseMovement_Data, 0)
            
            
            Return Details_
        }
        
        MouseMovementData_MD5Hash := ELP_CalcMD5(&MouseMovement_Data + 8, MouseMovement_FileSize - 8)
        
        , PartMouseMovementData_Size := MouseMovement_FileSize - Index_EndOffset
        
        , VarSetCapacity(PartMouseMovement_Data, PartMouseMovementData_Size, 0)
        , DllCall("RtlMoveMemory", Ptr, &PartMouseMovement_Data, Ptr, &MouseMovement_Data+Index_EndOffset, "UInt", PartMouseMovementData_Size)
        , VarSetCapacity(MouseMovement_Data, MouseMovement_FileSize, 0)
        , VarSetCapacity(MouseMovement_Data, 0)
        
        , Used_Monitors := FindMonitors(&PartMouseMovement_Data, PartMouseMovementData_Size)
        
        StringReplace, Used_Monitors, Used_Monitors, |, |, UseErrorLevel
        
        UsedMonitors_Count := Errorlevel + 1
        
        , VarSetCapacity(MonitorData_Pointers, (UsedMonitors_Count + 1) * 8, 0)

        Loop, Parse, Used_Monitors, |
        {
            StringSplit, DataP_, A_LoopField, `,
            
            VarSetCapacity(Monitor_%DataP_1%_Data, DataP_2 * 24, 0)
            , NumPut(&Monitor_%DataP_1%_Data, MonitorData_Pointers, DataP_1 * 8, "Int64")
        }
        
        Extract_MonitorData(&PartMouseMovement_Data, PartMouseMovementData_Size, &MonitorData_Pointers)
        
        Loop, Parse, Used_Monitors, |
        {
            StringSplit, DataP_, A_LoopField, `,
            
            New_IndexDataAddress := Index_MouseMovementData(&Monitor_%DataP_1%_Data, DataP_2 * 24)
            , VarSetCapacity(Monitor_%DataP_1%_Data, DataP_2 * 24, 0)
            , VarSetCapacity(Monitor_%DataP_1%_Data, 0)
            , New_IndexStartDate := NumGet(New_IndexDataAddress+0, 0, "Int64")
            , New_IndexEndDate := NumGet(New_IndexDataAddress+0, 8, "Int64")
            , New_IndexDataLength := NumGet(New_IndexDataAddress+0, 16, "Int64")
            , Index_MetaDataEntryExists := False
            
            , Index_MetaDataMonitor := DataP_1
            
            If (InStr("|" . Index_MetaDataMonitors . "|", "|" . Index_MetaDataMonitor . "|")){
                
                H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Read")
                
                , VarSetCapacity(Current_IndexDataDates, 16, 0)
                , ELP_ReadData(H, &Current_IndexDataDates, 16)
                , ELP_CloseFileHandle(H)
                
                , Index_MetaDataStartDate := NumGet(Current_IndexDataDates, 0, "Int64")
                , Index_MetaDataEndDate := NumGet(Current_IndexDataDates, 8, "Int64")
                , VarSetCapacity(Current_IndexDataDates, 16, 0)
                , VarSetCapacity(Current_IndexDataDates, 0)
                
                , Index_MetaDataEntryExists := True
            } Else
                Index_MetaDataMonitors .= Index_MetaDataMonitors != "" ? "|" . Index_MetaDataMonitor : Index_MetaDataMonitor
            
            
            
            
            If (Index_MetaDataEntryExists){
                If (New_IndexStartDate < Index_MetaDataEndDate){
                    
                    Data_OldestDate := Index_MetaDataStartDate < New_IndexStartDate ? Index_MetaDataStartDate : New_IndexStartDate
                    , Data_NewestDate := Index_MetaDataEndDate > New_IndexEndDate ? Index_MetaDataEndDate : New_IndexEndDate
                    
                    , Difference := Data_NewestDate
                    Difference -= Data_OldestDate, Seconds
                    Difference := (Difference // 60) + 1
                    
                    , Combined_IndexDataLength := (Difference * 16) + 16
                    , VarSetCapacity(Combined_IndexData, Combined_IndexDataLength, 0)
                    , NumPut(Data_OldestDate, Combined_IndexData, 0, "Int64")
                    , NumPut(Data_NewestDate, Combined_IndexData, 8, "Int64")
                    
                    , H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Read", Index_FileSize)
                    , Index_FileSize -= 16
                    
                    , ELP_SetFilePointer(H, 16)
                    
                    , VarSetCapacity(Current_IndexData, Index_FileSize, 0)
                    , ELP_ReadData(H, &Current_IndexData, Index_FileSize)
                    , ELP_CloseFileHandle(H)
                    
                    , Difference_CurrentIndex := Index_MetaDataStartDate
                    Difference_CurrentIndex -= Data_OldestDate, Seconds
                    Difference_CurrentIndex := (Difference_CurrentIndex // 60) * 16
                    
                    , DllCall("RtlMoveMemory", Ptr, &Combined_IndexData + 16 + Difference_CurrentIndex, Ptr, &Current_IndexData, "UInt", Index_FileSize)
                    , VarSetCapacity(Current_IndexData, Index_FileSize, 0)
                    , VarSetCapacity(Current_IndexData, 0)
                    
                    , Difference_NewIndex := New_IndexStartDate
                    Difference_NewIndex -= Data_OldestDate, Seconds
                    Difference_NewIndex := (Difference_NewIndex // 60) * 16
                    
                    , Merge_MonitorData(&Combined_IndexData + 16 + Difference_NewIndex, New_IndexDataAddress + 24, New_IndexDataLength)
                    , Index_MouseMovementData(0, 0, 1) ;Erases the index data stored in the functions static variable
                    
                    , H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write")
                    , ELP_WriteData(H, &Combined_IndexData, Combined_IndexDataLength)
                    , ELP_CloseFileHandle(H)
                    
                    , VarSetCapacity(Combined_IndexData, Combined_IndexDataLength, 0)
                    , VarSetCapacity(Combined_IndexData, 0)
                    
                } Else If (New_IndexStartDate = Index_MetaDataEndDate){
                    H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Read", Index_FileSize)
                    , ELP_SetFilePointer(H, Index_FileSize - 16)
                    , VarSetCapacity(Current_IndexLastEntry, 16, 0)
                    , ELP_ReadData(H, &Current_IndexLastEntry, 16)
                    , ELP_CloseFileHandle(H)
                    , NumPut(NumGet(New_IndexDataAddress+0, 24, "Int64") + NumGet(Current_IndexLastEntry, 0, "Int64"), New_IndexDataAddress+0, 24, "Int64")
                    , NumPut(NumGet(New_IndexDataAddress+0, 32, "Double") + NumGet(Current_IndexLastEntry, 8, "Double"), New_IndexDataAddress+0, 32, "Double")
                    , VarSetCapacity(Current_IndexLastEntry, 16, 0)
                    , VarSetCapacity(Current_IndexLastEntry, 0)
                    , H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write")
                    
                    , VarSetCapacity(New_IndexDataDates, 16, 0)
                    , NumPut(Index_MetaDataStartDate, New_IndexDataDates, 0, "Int64")
                    , NumPut(New_IndexEndDate, New_IndexDataDates, 8, "Int64")
                    , ELP_WriteData(H, &New_IndexDataDates, 16)
                    , VarSetCapacity(New_IndexDataDates, 16, 0)
                    , VarSetCapacity(New_IndexDataDates, 0)
                    
                    , ELP_SetFilePointer(H, Index_FileSize - 16)
                    , ELP_WriteData(H, New_IndexDataAddress + 24, New_IndexDataLength)
                    , ELP_CloseFileHandle(H)
                    
                    
                    Index_MouseMovementData(0, 0, 1) ;Erases the index data stored in the functions static variable
                    
                } Else If (New_IndexStartDate > Index_MetaDataEndDate){
                    Difference_Minutes := DateDifference(New_IndexStartDate, Index_MetaDataEndDate)
                    If (Difference_Minutes > 1){
                        Difference_Minutes -= 1
                        ;, New_IndexDataLength += Difference_Minutes * 16
                        , VarSetCapacity(BlankIndexData, Difference_Minutes * 16, 0)
                        , H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write", Index_FileSize)
                        , ELP_SetFilePointer(H, Index_FileSize)
                        , ELP_WriteData(H, &BlankIndexData, Difference_Minutes * 16)
                        , ELP_CloseFileHandle(H)
                        , VarSetCapacity(BlankIndexData, Difference_Minutes * 16, 0)
                        , VarSetCapacity(BlankIndexData, 0)
                        , Index_FileSize += Difference_Minutes * 16
                        
                    }
                    
                    H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write", Index_FileSize)
                    
                    , VarSetCapacity(New_IndexDataDates, 16, 0)
                    , NumPut(Index_MetaDataStartDate, New_IndexDataDates, 0, "Int64")
                    , NumPut(New_IndexEndDate, New_IndexDataDates, 8, "Int64")
                    
                    , ELP_WriteData(H, &New_IndexDataDates, 16)
                    
                    , VarSetCapacity(New_IndexDataDates, 16, 0)
                    , VarSetCapacity(New_IndexDataDates, 0)
                    
                    , ELP_SetFilePointer(H, Index_FileSize)
                    
                    , ELP_WriteData(H, New_IndexDataAddress + 24, New_IndexDataLength)
                    , ELP_CloseFileHandle(H)
                    
                    
                    Index_MouseMovementData(0, 0, 1) ;Erases the index data stored in the functions static variable
                }
            } Else {
                If (ELP_FileExists(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", 1, 0, 0))
                    ELP_FileMove(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", FDirectory . "\Index\Unknown file - " . A_Now . " - Mouse movement data " . Index_MetaDataMonitor . ".index", 1, 0, 0)
                
                H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write")
                
                , VarSetCapacity(New_IndexDataDates, 16, 0)
                , NumPut(New_IndexStartDate, New_IndexDataDates, 0, "Int64")
                , NumPut(New_IndexEndDate, New_IndexDataDates, 8, "Int64")
                
                , ELP_WriteData(H, &New_IndexDataDates, 16)
                , VarSetCapacity(New_IndexDataDates, 16, 0)
                , VarSetCapacity(New_IndexDataDates, 0)
                , ELP_SetFilePointer(H, 16)
                , ELP_WriteData(H, New_IndexDataAddress + 24, New_IndexDataLength)
                , ELP_CloseFileHandle(H)
                
                
                Index_MouseMovementData(0, 0, 1) ;Erases the index data stored in the functions static variable
            }
        }
    }
    
    If (!Index_IsCompatible){
        
        MouseMovementData_MD5Hash := ELP_CalcMD5(&MouseMovement_Data + 8, MouseMovement_FileSize - 8)
        , Used_Monitors := FindMonitors(&MouseMovement_Data + 8, MouseMovement_FileSize - 8)
        
        StringReplace, Used_Monitors, Used_Monitors, |, |, UseErrorLevel
        
        UsedMonitors_Count := Errorlevel + 1
        , VarSetCapacity(MonitorData_Pointers, (UsedMonitors_Count + 1) * 8, 0)
        ;MsgBox % Used_Monitors
        Loop, Parse, Used_Monitors, |
        {
            StringSplit, DataP_, A_LoopField, `,
            
            VarSetCapacity(Monitor_%DataP_1%_Data, DataP_2 * 24, 0)
            NumPut(&Monitor_%DataP_1%_Data, MonitorData_Pointers, DataP_1 * 8, "Int64")
        }
        
        Extract_MonitorData(&MouseMovement_Data + 8, MouseMovement_FileSize - 8, &MonitorData_Pointers)
        , VarSetCapacity(MouseMovement_Data, MouseMovement_FileSize, 0)
        , VarSetCapacity(MouseMovement_Data, 0)
        
        
        Loop, Parse, Used_Monitors, |
        {
            StringSplit, DataP_, A_LoopField, `,
            
;           MsgBox % NumGet(&Monitor_%DataP_1%_Data, 0, "Int64") "`n" NumGet(&Monitor_%DataP_1%_Data, 8, "Int64") "`n" NumGet(&Monitor_%DataP_1%_Data, 16, "Int64")
            
            New_IndexDataAddress := Index_MouseMovementData(&Monitor_%DataP_1%_Data, DataP_2 * 24)
            , VarSetCapacity(Monitor_%DataP_1%_Data, DataP_2 * 24, 0)
            , VarSetCapacity(Monitor_%DataP_1%_Data, 0)
            , New_IndexDataLength := NumGet(New_IndexDataAddress+0, 16, "Int64")
            , Index_MetaDataMonitor := DataP_1
            , Index_MetaDataMonitors .= Index_MetaDataMonitors != "" ? "|" . Index_MetaDataMonitor : Index_MetaDataMonitor
            
            If (ELP_FileExists(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", 1, 0, 0))
                ELP_FileMove(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", FDirectory . "\Index\Unknown file - " . A_Now . " - Mouse movement data " . Index_MetaDataMonitor . ".index", 1, 0, 0)
            
            H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data " . Index_MetaDataMonitor . ".index", "Write")
            , ELP_WriteData(H, New_IndexDataAddress, 16)
            , ELP_SetFilePointer(H, 16)
            , ELP_WriteData(H, New_IndexDataAddress + 24, New_IndexDataLength)
            , ELP_CloseFileHandle(H)
            
            
            Index_MouseMovementData(0, 0, 1) ;Erases the index data stored in the functions static variable
        }
        
    }
    
    
    StringReplace, Index_MetaDataMonitors, Index_MetaDataMonitors, |, |, UseErrorLevel
    Index_MetaDataLength := 98+((ErrorLevel + 1) * 8) ;8+8+8+8+8+50+8
    , VarSetCapacity(Index_MetaData, Index_MetaDataLength, 0)
    , Index_MetaDataOffset := 0
    
    , NumPut(MouseMovement_IndexVersion, Index_MetaData, Index_MetaDataOffset, "Double")
    , Index_MetaDataOffset += 8
    , NumPut(MouseMovement_Number, Index_MetaData, Index_MetaDataOffset, "Int64")
    , Index_MetaDataOffset += 8
    , NumPut(8, Index_MetaData, Index_MetaDataOffset, "Int64")
    , Index_MetaDataOffset += 8
    , NumPut(MouseMovement_FileSize, Index_MetaData, Index_MetaDataOffset, "Int64")
    , Index_MetaDataOffset += 8
    , NumPut(StrLen(MouseMovementData_MD5Hash), Index_MetaData, Index_MetaDataOffset, "Int64")
    , Index_MetaDataOffset += 8
    
    Loop, Parse, MouseMovementData_MD5Hash
        NumPut(A_LoopField, Index_MetaData, Index_MetaDataOffset++, "UChar")
    
    Index_MetaDataOffset += 50 - StrLen(MouseMovementData_MD5Hash)
    
    StringReplace, Index_MetaDataMonitors, Index_MetaDataMonitors, |, |, UseErrorLevel
    Index_Entries := ErrorLevel + 1
    , NumPut(Index_Entries, Index_MetaData, Index_MetaDataOffset, "Int64")
    , Index_MetaDataOffset += 8
    
    Loop, Parse, Index_MetaDataMonitors, |
    {
        NumPut(A_LoopField, Index_MetaData, Index_MetaDataOffset, "Int64")
        Index_MetaDataOffset += 8
    }
    
    H := ELP_OpenFileHandle(FDirectory . "\Index\Mouse movement data indexes.metadata", "Write")
    , ELP_WriteData(H, &Index_MetaData, Index_MetaDataOffset)
    , ELP_CloseFileHandle(H)
    
    
    Return Details_
}

Merge_MonitorData(_MergedData, _SourceData, _SourceDataLength)
{
    Global Ptr
    Static MCodedData
    , MergeMointorData
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            MergeMouseDataHex =
            (LTrim Join
                488D42084C8D4908493BC07329482BD14A8B440AF8490141F8F2410F100411F2410F5801F2410F11014983
                C108498D0411493BC072DAF3C3
            )
        } Else {
            MergeMouseDataHex = 
            (LTrim Join
                8B4C240453558B6C241456578B7C24188BDF83C7088D71083BFD0F83AF0000008BC52BC783C0079983E207
                03C2C1F80383F8047C708BC38D55E82BC18D6424008B2B01298B6B04116904DD06DC07DD1E8B6C08080169
                088B6C080C11690CDD4708DC4608DD5E088B6B100169108B6B14116914DD4710DC4610DD5E108B6B180169
                188B6B1C11691CDD4718DC461883C72083C32083C120DD5E1883C6203BFA7C9F8B6C241C3BFD73262BD92B
                F18D49008B040B01018B540B04115104DD040EDC0783C70883C108DD5C0EF83BFD72E15F5E5D5BC3
            )
        }
        
        VarSetCapacity(MergeMointorData, StrLen(MergeMouseDataHex)//2)
        Loop % StrLen(MergeMouseDataHex)//2
            NumPut("0x" . SubStr(MergeMouseDataHex, 2*A_Index-1, 2), MergeMointorData, A_Index-1, "Char")
        MergeMouseDataHex := ""
        
        DllCall("VirtualProtect", Ptr, &MergeMointorData, Ptr, VarSetCapacity(MergeMointorData), "uint", 0x40, "uint*", 0)
        
        MCodedData := True
    }
    
    DllCall(&MergeMointorData, Ptr, _MergedData, Ptr, _SourceData, Ptr, _SourceData+_SourceDataLength)
}

Extract_MonitorData(_MouseMovementData, _MouseMovementDataLength, _MonitorPointers)
{
    Global Ptr
    Static MCodedData
    , ExtractMonitorData
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            ExtractMonitorDataHex =
            (LTrim Join
                4C8BD2483BCA732F4C8B4908488B014883C1204B8B14C8488902488B41F048894208488B41F848894210488D421
                84B8904C8493BCA72D1F3C3
            )
        } Else {
            ExtractMonitorDataHex =
            (LTrim Join
                558BEC51518B4D083B4D0C73515356576A085B8B118B790403CB8B71048B018975FC8B75108D34C68B068910897
                80403CB8B1103C389108B510489500403CB8B1103C389108B510489500483C0089903CB89068956043B4D0C72B8
                5F5E5BC9C3
            )
        }
        
        VarSetCapacity(ExtractMonitorData, StrLen(ExtractMonitorDataHex)//2)
        Loop % StrLen(ExtractMonitorDataHex)//2
            NumPut("0x" . SubStr(ExtractMonitorDataHex, 2*A_Index-1, 2), ExtractMonitorData, A_Index-1, "Char")
        ExtractMonitorDataHex := ""

        DllCall("VirtualProtect", Ptr, &ExtractMonitorData, Ptr, VarSetCapacity(ExtractMonitorData), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    DllCall(&ExtractMonitorData, Ptr, _MouseMovementData, Ptr, _MouseMovementData+_MouseMovementDataLength, Ptr, _MonitorPointers)
}

FindMonitors(_MonData, _MonDataLength)
{
    C_Offset := 8
    Loop, % _MonDataLength // 32
    {
        Mon := NumGet(_MonData+0, C_Offset, "Int64"), C_Offset += 32
        Mon_%Mon%_Count ++
        
        If (!InStr("|" FoundMonitors "|", "|" Mon "|"))
            FoundMonitors .= FoundMonitors != "" ? "|" Mon : Mon
    }
    
    Loop, Parse, FoundMonitors, |
        ReturnValue .= ReturnValue ? "|" A_LoopField "," Mon_%A_LoopField%_Count : A_LoopField "," Mon_%A_LoopField%_Count
    
    Return ReturnValue
}

Delete_MouseDataIndexes(_UsedMonitors, _Which)
{
    Loop, Parse, _UsedMonitors, |
    {
        ELP_FileDelete(_Which . "\Index\Mouse movement data " . A_LoopField . ".index", 1, 0) ;1 - force delete, 0 - absolute file path (not a pattern)
        If (ErrorLevel)
            Errors .= "Unable to delete mouse movement data index for monitor " . A_LoopField . ".`r`n"
    }
    
    Return Errors
}

Index_MouseMovementData(_DataAddress, _DataLength, _BlankData = 0)
{
    Global Ptr
    Static FindLowestHighestDates
    , IndexMouseMovement
    , Last_IndexDataLength
    , IndexData
    , MCodedData
    
    If (_BlankData){
        VarSetCapacity(IndexData, Last_IndexDataLength, 0)
        , VarSetCapacity(IndexData, 0)
        
        Return
    }
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            FindLowestHighestDatesHex =
            (LTrim Join
                48B8FFFF63A7B3B6E00D4533C94989004D894808EB1B488B014939007E034989004C3B097D074C8B094D8948084
                883C118483BCA72E0F3C3
            )
        } Else {
            FindLowestHighestDatesHex = 
            (LTrim Join
                8B44240C8B4C24048360080083600C00C700FFFF63A7C74004B3B6E00D3B4C2408733956578B71048B113970047
                C0B7F043910760589108970048B71048B1139700C7F0D7C05395008730689500889700C83C1183B4C241072CB5F
                5EC3
            )
        }
        
        VarSetCapacity(FindLowestHighestDates, StrLen(FindLowestHighestDatesHex)//2)
        Loop % StrLen(FindLowestHighestDatesHex)//2
            NumPut("0x" . SubStr(FindLowestHighestDatesHex, 2*A_Index-1, 2), FindLowestHighestDates, A_Index-1, "Char")
        FindLowestHighestDatesHex := ""
        
        DllCall("VirtualProtect", Ptr, &FindLowestHighestDates, Ptr, VarSetCapacity(FindLowestHighestDates), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    VarSetCapacity(FindDates, 16, 0)
    
;   MsgBox Running...`n%_DataAddress%`n%_DataLength%
;   MsgBox % NumGet(_DataAddress+0, 0, "Int64") "`n" NumGet(_DataAddress+0, 8, "Int64") "`n" NumGet(_DataAddress+0, 16, "Int64")
    
    , DllCall(&FindLowestHighestDates, Ptr, _DataAddress, Ptr, _DataAddress + _DataLength, Ptr, &FindDates)
    , FindDate_Low := MinRange := SubStr(NumGet(FindDates, 0, "Int64"), 1, 12) . 00000
    , Difference := MaxRange := SubStr(NumGet(FindDates, 8, "Int64"), 1, 12) . 00000
    
;   MsgBox Done: %MinRange%`n%MaxRange%
    
    Difference -= MinRange, Seconds
    Difference := (Difference // 60) + 1
    , IndexDataLength := 24 + (Difference * 8 * 2) ;8 + 8 + 8
    , VarSetCapacity(IndexData, IndexDataLength, 0)
    
    , NumPut(MinRange, IndexData, 0, "Int64")
    , NumPut(MaxRange, IndexData, 8, "Int64")
    , NumPut(Difference * 8 * 2, IndexData, 16, "Int64")
    , Adr := &IndexData + 8 + 8 + 8
    , Year := SubStr(FindDate_Low, 1, 4)
    , Month := SubStr(FindDate_Low, 5, 2)
    , Day := SubStr(FindDate_Low, 7, 2)
    , Hour := SubStr(FindDate_Low, 9, 2)
    , Minute := SubStr(FindDate_Low, 11, 2)
    
    , MouseMovementData_Offset := 0
    
    Loop, % _DataLength // 8 // 3
    {
        CDate := NumGet(_DataAddress+0, MouseMovementData_Offset, "Int64")
        CDate -= FindDate_Low, Seconds
        
        CDate := CDate // 60 * 16
        , NumPut(NumGet(Adr+0, CDate, "Int64") + NumGet(_DataAddress+0, MouseMovementData_Offset + 8, "Int64"), Adr+0, CDate, "Int64")
        , NumPut(NumGet(Adr+0, CDate + 8, "Double") + NumGet(_DataAddress+0, MouseMovementData_Offset + 16, "Double"), Adr+0, CDate + 8, "Double")
        , MouseMovementData_Offset += 24
    }
    
    Last_IndexDataLength := IndexDataLength
    
    Return &IndexData
}


Validate_WordsTypedIndex(_Which = "", _LogAll = 0, _Validate = 0)
{
    Global RootDirectory
    , WordDirectory
    , Ptr
    , WordsPerTime_Number
    , WordsTyped_IndexVersion
    
    If (_Which = "")
        FDirectory := WordDirectory
    Else
        FDirectory := _Which
    
    If (_Validate)
        VerifyStoredData(_Which "\Words per time data", 0)
    
    ELP_FileCreateDirectory(FDirectory . "\Indexes")
    
    , VarSetCapacity(Details_, _LogAll ? 5120 : 1024) ;5*1024 : 1*1024
    , IndexOffset := 0
    
    , H := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data pointers.index", "Read", IndexPointers_FileSize)
    
    If (IndexPointers_FileSize != 0){
        VarSetCapacity(IndexDataPointers, 114, 0) ;8+8+8+8+8+50+8+8+8
        , VarSetCapacity(IndexEntry_LastEntry, 16, 0)
        
        , ELP_ReadData(H, &IndexDataPointers, 114) ;8+8+8+8+8+50+8+8+8
        , ELP_SetFilePointer(H, IndexPointers_FileSize-16)
        , ELP_ReadData(H, &IndexEntry_LastEntry, 16)
        , ELP_CloseFileHandle(H)
        , FileVersion := NumGet(IndexDataPointers, IndexOffset, "Double")
        , IndexOffset += 8
        , IDNumber := NumGet(IndexDataPointers, IndexOffset, "Int64")
        , IndexOffset += 8
        , IsCompatible := False
        
        If (FileVersion = WordsTyped_IndexVersion)
            IsCompatible := True
        
        If (!IsCompatible or IDNumber != WordsPerTime_Number){
            If (!IsCompatible)
                Details_ .= "The index file for the Words per time data was found to not be compatible with this version of M&K Counter 2.0 and it was deleted.`r`n"
            If (IDNumber != WordsPerTime_Number)
                Details_ .= "The index file for the Words per time data was not created for the Words per time data and it was deleted.`r`n"
                , Details_ .= "The index file was created for ID # " IDNumber ".`r`n"
            
            VarSetCapacity(IndexDataPointers, 114, 0) ;8+8+8+8+8+50+8+8+8
            , VarSetCapacity(IndexDataPointers, 0)
            , VarSetCapacity(IndexEntry_LastEntry, 16, 0)
            , VarSetCapacity(IndexEntry_LastEntry, 0)
            , IndexOffset := 0
            
            , ELP_FileDelete(FDirectory . "\Indexes\Words per time data pointers.index")
            , ELP_FileDelete(FDirectory . "\Indexes\Words per time data data.index")
        }
    } Else {
        ELP_CloseFileHandle(H)
        
    }
    
    H := ELP_OpenFileHandle(FDirectory . "\Words per time data", "Read", WordDataFileSize)
    
    If (WordDataFileSize != 0){
        VarSetCapacity(WordData, WordDataFileSize, 0)
        , ELP_ReadData(H, &WordData, WordDataFileSize)
        , ELP_CloseFileHandle(H)
        
        
        
        If (IsCompatible){
            IndexEntry_StartOffset := NumGet(IndexDataPointers, IndexOffset, "Int64")
            
            If (IndexEntry_StartOffset = 0){
                IndexOffset += 8
                , IndexEntry_EndOffset := NumGet(IndexDataPointers, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_MD5HashLength := NumGet(IndexDataPointers, IndexOffset, "Int64")
                , IndexOffset += 8
                
                Loop, % IndexEntry_MD5HashLength
                    IndexEntry_MD5Hash .= NumGet(IndexDataPointers, IndexOffset++, "UChar")
                
                IndexOffset += 50 - IndexEntry_MD5HashLength
                , IndexEntry_StartDate := NumGet(IndexDataPointers, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_EndDate := NumGet(IndexDataPointers, IndexOffset, "Int64")
                , IndexOffset += 8
                , IndexEntry_Length := NumGet(IndexDataPointers, IndexOffset, "Int64")
                , IndexOffset := 0
                
                , IndexEntry_LastEntryPointer := NumGet(IndexEntry_LastEntry, 0, "Int64")
                , IndexEntry_LastEntryEntries := NumGet(IndexEntry_LastEntry, 8, "Int64")
                , VarSetCapacity(IndexEntry_LastEntry, 16, 0)
                , VarSetCapacity(IndexEntry_LastEntry, 0)
                
                , NewMD5Hash := ELP_CalcMD5(&WordData, IndexEntry_EndOffset)
                
                If (NewMD5Hash . "" != IndexEntry_MD5Hash . "") ; . "" forces a string comparison else they both overflow int max and compare true when they're different
                {
                    IsCompatible := False
                    , Details_ .= "Words per time data index file contained invalid data (hashes didn't match) and was deleted.`r`n"
                    
                    ELP_FileDelete(FDirectory . "\Indexes\Words per time data pointers.index")
                    , ELP_FileDelete(FDirectory . "\Indexes\Words per time data data.index")
                }
            } Else {
                Details_ .= "Words per time data index file contained invalid data (start offset wrong) and was deleted.`r`n"
                , IndexOffset := 0
                , IndexEntry_StartOffset := ""
                , IsCompatible := False
                ELP_FileDelete(FDirectory . "\Indexes\Words per time data pointers.index")
                , ELP_FileDelete(FDirectory . "\Indexes\Words per time data data.index")
            }
            
            VarSetCapacity(IndexDataPointers, 114, 0) ;8+8+8+8+8+50+8+8+8
            , VarSetCapacity(IndexDataPointers, 0)
            
            If (IsCompatible){
                PartDataSize := WordDataFileSize - IndexEntry_EndOffset
            
                If (PartDataSize = 0){
                    VarSetCapacity(WordData, WordDataFileSize, 0)
                    , VarSetCapacity(WordData, 0)
                    
                    Return Details_
                }
                
                VarSetCapacity(PartWordData, PartDataSize, 0)
                , DllCall("RtlMoveMemory", Ptr, &PartWordData, Ptr, &WordData+IndexEntry_EndOffset, "UInt", PartDataSize)
                , H := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data data.index", "Read", IndexDataData_FileSize)
                , ELP_CloseFileHandle(H)
                , New_IndexDataAddresses := Index_WordsTypedData(&PartWordData, PartDataSize, IndexDataData_FileSize)
                
                StringSplit, Returned_, New_IndexDataAddresses, |
                
                New_IndexDataMetaDataAddress := Returned_1
                , New_IndexDataPointersAddress := Returned_2
                , New_IndexDataDataAddress := Returned_3
                , New_IndexDataDataSize := Returned_4
                
                ;MsgBox % New_IndexDataAddresses "`n`n" Returned_1 "`n" Returned_2 "`n" Returned_3 "`n" Returned_4              
                , VarSetCapacity(PartWordData, PartDataSize, 0)
                , VarSetCapacity(PartWordData, 0)
                , WordData_MD5Hash := ELP_CalcMD5(&WordData, WordDataFileSize)
                , New_IndexStartDate := NumGet(New_IndexDataMetaDataAddress+0, 0, "Int64")
                , New_IndexEndDate := NumGet(New_IndexDataMetaDataAddress+0, 8, "Int64")
                , New_IndexDataLength := NumGet(New_IndexDataMetaDataAddress+0, 16, "Int64")
                
                If (New_IndexStartDate < IndexEntry_EndDate){ ;If the start date is before the end date
                    H1 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data pointers.index", "Read", IndexDataPointers_FileSize)
                    , H2 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data data.index", "Read", IndexDataData_FileSize)
                    
                    , VarSetCapacity(OldIndexDataPointers, IndexDataPointers_FileSize, 0)
                    , VarSetCapacity(OldIndexDataData, IndexDataData_FileSize, 0)
                    
                    , ELP_SetFilePointer(H1, 90) ;8+8+8+8+8+50
                    , ELP_ReadData(H1, &OldIndexDataPointers, IndexDataPointers_FileSize)
                    , ELP_ReadData(H2, &OldIndexDataData, IndexDataData_FileSize)
                    , ELP_CloseFileHandle(H1)
                    , ELP_CloseFileHandle(H2)
                    
                    , Get_NeededSize(MergedPointersSize, MergedDataSize, New_IndexDataMetaDataAddress, &OldIndexDataPointers, New_IndexDataPointersAddress)
                    
                    ;MsgBOx % MergedPointersSize ".`r`n" MergedDataSize "."
                    
                    VarSetCapacity(MergedPointers, MergedPointersSize, 0)
                    , VarSetCapacity(MergedData, MergedDataSize, 0)
                    
                    , Merge_WordsTyped(&MergedPointers, &MergedData, New_IndexDataMetaDataAddress, &OldIndexDataPointers, &OldIndexDataData, New_IndexDataPointersAddress, New_IndexDataDataAddress)
                    
                    ;MsgBox Finished merge
                    
                    , Index_WordsTypedData(0, 0, 0, 1) ;Erases the index data stored in the functions static variable
                    
                    ;MsgBox Finished erase
                    
                    , VarSetCapacity(OldIndexDataPointers, IndexDataPointers_FileSize, 0)
                    , VarSetCapacity(OldIndexDataData, IndexDataData_FileSize, 0)
                    , VarSetCapacity(OldIndexDataPointers, 0)
                    , VarSetCapacity(OldIndexDataData, 0)
                    
                    
                    
                    ;, ELP_FileDelete(FDirectory . "\Indexes\Words per time data pointers.index")
                    ;, ELP_FileDelete(FDirectory . "\Indexes\Words per time data data.index")
                    
                    ;MsgBox % "Reached this point: " FDirectory . "\Indexes\Words per time data pointers.index"
                    
                    , H1 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data pointers.index", "Write", IndexDataPointers_FileSize)
                    
                    ;MsgBox % "Reached 2..."
                    
                    , VarSetCapacity(NewIndexMetaData, 66, 0) ;8+8+50
                    , NewIndexMetaDataOffset := 0
                    , NumPut(WordDataFileSize, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New EndOffset for the index file
                    , NewIndexMetaDataOffset += 8
                    , NumPut(StrLen(WordData_MD5Hash), NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New MD5HashLength for the index file
                    , NewIndexMetaDataOffset += 8
                    
                    Loop, Parse, WordData_MD5Hash ;New MD5 hash for the index file
                        NumPut(A_LoopField, NewIndexMetaData, NewIndexMetaDataOffset++, "UChar")
                    
                    NewIndexMetaDataOffset += 50 - StrLen(WordData_MD5Hash)
                    , ELP_SetFilePointer(H1, 24) ; 8 + 8 + 8
                    , ELP_WriteData(H1, &NewIndexMetaData, NewIndexMetaDataOffset)
                    , ELP_SetFilePointer(H1, 24 + NewIndexMetaDataOffset) ; 8 + 8 + 8
                    
                    , ELP_WriteData(H1, &MergedPointers, MergedPointersSize)
                    , ELP_CloseFileHandle(H1)
                    
                    ;MsgBox % "Reached this point as well: " FDirectory . "\Indexes\Words per time data data.index"
                    
                    H2 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data data.index", "Write", IndexDataData_FileSize)
                    , ELP_WriteData(H2, &MergedData, MergedDataSize)
                    , ELP_CloseFileHandle(H2)
                    
                } Else {
                    H1 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data pointers.index", "Write", IndexDataPointers_FileSize)
                    , H2 := ELP_OpenFileHandle(FDirectory . "\Indexes\Words per time data data.index", "Write", IndexDataData_FileSize)
                    , Wrote_BlankData := 0
                    
                    If (New_IndexStartDate != IndexEntry_EndDate){ ;Accounts for gaps between the last end date index data and the new index data start date
                        Difference_Minutes := DateDifference(New_IndexStartDate, IndexEntry_EndDate)
                        
                        If (Difference_Minutes > 1){
                            Difference_Minutes -= 1
                            , Wrote_BlankData := Difference_Minutes * 16
                            ;, New_IndexDataLength += Difference_Minutes * 16
                            , VarSetCapacity(BlankIndexData, Difference_Minutes * 16, 0)
                            , Offset := 0
                            
                            Loop, % Difference_Minutes
                            {
                                NumPut(IndexDataData_FileSize, BlankIndexData, Offset, "Int64")
                                , Offset += 16
                            }
                            
                            ELP_SetFilePointer(H1, IndexDataPointers_FileSize)
                            , ELP_WriteData(H1, &BlankIndexData, Difference_Minutes * 16)
                            
                            , VarSetCapacity(BlankIndexData, Difference_Minutes * 16, 0)
                            , VarSetCapacity(BlankIndexData, 0)
                            , IndexDataPointers_FileSize += Difference_Minutes * 16
                            
                        }
                    }
                    
                    VarSetCapacity(NewIndexMetaData, 90, 0) ;8+8+50+8+8+8
                    , NewIndexMetaDataOffset := 0
                    , NumPut(WordDataFileSize, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New EndOffset for the index file
                    , NewIndexMetaDataOffset += 8
                    , NumPut(StrLen(WordData_MD5Hash), NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New MD5HashLength for the index file
                    , NewIndexMetaDataOffset += 8
                    
                    Loop, Parse, WordData_MD5Hash ;New MD5 hash for the index file
                        NumPut(A_LoopField, NewIndexMetaData, NewIndexMetaDataOffset++, "UChar")
                    
                    NewIndexMetaDataOffset += 50 - StrLen(WordData_MD5Hash)
                    , NumPut(IndexEntry_StartDate, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New StartDate for the index file
                    , NewIndexMetaDataOffset += 8
                    , NumPut(New_IndexEndDate, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New EndDate for the index file
                    , NewIndexMetaDataOffset += 8
                    
                    NumPut(New_IndexDataLength + Wrote_BlankData + IndexEntry_Length, NewIndexMetaData, NewIndexMetaDataOffset, "Int64") ;New Length for the index file
                    , NewIndexMetaDataOffset += 8
                    
                    If (New_IndexStartDate = IndexEntry_EndDate){
                        NumPut(IndexEntry_LastEntryPointer, New_IndexDataPointersAddress+0, 0, "Int64")
                        , NumPut(NumGet(New_IndexDataPointersAddress+0, 8, "Int64") + IndexEntry_LastEntryEntries, New_IndexDataPointersAddress+0, 8, "Int64")
                        , NumPut(New_IndexDataLength + IndexEntry_Length - 16, NewIndexMetaData, NewIndexMetaDataOffset - 8, "Int64") ;New Length for the index file
                        
                        , ELP_SetFilePointer(H1, IndexDataPointers_FileSize - 16)
                        , ELP_WriteData(H1, New_IndexDataPointersAddress, New_IndexDataLength)
                        
                    ;   , DllCall("SetFilePointerEx", "UInt", H1, "Int64", IndexDataPointers_FileSize - 16, "UInt *", P, "Int", 0)
                    ;   , DllCall("WriteFile", "UInt", H1, "UInt", New_IndexDataPointersAddress, "UInt", New_IndexDataLength, "UInt", 0, "UInt", 0)
                        
                    } Else {
                        ELP_SetFilePointer(H1, IndexDataPointers_FileSize)
                        , ELP_WriteData(H1, New_IndexDataPointersAddress, New_IndexDataLength)
                        
                    ;   DllCall("SetFilePointerEx", "UInt", H1, "Int64", IndexDataPointers_FileSize, "UInt *", P, "Int", 0)
                    ;   , DllCall("WriteFile", "UInt", H1, "UInt", New_IndexDataPointersAddress, "UInt", New_IndexDataLength, "UInt", 0, "UInt", 0)
                    }
                    
                    ELP_SetFilePointer(H1, 24) ;8+8+8
                    , ELP_WriteData(H1, &NewIndexMetaData, NewIndexMetaDataOffset)
                    , ELP_CloseFileHandle(H1)
                    
                    , VarSetCapacity(NewIndexMetaData, NewIndexMetaDataOffset, 0)
                    , VarSetCapacity(NewIndexMetaData, 0)
                    
                    , ELP_SetFilePointer(H2, IndexDataData_FileSize)
                    , ELP_WriteData(H2, New_IndexDataDataAddress, New_IndexDataDataSize)
                    , ELP_CloseFileHandle(H2)
                    
                    , Index_WordsTypedData(0, 0, 0, 1) ;Erases the index data stored in the functions static variable
                    
                }
            }
        }
        
        If (!IsCompatible){
            WordData_MD5Hash := ELP_CalcMD5(&WordData, WordDataFileSize)
            , New_IndexDataAddresses := Index_WordsTypedData(&WordData, WordDataFileSize)
            
            StringSplit, Returned_, New_IndexDataAddresses, |
            
            New_IndexDataMetaDataAddress := Returned_1
            , New_IndexDataPointersAddress := Returned_2
            , New_IndexDataDataAddress := Returned_3
            , New_IndexDataDataSize := Returned_4
            
        ;   MsgBox % Returned_1 "`n" Returned_2 "`n" Returned_3 "`n" Returned_4
            
            , H1 := ELP_OpenFileHandle(FDirectory "\Indexes\Words per time data pointers.index", "Write", IndexDataPointers_FileSize)
            , H2 := ELP_OpenFileHandle(FDirectory "\Indexes\Words per time data data.index", "Write", IndexDataData_FileSize)
            
            , VarSetCapacity(IndexMetaData, 114, 0) ;8+8+8+8+8+50+8+8+8
            , IndexMetaDataOffset := 0
            , NumPut(WordsTyped_IndexVersion, IndexMetaData, IndexMetaDataOffset, "Double") ;IndexVersion for the index file
            , IndexMetaDataOffset += 8
            , NumPut(WordsPerTime_Number, IndexMetaData, IndexMetaDataOffset, "Int64") ;ID number of the data used for the index file
            , IndexMetaDataOffset += 8
            , NumPut(0, IndexMetaData, IndexMetaDataOffset, "Int64") ;StartOffset for the index file
            , IndexMetaDataOffset += 8
            , NumPut(WordDataFileSize, IndexMetaData, IndexMetaDataOffset, "Int64") ;EndOffset for the index file
            , IndexMetaDataOffset += 8
            , NumPut(StrLen(WordData_MD5Hash), IndexMetaData, IndexMetaDataOffset, "Int64") ;MD5HashLength for the index file
            , IndexMetaDataOffset += 8
            
            Loop, Parse, WordData_MD5Hash ;MD5 hash for the index file
                NumPut(A_LoopField, IndexMetaData, IndexMetaDataOffset++, "UChar")
            
            IndexMetaDataOffset += 50 - StrLen(WordData_MD5Hash)
            , NumPut(NumGet(New_IndexDataMetaDataAddress+0, 0, "Int64"), IndexMetaData, IndexMetaDataOffset, "Int64") ;Start date for the index file
            , IndexMetaDataOffset += 8
            , NumPut(NumGet(New_IndexDataMetaDataAddress+0, 8, "Int64"), IndexMetaData, IndexMetaDataOffset, "Int64") ;End date for the index file
            , IndexMetaDataOffset += 8
            , NumPut(NumGet(New_IndexDataMetaDataAddress+0, 16, "Int64"), IndexMetaData, IndexMetaDataOffset, "Int64") ;Length of the data for the index file
            , IndexMetaDataOffset += 8
            
            
            ELP_WriteData(H1, &IndexMetaData, IndexMetaDataOffset)
            
            
        ;   DllCall("WriteFile", "UInt", H1, "UInt", &IndexMetaData, "UInt", IndexMetaDataOffset, "UInt", 0, "UInt", 0)
            , VarSetCapacity(IndexMetaData, IndexMetaDataOffset, 0)
            , VarSetCapacity(IndexMetaData, 0)
            
            , ELP_SetFilePointer(H1, IndexMetaDataOffset)
            , ELP_WriteData(H1, New_IndexDataPointersAddress, NumGet(New_IndexDataMetaDataAddress+0, 16, "Int64"))
            , ELP_CloseFileHandle(H1)
            , ELP_WriteData(H2, New_IndexDataDataAddress, New_IndexDataDataSize)
            , ELP_CloseFileHandle(H2)
            
        ;   , DllCall("SetFilePointerEx", "UInt", H1, "Int64", IndexMetaDataOffset, "UInt *", P, "Int", 0)
        ;   , DllCall("WriteFile", "UInt", H1, "UInt", New_IndexDataPointersAddress, "UInt", NumGet(New_IndexDataMetaDataAddress+0, 16, "Int64"), "UInt", 0, "UInt", 0)
        ;   , DllCall("CloseHandle", "UInt", H1)
        ;   , DllCall("WriteFile", "UInt", H2, "UInt", New_IndexDataDataAddress, "UInt", New_IndexDataDataSize, "UInt", 0, "UInt", 0)
        ;   , DllCall("CloseHandle", "UInt", H2)
            
            
            Index_WordsTypedData(0, 0, 0, 1) ;Erases the index data stored in the functions static variable
        }
        
        VarSetCapacity(WordData, WordDataFileSize, 0)
        , VarSetCapacity(WordData, 0)
    } Else {
        ELP_CloseFileHandle(H)
        , Details_ .= "Words per time data file was not found or is 0 bytes.`r`n"
    }
    
    Return Details_
}

Index_WordsTypedData(_DataAddress, _DataLength, _IndexDataData_Offset = 0, _BlankData = 0)
{
    Global Ptr
    Static IndexWordsTypedSInt64
    , MCodedData
    , Difference
    , IndexMetaData
    , IndexDataPointers
    , IndexDataData
    , IndexDataData_Size
    , Last_VarSize
    
    If (_BlankData){
        VarSetCapacity(IndexMetaData, 24, 0) ;8+8+8
        , VarSetCapacity(IndexMetaData, 0)
        , VarSetCapacity(IndexDataPointers, Difference * 16, 0)
        , VarSetCapacity(IndexDataPointers, 0)
        , VarSetCapacity(IndexDataData, IndexDataData_Size, 0)
        , VarSetCapacity(IndexDataData, 0)
        , IndexDataData_Size := ""
        , Difference := ""
        
        Return
    }
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            Hex_IndexWordsTypedSInt64 =
            (LTrim Join
                48895C241855565741544155415641574883EC50448BA424C00000004C8BD148B900D
                0ED902E00000048894C244048B900A0DB215D000000498BE848890C2448B90070C9B2
                8B00000048B800E876481700000048894C241048B900282E8CD10000004C8BC248894
                C242048B900F81B1D0001000049BE00B864D94500000048894C243048B9005840FBA2
                00000049BF0088526A7400000048894C242848B90040B743BA00000048BA00E092651
                701000048894C241848B90010A5D4E800000033F648894C2438488B8C24D000000049
                8BF948BB0076BE370700000049B90018EE840600000049BB00AC23FC0600000049BD0
                0E288C0060000004C89B424A80000004C897C24084889942490000000483BC80F840B
                010000493BCE0F8402010000493BCF0F84F900000048B8005840FBA2000000483BC80
                F84E600000048B80040B743BA000000483BC80F84D300000048B80010A5D4E8000000
                483BC80F84C0000000483BCA0F84B700000048B800A0DB215D000000483BC80F84A70
                0000048B80070C9B28B000000483BC80F849400000048B800282E8CD1000000483BC8
                0F848100000048B800F81B1D00010000483BC8747248B800D0ED902E000000483BC87
                556418BC425030000807D07FFC883C8FCFFC085C0753CB81F85EB5141F7ECC1FA058B
                C2C1E81F03D06BD264443BE2751DB81F85EB5141F7ECC1FA078BC2C1E81F03D069D29
                0010000443BE275054D8BDDEB124D8BD9EB0D4C8B9C24C8000000EB034C8BDB488B94
                24C80000004C8BBC24D80000004C8BAC24E00000004C8BB424E80000004D8B0A488D1
                C0A4903DF4903DD4903DE4839B424B80000000F8E0502000066666666660F1F840000
                0000004981C6A08601004981FEE0065A000F8E530100004981C5809698004533F6498
                1FD8085B50D0F8E3C0100004981C700CA9A3B4533ED4D3BFB0F8E2901000048B800E8
                76481700000041BF00CA9A3B4803C8483BC80F84DE000000483B8C24A80000000F84D
                0000000483B4C24080F84C5000000483B4C24280F84BA000000483B4C24180F84AF00
                0000483B4C24380F84A4000000483B8C24900000000F8496000000483B0C240F84800
                00000483B4C24107479483B4C24207472483B4C2430746B483B4C2440757A418BC425
                030000807D07FFC883C8FCFFC085C07543B81F85EB5141F7ECC1FA058BC2C1E81F03D
                06BD264443BE2751DB81F85EB5141F7ECC1FA078BC2C1E81F03D069D290010000443B
                E2750C49BB00E288C006000000EB4749BB0018EE8406000000EB3B49BB00AC23FC060
                00000EB0A49BB0076BE3707000000483B8C24900000007E1B488BC848B800A0724E18
                0900004803D041FFC448899424C8000000488B9424C80000004989384983C0084803D
                14C898424980000004533C04903D74903D54903D64C3BCA7D3B4C3BCB7C364883FE01
                7430498B42084983C2104883C508488945F84883C70849FFC04C3B9424B0000000720
                7BE01000000EB034D8B0A4C3BCA7CC5488B842498000000488BDA488B9424C8000000
                4C89004C8BC04983C00848FF8C24B80000000F8508FEFFFF488BC7488B9C24A000000
                04883C450415F415E415D415C5F5E5DC3
            )
        } Else {
            Hex_IndexWordsTypedSInt64 =
            (LTrim Join
                83EC28538B5C2460558B6C246833C056578B7C24608944242089442424894424308D4
                80681FB00E87648750983FD170F844101000081FB00B864D9750983FD450F84300100
                0081FB0088526A750983FD740F841F01000081FB005840FB750C81FDA20000000F840
                B01000081FB0040B743750C81FDBA0000000F84F700000081FB0010A5D4750C81FDE8
                0000000F84E300000081FB00E09265750C81FD170100000F84CF00000081FB00A0DB2
                1750983FD5D0F84B000000081FB0070C9B2750C81FD8B0000000F849C00000081FB00
                282E8C750C81FDD10000000F848800000081FB00F81B1D750881FD00010000747881F
                B00D0ED900F858A00000083FD2E0F85810000008BC7250300008079054883C8FC4075
                45B81F85EB51F7EFC1FA058BC2C1E81F03C26BC0648BD72BD0751DB81F85EB51F7EFC
                1FA078BC2C1E81F03C269C0900100008BD72BD0750EC744241000E288C0894C2414EB
                2CC74424100018EE84894C2414EB1EC744241000AC23FC894C2414EB10C7442410007
                6BE37C7442414070000008B4424648B4C24688B74243C03C313CD03442474134C2478
                0344247C138C248000000003842484000000138C2488000000837C245C00894424288
                B06894C242C8B4E0489442418894C241C0F8C930300007F15837C2458000F86860300
                00EB088B6C24708B7C246081842484000000A0860100B800000000118424880000000
                F883F0200007F1181BC2484000000E0065A000F862C0200008144247C809698008984
                248400000089842488000000118424800000000F88090200007F0E817C247C8085B50
                D0F86F90100008144247400CA9A3B8B4C24788944247C13C889842480000000894C24
                783B4C24140F8CD20100007F0E8B542410395424740F86C201000081C300E8764883D
                517C744247400CA9A3B89442478895C246C896C247081FB00E87648750983FD170F84
                4B01000081FB00B864D9750983FD450F843A01000081FB0088526A750983FD740F842
                901000081FB005840FB750C81FDA20000000F841501000081FB0040B743750C81FDBA
                0000000F840101000081FB0010A5D4750C81FDE80000000F84ED00000081FB00E0926
                5750C81FD170100000F84D900000081FB00A0DB21750983FD5D0F84B600000081FB00
                70C9B2750C81FD8B0000000F84A200000081FB00282E8C750C81FDD10000000F848E0
                0000081FB00F81B1D750881FD00010000747E81FB00D0ED900F859400000083FD2E0F
                858B0000008BC7250300008079054883C8FC407547B81F85EB51F7EFC1FA058BCAC1E
                91F03CA6BC9648BD72BD1751BB81F85EB51F7EFC1FA078BC2C1E81F03C269C0900100
                002BF87512C744241000E288C0C744241406000000EB6DC74424100018EE84C744241
                406000000EB5BC744241000AC23FCC744241406000000EB10C74424100076BE37C744
                24140700000081FD170100007C317F0881FB00E0926576278144246400A0724EBB00E
                87648BD17000000815424681809000047895C246C896C2470897C24608B4424408B4C
                24488B54244C89088B4C246483C0088950FC894424408B44246833D233FF03CB13C50
                34C247413442478034C247C13842480000000038C2484000000138424880000003944
                241C0F8F8A0000007C0A394C24180F837E0000008B5C241C8D49003B5C242C7C6D7F0
                A8B5C24183B5C24287261837C243001750433DB74568B6E088B5C2444892B8B6E0C83
                C30883C6108344244808896BFC895C24448354244C0083C20183D7003B742450720E8
                B5C241CC744243001000000EB0D8B1E895C24188B5E04895C241C3BD87C957F06394C
                2418728D8B5C246C8B6C24408955008B54242483C5088344242001897DFC896C24408
                3D20089542424894C24288944242C3B54245C0F8C8CFCFFFF7F0E8B4424203B442458
                0F827CFCFFFF8B54244C8B4424485F5E5D5B83C428C3
            )
        }
        
        ;SInt64 indexing
        VarSetCapacity(IndexWordsTypedSInt64, StrLen(Hex_IndexWordsTypedSInt64)//2)
        Loop % StrLen(Hex_IndexWordsTypedSInt64)//2
            NumPut("0x" . SubStr(Hex_IndexWordsTypedSInt64, 2*A_Index-1, 2), IndexWordsTypedSInt64, A_Index-1, "Char")
        
        Hex_IndexWordsTypedSInt64 := ""
        , DllCall("VirtualProtect", Ptr, &IndexWordsTypedSInt64, Ptr, VarSetCapacity(IndexWordsTypedSInt64), "uint", 0x40, "uint*", 0)
        , MCodedData := True
    }
    
    QSortInt64(_DataAddress, _DataLength)
    , MinRange := SubStr(NumGet(_DataAddress+0, 0, "Int64"), 1, 12) . 00000
    , Difference := MaxRange := SubStr(NumGet(_DataAddress+0, _DataLength - 16, "Int64"), 1, 12) . 00000
    
    Difference -= MinRange, Seconds
    Difference := (Difference // 60) + 1
    , VarSetCapacity(IndexDataPointers, Difference * 16, 0)
    , VarSetCapacity(IndexDataData, Round((Difference + (_DataLength / 2)) * 8), 0)
    , VarSetCapacity(IndexMetaData, 8 * 3, 0)
    
    , NumPut(MinRange, IndexMetaData, 0, "Int64")
    , NumPut(MaxRange, IndexMetaData, 8, "Int64")
    , NumPut(Difference * 16, IndexMetaData, 16, "Int64")
    , Year := SubStr(MinRange, 1, 4)
    , Month := SubStr(MinRange, 5, 2)
    , Day := SubStr(MinRange, 7, 2)
    , Hour := SubStr(MinRange, 9, 2)
    , Minute := SubStr(MinRange, 11, 2)
    , Year += 0, Month += 0, Day += 0
    , Hour += 0, Minute += 0
    
;   MsgBox % "1`n" Year "`n" Month "`n" Day "`n" Hour "`n" Minute
    
;   MsgBox % "2`n" MinRange "`n" MaxRange "`n" Difference
    
;   MsgBox % "3`n" NumGet(_DataAddress+0, 0, "Int64") "`n" NumGet(_DataAddress+0, 8, "Int64")
    
;   MsgBox % "4`n" "This should be 0: " . _IndexDataData_Offset
    
;   MsgBox % "5`n" _DataAddress "`n" _DataLength "`n" _DataAddress + _DataLength
    
;   MsgBox % "6`n" NumGet(IndexWordsTypedSInt64, 0, "UChar") "`n" NumGet(IndexWordsTypedSInt64, 1, "UChar")
    
;   MsgBox % "Index data size 1: " . IndexDataData_Size "`nIndexdatadataOffset: " _IndexDataData_Offset
    
    IndexDataData_Size := DllCall(&IndexWordsTypedSInt64
        , Ptr, _DataAddress
        , Ptr, &IndexDataPointers
        , Ptr, &IndexDataData
        , "Int64", _IndexDataData_Offset
        , "Int64", _DataAddress + _DataLength
        , "Int64", Difference
        , "Int", Year
        , "Int64", Year * 10000000000000
        , "Int64", Month * 100000000000
        , "Int64", Day * 1000000000
        , "Int64", Hour * 10000000
        , "Int64", Minute * 100000
        , "cdecl int64")
    
;   MsgBox % "Index data size 2: " . IndexDataData_Size
    
;   MsgBox % NumGet(IndexDataPointers, 0, "Int64") "`n" NumGet(IndexDataPointers, 8, "Int64") "`n" NumGet(IndexDataPointers, 16, "Int64")
    
;   MsgBox % NumGet(IndexDataData, 0, "Int64") "`n" NumGet(IndexDataData, 8, "Int64") "`n" NumGet(IndexDataData, 16, "Int64")
    
    IndexDataData_Size -= _IndexDataData_Offset
;   MsgBox % "Index data size 3: " . IndexDataData_Size
    
    , Return_Data := &IndexMetaData . "|" . &IndexDataPointers . "|" . &IndexDataData . "|" . IndexDataData_Size
    
    Return Return_Data
}

QSortInt64(_ListAddress, _Length)
{
    Global Ptr
    Static SortMergeInt64
    , MCodedData
    , SmallerLength
    , SameLength
    , LargerLength
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            SortMergeInt64Hex = 
            (LTrim Join
                48895C240848896C2410488974241848897C242041544155415641574C8B6C2458488B7424504C8B742460488
                B442468488B7C244833ED4C8BFA49896D00498BD94D8BE04D8BD949892E4C8BD18BD548897424584889284C8B
                CF4C8BC64D85FF7E6D4C8BC0498B02493BC47D1E488903498B42084883C310488943F84983C2104883C210498
                3450010EB3A7E1D488906498B42084883C610488946F84983C2104883C21049830010EB1B488907498B420848
                83C710488947F84983C2104883C21049830610493BD77C9B4C8B442458498B55004885D27E344C8D52FF49C1E
                A0449FFC2498BEA48C1E504660F1F440000498B034883C1104983C31049FFCA488941F0498B43F8488941F875
                E4490316483BEA7D384C8BD24C2BD549FFCA49C1EA0449FFC2498BC248C1E0044803E86690498B014883C1104
                983C11049FFCA488941F0498B41F8488941F875E4488B442468480310483BEA7D33482BD548FFCA48C1EA0448
                FFC266660F1F840000000000498B004883C1104983C01048FFCA488941F0498B40F8488941F875E4488B5C242
                8488B6C2430488B742438488B7C2440415F415E415D415CC3
            )
        } Else {
            SortMergeInt64Hex = 
            (LTrim Join
                83EC108B4424388B4C2414538B5C243433D255568B742440891689560489108950048B442448578B7C243C891
                08950048B442438895424108954241489442444897C2438895C243C894C24403954242C0F8CD70000007F0A39
                5424280F86CB0000008B51048954241C3B5424347F517C0C8B113B5424308B54241C732F8B2989500489288B5
                1088950088B510C89500C83C11083C0108344241010BA0000000011542414830610115604EB613B5424347C2A
                7F0C8B113B5424308B54241C761C8B29895304892B8B51088953088B510C89530C8B54244C83C310EB1A8B298
                95704892F8B51088957088B510C89570C8B54244883C71083C1108344241010BD00000000116C241483021011
                6A048B5424143B54242C0F8C47FFFFFF7F0E8B542428395424100F8237FFFFFF33D28B2E8B76048B7C24388B5
                C243C8B44244033C9895424108B542444896C242885F67C3A7F0485ED74348B2A89288B6A048968048B6A0889
                68088B6A0C89680C83C01083C210834424101083D1003BCE7CD88B6C24287F06396C241072CC8B5424488B120
                3EA8B5424488B520413F28B542410896C24283BCE7F397C073BD573338D49008B2F89288B6F048968048B6F08
                8968088B6F0C89680C83C01083C71083C21083D1003BCE7CDA8B6C24287F043BD572D08B7C244C8B3F03EF8B7
                C244C8B7F0413F73BCE7F377C093BD57331EB038D49008B3B89388B7B048978048B7B088978088B7B0C89780C
                83C01083C31083C21083D1003BCE7CD083C21083D1003BCE7CDA7F043BD572D45F5E5D5B83C410C3
            )
        }
        
        VarSetCapacity(SortMergeInt64, StrLen(SortMergeInt64Hex)//2)
        Loop % StrLen(SortMergeInt64Hex)//2
            NumPut("0x" . SubStr(SortMergeInt64Hex, 2*A_Index-1, 2), SortMergeInt64, A_Index-1, "Char")
        
        , DllCall("VirtualProtect", Ptr, &SortMergeInt64, Ptr, VarSetCapacity(SortMergeInt64), "uint", 0x40, "uint*", 0)
        , MCodedData := True
        
        VarSetCapacity(SmallerLength, 8)
        , VarSetCapacity(SameLength, 8)
        , VarSetCapacity(LargerLength, 8)
    }
    
    PivotValue := NumGet(_ListAddress+0, (_Length // 16 // 2) * 16, "Int64")
    , VarSetCapacity(Smaller, _Length)
    , VarSetCapacity(Same, _Length)
    , VarSetCapacity(Larger, _Length)
    , DllCall(&SortMergeInt64
                , Ptr, _ListAddress
                , "Int64", _Length
                , "Int64", PivotValue
                , Ptr, &Smaller
                , Ptr, &Same
                , Ptr, &Larger
                , Ptr, &SmallerLength
                , Ptr, &SameLength
                , Ptr, &LargerLength)
    
    , VarSetCapacity(Smaller, 0)
    , VarSetCapacity(Same, 0)
    , VarSetCapacity(Larger, 0)
    , SML := NumGet(SmallerLength, 0, "Int64")
    , SAL := NumGet(SameLength, 0, "Int64")
    , LAL := NumGet(LargerLength, 0, "Int64")
    
    ;Recursive call and sort the smaller then and greator then sections of the list
    If (SML > 16)
        QSortInt64(_ListAddress, SML)
    If (LAL > 16)
        QSortInt64(_ListAddress + SML + SAL, LAL)
}

Get_NeededSize(ByRef PointerSize, ByRef DataSize, _NewMetaData, _CurrentIndexPointers, _NewIndexPointers)
{
    New_IndexPointersOffset := 0
    , Current_IndexPointersOffset := 0
    
    , CurrentIndexStartDate := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    , CurrentIndexEndDate := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    , CurrentIndexDataLength := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    
    , NewIndexStartDate := NumGet(_NewMetaData+0, 0, "Int64")
    , NewIndexEndDate := NumGet(_NewMetaData+0, 8, "Int64")
    , NewIndexDataLength := NumGet(_NewMetaData+0, 16, "Int64")
    
    , MergedDateStart := CurrentIndexStartDate < NewIndexStartDate ? CurrentIndexStartDate : NewIndexStartDate
    , MergedDateEnd := CurrentIndexEndDate > NewIndexEndDate ? CurrentIndexEndDate : NewIndexEndDate
    
    , MergedDateDifference := MergedDateEnd
    MergedDateDifference -= MergedDateStart, Seconds
    MergedDateDifference := (MergedDateDifference // 60) + 1
    
    , PointerSize := 8 + 8 + 8 + (MergedDateDifference * 16)
    
    , Temp := CurrentIndexEndDate
    Temp -= CurrentIndexStartDate, Seconds
    Temp := (Temp // 60) * 16
    , Temp += Current_IndexPointersOffset
    
    , Pointer := NumGet(_CurrentIndexPointers+0, Temp, "Int64")
    , Pointer += NumGet(_CurrentIndexPointers+0, Temp + 8, "Int64") * 8
    
    , Current_IndexDataSize := Pointer
    
    , Temp := NewIndexEndDate
    Temp -= NewIndexStartDate, Seconds
    Temp := (Temp // 60) * 16
    , Temp += New_IndexPointersOffset
    
    , BasePointer := NumGet(_NewIndexPointers+0, New_IndexPointersOffset, "Int64")
    , Pointer := NumGet(_NewIndexPointers+0, Temp, "Int64")
    , Pointer += NumGet(_NewIndexPointers+0, Temp + 8, "Int64") * 8
    , Pointer -= BasePointer
    
    , New_IndexDataSize := Pointer
    , DataSize := Current_IndexDataSize + New_IndexDataSize
    
    
;   O .= " CurrentIndexStartDate: " CurrentIndexStartDate
;   O .= "`r`n CurrentIndexEndDate: " CurrentIndexEndDate
;   O .= "`r`n CurrentIndexDataLength: " CurrentIndexDataLength
;   O .= "`r`n NewIndexStartDate: " NewIndexStartDate
;   O .= "`r`n NewIndexEndDate: " NewIndexEndDate
;   O .= "`r`n NewIndexDataLength: " NewIndexDataLength
;   O .= "`r`n MergedDateStart: " MergedDateStart
;   O .= "`r`n MergedDateEnd: " MergedDateEnd
;   O .= "`r`n MergedDateDifference: " MergedDateDifference
;   O .= "`r`n PointerSize: " PointerSize
;   O .= "`r`n Current_IndexDataSize: " Current_IndexDataSize
;   O .= "`r`n New_IndexDataSize: " New_IndexDataSize
;   O .= "`r`n DataSize: " DataSize
    
    ;MsgBox % "Get size:`n`n" O
}

Merge_WordsTyped(_MergedPointers, _MergedData, _NewMetaData, _CurrentIndexPointers, _CurrentIndexData, _NewIndexPointers, _NewIndexData)
{
    Merged_PointersOffset := Merged_DataOffset := 0
    , Current_IndexPointersOffset := New_IndexPointersOffset := 0
    
    , CurrentIndexStartDate := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    , CurrentIndexEndDate := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    , CurrentIndexDataLength := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
    , Current_IndexPointersOffset += 8
    
    , NewIndexStartDate := NumGet(_NewMetaData+0, 0, "Int64")
    , NewIndexEndDate := NumGet(_NewMetaData+0, 8, "Int64")
    , NewIndexDataLength := NumGet(_NewMetaData+0, 16, "Int64")
    
    , MergedDateStart := CurrentIndexStartDate < NewIndexStartDate ? CurrentIndexStartDate : NewIndexStartDate
    , MergedDateEnd := CurrentIndexEndDate > NewIndexEndDate ? CurrentIndexEndDate : NewIndexEndDate
    
    , MergedDateDifference := MergedDateEnd
    MergedDateDifference -= MergedDateStart, Seconds
    MergedDateDifference := (MergedDateDifference // 60) + 1
    
    , CurrentIndexStartPosition := CurrentIndexStartDate
    CurrentIndexStartPosition -= MergedDateStart, Seconds
    CurrentIndexStartPosition := (CurrentIndexStartPosition // 60) * 16
    
    , CurrentIndexEndPosition := CurrentIndexEndDate
    CurrentIndexEndPosition -= MergedDateStart, Seconds
    CurrentIndexEndPosition := (CurrentIndexEndPosition // 60) * 16
    
    , NewIndexStartPosition := NewIndexStartDate
    NewIndexStartPosition -= MergedDateStart, Seconds
    NewIndexStartPosition := (NewIndexStartPosition // 60) * 16
    
    , NewIndexEndPosition := NewIndexEndDate
    NewIndexEndPosition -= MergedDateStart, Seconds
    NewIndexEndPosition := (NewIndexEndPosition // 60) * 16
    
    , LoopNumber := MergedDateDifference
    , MergedDateDifference *= 16
    
    , NumPut(MergedDateStart, _MergedPointers+0, Merged_PointersOffset, "Int64")
    , Merged_PointersOffset += 8
    , NumPut(MergedDateEnd, _MergedPointers+0, Merged_PointersOffset, "Int64")
    , Merged_PointersOffset += 8
    , NumPut(MergedDateDifference, _MergedPointers+0, Merged_PointersOffset, "Int64")
    , Merged_PointersOffset += 8
    
    , CurrentIndexStartPosition += 24
    , CurrentIndexEndPosition += 24
    
    , NewIndexStartPosition += 24
    , NewIndexEndPosition += 24
    
    BasePointer := NumGet(_NewIndexPointers+0, New_IndexPointersOffset, "Int64")
    
;   O .= " CurrentIndexStartDate: " CurrentIndexStartDate
;   O .= "`r`n CurrentIndexEndDate: " CurrentIndexEndDate
;   O .= "`r`n CurrentIndexDataLength: " CurrentIndexDataLength
;   O .= "`r`n NewIndexStartDate: " NewIndexStartDate
;   O .= "`r`n NewIndexEndDate: " NewIndexEndDate
;   O .= "`r`n NewIndexDataLength: " NewIndexDataLength
;   O .= "`r`n MergedDateStart: " MergedDateStart
;   O .= "`r`n MergedDateEnd: " MergedDateEnd
;   O .= "`r`n MergedDateDifference: " MergedDateDifference
;   O .= "`r`n CurrentIndexStartPosition: " CurrentIndexStartPosition
;   O .= "`r`n CurrentIndexEndPosition: " CurrentIndexEndPosition
;   O .= "`r`n NewIndexStartPosition: " NewIndexStartPosition
;   O .= "`r`n NewIndexEndPosition: " NewIndexEndPosition
    
;   MsgBox % O
    
    Loop, % LoopNumber
    {
        NumPut(Merged_DataOffset, _MergedPointers+0, Merged_PointersOffset, "Int64")
        , Entries_IndexCount := 0
        
        If (Merged_PointersOffset >= CurrentIndexStartPosition And Merged_PointersOffset <= CurrentIndexEndPosition){
            TIndex_Pointer := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
            , Current_IndexPointersOffset += 8
            , TIndex_Entries := NumGet(_CurrentIndexPointers+0, Current_IndexPointersOffset, "Int64")
            , Current_IndexPointersOffset += 8
            , Entries_IndexCount += TIndex_Entries
            
            , I := 0
            Loop, % TIndex_Entries
            {
                NumPut(NumGet(_CurrentIndexData+0, TIndex_Pointer+I, "Int64"), _MergedData+0, Merged_DataOffset, "Int64"), I += 8
                , Merged_DataOffset += 8
            }
        }
        
        If (Merged_PointersOffset >= NewIndexStartPosition And Merged_PointersOffset <= NewIndexEndPosition){
            TIndex_Pointer := NumGet(_NewIndexPointers+0, New_IndexPointersOffset, "Int64")
            , New_IndexPointersOffset += 8
            , TIndex_Entries := NumGet(_NewIndexPointers+0, New_IndexPointersOffset, "Int64")
            , New_IndexPointersOffset += 8
            , Entries_IndexCount += TIndex_Entries
            
            , TIndex_Pointer -= BasePointer
            , I := 0
            Loop, % TIndex_Entries
            {
                V := NumGet(_NewIndexData+0, TIndex_Pointer+I, "Int64")
                , NumPut(V, _MergedData+0, Merged_DataOffset, "Int64")
                , I += 8
                , Merged_DataOffset += 8
            }
        }
        
        Merged_PointersOffset += 8
        , NumPut(Entries_IndexCount, _MergedPointers+0, Merged_PointersOffset, "Int64")
        , Merged_PointersOffset += 8
    }
}



DateDifference(_Date1, _Date2, _Signed = 0)
{
    Len1 := StrLen(_Date1)
    , Len2 := StrLen(_Date2)
    
    If (Len1 = 14)
        _Date1 .= 000, Len1 := 17
    If (Len2 = 14)
        _Date2 .= 000, Len2 := 17
    
    If (Len1 != Len2)
        MsgBox Something is wrong with the dates provided to DateDifference() - the 2 dates aren't the same length: %_Date1% - %_Date2%`n%Len1%`n%Len2%`n`nPlease report this error to the author along with what you did before it showed.
    
    If (SubStr(_Date1, -2) != 000)
        _Date1 := SubStr(_Date1, 1, StrLen(_Date1) - 3)
    If (SubStr(_Date2, -2) != 000)
        _Date2:= SubStr(_Date2, 1, StrLen(_Date2) - 3)
    
    If (_Date1 > _Date2){
        Difference_ := _Date1
        Difference_ -= _Date2, Seconds
    } Else If (_Date2 > _Date1){
        Difference_ := _Date2
        Difference_ -= _Date1, Seconds
        
        If (_Signed)
            Difference_ -= Difference_ * 2
    }
    
    Difference_ := (Difference_ // 60)
    
    Return Difference_ ? Difference_ : 0
}

Get_ComputerDataFolderNames()
{
    Global RootDirectory
    
    Loop
    {
        FName := ELP_LoopFilePattern(RootDirectory "\*.*", 2)
        If (!FName)
            Break
        
        FName := SubStr(FName, InStr(FName, "\", False, 0) + 1)
        
        All_Computers .= All_Computers = "" ? FName : "|" FName
    }
    
    Return All_Computers
}

VerifyStoredData(_What = "All", _ShowMessage = 1)
{
    Global
    Local H
    , FileSize
    , MouseData
    , ErrorsFixed
    , KeyData
    , KeyFile
    , ErrorNumber
    , E
    , WordsPerTimeData
    , New_MouseDataLength
    , New_KeyDataLength
    , New_WordsPerTimeDataLength
    , RightNow
    , Temp_Name
    , Temp_Name2
    , I
    , What_IsNumber
    , FFullPaths
    , FName
    , FDirectory
    , Computers
    
    Critical, On
    
    If (InStr(_What, "\"))
    {
        FFullPaths := SubStr(_What, 1, InStr(_What, "\", False, 0) - 1)
        , FName := SubStr(_What, InStr(_What, "\", False, 0)+1)
        
        If (InStr(FName, "Key Data"))
            _What := "Key Data"
        Else If (InStr(FName, "Words"))
            _What := "Words per ?"
        Else If (InStr(FName, "Mouse"))
            _What := "Mouse Movement Data"
        Else If (InStr(FName, "Key "))
            _What := SubStr(FName, InStr(FName, " ")+1) ;Key ID
        Else
            Return -1
    }
    
    If (_What = "All")
    {
        Computers := Get_ComputerDataFolderNames()
        
        Loop, Parse, Computers, |
        {
            FFullPaths .= FFullPaths = "" ? "" : "`n"
            FFullPaths .= RootDirectory "\" A_LoopField
        }
    }
    
    Save_AllData(1)
    
    If (Save_DataMethod = 2)
        Close_FileHandles()
    
    RightNow := A_YYYY A_MM A_DD A_Hour A_Min 00000
    RightNow += 1, Minutes
    RightNow .= 000
    
    Loop, Parse, FFullPaths, `n
    {
        TRootDirectory := A_LoopField
        
        If (_What = "All" Or _What = "Mouse movement data")
        {
            ;Validates the mouse movement data
            ;More complicated then the key/mouse clicking data
            FFullPath := TRootDirectory "\Mouse Movement\Mouse Movement Data"
            
            H := ELP_OpenFileHandle(FFullPath, "Read", FileSize)
            
            If (FileSize != 0){
                FileSize := (Ceil((FileSize - 8) / 32) * 32) + 8
                If (FileSize < 40){
                    ELP_CloseFileHandle(H)
                    , ResetCounters(TRootDirectory "\Mouse Movement", "Mouse Movement", 0)
                    , ErrorsFixed .= "Mouse pixel movement data file had corruption and was reset.`n"
                } Else {
                    VarSetCapacity(MouseData, FileSize, 0)
                    , ELP_ReadData(H, &MouseData, FileSize)
                    , ELP_CloseFileHandle(H)
                    
                    , New_MouseDataLength := Validate_MouseData(&MouseData, FileSize, RightNow)
                    
                    , ErrorNumber := FileSize - New_MouseDataLength
                    
                    If (ErrorNumber){
                        Temp_Name := Get_RandomResetName(FFullPath, " - Mouse Movement Data.verification")
                        
                        H := ELP_OpenFileHandle(Temp_Name, "Write")
                        , E := ELP_WriteData(H, &MouseData, New_MouseDataLength)
                        , ELP_CloseFileHandle(H)
                        
                        If (E = New_MouseDataLength)
                        {
                            Temp_Name2 := Get_RandomResetName(FFullPath, " - Mouse Movement Data.corrupt")
                            If (!E := ELP_FileMove(FFullPath, Temp_Name2, 1, 0, 0))
                                E += ELP_FileMove(Temp_Name, FFullPath, 1, 0, 0)
                        }
                        
                        If (E)
                            ErrorsFixed .= "Unable to replace the pixels mouse movement data file with with the new corrected data.`n"
                        Else If (ErrorNumber = 1)
                            ErrorsFixed .= ErrorNumber " error was found in the pixels mouse movement data and it was corrected.`n"
                        Else
                            ErrorsFixed .= ErrorNumber " errors where found in the pixels mouse movement data and they where corrected.`n"
                    }
                    
                    VarSetCapacity(MouseData, FileSize, 0)
                    , VarSetCapacity(MouseData, 0)
                }
            } Else
                ELP_CloseFileHandle(H)
        }
        
        If (_What = "All" Or _What = "Words per ?")
        {
            ;Validates the words per ? data
            FFullPath := TRootDirectory "\Word Speed\Words per time data"
            
            H := ELP_OpenFileHandle(FFullPath, "Read", FileSize)
            
            If (FileSize != 0){
                FileSize := Ceil(FileSize / 8) * 8
                , VarSetCapacity(WordsPerTimeData, FileSize, 0)
                , ELP_ReadData(H, &WordsPerTimeData, FileSize)
                , ELP_CloseFileHandle(H)
                
                , New_WordsPerTimeDataLength := Validate_WordData(&WordsPerTimeData, FileSize, RightNow)
                
                , ErrorNumber := FileSize - New_WordsPerTimeDataLength
                
                If (ErrorNumber){
                    Temp_Name := Get_RandomResetName(FFullPath, " - Words per time data.verification")
                    
                    H := ELP_OpenFileHandle(Temp_Name, "Write")
                    , E := ELP_WriteData(H, &WordsPerTimeData, New_WordsPerTimeDataLength)
                    , ELP_CloseFileHandle(H)
                    
                    If (E = New_WordsPerTimeDataLength){
                        Temp_Name2 := Get_RandomResetName(FFullPath, " - Words per time data.corrupt")
                        
                        If (!E := ELP_FileMove(FFullPath, Temp_Name2, 1, 0, 0))
                            E += ELP_FileMove(Temp_Name, FFullPath, 1, 0, 0)
                    }
                    
                    If (E)
                        ErrorsFixed .= "Unable to replace the Words per time data file with with the new corrected data.`n"
                    If (ErrorNumber = 1)
                        ErrorsFixed .= ErrorNumber " error was found in the Words per time file and it was corrected.`n"
                    Else
                        ErrorsFixed .= ErrorNumber " errors where found in the Words per time file and they where corrected.`n"
                }
                
                VarSetCapacity(WordsPerTimeData, FileSize, 0)
                , VarSetCapacity(WordsPerTimeData, 0)
            } Else
                ELP_CloseFileHandle(H)
        }
        
        If _What Is Number
            What_IsNumber := True
        
        If (_What = "All" Or _What = "Key Data" Or What_IsNumber)
        {
            FFullPath := TRootDirectory "\Keys"
            
            If (ELP_FileExists(FFullPath, 1, 0, 0)){
                ;Validates the key/mouse data
                
                If (What_IsNumber){
                    KeyFile := _What
                    , H := ELP_OpenFileHandle(FFullPath "\Key " KeyFile, "Read", FileSize)
                        
                    If (FileSize != 0){
                        FileSize := Ceil(FileSize / 8) * 8
                        , VarSetCapacity(KeyData, FileSize, 0)
                        , ELP_ReadData(H, &KeyData, FileSize)
                        , ELP_CloseFileHandle(H)
                        
                        , New_KeyDataLength := Validate_KeyData(&KeyData, FileSize, RightNow)
                        
                        , ErrorNumber := (FileSize - New_KeyDataLength)
                        
                        If (ErrorNumber){
                            Temp_Name := Get_RandomResetName(FFullPath, " - Key " KeyFile ".verification")
                            
                            H := ELP_OpenFileHandle(Temp_Name, "Write")
                            , E := ELP_WriteData(H, &KeyData, New_KeyDataLength)
                            , ELP_CloseFileHandle(H)
                            
                            If (E = New_KeyDataLength){
                                Temp_Name2 := Get_RandomResetName(FFullPath, " - Key " KeyFile ".corrupt")
                        
                                If (!E := ELP_FileMove(FFullPath "\Key " KeyFile, Temp_Name2, 1, 0, 0))
                                    E += ELP_FileMove(Temp_Name, FFullPath "\Key " KeyFile, 1, 0, 0)
                            }
                            
                            If (E)
                                ErrorsFixed .= "Unable to replace the key data file " KeyFile " with with the new corrected data.`n"
                            If (ErrorNumber = 1)
                                ErrorsFixed .= ErrorNumber " error was found in key file " KeyFile " and it was removed.`n"
                            Else
                                ErrorsFixed .= ErrorNumber " errors where found in key file " KeyFile " and they where removed.`n"
                        }
                        
                        VarSetCapacity(KeyData, FileSize, 0)
                        , VarSetCapacity(KeyData, 0)
                    } Else
                        ELP_CloseFileHandle(H)
                } Else {
                    I := Range0_Lower + 1 ;Skip range 1
                    
                    Loop, % Range0_Used - 1 ;Skip range 1
                    {
                        KeyFile := Range%I%_Lower
                        
                        Loop, % Range%I%_Used
                        {
                            H := ELP_OpenFileHandle(FFullPath "\Key " KeyFile, "Read", FileSize)
                            
                            If (FileSize != 0){
                                FileSize := Ceil(FileSize / 8) * 8
                                , VarSetCapacity(KeyData, FileSize, 0)
                                , ELP_ReadData(H, &KeyData, FileSize)
                                , ELP_CloseFileHandle(H)
                                
                                , New_KeyDataLength := Validate_KeyData(&KeyData, FileSize, RightNow)
                                
                                , ErrorNumber := (FileSize - New_KeyDataLength) // 8
                                
                                If (ErrorNumber){
                                    Temp_Name := Get_RandomResetName(FFullPath, " - Key " KeyFile ".verification")
                                    
                                    H := ELP_OpenFileHandle(Temp_Name, "Write")
                                    , E := ELP_WriteData(H, &KeyData, New_KeyDataLength)
                                    , ELP_CloseFileHandle(H)
                                    
                                    If (E = New_KeyDataLength){
                                        Temp_Name2 := Get_RandomResetName(FFullPath, " - Key " KeyFile ".corrupt")
                        
                                        If (!E := ELP_FileMove(FFullPath "\Key " KeyFile, Temp_Name2, 1, 0, 0))
                                            E += ELP_FileMove(Temp_Name, FFullPath "\Key " KeyFile, 1, 0, 0)
                                    }
                                    
                                    If (E)
                                        ErrorsFixed .= "Unable to replace the key data file " KeyFile " with with the new corrected data.`n"
                                    If (ErrorNumber = 1)
                                        ErrorsFixed .= ErrorNumber " error was found in key file " KeyFile " and it was removed.`n"
                                    Else
                                        ErrorsFixed .= ErrorNumber " errors where found in key file " KeyFile " and they where removed.`n"
                                }
                                
                                VarSetCapacity(KeyData, FileSize, 0)
                                , VarSetCapacity(KeyData, 0)
                            } Else
                                ELP_CloseFileHandle(H)
                                
                            KeyFile ++
                        }
                        
                        I ++
                    }
                }
            }
        }
    }
    
    If (!What_IsNumber){
        If (ErrorsFixed){
            UpdateCounts()
            , UpdateToolTip()
        }
    }
    
    If (Save_DataMethod = 2)
        Open_FileHandlesWrite()
    
    Critical, Off
    
    If (_ShowMessage){
        If (ErrorsFixed)
            MsgBox %ErrorsFixed%
        Else
            MsgBox No errors found.
    }
}

Validate_KeyData(_DA, _DS, _Now)
{
    Global Ptr
    Static MCodedData, VerifyKeyData
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            VKD =
            (LTrim Join
                4C8BCA488BC14C2BC9483BCA733149BA009280C207724700488B08493BCA7C0B493B
                C87F064883C008EB0F488B4AF84883EA084983E908488908483BC272D9498BC1C3
            )
        } Else {
            VKD =
            (LTrim Join
                8B4C2404538BC199568B742410578BF88BDA8BC6992BC71BD33BCE7346558B6C241C
                8B79048B1981FF077247007C1B7F0881FB009280C272113B7C24207F0B7C043BDD77
                0583C108EB148B7EF883EE0889398B7E0483C0F889790483D2FF3BCE72C05D5F5E5B
                C3
            )
        }
        
        VarSetCapacity(VerifyKeyData, StrLen(VKD) // 2)
        Loop, % StrLen(VKD) // 2
            NumPut("0x" . SubStr(VKD, 2 * A_Index - 1, 2), VerifyKeyData , A_Index - 1, "Char")
        
        DllCall("VirtualProtect", Ptr, &VerifyKeyData, Ptr, VarSetCapacity(VerifyKeyData), "uint", 0x40, "uint*", 0)
        , VKD := ""
        , MCodedData := True
    }
    
    Verified_Size := DllCall(&VerifyKeyData, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "cdecl Int64")
    
    Return Verified_Size < 0 ? 0 : Verified_Size
}

Validate_WordData(_DA, _DS, _Now)
{
    Global Ptr
    Static MCodedData, VerifyWordData
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            VWD =
            (LTrim Join
                488BC24D8BD04C8BC9482BC1483BCA734849BB009280C2077247000F1F440000498B
                094D8B41084983C110493BCB7C0A493BCA7F054D85C0751A488B4AF84883EA104983
                E91049894908488B0A4883E8104989094C3BCA72C7F3C3
            )
        } Else {
            VWD =
            (LTrim Join
                83EC088B4C240C538BC199568B742418578BF88BDA8BC6992BC71BD38944240C3BCE
                7361558B79048B198B69088B410C83C11081FF077247007C1C7F0881FB009280C272
                123B7C24287F0C7C063B5C242477040BE875258B46F88941F88B46FC8941FC8B46F0
                83EE1083E91083442410F089018B460489410483D2FF3BCE72A58B4424105D5F5E5B
                83C408C3
            )
        }
        
        VarSetCapacity(VerifyWordData, StrLen(VWD) // 2)
        Loop, % StrLen(VWD) // 2
            NumPut("0x" . SubStr(VWD, 2 * A_Index - 1, 2), VerifyWordData , A_Index - 1, "Char")
        
        DllCall("VirtualProtect", Ptr, &VerifyWordData, Ptr, VarSetCapacity(VerifyWordData), "uint", 0x40, "uint*", 0)
        , VWD := ""
        , MCodedData := True
    }
    
    Verified_Size := DllCall(&VerifyWordData, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "cdecl Int64")
    
    Return Verified_Size < 0 ? 0 : Verified_Size
}

Validate_MouseData(_DA, _DS, _Now, _DataType = 1)
{
    ;_DataType =  0 | part data with no version # + fix
    ;_DataType =  1 | full data with version # + fix
    Global Ptr
    Static MCodedData, VerifyMouseMovementData
    
    If (!MCodedData){
        If (A_PtrSize = 8){
            VMMD =
            (LTrim Join
                4C8BDA4C8BD14C2BD94983F90175044983C2084C3BD273514883C2F049B9009280C2
                07724700498B02493BC17C0B493BC07F064983C220EB27488B42084983EB204883EA
                2049894218488B422049894210488B4A1849894A08488B4A1049890A488D4A104C3B
                D172BD498BC3C3
            )
        } Else {
            VMMD =
            (LTrim Join
                8B4C2404538BC199568B742410578BF88BDA8BC6992BC71BD3837C242001750A837C
                242400750383C1083BCE7379558B6C241C83C6F0EB088DA42400000000908B79048B
                1981FF077247007C1B7F0881FB009280C272113B7C24207F0B7C043BDD770583C120
                EB378B7E088979188B7E0C89791C8B3E8979108B7E048979148B7EF88979088B7EFC
                89790C8B7EF089398B7EF483EE2083C0E089790483D2FF8D7E103BCF729A5D5F5E5B
                C3
            )
        }
        
        VarSetCapacity(VerifyMouseMovementData, StrLen(VMMD) // 2)
        Loop, % StrLen(VMMD) // 2
            NumPut("0x" . SubStr(VMMD, 2 * A_Index - 1, 2), VerifyMouseMovementData , A_Index - 1, "Char")
        
        DllCall("VirtualProtect", Ptr, &VerifyMouseMovementData, Ptr, VarSetCapacity(VerifyMouseMovementData), "uint", 0x40, "uint*", 0)
        , VMMD := ""
        , MCodedData := True
    }
    
    Verified_Size := DllCall(&VerifyMouseMovementData, Ptr, _DA, Ptr, _DA + _DS, "Int64", _Now, "Int64", _DataType, "cdecl Int64")
    
    Return Verified_Size < 0 ? 0 : Verified_Size
}

;**********************************
; End Indexing and reporting functions
;**********************************

;**********************************
; Misc includes
;**********************************

ResetCounters_GUI(_Cmd = "", _GuiEvent = "", _EventInfo = "", _GuiControl = "")
{
    Static
    Static N := 8
    , IsShowing := False
    , CBStates
    , LVCBStates
    , CBStates_Size
    , CBDisabled    
    
    Global RootDirectory
    
    Local CheckedCount
    , IsChecked
    , Row
    , Computers
    , SelectedRow
    , IsRowChecked
    , ComputerName
    , ResetPaths
    , T
    , Reset
    , Reset1
    , Reset2
    , ResetCount
    
    Critical, On
    
    If (_Cmd = "Check All")
    {
        ; Checks or unchecks all the check boxes depending if they're all already checked or not
        Gui, %N%:Submit, NoHide
        Gui, %N%:Listview, SelectedComputers
        Gui, %N%:Default
        
        ; Enables the checkboxes if they haven't been enabled yet
        If (CBDisabled)
        {
            Loop, 5
                GuiControl, Enable, CB%A_Index%
            
            
            
            CBDisabled := False
        }
        
        ; Count how many of the check boxes are selected both the computers and the sub options for each
        CheckedCount := 0
        
        Loop, % CBStates_Size / 5
        {
            If (NumGet(LVCBStates, A_Index - 1, "UChar"))
                CheckedCount ++
        }
        
        If (CheckedCount)
        {
            Loop, % CBStates_Size
            {
                If (NumGet(CBStates, A_Index - 1, "Uchar"))
                    CheckedCount ++
            }
        }
        
        ; Check if no row is selected (fresh GUI - no clicks on computers yet) and if none are, set the "selected computer" to the first one in the list
        If (LV_GetNext("Selected") = 0)
        {
            LV_GetText(SelectedComputer, 1)
            LV_Modify(1, "Select")
            GuiControl,, CurrentSelectedComputer, % SelectedComputer
        }
        
        ; If every computer is selected and every sub option for every computer is selected, deselect everything
        If (CheckedCount = (CBStates_Size + (CBStates_Size / 5)))
        {
            VarSetCapacity(CBStates, CBStates_Size, 0)
            , VarSetCapacity(LVCBStates, CBStates_Size / 5, 0)
            
            Loop, % LV_GetCount()
                LV_Modify(A_Index, "-check")
            
            Loop, 5
                GuiControl,, CB%A_Index%, 0
        } Else ; Else select everything
        {
            VarSetCapacity(CBStates, CBStates_Size, 1)
            , VarSetCapacity(LVCBStates, CBStates_Size / 5, 1)
            
            Loop, % LV_GetCount()
                LV_Modify(A_Index, "check")
            
            Loop, 5
                GuiControl,, CB%A_Index%, 1
        }
        
        Critical, Off
        
        Return
    } Else IF (_Cmd = "Check All SCBs")
    {
        ; Checks all of the sub options for the currently selected computer
        SelectedRow := LV_GetNext("Selected")
        
        If (SelectedRow)
        {
            Loop, 5
            {
                If (!NumGet(CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar"))
                {
                    NumPut(1, CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar")
                    
                    GuiControl,, CB%A_Index%, 1
                }
            }
        }
        
        Return
    } Else If (_Cmd = "UnCheck All SCBs")
    {
        ; Unchecks all of the sub options for the currently selected computer
        SelectedRow := LV_GetNext("Selected")
        
        If (SelectedRow)
        {
            Loop, 5
            {
                If (NumGet(CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar"))
                {
                    NumPut(0, CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar")
                    
                    GuiControl,, CB%A_Index%, 0
                }
            }
        }
        
        Return
    } Else If (_Cmd = "ListView")
    {
        Gui, %N%:Submit, NoHide
        Gui, %N%:Listview, SelectedComputers
        Gui, %N%:Default
        
        ; Records the selected row and makes sure even if check boxes are clicked the row gets selected
        Loop, % LV_GetCount()
        {
            Row := A_Index
            SendMessage, 4140, Row - 1, 0xF000, SysListView321
            IsRowChecked := (ErrorLevel >> 12) - 1
            
            If (IsRowChecked)
            {
                If (!NumGet(LVCBStates, Row - 1, "UChar"))
                {
                    NumPut(1, LVCBStates, Row - 1, "UChar")
                    , LV_Modify(Row, "Focus Select")
                    , ResetCounters_GUI("Check All SCBs")
                }
            } Else
            {
                If (NumGet(LVCBStates, Row - 1, "UChar"))
                {
                    NumPut(0, LVCBStates, Row - 1, "UChar")
                    , LV_Modify(Row, "Focus Select")
                    , ResetCounters_GUI("UnCheck All SCBs")
                }
            }
        }
        
        SelectedRow := LV_GetNext("Selected")
        
        If (SelectedRow != 0)
        {
            LV_GetText(SelectedComputer, SelectedRow)
            GuiControl,, CurrentSelectedComputer, % SelectedComputer
            
            ; Enables the checkboxes the first time any computer is selected
            If (CBDisabled)
            {
                Loop, 5
                    GuiControl, Enable, CB%A_Index%
                
                CBDisabled := False
            }
            
            ; Modifies the sub options for the newly selected computer to display accurately
            Loop, 5
            {
                GuiControlGet, IsChecked,, CB%A_Index%
                
                If (NumGet(CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar"))
                {
                    If (!IsChecked)
                        GuiControl,, CB%A_Index%, 1
                } Else If (IsChecked)
                    GuiControl,, CB%A_Index%, 0
            }
        }
        
        Critical, Off
        
        return
    } Else If (_Cmd = "CheckBox")
    {
        Gui, %N%:Submit, NoHide
        Gui, %N%:Listview, SelectedComputers
        Gui, %N%:Default
        
        SelectedRow := LV_GetNext("Selected")
        , CheckedCount := 0
        
        Loop, 5
        {
            GuiControlGet, IsChecked,, CB%A_Index%
            
            If (IsChecked)
            {
                NumPut(1, CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar")
                , CheckedCount ++
            } Else
                NumPut(0, CBStates, ((SelectedRow - 1) * 5) + (A_Index - 1), "UChar")
        }
        
        If (!CheckedCount)
        {
            If (NumGet(LVCBStates, (SelectedRow - 1), "UChar"))
            {
                NumPut(0, LVCBStates, (SelectedRow - 1), "UChar")
                , LV_Modify(SelectedRow, "-Check")
            }
        } Else
        {
            If (!NumGet(LVCBStates, (SelectedRow - 1), "UChar"))
            {
                NumPut(1, LVCBStates, (SelectedRow - 1), "UChar")
                , LV_Modify(SelectedRow, "Check")
            }
        }
        
        Critical, Off
        
        Return
    } Else If (_Cmd = "Reset")
    {
        Msg := ""
        , ResetPaths := ""
        , ResetCount := 0
        
        Loop, % CBStates_Size / 5
        {
            Row := A_Index
            , ComputerName := ""
            
            Loop, 5
            {
                If (NumGet(CBStates, ((Row - 1) * 5) + (A_Index - 1), "UChar"))
                {
                    If (ComputerName = "")
                    {
                        LV_GetText(ComputerName, Row)
                        , Msg .= Msg = "" ? "" : "`n"
                        , Msg .= ComputerName
                    }
                    
                    If (A_Index = 1)
                        T := "Mouse Buttons"
                    Else If (A_Index = 2)
                        T := "Keyboard Keys"
                    Else If (A_Index = 3)
                        T := "Mouse Movement"
                    Else If (A_Index = 4)
                        T := "Word Data"
                    Else If (A_Index = 5)
                        T := "HD Activity"
                    
                    Msg .= "`n" A_Tab T
                    , ResetPaths .= ResetPaths = "" ? RootDirectory "\" ComputerName "|" T : "`n" RootDirectory "\" ComputerName "|" T
                    , ResetCount ++
                }
            }
        }
        
        If (Msg)
        {
            MsgBox, 0x4, Are you sure?, Are you sure you want to reset the following counters:`n`n%Msg%
            
            IfMsgBox, Yes
            {
                Loop, Parse, ResetPaths, `n
                {
                    StringSplit, Reset, A_LoopField, |
                    ResetCounters(Reset1, Reset2, 0, A_Index = ResetCount ? 1 : 0)
                }
                
                MsgBox, Counter(s) reset complete.
            }
        }
    } Else If (_Cmd = "Destroy")
    {
        Gui, %N%:Destroy
        IsShowing := False
        Return
    }
    
    If (IsShowing)
        Return
    
    IsShowing := True
    
    Computers := Get_ComputerDataFolderNames()
    
    Gui, %N%:Default
    Gui, %N%:Font, S10
    Gui, %N%:+LabelResetCounters
    
    Gui, %N%:Add, GroupBox, x10 y10 w475 h400, Select data counters to reset
    Gui, %N%:Add, Button, x20 y33 w225 gResetCountersCheckAll, Check/Uncheck All
    Gui, %N%:Add, ListView, x20 y73 w225 h325 AltSubmit Checked Grid -Hdr -multi vSelectedComputers gResetCountersSelectComputer, Computers
    
    Gui, %N%:Listview, SelectedComputers
    Gui, %N%:Add, Text, x295 y73 w180 vCurrentSelectedComputer, -Select Computer-
    
    CBStates_Size := 0
    Loop, Parse, Computers, |
    {
        LV_Add("", A_LoopField, A_LoopField)
        , CBStates_Size += 5
    }
    
    VarSetCapacity(CBStates, CBStates_Size, 0)
    , VarSetCapacity(LVCBStates, CBStates_Size / 5, 0)
    
    Gui, %N%:Add, CheckBox, x295 y93 Disabled vCB1 gResetCountersCheckbox, Mouse Buttons
    Gui, %N%:Add, CheckBox, x295 yp+23 Disabled vCB2 gResetCountersCheckbox, Keyboard Keys
    Gui, %N%:Add, CheckBox, x295 yp+23 Disabled vCB3 gResetCountersCheckbox, Mouse Movement
    Gui, %N%:Add, CheckBox, x295 yp+23 Disabled vCB4 gResetCountersCheckbox, Word Data
    Gui, %N%:Add, CheckBox, x295 yp+23 Disabled vCB5 gResetCountersCheckbox, HD Activity
    
    Gui, %N%:Add, Button, x255 y350 w220 h49 gResetCountersReset, Reset
    
    CBDisabled := True
    
    Critical, Off
    
    Gui, %N%:Show,, Reset data counters
}

ResetCountersClose:
ResetCountersEscape:
    ResetCounters_GUI("Destroy")
Return

ResetCountersCheckAll:
    ResetCounters_GUI("Check All")
Return

ResetCountersSelectComputer:
    ResetCounters_GUI("ListView", A_GuiEvent, A_EventInfo)
Return

ResetCountersCheckbox:
    ResetCounters_GUI("CheckBox", A_GuiEvent, A_EventInfo, A_GuiControl)
Return

ResetCountersReset:
    ResetCounters_Gui("Reset")
Return
Settings_GUI(_Cmd = "", _AGuiControl = "", _SyncValue = "")
{
    ;All variables referenced here are static unless specifically defined as global or local.
    ;This is just a reminder for future modification.
    Static
    Static N := 9
    , IsShowing := False
    Global Name, Capture_Accuracy, MB_RamUse, Save_DataMethod, AutoSave_Interval, CountMouse
    , CountKeyboard, CountPixelsMoved, ScreenSizes, AutoSave_State, CountWPT, Save_SettingsMethod
    , Show_CountsInConvertedUnits, Show_TodaysCount, CountHDActivity, Show_AllComputers
    
    
    If (_Cmd = "Process")
    {
        If (!IsShowing)
            Return
        
        Gui, %N%:Submit, NoHide
        
        If (_AGuiControl = "MouseClicksScrolls")
            MenuHandler("Enable mouse counting")
        Else If (_AGuiControl = "KeyboardPresses")
            MenuHandler("Enable keyboard counting")
        Else If (_AGuiControl = "MouseMovement")
            MenuHandler("Count pixels mouse moved")
        Else If (_AGuiControl = "WordsTypedAndLengths")
            MenuHandler("Count words per ?")
        Else If (_AGuiControl = "BytesReadWrite")
            MenuHandler("Count bytes read/written")
        Else If (_AGuiControl = "Reset:")
            MenuHandler("Reset counters")
        Else If (_AGuiControl = "CaptureAccuracyMinutes")
            MenuHandler("Minutes")
        Else If (_AGuiControl = "CaptureAccuracySeconds")
            MenuHandler("Seconds")
        Else If (_AGuiControl = "CaptureAccuracyMilliseconds")
            MenuHandler("Milliseconds")
        Else If (_AGuiControl = "AutostartAtLogon")
            MenuHandler("Autostart at logon")
        Else If (_AGuiControl = "ShowConvertedUnits")
            MenuHandler("Show hover over counts in converted units")
        Else If (_AGuiControl = "ShowOnlyTodaysCounts")
            MenuHandler("Show todays counts in hover-over tray tip")
        Else If (_AGuiControl = "ShowAllComputersData")
            MenuHandler("Show all computers data in tray tip")
        Else If (_AGuiControl = "EnableAutosave")
            MenuHandler("Enable autosave")
        Else If (_AGuiControl = "Set interval")
            MenuHandler("Set autosave interval")
        Else If (_AGuiControl = "UseSaveOne")
            MenuHandler("Save method 1 (buffer key counts)")
        Else If (_AGuiControl = "UseSaveTwo")
            MenuHandler("Save method 2 (direct to disk)")
        Else If (_AGuiControl = "UseRegistrySave")
            MenuHandler("Use registry to store settings")
        Else If (_AGuiControl = "UseOptionsSave")
            MenuHandler("Use options file to store settings")
        Else If (_AGuiControl = "Verify stored data")
            MenuHandler("Verify stored data")
        Else If (_AGuiControl = "Set screen size(s)")
            MenuHandler("Set screen size")
        Else If (_AGuiControl = "Set maximum RAM use")
            MenuHandler("Set maximum RAM Use")
        Else If (_AGuiControl = "Check for update")
            MenuHandler("Check for update")
        Else If (_AGuiControl = "Remove/Un-install this program")
            MenuHandler("Remove this program and all of its files from this computer")
        Else If (_AGuiControl = "Show key/mouse counts for a specific date range")
            MenuHandler("Show key/mouse counts for a specific date range")
        Else If (_AGuiControl = "Show mouse movement for a specific date range")
            MenuHandler("Show mouse movement information for a specific date range")
        Else If (_AGuiControl = "Show word information for a specific date range")
            MenuHandler("Show word information for a specific date range")
        Else If (_AGuiControl = "About")
            MenuHandler("About")
        
        Return
    } Else If (_Cmd = "Sync")
    {
        If (!IsShowing)
            Return
        
        Gui, %N%:Submit, NoHide
        Gui, %N%:Default
        
        If (_AGuiControl = "Enable mouse counting")
        {
            If (MouseClicksScrolls != _SyncValue)
                GuiControl,, MouseClicksScrolls, % _SyncValue
        } Else If (_AGuiControl = "Enable keyboard counting")
        {
            If (KeyboardPresses != _SyncValue)
                GuiControl,, KeyboardPresses, % _SyncValue
        } Else If (_AGuiControl = "Count pixels mouse moved")
        {
            If (MouseMovement != _SyncValue)
                GuiControl,, MouseMovement, % _SyncValue
        } Else If (_AGuiControl = "Count words per ?")
        {
            If (WordsTypedAndLengths != _SyncValue)
                GuiControl,, WordsTypedAndLengths, % _SyncValue
        } Else If (_AGuiControl = "Count bytes read/written")
        {
            If (BytesReadWrite != _SyncValue)
                GuiControl,, BytesReadWrite, % _SyncValue
        } Else If (_AGuiControl = "Minutes")
        {
            If (CaptureAccuracyMinutes != 1)
                GuiControl,, CaptureAccuracyMinutes, 1
        } Else If (_AGuiControl = "Seconds")
        {
            If (CaptureAccuracySeconds != 2)
                GuiControl,, CaptureAccuracySeconds, 1
        } Else If (_AGuiControl = "Milliseconds")
        {
            If (CaptureAccuracyMilliseconds != 2)
                GuiControl,, CaptureAccuracyMilliseconds, 1
        } Else If (_AGuiControl = "Autostart at logon")
        {
            If (AutostartAtLogon != _SyncValue)
                GuiControl,, AutostartAtLogon, % _SyncValue
        } Else If (_AGuiControl = "Show hover over counts in converted units")
        {
            If (ShowConvertedUnits != _SyncValue)
                GuiControl,, ShowConvertedUnits, % _SyncValue
        } Else If (_AGuiControl = "Show todays counts in hover-over tray tip")
        {
            If (ShowOnlyTodaysCounts != _SyncValue)
                GuiControl,, ShowOnlyTodaysCounts, % _SyncValue
        } Else If (_AGuiControl = "Show all computers data in tray tip")
        {
            If (ShowAllComputersData != _SyncValue)
                GuiControl,, ShowAllComputersData, % _SyncValue
        } Else If (_AGuiControl = "Enable autosave")
        {
            If (EnableAutosave != _SyncValue)
                GuiControl,, EnableAutosave, % _SyncValue
        } Else If (_AGuiControl = "Save method 1 (buffer key counts)")
        {
            If (UseSaveOne != 1)
                GuiControl,, UseSaveOne, 1
        } Else If (_AGuiControl = "Save method 2 (direct to disk)")
        {
            If (UseSaveTwo != 1)
                GuiControl,, UseSaveTwo, 1
        } Else If (_AGuiControl = "Use registry to store settings")
        {
            If (UseRegistrySave != 1)
                GuiControl,, UseRegistrySave, 1
        } Else If (_AGuiControl = "Use options file to store settings")
        {
            If (UseOptionsSave != 1)
                GuiControl,, UseOptionsSave, 1
        }
        
        Return
    } Else If (_Cmd = "Is Showing")
    {
        Return IsShowing
    } Else If (_Cmd = "Destroy")
    {
        Gui, %N%:Destroy
        IsShowing := False
        ;Exitapp ;*****************************************************************************************************************************
        
        Return
    }
    
    
    If (IsShowing)
        Return
    
    Critical, On
    IsShowing := True
    
    Gui, %N%:Default
    Gui, %N%:Font, S10
    Gui, %N%:+LabelScriptGUI
    
    ;Tab control
    Gui, %N%:Add, Tab2, vTABCONTROL w560 h315, Main|Advanced|Reports
    GuiControlGet, P, Pos, TABCONTROL
    Gui, %N%:Tab
    Gui, %N%:Add, Button, xp+512 yp-3 h21 gScriptGUIProcess, About
    
    ;Main tab
    
    ;Enable/disable counters
    Gui, %N%:Tab, 1
    PX += 14, PY += 32
    Gui, %N%:Add, GroupBox, vScriptCounters_GroupBox x%PX% y%PY% w250 h140, Script counters
    Gui, %N%:Add, CheckBox, yp+22 xp+10 gScriptGUIProcess vMouseClicksScrolls, Count mouse clicks and scrolls
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vKeyboardPresses, Count keyboard presses
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vMouseMovement, Count mouse movement
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vWordsTypedAndLengths, Count words typed and word lengths
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vBytesReadWrite, Count bytes read and written
    
    ;Reset counters
    GuiControlGet, P, Pos, ScriptCounters_GroupBox
    NX := PX + PW + 11
    NY := PY
    Gui, %N%:Add, GroupBox, vResetCounters_GroupBox x%NX% y%NY% w270 h140, Reset counter(s)
    
    NX += 10, NY += 20
    Gui, %N%:Add, Button, x%NX% y%NY% H21 gScriptGUIProcess, Reset:
    Gui, %N%:Add, Text, yp+3 xp+55, General reset counters
    
    
    ;Capture accuracy
    GuiControlGet, P, Pos, ScriptCounters_GroupBox
    PY += PH + 14
    Gui, %N%:Add, GroupBox, vCaptureAccuracy_GroupBox x%PX% y%PY% w250 h115, Counter capture accuracy
    Gui, %N%:Add, Radio, xp+10 yp+22 gScriptGUIProcess vCaptureAccuracyMinutes, Set to Minutes
    Gui, %N%:Add, Radio, gScriptGUIProcess vCaptureAccuracySeconds, Set to Seconds
    Gui, %N%:Add, Radio, gScriptGUIProcess vCaptureAccuracyMilliseconds, Set to Milliseconds
    
    ;Other main settings
    GuiControlGet, P, Pos, CaptureAccuracy_GroupBox
    PX += PW + 11
    Gui, %N%:Add, GroupBox, vMainOther_GroupBox x%PX% y%PY% w270 h115, Other settings
    Gui, %N%:Add, CheckBox, xp+10 yp+22 gScriptGUIProcess vAutostartAtLogon, Autostart at logon
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vShowConvertedUnits, Show tray tip counts in converted units
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vShowOnlyTodaysCounts, Show only todays counts in tray tip
    Gui, %N%:Add, CheckBox, gScriptGUIProcess vShowAllComputersData, Show all computers data in tray tip
    
    
    ;Advanced tab
    Gui, %N%:Tab, 2
    
    ;Save settings
    GuiControlGet, P, Pos, TABCONTROL
    PX += 14, PY += 32
    Gui, %N%:Add, GroupBox, vAdvancedAutoSave_GroupBox x%PX% y%PY% w250 h140, Save settings
    PX += 10, PY += 22
    Gui, %N%:Add, CheckBox, x%PX% y%PY% gScriptGUIProcess vEnableAutosave, Enable autosave
    Gui, %N%:Add, Button, xp+125 yp-2 h21 w95 gScriptGUIProcess, Set interval
    Gui, %N%:Add, Radio, xp-125 yp+25 gScriptGUIProcess vUseSaveOne, Use save method 1 (buffer data)
    Gui, %N%:Add, Radio, gScriptGUIProcess vUseSaveTwo, Use save method 2 (direct to disk)
    Gui, %N%:Add, Radio, Group gScriptGUIProcess vUseRegistrySave, Use registry to store settings
    Gui, %N%:Add, Radio, gScriptGUIProcess vUseOptionsSave, Use options file to store settings
    
    ;Import/export
    ;GuiControlGet, P, Pos, AdvancedAutoSave_GroupBox
    ;PX += PW + 11
    ;Gui, %N%:Add, GroupBox, vAdvancedImportExport_GroupBox x%PX% y%PY% w270 h120, Import and Export history
    /*
    PX += 10, PY += 20
    Gui, %N%:Add, Button, x%PX% y%PY% H21 w55, Export:
    Gui, %N%:Add, Text, yp+3 xp+56, To package
    
    PY += 23
    Gui, %N%:Add, Button, x%PX% y%PY% H21 w55, Import:
    Gui, %N%:Add, Text, yp+3 xp+56, From package (replace)
    
    PY += 23
    Gui, %N%:Add, Button, x%PX% y%PY% H21 w55, Import:
    Gui, %N%:Add, Text, yp+3 xp+56, From package (merge)
    
    PY += 23
    Gui, %N%:Add, Button, x%PX% y%PY% H21 w55, Import:
    Gui, %N%:Add, Text, yp+3 xp+56, From package (merge-replace)
    */
    
    ;Other settings/options
    ;GuiControlGet, P, Pos, AdvancedImportExport_GroupBox
    ;PY += PH + 14
    
    GuiControlGet, P, Pos, AdvancedAutoSave_GroupBox
    PX += PW + 11
    Gui, %N%:Add, GroupBox, vAdvancedOtherSettingsOptions_GroupBox x%PX% y%PY% w270 h130, Other settings and options
    PX += 10, PY += 20
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w250 gScriptGUIProcess, Verify stored data
    
    PY += 25
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w250 gScriptGUIProcess, Set screen size(s)
    
    PY += 25
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w250 gScriptGUIProcess, Set maximum RAM use
    
    PY += 25
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w250 gScriptGUIProcess, Check for update
    
    ;Remove program
    GuiControlGet, P ,Pos, AdvancedAutoSave_GroupBox
    PY += PH + 14
    Gui, %N%:Add, GroupBox, vAdvancedRemoveProgram_GroupBox x%PX% y%PY% w250 h55, Remove program
    PX += 10, PY += 20
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w230 gScriptGUIProcess, Remove/Un-install this program
    
    
    ;Reports tab
    Gui, %N%:Tab, 3
    
    ;Range reports
    GuiControlGet, P, Pos, TABCONTROL
    PX += 14, PY += 32
    Gui, %N%:Add, GroupBox, vReportsDateRangeReports_GroupBox x%PX% y%PY% w325 h105, Show detailed information
    PX += 10, PY += 20
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w305 gScriptGUIProcess, Show key/mouse counts for a specific date range
    
    PY += 25
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w305 gScriptGUIProcess, Show mouse movement for a specific date range
    
    PY += 25
    Gui, %N%:Add, Button, x%PX% y%PY% h22 w305 gScriptGUIProcess, Show word information for a specific date range
    
    
    ;Sets all the GUI values to the live script values
    GuiControl,, MouseClicksScrolls, % CountMouse
    GuiControl,, KeyboardPresses, % CountKeyboard
    GuiControl,, MouseMovement, % CountPixelsMoved
    GuiControl,, WordsTypedAndLengths, % CountWPT
    GuiControl,, BytesReadWrite, % CountHDActivity
    If (Capture_Accuracy = 1)
        GuiControl,, CaptureAccuracyMinutes, 1
    Else If (Capture_Accuracy = 2)
        GuiControl,, CaptureAccuracySeconds, 1
    Else If (Capture_Accuracy = 3)
        GuiControl,, CaptureAccuracyMilliseconds, 1
    If (AutoStart("Check"))
        GuiControl,, AutostartAtLogon, 1
    GuiControl,, ShowConvertedUnits, % Show_CountsInConvertedUnits
    GuiControl,, ShowOnlyTodaysCounts, % Show_TodaysCount
    GuiControl,, ShowAllComputersData, % Show_AllComputers
    GuiControl,, EnableAutosave, % AutoSave_State
    If (Save_DataMethod = 1)
        GuiControl,, UseSaveOne, 1
    Else If (Save_DataMethod = 2)
        GuiControl,, UseSaveTwo, 1
    If (Save_SettingsMethod = 1)
        GuiControl,, UseRegistrySave, 1
    Else If (Save_SettingsMethod = 2)
        GuiControl,, UseOptionsSave, 1
    
    
    Critical, Off
    
    Gui, %N%:Show, h335, % Name
    
    Return
    
    
    ScriptGUIClose:
    ScriptGUIEscape:
        Settings_GUI("Destroy")
    Return
    
    ScriptGUIProcess:
        Settings_GUI("Process", A_GuiControl)
    Return
}

;**********************************
; End Misc includes
;**********************************


;**********************************
; File i/o functions
;**********************************

;Your script must have the following set before these functions will operate
Ptr := A_PtrSize ? "Ptr" : "UInt"

ELP_FileSetTimes(_ModifedTime, _CreationTime, _AccessTime, _FilePattern, _OperateOnFolders = 0, _Recurse = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFSTS"
    
    If (_ModifedTime = "")
        _ModifedTime := A_Now
    Else If (_ModifedTime != 0 And StrLen(_ModifedTime) < 14)
        FormatTime, _ModifedTime, _ModifedTime, yyyyMMddHHmmss
    
    If (_CreationTime = "")
        _CreationTime := A_Now
    Else If (_CreationTime != 0 And StrLen(_CreationTime) < 14)
        FormatTime, _CreationTime, _CreationTime, yyyyMMddHHmmss
    
    If (_AccessTime = "")
        _AccessTime := A_Now
    Else If (_AccessTime != 0 And StrLen(_AccessTime) < 14)
        FormatTime, _AccessTime, _AccessTime, yyyyMMddHHmmss
    
    _AccessTime := _AccessTime = 0 ? 0 : ELP_LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_AccessTime))
    , VarSetCapacity(AccessTime, 8, 0)
    , NumPut(_AccessTime, AccessTime, 0, "Int64")
    , _CreationTime := _CreationTime = 0 ? 0 : ELP_LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_CreationTime))
    , VarSetCapacity(CreationTime, 8, 0)
    , NumPut(_CreationTime, CreationTime, 0, "Int64")
    , _ModifedTime := _ModifedTime = 0 ? 0 : ELP_LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_ModifedTime))
    , VarSetCapacity(ModifiedTime, 8, 0)
    , NumPut(_ModifedTime, ModifiedTime, 0, "Int64")
    , FailedFiles := 0
    , SuccessfulFiles := 0
    
    If (_IsPattern){
        If (!InStr(_FilePattern, "*", False, InStr(_FilePattern, "\", False, 0)))
            _IsPattern := False
    }
    
    If (_FilePattern = "" Or (!_IsPattern And !ELP_FileExists(_FilePattern))){
        ErrorLevel := 1
        Return 1
    }
    
    If (_IsPattern){
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FilePattern, "Close", 0, FileInfo, MY_ID)
        
        Loop
        {
            FileName := ELP_LoopFilePattern(_FilePattern, _OperateOnFolders, _Recurse, FileInfo, MY_ID)
            
            If (FileName = "")
                Break
            
            H := ELP_OpenFileHandle(FileName, "Write")
            , E := DllCall("SetFileTime", Ptr, H, Ptr, &CreationTime, Ptr, &AccessTime, Ptr, &ModifiedTime)
            , ELP_CloseFileHandle(H)
            
            If (!E)
                FailedFiles ++
            Else
                SuccessfulFiles ++
        }
    } Else {
        H := ELP_OpenFileHandle(_FilePattern, "Write")
        , E := DllCall("SetFileTime", Ptr, H, Ptr, &CreationTime, Ptr, &AccessTime, Ptr, &ModifiedTime)
        , ELP_CloseFileHandle(H)
        
        If (!E)
            FailedFiles ++
        Else
            SuccessfulFiles ++
    }
    
    ErrorLevel := FailedFiles
    
    Return SuccessfulFiles
}

ELP_FileSetTime(_TimeStamp, _FilePattern, _WhichTime = "M", _OperateOnFolders = 0, _Recurse = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFST"
    
    If (_TimeStamp = "")
        _TimeStamp := A_Now
    Else If (StrLen(_TimeStamp) < 14)
        FormatTime, _TimeStamp, _TimeStamp, yyyyMMddHHmmss
    
    _TimeStamp := ELP_LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_TimeStamp))
    , VarSetCapacity(TimeStamp, 8, 0)
    , NumPut(_TimeStamp, TimeStamp, 0, "Int64")
    , FailedFiles := 0
    , SuccessfulFiles := 0
    
    If (_IsPattern){
        If (!InStr(_FilePattern, "*", False, InStr(_FilePattern, "\", False, 0)))
            _IsPattern := False
    }
    
    If (_FilePattern = "" Or (!_IsPattern And !ELP_FileExists(_FilePattern))){
        ErrorLevel := 1
        Return 1
    }
    
    If (_IsPattern){
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FilePattern, "Close", 0, FileInfo, MY_ID)
        
        Loop
        {
            FileName := ELP_LoopFilePattern(_FilePattern, _OperateOnFolders, _Recurse, FileInfo, MY_ID)
            
            If (FileName = "")
                Break
            
            H := ELP_OpenFileHandle(FileName, "Write")
            
            If (_WhichTime = "M" Or _WhichTime = "")
                E := DllCall("SetFileTime", Ptr, H, "UInt", 0, "UInt", 0, Ptr, &TimeStamp)
            Else If (_WhichTime = "A")
                E := DllCall("SetFileTime", Ptr, H, "UInt", 0, Ptr, &TimeStamp, "UInt", 0)
            Else If (_WhichTime = "C")
                E := DllCall("SetFileTime", Ptr, H, Ptr, &TimeStamp, "UInt", 0, "UInt", 0)
            
            ELP_CloseFileHandle(H)
            
            If (!E)
                FailedFiles ++
            Else
                SuccessfulFiles ++
        }
    } Else {
        H := ELP_OpenFileHandle(_FilePattern, "Write")
        
        If (_WhichTime = "M" Or _WhichTime = "")
            E := DllCall("SetFileTime", Ptr, H, "UInt", 0, "UInt", 0, Ptr, &TimeStamp)
        Else If (_WhichTime = "A")
            E := DllCall("SetFileTime", Ptr, H, "UInt", 0, Ptr, &TimeStamp, "UInt", 0)
        Else If (_WhichTime = "C")
            E := DllCall("SetFileTime", Ptr, H, Ptr, &TimeStamp, "UInt", 0, "UInt", 0)
        
        ELP_CloseFileHandle(H)
        
        If (!E)
            FailedFiles ++
        Else
            SuccessfulFiles ++
    }
    
    ErrorLevel := FailedFiles
    
    Return SuccessfulFiles
}

ELP_SystemTimeToFileTime(_SystemTime)
{
    Global Ptr
    
    VarSetCapacity(FSystemTime, 16, 0) ;8*2
    , VarSetCapacity(FFileTime, 8, 0) ;2*4
    
    , Miliseconds := SubStr(_SystemTime, 15, 3)
    , Miliseconds := Miliseconds = "" ? 0 : Miliseconds
    
    , NumPut(SubStr(_SystemTime, 1, 4), FSystemTime, 0, "UShort")
    , NumPut(SubStr(_SystemTime, 5, 2), FSystemTime, 2, "UShort")
    ;NumPut(DayOfWeek, FSystemTime, 0, "UShort")
    , NumPut(SubStr(_SystemTime, 7, 2), FSystemTime, 6, "UShort")
    , NumPut(SubStr(_SystemTime, 9, 2), FSystemTime, 8, "UShort")
    , NumPut(SubStr(_SystemTime, 11, 2), FSystemTime, 10, "UShort")
    , NumPut(SubStr(_SystemTime, 13, 2), FSystemTime, 12, "UShort")
    , NumPut(Miliseconds, FSystemTime, 14, "UShort")
    
    , DllCall("SystemTimeToFileTime", Ptr, &FSystemTime, Ptr, &FFileTime)
    
    Return NumGet(FFileTime, 0, "Int64")
}

ELP_LocalFileTimeToFileTime(_FileTime)
{
    Global Ptr
    
    VarSetCapacity(FileTime, 64, 0)
    , VarSetCapacity(FileTimeUTC, 64, 0)
    , NumPut(_FileTime, FileTime, 0, "Int64")
    , DllCall("LocalFileTimeToFileTime", Ptr, &FileTime, Ptr, &FileTimeUTC)
    
    Return NumGet(FileTimeUTC, 0, "Int64")
}

ELP_FileRead(_FileName, ByRef _Data = "010011100010111101000001")
{
    Global Ptr
    Static UTF8_BOM1 = 239, UTF8_BOM2 = 187, UTF8_BOM3 = 191
    , UTF16LE_BOM1 = 255, UTF16LE_BOM2 = 254
    , UTF8_CP = 65001, UTF16_CP = 1200
    , SLong_MAX = 2147483647
    
    W_CP := A_FileEncoding
    
    Loop
    {
        If (SubStr(_FileName, 1, 1) = "*"){
            Option := SubStr(_FileName, 1, InStr(_FileName, A_Space))
            , _FileName := SubStr(_FileName, StrLen(Option) + 1)
            
            If (InStr(Option, ":") Or InStr(Option, "\") Or InStr(Option, ".") Or _FileName = ""){
                ErrorLevel := -1
                Return
            }
            
            If (SubStr(Option, 1, 2) = "*m"){
                Bytes_ToRead := SubStr(Option, 3)
                , Bytes_ToRead *= 1024 * 1024
            } Else If (SubStr(Option, 1, 2) = "*t")
                Replace_Newlines := 1
            Else If (SubStr(Option, 1, 2) = "*P")
                W_CP := SubStr(Option, 3)
            Else If (SubStr(Option, 1, 2) = "*c"){
                ErrorLevel := 1
                Return
            } Else If (SubStr(Option, 1, 2) = "**")
                Binary_Mode := True
        } Else
            Break
    }
    
    If (W_CP = "" Or W_CP = 0)
        W_CP := DllCall("GetACP")
    Else {
        If W_CP Is Not Number
            W_CP := DllCall("GetACP")
    }
    
    If (!ELP_FileExists(_FileName, 0, 0, 0)){
        ErrorLevel := 1
        Return
    }
    
    If (_Data = "010011100010111101000001"){
        ReturnByRef := True
        
        If (Binary_Mode){
            ErrorLevel := 1
            Return
        }
    }
    
    Handle := ELP_OpenFileHandle(_FileName, "Read", FileSize)
    If (Handle = -1){
        ErrorLevel := 2
        Return
    }
    
    Bytes_ToRead := Bytes_ToRead = "" ? FileSize : Bytes_ToRead
    
    If (!FileSize){
        ErrorLevel := 0
        ELP_CloseFileHandle(Handle)
        Return
    }
    
    If (A_PtrSize != 8 And Bytes_ToRead > SLong_MAX){
        ErrorLevel := 1
        Return
    }
    
    If (Binary_Mode){
        VarSetCapacity(_Data, Bytes_ToRead, 0)
        , Bytes_Read := ELP_ReadData(Handle, &_Data, Bytes_ToRead)
        
        Return Bytes_Read
    } Else {
        VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
        , Bytes_Read := ELP_ReadData(Handle, &Data_Buffer, Bytes_ToRead)
        , ELP_CloseFileHandle(Handle)
    }
    
    If (Bytes_Read >= 3 And NumGet(&Data_Buffer, 0, "UChar") = UTF8_BOM1 And NumGet(&Data_Buffer, 1, "UChar") = UTF8_BOM2 And NumGet(&Data_Buffer, 2, "UChar") = UTF8_BOM3){
        Data_Start := &Data_Buffer + 3
        , Data_Length := Bytes_Read - 3
        
        If (A_IsUnicode){
            ;Convert UTF8 to UTF16 to string
            Data_Length := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0)
            , VarSetCapacity(_Data, Data_Length * 2, 0)
            , DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length * 2)
            
            , VarSetCapacity(_Data, -1)
            , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
            , VarSetCapacity(Data_Buffer, 0)
        } Else {
            ;Convert UTF8 to ANSI to string
            Data_Length := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0)
            , VarSetCapacity(_Data, Data_Length * 2, 0)
            , DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length * 2)
            
            , Temp_Data_Length := Data_Length
            , Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Temp_Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
            , VarSetCapacity(Data_Buffer, Data_Length, 0)
            , DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Temp_Data_Length, Ptr, &Data_Buffer, "Int", Data_Length, Ptr, 0, Ptr, 0)
            
            , VarSetCapacity(_Data, 0)
            , VarSetCapacity(_Data, Data_Length, 0)
            
            , DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Data_Length)
            , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
            , VarSetCapacity(Data_Buffer, 0)
            , VarSetCapacity(_Data, -1)
        }
    } Else If ((Has_BOM := (Bytes_Read >= 2 And NumGet(&Data_Buffer, 0, "UChar") = UTF16LE_BOM1 And NumGet(&Data_Buffer, 1, "UChar") = UTF16LE_BOM2)) Or W_CP = UTF16_CP){
        Data_Start := &Data_Buffer
        , Data_Length := Bytes_Read
        
        If (Has_BOM)
            Data_Start += 2, Data_Length -= 2
        
        If (A_IsUnicode){
            ;Moves the UTF16 buffer data into a string
            VarSetCapacity(_Data, Data_Length, 0)
            , DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, Data_Start, "UInt", Data_Length)
            
            , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
            , VarSetCapacity(Data_Buffer, 0)
            , VarSetCapacity(_Data, -1)
        } Else {
            ;Convert UTF16 to ANSI to string
            Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
            , VarSetCapacity(_Data, Data_Length, 0)
            , DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length, Ptr, 0, Ptr, 0)
            
            , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
            , VarSetCapacity(Data_Buffer, 0)
            , VarSetCapacity(_Data, -1)
        }
    } Else {
        If (A_IsUnicode){
            ;Convert from other codepage to UTF16 to string
            Data_Length := DllCall("MultiByteToWideChar", "UInt", W_CP,"UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, 0, "Int", 0)
            , VarSetCapacity(_Data, Data_Length * 2, 0)
            , DllCall("MultiByteToWideChar", "UInt", W_CP, "UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, &_Data, "Int", Data_Length * 2)
            
            , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
            , VarSetCapacity(Data_Buffer, 0)
            , VarSetCapacity(_Data, -1)
        } Else {
            ;Moves the ANSI data into the string
            If (W_CP = DllCall("GetACP")){
                VarSetCapacity(_Data, Bytes_Read, 0)
                , DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Bytes_Read)
                
                , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
                , VarSetCapacity(Data_Buffer, 0)
                , VarSetCapacity(_Data, -1)
            } Else {
                ;Convert from other codepage to UTF16 to ANSI to string
                Data_Length := DllCall("MultiByteToWideChar", "UInt", W_CP,"UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, 0, "Int", 0)
                , VarSetCapacity(_Data, Data_Length * 2, 0)
                , DllCall("MultiByteToWideChar", "UInt", W_CP, "UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, &_Data, "Int", Data_Length)
                , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
                , VarSetCapacity(Data_Buffer, 0)
                
                , W_CP := DllCAll("GetACP")
                
                , Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
                , VarSetCapacity(Data_Buffer, Data_Length, 0)
                , DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Data_Length, Ptr, &Data_Buffer, "Int", Data_Length, Ptr, 0, Ptr, 0)
                , VarSetCapacity(_Data, 0)
                , VarSetCapacity(_Data, Data_Length, 0)
                , DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Data_Length)
                , VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
                , VarSetCapacity(Data_Buffer, 0)
                , VarSetCapacity(_Data, -1)
            }
        }
    }
    
    If (Replace_Newlines)
        StringReplace, _Data, _Data, `r`n, `n, A
    
    If (ReturnByRef)
        Return _Data
}

ELP_FileMoveDirectory(_FromDirectory, _ToDirectory, _Flags = 0)
{
    ;_Flags
    ;R | Rename
    ;0 | Fail if exists
    ;1 | Overwrite
    ;2 | Overwrite
    ;3 | Overwrite and always remove source files
    
    Global Ptr
    Static MY_ID := "ELPCF", ERROR_ALREADY_EXISTS := 183, Am_Root
    
    If (SubStr(_FromDirectory, 0, 1) != "\")
        _FromDirectory .= "\"
    
    If (SubStr(_ToDirectory, 0, 1) != "\")
        _ToDirectory .= "\"
    
    Failed_Moves := 0
    
    If (_Flags = "R"){
        ELP_ConvertPath(_FromDirectory)
        , ELP_ConvertPath(_ToDirectory)
        , Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
    } Else If (_Flags = 1 Or _Flags = 2){
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FromDirectory . "*.*", "Close", 0, FileInfo, MY_ID)
        , Failed_Moves += ELP_FileMove(_FromDirectory . "*.*", _ToDirectory . "*.*", 1, 1)
        , Source_Length := StrLen(_FromDirectory) + 1
        
        Loop
        {
            FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 2, 0, FileInfo, MY_ID)
            
            If (FromFile = "")
                Break
            
            Temp_ToDirectory := _ToDirectory . SubStr(FromFile, Source_Length)
            , Failed_Moves += ELP_FileMoveDirectory(FromFile, Temp_ToDirectory, _Flags)
        }
        
        Failed_Moves += ELP_FileRemoveDirectory(_FromDirectory)
    } Else If (_Flags = 0 Or _Flags = 3){
        If (ELP_FileExists(_ToDirectory, 1, 0, 0))
            Failed_Moves := 1
        Else {
            From_Device := ELP_GetPathRoot(_FromDirectory)
            , To_Device := ELP_GetPathRoot(_ToDirectory)
            
            If (From_Device = To_Device){
                ELP_ConvertPath(_FromDirectory)
                , ELP_ConvertPath(_ToDirectory)
                , Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
            } Else {
                Failed_Moves := ELP_FileCopyDirectory(_FromDirectory, _ToDirectory)
                
                If (!Failed_Moves Or _Flags = 3)
                    ELP_FileRemoveDirectory(_FromDirectory, 1)
            }
        }
    }
    
    Return ErrorLevel := Failed_Moves
}

ELP_FileMove(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFM", ERROR_ALREADY_EXISTS := 183
    
    If (_IsPattern){
        If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile), "D"))
            Return ErrorLevel := 1
        
        P := InStr(_FromFile, "\", False, 0)
        
        If (InStr(_FromFile, "*", False, P))
            Source_IsPattern := True
        Else
            Source_IsPattern := False
        
        P := InStr(_ToFile, "\", False, 0)
        
        If (InStr(_ToFile, "*", False, P))
            Destination_IsPattern := True
        Else
            Destination_IsPattern := False
        
        If (!Destination_IsPattern){
            If (SubStr(_ToFile, 0, 1) = "\")
                Destination_IsPattern := True
            Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
                _ToFile .= "\", Destination_IsPattern := True
            
            If (!Source_IsPattern And Destination_IsPattern){
                _ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
                , Destination_IsPattern := False
            }
        }
        
        If (!Source_IsPattern And !Destination_IsPattern)
            _IsPattern := False
    }
    
    Failed_Moves := 0
    
    If (_CreateDestination){
        Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
        
        If (!ELP_FileExists(Directory, 1, 0, 0))
            ELP_FileCreateDirectory(Directory)
    }
    
    From_Device := ELP_GetPathRoot(_FromFile)
    , To_Device := ELP_GetPathRoot(_ToFile)
    
    If (From_Device != To_Device)
        Method_Copy := True
    
    If (!_IsPattern){
        If (Method_Copy){
            Failed_Moves := ELP_FileCopy(_FromFile, _ToFile, _OverWrite, 0, 0)
            
            If (!Failed_Moves)
                ELP_FileDelete(_FromFile, 1, 0)
        } Else {
            __FromFile := _FromFile
            , __ToFile := _ToFile
            , ELP_ConvertPath(__FromFile)
            , ELP_ConvertPath(__ToFile)
            , Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
            
            If (Failed_Moves And _OverWrite And A_LastError = ERROR_ALREADY_EXISTS){
                If (!ELP_FileDelete(_ToFile, 1, 0))
                    Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
            }
        }
    } Else {
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
        
        Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
        If (Destination_Pattern != ""){
            _ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
            
            StringSplit,FN_,Destination_Pattern,.
            
            Dest_Name := FN_1
            , Dest_Extension := FN_2
        }
        
        Loop
        {
            MoveFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
            
            If (MoveFromFile = "")
                Break
            
            ;Populate the Copy-To variable with the Copy-From file name
            Source_Name := SubStr(MoveFromFile, InStr(MoveFromFile, "\", False, 0) + 1)
            
            If (Destination_Pattern){
                MoveTo_Name := Dest_Name
                , MoveTo_Extension := Dest_Extension
                , P := InStr(Source_Name, ".", False, 0)
                
                If (P){
                    SFN_1 := SubStr(Source_Name, 1, P - 1)
                    , SFN_2 := SubStr(Source_Name, P + 1)
                } Else {
                    SFN_1 := Source_Name
                    , SFN_2 := ""
                }
                
                If (InStr(MoveTo_Name,"*")){
                    StringReplace, MoveTo_Name, MoveTo_Name, *, %SFN_1%
                    StringReplace, MoveTo_Name, MoveTo_Name, *,, A
                }
                
                If (InStr(MoveTo_Extension,"*")){
                    StringReplace, MoveTo_Extension, MoveTo_Extension, *, %SFN_2%
                    StringReplace, MoveTo_Extension, MoveTo_Extension, *,, A
                }
                
                If (MoveTo_Extension)
                    MoveToFile := _ToFile . MoveTo_Name . "." . MoveTo_Extension
                Else
                    MoveToFile := _ToFile . MoveTo_Name
            } Else
                MoveToFile := _ToFile . Source_Name
            
            If (Method_Copy){
                E := ELP_FileCopy(MoveFromFile, MoveToFile, _OverWrite, 0, 0)
            
                If (!E)
                    ELP_FileDelete(MoveFromFile, 1, 0)
                Else
                    Failed_Moves ++
            } Else {
                ELP_ConvertPath(MoveFromFile)
                , ELP_ConvertPath(MoveToFile)
                , E := DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
                
                If (E){
                    If (_OverWrite And A_LastError = ERROR_ALREADY_EXISTS And !ELP_FileDelete(_ToFile, 1, 0))
                        Failed_Moves += DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
                    Else
                        Failed_Moves ++
                }
            }
        }
    }
    
    Return Failed_Moves
}

ELP_FileCopyDirectory(_FromDirectory, _ToDirectory, _Overwrite = 0)
{
    Global Ptr
    Static MY_ID := "ELPFCD"
    
    If (SubStr(_FromDirectory, 0, 1) != "\")
        _FromDirectory .= "\"
    
    If (SubStr(_ToDirectory, 0, 1) != "\")
        _ToDirectory .= "\"
    
    If (_FromDirectory = _ToDirectory)
        Return ErrorLevel := 1
    
    If (SubStr(_ToDirectory, 1, StrLen(_FromDirectory)) = _FromDirectory)
        Method := 2
    Else
        Method := 1
    
    Destination_Exists := ELP_FileExists(_ToDirectory, 1, 0, 0)
    
    If (Destination_Exists And !_Overwrite)
        Return ErrorLevel := 1
    
    Errored_Directories := 0
    , Errored_Files := 0
    
    , From_BaseLength := StrLen(_FromDirectory)
    , To_BaseLength := StrLen(_ToDirectory)
    
    If (Method = 1){
        Loop
        {
            FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
            
            If (FromFile = "")
                Break
            
            CopyFile := SubStr(FromFile, From_BaseLength + 1)
            
            If (ELP_IsDirectoryFromFI(FileInfo)){
                If (ELP_FileCreateDirectory(_ToDirectory . CopyFile))
                    Errored_Directories ++
            } Else {
                If (ELP_FileCopy(_FromDirectory . CopyFile, _ToDirectory . CopyFile, _Overwrite, 0, 0))
                    Errored_Files ++
            }
        }
    } Else If (Method = 2){
        Loop
        {
            FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
            
            If (FromFile = "")
                Break
            
            If (SubStr(FromFile,1,To_BaseLength) = _ToDirectory)
                Continue
            
            FromFile := SubStr(FromFile, From_BaseLength + 1)
            
            If (ELP_IsDirectoryFromFI(FileInfo))
                DirectoryContents .= DirectoryContents ? "|" . FromFile . "\" : FromFile . "\"
            Else
                DirectoryContents .= DirectoryContents ? "|" . FromFile : FromFile
        }
        
        If (!Destination_Exists And ELP_FileCreateDirectory(_ToDirectory))
            Return ErrorLevel := 1
        
        Loop,Parse,DirectoryContents,|
        {
            If (SubStr(A_LoopField, 0, 1) = "\"){
                If (ELP_FileCreateDirectory(_ToDirectory . A_LoopField))
                    Errored_Directories ++
            } Else {
                If (ELP_FileCopy(_FromDirectory . A_LoopField, _ToDirectory . A_LoopField, _Overwrite, 0, 0))
                    Errored_Files ++
            }
        }
        
        VarSetCapacity(DirectoryContents, 0)
    }
    
    If (Errored_Directories Or Errored_Files)
        Return Errored_Directories . "|" . Errored_Files
}

ELP_FileCopy(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFC"
    
    If (_IsPattern){
        If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile), "D"))
            Return ErrorLevel := 1
        
        P := InStr(_FromFile, "\", False, 0)
        
        If (InStr(_FromFile, "*", False, P))
            Source_IsPattern := True
        Else
            Source_IsPattern := False
        
        P := InStr(_ToFile, "\", False, 0)
        
        If (InStr(_ToFile, "*", False, P))
            Destination_IsPattern := True
        Else
            Destination_IsPattern := False
        
        If (!Destination_IsPattern){
            If (SubStr(_ToFile, 0, 1) = "\")
                Destination_IsPattern := True
            Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
                _ToFile .= "\", Destination_IsPattern := True
            
            If (!Source_IsPattern And Destination_IsPattern){
                _ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
                , Destination_IsPattern := False
            }
        }
        
        If (!Source_IsPattern And !Destination_IsPattern)
            _IsPattern := False
    }
    
    Failed_Copies := 0
    
    If (_CreateDestination){
        Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
        
        If (!ELP_FileExists(Directory, 1, 0, 0))
            ELP_FileCreateDirectory(Directory)
    }
    
    If (!_IsPattern){
        __FromFile := _FromFile
        , __ToFile := _ToFile
        , ELP_ConvertPath(__FromFile)
        , ELP_ConvertPath(__ToFile)
        , Failed_Copies := DllCall("CopyFileW", Ptr, &__FromFile, Ptr, &__ToFile, "Int", !_OverWrite) = 0 ? 1 : 0
    } Else {
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
        
        Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
        If (Destination_Pattern != ""){
            _ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
            
            StringSplit, FN_, Destination_Pattern, .
            
            Dest_Name := FN_1
            , Dest_Extension := FN_2
        }
        
        Loop
        {
            CopyFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
            
            If (CopyFromFile = "")
                Break
            
            ;Populate the Copy-To variable with the Copy-From file name
            Source_Name := SubStr(CopyFromFile, InStr(CopyFromFile, "\", False, 0) + 1)
            
            If (Destination_Pattern){
                CopyTo_Name := Dest_Name
                , CopyTo_Extension := Dest_Extension
                , P := InStr(Source_Name, ".", False, 0)
                
                If (P){
                    SFN_1 := SubStr(Source_Name, 1, P - 1)
                    , SFN_2 := SubStr(Source_Name, P + 1)
                } Else {
                    SFN_1 := Source_Name
                    , SFN_2 := ""
                }
                
                If (InStr(CopyTo_Name,"*")){
                    StringReplace, CopyTo_Name, CopyTo_Name, *, %SFN_1%
                    StringReplace, CopyTo_Name, CopyTo_Name, *,, A
                }
                
                If (InStr(CopyTo_Extension,"*")){
                    StringReplace, CopyTo_Extension, CopyTo_Extension, *, %SFN_2%
                    StringReplace, CopyTo_Extension, CopyTo_Extension, *,, A
                }
                
                If (CopyTo_Extension)
                    CopyToFile := _ToFile . CopyTo_Name . "." . CopyTo_Extension
                Else
                    CopyToFile := _ToFile . CopyTo_Name
            } Else
                CopyToFile := _ToFile . Source_Name
            
            ELP_ConvertPath(CopyFromFile)
            , ELP_ConvertPath(CopyToFile)
            , Failed_Copies += DllCall("CopyFileW", Ptr, &CopyFromFile, Ptr, &CopyToFile, "Int", !_OverWrite) = 0 ? 1 : 0
        }
    }
    
    Return Failed_Copies
}

ELP_FileGetVersion(_FileName, _Which = 1)
{
    Global Ptr
    
    ELP_ConvertPath(_FileName)
    , Size := DllCall("Version.dll\GetFileVersionInfoSizeW", Ptr, &_FileName, Ptr, 0)
    
    If (!Size){
        ErrorLevel := 1
        Return
    }
    
    VarSetCapacity(FileVersion,Size,0)
    , DllCall("Version.dll\GetFileVersionInfoW", Ptr, &_FileName, "Int", 0, "Int", Size, Ptr, &FileVersion)
    , VarSetCapacity(SL, 2, 0)
    , NumPut(Asc("\"), SL, 0, "UShort")
    
    If (!DllCall("Version.dll\VerQueryValueW", Ptr, &FileVersion, Ptr, &SL, "Int64*", pFFI, "UInt*", uSize)){
        VarSetCapacity(FileVersion, Size, 0)
        , VarSetCapacity(FileVersion, 0)
        , ErrorLevel := 1
        
        Return
    }
    
    ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms646997(v=vs.85).aspx
    
    If (_Which = 1){
        FVMS := NumGet(pFFI+0, 8, "Int")
        , FVLS := NumGet(pFFI+0, 12, "Int")
        , Version := (FVMS >> 16) . "." . (FVMS & 0xFFFF) . "." . (FVLS >> 16) . "." . (FVLS & 0xFFFF)
    } Else If (_Which = 2){
        PVMS := NumGet(pFFI+0, 8, "Int")
        , PVLS := NumGet(pFFI+0, 12, "Int")
        , Version := (PVMS >> 16) . "." . (PVMS & 0xFFFF) . "." . (PVLS >> 16) . "." . (PVLS & 0xFFFF)
    }
    
    ;Cleanup
    VarSetCapacity(FileVersion, Size, 0)
    , VarSetCapacity(FileVersion, 0)
    
    Return Version
}

ELP_FileRemoveDirectory(_Directory, _Recurse = 0)
{
    Global Ptr
    Static MY_ID := "ELPFRD"
    
    If (SubStr(_Directory,0) != "\")
        _Directory .= "\"
    
    __Directory := _Directory
    , ELP_ConvertPath(__Directory)
    , E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
    
    If (!_Recurse And !E){
        ;If (A_LastError
        Return ErrorLevel := 1
    } Else If (_Recurse And !E){
        E := ELP_FileDelete(_Directory . "*.*")
        
        If (E){
            ErrorLevel := 1
            
            Return E
        }
        
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
        
        Loop
        {
            Folder := ELP_LoopFilePattern(_Directory . "*.*", 2, 0, FileInfo, MY_ID)
            
            If (Folder = "")
                Break
            
            E := ELP_FileRemoveDirectory(Folder, _Recurse)
            
            If (E){
                ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
                , ErrorLevel := 1
                
                Return E
            }
        }
        
        __Directory := _Directory
        , ELP_ConvertPath(__Directory)
        , E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
        
        If (!E)
            Return ErrorLevel := 1
    }
}

ELP_FileExists(_FileName, _IncludeFolders = 1, _Recurse = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFE"
    
    If (_IsPattern){
        P := InStr(_FileName, "\", False, 0)
        
        If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
            _IsPattern := False
    }
    
    If (_IncludeFolders != 1 Or _Recurse)
        _IsPattern := True
    Else If (!_IsPattern){
        __FileName := _FileName
        ELP_ConvertPath(__FileName)
        , E := DllCall("GetFileAttributesW", Ptr, &__FileName)
        
        If (E = -1) ;Try the find-file method
            _IsPattern := True, E := False
    }
    
    If (_IsPattern){
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
        , FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
        
        If (FileName != ""){
            ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
            , E := True
        }
    }
    
    Return E
}

ELP_FileDelete(_FileName, _ForceDelete = 1, _IsPattern = 1, _ErrorIfNotExist = 1)
{
    Global Ptr
    Static MY_ID := "ELPFD"
    
    FailedDeletes := 0
    , __FileName := _FileName
    
    If (_IsPattern){
        P := InStr(_FileName, "\", False, 0)
        
        If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
            _IsPattern := False
    }
    
    If (!_IsPattern){
        ELP_ConvertPath(__FileName)
        , E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
        
        If (A_LastError != 2){
            If (E = 5 And _ForceDelete){
                If (ELP_FileSetAttributes("-R", _FileName, 0, 0, _IsPattern))
                    FailedDeletes ++
                Else If (!DllCall("DeleteFileW", Ptr, &__FileName))
                    FailedDeletes ++
            } Else If (E)
                FailedDeletes ++
        } Else If (A_LastError And _ErrorIfNotExist)
            FailedDeletes ++
            , ErrorLevel := 1
    } Else {
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
        Loop
        {
            FileName := ELP_LoopFilePattern(_FileName, 0, 0, FileInfo, MY_ID)
            
            If (FileName = "")
                Break
            
            __FileName := FileName
            , ELP_ConvertPath(__FileName)
            , E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
            
            If (A_LastError != 2){
                If (E = 5 And _ForceDelete){
                    Original_Attributes := ELP_FileGetAttributesFromFI(FileInfo, 1)
                    
                    If (Original_Attributes){
                        New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, "-R")
                        
                        If (New_Attributes != Original_attributes){
                            ELP_FileSetRAWAttributes(FileName, New_Attributes)
                            , E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
                        }
                    }
                }
                
                If (E)
                    FailedDeletes ++
            }
        }
    }
    
    Return FailedDeletes
}

ELP_FileSetAttributes(_Attributes, _FileName, _IncludeFolders = 0, _Recurse = 0, _IsPattern = 1)
{
    Global Ptr
    Static MY_ID := "ELPFSA"
    
    If (_IsPattern){
        P := InStr(_FileName, "\", False, 0)
        
        If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
            _IsPattern := False
    }
    
    FailedAttributeChanges := 0
    
    If (!_IsPattern){
        Original_Attributes := ELP_FileGetAttributes(_FileName, 1)
        
        If (Original_Attributes = -1)
            FailedAttributeChanges ++
        Else {      
            New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
            
            If (New_Attributes != Original_Attributes){
                ELP_FileSetRAWAttributes(_FileName, New_Attributes)
                
                If (ErrorLevel)
                    FailedAttributeChanges ++
            }
        }
    } Else {
        ;Just incase this search pattern was done before - rare but it might happen
        ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
        Loop
        {
            FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
            
            If (FileName = "")
                Break
            
            Original_Attributes := ELP_FileGetAttributes(FileName, 1)
            
            If (Original_Attributes = -1)
                FailedAttributeChanges ++
            Else {      
                New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
                
                If (New_Attributes != Original_Attributes){
                    ELP_FileSetRAWAttributes(_FileName, New_Attributes)
                    
                    If (ErrorLevel)
                        FailedAttributeChanges ++
                }
            }
        }
    }
    
    Return FailedAttributeChanges
}

ELP_ChangeRawAttributes(New_Attributes, _NewAttributes)
{
    Static FILE_ATTRIBUTE_ARCHIVE := 32
    , FILE_ATTRIBUTE_HIDDEN := 2
    , FILE_ATTRIBUTE_NORMAL := 128
    , FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
    , FILE_ATTRIBUTE_OFFLINE := 4096
    , FILE_ATTRIBUTE_READONLY := 1
    , FILE_ATTRIBUTE_SYSTEM := 4
    , FILE_ATTRIBUTE_TEMPORARY := 256
    , Allowed_Attributes := "AHN2ORST"
    
    Mode := -1
    
    Loop,Parse,_NewAttributes
    {
        If (A_LoopField = "-")
            Mode := -1
        Else If (A_LoopField = "+")
            Mode := 1
        Else If (A_LoopField = "^")
            Mode := 0
        Else If (InStr(Allowed_Attributes, A_LoopField)){
            If (A_LoopField = "R")
                Temp_Attribute := FILE_ATTRIBUTE_READONLY
            Else If (A_LoopField = "A")
                Temp_Attribute := FILE_ATTRIBUTE_ARCHIVE
            Else If (A_LoopField = "H")
                Temp_Attribute := FILE_ATTRIBUTE_HIDDEN
            Else If (A_LoopField = "N")
                Temp_Attribute := FILE_ATTRIBUTE_NORMAL
            Else If (A_LoopField = 2)
                Temp_Attribute := FILE_ATTRIBUTE_NOT_CONTENT_INDEXED
            Else If (A_LoopField = "O")
                Temp_Attribute := FILE_ATTRIBUTE_OFFLINE
            Else If (A_LoopField = "S")
                Temp_Attribute := FILE_ATTRIBUTE_SYSTEM
            Else If (A_LoopField = "T")
                Temp_Attribute := FILE_ATTRIBUTE_TEMPORARY
            
            If (Mode < 0)
                New_Attributes := New_Attributes & ~Temp_Attribute
            Else If (Mode > 0)
                New_Attributes := New_Attributes | Temp_Attribute
            Else
                New_Attributes := New_Attributes ^ Temp_Attribute
        }
    }
    
    Return New_Attributes
}

ELP_FileSetRAWAttributes(_FileName, _Attributes)
{
    Global Ptr
    
    If _Attributes Is Not Number
    {
        ErrorLevel := -1
        Return
    }
    
    ELP_ConvertPath(_FileName)
    , ErrorLevel := DllCall("SetFileAttributesW", Ptr, &_FileName, "Int", _Attributes) = 0 ? 1 : 0
}

ELP_ConvertRAWAttributes(_RawAttributes)
{
    Static FILE_ATTRIBUTE_ARCHIVE := 32
    , FILE_ATTRIBUTE_COMPRESSED := 2048
    , FILE_ATTRIBUTE_DEVICE := 64
    , FILE_ATTRIBUTE_DIRECTORY := 16
    , FILE_ATTRIBUTE_ENCRYPTED := 16384
    , FILE_ATTRIBUTE_HIDDEN := 2
    , FILE_ATTRIBUTE_NORMAL := 128
    , FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
    , FILE_ATTRIBUTE_OFFLINE := 4096
    , FILE_ATTRIBUTE_READONLY := 1
    , FILE_ATTRIBUTE_REPARSE_POINT := 1024
    , FILE_ATTRIBUTE_SPARSE_FILE := 512
    , FILE_ATTRIBUTE_SYSTEM := 4
    , FILE_ATTRIBUTE_TEMPORARY := 256
    , FILE_ATTRIBUTE_VIRTUAL := 65536
    
    Attributes .= _RawAttributes & FILE_ATTRIBUTE_ARCHIVE ? "A" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_COMPRESSED ? "C" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_DEVICE ? "1" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_DIRECTORY ? "D" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_ENCRYPTED ? "E" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_HIDDEN ? "H" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_NORMAL ? "N" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_NOT_CONTENT_INDEXED ? "2" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_OFFLINE ? "O" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_READONLY ? "R" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_REPARSE_POINT ? "3" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_SPARSE_FILE ? "4" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_SYSTEM ? "S" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_TEMPORARY ? "T" : ""
    , Attributes .= _RawAttributes & FILE_ATTRIBUTE_VIRTUAL ? "V" : ""
    
    Return Attributes
}

ELP_FileGetAttributes(_FileName, _Raw = 0)
{
    Global Ptr
    
    ELP_ConvertPath(_FileName)
    , RAW_Attributes := DllCall("GetFileAttributesW", Ptr, &_FileName)
    
    If (RAW_Attributes = -1)
        Return -1
    
    If (_Raw)
        Return RAW_Attributes
    Else 
        Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetSize(_FileName, _Units = "B", _Floor = 0)
{
    Static MY_ID := "ELPFGS"
    
    If (!ELP_FileExists(_FileName))
        Return 0
    
    Handle := ELP_OpenFileHandle(_FileName, "Read", FileSize)
    
    If (Handle = -1){
        ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID) ;Just incase this search pattern was done before - rare but it might happen
        If (ELP_LoopFilePattern(_FileName, 1, 0, FileInfo) = "")
            FileSize := 0
        Else {
            FileSize := ELP_GetFileSizeFromFI(FileInfo)
            , ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID)
        }
    } Else
        ELP_CloseFileHandle(Handle)
    
    If (_Units = "K")
        FileSize := FileSize / 1024
    Else If (_Units = "M")
        FileSize := FileSize / 1024 / 1024
    Else If (_Units = "G")
        FileSize := FileSize / 1024 / 1024 / 1024
    
    If (_Floor)
        FileSize := Floor(FileSize)
    
    Return FileSize
}

ELP_GetFileSizeFromFI(ByRef _FileInfo, _Units = "B", _Floor = 0)
{
    Static FileSizeOffset := 28, MAXDWORD := 4294967295
    
    HighOrder := NumGet(_FileInfo, FileSizeOffset, "Int")
    , LowOrder := NumGet(_FileInfo, FileSizeOffset + 4, "Int")
    
    FileSize := (HighOrder * (MAXDWORD+1)) + LowOrder
    
    If (_Units = "K")
        FileSize := FileSize / 1024
    Else If (_Units = "M")
        FileSize := FileSize / 1024 / 1024
    Else If (_Units = "G")
        FileSize := FileSize / 1024 / 1024 / 1024
    
    If (_Floor)
        FileSize := Floor(FileSize)
    
    Return FileSize
}

ELP_FileGetAttributesFromFI(ByRef _FileInfo, _Raw = 0)
{
    Static FileAttributesOffset := 0
    
    RAW_Attributes := NumGet(_FileInfo, FileAttributesOffset, "Int")
    
    If (_Raw)
        Return RAW_Attributes
    Else
        Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetTimeFromFI(ByRef _FileInfo, _Which = "M", _Style = 1)
{
    Global Ptr
    Static CO := 4, AO := 12, MO := 20
    
    
    If (_Which = "C")
        Address := &_FileInfo + CO
    Else If (_Which = "A")
        Address := &_FileInfo + AO
    Else 
        Address := &_FileInfo + MO
    
    VarSetCapacity(FSystemTime,16,0) ;8*2
    
    If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
        Year := NumGet(FSystemTime, 0, "Short") 
        , Month := NumGet(FSystemTime, 2, "Short") 
        ;, WDay := NumGet(FSystemTime, 4, "Short")
        , Day := NumGet(FSystemTime, 6, "Short")
        , Hour := NumGet(FSystemTime, 8, "Short")
        , Minute := NumGet(FSystemTime, 10, "Short")
        , Second := NumGet(FSystemTime, 12, "Short")
        , Milisecond := NumGet(FSystemTime, 14, "Short")
        , VarSetCapacity(FSystemTime, 16, 0)
        , VarSetCapacity(FSystemTime, 0)
        
        If (_Style = 1){
            RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
            , RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
            Return RVal
        } Else If (_Style = 2)
            Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
    } Else {
        VarSetCapacity(FSystemTime, 16, 0)
        , VarSetCapacity(FSystemTime, 0)
        , ErrorLevel := 3
    }
}

ELP_FileGetTime(_FileName, _Which = "M", _Style = 1)
{
    Global Ptr
    Static CO := 4, AO := 12, MO := 20
    
    Handle := ELP_OpenFileHandle(_FileName, "Read")
    
    If (Handle = -1){
        ErrorLevel := 1
        Return
    }
    
    VarSetCapacity(FileInformation, 52, 0) ;13*4
    
    If (!DllCall("GetFileInformationByHandle", Ptr, Handle, Ptr, &FileInformation)){
        ErrorLevel := 2
        , ELP_CloseFileHandle(Handle)
        , VarSetCapacity(FileInformation, 52, 0)
        , VarSetCapacity(FileInformation, 0)
        
        Return
    } Else
        ELP_CloseFileHandle(Handle)
    
    If (_Which = "C")
        Address := &FileInformation + CO
    Else If (_Which = "A")
        Address := &FileInformation + AO
    Else 
        Address := &FileInformation + MO
    
    VarSetCapacity(FSystemTime,16,0) ;8*2
    
    If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
        Year := NumGet(FSystemTime, 0, "Short") 
        , Month := NumGet(FSystemTime, 2, "Short") 
        ;, WDay := NumGet(FSystemTime, 4, "Short")
        , Day := NumGet(FSystemTime, 6, "Short")
        , Hour := NumGet(FSystemTime, 8, "Short")
        , Minute := NumGet(FSystemTime, 10, "Short")
        , Second := NumGet(FSystemTime, 12, "Short")
        , Milisecond := NumGet(FSystemTime, 14, "Short")
        , VarSetCapacity(FSystemTime, 16, 0)
        , VarSetCapacity(FSystemTime, 0)
        
        If (_Style = 1){
            RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
            , RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
            Return RVal
        } Else If (_Style = 2)
            Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
    } Else {
        VarSetCapacity(FSystemTime, 16, 0)
        , VarSetCapacity(FSystemTime, 0)
        , ErrorLevel := 3
    }
}


ELP_FileAppend(_String, _FileName)
{
    Global Ptr
    Static UTF8_BOM1 = 239, UTF8_BOM2 = 187, UTF8_BOM3 = 191
    , UTF16LE_BOM1 = 255, UTF16LE_BOM2 = 254
    , UTF8_CP = 65001, UTF16_CP = 1200
    
    If (_FileName = ""){
        ErrorLevel := 2
        Return
    }
    
    If (SubStr(_FileName, 1, 1) = "*"){
        Binary_Mode := True
        , _FileName := SubStr(_FileName, 2)
    }
    
    If (P := InStr(_FileName, ",")){
        CodePage := SubStr(_FileName, P + 1)
        , _FileName := SubStr(_FileName, 1, P-1)
    } Else If (A_FileEncoding)
        CodePage := A_FileEncoding
    
    Handle := ELP_OpenFileHandle(_FileName, "Write", FileSize)
    
    If (Handle = -1){
        ErrorLevel := 1
        Return
    }
    
    If (CodePage = "")
        W_CP := 0
    Else If (CodePage = "UTF-8" Or CodePage = "UTF-8-RAW")
        W_CP := UTF8_CP
    Else If (CodePage = "UTF-16" Or CodePage = "UTF-16-RAW")
        W_CP := UTF16_CP
    Else If (SubStr(CodePage, 1, 2) = "CP"){
        W_CP := SubStr(CodePage, 2)
        
        If W_CP Is Not Number
            W_CP := 0
    } Else
        W_CP := 0
    
    If (!Binary_Mode){
        If (!InStr(_String, "`r`n") And InStr(_String, "`n"))
            StringReplace, _String, _String, "`n", "`r`n", 1
    }
    
    If (A_IsUnicode){
        If (W_CP != UTF16_CP){
            If (W_CP = 0)
                W_CP := DllCall("GetACP")
            
            StringLength := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
            , VarSetCapacity(__String, StringLength, 0)
            , DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength, Ptr, 0, Ptr, 0)
            , Converted := True
        }
    } Else If (W_CP != 0){
        StringLength := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0)
        , VarSetCapacity(__String, StringLength * 2, 0)
        , DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength)
        
        If (W_CP != UTF16_CP){
            Temp_StringLength := StringLength
            , StringLength := DllCall("WideCharToMultiByte","UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
            , VarSetCapacity(_String,StringLength,0)
            , DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, &_String, "Int", StringLength, Ptr, 0, Ptr, 0)
            , VarSetCapacity(__String, Temp_StringLength * 2, 0)
            , VarSetCapacity(__String, 0)
        } Else
            StringLength *= 2
        
        Converted := True
    }
    
    If (FileSize = 0){
        If (CodePage = "UTF-8"){
            VarSetCapacity(BOM, 3, 0)
            , NumPut(UTF8_BOM1, BOM,0, "UChar")
            , NumPut(UTF8_BOM2, BOM,1, "UChar")
            , NumPut(UTF8_BOM3, BOM,2, "UChar")
            , ELP_WriteData(Handle, &BOM, 3)
            , FileSize += 3
            , VarSetCapacity(BOM, 3, 0)
            , VarSetCapacity(BOM, 0)
        } Else If (CodePage = "UTF-16"){
            VarSetCapacity(BOM, 2, 0)
            , NumPut(UTF16LE_BOM1, BOM, 0, "UChar")
            , NumPut(UTF16LE_BOM2, BOM, 1, "UChar")
            , ELP_WriteData(Handle, &BOM, 2)
            , FileSize += 2
            , VarSetCapacity(BOM, 2, 0)
            , VarSetCapacity(BOM, 0)
        }
    }
    
    ELP_SetFilePointer(Handle, FileSize)
    
    If (Converted){
        If (A_IsUnicode Or W_CP = UTF16_CP){
            ELP_WriteData(Handle, &__String, StringLength)
            , VarSetCapacity(__String, StringLength, 0)
            , VarSetCapacity(__String, 0)
        } Else {
            ELP_WriteData(Handle, &_String, StringLength)
            , VarSetCapacity(_String, StringLength, 0)
            , VarSetCapacity(_String, 0)
        }
    } Else
        ELP_WriteData(Handle, &_String, StrLen(_String) * (A_IsUnicode ? 2 : 1))
    
    ELP_CloseFileHandle(Handle)
}

ELP_LoopFilePattern(_FileName, _IncludeFolders = 0, _DoRecurse = 0, ByRef FileInfo = "", Override_ID = "")
{
    Static
    ;Ensures that atleast the first entry of the common sets are static
    Static @0__CurrentFileName, @0__CurrentPath, @0__Handle, @0__FN, Stored__Handles
    , @0_ELPFRD_CurrentFileName, @0_ELPFRD_CurrentPath, @0_ELPFRD_Handle, @0_ELPFRD_FN, Stored_ELPFRD_Handles
    , @0_ELPFE_CurrentFileName, @0_ELPFE_CurrentPath, @0_ELPFE_Handle, @0_ELPFE_FN, Stored_ELPFE_Handles
    , @0_ELPFD_CurrentFileName, @0_ELPFD_CurrentPath, @0_ELPFD_Handle, @0_ELPFD_FN, Stored_ELPFD_Handles
    , @0_ELPFSA_CurrentFileName, @0_ELPFSA_CurrentPath, @0_ELPFSA_Handle, @0_ELPFSA_FN, Stored_ELPFSA_Handles
    , @0_ELPFGS_CurrentFileName, @0_ELPFGS_CurrentPath, @0_ELPFGS_Handle, @0_ELPFGS_FN, Stored_ELPFGS_Handles
    , @0_ELPCF_CurrentFileName, @0_ELPCF_CurrentPath, @0_ELPCF_Handle, @0_ELPCF_FN, Stored_ELPCF_Handles
    , @0_ELPFM_CurrentFileName, @0_ELPFM_CurrentPath, @0_ELPFM_Handle, @0_ELPFM_FN, Stored_ELPFM_Handles
    , @0_ELPFCD_CurrentFileName, @0_ELPFCD_CurrentPath, @0_ELPFCD_Handle, @0_ELPFCD_FN, Stored_ELPFCD_Handles
    , @0_ELPFC_CurrentFileName, @0_ELPFC_CurrentPath, @0_ELPFC_Handle, @0_ELPFC_FN, Stored_ELPFC_Handles
    , @0_ELPFST_CurrentFileName, @0_ELPFST_CurrentPath, @0_ELPFST_Handle, @0_ELPFST_FN, Stored_ELPFST_Handles
    Global Ptr
    Local FileName, FilePath, SearchPattern, Folders
    , P1, P2, Handle, __FileName, __ID, ID, FoundName ;, Recursed := 0
    
    ELPLFP_Start:
    
    If (Last_OverrideID = Override_ID And Last_FileName = _FileName){
        __ID := Last___ID
        , FileName := @%__ID%_%Override_ID%_CurrentFileName
        , CurrentPath := @%__ID%_%Override_ID%_CurrentPath
        , Handle := @%__ID%_%Override_ID%_Handle
    } Else If (P1 := InStr(Stored_%Override_ID%_Handles,"|" . _FileName . "|")){
        P2 := P1 + StrLen(_FileName) + 2
        , __ID := SubStr(Stored_%Override_ID%_Handles, P2, InStr(Stored_%Override_ID%_Handles, "|", False, P2) - P2)
        , FileName := @%__ID%_%Override_ID%_CurrentFileName
        , CurrentPath := @%__ID%_%Override_ID%_CurrentPath
        , Handle := @%__ID%_%Override_ID%_Handle
        , Last_FileName := _FileName
        , Last___ID := __ID
        , Last_OverrideID := Override_ID
    } Else If (_IncludeFolders != "Close"){
        FileName := _FileName
        , __ID := 0
        
        While (InStr(Stored_%Override_ID%_Handles,"|" . __ID . "|"))
            __ID ++
        
        @%__ID%_%Override_ID%_FN := 0
        , Stored_%Override_ID%_Handles .= Stored_%Override_ID%_Handles ? _FileName . "|" . __ID . "|" : "|" . _FileName . "|" . __ID . "|"
        , Last_FileName := _FileName
        , Last___ID := __ID
        , Last_OverrideID := Override_ID
    }
    
    If (_IncludeFolders = "Close"){
        ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
        If (__ID != ""){
            VarSetCapacity(@%__ID%_%Override_ID%_CurrentFileName, 0)
            , VarSetCapacity(@%__ID%_%Override_ID%_CurrentPath, 0)
            , ELP_FindClose(@%__ID%_%Override_ID%_Handle)
            , VarSetCapacity(@%__ID%_%Override_ID%_Handle, 0)
            
            Loop,% @%__ID%_%Override_ID%_FN
                VarSetCapacity(@Folder_%A_Index%_%Override_ID%, 0)
            
            VarSetCapacity(@%__ID%_%Override_ID%_FN, 0)
        }
        
        VarSetCapacity(Last_FileName, 0)
        , VarSetCapacity(Last___ID, 0)
        , VarSetCapacity(Last_OverrideID, 0)
        , VarSetCapacity(FileInfo, 1140, 0)
        , VarSetCapacity(FileInfo, 0)
        
        Return
    }
    
    If (!Handle){
        __FileName := FileName
        , ELP_ConvertPath(__FileName)
        , VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
        , Handle := DllCall("FindFirstFileW", Ptr, &__FileName, Ptr, &FileInfo)
        
        If (Handle = -1){
            If (_DoRecurse){
                Folders := ELP_FindFolders(FileName, _DoRecurse)

                If (Folders != ""){
                    P1 := InStr(FileName, "\", False, 0)
                    , FilePath := SubStr(FileName, 1, P1)
                    , SearchPattern := SubStr(FileName, P1+1)
                    
                    Loop,Parse,Folders,|
                    {
                        @%__ID%_%Override_ID%_FN ++
                        ID := @%__ID%_%Override_ID%_FN
                        @Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
                    }
                }
            }
        } Else {
            FoundName := ELP_GetNameFromFI(FileInfo)
            , @%__ID%_%Override_ID%_CurrentFileName := FileName
            , CurrentPath := @%__ID%_%Override_ID%_CurrentPath := SubStr(FileName, 1, InStr(FileName, "\", False, 0))
            , @%__ID%_%Override_ID%_Handle := Handle
            
            If (FoundName = "." Or FoundName = ".."){
                FoundName := ""
                , VarSetCapacity(FileInfo, 0)
                GoTo,ELPLFP_Start
            } Else If (!_IncludeFolders){
                If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
                    FoundName := ""
                    , VarSetCapacity(FileInfo, 0)
                    GoTo,ELPLFP_Start
                }
            } Else If (_IncludeFolders = 2){
                If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
                    FoundName := ""
                    , VarSetCapacity(FileInfo, 0)
                    GoTo,ELPLFP_Start
                }
            }
        }
    } Else {
        VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
        
        If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
            ELP_FindClose(Handle)
            , Handle := @%__ID%_%Override_ID%_Handle := ""
            
            If (_DoRecurse){
                Folders := ELP_FindFolders(FileName, _DoRecurse)
                
                If (Folders != ""){
                    P1 := InStr(FileName, "\", False, 0)
                    , FilePath := SubStr(FileName, 1, P1)
                    , SearchPattern := SubStr(FileName, P1+1)
                    
                    Loop, Parse, Folders, |
                    {
                        @%__ID%_%Override_ID%_FN ++
                        ID := @%__ID%_%Override_ID%_FN
                        @Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
                    }
                }
            }
        } Else {
            FoundName := ELP_GetNameFromFI(FileInfo)
            
            If (FoundName = "." Or FoundName = ".."){
                FoundName := ""
                , VarSetCapacity(FileInfo, 0)
                GoTo,ELPLFP_Start
            } Else If (!_IncludeFolders){
                If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
                    FoundName := ""
                    , VarSetCapacity(FileInfo, 0)
                    GoTo,ELPLFP_Start
                }
            } Else If (_IncludeFolders = 2){
                If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
                    FoundName := ""
                    , VarSetCapacity(FileInfo, 0)
                    GoTo,ELPLFP_Start
                }
            }
        }
    }
    
    If (FoundName != "")
        Return CurrentPath . FoundName
    Else If (@%__ID%_%Override_ID%_FN){
        ID := @%__ID%_%Override_ID%_FN
        , @%__ID%_%Override_ID%_FN --
        , @%__ID%_%Override_ID%_CurrentFileName := @Folder_%ID%_%Override_ID%
        , VarSetCapacity(@Folder_%ID%_%Override_ID%, 0)
        GoTo, ELPLFP_Start
    } Else {
        If (InStr(Stored_%Override_ID%_Handles, "|" . _FileName . "|")){
            ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
            , @%__ID%_%Override_ID%_CurrentFileName := ""
            , @%__ID%_%Override_ID%_CurrentPath := ""
            , @%__ID%_%Override_ID%_Handle := ""
            , Last_FileName := Last___ID := Last_OverrideID := ""
        }
    }
}

ELP_DeleteFileHandle(ByRef _StoredHandles, _FileName)
{
    P1 := InStr(_StoredHandles, "|" . _FileName . "|")
    
    If (P1){
        P2 := P1 + StrLen(_FileName) + 2
        , New_1 := SubStr(_StoredHandles, 1, P1 - 1)
        , New_2 := SubStr(_StoredHandles, InStr(_StoredHandles, "|", False, P2))
        , _StoredHandles := New_1 . New_2
        
        If (_StoredHandles = "|")
            VarSetCapacity(_StoredHandles, 0)
    }
}

ELP_FindFolders(_FileName, _DoRecurse)
{
    Global Ptr
    
    If (_DoRecurse = 2)
        __FilePath := _FileName
    Else
        __FilePath := SubStr(_FileName, 1, InStr(_FileName, "\", False, 0)) . "*.*"
    
    ELP_ConvertPath(__FilePath)
    , VarSetCapacity(FileInfo, 1140, 0) ;4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
    , Handle := DllCall("FindFirstFileW", Ptr, &__FilePath, Ptr, &FileInfo)
    
    If (Handle = -1)
        Return
    
    Loop
    {
        FolderName := ELP_GetNameFromFI(FileInfo)
        
        If (FolderName != "." And FolderName != ".."){
            If (ELP_IsDirectoryFromFI(FileInfo))
                AllFolders .= AllFolders != "" ? "|" . FolderName : FolderName
        }
            
        VarSetCapacity(FileInfo, 1140, 0) ;4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
        If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
            ELP_FindClose(Handle)
            
            Return AllFolders
        }
    }
}

ELP_GetNameFromFI(ByRef _FileInfo)
{
    Global Ptr
    Static NameOffset := 44, L_Name := "StrGet"
    
    If (A_IsUnicode)
        Name := %L_Name%(&_FileInfo + NameOffset,-1,"UTF-16")
    Else
        Name := StrGetB(&_FileInfo + NameOffset,-1,"UTF-16")
    
    Return Name
}

StrGetB2(Address, Length=-1, Encoding=0)
{
    ; Flexible parameter handling:
    if Length is not integer
    Encoding := Length,  Length := -1

    ; Check for obvious errors.
    if (Address+0 < 1024)
        return

    ; Ensure 'Encoding' contains a numeric identifier.
    if Encoding = UTF-16
        Encoding = 1200
    else if Encoding = UTF-8
        Encoding = 65001
    else if SubStr(Encoding,1,2)="CP"
        Encoding := SubStr(Encoding,3)

    if !Encoding ; "" or 0
    {
        ; No conversion necessary, but we might not want the whole string.
        if (Length == -1)
            Length := DllCall("lstrlen", "uint", Address)
        VarSetCapacity(String, Length)
        DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
    }
    else if Encoding = 1200 ; UTF-16
    {
        char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
        VarSetCapacity(String, char_count)
        DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
    }
    else if Encoding is integer
    {
        ; Convert from target encoding to UTF-16 then to the active code page.
        char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
        VarSetCapacity(String, char_count * 2)
        char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
        String := StrGetB(&String, char_count, 1200)
    }
    
    return String
}

ELP_IsDirectoryFromFI(ByRef _FileInfo)
{
    Static FILE_ATTRIBUTE_DIRECTORY := 0x10
    
    Return NumGet(_FileInfo, 0, "UInt") & FILE_ATTRIBUTE_DIRECTORY
}

ELP_FindClose(_Handle)
{
    Global Ptr
    
    Return DllCall("FindClose", Ptr, _Handle)
}










ELP_SetEndOfFile(_Handle, _Size)
{
    Global Ptr
    
    Old_Pointer := ELP_GetFilePointer(_Handle)
    , ELP_SetFilePointer(_Handle, _Size)
    , ErrorLevel := DllCall("SetEndOfFile", Ptr, _Handle) = 0 ? 1 : 0
    , ELP_SetFilePointer(_Handle, Old_Pointer)
    
    Return ErrorLevel
}

ELP_WOW64FileRedirect(_NewState)
{
    Global Ptr
    Static OldValue, CurrentValue := "Enabled"
    
    If ((_NewState = 0 Or _NewState = "Disable") And CurrentValue != "Disabled"){
        VarSetCapacity(OldValue, 500, 0)
        , E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
        , CurrentValue := "Disable"
    } Else If ((_NewState = 1 Or _NewState = "Enable") And CurrentValue != "Enabled"){
        E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
        , CurrentValue := "Enabled"
    }
    
    Return E
}

ELP_OpenFileHandle(_FileName, _DesiredAccess, ByRef _FileSize = 0)
{
    Global Ptr
    Static GENERIC_ALL := 0x10000000
    , GENERIC_READ = 0x80000000
    , GENERIC_WRITE := 0x40000000
    , GENERIC_EXECUTE  := 0x20000000
    , FILE_SHARE_DISABLE := 0x00000000
    , FILE_SHARE_DELETE := 0x00000004
    , FILE_SHARE_READ := 0x00000001
    , FILE_SHARE_WRITE := 0x00000002
    , FILE_SHARE_READ_WRITE := 0x00000003
    
    ELP_ConvertPath(_FileName)
    
    If (_DesiredAccess = "Read")
        Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_READ, "UInt", FILE_SHARE_READ_WRITE, "UInt", 0, "UInt", 3, "UInt", 0, "UInt", 0)
    Else If (_DesiredAccess = "Write")
        Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_READ | GENERIC_WRITE, "UInt", FILE_SHARE_READ, "UInt", 0, "UInt", 4, "UInt", 0, "UInt", 0)
    
    _FileSize := 0
    If (Handle_ = -1)
        ErrorLevel := 1
    Else {
        DllCall("GetFileSizeEx", Ptr, Handle_, "Int64*", _FileSize)
        , _FileSize := _FileSize = -1 ? 0 : _FileSize
    }
    
    Return Handle_
}

ELP_SetFilePointer(_Handle, _DesiredValue)
{
    Global Ptr
    
    DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", _DesiredValue, "UInt *", P, "Int", 0)
}

ELP_WriteData(ByRef _Handle, _DataAddress, _BytesToWrite, _AttemptV = 1)
{
    Global Ptr
    Static UInt_MAX = 4294967295
    
    If (_AttemptV)
        Verify_Writes := ELP_MasterSettings("Get", "Verify_Writes")
    
    WriteBytes := _BytesToWrite
    , Original_FilePointer := ELP_GetFilePointer(_Handle)
    , Total_BytesWritten := 0
    
    While (WriteBytes > 0){
        Write_Size := WriteBytes > UInt_MAX ? UInt_MAX : WriteBytes
        , WriteBytes -= UInt_MAX
        
        , ELP_SetFilePointer(_Handle, Original_FilePointer + ((A_Index - 1) * UInt_MAX))
        , DllCall("WriteFile", Ptr, _Handle, Ptr, _DataAddress + ((A_Index - 1) * UInt_MAX), "UInt", Write_Size, "UInt*", BytesWritten, "UInt", 0)
        
        , Total_BytesWritten += BytesWritten
    }
    
    If (ELP_MasterSettings("Get", "Count_BytesWritten"))
        ELP_StoreBytes("AddWrite", Total_BytesWritten)
    
    If (Verify_Writes And _AttemptV)
        ELP_VerifyWrite(_Handle, _DataAddress, _BytesToWrite, Original_FilePointer, ELP_GetFilePointer(_Handle))
    
    Return Total_BytesWritten
}

ELP_ReadData(_Handle, _DataAddress, _BytesToRead, _AttemptV = 1)
{
    Global Ptr
    Static UInt_MAX = 4294967295
    
    If (_AttemptV)
        ELP_VerifyReads := ELP_MasterSettings("Get", "ELP_VerifyReads")
    
    ReadBytes := _BytesToRead
    , Original_FilePointer := ELP_GetFilePointer(_Handle)
    , Total_BytesRead := 0
    
    While (ReadBytes > 0){
        Read_Size := ReadBytes > UInt_MAX ? UInt_MAX : ReadBytes
        , ReadBytes -= UInt_MAX
        
        , ELP_SetFilePointer(_Handle, Original_FilePointer + ((A_Index - 1) * UInt_MAX))
        , DllCall("ReadFile", Ptr, _Handle, Ptr, _DataAddress + ((A_Index - 1) * UInt_MAX), "UInt", Read_Size, "UInt*", BytesRead, "UInt", 0)
        
        , Total_BytesRead += BytesRead
    }
    
    If (ELP_MasterSettings("Get", "Count_BytesRead"))
        ELP_StoreBytes("AddRead", Total_BytesRead)
    
    If (_AttemptV And ELP_VerifyReads)
        ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, ELP_GetFilePointer(_Handle))
    
    Return Total_BytesRead
}

ELP_CloseFileHandle(_Handle)
{
    Global Ptr
    
    DllCall("CloseHandle", Ptr, _Handle)
}

ELP_GetFilePointer(_Handle)
{
    Global Ptr
    
    DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", 0, "Int64*", Current_FilePointer, "Int", 1)
    
    Return Current_FilePointer
}

ELP_VerifyWrite(_Handle, _DataAddress, _BytesToWrite, Original_FilePointer, Current_FilePointer)
{
    ;FileName := ELP_GetPathFromHandle(_Handle)
    ;If (FileName = -1)
    ;   Return
    
    VarHash := ELP_CalcMD5(_DataAddress, _BytesToWrite)
    
    ;, ELP_CloseFileHandle(_Handle)
    ;, H := ELP_OpenFileHandle(FileName, "Read", FileSize)
    , ELP_SetFilePointer(_Handle, Original_FilePointer)
    , VarSetCapacity(TempData, _BytesToWrite, 0)
    , ELP_ReadData(_Handle, &TempData, _BytesToWrite, 0)
    
    ;, ELP_CloseFileHandle(H)
    , FileHash := ELP_CalcMD5(&TempData, _BytesToWrite)
    , VarSetCapacity(TempData, _BytesToRead, 0)
    , VarSetCapacity(TempData, 0)
    
    ;, _Handle := ELP_OpenFileHandle(FileName, "Write") ;Open the file back up to it's original state
    , ELP_SetFilePointer(_Handle, Current_FilePointer)
    
    If (VarHash != FileHash)
        ErrorLevel := -100
}

ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, Current_FilePointer)
{
    VarHash := ELP_CalcMD5(_DataAddress, _BytesToRead)
    
    , ELP_SetFilePointer(_Handle, Original_FilePointer)
    , VarSetCapacity(TempData, _BytesToRead, 0)
    
    , ELP_ReadData(_Handle, &TempData, _BytesToRead, 0)
    , FileHash := ELP_CalcMD5(&TempData, _BytesToRead)
    , VarSetCapacity(TempData, _BytesToRead, 0)
    , VarSetCapacity(TempData, 0)
    
    , ELP_SetFilePointer(_Handle, Current_FilePointer)
    
    If (VarHash != FileHash)    
        ErrorLevel := -101
}

ELP_GetPathFromHandle(_Handle)
{
    Global Ptr
    Static Old_OperatingSystems := "WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_2000,WIN_2003,WIN_XP"
    
    If (InStr("," . Old_OperatingSystems . ",", "," . A_OSVersion . ",")) ;Requires Vista/Server 2008 or later
        Return -1
    
    CallName := A_IsUnicode ? "Kernel32.dll\GetFinalPathNameByHandleW" : "Kernel32.dll\GetFinalPathNameByHandleA"
    , PathLength := DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", 0, "UInt", 0)
    , VarSetCapacity(FileName, PathLength * 2, 0)
    , DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", PathLength * 2, "UInt", 0)
    , VarSetCapacity(FileName, -1)
    
    Return FileName
}

ELP_GetPathRoot(_FileName)
{
    If (SubStr(_FileName, 2, 2) = ":\") ;Local file
        I := 3
    Else If (SubStr(_FileName, 1, 9) = "\\?\UNC\\"){ ;Long network path
        P := InStr(_FileName, "\", False, 10) + 2
        If (SubStr(_FileName, P, 2) = "$\") ;Long admin network share
            I := P + 1
        Else ;Long normal network share
            I := InStr(_FileName, "\", False, P + 2)
    } Else If (SubStr(_FileName, 1, 4) = "\\?\") ;Long local path
        I := 7
    Else If (SubStr(_FileName, 1, 2) = "\\") ;Network path
        I := InStr(_FileName, "\", False, InStr(_FileName, "\", False, 3) + 1)
    Else
        Return
    
    Return SubStr(_FileName, 1, I)
}

ELP_FileCreateDirectory(_Directory, _CreateParents = 1)
{
    Global Ptr
    Static ERROR_ALREADY_EXISTS := 183
    
    __Directory := _Directory
    , ELP_ConvertPath(__Directory)
    , E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
    
    If (E Or A_LastError = ERROR_ALREADY_EXISTS) ;Directory already exists != critical error
        ErrorLevel := 0
    Else If (_CreateParents){
        If (SubStr(_Directory, 0) != "\")
            _Directory .= "\"
        
        Part_Length := StrLen(ELP_GetPathRoot(_Directory))
        , I := StrLen(_Directory)
        
        While (Part_Length < I){
            Part_Length := InStr(_Directory, "\", False, Part_Length + 1)
            , __Directory :=  SubStr(_Directory, 1, Part_Length)
            , ELP_ConvertPath(__Directory)
            , E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
        }
        
        If (E Or A_LastError = ERROR_ALREADY_EXISTS)
            ErrorLevel := 0
        Else
            ErrorLevel := 1
    }
    
    Return ErrorLevel
}

ELP_CalcMD5(_VarAddress, _VarSize)
{
    Global Ptr
    Static Hex = "123456789ABCDEF0"
    
    VarSetCapacity(MD5_CTX, 104, 0)
    , DllCall("advapi32\MD5Init", Ptr, &MD5_CTX)
    , DllCall("advapi32\MD5Update", Ptr, &MD5_CTX, Ptr, _VarAddress, "UInt", _VarSize)
    , DllCall("advapi32\MD5Final", Ptr, &MD5_CTX)
    
    Loop,16
        MD5 .= NumGet(MD5_CTX, 87 + A_Index, "UChar")
    ;N := NumGet(MD5_CTX, 87 + A_Index, "Char"), MD5 .= SubStr(Hex, N >> 4, 1) . SubStr(Hex, N & 15, 1)
    
    Return MD5
}

ELP_ConvertPath(ByRef _String)
{
    Global Ptr
    
    If (SubStr(_String, 1, 4) != "\\?\"){
        If (SubStr(_String, 1, 2) = "\\")
            String_C := "\\?\UNC\" . SubStr(_String, 3)
        Else
            String_C := "\\?\" . _String
    } Else
        String_C := _String
    
    If (A_IsUnicode){
        _String := String_C
        Return
    } Else {
        CodePage := DllCall("GetACP")
        , Size := DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, 0, "Int", 0)
        , VarSetCapacity(_String, 2 * Size, 0)
        , DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, &_String, "Int", Size)
    }
}

ELP_StoreBytes(_Cmd, _V = 0)
{
    Static BW := 0, BR := 0
    
    If (_Cmd = "AddRead")
        BR += _V
    Else If (_Cmd = "AddWrite")
        BW += _V
    Else If (_Cmd = "GetRead")
        Return BR
    Else If (_Cmd = "GetWrite")
        Return BW
    Else If (_Cmd = "ResetRead")
        BR := 0
    Else If (_Cmd = "ResetWrite")
        BW := 0
}

ELP_MasterSettings(_Cmd, _Value, _NewValue = "")
{
    Static Verify_Writes :=  False
    , Verify_Reads := False
    , Count_BytesWritten := False
    , Count_BytesRead := False
    , Version := 1.2
    
    If (_Cmd = "Get"){
        If (_Value = "Verify_Writes"){
            Return Verify_Writes
        } Else If (_Value = "Verify_Reads"){
            Return Verify_Reads
        } Else If (_Value = "Count_BytesWritten"){
            Return Count_BytesWritten
        } Else If (_Value = "Count_bytesRead"){
            Return Count_bytesRead
        } Else If (_Value = "Version"){
            Return Version
        }
    } Else If (_Cmd = "Set"){
        If (_Value = "Verify_Writes"){
            Verify_Writes := _NewValue
        } Else If (_Value = "Verify_Reads"){
            Verify_Reads := _NewValue
        } Else If (_Value = "Count_BytesWritten"){
            Count_BytesWritten := _NewValue
        } Else If (_Value = "Count_bytesRead"){
            Count_bytesRead := _NewValue
        }
    }
}

;**********************************
; End file i/o functions
;**********************************

ScreenSizesClose:
ScreenSizesEscape:
    Waiting_ForMonSizeGui := 2
Return

ScreenSizesOk:
    Waiting_ForMonSizeGui := False
Return

AutosaveIntervalOK:
    Get_AutosaveInterval("Calculate")
Return

AutosaveIntervalClose:
AutosaveIntervalEscape:
    Get_AutosaveInterval("Destroy")
Return

RamUseOk:
    Get_RamUse("Calculate")
Return

RamUseClose:
RamUseEscape:
    Get_RamUse("Destroy")
Return

MenuHandler:
    MenuHandler(A_ThisMenuItem)
Return

UpdateToolTip:
    UpdateToolTip()
Return

RemoveTrayTip:
    TrayTip
Return

MonitorMouseMovement:
    If (!MonitorMouseMovement())
        SetTimer, MonitorMouseMovement, -1
Return

AutoSave:
    If (Save_DataMethod = 2){
        If (!CountPixelsMoved)
            Return
        Else
            SavePixelData()
    } Else If (Save_DataMethod = 1)
        Save_AllData()
Return

ExitSub:
    Menu, Tray, NoIcon
    
    If (SkipExitSub)
        ExitApp
    Else {
        If (Save_DataMethod = 1)
            Save_AllData(1)
        Else If (Save_DataMethod = 2){
            Close_FileHandles()
            , SavePixelData(1)
        }
        
        Write_HDActivity()
        
        ExitApp
    }
Return







/*
************************************
 --------------Hotkeys--------------
************************************
*/

*~LShift::
    If (!LShift_S)
        KP(300001)
    LShift_S := 1
Return

*~RShift::
    If (!RShift_S)
        KP(300002)
    RShift_S := 1
Return

*~LCtrl Up::KP(300003)
~RCtrl Up::KP(300004)
*~LAlt Up::KP(300005)
*~RAlt Up::KP(300006)


*~CapsLock::
    If (!KS350001)
        KP(350001), KS350001 := 1, CapsLock_S := GetKeyState("CapsLock", "T")
Return

*~NumLock::
    If (!KS350002)
        KP(350002), KS350002 := 1, NumLock_State := GetKeyState("NumLock", "T")
Return

*~Insert::
    If (!KS350003)
        KP(350003), KS350003 := 1, Insert_State := GetKeyState("Insert", "T")
Return

*~ScrollLock::
    If (!KS350004)
        KP(350004), KS350004 := 1, ScrollLock_State := GetKeyState("ScrollLock", "T")
Return


*~LShift Up::LShift_S := 0
*~RShift Up::RShift_S := 0
*~CapsLock Up::KS350001 := 0
*~NumLock Up::KS350002 := 0
*~Insert Up::KS350003 := 0
*~ScrollLock Up::KS350004 := 0

*~A::
    If (!KS50001){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100001)
        Else
            KP(50001)
        KS50001 := 1
    }
Return

*~B::
    If (!KS50002){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100002)
        Else
            KP(50002)
        KS50002 := 1
    }
Return

*~C::
    If (!KS50003){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100003)
        Else
            KP(50003)
        KS50003 := 1
    }
Return

*~D::
    If (!KS50004){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100004)
        Else
            KP(50004)
        KS50004 := 1
    }
Return

*~E::
    If (!KS50005){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100005)
        Else
            KP(50005)
        KS50005 := 1
    }
Return

*~F::
    If (!KS50006){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100006)
        Else
            KP(50006)
        KS50006 := 1
    }
Return

*~G::
    If (!KS50007){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100007)
        Else
            KP(50007)
        KS50007 := 1
    }
Return

*~H::
    If (!KS50008){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100008)
        Else
            KP(50008)
        KS50008 := 1
    }
Return

*~I::
    If (!KS50009){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100009)
        Else
            KP(50009)
        KS50009 := 1
    }
Return

*~J::
    If (!KS50010){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100010)
        Else
            KP(50010)
        KS50010 := 1
    }
Return

*~K::
    If (!KS50011){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100011)
        Else
            KP(50011)
        KS50011 := 1
    }
Return

*~L::
    If (!KS50012){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100012)
        Else
            KP(50012)
        KS50012 := 1
    }
Return

*~M::
    If (!KS50013){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100013)
        Else
            KP(50013)
        KS50013 := 1
    }
Return

*~N::
    If (!KS50014){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100014)
        Else
            KP(50014)
        KS50014 := 1
    }
Return

*~O::
    If (!KS50015){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100015)
        Else
            KP(50015)
        KS50015 := 1
    }
Return

*~P::
    If (!KS50016){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100016)
        Else
            KP(50016)
        KS50016 := 1
    }
Return

*~Q::
    If (!KS50017){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100017)
        Else
            KP(50017)
        KS50017 := 1
    }
Return

*~R::
    If (!KS50018){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100018)
        Else
            KP(50018)
        KS50018 := 1
    }
Return

*~S::
    If (!KS50019){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100019)
        Else
            KP(50019)
        KS50019 := 1
    }
Return

*~T::
    If (!KS50020){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100020)
        Else
            KP(50020)
        KS50020 := 1
    }
Return

*~U::
    If (!KS50021){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100021)
        Else
            KP(50021)
        KS50021 := 1
    }
Return

*~V::
    If (!KS50022){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100022)
        Else
            KP(50022)
        KS50022 := 1
    }
Return

*~W::
    If (!KS50023){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100023)
        Else
            KP(50023)
        KS50023 := 1
    }
Return

*~X::
    If (!KS50024){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100024)
        Else
            KP(50024)
        KS50024 := 1
    }
Return

*~Y::
    If (!KS50025){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100025)
        Else
            KP(50025)
        KS50025 := 1
    }
Return

*~Z::
    If (!KS50026){
        If (LShift_S Or RShift_S Or CapsLock_S)
            KP(100026)
        Else
            KP(50026)
        KS50026 := 1
    }
Return



*~0::
    If (!KS150001){
        If (LShift_S Or RShift_S)
            KP(200012)
        Else
            KP(150001)
        KS150001 := 1
    }
Return

*~1::
    If (!KS150002){
        If (LShift_S Or RShift_S)
            KP(200003)
        Else
            KP(150002)
        KS150002 := 1
    }
Return

*~2::
    If (!KS150003){
        If (LShift_S Or RShift_S)
            KP(200004)
        Else
            KP(150003)
        KS150003 := 1
    }
Return

*~3::
    If (!KS150004){
        If (LShift_S Or RShift_S)
            KP(200005)
        Else
            KP(150004)
        KS150004 := 1
    }
Return

*~4::
    If (!KS150005){
        If (LShift_S Or RShift_S)
            KP(200006)
        Else
            KP(150005)
        KS150005 := 1
    }
Return

*~5::
    If (!KS150006){
        If (LShift_S Or RShift_S)
            KP(200007)
        Else
            KP(150006)
        KS150006 := 1
    }
Return

*~6::
    If (!KS150007){
        If (LShift_S Or RShift_S)
            KP(200008)
        Else
            KP(150007)
        KS150007 := 1
    }
Return

*~7::
    If (!KS150008){
        If (LShift_S Or RShift_S)
            KP(200009)
        Else
            KP(150008)
        KS150008 := 1
    }
Return

*~8::
    If (!KS150009){
        If (LShift_S Or RShift_S)
            KP(200010)
        Else
            KP(150009)
        KS150009 := 1
    }
Return

*~9::
    If (!KS150010){
        If (LShift_S Or RShift_S)
            KP(200011)
        Else
            KP(150010)
        KS150010 := 1
    }
Return


*~A Up::KS50001 := 0
*~B Up::KS50002 := 0
*~C Up::KS50003 := 0
*~D Up::KS50004 := 0
*~E Up::KS50005 := 0
*~F Up::KS50006 := 0
*~G Up::KS50007 := 0
*~H Up::KS50008 := 0
*~I Up::KS50009 := 0
*~J Up::KS50010 := 0
*~K Up::KS50011 := 0
*~L Up::KS50012 := 0
*~M Up::KS50013 := 0
*~N Up::KS50014 := 0
*~O Up::KS50015 := 0
*~P Up::KS50016 := 0
*~Q Up::KS50017 := 0
*~R Up::KS50018 := 0
*~S Up::KS50019 := 0
*~T Up::KS50020 := 0
*~U Up::KS50021 := 0
*~V Up::KS50022 := 0
*~W Up::KS50023 := 0
*~X Up::KS50024 := 0
*~Y Up::KS50025 := 0
*~Z Up::KS50026 := 0

*~0 Up::KS150001 := 0
*~1 Up::KS150002 := 0
*~2 Up::KS150003 := 0
*~3 Up::KS150004 := 0
*~4 Up::KS150005 := 0
*~5 Up::KS150006 := 0
*~6 Up::KS150007 := 0
*~7 Up::KS150008 := 0
*~8 Up::KS150009 := 0
*~9 Up::KS150010 := 0


*~F1 Up::KP(250001)
*~F2 Up::KP(250002)
*~F3 Up::KP(250003)
*~F4 Up::KP(250004)
*~F5 Up::KP(250005)
*~F6 Up::KP(250006)
*~F7 Up::KP(250007)
*~F8 Up::KP(250008)
*~F9 Up::KP(250009)
*~F10 Up::KP(250010)
*~F11 Up::KP(250011)
*~F12 Up::KP(250012)
*~F13 Up::KP(250013)
*~F14 Up::KP(250014)
*~F15 Up::KP(250015)
*~F16 Up::KP(250016)
*~F17 Up::KP(250017)
*~F18 Up::KP(250018)
*~F19 Up::KP(250019)
*~F20 Up::KP(250020)
*~F21 Up::KP(250021)
*~F22 Up::KP(250022)
*~F23 Up::KP(250023)
*~F24 Up::KP(250024)


*~AppsKey Up::KP(400001)
*~Tab Up::KP(400002)
*~Help Up::KP(400003)
*~Sleep Up::KP(400004)
*~PrintScreen Up::KP(400005)
*~Pause Up::KP(400006)
*~Home Up::KP(400007)
*~PgUp Up::KP(400008)
*~PgDn Up::KP(400009)
*~Delete Up::KP(400010)
*~End Up::KP(400011)
*~Left Up::KP(400012)
*~Up Up::KP(400013)
*~Right Up::KP(400014)
*~Down Up::KP(400015)

*~LWin::
    KP(400016)
    While GetKeyState("LWin", "P")
        Sleep, 10
Return
*~RWin::
    KP("400017")
    While GetKeyState("RWin", "P")
        Sleep, 10
Return

*~Escape Up::KP(400018)
*~BackSpace Up::KP(400019)
*~Space Up::KP(400020)
*~Enter Up::KP(400021)


*~Numpad0 Up::KP(450001)
*~Numpad1 Up::KP(450002)
*~Numpad2 Up::KP(450003)
*~Numpad3 Up::KP(450004)
*~Numpad4 Up::KP(450005)
*~Numpad5 Up::KP(450006)
*~Numpad6 Up::KP(450007)
*~Numpad7 Up::KP(450008)
*~Numpad8 Up::KP(450009)
*~Numpad9 Up::KP(450010)

*~NumpadDot Up::KP(500001)
*~NumpadEnter Up::KP(500002)
*~NumpadAdd Up::KP(500003)
*~NumpadSub Up::KP(500004)
*~NumpadMult Up::KP(500005)
*~NumpadDiv Up::KP(500006)
*~NumpadIns Up::KP(500007)
*~NumpadEnd Up::KP(500008)
*~NumpadHome Up::KP(500009)
*~NumpadPgDn Up::KP(500010)
*~NumpadPgUp Up::KP(500011)
*~NumpadClear Up::KP(500012)
*~NumpadDel Up::KP(500013)
*~NumpadLeft Up::KP(500014)
*~NumpadUp Up::KP(500015)
*~NumpadRight Up::KP(500016)
*~NumpadDown Up::KP(500017)


*~Browser_Back Up::KP(550001)
*~Browser_Forward Up::KP(550002)
*~Browser_Refresh Up::KP(550003)
*~Browser_Stop Up::KP(550004)
*~Browser_Search Up::KP(550005)
*~Browser_Favorites Up::KP(550006)
*~Browser_Home Up::KP(550007)
*~Volume_Mute::KP(550008)
*~Volume_Down::KP(550009)
*~Volume_Up::KP(550010)
*~Media_Next::KP(550011)
*~Media_Prev::KP(550012)
*~Media_Stop::KP(550013)
*~Media_Play_Pause::KP(550014)
*~Launch_Mail::KP(550015)
*~Launch_Media::KP(550016)
*~Launch_App1::KP(550017)
*~Launch_App2::KP(550018)





*~`::
    If (!KS200001){
        If (LShift_S Or RShift_S)
            KP(200002)
        Else
            KP(200001)
        KS200001 := 1
    }
Return

*~-::
    If (!KS200013){
        If (LShift_S Or RShift_S)
            KP(200014)
        Else
            KP(200013)
        KS200013 := 1
    }
Return

*~=::
    If (!KS200015){
        If (LShift_S Or RShift_S)
            KP(200016)
        Else
            KP(200015)
        KS200015 := 1
    }
Return

*~[::
    If (!KS200017){
        If (LShift_S Or RShift_S)
            KP(200018)
        Else
            KP(200017)
        KS200017 := 1
    }
Return

*~]::
    If (!KS200019){
        If (LShift_S Or RShift_S)
            KP(200020)
        Else
            KP(200019)
        KS200019 := 1
    }
Return

*~\::
    If (!KS200021){
        If (LShift_S Or RShift_S)
            KP(200022)
        Else
            KP(200021)
        KS200021 := 1
    }
Return

*~`;::
    If (!KS200023){
        If (LShift_S Or RShift_S)
            KP(200024)
        Else
            KP(200023)
        KS200023 := 1
    }
Return

*~'::
    If (!KS200025){
        If (LShift_S Or RShift_S)
            KP(200026)
        Else
            KP(200025)
        KS200025 := 1
    }
Return

*~,::
    If (!KS200027){
        If (LShift_S Or RShift_S)
            KP(200028)
        Else
            KP(200027)
        KS200027 := 1
    }
Return

*~.::
    If (!KS200029){
        If (LShift_S Or RShift_S)
            KP(200030)
        Else
            KP(200029)
        KS200029 := 1
    }
Return

*~/::
    If (!KS200031){
        If (LShift_S Or RShift_S)
            KP(200032)
        Else
            KP(200031)
        KS200031 := 1
    }
Return


*~` Up::KS200001 := 0
*~- Up::KS200013 := 0
*~= Up::KS200015 := 0
*~[ Up::KS200017 := 0
*~] Up::KS200019 := 0
*~\ Up::KS200021 := 0
*~`; Up::KS200023 := 0
*~' Up::KS200025 := 0
*~, Up::KS200027 := 0
*~. Up::KS200029 := 0
*~/ Up::KS200031 := 0

*~LButton::KP(600001)
*~RButton::KP(600002)
*~MButton::KP(600003)
*~XButton1::KP(600004)
*~XButton2::KP(600005)
*~WheelUp::KP(600006)
*~WheelDown::KP(600007)