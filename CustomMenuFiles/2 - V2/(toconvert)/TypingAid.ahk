;ONFIGURATIONS 

#NoTrayIcon
;disable hotkeys until setup is complete
Suspend, On 
#NoEnv
ListLines Off
g_OSVersion := GetOSVersion()
;Set the Coordinate Modes before any threads can be executed
CoordMode, Caret, Screen
CoordMode, Mouse, Screen
SetBatchLines, 20ms
OnExit, SaveScript
SetTitleMatchMode, 2

;read in the preferences file
ReadPreferences()

EvaluateScriptPathAndTitle()
SuspendOn()
BuildTrayMenu()      



;set windows constants
g_EVENT_SYSTEM_FOREGROUND := 0x0003
g_EVENT_SYSTEM_SCROLLINGSTART := 0x0012
g_EVENT_SYSTEM_SCROLLINGEND := 0x0013
g_GCLP_HCURSOR := -12
g_IDC_HAND := 32649
g_IDC_HELP := 32651
g_IMAGE_CURSOR := 2
g_LR_SHARED := 0x8000
g_NormalizationKD := 0x6
g_NULL := 0
g_Process_DPI_Unaware := 0
g_Process_System_DPI_Aware  := 1
g_Process_Per_Monitor_DPI_Aware := 2
g_PROCESS_QUERY_INFORMATION := 0x0400
g_PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
g_SB_VERT := 0x1
g_SIF_POS := 0x4
g_SM_CMONITORS := 80
g_SM_CXVSCROLL := 2
g_SM_CXFOCUSBORDER := 83
g_WINEVENT_SKIPOWNPROCESS := 0x0002
g_WM_LBUTTONUP := 0x202
g_WM_LBUTTONDBLCLK := 0x203
g_WM_MOUSEMOVE := 0x200
g_WM_SETCURSOR := 0x20

;setup code
g_DpiScalingFactor := A_ScreenDPI/96
g_Helper_Id = 
g_HelperManual = 
g_DelimiterChar := Chr(2)
g_cursor_hand := DllCall( "LoadImage", "Ptr", g_NULL, "Uint", g_IDC_HAND , "Uint", g_IMAGE_CURSOR, "int", g_NULL, "int", g_NULL, "Uint", g_LR_SHARED ) 
if (A_PtrSize == 8) {
   g_SetClassLongFunction := "SetClassLongPtr"
} else {
   g_SetClassLongFunction := "SetClassLong"
}
g_PID := DllCall("GetCurrentProcessId")
AutoTrim, Off

msgbox, % "dll stuuff" g_cursor_hand "`n" g_PID 

InitializeListBox()

BlockInput, Send

InitializeHotKeys()

DisableKeyboardHotKeys()

;Change the Running performance speed (Priority changed to High in GetIncludedActiveWindow)
SetBatchLines, -1

;Read in the WordList
ReadWordList()

g_WinChangedCallback := RegisterCallback("WinChanged")
g_ListBoxScrollCallback := RegisterCallback("ListBoxScroll")

if !(g_WinChangedCallback)
{
   MsgBox, Failed to register callback function
   ExitApp
}

if !(g_ListBoxScrollCallback)
{
   MsgBox, Failed to register ListBox Scroll callback function
   ExitApp
}
   
;Find the ID of the window we are using
GetIncludedActiveWindow()

MainLoop()

; END

MainLoop(){
   global g_TerminatingEndKeys
   Loop 
   { 

      ;If the active window has changed, wait for a new one
      IF !( ReturnWinActive() ) 
      {
         Critical, Off
         GetIncludedActiveWindow()
      } else {    
         Critical, Off
      }
   
      ;Get one key at a time 
      Input, InputChar, L1 V I, {BS}%g_TerminatingEndKeys%
   
      Critical
      EndKey := ErrorLevel
   
      ProcessKey(InputChar,EndKey)
   }
}

ProcessKey(InputChar,EndKey){
   global g_Active_Id
   global g_Helper_Id
   global g_IgnoreSend
   global g_LastInput_Id
   global g_OldCaretX
   global g_OldCaretY
   global g_TerminatingCharactersParsed
   global g_Word
   global prefs_DetectMouseClickMove
   global prefs_EndWordCharacters
   global prefs_ForceNewWordCharacters
   global prefs_Length
   
   IfEqual, g_IgnoreSend, 1
   {
      g_IgnoreSend = 
      Return
   }

   IfEqual, EndKey,
   {
      EndKey = Max
   }
   
   IfEqual, EndKey, NewInput
      Return

   IfEqual, EndKey, Endkey:Tab
      If ( GetKeyState("Alt") =1 || GetKeyState("LWin") =1 || GetKeyState("RWin") =1 )
         Return
   
   ;If we have no window activated for typing, we don't want to do anything with the typed character
   IfEqual, g_Active_Id,
   {
      if (!GetIncludedActiveWindow())
      {
         Return
      }
   }


   IF !( ReturnWinActive() )
   {
      if (!GetIncludedActiveWindow())
      {
         Return
      }
   }
   
   IfEqual, g_Active_Id, %g_Helper_Id%
   {
      Return
   }
   
   ;If we haven't typed anywhere, set this as the last window typed in
   IfEqual, g_LastInput_Id,
      g_LastInput_Id = %g_Active_Id%
   
   IfNotEqual, prefs_DetectMouseClickMove, On
   {
      ifequal, g_OldCaretY,
         g_OldCaretY := HCaretY()
         
      if ( g_OldCaretY != HCaretY() )
      {
         ;Don't do anything if we aren't in the original window and aren't starting a new word
         IfNotEqual, g_LastInput_Id, %g_Active_Id%
            Return
            
         ; add the word if switching lines
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
         Return         
      } 
   }

   g_OldCaretY := HCaretY()
   g_OldCaretX := HCaretX()
   
   ;Backspace clears last letter 
   ifequal, EndKey, Endkey:BackSpace
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      IfNotEqual, g_LastInput_Id, %g_Active_Id%
         Return
      
      StringLen, len, g_Word
      IfEqual, len, 1   
      {
         ClearAllVars(true)
      } else IfNotEqual, len, 0
      {
         StringTrimRight, g_Word, g_Word, 1
      }
   } else if ( ( EndKey == "Max" ) && !(InStr(g_TerminatingCharactersParsed, InputChar)) )
   {
      ; If active window has different window ID from the last input,
      ;learn and blank word, then assign number pressed to the word
      IfNotEqual, g_LastInput_Id, %g_Active_Id%
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
         g_LastInput_Id := g_Active_Id
         Return
      }
   
      if InputChar in %prefs_ForceNewWordCharacters%
      {
         AddWordToList(g_Word,0)
         ClearAllVars(true)
         g_Word := InputChar
      } else if InputChar in %prefs_EndWordCharacters%
      {
         g_Word .= InputChar
         AddWordToList(g_Word, 1)
         ClearAllVars(true)
      } else { 
         g_Word .= InputChar
      }
      
   } else IfNotEqual, g_LastInput_Id, %g_Active_Id%
   {
      ;Don't do anything if we aren't in the original window and aren't starting a new word
      Return
   } else {
      AddWordToList(g_Word,0)
      ClearAllVars(true)
      Return
   }
   
   ;Wait till minimum letters 
   IF ( StrLen(g_Word) < prefs_Length )
   {
      CloseListBox()
      Return
   }
   SetTimer, RecomputeMatchesTimer, -1
}

RecomputeMatchesTimer:
   Thread, NoTimers
   RecomputeMatches()
   Return

RecomputeMatches(){
   ; This function will take the given word, and will recompile the list of matches and redisplay the wordlist.
   global g_MatchTotal
   global g_SingleMatch
   global g_SingleMatchDescription
   global g_SingleMatchReplacement
   global g_Word
   global g_WordListDB
   global prefs_ArrowKeyMethod
   global prefs_LearnMode
   global prefs_ListBoxRows
   global prefs_NoBackSpace
   global prefs_ShowLearnedFirst
   global prefs_SuppressMatchingWord
   
   SavePriorMatchPosition()

   ;Match part-word with command 
   g_MatchTotal = 0 
   
   IfEqual, prefs_ArrowKeyMethod, Off
   {
      IfLess, prefs_ListBoxRows, 10
         LimitTotalMatches := prefs_ListBoxRows
      else LimitTotalMatches = 10
   } else {
      LimitTotalMatches = 200
   }
   
   StringUpper, WordMatchOriginal, g_Word
   
   WordMatch := StrUnmark(WordMatchOriginal)
   
   StringUpper, WordMatch, WordMatch
   
   ; if a user typed an accented character, we should exact match on that accented character
   if (WordMatch != WordMatchOriginal) {
      WordAccentQuery =
      LoopCount := StrLen(g_Word)
      Loop, %LoopCount%
      {
         Position := A_Index
         SubChar := SubStr(g_Word, Position, 1)
         SubCharNormalized := StrUnmark(SubChar)
         if !(SubCharNormalized == SubChar) {
            StringUpper, SubCharUpper, SubChar
            StringLower, SubCharLower, SubChar
            StringReplace, SubCharUpperEscaped, SubCharUpper, ', '', All
            StringReplace, SubCharLowerEscaped, SubCharLower, ', '', All
            PrefixChars =
            Loop, % Position - 1
            {
               PrefixChars .= "?"
            }
            ; because SQLite cannot do case-insensitivity on accented characters using LIKE, we need
            ; to handle it manually, so we need 2 searches for each accented character the user typed.
            ;GLOB is used for consistency with the wordindexed search.
            WordAccentQuery .= " AND (word GLOB '" . PrefixChars . SubCharUpperEscaped . "*' OR word GLOB '" . PrefixChars . SubCharLowerEscaped . "*')"
         }         
      }
   } else {
      WordAccentQuery =
   }
   
   StringReplace, WordExactEscaped, g_Word, ', '', All
   StringReplace, WordMatchEscaped, WordMatch, ', '', All
   
   IfEqual, prefs_SuppressMatchingWord, On
   {
      IfEqual, prefs_NoBackSpace, Off
      {
         SuppressMatchingWordQuery := " AND word <> '" . WordExactEscaped . "'"
      } else {
               SuppressMatchingWordQuery := " AND wordindexed <> '" . WordMatchEscaped . "'"
            }
   }
   
   WhereQuery := " WHERE wordindexed GLOB '" . WordMatchEscaped . "*' " . SuppressMatchingWordQuery . WordAccentQuery
   
   NormalizeTable := g_WordListDB.Query("SELECT MIN(count) AS normalize FROM Words" . WhereQuery . "AND count IS NOT NULL LIMIT " . LimitTotalMatches . ";")
   
   for each, row in NormalizeTable.Rows
   {
      Normalize := row[1]
   }
      
   IfEqual, Normalize,
   {
      Normalize := 0
   }
      
   WordLen := StrLen(g_Word)
   OrderByQuery := " ORDER BY CASE WHEN count IS NULL then "
   IfEqual, prefs_ShowLearnedFirst, On
   {
      OrderByQuery .= "ROWID + 1 else 0"
   } else {
      OrderByQuery .= "ROWID else 'z'"
   }
   
   OrderByQuery .= " end, CASE WHEN count IS NOT NULL then ( (count - " . Normalize . ") * ( 1 - ( '0.75' / (LENGTH(word) - " . WordLen . ")))) end DESC, Word"
      
   Matches := g_WordListDB.Query("SELECT word, worddescription, wordreplacement FROM Words" . WhereQuery . OrderByQuery . " LIMIT " . LimitTotalMatches . ";")
   
   g_SingleMatch := Object()
   g_SingleMatchDescription := Object()
   g_SingleMatchReplacement := Object()
   
   for each, row in Matches.Rows
   {      
      g_SingleMatch[++g_MatchTotal] := row[1]
      g_SingleMatchDescription[g_MatchTotal] := row[2]
      g_SingleMatchReplacement[g_MatchTotal] := row[3]
      
      continue
   }
   
   ;If no match then clear Tip 
   IfEqual, g_MatchTotal, 0
   {
      ClearAllVars(false)
      Return 
   } 
   
   SetupMatchPosition()
   RebuildMatchList()
   ShowListBox()
}

;------------------------------------------------------------------------

~LButton:: 
CheckForCaretMove("LButton","UpdatePosition")
return
   

;------------------------------------------------------------------------

~RButton:: 
CheckForCaretMove("RButton","UpdatePosition")
Return

;------------------------------------------------------------------------
F1::
    CoordMode Menu, Screen
    GetCaret(X, Y,, H)
    Menu, MyMenu, Add, Menu Item 1, MenuHandler1
    Menu, MyMenu, Add, Menu Item 2, MenuHandler2
    Menu, MyMenu, Add, Menu Item 3, MenuHandler3
    Menu, MyMenu, Show, % X, % Y + H
Return

MenuHandler1:
GetCaret(X, Y,, H)
;InputBox, test
;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
InputBox, omniinput, ,,, , , % x, % y ,Consolas, 10000,g 
StringLeft, checkvar, omniINPUT, 1
msgbox, % omniinput
StringTrimleft, omniinput, omniinput,1
msgboX, % checkvar "-" omniinput
clipboard := omniinput
switch checkvar
{
   case "g":
   clipboard := omniinput
   runstring("www.google.com/search?q=" . clipboard)
   return
   case "f":
   msgbox, % "return"
   return
   case "c":
   msgbox, % "return"
   return
   case "m":
   msgbox, % "return"
   return
   ;filesearch(frontfolder)
}
runstring(string_path){
run, % string_path
}

readomni(omniinput)
Return

MenuHandler2:

Return
MenuHandler3:
    ; do something
Return

readomni(omniinput){
   StrSplit(omniinput, a_space ," ")
   for k,v in omniinput
   msgbox, % v
}


GetCaret(ByRef X:="", ByRef Y:="", ByRef W:="", ByRef H:="") {

    ; UIA caret
    static IUIA := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
    ; GetFocusedElement
    DllCall(NumGet(NumGet(IUIA+0)+8*A_PtrSize), "ptr", IUIA, "ptr*", FocusedEl:=0)
    ; GetCurrentPattern. TextPatternElement2 = 10024
    DllCall(NumGet(NumGet(FocusedEl+0)+16*A_PtrSize), "ptr", FocusedEl, "int", 10024, "ptr*", patternObject:=0), ObjRelease(FocusedEl)
    if patternObject {
        ; GetCaretRange
        DllCall(NumGet(NumGet(patternObject+0)+10*A_PtrSize), "ptr", patternObject, "int*", IsActive:=1, "ptr*", caretRange:=0), ObjRelease(patternObject)
        ; GetBoundingRectangles
        DllCall(NumGet(NumGet(caretRange+0)+10*A_PtrSize), "ptr", caretRange, "ptr*", boundingRects:=0), ObjRelease(caretRange)
        ; VT_ARRAY = 0x20000 | VT_R8 = 5 (64-bit floating-point number)
        Rect := ComObject(0x2005, boundingRects)
        if (Rect.MaxIndex() = 3) {
            X:=Round(Rect[0]), Y:=Round(Rect[1]), W:=Round(Rect[2]), H:=Round(Rect[3])
            return
        }
    }

    ; Acc caret
    static _ := DllCall("LoadLibrary", "Str","oleacc", "Ptr")
    idObject := 0xFFFFFFF8 ; OBJID_CARET
    if DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", WinExist("A"), "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc:=0)=0 {
        oAcc := ComObjEnwrap(9,pacc,1)
        oAcc.accLocation(ComObj(0x4003,&_x:=0), ComObj(0x4003,&_y:=0), ComObj(0x4003,&_w:=0), ComObj(0x4003,&_h:=0), 0)
        X:=NumGet(_x,0,"int"), Y:=NumGet(_y,0,"int"), W:=NumGet(_w,0,"int"), H:=NumGet(_h,0,"int")
        if (X | Y) != 0
            return
    }

    ; default caret
    CoordMode Caret, Screen
    X := A_CaretX
    Y := A_CaretY
    W := 4
    H := 20
}

CheckForCaretMove(MouseButtonClick, UpdatePosition = false){
   global g_LastInput_Id
   global g_MouseWin_Id
   global g_OldCaretX
   global g_OldCaretY
   global g_Word
   global prefs_DetectMouseClickMove
   
   ;If we aren't using the DetectMouseClickMoveScheme, skip out
   IfNotEqual, prefs_DetectMouseClickMove, On
      Return
   
   if (UpdatePosition)
   {
      ; Update last click position in case Caret is not detectable
      ;  and update the Last Window Clicked in
      MouseGetPos, MouseX, MouseY, g_MouseWin_Id
      WinGetPos, ,TempY, , , ahk_id %g_MouseWin_Id%
   }
   
   IfEqual, MouseButtonClick, LButton
   {
      KeyWait, LButton, U    
   } else KeyWait, RButton, U
   
   IfNotEqual, g_LastInput_Id, %g_MouseWin_Id%
   {
      Return
   }
   
   SysGet, SM_CYCAPTION, 4
   SysGet, SM_CYSIZEFRAME, 33
   
   TempY += SM_CYSIZEFRAME
   IF ( ( MouseY >= TempY ) && (MouseY < (TempY + SM_CYCAPTION) ) )
   {
      Return
   }
   
   ; If we have a g_Word and an g_OldCaretX, check to see if the Caret moved
   IfNotEqual, g_OldCaretX, 
   {
      IfNotEqual, g_Word, 
      {
         if (( g_OldCaretY != HCaretY() ) || (g_OldCaretX != HCaretX() ))
         {
            ; add the word if switching lines
            AddWordToList(g_Word,0)
            ClearAllVars(true)
         }
      }
   }

   Return
}
   
   
;------------------------------------------------------------------------

InitializeHotKeys(){
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_LearnMode  
   
   g_EnabledKeyboardHotKeys =

   ;Setup toggle-able hotkeys

   ;Can't disable mouse buttons as we need to check to see if we have clicked the ListBox window


   ; If we disable the number keys they never get to the input for some reason,
   ; so we need to keep them enabled as hotkeys

   IfNotEqual, prefs_LearnMode, On
   {
      Hotkey, $^+Delete, Off
   } else {
      Hotkey, $^+Delete, Off
      ; We only want Ctrl-Shift-Delete enabled when the listbox is showing.
      g_EnabledKeyboardHotKeys .= "$^+Delete" . g_DelimiterChar
   }
   
   HotKey, $^+c, On
   
   IfEqual, prefs_ArrowKeyMethod, Off
   {
      Hotkey, $^Enter, Off
      Hotkey, $^Space, Off
      Hotkey, $Tab, Off
      Hotkey, $Right, Off
      Hotkey, $Up, Off
      Hotkey, $Down, Off
      Hotkey, $PgUp, Off
      Hotkey, $PgDn, Off
      HotKey, $Enter, Off
      Hotkey, $NumpadEnter, Off
   } else {
      g_EnabledKeyboardHotKeys .= "$Up" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$Down" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgUp" . g_DelimiterChar
      g_EnabledKeyboardHotKeys .= "$PgDn" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains E
         Hotkey, $^Enter, Off
      else g_EnabledKeyboardHotKeys .= "$^Enter" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains S
         HotKey, $^Space, Off
      else g_EnabledKeyboardHotKeys .= "$^Space" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains T
         HotKey, $Tab, Off
      else g_EnabledKeyboardHotKeys .= "$Tab" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains R
         HotKey, $Right, Off
      else g_EnabledKeyboardHotKeys .= "$Right" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains U
         HotKey, $Enter, Off
      else g_EnabledKeyboardHotKeys .= "$Enter" . g_DelimiterChar
      If prefs_DisabledAutoCompleteKeys contains M
         HotKey, $NumpadEnter, Off
      else g_EnabledKeyboardHotKeys .= "$NumpadEnter" . g_DelimiterChar
   }

   ; remove last ascii 2
   StringTrimRight, g_EnabledKeyboardHotKeys, g_EnabledKeyboardHotKeys, 1
   
}

EnableKeyboardHotKeys(){
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   Loop, Parse, g_EnabledKeyboardHotKeys, %g_DelimiterChar%
   {
      HotKey, %A_LoopField%, On
   }
   Return
}

DisableKeyboardHotKeys(){
   global g_DelimiterChar
   global g_EnabledKeyboardHotKeys
   Loop, Parse, g_EnabledKeyboardHotKeys, %g_DelimiterChar%
   {
      HotKey, %A_LoopField%, Off
   }
   Return
}
   
;------------------------------------------------------------------------

#MaxThreadsPerHotkey 1 
    
$1:: 
$2:: 
$3:: 
$4:: 
$5:: 
$6:: 
$7:: 
$8:: 
$9:: 
$0::
CheckWord(A_ThisHotkey)
Return

$^Enter::
$^Space::
$Tab::
$Up::
$Down::
$PgUp::
$PgDn::
$Right::
$Enter::
$NumpadEnter::
EvaluateUpDown(A_ThisHotKey)
Return

$^+h::
MaybeOpenOrCloseHelperWindowManual()
Return

$^+c:: 
AddSelectedWordToList()
Return

$^+Delete::
DeleteSelectedWordFromList()
Return

;------------------------------------------------------------------------

; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed 
CheckWord(Key){
   global g_ListBox_Id
   global g_Match
   global g_MatchStart
   global g_NumKeyMethod
   global g_SingleMatch
   global g_Word
   global prefs_ListBoxRows
   global prefs_NumPresses
   
   StringRight, Key, Key, 1 ;Grab just the number pushed, trim off the "$"
   
   IfEqual, Key, 0
   {
      WordIndex := g_MatchStart + 9
   } else {
            WordIndex := g_MatchStart - 1 + Key
         }  
   
   IfEqual, g_NumKeyMethod, Off
   {
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      Return
   }
   
   IfEqual, prefs_NumPresses, 2
      SuspendOn()

   ; If active window has different window ID from before the input, blank word 
   ; (well, assign the number pressed to the word) 
   if !(ReturnWinActive())
   { 
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return 
   } 
   
   if ReturnLineWrong() ;Make sure we are still on the same line
   { 
      SendCompatible(Key,0)
      ProcessKey(Key,"") 
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return 
   } 

   IfNotEqual, g_Match, 
   {
      ifequal, g_ListBox_Id,        ; only continue if match is not empty and list is showing
      { 
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         IfEqual, prefs_NumPresses, 2
            SuspendOff()
         Return 
      }
   }

   ifequal, g_Word,        ; only continue if g_word is not empty 
   { 
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return 
   }
      
   if ( ( (WordIndex + 1 - MatchStart) > prefs_ListBoxRows) || ( g_Match = "" ) || (g_SingleMatch[WordIndex] = "") )   ; only continue g_SingleMatch is not empty 
   { 
      SendCompatible(Key,0)
      ProcessKey(Key,"")
      IfEqual, prefs_NumPresses, 2
         SuspendOff()
      Return 
   }

   IfEqual, prefs_NumPresses, 2
   {
      Input, KeyAgain, L1 I T0.5, 1234567890
      
      ; If there is a timeout, abort replacement, send key and return
      IfEqual, ErrorLevel, Timeout
      {
         SendCompatible(Key,0)
         ProcessKey(Key,"")
         SuspendOff()
         Return
      }

      ; Make sure it's an EndKey, otherwise abort replacement, send key and return
      IfNotInString, ErrorLevel, EndKey:
      {
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }
   
      ; If the 2nd key is NOT the same 1st trigger key, abort replacement and send keys   
      IfNotInString, ErrorLevel, %Key%
      {
         StringTrimLeft, KeyAgain, ErrorLevel, 7
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return
      }

      ; If active window has different window ID from before the input, blank word 
      ; (well, assign the number pressed to the word) 
      if !(ReturnWinActive())
      { 
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return 
      } 
   
      if ReturnLineWrong() ;Make sure we are still on the same line
      { 
         SendCompatible(Key . KeyAgain,0)
         ProcessKey(Key,"")
         ProcessKey(KeyAgain,"")
         SuspendOff()
         Return 
      } 
   }

   SendWord(WordIndex)
   IfEqual, prefs_NumPresses, 2
      SuspendOff()
   Return 
}

;------------------------------------------------------------------------

;If a hotkey related to the up/down arrows was pressed
EvaluateUpDown(Key){
   global g_ListBox_Id
   global g_Match
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OriginalMatchStart
   global g_SingleMatch
   global g_Word
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_ListBoxRows
   
   IfEqual, prefs_ArrowKeyMethod, Off
   {
      if (Key != "$LButton")
      {
         SendKey(Key)
         Return
      }
   }
   
   IfEqual, g_Match,
   {
      SendKey(Key)
      Return
   }

   IfEqual, g_ListBox_Id,
   {
      SendKey(Key)
      Return
   }

   if !(ReturnWinActive())
   {
      SendKey(Key)
      ClearAllVars(false)
      Return
   }

   if ReturnLineWrong()
   {
      SendKey(Key)
      ClearAllVars(true)
      Return
   }   
   
   IfEqual, g_Word, ; only continue if word is not empty
   {
      SendKey(Key)
      ClearAllVars(false)
      Return
   }
   
   if ( ( Key = "$^Enter" ) || ( Key = "$Tab" ) || ( Key = "$^Space" ) || ( Key = "$Right") || ( Key = "$Enter") || ( Key = "$LButton") || ( Key = "$NumpadEnter") )
   {
      IfEqual, Key, $^Enter
      {
         KeyTest = E
      } else IfEqual, Key, $Tab
      {
         KeyTest = T
      } else IfEqual, Key, $^Space
      {   
         KeyTest = S 
      } else IfEqual, Key, $Right
      {
         KeyTest = R
      } else IfEqual, Key, $Enter
      {
         KeyTest = U
      } else IfEqual, Key, $LButton
      {
         KeyTest = L
      } else IfEqual, Key, $NumpadEnter
      {
         KeyTest = M
      }
      
      if (KeyTest == "L") {
         ;when hitting LButton, we've already handled this condition         
      } else if prefs_DisabledAutoCompleteKeys contains %KeyTest%
      {
         SendKey(Key)
         Return     
      }
      
      if (g_SingleMatch[g_MatchPos] = "") ;only continue if g_SingleMatch is not empty
      {
         SendKey(Key)
         g_MatchPos := g_MatchTotal
         RebuildMatchList()
         ShowListBox()
         Return
      }
      
      SendWord(g_MatchPos)
      Return
      
   }

   PreviousMatchStart := g_OriginalMatchStart
   
   IfEqual, Key, $Up
   {   
      g_MatchPos--
   
      IfLess, g_MatchPos, 1
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
         g_MatchPos := g_MatchTotal
      } else IfLess, g_MatchPos, %g_MatchStart%
      {
         g_MatchStart --
      }      
   } else IfEqual, Key, $Down
   {
      g_MatchPos++
      IfGreater, g_MatchPos, %g_MatchTotal%
      {
         g_MatchStart =1
         g_MatchPos =1
      } Else If ( g_MatchPos > ( g_MatchStart + (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart ++
      }            
   } else IfEqual, Key, $PgUp
   {
      IfEqual, g_MatchPos, 1
      {
         g_MatchPos := g_MatchTotal - (prefs_ListBoxRows - 1)
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
      } Else {
         g_MatchPos-=prefs_ListBoxRows   
         g_MatchStart-=prefs_ListBoxRows
      }
      
      IfLess, g_MatchPos, 1
         g_MatchPos = 1
      IfLess, g_MatchStart, 1
         g_MatchStart = 1
      
   } else IfEqual, Key, $PgDn
   {
      IfEqual, g_MatchPos, %g_MatchTotal%
      {
         g_MatchPos := prefs_ListBoxRows
         g_MatchStart := 1
      } else {
         g_MatchPos+=prefs_ListBoxRows
         g_MatchStart+=prefs_ListBoxRows
      }
   
      IfGreater, g_MatchPos, %g_MatchTotal%
         g_MatchPos := g_MatchTotal
   
      If ( g_MatchStart > ( g_MatchTotal - (prefs_ListBoxRows - 1) ) )
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)   
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
      }
   }
   
   IfEqual, g_MatchStart, %PreviousMatchStart%
   {
      Rows := GetRows()
      IfNotEqual, g_MatchPos,
      {
         ListBoxChooseItem(Rows)
      }
   } else {
      RebuildMatchList()
      ShowListBox()
   }
   Return
}

;------------------------------------------------------------------------

ReturnLineWrong(){
   global g_OldCaretY
   global prefs_DetectMouseClickMove
   ; Return false if we are using DetectMouseClickMove
   IfEqual, prefs_DetectMouseClickMove, On
      Return
      
   Return, ( g_OldCaretY != HCaretY() )
}

;------------------------------------------------------------------------

AddSelectedWordToList(){      
   ClipboardSave := ClipboardAll
   Clipboard =
   Sleep, 100
   SendCompatible("^c",0)
   ClipWait, 0
   IfNotEqual, Clipboard, 
   {
      AddWordToList(Clipboard,1,"ForceLearn")
   }
   Clipboard = %ClipboardSave%
}

DeleteSelectedWordFromList(){
   global g_MatchPos
   global g_SingleMatch
   
   if !(g_SingleMatch[g_MatchPos] = "") ;only continue if g_SingleMatch is not empty
   {
      
      DeleteWordFromList(g_SingleMatch[g_MatchPos])
      RecomputeMatches()
      Return
   }
   
}

;------------------------------------------------------------------------

EvaluateScriptPathAndTitle(){
   ;relaunches to 64 bit or sets script title
   global g_ScriptTitle

   SplitPath, A_ScriptName,,,ScriptExtension,ScriptNoExtension,

   If A_Is64bitOS
   {
      IF (A_PtrSize = 4)
      {
         IF A_IsCompiled
         {
         
            ScriptPath64 := A_ScriptDir . "\" . ScriptNoExtension . "64." . ScriptExtension
         
            IfExist, %ScriptPath64%
            {
               Run, %ScriptPath64%, %A_WorkingDir%
               ExitApp
            }
         }
      }
   }

   if (SubStr(ScriptNoExtension, StrLen(ScriptNoExtension)-1, 2) == "64" )
   {
      StringTrimRight, g_ScriptTitle, ScriptNoExtension, 2
   } else {
      g_ScriptTitle := ScriptNoExtension
   }

   if (InStr(g_ScriptTitle, "TypingAid"))
   {
      g_ScriptTitle = TypingAid
   }
   
   return
}

;------------------------------------------------------------------------

InactivateAll(){
   ;Force unload of Keyboard Hook and WinEventHook
   Input
   SuspendOn()
   CloseListBox()
   MaybeSaveHelperWindowPos()
   DisableWinHook()
}

SuspendOn(){
   global g_ScriptTitle
   Suspend, On
   Menu, Tray, Tip, %g_ScriptTitle% - Inactive
   If A_IsCompiled
   {
      Menu, tray, Icon, %A_ScriptFullPath%,3,1
   } else
   {
      Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Inactive.ico, ,1
   }
}

SuspendOff(){
   global g_ScriptTitle
   Suspend, Off
   Menu, Tray, Tip, %g_ScriptTitle% - Active
   If A_IsCompiled
   {
      Menu, tray, Icon, %A_ScriptFullPath%,1,1
   } else
   {
      Menu, tray, Icon, %A_ScriptDir%\%g_ScriptTitle%-Active.ico, ,1
   }
}   

;------------------------------------------------------------------------

BuildTrayMenu(){

   Menu, Tray, DeleteAll
   Menu, Tray, NoStandard
   Menu, Tray, add, Settings, Configuration
   Menu, Tray, add, Pause, PauseResumeScript
   IF (A_IsCompiled)
   {
      Menu, Tray, add, Exit, ExitScript
   } else {
      Menu, Tray, Standard
   }
   Menu, Tray, Default, Settings
   ;Initialize Tray Icon
   Menu, Tray, Icon
}

;------------------------------------------------------------------------

; This is to blank all vars related to matches, ListBox and (optionally) word 
ClearAllVars(ClearWord){
   global
   CloseListBox()
   Ifequal,ClearWord,1
   {
      g_Word =
      g_OldCaretY=
      g_OldCaretX=
      g_LastInput_id=
      g_ListBoxFlipped=
      g_ListBoxMaxWordHeight=
   }
   
   g_SingleMatch =
   g_SingleMatchDescription =
   g_SingleMatchReplacement =
   g_Match= 
   g_MatchPos=
   g_MatchStart= 
   g_OriginalMatchStart=
   Return
}

;------------------------------------------------------------------------

FileAppendDispatch(Text,FileName,ForceEncoding=0){
   IfEqual, A_IsUnicode, 1
   {
      IfNotEqual, ForceEncoding, 0
      {
         FileAppend, %Text%, %FileName%, %ForceEncoding%
      } else
      {
         FileAppend, %Text%, %FileName%, UTF-8
      }
   } else {
            FileAppend, %Text%, %FileName%
         }
   Return
}

MaybeFixFileEncoding(File,Encoding){
   IfGreaterOrEqual, A_AhkVersion, 1.0.90.0
   {
      
      IfExist, %File%
      {    
         IfNotEqual, A_IsUnicode, 1
         {
            Encoding =
         }
         
         
         EncodingCheck := FileOpen(File,"r")
         
         If EncodingCheck
         {
            If Encoding
            {
               IF !(EncodingCheck.Encoding = Encoding)
                  WriteFile = 1
            } else
            {
               IF (SubStr(EncodingCheck.Encoding, 1, 3) = "UTF")
                  WriteFile = 1
            }
         
            IF WriteFile
            {
               Contents := EncodingCheck.Read()
               EncodingCheck.Close()
               EncodingCheck =
               FileCopy, %File%, %File%.preconv.bak
               FileDelete, %File%
               FileAppend, %Contents%, %File%, %Encoding%
               
               Contents =
            } else
            {
               EncodingCheck.Close()
               EncodingCheck =
            }
         }
      }
   }
}

;------------------------------------------------------------------------

GetOSVersion(){
   return ((r := DllCall("GetVersion") & 0xFFFF) & 0xFF) "." (r >> 8)
}

;------------------------------------------------------------------------

MaybeCoInitializeEx(){
   global g_NULL
   global g_ScrollEventHook
   global g_WinChangedEventHook
   
   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoInitializeEx", "Ptr", g_NULL, "Uint", g_NULL)
   }
   
}


MaybeCoUninitialize(){
   global g_WinChangedEventHook
   global g_ScrollEventHook
   if (!g_WinChangedEventHook && !g_ScrollEventHook)
   {
      DllCall("CoUninitialize")
   }
}

;------------------------------------------------------------------------

Configuration:
GoSub, LaunchSettings
Return

PauseResumeScript:
if (g_PauseState == "Paused")
{
   g_PauseState =
   Pause, Off
   EnableWinHook()
   Menu, tray, Uncheck, Pause
} else {
   g_PauseState = Paused
   DisableWinHook()
   SuspendOn()
   Menu, tray, Check, Pause
   Pause, On, 1
}
Return

ExitScript:
ExitApp
Return
   
SaveScript:
; Close the ListBox if it's open
CloseListBox()

SuspendOn()

;Change the cleanup performance speed
SetBatchLines, 20ms
Process, Priority,,Normal

;Grab the Helper Window Position if open
MaybeSaveHelperWindowPos()

;Write the Helper Window Position to the Preferences File
MaybeWriteHelperWindowPos()

; Update the Learned Words
MaybeUpdateWordlist()

ExitApp




;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;\|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;============================== [Conversions]

; these functions handle database conversion
; always set the SetDbVersion default argument to the current highest version

SetDbVersion(dBVersion = 7){
   global g_WordListDB
   g_WordListDB.Query("INSERT OR REPLACE INTO LastState VALUES ('databaseVersion', '" . dBVersion . "', NULL);")
}


; returns true if we need to rebuild the whole database
MaybeConvertDatabase(){
   global g_WordListDB
   
   databaseVersionRows := g_WordListDB.Query("SELECT lastStateNumber FROM LastState WHERE lastStateItem = 'databaseVersion';")
   
   if (databaseVersionRows)
   {
      for each, row in databaseVersionRows.Rows
      {
         databaseVersion := row[1]
      }
   }
   
   if (!databaseVersion)
   {
         tableConverted := g_WordListDB.Query("SELECT tableconverted FROM LastState;")
   } else {
      tableConverted := g_WordListDB.Query("SELECT lastStateNumber FROM LastState WHERE lastStateItem = 'tableConverted';")
   }
   
   if (tableConverted)
   {
      for each, row in tableConverted.Rows
      {
         WordlistConverted := row[1]
      }
   }
   
   IfNotEqual, WordlistConverted, 1
   {
      RebuildDatabase()    
      return, true
   }
   
   if (!databaseVersion)
   {
      RunConversionOne(WordlistConverted)
   }
   
   if (databaseVersion < 2)
   {
      RunConversionTwo()
   }
   
   if (databaseVersion < 3)
   {
      RunConversionThree()
   }
   
   if (databaseVersion < 4)
   {
      RunConversionFour()
   }
   
   if (databaseVersion < 5)
   {
      RunConversionFive()
   }
   
   if (databaseVersion < 6)
   {
      RunConversionSix()
   }
   
   if (databaseVersion < 7)
   {
      RunConversionSeven()
   }
   
   return, false
}


; Rebuilds the Database from scratch as we have to redo the wordlist anyway.
RebuildDatabase(){
   global g_WordListDB
   g_WordListDB.BeginTransaction()
   g_WordListDB.Query("DROP TABLE Words;")
   g_WordListDB.Query("DROP INDEX WordIndex;")
   g_WordListDB.Query("DROP TABLE LastState;")
   g_WordListDB.Query("DROP TABLE Wordlists;")
   
   CreateWordsTable()
   
   CreateWordIndex()
   
   CreateLastStateTable()
   
   CreateWordlistsTable()
   
   SetDbVersion()
   g_WordListDB.EndTransaction()
      
}

;Runs the first conversion
RunConversionOne(WordlistConverted){
   global g_WordListDB
   g_WordListDB.BeginTransaction()
   
   g_WordListDB.Query("ALTER TABLE LastState RENAME TO OldLastState;")
   
   CreateLastStateTable()
   
   g_WordListDB.Query("DROP TABLE OldLastState;")
   g_WordListDB.Query("INSERT OR REPLACE INTO LastState VALUES ('tableConverted', '" . WordlistConverted . "', NULL);")
   
   ;superseded by conversion 3
   ;g_WordListDB.Query("ALTER TABLE Words ADD COLUMN worddescription TEXT;")
   
   SetDbVersion(1)
   g_WordListDB.EndTransaction()
   
}

RunConversionTwo(){
   global g_WordListDB
   
   ;superseded by conversion 3
   ;g_WordListDB.Query("ALTER TABLE Words ADD COLUMN wordreplacement TEXT;")
   
   ;SetDbVersion(2)
}

RunConversionThree(){
   global g_WordListDB
   g_WordListDB.BeginTransaction()
   
   CreateWordsTable("Words2")
   
   g_WordListDB.Query("UPDATE Words SET wordreplacement = '' WHERE wordreplacement IS NULL;")
   
   g_WordListDB.Query("INSERT INTO Words2 SELECT * FROM Words;")
   
   g_WordListDB.Query("DROP TABLE Words;")
   
   g_WordListDB.Query("ALTER TABLE Words2 RENAME TO Words;")
   
   CreateWordIndex()
   
   SetDbVersion(3)
   g_WordListDB.EndTransaction()
}

; normalize accented characters
RunConversionFour(){
   global g_WordListDB
   ;superseded by conversion 6
   /*g_WordListDB.BeginTransaction()
   
   Words := g_WordListDB.Query("SELECT word, wordindexed, wordreplacement FROM Words;")
   
   for each, row in Words.Rows
   {
      Word := row[1]
      WordIndexed := row[2]
      WordReplacement := row[3]     
      
      WordIndexedTransformed := StrUnmark(WordIndexed)
      
      StringReplace, WordIndexedTransformedEscaped, WordIndexedTransformed, ', '', All    
      StringReplace, WordEscaped, Word, ', '', All
      StringReplace, WordIndexEscaped, WordIndexed, ', '', All
      StringReplace, WordReplacementEscaped, WordReplacement, ', '', All
      
      g_WordListDB.Query("UPDATE Words SET wordindexed = '" . WordIndexedTransformedEscaped . "' WHERE word = '" . WordEscaped . "' AND wordindexed = '" . WordIndexEscaped . "' AND wordreplacement = '" . WordReplacementEscaped . "';")
   }
   
   SetDbVersion(4)
   g_WordListDB.EndTransaction()
   */
}

;Creates the Wordlists table
RunConversionFive(){
   global g_WordListDB
   g_WordListDB.BeginTransaction()
   
   CreateWordlistsTable()
   
   SetDbVersion(5)
   g_WordListDB.EndTransaction()
}

; normalize accented characters
RunConversionSix(){
   ; superseded by conversion 7
}

; normalize accented characters
RunConversionSeven(){
   global g_WordListDB
   g_WordListDB.BeginTransaction()
   
   Words := g_WordListDB.Query("SELECT word, wordindexed, wordreplacement FROM Words;")
   WordDescription = 
   
   for each, row in Words.Rows
   {
      Word := row[1]
      WordIndexed := row[2]
      WordReplacement := row[3]
      
      TransformWord(Word, WordReplacement, WordDescription, WordTransformed, WordIndexedTransformed, WordReplacementTransformed, WordDescriptionTransformed)
      
      StringReplace, OldWordIndexedTransformed, WordIndexed, ', '', All
      
      g_WordListDB.Query("UPDATE Words SET wordindexed = '" . WordIndexedTransformed . "' WHERE word = '" . WordTransformed . "' AND wordindexed = '" . OldWordIndexedTransformed . "' AND wordreplacement = '" . WordReplacementTransformed . "';")
   }
   
   SetDbVersion(7)
   g_WordListDB.EndTransaction()
}

CreateLastStateTable(){
   global g_WordListDB

   IF not g_WordListDB.Query("CREATE TABLE LastState (lastStateItem TEXT PRIMARY KEY, lastStateNumber INTEGER, otherInfo TEXT) WITHOUT ROWID;")
   {
      ErrMsg := g_WordListDB.ErrMsg()
      ErrCode := g_WordListDB.ErrCode()
      MsgBox Cannot Create LastState Table - fatal error: %ErrCode% - %ErrMsg%
      ExitApp
   }
}

CreateWordsTable(WordsTableName:="Words"){
   global g_WordListDB
   
   IF not g_WordListDB.Query("CREATE TABLE " . WordsTableName . " (wordindexed TEXT NOT NULL, word TEXT NOT NULL, count INTEGER, worddescription TEXT, wordreplacement TEXT NOT NULL, PRIMARY KEY (word, wordreplacement) );")
   {
      ErrMsg := g_WordListDB.ErrMsg()
      ErrCode := g_WordListDB.ErrCode()
      msgbox Cannot Create %WordsTableName% Table - fatal error: %ErrCode% - %ErrMsg%
      ExitApp
   }
}

CreateWordIndex(){
   global g_WordListDB

   IF not g_WordListDB.Query("CREATE INDEX WordIndex ON Words (wordindexed);")
   {
      ErrMsg := g_WordListDB.ErrMsg()
      ErrCode := g_WordListDB.ErrCode()
      msgbox Cannot Create WordIndex Index - fatal error: %ErrCode% - %ErrMsg%
      ExitApp
   }
}

CreateWordlistsTable(){
   global g_WordListDB
   
   IF not g_WordListDB.Query("CREATE TABLE Wordlists (wordlist TEXT PRIMARY KEY, wordlistmodified DATETIME, wordlistsize INTEGER) WITHOUT ROWID;")
   {
      ErrMsg := g_WordListDB.ErrMsg()
      ErrCode := g_WordListDB.ErrCode()
      msgbox Cannot Create Wordlists Table - fatal error: %ErrCode% - %ErrMsg%
      ExitApp
   }
}

;============================== [ Helper ]

; These functions and labels are related to interacting with the Helper Window

MaybeOpenOrCloseHelperWindow(ActiveProcess,ActiveTitle,ActiveId){
   ; This is called when switching the active window
   global g_HelperManual
   
   IfNotEqual, g_HelperManual,
   {
      MaybeCreateHelperWindow()
      Return
   }

   IF ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
   {
      global g_HelperClosedWindowIds
      ; Remove windows which were closed
      Loop, Parse, g_HelperClosedWindowIDs, |
      {
         IfEqual, A_LoopField,
            Continue
            
         IfWinExist, ahk_id %A_LoopField%
         {
            TempHelperClosedWindowIDs .= "|" . A_LoopField . "|"
         }
      }
      
      g_HelperClosedWindowIDs = %TempHelperClosedWindowIDs%
      TempHelperClosedWindowIDs =
      
      SearchText := "|" . ActiveId . "|"
      
      IfInString, g_HelperClosedWindowIDs, %SearchText%
      {
         MaybeSaveHelperWindowPos()
      } else MaybeCreateHelperWindow()
   
   } else MaybeSaveHelperWindowPos()

   Return
   
}

CheckHelperWindowAuto(ActiveProcess,ActiveTitle){
   global prefs_HelperWindowProgramExecutables
   global prefs_HelperWindowProgramTitles
   
   quotechar := """"
   
   Loop, Parse, prefs_HelperWindowProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return, true
   }

   Loop, Parse, prefs_HelperWindowProgramTitles, |
   {
      if (SubStr(A_LoopField, 1, 1) == quotechar && SubStr(A_LoopField, StrLen(A_LoopField), 1) == quotechar)
      {
         StringTrimLeft, TrimmedString, A_LoopField, 1
         StringTrimRight, TrimmedString, TrimmedString, 1
         IfEqual, ActiveTitle, %TrimmedString%
         {
            Return, true
         }
      } else IfInString, ActiveTitle, %A_LoopField%
      {
         Return, true
      }
   }

   Return
}

MaybeOpenOrCloseHelperWindowManual(){
   ;Called when we hit Ctrl-Shift-H
      
   global g_Helper_Id
   global g_HelperManual
   
   ;If a helper window already exists 
   IfNotEqual, g_Helper_Id,
   {
      ; If we've forced a manual helper open, close it. Else mark it as forced open manually
      IfNotEqual, g_HelperManual,
      {
         HelperWindowClosed()
      } else g_HelperManual=1
   } else {
      global g_Active_Id
      global g_Active_Process
      global g_Active_Title
      ;Check for Auto Helper, and if Auto clear closed flag and open
      IF ( CheckHelperWindowAuto(g_Active_Process,g_Active_Title) )
      {
         global g_HelperClosedWindowIDs
         SearchText := "|" . g_Active_Id . "|"
         StringReplace, g_HelperClosedWindowIDs, g_HelperClosedWindowIDs, %SearchText%
               
      } else {
         ; else Open a manually opened helper window
         g_HelperManual=1
      }
      MaybeCreateHelperWindow()
   }
      
   Return
}

;------------------------------------------------------------------------

;Create helper window for showing ListBox
MaybeCreateHelperWindow(){
   Global g_Helper_Id
   Global g_XY
   ;Don't open a new Helper Window if One is already open
   IfNotEqual, g_Helper_Id,
      Return
      
   Gui, HelperGui:+Owner -MinimizeBox -MaximizeBox +AlwaysOnTop
   Gui, HelperGui:+LabelHelper_
   Gui, HelperGui:Add, Text,,List appears here 
   IfNotEqual, g_XY, 
   {
      StringSplit, Pos, g_XY, `, 
      Gui, HelperGui:Show, X%Pos1% Y%Pos2% NoActivate
   } else {
      Gui, HelperGui:Show, NoActivate
   }
   WinGet, g_Helper_Id, ID,,List appears here 
   WinSet, Transparent, 125, ahk_id %g_Helper_Id%
   return 
}

;------------------------------------------------------------------------

Helper_Close:
HelperWindowClosed()
Return

HelperWindowClosed(){
   global g_Helper_Id
   global g_HelperManual
   IfNotEqual, g_Helper_Id,
   {
      ;Check g_LastActiveIdBeforeHelper and not g_Active_Id in case we are on the Helper Window
      global g_LastActiveIdBeforeHelper
      WinGetTitle, ActiveTitle, ahk_id %g_LastActiveIdBeforeHelper%
      WinGet, ActiveProcess, ProcessName, ahk_id %g_LastActiveIdBeforeHelper%
      
      If ( CheckHelperWindowAuto(ActiveProcess,ActiveTitle) )
      {
         global g_HelperClosedWindowIDs
         
         SearchText := "|" . g_LastActiveIdBeforeHelper . "|"         
         IfNotInString g_HelperClosedWindowIDs, %SearchText%
            g_HelperClosedWindowIDs .= SearchText
      }
   
      g_HelperManual=   
   
      MaybeSaveHelperWindowPos()
   }
   Return
}

;------------------------------------------------------------------------

MaybeSaveHelperWindowPos(){
   global g_Helper_Id
   IfNotEqual, g_Helper_Id, 
   {
      global g_XY
      global g_XYSaved
      WinGetPos, hX, hY, , , ahk_id %g_Helper_Id%
      g_XY = %hX%`,%hY%
      g_XYSaved = 1
      g_Helper_Id = 
      Gui, HelperGui:Hide
   }
   Return
}

;============================== [ ListBox ]

;These functions and labels are related to the shown list of words

InitializeListBox(){
   global
   
   Gui, ListBoxGui: -DPIScale -Caption +AlwaysOnTop +ToolWindow +Delimiter%g_DelimiterChar%
   
   Local ListBoxFont
   if (prefs_ListBoxFontOverride && prefs_ListBoxFontOverride != "<Default>")
   {
      ListBoxFont := prefs_ListBoxFontOverride
   } else IfEqual, prefs_ListBoxFontFixed, On
   {
      ListBoxFont = Courier New
   } else {
      ListBoxFont = Tahoma
   }
      
   Gui, ListBoxGui:Font, s%prefs_ListBoxFontSize%, %ListBoxFont%

   Loop, %prefs_ListBoxRows%
   {
      GuiControl, ListBoxGui:-Redraw, g_ListBox%A_Index%
      ;can't use a g-label here as windows sometimes passes the click message when spamming the scrollbar arrows
      Gui, ListBoxGui: Add, ListBox, vg_ListBox%A_Index% R%A_Index% X0 Y0 T%prefs_ListBoxFontSize% T32 hwndg_ListBoxHwnd%A_Index%
   }

   Return
}
   
ListBoxClickItem(wParam, lParam, msg, ClickedHwnd){
   global
   Local NewClickedItem
   Local TempRows
   static LastClickedItem
   
   TempRows := GetRows()
   
   if (ClickedHwnd != g_ListBoxHwnd%TempRows%)
   {
      return
   }
   
   ; if we clicked in the scrollbar, jump out
   if (A_GuiX > (g_ListBoxPosX + g_ListBoxContentWidth))
   {
      SetSwitchOffListBoxTimer()
      Return
   }
   
   GuiControlGet, g_MatchPos, ListBoxGui:, g_ListBox%TempRows%
   
   if (msg == g_WM_LBUTTONUP)
   {
      if prefs_DisabledAutoCompleteKeys not contains L
      {
         SwitchOffListBoxIfActive()
         EvaluateUpDown("$LButton")   
      } else {
         ; Track this to make sure we're double clicking on the same item
         NewClickedItem := g_MatchPos
         SetSwitchOffListBoxTimer()
      }
         
   } else if (msg == g_WM_LBUTTONDBLCLK)
   {
      SwitchOffListBoxIfActive()
      
      if prefs_DisabledAutoCompleteKeys contains L
      {
         if (LastClickedItem == g_MatchPos)
         {
            EvaluateUpDown("$LButton")   
         }
      }
   } else {
      SwitchOffListBoxIfActive()
   }
      
   ; clear or set LastClickedItem
   LastClickedItem := NewClickedItem
   
   Return
}

SetSwitchOffListBoxTimer(){
   static DoubleClickTime
   
   if !(DoubleClickTime)
   {
      DoubleClickTime := DllCall("GetDoubleClickTime")
   }
   ;When single click is off, we have to wait for the double click time to pass
   ; before re-activating the edit window to allow double click to work
   SetTimer, SwitchOffListBoxIfActiveSub, -%DoubleClickTime%
}
   

SwitchOffListBoxIfActiveSub:
SwitchOffListBoxIfActive()
Return

ListBoxScroll(Hook, Event, EventHwnd){
   global
   
   Local MatchEnd
   Local SI
   Local TempRows
   Local Position
   
   if (g_ListBox_Id)
   {
   
      TempRows := GetRows()
      if (g_ListBoxHwnd%TempRows% != EventHwnd)
      {
         return
      }
      
      if (Event == g_EVENT_SYSTEM_SCROLLINGSTART)
      {
         ; make sure the timer is clear so we don't switch while scrolling
         SetTimer, SwitchOffListBoxIfActiveSub, Off
         return
      }
      
      SI:=GetScrollInfo(g_ListBoxHwnd%TempRows%)
   
      if (!SI.npos)
      {
         return
      }
   
      if (SI.npos == g_MatchStart)
      {
         return
      }
   
      g_MatchStart := SI.npos
   
      SetSwitchOffListBoxTimer()   
   }
}

; based on code by HotKeyIt
;  http://www.autohotkey.com/board/topic/78829-ahk-l-scrollinfo/
;  http://www.autohotkey.com/board/topic/55150-class-structfunc-sizeof-updated-010412-ahkv2/
GetScrollInfo(ctrlhwnd) {
  global g_SB_VERT
  global g_SIF_POS
  SI:=new _Struct("cbSize,fMask,nMin,nMax,nPage,nPos,nTrackPos")
  SI.cbSize:=sizeof(SI)
  SI.fMask := g_SIF_POS
  If !DllCall("GetScrollInfo","PTR",ctrlhwnd,"Int",g_SB_VERT,"PTR",SI[""])
    Return false
  else Return SI
}

ListBoxChooseItem(Row){
   global
   GuiControl, ListBoxGui: Choose, g_ListBox%Row%, %g_MatchPos%
}

;------------------------------------------------------------------------

CloseListBox(){
   global g_ListBox_Id
   IfNotEqual, g_ListBox_Id,
   {
      Gui, ListBoxGui: Hide
      ListBoxEnd()
   }
   Return
}

DestroyListBox(){
   Gui, ListBoxGui:Destroy
   ListBoxEnd()
   Return
}

ListBoxEnd(){
   global g_ScrollEventHook
   global g_ScrollEventHookThread
   global g_ListBox_Id
   global g_WM_LBUTTONUP
   global g_WM_LBUTTONDBLCLK
   
   g_ListBox_Id =
   
   OnMessage(g_WM_LBUTTONUP, "")
   OnMessage(g_WM_LBUTTONDBLCLK, "")

   if (g_ScrollEventHook) {
      DllCall("UnhookWinEvent", "Uint", g_ScrollEventHook)
      g_ScrollEventHook =
      g_ScrollEventHookThread =
      MaybeCoUninitialize()
   }
   DisableKeyboardHotKeys()
   return
}

;------------------------------------------------------------------------

SavePriorMatchPosition(){
   global g_MatchPos
   global g_MatchStart
   global g_OldMatch
   global g_OldMatchStart
   global g_SingleMatch
   global prefs_ArrowKeyMethod
   
   if !(g_MatchPos)
   {
      g_OldMatch =
      g_OldMatchStart = 
   } else IfEqual, prefs_ArrowKeyMethod, LastWord
   {
      g_OldMatch := g_SingleMatch[g_MatchPos]
      g_OldMatchStart = 
   } else IfEqual, prefs_ArrowKeyMethod, LastPosition
   {
      g_OldMatch := g_MatchPos
      g_OldMatchStart := g_MatchStart
   } else {
      g_OldMatch =
      g_OldMatchStart =
   }
      
   Return
}

SetupMatchPosition(){
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OldMatch
   global g_OldMatchStart
   global g_SingleMatch
   global prefs_ArrowKeyMethod
   global prefs_ListBoxRows
   
   IfEqual, g_OldMatch, 
   {
      IfEqual, prefs_ArrowKeyMethod, Off
      {
         g_MatchPos = 
         g_MatchStart = 1
      } else {
         g_MatchPos = 1
         g_MatchStart = 1
      }
   } else IfEqual, prefs_ArrowKeyMethod, Off
   {
      g_MatchPos = 
      g_MatchStart = 1
   } else IfEqual, prefs_ArrowKeyMethod, LastPosition
   {
      IfGreater, g_OldMatch, %g_MatchTotal%
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
         g_MatchPos := g_MatchTotal
      } else {
         g_MatchStart := g_OldMatchStart
         If ( g_MatchStart > (g_MatchTotal - (prefs_ListBoxRows - 1) ))
         {
            g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
            IfLess, g_MatchStart, 1
               g_MatchStart = 1
         }
         g_MatchPos := g_OldMatch
      }
   
   } else IfEqual, prefs_ArrowKeyMethod, LastWord
   {
      ListPosition =
      Loop, %g_MatchTotal%
      {
         if ( g_OldMatch == g_SingleMatch[A_Index] )
         {
            ListPosition := A_Index
            Break
         }
      }
      IfEqual, ListPosition, 
      {
         g_MatchPos = 1
         g_MatchStart = 1
      } Else {
         g_MatchStart := ListPosition - (prefs_ListBoxRows - 1)
         IfLess, g_MatchStart, 1
            g_MatchStart = 1
         g_MatchPos := ListPosition
      }
   } else {
      g_MatchPos = 1
      g_MatchStart = 1
   }
             
   g_OldMatch = 
   g_OldMatchStart = 
   Return
}

RebuildMatchList(){
   global g_Match
   global g_MatchLongestLength
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OriginalMatchStart
   global prefs_ListBoxRows
   
   g_Match = 
   g_MatchLongestLength =
   
   if (!g_MatchPos)
   {
      ; do nothing
   } else if (g_MatchPos < g_MatchStart)
   {
      g_MatchStart := g_MatchPos
   } else if (g_MatchPos > (g_MatchStart + (prefs_ListBoxRows - 1)))
   {
      g_MatchStart := g_MatchPos - (prefs_ListBoxRows -1)
   }
   
   g_OriginalMatchStart := g_MatchStart
   
   MaxLength := ComputeListBoxMaxLength()
   HalfLength := Round(MaxLength/2)
   
   Loop, %g_MatchTotal%
   {
      CurrentLength := AddToMatchList(A_Index, MaxLength, HalfLength, 0, true)
      IfGreater, CurrentLength, %LongestBaseLength%
         LongestBaseLength := CurrentLength      
   }
   
   Loop, %g_MatchTotal%
   {
      CurrentLength := AddToMatchList(A_Index, MaxLength, HalfLength, LongestBaseLength, false)
      IfGreater, CurrentLength, %g_MatchLongestLength%
         g_MatchLongestLength := CurrentLength      
   }
   StringTrimRight, g_Match, g_Match, 1        ; Get rid of the last linefeed 
   Return
}

AddToMatchList(position, MaxLength, HalfLength, LongestBaseLength, ComputeBaseLengthOnly){
   global g_DelimiterChar
   global g_Match
   global g_MatchStart
   global g_NumKeyMethod
   global g_SingleMatch
   global g_SingleMatchDescription
   global g_SingleMatchReplacement
   global prefs_ListBoxFontFixed
   
   blankprefix = `t
   
   IfEqual, g_NumKeyMethod, Off
   {
      prefix := blankprefix
   } else IfLess, position, %g_MatchStart%
   {
      prefix := blankprefix
   } else if ( position > ( g_MatchStart + 9 ) )
   {
      prefix := blankprefix
   } else {
      prefix := Mod(position - g_MatchStart +1,10) . "`t"
   }
   
   prefixlen := 2
   
   CurrentMatch := g_SingleMatch[position]
   if (g_SingleMatchReplacement[position] || g_SingleMatchDescription[position])
   {
      AdditionalDataExists := true
      BaseLength := HalfLength
   } else if (ComputeBaseLengthOnly) {
      ; we don't need to compute the base length if there
      ; is no Replacement or Description
      Return, 0
   } else {
      BaseLength := MaxLength
   }
   
   CurrentMatchLength := StrLen(CurrentMatch) + prefixlen
   
   if (CurrentMatchLength > BaseLength)
   {
      CompensatedBaseLength := BaseLength - prefixlen
      ; remove 3 characters so we can add the ellipsis
      StringLeft, CurrentMatch, CurrentMatch, CompensatedBaseLength - 3
      CurrentMatch .= "..."
   
      CurrentMatchLength := StrLen(CurrentMatch) + prefixlen
   }
   
   if (ComputeBaseLengthOnly)
   {
      Return, CurrentMatchLength
   }
   
   Iterations := 0
   Tabs = 
   Remainder := 0
   
   if (AdditionalDataExists) 
   {
      if (g_SingleMatchReplacement[position])
      {
         CurrentMatch .= " " . chr(26) . " " . g_SingleMatchReplacement[position]
      }
      if (g_SingleMatchDescription[position])
      {
         ;;CurrentMatch .= "|" . g_SingleMatchDescription[position]
         IfEqual, prefs_ListBoxFontFixed, On
         {
            Iterations := Ceil(LongestBaseLength/8) - Floor((strlen(CurrentMatch) + prefixlen)/8)
         
            Remainder := Mod(strlen(CurrentMatch) + prefixlen, 8)
         
            Loop, %Iterations%
            {
               Tabs .= Chr(9)
            }
         } else {
            Iterations := 1
            Remainder := 0
            Tabs := Chr(9)
         }
         
         CurrentMatch .= Tabs . "|" . g_SingleMatchDescription[position]
      }
         
      CurrentMatchLength := strlen(CurrentMatch) + prefixlen - strlen(Tabs) + (Iterations * 8) - Remainder
      
      ;MaxLength - prefix length to make room for prefix
      if (CurrentMatchLength > MaxLength)
      {
         CompensatedMaxLength := MaxLength - prefixlen + strlen(Tabs) - (Iterations * 8) + Remainder
         ; remove 3 characters so we can add the ellipsis
         StringLeft, CurrentMatch, CurrentMatch, CompensatedMaxLength - 3
         CurrentMatch .= "..."
         CurrentMatchLength := strlen(CurrentMatch) + prefixlen - strlen(Tabs) + (Iterations * 8) - Remainder
      }
   }
   
   g_Match .= prefix . CurrentMatch
   
   g_Match .= g_DelimiterChar
   Return, CurrentMatchLength
}

;------------------------------------------------------------------------

; find out the longest length we can use in the listbox
; Any changes to this function probably need to be reflected in ShowListBox() or ForceWithinMonitorBounds
ComputeListBoxMaxLength(){
   global g_ListBoxCharacterWidthComputed
   global g_MatchTotal
   global g_SM_CMONITORS
   global g_SM_CXFOCUSBORDER
   global g_SM_CXVSCROLL
   global prefs_ListBoxMaxWidth
   
   ; grab the width of a vertical scrollbar

   Rows := GetRows()
   
   IfGreater, g_MatchTotal, %Rows%
   {
      SysGet, ScrollBarWidth, %g_SM_CXVSCROLL%
      if ScrollBarWidth is not integer
         ScrollBarWidth = 17
   } else ScrollBarWidth = 0

   ; Grab the internal border width of the ListBox box
   SysGet, BorderWidthX, %g_SM_CXFOCUSBORDER%
   If BorderWidthX is not integer
      BorderWidthX = 1
   
   ;Use 8 pixels for each character in width
   ListBoxBaseSizeX := g_ListBoxCharacterWidthComputed + ScrollBarWidth + (BorderWidthX * 2)
   
   ListBoxPosX := HCaretX()
   ListBoxPosY := HCaretY()
   
   SysGet, NumMonitors, %g_SM_CMONITORS%

   IfLess, NumMonitors, 1
      NumMonitors =1
         
   Loop, %NumMonitors%
   {
      SysGet, Mon, Monitor, %A_Index%
      IF ( ( ListBoxPosX < MonLeft ) || (ListBoxPosX > MonRight ) || ( ListBoxPosY < MonTop ) || (ListBoxPosY > MonBottom ) )
         Continue
      
      MonWidth := MonRight - MonLeft
      break
   }
   
   if !prefs_ListBoxMaxWidth
   {
      Width := MonWidth
   } else if (prefs_ListBoxMaxWidth < MonWidth)
   {
      Width := prefs_ListBoxMaxWidth
   } else 
   {
      Width := MonWidth
   }
   
   return Floor((Width-ListBoxBaseSizeX)/ g_ListBoxCharacterWidthComputed)
}
   

;Show matched values
; Any changes to this function may need to be reflected in ComputeListBoxMaxLength()
ShowListBox(){
   global

   IfNotEqual, g_Match,
   {
      Local BorderWidthX
      Local ListBoxActualSize
      Local ListBoxActualSizeH
      Local ListBoxActualSizeW
      Local ListBoxPosY
      Local ListBoxSizeX
      Local ListBoxThread
      Local MatchEnd
      Local Rows
      Local ScrollBarWidth
      static ListBox_Old_Cursor

      Rows := GetRows()
      
      IfGreater, g_MatchTotal, %Rows%
      {
         SysGet, ScrollBarWidth, %g_SM_CXVSCROLL%
         if ScrollBarWidth is not integer
            ScrollBarWidth = 17
      } else ScrollBarWidth = 0
   
      ; Grab the internal border width of the ListBox box
      SysGet, BorderWidthX, %g_SM_CXFOCUSBORDER%
      If BorderWidthX is not integer
         BorderWidthX = 1
      
      ;Use 8 pixels for each character in width
      ListBoxSizeX := g_ListBoxCharacterWidthComputed * g_MatchLongestLength + g_ListBoxCharacterWidthComputed + ScrollBarWidth + (BorderWidthX * 2)
      
      g_ListBoxPosX := HCaretX()
      ListBoxPosY := HCaretY()
      
      ; In rare scenarios, the Cursor may not have been detected. In these cases, we just won't show the ListBox.
      IF (!(g_ListBoxPosX) || !(ListBoxPosY))
      {
         return
      }
      
      MatchEnd := g_MatchStart + (prefs_ListBoxRows - 1)
      
      Loop, %prefs_ListBoxRows%
      { 
         IfEqual, A_Index, %Rows%
         {
            GuiControl, ListBoxGui: -Redraw, g_ListBox%A_Index%
            GuiControl, ListBoxGui: Move, g_ListBox%A_Index%, w%ListBoxSizeX%
            GuiControl, ListBoxGui: ,g_ListBox%A_Index%, %g_DelimiterChar%%g_Match%
            IfNotEqual, g_MatchPos,
            {
               GuiControl, ListBoxGui: Choose, g_ListBox%A_Index%, %MatchEnd%
               GuiControl, ListBoxGui: Choose, g_ListBox%A_Index%, %g_MatchPos%
            }
            GuiControl, ListBoxGui: +AltSubmit +Redraw, g_ListBox%A_Index%
            GuiControl, ListBoxGui: Show, g_ListBox%A_Index%
            GuiControlGet, ListBoxActualSize, ListBoxGui: Pos, g_ListBox%A_Index%
            Continue
         }
      
         GuiControl, ListBoxGui: Hide, g_ListBox%A_Index%
         GuiControl, ListBoxGui: -Redraw, g_ListBox%A_Index%
         GuiControl, ListBoxGui: , g_ListBox%A_Index%, %g_DelimiterChar%
      }
      
      ForceWithinMonitorBounds(g_ListBoxPosX,ListBoxPosY,ListBoxActualSizeW,ListBoxActualSizeH)
      
      g_ListBoxContentWidth := ListBoxActualSizeW - ScrollBarWidth - BorderWidthX
      
      IfEqual, g_ListBox_Id,
      {
         
         if prefs_DisabledAutoCompleteKeys not contains L
         {
            if (!ListBox_Old_Cursor)
            {
               ListBox_Old_Cursor := DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", g_cursor_hand)
            }
            
            DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", g_cursor_hand)
            
         ; we only need to set it back to the default cursor if we've ever unset the default cursor
         } else if (ListBox_Old_Cursor)
         {
            DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", ListBox_Old_Cursor)
         }
            
      }
      
      Gui, ListBoxGui: Show, NoActivate X%g_ListBoxPosX% Y%ListBoxPosY% H%ListBoxActualSizeH% W%ListBoxActualSizeW%, Word List Appears Here.
      Gui, ListBoxGui: +LastFound +AlwaysOnTop
      
      IfEqual, g_ListBox_Id,
      {
         
         EnableKeyboardHotKeys()   
      }
      
      WinGet, g_ListBox_Id, ID, Word List Appears Here.
      
      ListBoxThread := DllCall("GetWindowThreadProcessId", "Ptr", g_ListBox_Id, "Ptr", g_NULL)
      if (g_ScrollEventHook && (ListBoxThread != g_ScrollEventHookThread))
      {
         DllCall("UnhookWinEvent", "Uint", g_ScrollEventHook)
         g_ScrollEventHook =
         g_ScrollEventHookThread =
         MaybeCoUninitialize()
      }
         
      if (!g_ScrollEventHook) {
         MaybeCoInitializeEx()
         g_ScrollEventHook := DllCall("SetWinEventHook", "Uint", g_EVENT_SYSTEM_SCROLLINGSTART, "Uint", g_EVENT_SYSTEM_SCROLLINGEND, "Ptr", g_NULL, "Uint", g_ListBoxScrollCallback, "Uint", g_PID, "Uint", ListBoxThread, "Uint", g_NULL)
         g_ScrollEventHookThread := ListBoxThread
      }
      
      OnMessage(g_WM_LBUTTONUP, "ListBoxClickItem")
      OnMessage(g_WM_LBUTTONDBLCLK, "ListBoxClickItem")
      
      IfNotEqual, prefs_ListBoxOpacity, 255
         WinSet, Transparent, %prefs_ListBoxOpacity%, ahk_id %g_ListBox_Id%
   }
}

; Any changes to this function may need to be reflected in ComputeListBoxMaxLength()
ForceWithinMonitorBounds(ByRef ListBoxPosX,ByRef ListBoxPosY,ListBoxActualSizeW,ListBoxActualSizeH){
   global g_ListBoxFlipped
   global g_SM_CMONITORS
   global g_ListBoxCharacterWidthComputed
   global g_ListBoxOffsetComputed
   global g_ListBoxMaxWordHeight
   ;Grab the number of non-dummy monitors
   SysGet, NumMonitors, %g_SM_CMONITORS%
   
   IfLess, NumMonitors, 1
      NumMonitors =1
         
   Loop, %NumMonitors%
   {
      SysGet, Mon, Monitor, %A_Index%
      IF ( ( ListBoxPosX < MonLeft ) || (ListBoxPosX > MonRight ) || ( ListBoxPosY < MonTop ) || (ListBoxPosY > MonBottom ) )
         Continue
      
      if (ListBoxActualSizeH > g_ListBoxMaxWordHeight) {
         g_ListBoxMaxWordHeight := ListBoxActualSizeH
      }
      
      ; + g_ListBoxOffsetComputed Move ListBox down a little so as not to hide the caret. 
      ListBoxPosY := ListBoxPosY + g_ListBoxOffsetComputed
      if (g_ListBoxFlipped) {
         ListBoxMaxPosY := HCaretY() - g_ListBoxMaxWordHeight
         
         if (ListBoxMaxPosY < MonTop) {
            g_ListBoxFlipped =
         } else {
            ListBoxPosY := HCaretY() - ListBoxActualSizeH
         }
      }
      
      ; make sure we don't go below the screen.
      If ( (ListBoxPosY + g_ListBoxMaxWordHeight ) > MonBottom )
      {
         ListBoxPosY := HCaretY() - ListBoxActualSizeH
         g_ListBoxFlipped := true
      }
      
      ; make sure we don't go above the top of the screen.
      If (ListBoxPosY < MonTop) {
         ListBoxPosY := MonTop
         ; Try to move over horizontal position to leave some space, may get overridden later.
         ListBoxPosX += g_ListBoxCharacterWidthComputed
      }
      
      If ( (ListBoxPosX + ListBoxActualSizeW ) > MonRight )
      {
         ListBoxPosX := MonRight - ListBoxActualSizeW
         If ( ListBoxPosX < MonLeft )
            ListBoxPosX := MonLeft
      }
         
         
      Break
   }

   Return      
}

;------------------------------------------------------------------------

GetRows(){
   global g_MatchTotal
   global prefs_ListBoxRows
   IfGreater, g_MatchTotal, %prefs_ListBoxRows%
      Rows := prefs_ListBoxRows
   else Rows := g_MatchTotal
   
   Return, Rows
}
;------------------------------------------------------------------------

; function to grab the X position of the caret for the ListBox
HCaretX() {
   global g_DpiAware
   global g_DpiScalingFactor
   global g_Helper_Id
   global g_Process_DPI_Unaware
    
   WinGetPos, HelperX,,,, ahk_id %g_Helper_Id% 
   if HelperX !=
   { 
      return HelperX
   } 
   if ( CheckIfCaretNotDetectable() )
   { 
      MouseGetPos, MouseX
      return MouseX
   }
   ; non-DPI Aware
   if (g_DpiAware == g_Process_DPI_Unaware) {
      return (A_CaretX * g_DpiScalingFactor)
   }
   
   return A_CaretX 
} 

;------------------------------------------------------------------------

; function to grab the Y position of the caret for the ListBox
HCaretY() {
   global g_DpiAware
   global g_DpiScalingFactor
   global g_Helper_Id
   global g_Process_DPI_Unaware

   WinGetPos,,HelperY,,, ahk_id %g_Helper_Id% 
   if HelperY != 
   { 
      return HelperY
   } 
   if ( CheckIfCaretNotDetectable() )
   { 
      MouseGetPos, , MouseY
      return MouseY + (20*g_DpiScalingFactor)
   }
   if (g_DpiAware == g_Process_DPI_Unaware) {
      return (A_CaretY * g_DpiScalingFactor)
   }
   
   return A_CaretY 
}

;------------------------------------------------------------------------

CheckIfCaretNotDetectable(){
   ;Grab the number of non-dummy monitors
   SysGet, NumMonitors, 80
   
   IfLess, NumMonitors, 1
      NumMonitors = 1
   
   if !(A_CaretX)
   {
      Return, 1
   }
   
   ;if the X caret position is equal to the leftmost border of the monitor +1, we can't detect the caret position.
   Loop, %NumMonitors%
   {
      SysGet, Mon, Monitor, %A_Index%
      if ( A_CaretX = ( MonLeft ) )
      {
         Return, 1
      }
      
   }
   
   Return, 0
}

;============================== [ Preference File ]

;These functions and labels are related to the preferences file

MaybeWriteHelperWindowPos(){
   global g_XY
   global g_XYSaved
   ;Update the Helper Window Position
   IfEqual, g_XYSaved, 1
   {
      IfNotEqual, g_XY, 
         IniWrite, %g_XY%, %A_ScriptDir%\LastState.ini, HelperWindow, XY
   }
   Return
}

;------------------------------------------------------------------------

ReadPreferences(RestoreDefaults = false,RestorePreferences = false){
   global dft_IncludeProgramExecutables
   global dft_IncludeProgramTitles
   global dft_ExcludeProgramExecutables
   global dft_ExcludeProgramTitles
   global dft_Length
   global dft_NumPresses
   global dft_LearnMode
   global dft_LearnCount
   global dft_LearnLength
   global dft_DoNotLearnStrings
   global dft_ArrowKeyMethod
   global dft_DisabledAutoCompleteKeys
   global dft_DetectMouseClickMove
   global dft_NoBackSpace
   global dft_AutoSpace
   global dft_ShowLearnedFirst
   global dft_SuppressMatchingWord
   global dft_SendMethod
   global dft_TerminatingCharacters
   global dft_ForceNewWordCharacters
   global dft_EndWordCharacters
   global dft_ListBoxOffSet
   global dft_ListBoxFontFixed
   global dft_ListBoxFontOverride
   global dft_ListBoxFontSize
   global dft_ListBoxCharacterWidth
   global dft_ListBoxMaxWidth
   global dft_ListBoxOpacity
   global dft_ListBoxRows
   global dft_ListBoxNotDPIAwareProgramExecutables
   global dft_HelperWindowProgramExecutables
   global dft_HelperWindowProgramTitles
   
   global prefs_IncludeProgramExecutables
   global prefs_IncludeProgramTitles
   global prefs_ExcludeProgramExecutables
   global prefs_ExcludeProgramTitles
   global prefs_Length
   global prefs_NumPresses
   global prefs_LearnMode
   global prefs_LearnCount
   global prefs_LearnLength
   global prefs_DoNotLearnStrings
   global prefs_ArrowKeyMethod
   global prefs_DisabledAutoCompleteKeys
   global prefs_DetectMouseClickMove
   global prefs_NoBackSpace
   global prefs_AutoSpace
   global prefs_ShowLearnedFirst
   global prefs_SuppressMatchingWord
   global prefs_SendMethod
   global prefs_TerminatingCharacters
   global prefs_ForceNewWordCharacters
   global prefs_EndWordCharacters
   global prefs_ListBoxOffset
   global prefs_ListBoxFontFixed
   global prefs_ListBoxFontOverride
   global prefs_ListBoxFontSize
   global prefs_ListBoxCharacterWidth
   global prefs_ListBoxMaxWidth
   global prefs_ListBoxOpacity
   global prefs_ListBoxRows
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global prefs_HelperWindowProgramExecutables
   global prefs_HelperWindowProgramTitles
   
   ;g_PrefsFile is global so it works in Settings.ahk
   global g_PrefsFile
   global g_PrefsSections
   global g_XY
   
   g_PrefsFile = %A_ScriptDir%\Preferences.ini
   Defaults = %A_ScriptDir%\Defaults.ini
   LastState = %A_ScriptDir%\LastState.ini
   
   MaybeFixFileEncoding(g_PrefsFile,"UTF-16")
   MaybeFixFileEncoding(Defaults,"UTF-16")
   MaybeFixFileEncoding(LastState,"UTF-16")
   
   dft_TerminatingCharacters = {enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}.;`,¿?¡!'"()[]{}{}}{{}``~`%$&*-+=\/><^|@#:
   
   
   ; There was a bug in TypingAid 2.19.7 that broke terminating characters for new preference files, this code repairs it
   BrokenTerminatingCharacters = {enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}.;
   IfExist, %g_PrefsFile%
   {
      IniRead, MaybeFixTerminatingCharacters, %g_PrefsFile%, Settings, TerminatingCharacters, %A_Space%
      IF (MaybeFixTerminatingCharacters == BrokenTerminatingCharacters)
      {
         IniWrite, %dft_TerminatingCharacters%, %g_PrefsFile%, Settings, TerminatingCharacters
      }
   }      
   
   SpaceVar := "%A_Space%"
   
   IniValues =
   (
      dft_IncludeProgramExecutables,prefs_IncludeProgramExecutables,IncludePrograms,%SpaceVar%
      dft_IncludeProgramTitles,prefs_IncludeProgramTitles,IncludePrograms,%SpaceVar%
      dft_ExcludeProgramExecutables,prefs_ExcludeProgramExecutables,ExcludePrograms,%SpaceVar%
      dft_ExcludeProgramTitles,prefs_ExcludeProgramTitles,ExcludePrograms,%SpaceVar%
      ,Title,Settings,%SpaceVar%
      dft_Length,prefs_Length,Settings,3
      dft_NumPresses,prefs_NumPresses,Settings,1
      dft_LearnMode,prefs_LearnMode,Settings,On
      dft_LearnCount,prefs_LearnCount,Settings,5
      dft_LearnLength,prefs_LearnLength,Settings,%SpaceVar%
      dft_DoNotLearnStrings,prefs_DoNotLearnStrings,Settings,%SpaceVar%
      dft_ArrowKeyMethod,prefs_ArrowKeyMethod,Settings,First
      dft_DisabledAutoCompleteKeys,prefs_DisabledAutoCompleteKeys,Settings,%SpaceVar%
      dft_DetectMouseClickMove,prefs_DetectMouseClickMove,Settings,On
      dft_NoBackSpace,prefs_NoBackSpace,Settings,On
      dft_AutoSpace,prefs_AutoSpace,Settings,Off
      dft_ShowLearnedFirst,prefs_ShowLearnedFirst,Settings,Off
      dft_SuppressMatchingWord,prefs_SuppressMatchingWord,Settings,Off
      dft_SendMethod,prefs_SendMethod,Settings,1
      dft_TerminatingCharacters,prefs_TerminatingCharacters,Settings,`%dft_TerminatingCharacters`%
      dft_ForceNewWordCharacters,prefs_ForceNewWordCharacters,Settings,%SpaceVar%
      dft_EndWordCharacters,prefs_EndWordCharacters,Settings,%SpaceVar%
      dft_ListBoxOffSet,prefs_ListBoxOffset,ListBoxSettings,<Computed>
      dft_ListBoxFontFixed,prefs_ListBoxFontFixed,ListBoxSettings,Off
      dft_ListBoxFontOverride,prefs_ListBoxFontOverride,ListBoxSettings,<Default>
      dft_ListBoxFontSize,prefs_ListBoxFontSize,ListBoxSettings,10 
      dft_ListBoxCharacterWidth,prefs_ListBoxCharacterWidth,ListBoxSettings,<Computed>
      dft_ListBoxMaxWidth,prefs_ListBoxMaxWidth,ListBoxSettings,%SpaceVar%
      dft_ListBoxOpacity,prefs_ListBoxOpacity,ListBoxSettings,215
      dft_ListBoxRows,prefs_ListBoxRows,ListBoxSettings,10
      dft_ListBoxNotDPIAwareProgramExecutables,prefs_ListBoxNotDPIAwareProgramExecutables,ListBoxSettings,%SpaceVar%
      dft_HelperWindowProgramExecutables,prefs_HelperWindowProgramExecutables,HelperWindow,%SpaceVar%
      dft_HelperWindowProgramTitles,prefs_HelperWindowProgramTitles,HelperWindow,%SpaceVar%
      ,XY,HelperWindow,%SpaceVar%
   )
   
   g_PrefsSections := Object()
    
   Loop, Parse, IniValues, `n, `r%A_Space%
   {
      StringSplit, CurrentIniValues, A_LoopField, `,
      DftVariable := CurrentIniValues1
      NormalVariable := CurrentIniValues2
      IniSection := CurrentIniValues3
      DftValue := CurrentIniValues4
      ; maybe strip "prefs_" prefix
      if (substr(NormalVariable, 1, 6) == "prefs_")
      {
         StringTrimLeft, KeyName, NormalVariable, 6
      } else {
         KeyName := NormalVariable
      }
      
      g_PrefsSections[KeyName] := IniSection
      
      ; this is done because certain characters can break the parsing (comma, for example)
      IF (DftValue == "%dft_TerminatingCharacters%")
      {
         DftValue := dft_TerminatingCharacters
      }

      IF ( DftValue = "%A_Space%" )
         DftValue := A_Space
      
      IF !(RestoreDefaults)
         IniRead, %NormalVariable%, %g_PrefsFile%, %IniSection%, %KeyName%, %A_Space%
      
      IF DftVariable
      { 
         IniRead, %DftVariable%, %Defaults%, %IniSection%, %KeyName%, %DftValue%
         IF (RestoreDefaults || %NormalVariable% == "")
         {
            %NormalVariable% := %DftVariable%
         }
      }
   }
   
   ValidatePreferences()
   ParseTerminatingCharacters()
   
   ; Legacy support for old Preferences File
   IfNotEqual, Etitle,
   {
      IfEqual, prefs_IncludeProgramTitles,
      {
         prefs_IncludeProgramTitles = %Etitle%
      } else {
         prefs_IncludeProgramTitles .= "|" . Etitle
      }
      
      Etitle=      
   }
   
   g_XY := XY
   
   IF ( RestoreDefaults || RestorePreferences )
      Return
   
   IfExist, %LastState%
   {    
      IniRead, g_XY, %LastState%, HelperWindow, XY, %A_Space%
   }
   
   ConstructHelpStrings()
         
   Return
}

ValidatePreferences(){
   global g_ListBoxCharacterWidthComputed, g_ListBoxOffsetComputed, g_NumKeyMethod
   global prefs_ArrowKeyMethod, prefs_DisabledAutoCompleteKeys
   global dft_ArrowKeyMethod
   global prefs_AutoSpace, prefs_DetectMouseClickMove, prefs_LearnCount, prefs_LearnLength, prefs_LearnMode, prefs_Length
   global dft_AutoSpace, dft_DetectMouseClickMove, dft_LearnCount, dft_LearnLength, dft_LearnMode, dft_Length
   global prefs_ListBoxCharacterWidth, prefs_ListBoxFontFixed, prefs_ListBoxFontSize, prefs_ListBoxMaxWidth, prefs_ListBoxOffset, prefs_ListBoxOpacity, prefs_ListBoxRows
   global dft_ListBoxCharacterWidth, dft_ListBoxFontFixed, dft_ListBoxFontSize, dft_ListBoxMaxWidth, dft_ListBoxOffset, dft_ListBoxOpacity, dft_ListBoxRows
   global prefs_NoBackSpace, prefs_NumPresses, prefs_SendMethod, prefs_ShowLearnedFirst, prefs_SuppressMatchingWord, prefs_TerminatingCharacters
   global dft_NoBackSpace, dft_NumPresses, dft_SendMethod, dft_ShowLearnedFirst, dft_SuppressMatchingWord, dft_TerminatingCharacters
   
   if prefs_Length is not integer
   {
      prefs_Length := dft_Length
   }
   
   if (prefs_Length < 1) {
      prefs_Length = 1
   }
   
   if prefs_NumPresses not in 1,2
      prefs_NumPresses := dft_NumPresses
   
   If prefs_LearnMode not in On,Off
      prefs_LearnMode := dft_LearnMode
   
   If prefs_LearnCount is not Integer
   {
      prefs_LearnCount := dft_LearnCount
   }
   
   if (prefs_LearnCount < 1)
   {
      prefs_LearnCount = 1
   }
   
   if dft_LearnLength is not Integer
   {
      dft_LearnLength := prefs_Length + 2
   }
   
   if prefs_LearnLength is not Integer
   {
      prefs_LearnLength := dft_LearnLength
   } else If ( prefs_LearnLength < ( prefs_Length + 1 ) )
   {
      prefs_LearnLength := prefs_Length + 1
   }
   
   if prefs_DisabledAutoCompleteKeys contains N
   {
      g_NumKeyMethod = Off
   } else {
      g_NumKeyMethod = On
   }
   
   IfNotEqual, prefs_ArrowKeyMethod, Off
      If prefs_DisabledAutoCompleteKeys contains E
         If prefs_DisabledAutoCompleteKeys contains S
            If prefs_DisabledAutoCompleteKeys contains T
               If prefs_DisabledAutoCompleteKeys contains R
                  If prefs_DisabledAutoCompleteKeys contains U
                     If prefs_DisabledAutoCompleteKeys contains M
                        prefs_ArrowKeyMethod = Off
   
   If prefs_ArrowKeyMethod not in First,Off,LastWord,LastPosition
   {
      prefs_ArrowKeyMethod := dft_ArrowKeyMethod
   }
   
   If prefs_DetectMouseClickMove not in On,Off
      prefs_DetectMouseClickMove := dft_DetectMouseClickMove
   
   If prefs_NoBackSpace not in On,Off
      prefs_NoBackSpace := dft_NoBackSpace
      
   If prefs_AutoSpace not in On,Off
      prefs_AutoSpace := dft_AutoSpace
   
   if prefs_ShowLearnedFirst not in On,Off
      prefs_ShowLearnedFirst := dft_ShowLearnedFirst
   
   if prefs_SuppressMatchingWord not in On,Off
      prefs_SuppressMatchingWord := dft_SuppressMatchingWord
   
   if prefs_SendMethod not in 1,2,3,1C,2C,3C,4C
      prefs_SendMethod := dft_SendMethod
   
   ;SendPlay does not work when not running as Administrator, switch to SendInput
   If not A_IsAdmin
   {
      IfEqual, prefs_SendMethod, 1
      {
         prefs_SendMethod = 2
      } else IfEqual, prefs_SendMethod, 1C
      {
         prefs_SendMethod = 2C   
      }
   }
   
   IfEqual, prefs_TerminatingCharacters,
      prefs_TerminatingCharacters := dft_TerminatingCharacters
      
   if prefs_ListBoxFontFixed not in On,Off
      prefs_ListBoxFontFixed := dft_ListBoxFontFixed
   
   If prefs_ListBoxFontSize is not Integer
   {
      prefs_ListBoxFontSize := dft_ListBoxFontSize
   }
   else IfLess, prefs_ListBoxFontSize, 2
   {
      prefs_ListBoxFontSize = 2
   }
   
   if dft_ListBoxOffset is not Integer
   {
      dft_ListBoxOffset := "<Computed>"
   }
   
   if prefs_ListBoxOffset is not Integer
   {
      if !(prefs_ListBoxOffset == "<Computed>")
      {
         prefs_ListBoxOffset := dft_ListBoxOffset
      }
   }
   
   if prefs_ListBoxOffset is Integer
   {
      g_ListBoxOffsetComputed := prefs_ListBoxOffset
   } else {
      ; There are 72 points in an inch. Font size is measured in points.
      g_ListBoxOffsetComputed := Ceil(prefs_ListBoxFontSize * A_ScreenDPI / 72)
   }
   
   if dft_ListBoxCharacterWidth is not Integer
   {
      dft_ListBoxCharacterWidth := "<Computed>"
   }
   
   if prefs_ListBoxCharacterWidth is not Integer
   {
      if !(prefs_ListBoxCharacterWidth == "<Computed>")
      {
         prefs_ListBoxCharacterWidth := dft_ListBoxCharacterWidth
      }
   }
   
   if prefs_ListBoxCharacterWidth is Integer
   {
      g_ListBoxCharacterWidthComputed := prefs_ListBoxCharacterWidth
   } else {
      ; There are 72 points in an inch. Font size is measured in points. Most fonts have a width 3/5 the size of their height
      g_ListBoxCharacterWidthComputed := Ceil(prefs_ListBoxFontSize * A_ScreenDPI / 72 * 0.6)
   }
   
   if dft_ListBoxMaxWidth is not Integer
   {
      dft_ListBoxMaxWidth =
   }
   
   if prefs_ListBoxMaxWidth is not Integer
   {
      prefs_ListBoxMaxWidth := dft_ListBoxMaxWidth
   }
   
   if !prefs_ListBoxMaxWidth
   {
      ; skip out
   } else if prefs_ListBoxMaxWidth is Integer
   {
      IfLess, prefs_ListBoxMaxWidth, 100
         prefs_ListBoxMaxWidth = 100
   }
      
   If prefs_ListBoxOpacity is not Integer
      prefs_ListBoxOpacity := dft_ListBoxOpacity
   
   IfLess, prefs_ListBoxOpacity, 0
      prefs_ListBoxOpacity = 0
   else IfGreater, prefs_ListBoxOpacity, 255
      prefs_ListBoxOpacity = 255
                  
   If prefs_ListBoxRows is not Integer
      prefs_ListBoxRows := dft_ListBoxRows
   
   IfLess, prefs_ListBoxRows, 3
      prefs_ListBoxRows = 3
   else IfGreater, prefs_ListBoxRows, 30
      prefs_ListBoxRows = 30
            
   Return
}

ParseTerminatingCharacters(){
   global prefs_TerminatingCharacters
   global g_TerminatingCharactersParsed
   global g_TerminatingEndKeys
   
   Loop, Parse, prefs_TerminatingCharacters
   {
      IfEqual, OpenWord, 1
      {
         If ( A_LoopField == "}" )
         {
            OpenWord =
            IF !(Word)
               TempCharacters .= "{}"
            else If ( Word = "{" || Word = "}")
               TempCharacters .= Word
            else
               TempEndKeys .= "{" . Word . "}"
            
            Word =
         } else 
         {
            Word .= A_LoopField
         }
      } else if ( A_LoopField  == "{" )
      {
         OpenWord = 1
      } else
      {
         TempCharacters .= A_LoopField
      }
   }
      
   IfNotEqual, Word,
      TempCharacters .= Word
   
   g_TerminatingCharactersParsed := TempCharacters
   g_TerminatingEndKeys := TempEndKeys
}

SavePreferences(PrefsToSave){
   global
   local index
   local element
   local KeyName
   local PrefsExist
   
   ValidatePreferences()
   
   IfExist, %g_PrefsFile%
   {
      PrefsExist := true
   } else {
      PrefsExist := false
   }
      
   for index, element in PrefsToSave
   {
      if (substr(element, 1, 6) == "prefs_")
      {
         StringTrimLeft, KeyName, element, 6
      } else {
         KeyName := element
      }
   
      If (%element% == dft_%KeyName%)
      {
         ; Make sure preferences already exist so we don't create 0 byte file
         if (PrefsExist == true)
         {
            IniDelete, %g_PrefsFile%,% g_PrefsSections[KeyName], %KeyName%
         }
      } else {
         IniWrite,% %element%, %g_PrefsFile%,% g_PrefsSections[KeyName], %KeyName%
      }
   }
   
   Return
}

ConstructHelpStrings(){
   global

helpinfo_LearnMode=
(
;"Learn new words as you type" defines whether or not the script should learn new words as you type them, either On or Off.
)

helpinfo_LearnLength=
(
;"Minimum length of words to learn" is the minimum number of characters in a word for it to be learned. This must be at least Length+1.
)

helpinfo_LearnCount=
(
;"Add to wordlist after X times" defines the number of times you have to type a word within a single session for it to be learned permanently.
)

helpinfo_ListBoxRows=
(
;"Maximum number of results to show" is the maximum number of rows to show in the ListBox. This value can range from 3 to 30.
)

helpinfo_Length=
(
;"Show wordlist after X characters" is the minimum number of characters that need to be typed before the program shows a List of words.
;For example, if you need to autocomplete "assemble" in the word list, set this to 2, type 'as' and a list will appear.
)

helpinfo_SendMethod=
(
;"Send Method" is used to change the way the program sends the keys to the screen, this is included for compatibility reasons.
;Try changing this only when you encounter a problem with key sending during autocompletion.
;  1 = Fast method that reliably buffers key hits while sending. HAS BEEN KNOWN TO NOT FUNCTION ON SOME MACHINES.
;      If the script detects that this method will not work on the machine, it will switch to method 2.
;      (Might not work with characters that cannot be typed using the current keyboard layout.)
;  2 = Fastest method with unreliable keyboard buffering while sending. Has been known to not function on some machines.
;  3 = Slowest method, will not buffer or accept keyboard input while sending. Most compatible method.
;The options below use the clipboard to copy and paste the data to improve speed, but will leave an entry in any clipboard 
;history tracking routines you may be running. Data on the clipboard *will* be preserved prior to autocompletion.
;  4 = Same as 1 above.
;  5 = Same as 2 above, doesn't work on some machines.
;  6 = Same as 3 above.
;  7 = Alternate method.
)

helpinfo_DisabledAutoCompleteKeys=
(
;"Auto Complete Keys" is used to enable or disable hotkeys for autocompleting the selected item in the list.
)

helpinfo_ArrowKeyMethod=
(
;"Wordlist row highlighting" is the way the arrow keys are handled when a list is shown.
;Options are:
;  Off - only use the number keys
;  First - resets the highlighted row to the beginning whenever you type a new character
;  LastWord - keeps the highlighted row on the prior selected word if it's still in the list, else resets to the beginning
;  LastPosition - maintains the highlighted row's position
)

helpinfo_NoBackSpace=
(
;"Case correction" is used to correct the case of any previously typed characters.
;  On - characters you have already typed will be backspaced and replaced with the case of the word you have chosen.
;  Off - characters you have already typed will not be changed
)

helpinfo_DetectMouseClickMove=
(
;"Monitor mouse clicks" is used to detect when the cursor is moved with the mouse.
; On - %g_ScriptTitle% will not work when used with an On-Screen keyboard.
; Off - %g_ScriptTitle% will not detect when the cursor is moved within the same line using the mouse, and scrolling the text will clear the list.
)

helpinfo_AutoSpace=
(
;"Type space after autocomplete" is used to automatically add a space to the end of an autocompleted word.
; On - Add a space to the end of the autocompleted word.
; Off - Do not add a space to the end of the autocompleted word.
)

helpinfo_DoNotLearnStrings=
(
;"Sub-strings to not learn" is a comma separated list of strings. Any words which contain any of these strings will not be learned.
;This can be used to prevent the program from learning passwords or other critical information.
;For example, if you have ord98 in "Sub-strings to not learn", password987 will not be learned.
)

helpinfo_SuppressMatchingWord=
(
;"Suppress matching word" is used to suppress a word from the Word list if it matches the typed word.
;  If "Case correction" is On, then the match is case-sensitive.
;  If "Case correction" is Off, then the match is case in-sensitive.
; On - Suppress matching word from the word list.
; Off - Do not suppress matching word from the word list.
)

helpinfo_NumPresses=
(
;"Number of presses" is the number of times the number hotkey must be tapped for the word to be selected, either 1 or 2.
)

helpinfo_ShowLearnedFirst=
(
;"Show learned words first" controls whether the learned words appear before or after the words from Wordlist.txt.
)

helpinfo_ListBoxOffset=
(
;"Pixels below cursor override" is the number of pixels below the top of the caret (vertical blinking line) to display the list.
)

helpinfo_ListBoxFontFixed=
(
;"Fixed width font in list" controls whether a fixed or variable character font width is used.
;(e.g., in fixed width, "i" and "w" take the same number of pixels)
)

helpinfo_ListBoxFontSize=
(
;"Font size in list" controls the size of the font in the list.
)

helpinfo_ListBoxOpacity=
(
;"list opacity" is how transparent (see-through) the Wordlist Box should be. Use a value of 255 to make it so the
;Wordlist Box is fully ypaque, or use a value of 0 to make it so the Wordlist Box cannot be seen at all.
)

helpinfo_ListBoxCharacterWidth=
(
;"List character width override" is the width (in pixels) of one character in the Wordlist Box.
;This number should only need to be changed if the box containing the list is not the correct width.
;Some things which may cause this to need to be changed would include:
; 1. Changing the Font DPI in Windows
; 2. Changing the "Fixed width font in list" setting
; 3. Changing the "Font size in list" setting
;Leave this blank to let %g_ScriptTitle% try to compute the width.
)

helpinfo_ListBoxFontOverride=
(
;"List font" is used to specify a font for the Wordlist Box to use. The default for Fixed is Courier,
;and the default for Variable is Tahoma.
)

helpinfo_ListBoxMaxWidth=
(
;"List max width in pixels" is used to specify the maximum width for the Wordlist Box in pixels. By default, this will not expand beyond the width of the current monitor.
)

helpinfo_ListBoxNotDPIAwareProgramExecutables=
(
;"Processes which are not DPI Aware" is a list of executable (.exe) files that %g_ScriptTitle% needs to compensate for when scaling the listbox at DPI settings higher than 100`% (96 DPI).
)

helpinfo_IncludeProgramTitles=
(
;"Window titles you want %g_ScriptTitle% enabled for" is a list of strings (separated by | ) to find in the title of the window you want %g_ScriptTitle% enabled for.
;If one of the strings is found in the title, %g_ScriptTitle% is enabled for that window.
)

helpinfo_ExcludeProgramTitles=
(
;"Window titles you want %g_ScriptTitle% disabled for" is a list of strings (separated by | ) to find in the title of the window you want %g_ScriptTitle% disabled for.
;If one of the strings is found in the title, %g_ScriptTitle% is disabled for that window.
)
   
helpinfo_IncludeProgramExecutables=
(
;"Processes you want %g_ScriptTitle% enabled for" is a list of executable (.exe) files that %g_ScriptTitle% should be enabled for.
;If one of the executables matches the current program, %g_ScriptTitle% is enabled for that program.
)

helpinfo_ExcludeProgramExecutables=
(
;"Processes you want %g_ScriptTitle% disabled for" is a list of executable (.exe) files that %g_ScriptTitle% should be disabled for.
;If one of the executables matches the current program, %g_ScriptTitle% is disabled for that program.
)

helpinfo_HelperWindowProgramTitles=
(
;"Window titles you want the helper window enabled for" is a list of strings (separated by | ) to find in the title of the window that the helper window should be automatically enabled for.
;If one of the strings is found in the title, the helper window will pop up automatically for that program.
)

helpinfo_HelperWindowProgramExecutables=
(
;"Processes you want the helper window enabled for" is a list of executable (.exe) files that the helper window should be automatically enabled for.
;If one of the executables matches the current program, the helper window will pop up automatically for that program.
)

helpinfo_TerminatingCharacters=
(
;"Terminating Characters" is a list of characters (EndKey) which will signal the program that you are done typing a word.
;You probably need to change this only when using this with certain programming languages.
;
;Default setting:
;%dft_TerminatingCharacters%
;
; More information on how to configure "Terminating Characters":
;A list of keys may be found here:
; http://www.autohotkey.com/docs/KeyList.htm
;For more details on how to format the list of characters please see the EndKeys section (paragraphs 2,3,4) of:
; http://www.autohotkey.com/docs/commands/Input.htm
)

helpinfo_ForceNewWordCharacters=
(
;"Force New Word Characters" is a comma separated list of characters which forces the program to start a new word whenever
;one of those characters is typed. Any words which begin with one of these characters will never be learned (even
;if learning is enabled). If you were typing a word when you hit one of these characters that word will be learned
;if learning is enabled. Characters in "Force New Word Characters" should not be in "Terminating Characters".
;Change this only if you know what you are doing, it is probably only useful for certain programming languages.
; ex: ForceNewWordCharacters=@,:,#
))

helpinfo_EndWordCharacters=
(
;"End Word Characters" is a comma separated list of characters which forces the program to start end the current
;word whenever one of those characters is typed. Unlike "Terminating Characters", the character becomes the last
;character in the typed word. If you were typing a word when you hit one of these characters that word will be 
;permanently learned. Characters in "Force New Word Characters" should not be in "Terminating Characters".
;Change this only if you know what you are doing, it is probably only useful for certain programming languages.
; ex: EndWordCharacters=@,:,#
)

helpinfo_FullHelpString =
(
%helpinfo_LearnMode%`r`n`r`n%helpinfo_LearnLength%`r`n`r`n%helpinfo_LearnCount%

%helpinfo_DoNotLearnStrings%`r`n`r`n%helpinfo_NumPresses%

%helpinfo_DisabledAutoCompleteKeys%`r`n`r`n%helpinfo_SendMethod%

%helpinfo_NoBackSpace%`r`n`r`n%helpinfo_DetectMouseClickMove%`r`n`r`n%helpinfo_AutoSpace%

%helpinfo_ListBoxRows%`r`n`r`n%helpinfo_Length%`r`n`r`n%helpinfo_ShowLearnedFirst%

%helpinfo_ArrowKeyMethod%`r`n`r`n%helpinfo_SuppressMatchingWord%

%helpinfo_ListBoxOffset%`r`n`r`n%helpinfo_ListBoxFontFixed%`r`n`r`n%helpinfo_ListBoxFontSize%

%helpinfo_ListBoxOpacity%`r`n`r`n%helpinfo_ListBoxCharacterWidth%`r`n`r`n%helpinfo_ListBoxFontOverride%

%helpinfo_ListBoxMaxWidth%`r`n`r`n%helpinfo_ListBoxNotDPIAwareProgramExecutables%

%helpinfo_IncludeProgramTitles%`r`n`r`n%helpinfo_ExcludeProgramTitles%`r`n`r`n%helpinfo_IncludeProgramExecutables%`r`n`r`n%helpinfo_ExcludeProgramExecutables%

%helpinfo_HelperWindowProgramTitles%`r`n`r`n%helpinfo_HelperWindowProgramExecutables%

%helpinfo_TerminatingCharacters%`r`n`r`n%helpinfo_ForceNewWordCharacters%`r`n`r`n%helpinfo_EndWordCharacters%
)

}

;============================== [ Sending ]

; These functions and labels are related to sending the word to the program

SendKey(Key){
   IfEqual, Key, $^Enter
   {
      Key = ^{Enter}
   } else IfEqual, Key, $^Space
   { 
      Key = ^{Space}
   } else {
      Key := "{" . SubStr(Key, 2) . "}"
   }
   
   SendCompatible(Key,1)
   Return
}

;------------------------------------------------------------------------
   
SendWord(WordIndex){
   global g_SingleMatch
   global g_SingleMatchReplacement
   ;Send the word
   if (g_SingleMatchReplacement[WordIndex])
   {
      sending := g_SingleMatchReplacement[WordIndex]
      ForceBackspace := true
   } else {
      sending := g_SingleMatch[WordIndex]
      ForceBackspace := false
   }
   ; Update Typed Count
   UpdateWordCount(sending,0)
   SendFull(sending, ForceBackspace)   
   ClearAllVars(true)
   Return
}  

;------------------------------------------------------------------------
            
SendFull(SendValue,ForceBackspace=false){
   global g_Active_Id
   global g_Word
   global prefs_AutoSpace
   global prefs_NoBackSpace
   global prefs_SendMethod
   
   SwitchOffListBoxIfActive()
   
   BackSpaceLen := StrLen(g_Word)
   
   if (ForceBackspace || prefs_NoBackspace = "Off") {
      BackSpaceWord := true
   }
   
   ; match case on first letter if we are forcing a backspace AND CaseCorrection is off
   if (ForceBackspace && !(prefs_NoBackspace = "Off")) {
      IfEqual, A_IsUnicode, 1
      {
         if ( RegExMatch(Substr(g_Word, 1, 1), "S)\p{Lu}") > 0 )  
         {
            Capitalize := true
         }
      } else if ( RegExMatch(Substr(g_Word, 1, 1), "S)[A-ZÀ-ÖØ-ß]") > 0 )
      {
         Capitalize := true
      }
      
      StringLeft, FirstLetter, SendValue, 1
         StringTrimLeft, SendValue, SendValue, 1
      if (Capitalize) {
         StringUpper, FirstLetter, FirstLetter
      } else {
         StringLower, FirstLetter, FirstLetter
      }
      SendValue := FirstLetter . SendValue
   }
   
   ; if the user chose a word with accented characters, then we need to
   ; substitute those letters into the word
   StringCaseSenseOld := A_StringCaseSense
   StringCaseSense, Locale   
   if (!BackSpaceWord && !(SubStr(SendValue, 1, BackSpaceLen) = g_Word)) {
      BackSpaceWord := true
      
      SendIndex := 1
      WordIndex := 1
      NewSendValue =
      While (WordIndex <= BackSpaceLen) {
         SendChar := SubStr(SendValue, SendIndex, 1)
         WordChar := SubStr(g_Word, WordIndex, 1)
         SendIndex++
         
         if (SendChar = WordChar) {
            WordIndex++
            NewSendValue .= WordChar
         } else {
            
            SendCharNorm := StrUnmark(SendChar)
            ; if character normalizes to more than 1 character, we need
            ; to increment the WordIndex pointer again
            
            StringUpper, SendCharNormUpper, SendCharNorm
            StringLower, SendCharNormLower, SendCharNorm
            StringUpper, SendCharUpper, SendChar
            StringLower, SendCharLower, SendChar
            WordChar := SubStr(g_Word, WordIndex, StrLen(SendCharNorm))
            
            if (SendCharNorm == WordChar) {
               NewSendValue .= SendChar
            } else if (SendCharNormUpper == WordChar) {
               NewSendValue .= SendCharUpper
            } else if (SendCharNormLower == WordChar) {
               NewSendValue .= SendCharLower
            } else {
               NewSendValue .= SendChar
            }
            WordIndex += StrLen(SendCharNorm)
         }
      }
      
      NewSendValue .= SubStr(SendValue, SendIndex, StrLen(SendValue) - SendIndex + 1)
      
      SendValue := NewSendValue
   }
   StringCaseSense, %StringCaseSenseOld%
   
   ; If we are not backspacing, remove the typed characters from the string to send
   if !(BackSpaceWord)
   {
      StringTrimLeft, SendValue, SendValue, %BackSpaceLen%
   }
   
   ; if autospace is on, add a space to the string to send
   IfEqual, prefs_AutoSpace, On
      SendValue .= A_Space
   
   IfEqual, prefs_SendMethod, 1
   {
      ; Shift key hits are here to account for an occassional bug which misses the first keys in SendPlay
      sending = {Shift Down}{Shift Up}{Shift Down}{Shift Up}      
      if (BackSpaceWord)
      {
         sending .= "{BS " . BackSpaceLen . "}"
      }
      sending .= "{Raw}" . SendValue
         
      SendPlay, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }

   if (BackSpaceWord)
   {
      sending = {BS %BackSpaceLen%}{Raw}%SendValue%
   } Else {
      sending = {Raw}%SendValue%
   }
   
   IfEqual, prefs_SendMethod, 2
   {
      SendInput, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt)      
      Return
   }

   IfEqual, prefs_SendMethod, 3
   {
      SendEvent, %sending% ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }
   
   ClipboardSave := ClipboardAll
   Clipboard = 
   Clipboard := SendValue
   ClipWait, 0
   
   if (BackSpaceWord)
   {
      sending = {BS %BackSpaceLen%}{Ctrl Down}v{Ctrl Up}
   } else {
   sending = {Ctrl Down}v{Ctrl Up}
   }
   
   IfEqual, prefs_SendMethod, 1C
   {
      sending := "{Shift Down}{Shift Up}{Shift Down}{Shift Up}" . sending
      SendPlay, %sending% ; First do the backspaces, Then send word via clipboard
   } else IfEqual, prefs_SendMethod, 2C
   {
      SendInput, %sending% ; First do the backspaces, Then send word via clipboard
   } else IfEqual, prefs_SendMethod, 3C
   {
      SendEvent, %sending% ; First do the backspaces, Then send word via clipboard
   } else {
      ControlGetFocus, ActiveControl, ahk_id %g_Active_Id%
      IfNotEqual, ActiveControl,
         ControlSend, %ActiveControl%, %sending%, ahk_id %g_Active_Id%
   }
         
   Clipboard := ClipboardSave
   Return
}

;------------------------------------------------------------------------

SendCompatible(SendValue,ForceSendForInput){
   global g_IgnoreSend
   global prefs_SendMethod
   IfEqual, ForceSendForInput, 1
   {
      g_IgnoreSend = 
      SendEvent, %SendValue%
      Return
   }
   
   SendMethodLocal := SubStr(prefs_SendMethod, 1, 1)
   IF ( ( SendMethodLocal = 1 ) || ( SendMethodLocal = 2 ) )
   {
      SendInput, %SendValue%
      Return
   }

   IF ( ( SendMethodLocal = 3 ) || ( SendMethodLocal = 4 ) )
   {
      g_IgnoreSend = 1
      SendEvent, %SendValue%
      Return
   }
   
   SendInput, %SendValue%   
   Return
}

;------------------------------------------------------------------------

;============================== [ Settings ]

; GUI for TypingAid configuration
; by HugoV / Maniac

LaunchSettings:
if (g_InSettings == true)
{
   return
}
InactivateAll()
Menu, Tray, Disable, Settings
g_InSettings := true
ClearAllVars(True)
Menu_OldLearnCount := prefs_LearnCount
; initialize this to make sure the object exists
Menu_ChangedPrefs := Object()
ConstructGui()
; Call "HandleMessage" when script receives WM_SETCURSOR message
OnMessage(g_WM_SETCURSOR, "HandleSettingsMessage")
; Call "HandleMessage" when script receives WM_MOUSEMOVE message
OnMessage(g_WM_MOUSEMOVE, "HandleSettingsMessage")
; clear and re-initialize variables after constructing the GUI as some controls call the edit flag immediately
Menu_ChangedPrefs =
Menu_ChangedPrefs := Object()
Menu_ValueChanged := false
Return

ConstructGui(){
   global prefs_ArrowKeyMethod, prefs_AutoSpace, prefs_DetectMouseClickMove, prefs_DisabledAutoCompleteKeys, prefs_DoNotLearnStrings
   global helpinfo_ArrowKeyMethod, helpinfo_AutoSpace, helpinfo_DetectMouseClickMove, helpinfo_DisabledAutoCompleteKeys, helpinfo_DoNotLearnStrings
   global prefs_EndWordCharacters, prefs_ForceNewWordCharacters, prefs_LearnCount, prefs_LearnLength, prefs_LearnMode, prefs_Length
   global helpinfo_EndWordCharacters, helpinfo_ForceNewWordCharacters, helpinfo_LearnCount, helpinfo_LearnLength, helpinfo_LearnMode, helpinfo_Length
   global prefs_NoBackSpace, prefs_NumPresses, prefs_SendMethod, prefs_ShowLearnedFirst, prefs_SuppressMatchingWord, prefs_TerminatingCharacters
   global helpinfo_NoBackSpace, helpinfo_NumPresses, helpinfo_SendMethod, helpinfo_ShowLearnedFirst, helpinfo_SuppressMatchingWord, helpinfo_TerminatingCharacters
   global prefs_ExcludeProgramExecutables, prefs_ExcludeProgramTitles, prefs_IncludeProgramExecutables, prefs_IncludeProgramTitles, prefs_HelperWindowProgramExecutables, prefs_HelperWindowProgramTitles
   global helpinfo_ExcludeProgramExecutables, helpinfo_ExcludeProgramTitles, helpinfo_IncludeProgramExecutables, helpinfo_IncludeProgramTitles, helpinfo_HelperWindowProgramExecutables, helpinfo_HelperWindowProgramTitles
   global prefs_ListBoxCharacterWidth, prefs_ListBoxFontFixed, prefs_ListBoxFontOverride, prefs_ListBoxFontSize, prefs_ListBoxMaxWidth, prefs_ListBoxOffset, prefs_ListBoxOpacity, prefs_ListBoxRows
   global helpinfo_ListBoxCharacterWidth, helpinfo_ListBoxFontFixed, helpinfo_ListBoxFontOverride, helpinfo_ListBoxFontSize, helpinfo_ListBoxMaxWidth, helpinfo_ListBoxOffset, helpinfo_ListBoxOpacity, helpinfo_ListBoxRows
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global helpinfo_ListBoxNotDPIAwareProgramExecutables
   global helpinfo_FullHelpString
   global Menu_ArrowKeyMethodOptionsText, Menu_CaseCorrection, Menu_ListBoxOpacityUpDown, Menu_SendMethodOptionsCode, Menu_SendMethodC
   global Menu_CtrlEnter, Menu_CtrlSpace, Menu_Enter, Menu_SingleClick, Menu_NumberKeys, Menu_NumpadEnter, Menu_RightArrow, Menu_Tab
   global g_ScriptTitle
   ; Must be global for colors to function, colors will not function if static
   global Menu_VisitForum
   
   Menu_CaseCorrection=
   Menu_ArrowKeyMethodOptionsText=
   
   MenuFontList:=Writer_enumFonts() ; see note at function for credit

   MenuGuiWidth=700
   MenuGuiHeight=480
   MenuGuiRows = 8
   MenuGuiHelpIcon = %A_Space%(?)%A_Space%

   MenuSeparatorX = 10
   MenuSeparatorY = 8
   MenuEditIndentX = 10
   MenuEditIndentY = 20
   MenuHelpIndentX = 30
   MenuHelpIndentY = 0
   
   MenuRowHeight := (MenuGuiHeight - ((MenuGuiRows +1 ) * MenuSeparatorY ))/MenuGuiRows

   MenuTextMenuRowY := (MenuRowHeight - 6 ) / 3

   MenuTabWidth:=MenuGuiWidth-4
   MenuTabHeight:=MenuGuiHeight-75
   MenuTabHeightEdit:=MenuTabHeight-40

   MenuOneColGroupWidth := MenuGuiWidth - (2 * MenuSeparatorX)
   MenuTwoColGroupWidth := (MenuGuiWidth - (3 * MenuSeparatorX))/2
   MenuThreeColGroupWidth := (MenuGuiWidth - (4 * MenuSeparatorX))/3
   MenuDualThreeColGroupWidth := (MenuThreeColGroupWidth * 2) + MenuSeparatorX

   MenuOneColEditWidth := MenuOneColGroupWidth - (MenuEditIndentX * 2)
   MenuTwoColEditWidth := MenuTwoColGroupWidth - (MenuEditIndentX * 2)
   MenuThreeColEditWidth := MenuThreeColGroupWidth - (MenuEditIndentX * 2)
   MenuOneColEditWidthEdit := MenuOneColEditWidth - 140
   MenuOneColEditButton := MenuOneColEditWidthEdit + 30

   MenuGroup1BoxX := MenuSeparatorX
   MenuGroup1EditX := MenuGroup1BoxX + MenuEditIndentX
   MenuGroup1of1HelpX := MenuGroup1BoxX + MenuOneColGroupWidth - MenuHelpIndentX
   MenuGroup1of2HelpX := MenuGroup1BoxX + MenuTwoColGroupWidth - MenuHelpIndentX
   MenuGroup1of3HelpX := MenuGroup1BoxX + MenuThreeColGroupWidth - MenuHelpIndentX

   MenuGroup2of2BoxX := MenuGroup1BoxX + MenuTwoColGroupWidth + MenuSeparatorX
   MenuGroup2of2EditX := MenuGroup2of2BoxX + MenuEditIndentX
   MenuGroup2of2HelpX := MenuGroup2of2BoxX + MenuTwoColGroupWidth - MenuHelpIndentX
   
   MenuGroup2of3BoxX := MenuGroup1BoxX + MenuThreeColGroupWidth + MenuSeparatorX
   MenuGroup2of3EditX := MenuGroup2of3BoxX + MenuEditIndentX
   MenuGroup2of3HelpX := MenuGroup2of3BoxX + MenuThreeColGroupWidth - MenuHelpIndentX
   
   MenuGroup3of3BoxX := MenuGroup2of3BoxX + MenuThreeColGroupWidth + MenuSeparatorX
   MenuGroup3of3EditX := MenuGroup3of3BoxX + MenuEditIndentX
   MenuGroup3of3HelpX := MenuGroup3of3BoxX + MenuThreeColGroupWidth - MenuHelpIndentX
   
   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Font, s8, Arial

   Gui, MenuGui:Add, Tab2, x2 w%MenuTabWidth% h%MenuTabHeight%, General Settings|Wordlist Box|Programs|Advanced (Experts Only)|About && Help

   Gui, MenuGui:Tab, 1 ; General Settings

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Learn new words as you type
   Menu_LearnModeOptions=|On|Off|
   StringReplace, Menu_LearnModeOptions, Menu_LearnModeOptions, |%prefs_LearnMode%|,|%prefs_LearnMode%||
   StringTrimLeft, Menu_LearnModeOptions, Menu_LearnModeOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_LearnMode gEditValue, %Menu_LearnModeOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_LearnMode gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack


   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Minimum length of word to learn
   Menu_LearnLengthOptions=|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
   StringReplace,  Menu_LearnLengthOptions, Menu_LearnLengthOptions, |%prefs_LearnLength%|,|%prefs_LearnLength%||
   StringTrimLeft, Menu_LearnLengthOptions, Menu_LearnLengthOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_LearnLength gEditValue, %Menu_LearnLengthOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_LearnLength gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack
   

   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight%, Add to wordlist after X times
   Menu_LearnCountOptions=|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
   StringReplace,  Menu_LearnCountOptions, Menu_LearnCountOptions, |%prefs_LearnCount%|,|%prefs_LearnCount%||
   StringTrimLeft, Menu_LearnCountOptions, Menu_LearnCountOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_LearnCount gEditValue, %Menu_LearnCountOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_LearnCount gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack
   

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuTwoColGroupWidth% h%MenuRowHeight% , Sub-strings to not learn
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuTwoColEditWidth% r1 vprefs_DoNotLearnStrings Password gEditValue, %prefs_DoNotLearnStrings%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of2HelpX% y%MenuRowHelpY% vhelpinfo_DoNotLearnStrings gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of2BoxX% y%MenuRowY% w%MenuTwoColGroupWidth% h%MenuRowHeight% , Number of presses
   Menu_NumPressesOptions=|1|2|
   StringReplace,  Menu_NumPressesOptions, Menu_NumPressesOptions, |%prefs_NumPresses%|,|%prefs_NumPresses%||
   StringTrimLeft, Menu_NumPressesOptions, Menu_NumPressesOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of2EditX% y%MenuRowEditY% w%MenuTwoColEditWidth% r5 vprefs_NumPresses gEditValue, %Menu_NumPressesOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of2HelpX% y%MenuRowHelpY% vhelpinfo_NumPresses gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack


   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuDualThreeColGroupWidth% h%MenuRowHeight% , Auto Complete Keys
   ;  E = Ctrl + Enter
   ;  S = Ctrl + Space
   ;  T = Tab
   ;  R = Right Arrow
   ;  N = Number Keys
   ;  U = Enter
   ;  L = Single Click
   ;  M = Numpad Enter
   Menu_CheckedE=Checked
   Menu_CheckedS=Checked
   Menu_CheckedT=Checked
   Menu_CheckedR=Checked
   Menu_CheckedN=Checked
   Menu_CheckedU=Checked
   Menu_CheckedL=Checked
   Menu_CheckedM=Checked
   Loop, parse, prefs_DisabledAutoCompleteKeys
   {
     If (A_LoopField = "E")
       Menu_CheckedE =
     If (A_LoopField = "S")
       Menu_CheckedS =
     If (A_LoopField = "T")
       Menu_CheckedT =
     If (A_LoopField = "R")
       Menu_CheckedR =
     If (A_LoopField = "N")
       Menu_CheckedN =
     If (A_LoopField = "U")
       Menu_CheckedU =
     If (A_LoopField = "L")
       Menu_CheckedL =
     If (A_LoopField = "M")
       Menu_CheckedM =
   }

   MenuCheckmarkIndent := MenuTwoColEditWidth/3 + MenuEditIndentX
   Gui, MenuGui:Add, Checkbox, x%MenuGroup1EditX% yp+%MenuTextMenuRowY% vMenu_CtrlEnter gEditValue %Menu_CheckedE%, Ctrl + Enter
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_Tab gEditValue %Menu_CheckedT%, Tab
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_RightArrow gEditValue %Menu_CheckedR%, Right Arrow
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_SingleClick gEditValue %Menu_CheckedL%, Single Click
   Gui, MenuGui:Add, Checkbox, x%MenuGroup1EditX% yp+%MenuTextMenuRowY% vMenu_CtrlSpace gEditValue %Menu_CheckedS%, Ctrl + Space
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_NumberKeys gEditValue %Menu_CheckedN%, Number Keys
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_Enter gEditValue %Menu_CheckedU%, Enter
   Gui, MenuGui:Add, Checkbox, xp%MenuCheckmarkIndent% yp vMenu_NumpadEnter gEditValue %Menu_CheckedM%, Numpad Enter

   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_DisabledAutoCompleteKeys gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack


   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Send Method
   Menu_SendMethodOptionsText=1 - Default (Type)|2 - Fast (Type)|3 - Slow (Type)|4 - Default (Paste)|5 - Fast (Paste)|6 - Slow (Paste)|7 - Alternate method
   Menu_SendMethodOptionsCode=1|2|3|1C|2C|3C|4C
   Loop, parse, Menu_SendMethodOptionsCode, |
   {
     If (prefs_SendMethod = A_LoopField)
       Menu_SendCount:=A_Index
   }

   Loop, parse, Menu_SendMethodOptionsText, |
   {
     Menu_SendMethodOptions .= A_LoopField "|"
     If (A_Index = Menu_SendCount)
       Menu_SendMethodOptions .= "|"
   }   
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vMenu_SendMethodC gEditValue altsubmit, %Menu_SendMethodOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_SendMethod gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack
   

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Case correction
   Menu_CaseCorrectionOptions=|On|Off|
   If (prefs_NoBackSpace = "on")
     Menu_CaseCorrection=Off
   Else If (prefs_NoBackSpace = "off")
     Menu_CaseCorrection=On
   StringReplace,  Menu_CaseCorrectionOptions, Menu_CaseCorrectionOptions, |%Menu_CaseCorrection%|,|%Menu_CaseCorrection%||
   StringTrimLeft, Menu_CaseCorrectionOptions, Menu_CaseCorrectionOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vMenu_CaseCorrection gEditValue, %Menu_CaseCorrectionOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_NoBackSpace gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack


   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Monitor mouse clicks 
   Menu_DetectMouseClickMoveOptions=|On|Off|
   StringReplace,  Menu_DetectMouseClickMoveOptions, Menu_DetectMouseClickMoveOptions, |%prefs_DetectMouseClickMove%|,|%prefs_DetectMouseClickMove%||
   StringTrimLeft, Menu_DetectMouseClickMoveOptions, Menu_DetectMouseClickMoveOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_DetectMouseClickMove gEditValue, %Menu_DetectMouseClickMoveOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_DetectMouseClickMove gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Type space after autocomplete
   Menu_AutoSpaceOptions=|On|Off|
   StringReplace,  Menu_AutoSpaceOptions, Menu_AutoSpaceOptions, |%prefs_AutoSpace%|,|%prefs_AutoSpace%||
   StringTrimLeft, Menu_AutoSpaceOptions, Menu_AutoSpaceOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_AutoSpace gEditValue, %Menu_AutoSpaceOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_AutoSpace gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Tab, 2 ; listbox ---------------------------------------------------------


   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Show wordlist after X characters
   Menu_LengthOptions=|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
   StringReplace,  Menu_LengthOptions, Menu_LengthOptions, |%prefs_Length%|,|%prefs_Length%||
   StringTrimLeft, Menu_LengthOptions, Menu_LengthOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_Length gEditValue, %Menu_LengthOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_Length gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Maximum number of results to show
   Menu_ListBoxRowsOptions=|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|
   StringReplace,  Menu_ListBoxRowsOptions, Menu_ListBoxRowsOptions, |%prefs_ListBoxRows%|,|%prefs_ListBoxRows%||
   StringTrimLeft, Menu_ListBoxRowsOptions, Menu_ListBoxRowsOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_ListBoxRows gEditValue, %Menu_ListBoxRowsOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxRows gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Show learned words first
   Menu_ShowLearnedFirstOptions=|On|Off|
   StringReplace,  Menu_ShowLearnedFirstOptions, Menu_ShowLearnedFirstOptions, |%prefs_ShowLearnedFirst%|,|%prefs_ShowLearnedFirst%||
   StringTrimLeft, Menu_ShowLearnedFirstOptions, Menu_ShowLearnedFirstOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% vprefs_ShowLearnedFirst gEditValue, %Menu_ShowLearnedFirstOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_ShowLearnedFirst gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuTwoColGroupWidth% h%MenuRowHeight% , Wordlist row highlighting
   Menu_ArrowKeyMethodOptionsText=Off - only use the number keys|First - reset selected word to the beginning|LastWord - keep last word selected|LastPosition - keep the last cursor position
   Loop, parse, Menu_ArrowKeyMethodOptionsText, |
   {
     Menu_ArrowKeyMethodOptions .= A_LoopField "|"
     StringSplit, Split, A_LoopField, -
      Split1 := Trim(Split1)
     If (Split1 = prefs_ArrowKeyMethod)
     {
       Menu_ArrowKeyMethodOptions .= "|"
     }   
   }

   Gui, MenuGui:Add, DDL, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuTwoColEditWidth% r5 vprefs_ArrowKeyMethod gEditValue altsubmit, %Menu_ArrowKeyMethodOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of2HelpX% y%MenuRowHelpY% vhelpinfo_ArrowKeyMethod gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of2BoxX% y%MenuRowY% w%MenuTwoColGroupWidth% h%MenuRowHeight% , Suppress matching word
   Menu_SuppressMatchingWordOptions=|On|Off|
   StringReplace,  Menu_SuppressMatchingWordOptions, Menu_SuppressMatchingWordOptions, |%prefs_SuppressMatchingWord%|,|%prefs_SuppressMatchingWord%||
   StringTrimLeft, Menu_SuppressMatchingWordOptions, Menu_SuppressMatchingWordOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of2EditX% y%MenuRowEditY% w%MenuTwoColEditWidth% vprefs_SuppressMatchingWord gEditValue, %Menu_SuppressMatchingWordOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of2HelpX% y%MenuRowHelpY% vhelpinfo_SuppressMatchingWord gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Pixels below cursor override
   Menu_ListBoxOffsetOptions=|<Computed>|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32
   StringReplace,  Menu_ListBoxOffsetOptions, Menu_ListBoxOffsetOptions, |%prefs_ListBoxOffset%|,|%prefs_ListBoxOffset%||
   StringTrimLeft, Menu_ListBoxOffsetOptions, Menu_ListBoxOffsetOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_ListBoxOffset gEditValue, %Menu_ListBoxOffsetOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxOffset gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Fixed width font in list
   Menu_ListBoxFontFixedOptions=|On|Off|
   StringReplace,  Menu_ListBoxFontFixedOptions, Menu_ListBoxFontFixedOptions, |%prefs_ListBoxFontFixed%|,|%prefs_ListBoxFontFixed%||
   StringTrimLeft, Menu_ListBoxFontFixedOptions, Menu_ListBoxFontFixedOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_ListBoxFontFixed gEditValue, %Menu_ListBoxFontFixedOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxFontFixed gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , Font size in list
   Menu_ListBoxFontSizeOptions=|8|9|10|11|12|13|14|15|16|17|18|19|20|
   StringReplace,  Menu_ListBoxFontSizeOptions, Menu_ListBoxFontSizeOptions, |%prefs_ListBoxFontSize%|,|%prefs_ListBoxFontSize%||
   StringTrimLeft, Menu_ListBoxFontSizeOptions, Menu_ListBoxFontSizeOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_ListBoxFontSize gEditValue, %Menu_ListBoxFontSizeOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxFontSize gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , List opacity
   Gui, MenuGui:Add, Edit, xp+10 yp+20 w%MenuThreeColEditWidth% vprefs_ListBoxOpacity gEditValue, %prefs_ListBoxOpacity%
   Gui, MenuGui:Add, UpDown, xp+10 yp+20 w%MenuThreeColEditWidth% vMenu_ListBoxOpacityUpDown Range0-255, %prefs_ListBoxOpacity%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxOpacity gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup2of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , List character width override
   Menu_ListBoxCharacterWidthOptions=|<Computed>|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|
   StringReplace,  Menu_ListBoxCharacterWidthOptions, Menu_ListBoxCharacterWidthOptions, |%prefs_ListBoxCharacterWidth%|,|%prefs_ListBoxCharacterWidth%||
   StringTrimLeft, Menu_ListBoxCharacterWidthOptions, Menu_ListBoxCharacterWidthOptions, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup2of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r5 vprefs_ListBoxCharacterWidth gEditValue, %Menu_ListBoxCharacterWidthOptions%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup2of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxCharacterWidth gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   Gui, MenuGui:Add, GroupBox, x%MenuGroup3of3BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , List font
   sort, MenuFontList, D|
   MenuFontList := "|<Default>|" . MenuFontList
   If (MenuListBoxFont = "") or (MenuListBoxFont = " ")
   {
      StringReplace, MenuFontList, MenuFontList, |%prefs_ListBoxFontOverride%|, |%prefs_ListBoxFontOverride%||
   }
   ; remove the extra leading "|" we added for searching
   StringTrimLeft, MenuFontList, MenuFontList, 1
   Gui, MenuGui:Add, DDL, x%MenuGroup3of3EditX% y%MenuRowEditY% w%MenuThreeColEditWidth% r10 w200 vprefs_ListBoxFontOverride gEditValue, %MenuFontList%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup3of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxFontOverride gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuThreeColGroupWidth% h%MenuRowHeight% , List max width in pixels
   Gui, MenuGui:Add, Edit, xp+10 yp+20 w%MenuThreeColEditWidth% vprefs_ListBoxMaxWidth gEditValue, %prefs_ListBoxMaxWidth%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of3HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxMaxWidth gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Processes which are not DPI Aware
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_ListBoxNotDPIAwareProgramExecutables gEditValue, %prefs_ListBoxNotDPIAwareProgramExecutables%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetNotDPIAwareProcess, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_ListBoxNotDPIAwareProgramExecutables gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY


   Gui, MenuGui:Tab, 3 ; Programs ---------------------------------------------------------


   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Window titles you want %g_ScriptTitle% enabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_IncludeProgramTitles gEditValue, %prefs_IncludeProgramTitles%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetEnableTitles, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_IncludeProgramTitles gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack
   
   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Window titles you want %g_ScriptTitle% disabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_ExcludeProgramTitles gEditValue, %prefs_ExcludeProgramTitles%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetDisableTitles, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_ExcludeProgramTitles gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Processes you want %g_ScriptTitle% enabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_IncludeProgramExecutables gEditValue, %prefs_IncludeProgramExecutables%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetEnableProcess, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_IncludeProgramExecutables gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Processes you want %g_ScriptTitle% disabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_ExcludeProgramExecutables gEditValue, %prefs_ExcludeProgramExecutables%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetDisableProcess, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_ExcludeProgramExecutables gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   ;HelperWindowProgramTitles

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Window titles you want the helper window enabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_HelperWindowProgramTitles gEditValue, %prefs_HelperWindowProgramTitles%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetHelpTitles, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_HelperWindowProgramTitles gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   ;HelperWindowProgramExecutables

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Processes you want the helper window enabled for
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidthEdit% r1 vprefs_HelperWindowProgramExecutables gEditValue, %prefs_HelperWindowProgramExecutables%
   Gui, MenuGui:Add, Button, x%MenuOneColEditButton% yp w130 gSetHelpProcess, Edit
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_HelperWindowProgramExecutables gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack



   Gui, MenuGui:Tab, 4 ; advanced  -------------------------------------------------------------------------

   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Terminating Characters (see http://www.autohotkey.com/docs/KeyList.htm)
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidth% r1 vprefs_TerminatingCharacters gEditValue, %prefs_TerminatingCharacters%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_TerminatingCharacters gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , Force New Word Characters (comma separated)
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidth% r1 vprefs_ForceNewWordCharacters gEditValue, %prefs_ForceNewWordCharacters%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_ForceNewWordCharacters gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack

   MenuRowY := MenuRowY + MenuRowHeight + MenuSeparatorY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowHelpY := MenuRowY - MenuHelpIndentY

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuRowHeight% , End Word Characters (comma separated)
   Gui, MenuGui:Add, Edit, x%MenuGroup1EditX% y%MenuRowEditY% w%MenuOneColEditWidth% r1 vprefs_EndWordCharacters gEditValue, %prefs_EndWordCharacters%
   Gui, MenuGui:Font, cGreen
   Gui, MenuGui:Add, Text, x%MenuGroup1of1HelpX% y%MenuRowHelpY% vhelpinfo_EndWordCharacters gHelpMe, %MenuGuiHelpIcon%
   Gui, MenuGui:Font, cBlack



   Gui, MenuGui:Tab, 5 ; about & help --------------------------------------------

   MenuRowY := MenuSeparatorY + 30
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY

   helpinfo_Intro=
   (
%g_ScriptTitle% is a simple, compact, and handy auto-completion utility.

It is customizable enough to be useful for regular typing and for programming.

Features:
As you type your word, up to 10 (or as defined in Settings) matches will appear in a drop-down dialog, numbered 1 - 0 (10th). To choose the match you want just hit the associated number on your keyboard (numpad does not work). Alternatively you can select an item from the drop-down using the Up/Down arrows. You can define a fixed position for the drop-down dialog to appear by hitting Ctrl-Shift-H to open a small helper window, or by specifying a list of programs in the preferences file. Please note that in Firefox, Thunderbird, and certain other programs you will probably need to open the helper window due to issues detecting the caret position.

Words should be stored in a file named 'Wordlist.txt' which should be located in the script directory. These words may be commented out by prefixing with a semicolon or simply removed or added. Words may include terminating characters (such as space), but you must select the word before typing the terminating character.

In addition to being able to use the number keys to select a word, you can select words from the drop-down via the Up/Down arrows. Hitting Up on the first item will bring you to the last and hitting Down on the last item will bring you to the first. Hitting Page Up will bring you up 10 items, or to the first item. Hitting Page Down will bring you down 10 items, or to the last item. You can hit Tab, Right Arrow, Ctrl-Space, or Ctrl-Enter to autocomplete the selected word. This feature can be disabled or have some of its behavior modified via Settings.

The script will learn words as you type them if "Learn new words as you type" is set to On in Settings. If you type a word more than 5 times (or as defined in "Minimum length of word to learn") in a single session the word will be permanently added to the list of learned words. Learned words will always appear below predefined words, but will be ranked and ordered among other learned words based on the frequency you type them. You can permanently learn a word by highlighting a word and hitting Ctrl-Shift-C (this works even if "Learn new words as you type" is set to Off). You may use Ctrl-Shift-Del to remove the currently selected Learned Word.
Learned words are stored in the WordlistLearned.db sqlite3 database. Learned words are backed up in WordlistLearned.txt. To modify the list of Learned words manually, delete the WordlistLearned.db database, then manually edit the WordlistLearned.txt file. On the next launch of the script, the WordlistLearned.db database will be rebuilt.

Word descriptions can be added to 'Wordlist.txt' that will appear in the wordlist next to the word. These descriptions should be in the form of <word>|d|<description>, e.g., Tylenol|d|Pain Reliever. This could be used for spelling replacements, text expansion, or translation aids. Multiple replacements can be defined for a word (put each on a separate line). Descriptions can be added to each word as well.

Word replacements can be added to 'Wordlist.txt' that will appear in the wordlist next to the word. When the word is chosen, it will be backspaced out and replaced with the new word. These replacements should be in the form of <word>|r|<description>, e.g., fire|r|fuego. This could be used for things like definitions, translation aids, or function arguments. When Fixed Width fonts are used in the wordlist, the description columns will be tabbed evenly so they line up.

When Settings are changed, the script will automatically create a file named Preferences.ini in the script directory. This file allows for sharing settings between users. Users are encouraged to only edit settings by using the Settings window.
To allow for distribution of standardized preferences, a Defaults.ini may be distributed with the same format as Preferences.ini. If the Defaults.ini is present, this will override the hardcoded defaults in the script. A user may override the Defaults.ini by changing settings in the Settings window.

Customizable features include (see also detailed description below)

   * Enable or disable learning mode.
   * Number of characters a word needs to have in order to be learned.
   * Number of times you must type a word before it is permanently learned.
   * Number of items to show in the list at once.
   * Number of characters before the list of words appears.
   * Change the method used to send the word to the screen.
   * Enable, disable, or customize the arrow key's functionality.
   * Disable certain keys for autocompleting a word selected via the arrow keys.
   * Change whether the script simply completes or actually replaces the word (capitalization change based on the wordlist file).
   * Enable or disable the resetting of the Wordlist Box on a mouseclick.
   * Change whether a space should be automatically added after the autocompleted word or not.
   * List of strings which will prevent any word which contains one of these strings from being learned.
   * Change whether the typed word should appear in the word list or not.
   * Number of pixels below the caret to display the Wordlist Box.
   * Wordlist Box Default Font of fixed (Courier New) or variable (Tahoma) width.
   * Wordlist Box Font Size.
   * Wordlist Box Opacity setting to set the transparency of the List Box.
   * Wordlist Box Character Width to override the computed character width.
   * Wordlist Box Default Font override.
   * List of programs for which you want %g_ScriptTitle% enabled.
   * List of programs for which you do not want %g_ScriptTitle% enabled.
   * List of programs for which you want the Helper Window to automatically open.
   * List of characters which terminate a word.
   * List of characters which terminate a word and start a new word.
   * Number of times you must press a number hotkey to select the associated word (options are 1 and 2, 2 is buggy).
   
Unicode Support:
Full support for UTF-8 character set.
   )
   
   helpinfo_HelpText = %helpinfo_Intro%`r`n`r`n%helpinfo_FullHelpString%

   Loop, Parse, helpinfo_HelpText,`n, `r
   {
     IF ( SubStr(A_LoopField, 1,1) = ";")
     {
       helpinfo_ModHelpText .= SubStr(A_LoopField,2) . "`r`n"
     } else
     {
       helpinfo_ModHelpText .= A_LoopField . "`r`n"
     }
   }

   Gui, MenuGui:Add, Edit, ReadOnly x%MenuGroup1BoxX% y%MenuRowY% w%MenuOneColGroupWidth% h%MenuTabHeightEdit%, %helpinfo_ModHelpText%

   helpinfo_ModHelpText =
   helpinfo_HelpText =
   helpinfo_Intro =

   Gui, MenuGui:tab, 

   MenuRowY := MenuTabHeight+15
   MenuRowHelpY := MenuRowY - MenuHelpIndentY
   MenuRowEditY := MenuRowY + MenuEditIndentY
   MenuRowThreeButtonWidth := (MenuTwoColGroupWidth - (4 * MenuEditIndentX))/3
   MenuRowThreeButtonNext := MenuEditIndentX + MenuRowThreeButtonWidth

   Gui, MenuGui:Add, GroupBox, x%MenuGroup1BoxX%           y%MenuRowY%     w%MenuTwoColGroupWidth% h50 , Configuration
   Gui, MenuGui:Add, Button,   x%MenuGroup1EditX%          y%MenuRowEditY% w%MenuRowThreeButtonWidth%    gSave   , Save && Close
   Gui, MenuGui:Add, Button,   xp+%MenuRowThreeButtonNext% yp          w%MenuRowThreeButtonWidth%    gRestore, Restore default
   Gui, MenuGui:Add, Button,   xp+%MenuRowThreeButtonNext% yp          w%MenuRowThreeButtonWidth%    gCancelButton , Cancel

   if (g_ScriptTitle == "TypingAid")
   {
      Gui, MenuGui:Font, cBlack bold
      Gui, MenuGui:Add, Text, x%MenuGroup2of2EditX% Yp-10, %g_ScriptTitle%
      Gui, MenuGui:Font, cBlack normal

      Gui, MenuGui:Add, Text, xp+60 Yp, is free software, support forum at
      Gui, MenuGui:Font, cGreen 
      ;the vMenu_VisitForum variable is necessary for the link highlighting
      Gui, MenuGui:Add, Text, x%MenuGroup2of2EditX% Yp+%MenuTextMenuRowY% vMenu_VisitForum gVisitForum, www.autohotkey.com (click here)
      Gui, MenuGui:Font, cBlack 
   }
   
   Gui, Menugui:+OwnDialogs
   Gui, MenuGui:Show, h%MenuGuiHeight% w%MenuGuiWidth%, %g_ScriptTitle% Settings
   Return
}

SetNotDPIAwareProcess:
GetList("prefs_ListBoxNotDPIAwareProgramExecutables",1)
Return

SetEnableTitles:
GetList("prefs_IncludeProgramTitles",0)
Return

SetDisableTitles:
GetList("prefs_ExcludeProgramTitles",0)
Return

SetEnableProcess:
GetList("prefs_IncludeProgramExecutables",1)
Return

SetDisableProcess:
GetList("prefs_ExcludeProgramExecutables",1)
Return

SetHelpTitles:
GetList("prefs_HelperWindowProgramTitles",0)
Return

SetHelpProcess:
GetList("prefs_HelperWindowProgramExecutables",1)
Return

GetList(TitleType,GetExe){
   global Menu_GetExe
   global Menu_TitleType
   global Menu_InProcessList
   global g_ScriptTitle
   global prefs_ListBoxNotDPIAwareProgramExecutables
   global prefs_IncludeProgramTitles
   global prefs_ExcludeProgramTitles
   global prefs_IncludeProgramExecutables
   global prefs_ExcludeProgramExecutables
   global prefs_HelperWindowProgramTitles
   global prefs_HelperWindowProgramExecutables


   Menu_InProcessList := true
   Menu_GetExe := GetExe
   Menu_TitleType := TitleType
   If (GetExe == 1)
   {
      WinGet, id, list,,, Program Manager
      Loop, %id%
      {
         tmptitle=
         tmpid := id%A_Index%
         WinGet, tmptitle, ProcessName, ahk_id %tmpid%
         If (tmptitle <> "")
            RunningList .= tmptitle "|"
      }
   } Else If (GetExe == 0) ; get list of active window titles
   {
      WinGet, id, list,,, Program Manager
      Loop, %id%
      {
         tmptitle=
         tmpid := id%A_Index%
         WinGetTitle, tmptitle, ahk_id %tmpid%
         If (tmptitle <> "")
            RunningList .= tmptitle "|"
      }
   }
   
   GuiControlGet, MenuTitleList, MenuGui: , %Menu_TitleType%
   
   MenuProcessHeight := 380
   
   Sort,RunningList, D| U  
   Gui, ProcessList:+OwnerMenuGui
   Gui, MenuGui:+Disabled  ; disable main window
   Gui, ProcessList:Add, Text,x10 y10, Select program:
   Gui, ProcessList:Add, DDL, xp+100 yp w250 R10 gToEdit,%RunningList%
   Gui, ProcessList:Add, Text,x10 yp+30, Edit:
   Gui, ProcessList:Add, Edit, xp+100 yp w250
   Gui, ProcessList:Add, Button, xp+260 yp gAddNew1 w40 Default, Add
   if (GetExe == 0)
   {
      Gui, ProcessList:Add, Text,x10 yp+30, Exact Match:
      Gui, ProcessList:Add, Checkbox, xp+100 yp
      MenuProcessHeight += 30
   }
   Gui, ProcessList:Add, Text, x10 yp+30, Current list:
   Gui, ProcessList:Add, ListBox, xp+100 yp w250 r10, %MenuTitleList%
   Gui, ProcessList:Add, Button, xp+260 yp gRemoveNew1 w40 , Del
   Gui, ProcessList:Add, Text, x10 yp+170, a) Select a program or window from the list or type a name in the`n%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%'Edit' control (you may need to edit it further)`nb) Click ADD to add it to the list`nc) To remove a program/title, select an item from the 'current list' and`n%A_Space%%A_Space%%A_Space%%A_Space%click DEL.
   Gui, ProcessList:Add, Button, x10 yp+90 w190 gSaveTitleList, Save 
   Gui, ProcessList:Add, Button, xp+210 yp w190 gCancelTitle, Cancel
   Gui, ProcessList:Show, w420 h%MenuProcessHeight%, %g_ScriptTitle% Settings
   Return
}

VisitForum:
MsgBox , 36 , Visit %g_ScriptTitle% forum (www.autohotkey.com), Do you want to visit the %g_ScriptTitle% forum on www.autohotkey.com?
IfMsgBox, Yes
   Run, http://www.autohotkey.com/board/topic/49517-ahk-11typingaid-v2198-word-autocompletion-utility/
Return

Restore:
MsgBox, 1, Restore Defaults, This will restore all settings to default. Continue?
IfMsgBox, Cancel
   return
RestoreDefaults()
gosub, Cancel
return

RestoreDefaults(){
   global g_PrefsFile
   global g_ScriptTitle
   global Menu_OldLearnCount
   global prefs_LearnCount

   ReadPreferences("RestoreDefaults")

   IF ( Menu_OldLearnCount < prefs_LearnCount )
   {
      MsgBox, 1, Restore Defaults, Restoring Defaults will increase the Learn Count value.`r`nWhen exiting %g_ScriptTitle%, this will permanently delete any words`r`nfrom the Learned Words which have been typed less times`r`nthan the new Learn Count. Continue?
      IfMsgBox, Cancel
      {
         ReturnValue := "Cancel"
      }
   }
   
   if (ReturnValue == "Cancel")
   {
      ReadPreferences(,"RestorePreferences")
      return
   } else {
      
      IfExist, %g_PrefsFile%
      {
         try {
            FileCopy, %g_PrefsFile%, %PrefsFile%-%A_Now%.bak, 1
            FileDelete, %g_PrefsFile%
         } catch {
            MsgBox,,Restore Defaults,Unable to back up preferences! Canceling...
            ReadPreferences(,"RestorePreferences")
            return
         }
      }
      
      ApplyChanges()
      MsgBox,,Restore Defaults, Defaults have been restored.
   }
   
   return
}

MenuGuiGuiEscape:
MenuGuiGuiClose:
CancelButton:
if (Menu_ValueChanged == true)
{
   MsgBox, 4, Cancel, Changes will not be saved. Cancel anyway?
   IfMsgBox, Yes
   {
      gosub, Cancel
   }
} else {
   gosub, Cancel
}
return

Cancel:
Gui, MenuGui:Destroy
; Clear WM_SETCURSOR action
OnMessage(g_WM_SETCURSOR, "")
; Clear WM_MOUSEMOVE action
OnMessage(g_WM_MOUSEMOVE, "")
;Clear mouse flags
HandleSettingsMessage("", "", "", "")
g_InSettings := false
Menu, Tray, Enable, Settings
GetIncludedActiveWindow()
Return

Save:
Save()
return

Save(){
   global prefs_ArrowKeyMethod, prefs_DisabledAutoCompleteKeys, prefs_LearnCount, prefs_ListBoxOpacity, prefs_NoBackSpace, prefs_SendMethod
   global Menu_ChangedPrefs, Menu_ListBoxOpacityUpDown, Menu_OldLearnCount
   global g_ScriptTitle
   ; should only save preferences.ini if different from defaults
   Menu_ChangedPrefs["prefs_ArrowKeyMethod"] := prefs_ArrowKeyMethod
   Menu_ChangedPrefs["prefs_DisabledAutoCompleteKeys"] := prefs_DisabledAutoCompleteKeys
   Menu_ChangedPrefs["prefs_NoBackSpace"] := prefs_NoBackSpace
   Menu_ChangedPrefs["prefs_SendMethod"] := prefs_SendMethod
   Gui, MenuGui:Submit
   prefs_ListBoxOpacity := Menu_ListBoxOpacityUpDown
   
   IF (Menu_OldLearnCount < prefs_LearnCount )
   {   
      MsgBox, 1, Save, Saving will increase the Learn Count value.`r`nWhen exiting %g_ScriptTitle%, this will permanently delete any words`r`nfrom the Learned Words which have been typed less times`r`nthan the new Learn Count. Continue?
      IfMsgBox, Cancel
      {
         ReturnValue := "Cancel"
      }
   }
   
   If ( ReturnValue == "Cancel" )
   {
      ReadPreferences(,"RestorePreferences")
   } else {
      SaveSettings()
      ApplyChanges()
   }
   gosub, Cancel
   Return
}

SaveSettings(){
   Global
   
   Local Menu_PrefsToSave
   Local Split
   Local Split0
   Local Split1

   Local key
   Local value
   
   Menu_PrefsToSave := Object()
  
   Loop, parse, Menu_SendMethodOptionsCode, | ; get sendmethod
   {
      If (Menu_SendMethodC = A_Index)
         prefs_SendMethod:=A_LoopField
   }
   
   prefs_DisabledAutoCompleteKeys=
   If (Menu_CtrlEnter = 0)
      prefs_DisabledAutoCompleteKeys .= "E"
   If (Menu_Tab = 0)
      prefs_DisabledAutoCompleteKeys .= "T"
   If (Menu_CtrlSpace = 0)
      prefs_DisabledAutoCompleteKeys .= "S"
   If (Menu_RightArrow = 0)
      prefs_DisabledAutoCompleteKeys .= "R"
   If (Menu_NumberKeys = 0)
      prefs_DisabledAutoCompleteKeys .= "N"
   If (Menu_Enter = 0)
      prefs_DisabledAutoCompleteKeys .= "U"
   If (Menu_SingleClick = 0)
      prefs_DisabledAutoCompleteKeys .= "L"
   If (Menu_NumpadEnter = 0)
      prefs_DisabledAutoCompleteKeys .= "M"

   Loop, parse, Menu_ArrowKeyMethodOptionsText, |
   {
      StringSplit, Split, A_LoopField, -
      Split1 := Trim(Split1)
      If (prefs_ArrowKeyMethod = A_Index)
      {
         prefs_ArrowKeyMethod := Split1
      }   
   }

   If (Menu_CaseCorrection = "on")
      prefs_NoBackSpace=Off
   Else If (Menu_CaseCorrection = "off")
      prefs_NoBackSpace=On
   
   ; Determine list of preferences to save
   For key, value in Menu_ChangedPrefs
   {
      IF (%key% <> value)
      {
         Menu_PrefsToSave.Insert(key)
      }
   }

   SavePreferences(Menu_PrefsToSave)
}

ApplyChanges(){
   ValidatePreferences()
   ParseTerminatingCharacters()
   InitializeHotKeys()
   DestroyListBox()
   InitializeListBox()
   
   Return

}   

EditValue:
Menu_ValueChanged := true
IF (A_GuiControl && !(SubStr(A_GuiControl ,1 ,5) == "Menu_") )
{
   Menu_ChangedPrefs[A_GuiControl] := %A_GuiControl%
}
Return

HelpMe:
HelpMe()
return

HelpMe(){
   global g_ScriptTitle
   Loop, Parse, %A_GuiControl%,`r`n
   {
      IF ( SubStr(A_LoopField, 1,1) = ";")
      {
         Menu_Help .= SubStr(A_LoopField,2) . "`r`n"
      } else {
         Menu_Help .= A_LoopField . "`r`n"
      }
   }
   MsgBox , 32 , %g_ScriptTitle% Help, %Menu_Help%
   return
}
   
; derived from work by shimanov, 2005
; http://www.autohotkey.com/forum/viewtopic.php?p=37696#37696
HandleSettingsMessage( p_w, p_l, p_m, p_hw ){
   Global g_IDC_HELP, g_IMAGE_CURSOR, g_LR_SHARED, g_NULL, g_WM_SETCURSOR, g_WM_MOUSEMOVE, g_cursor_hand
   Static Help_Hover, h_cursor_help, URL_Hover, h_old_cursor, Old_GuiControl
   
   ; pass in all blanks to clear flags
   if ((!p_w) && (!p_l) && (!p_m) && (!p_hw)) {
      Help_Hover =
      URL_Hover =
      h_old_cursor =
      Old_GuiControl =
   }
   
   if ( p_m = g_WM_SETCURSOR )
   {
      if ( Help_Hover || URL_Hover)
         return, true
   } else if (A_GuiControl == Old_GuiControl)
   {
      return
   } else if ( p_m = g_WM_MOUSEMOVE )
   {
      if (Help_Hover || URL_Hover)
      {
         
         Gui, MenuGui:Font, cGreen     ;;; xyz
         GuiControl, MenuGui:Font, %Old_GuiControl% ;;; xyz
      }
      
      if ( SubStr(A_GuiControl, 1, 9) == "helpinfo_" )
      {
         if !(Help_Hover)
         {
            IF !(h_cursor_help)
            {
               h_cursor_help := DllCall( "LoadImage", "Ptr", g_NULL, "Uint", g_IDC_HELP , "Uint", g_IMAGE_CURSOR, "Int", g_NULL, "Int", g_NULL, "Uint", g_LR_SHARED ) 
            }
            old_cursor := DllCall( "SetCursor", "Uint", h_cursor_help )
            Help_Hover = true
            URL_Hover = 
            Gui, MenuGui:Font, cBlue        ;;; xyz
            GuiControl, MenuGui:Font, %A_GuiControl% ;;; xyz
         }
      } else if (A_GuiControl == "Menu_VisitForum")
      {  
         if !(URL_Hover)
         {
            old_cursor := DllCall( "SetCursor", "uint", g_cursor_hand )
            URL_Hover = true
            Help_Hover =
            Gui, MenuGui:Font, cBlue        ;;; xyz
            GuiControl, MenuGui:Font, %A_GuiControl% ;;; xyz
         }
            
      } else if (Help_Hover || URL_Hover)
      {
         DllCall( "SetCursor", "Uint", h_old_cursor )
         Help_Hover=
         URL_Hover=
         h_old_cursor=
      }
      IF !(h_old_cursor)
      {
         h_old_cursor := old_cursor
      }
      
      Old_GuiControl := A_GuiControl
   }
}

SaveTitleList:
SaveTitleList()
return

SaveTitleList(){
   global Menu_InProcessList
   global Menu_TitleType
   ControlGet, MenuTitleList, List, , ListBox1
   Menu_InProcessList := false
   Gui, ProcessList:Destroy
   Gui, MenuGui:-Disabled  ; enable main window
   Gui, MenuGui:Show
   StringReplace, MenuTitleList, MenuTitleList, `n, |, All

   GuiControl, MenuGui:Text, %Menu_TitleType%, %MenuTitleList%
   Menu_ChangedPrefs[Menu_TitleType] := %Menu_TitleType%
   
   return
}

ProcessListGuiEscape:
ProcessListGuiClose:
CancelTitle:
Menu_InProcessList := false
Gui, ProcessList:Destroy
Gui, MenuGui:-Disabled ; enable main window
Gui, MenuGui:Show
Return

ToEdit:
ToEdit()
return

ToEdit(){
   GuiControlGet, MenuOutputVar, ProcessList:,ComboBox1
   GuiControl, ProcessList:, Edit1, 
   GuiControl, ProcessList:, Edit1, %MenuOutputVar%
   ControlFocus, Edit1
   return
}

AddNew1:
AddNew1()
return

AddNew1(){
   global Menu_GetExe
   if (Menu_GetExe == 0)
   {
      GuiControlGet, MenuExactMatch, ProcessList:, Button2
   } else {
      MenuExactMatch := 0
   }
   GuiControlGet, MenuOutputVar, ProcessList:,Edit1
   ControlGet, MenuTitleList, List, , ListBox1
   
   if (MenuExactMatch == 1)
   {
      MenuOutputVar := """" . MenuOutputVar . """"
   }
   
   StringReplace, MenuTitleList, MenuTitleList, `n, |, All
   MenuTitleList := "|" . MenuTitleList . "|"
   
   SearchString := "|" . MenuOutputVar . "|"
   
   IfInString, MenuTitleList, |%MenuOutputVar%|
   {
      MsgBox, 16, , Duplicate entry.
      return
   }
   
   GuiControl, ProcessList:, ListBox1, %MenuOutputVar%|
   GuiControl, ProcessList:, Edit1, 
   if (Menu_GetExe == 0)
   {
      GuiControl, ProcessList:, Button2, 0
   }
   ControlFocus, Edit1
   return
}

RemoveNew1:
RemoveNew1()
return

RemoveNew1(){
   GuiControlGet, MenuOutputVar, ProcessList:, Listbox1
   ControlGet, MenuTitleList, List, , ListBox1
   StringReplace, MenuTitleList, MenuTitleList, `n, |, All
   MenuTitleList := "|" . MenuTitleList . "|"
   StringReplace, MenuTitleList, MenuTitleList, |%MenuOutputVar%|, |, all
   StringTrimRight, MenuTitleList, MenuTitleList, 1
   GuiControl, ProcessList:, ListBox1, |
   GuiControl, ProcessList:, ListBox1, %MenuTitleList%
   
   return
}

; copied from font explorer http://www.autohotkey.com/forum/viewtopic.php?t=57501&highlight=font
Writer_enumFonts(){
   global g_NULL
   Writer_enumFontsProc(0, 0, 0, 0,"Clear")
   hDC := DllCall("GetDC", "Uint", g_NULL) 
   DllCall("EnumFonts", "Uint", hDC, "Uint", g_NULL, "Uint", RegisterCallback("Writer_enumFontsProc", "F"), "Uint", g_NULL) 
   DllCall("ReleaseDC", "Uint", g_NULL, "Uint", hDC)
   
   return Writer_enumFontsProc(0, 0, 0, 0, "ReturnS")
}

Writer_enumFontsProc(lplf, lptm, dwType, lpData, Action = 0){
   static s
   
   ifEqual, Action, Clear
   {
      s=
      return
   }
   
   ifEqual, Action, ReturnS, return s

   s .= DllCall("MulDiv", "Int", lplf+28, "Int",1, "Int", 1, "str") "|"
   return 1
}

;============================== [ Window ]

;These functions and labels are related to the active window

EnableWinHook(){
   global g_EVENT_SYSTEM_FOREGROUND
   global g_NULL
   global g_WINEVENT_SKIPOWNPROCESS
   global g_WinChangedEventHook
   global g_WinChangedCallback
   ; Set a hook to check for a changed window
   If !(g_WinChangedEventHook)
   {
      MaybeCoInitializeEx()
      g_WinChangedEventHook := DllCall("SetWinEventHook", "Uint", g_EVENT_SYSTEM_FOREGROUND, "Uint", g_EVENT_SYSTEM_FOREGROUND, "Ptr", g_NULL, "Uint", g_WinChangedCallback, "Uint", g_NULL, "Uint", g_NULL, "Uint", g_WINEVENT_SKIPOWNPROCESS)
      
      if !(g_WinChangedEventHook)
      {
         MsgBox, Failed to register Event Hook!
         ExitApp
      }
   }
   
   Return
}

DisableWinHook(){
   global g_WinChangedEventHook
   
   if (g_WinChangedEventHook)
   {
      if (DllCall("UnhookWinEvent", "Uint", g_WinChangedEventHook))
      {
         g_WinChangedEventHook =
         MaybeCoUninitialize()
      } else {
         MsgBox, Failed to Unhook WinEvent!
         ExitApp
      }
   }
   return
}

; Hook function to detect change of focus (and remove ListBox when changing active window) 
WinChanged(hWinEventHook, event, wchwnd, idObject, idChild, dwEventThread, dwmsEventTime){
   global g_inSettings
   global g_ManualActivate
   global g_OldCaretY
   global prefs_DetectMouseClickMove
   
   If (event <> 3)
   {
      return
   }
   
   if (g_ManualActivate = true)
   {
      ; ignore activations we've set up manually and clear the flag
      g_ManualActivate = 
      return
   }      
   
   if (g_inSettings = true )
   {
      return
   }
   
   if (SwitchOffListBoxIfActive())
   {
      return
   }
   
   IF ( ReturnWinActive() )
   {
      IfNotEqual, prefs_DetectMouseClickMove, On 
      {
         IfNotEqual, g_OldCaretY,
         {
            if ( g_OldCaretY != HCaretY() )
            {
               CloseListBox()
            }
         }
      }
      
   } else {
      GetIncludedActiveWindow()
   }
   Return
}

SwitchOffListBoxIfActive(){   
   global g_Active_Id
   global g_ListBox_Id
   global g_ManualActivate
   
   if (g_Active_Id && g_ListBox_Id) {
      WinGet, Temp_id, ID, A   
      IfEqual, Temp_id, %g_ListBox_Id%
      {
         ;set so we don't process this activation
         g_ManualActivate := true
         WinActivate, ahk_id %g_Active_Id%
         return, true
      }
   }
   return, false
}
   
   
;------------------------------------------------------------------------

; Wrapper function to ensure we always enable the WinEventHook after waiting for an active window
; Returns true if the current window is included
GetIncludedActiveWindow(){
   global g_Active_Pid
   global g_Active_Process
   global g_DpiAware
   global g_OSVersion
   global g_Process_DPI_Unaware
   global g_Process_System_DPI_Aware
   global g_Process_Per_Monitor_DPI_Aware
   global prefs_ListBoxNotDPIAwareProgramExecutables
   
   CurrentWindowIsActive := GetIncludedActiveWindowGuts()
   
   if (g_Active_Pid) {
      ; we'll first assume the software is system DPI aware
      DpiAware := g_Process_System_DPI_Aware
      ; if Win 8.1 or higher, we can actually check if it's system DPI aware
      if (g_OSVersion >= 6.3)
      {
         ProcessHandle := DllCall("OpenProcess", "int", g_PROCESS_QUERY_INFORMATION | g_PROCESS_QUERY_LIMITED_INFORMATION, "int", 0, "UInt", g_Active_Pid)
         DllCall("GetProcessDpiAwareness", "Ptr", ProcessHandle, "Uint*", DpiAware)
         DllCall("CloseHandle", "Ptr", ProcessHandle)
      }
      
      ; check the override list for processes that aren't DPI aware
      if (DpiAware != g_Process_DPI_Unaware) {  
         Loop, Parse, prefs_ListBoxNotDPIAwareProgramExecutables, |
         {
            IfEqual, g_Active_Process, %A_LoopField%
            {
               DpiAware := g_Process_DPI_Unaware
               break
            }
         }
      }
      
      If (DpiAware == g_Process_DPI_Unaware) {
         g_DpiAware := DpiAware
      } else if (DpiAware == g_Process_System_DPI_Aware) {
         g_DpiAware := DpiAware
      } else if (DpiAware == g_Process_Per_Monitor_DPI_Aware) {
         g_DpiAware := DpiAware
      } else {
         g_DpiAware := g_Process_System_DPI_Aware
      }
   }
   
   EnableWinHook()
   Return, CurrentWindowIsActive
}

GetIncludedActiveWindowGuts(){
   global g_Active_Id
   global g_Active_Pid
   global g_Active_Process
   global g_Active_Title
   global g_Helper_Id
   global g_LastActiveIdBeforeHelper
   global g_ListBox_Id
   global g_MouseWin_Id
   Process, Priority,,Normal
   ;Wait for Included Active Window
   
   CurrentWindowIsActive := true
   
   Loop
   {
      WinGet, ActiveId, ID, A
      WinGet, ActivePid, PID, ahk_id %ActiveId%
      WinGet, ActiveProcess, ProcessName, ahk_id %ActiveId%
      WinGetTitle, ActiveTitle, ahk_id %ActiveId%
      IfEqual, ActiveId, 
      {
         IfNotEqual, g_MouseWin_Id,
         {
            IfEqual, g_MouseWin_Id, %g_ListBox_Id% 
            {
               WinActivate, ahk_id %g_Active_Id%
               Return, CurrentWindowIsActive
            }
         }
         
         CurrentWindowIsActive := false
         InactivateAll()
         ;Wait for any window to be active
         WinWaitActive, , , , ZZZYouWillNeverFindThisStringInAWindowTitleZZZ
         Continue
      }
      IfEqual, ActiveId, %g_Helper_Id%
         Break
      IfEqual, ActiveId, %g_ListBox_Id%
         Break
      If CheckForActive(ActiveProcess,ActiveTitle)
         Break
      
      CurrentWindowIsActive := false
      InactivateAll()
      SetTitleMatchMode, 3 ; set the title match mode to exact so we can detect a window title change
      ; Wait for the current window to no longer be active
      WinWaitNotActive, %ActiveTitle% ahk_id %ActiveId%
      SetTitleMatchMode, 2
      ActiveId = 
      ActiveTitle =
      ActiveProcess =
   }

   IfEqual, ActiveId, %g_ListBox_Id%
   {
      g_Active_Id :=  ActiveId
      g_Active_Pid := ActivePid
      g_Active_Process := ActiveProcess
      g_Active_Title := ActiveTitle
      Return, CurrentWindowIsActive
   }
   
   ;if we are in the Helper Window, we don't want to re-enable script functions
   IfNotEqual, ActiveId, %g_Helper_Id%
   {
      ; Check to see if we need to reopen the helper window
      MaybeOpenOrCloseHelperWindow(ActiveProcess,ActiveTitle,ActiveId)
      SuspendOff()
      ;Set the process priority back to High
      Process, Priority,,High
      g_LastActiveIdBeforeHelper = %ActiveId%
      
   } else {
      IfNotEqual, g_Active_Id, %g_Helper_Id%
         g_LastActiveIdBeforeHelper = %g_Active_Id%               
   }
   
   global g_LastInput_Id
   ;Show the ListBox if the old window is the same as the new one
   IfEqual, ActiveId, %g_LastInput_Id%
   {
      WinWaitActive, ahk_id %g_LastInput_Id%,,0
      ;Check Caret Position again
      CheckForCaretMove("LButton")
      ShowListBox()      
   } else {
      CloseListBox()
   }
   g_Active_Id :=  ActiveId
   g_Active_Pid := ActivePid
   g_Active_Process := ActiveProcess
   g_Active_Title := ActiveTitle
   Return, CurrentWindowIsActive
}

CheckForActive(ActiveProcess,ActiveTitle){
   ;Check to see if the Window passes include/exclude tests
   global g_InSettings
   global prefs_ExcludeProgramExecutables
   global prefs_ExcludeProgramTitles
   global prefs_IncludeProgramExecutables
   global prefs_IncludeProgramTitles
   
   quotechar := """"
   
   If g_InSettings
      Return,
   
   Loop, Parse, prefs_ExcludeProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return,
   }
   
   Loop, Parse, prefs_ExcludeProgramTitles, |
   {
      
      if (SubStr(A_LoopField, 1, 1) == quotechar && SubStr(A_LoopField, StrLen(A_LoopField), 1) == quotechar)
      {
         StringTrimLeft, TrimmedString, A_LoopField, 1
         StringTrimRight, TrimmedString, TrimmedString, 1
         IfEqual, ActiveTitle, %TrimmedString%
         {
            return,
         }
      }  else IfInString, ActiveTitle, %A_LoopField%
      {
         return,
      }
   }

   IfEqual, prefs_IncludeProgramExecutables,
   {
      IfEqual, prefs_IncludeProgramTitles,
         Return, 1
   }

   Loop, Parse, prefs_IncludeProgramExecutables, |
   {
      IfEqual, ActiveProcess, %A_LoopField%
         Return, 1
   }

   Loop, Parse, prefs_IncludeProgramTitles, |
   {
      if (SubStr(A_LoopField, 1, 1) == quotechar && SubStr(A_LoopField, StrLen(A_LoopField), 1) == quotechar)
      {
         StringTrimLeft, TrimmedString, A_LoopField, 1
         StringTrimRight, TrimmedString, TrimmedString, 1
         IfEqual, ActiveTitle, %TrimmedString%
         {
            Return, 1
         }
      } else IfInString, ActiveTitle, %A_LoopField%
      {
         Return, 1
      }
   }

   Return, 
}

;------------------------------------------------------------------------
      
ReturnWinActive(){
   global g_Active_Id
   global g_Active_Title
   global g_InSettings
   
   IF g_InSettings
      Return
   
   if (SwitchOffListBoxIfActive())
   {
      return, true
   }
   
   WinGet, Temp_id, ID, A
   WinGetTitle, Temp_Title, ahk_id %Temp_id%
   Last_Title := g_Active_Title
   ; remove all asterisks, dashes, and spaces from title in case saved value changes
   StringReplace, Last_Title, Last_Title,*,,All
   StringReplace, Temp_Title, Temp_Title,*,,All
   StringReplace, Last_Title, Last_Title,%A_Space%,,All
   StringReplace, Temp_Title, Temp_Title,%A_Space%,,All
   StringReplace, Last_Title, Last_Title,-,,All
   StringReplace, Temp_Title, Temp_Title,-,,All
   Return, (( g_Active_Id == Temp_id ) && ( Last_Title == Temp_Title ))
}

;============================== [ Wordlist ]

; These functions and labels are related maintenance of the wordlist

ReadWordList(){
   global g_LegacyLearnedWords
   global g_ScriptTitle
   global g_WordListDone
   global g_WordListDB
   ;mark the wordlist as not done
   g_WordListDone = 0
   
   WordlistFileName = wordlist.txt
   
   Wordlist = %A_ScriptDir%\%WordlistFileName%
   WordlistLearned = %A_ScriptDir%\WordlistLearned.txt
   
   MaybeFixFileEncoding(Wordlist,"UTF-8")
   MaybeFixFileEncoding(WordlistLearned,"UTF-8")

   g_WordListDB := DBA.DataBaseFactory.OpenDataBase("SQLite", A_ScriptDir . "\WordlistLearned.db" )
   
   if !g_WordListDB
   {
      msgbox Problem opening database '%A_ScriptDir%\WordlistLearned.db' - fatal error...
      exitapp
   }
   
   g_WordListDB.Query("PRAGMA journal_mode = TRUNCATE;")
   
   DatabaseRebuilt := MaybeConvertDatabase()
         
   FileGetSize, WordlistSize, %Wordlist%
   FileGetTime, WordlistModified, %Wordlist%, M
   FormatTime, WordlistModified, %WordlistModified%, yyyy-MM-dd HH:mm:ss
   
   if (!DatabaseRebuilt) {
      LearnedWordsTable := g_WordListDB.Query("SELECT wordlistmodified, wordlistsize FROM Wordlists WHERE wordlist = '" . WordlistFileName . "';")
      
      LoadWordlist := "Insert"
      
      For each, row in LearnedWordsTable.Rows
      {
         WordlistLastModified := row[1]
         WordlistLastSize := row[2]
         
         if (WordlistSize != WordlistLastSize || WordlistModified != WordlistLastModified) {
            LoadWordlist := "Update"
            CleanupWordList()
         } else {
            LoadWordlist =
            CleanupWordList(true)
         }
      }
   } else {
      LoadWordlist := "Insert"
   }
   
   if (LoadWordlist) {
      Progress, M, Please wait..., Loading wordlist, %g_ScriptTitle%
      g_WordListDB.BeginTransaction()
      ;reads list of words from file 
      FileRead, ParseWords, %Wordlist%
      Loop, Parse, ParseWords, `n, `r
      {
         ParseWordsCount++
      }
      Loop, Parse, ParseWords, `n, `r
      {
         ParseWordsSubCount++
         ProgressPercent := Round(ParseWordsSubCount/ParseWordsCount * 100)
         if (ProgressPercent <> OldProgressPercent)
         {
            Progress, %ProgressPercent%
            OldProgressPercent := ProgressPercent
         }
         IfEqual, A_LoopField, `;LEARNEDWORDS`;
         {
            if (DatabaseRebuilt)
            {
               LearnedWordsCount=0
               g_LegacyLearnedWords=1 ; Set Flag that we need to convert wordlist file
            } else {
               break
            }
         } else {
            AddWordToList(A_LoopField,0,"ForceLearn",LearnedWordsCount)
         }
      }
      ParseWords =
      g_WordListDB.EndTransaction()
      Progress, Off
      
      if (LoadWordlist == "Update") {
         g_WordListDB.Query("UPDATE wordlists SET wordlistmodified = '" . WordlistModified . "', wordlistsize = '" . WordlistSize . "' WHERE wordlist = '" . WordlistFileName . "';")
      } else {
         g_WordListDB.Query("INSERT INTO Wordlists (wordlist, wordlistmodified, wordlistsize) VALUES ('" . WordlistFileName . "','" . WordlistModified . "','" . WordlistSize . "');")
      }
      
   }
   
   if (DatabaseRebuilt)
   {
      Progress, M, Please wait..., Converting learned words, %g_ScriptTitle%
    
      ;Force LearnedWordsCount to 0 if not already set as we are now processing Learned Words
      IfEqual, LearnedWordsCount,
      {
         LearnedWordsCount=0
      }
      
      g_WordListDB.BeginTransaction()
      ;reads list of words from file 
      FileRead, ParseWords, %WordlistLearned%
      Loop, Parse, ParseWords, `n, `r
      {
         
         AddWordToList(A_LoopField,0,"ForceLearn",LearnedWordsCount)
      }
      ParseWords =
      g_WordListDB.EndTransaction()
      
      Progress, 50, Please wait..., Converting learned words, %g_ScriptTitle%

      ;reverse the numbers of the word counts in memory
      ReverseWordNums(LearnedWordsCount)
      
      g_WordListDB.Query("INSERT INTO LastState VALUES ('tableConverted','1',NULL);")
      
      Progress, Off
   }

   ;mark the wordlist as completed
   g_WordlistDone = 1
   Return
}

;------------------------------------------------------------------------

ReverseWordNums(LearnedWordsCount){
   ; This function will reverse the read numbers since now we know the total number of words
   global prefs_LearnCount
   global g_WordListDB

   LearnedWordsCount+= (prefs_LearnCount - 1)

   LearnedWordsTable := g_WordListDB.Query("SELECT word FROM Words WHERE count IS NOT NULL;")

   g_WordListDB.BeginTransaction()
   For each, row in LearnedWordsTable.Rows
   {
      SearchValue := row[1]
      StringReplace, SearchValueEscaped, SearchValue, ', '', All
      WhereQuery := "WHERE word = '" . SearchValueEscaped . "'"
      g_WordListDB.Query("UPDATE words SET count = (SELECT " . LearnedWordsCount . " - count FROM words " . WhereQuery . ") " . WhereQuery . ";")
   }
   g_WordListDB.EndTransaction()

   Return
   
}

;------------------------------------------------------------------------

AddWordToList(AddWord,ForceCountNewOnly,ForceLearn=false, ByRef LearnedWordsCount = false){
   ;AddWord = Word to add to the list
   ;ForceCountNewOnly = force this word to be permanently learned even if learnmode is off
   ;ForceLearn = disables some checks in CheckValid
   ;LearnedWordsCount = if this is a stored learned word, this will only have a value when LearnedWords are read in from the wordlist
   global prefs_DoNotLearnStrings
   global prefs_ForceNewWordCharacters
   global prefs_LearnCount
   global prefs_LearnLength
   global prefs_LearnMode
   global g_WordListDone
   global g_WordListDB
   
   if !(LearnedWordsCount) {
      StringSplit, SplitAddWord, AddWord, |
      
      IfEqual, SplitAddWord2, D
      {
         AddWordDescription := SplitAddWord3
         AddWord := SplitAddWord1
         IfEqual, SplitAddWord4, R
         {
            AddWordReplacement := SplitAddWord5
         }
      } else IfEqual, SplitAddword2, R
      {
         AddWordReplacement := SplitAddWord3
         AddWord := SplitAddWord1
         IfEqual, SplitAddWord4, D
         {
            AddWordDescription := SplitAddWord5
         }
      }
   }
         
   if !(CheckValid(AddWord,ForceLearn))
      return
   
   TransformWord(AddWord, AddWordReplacement, AddWordDescription, AddWordTransformed, AddWordIndexTransformed, AddWordReplacementTransformed, AddWordDescriptionTransformed)

   IfEqual, g_WordListDone, 0 ;if this is read from the wordlist
   {
      IfNotEqual,LearnedWordsCount,  ;if this is a stored learned word, this will only have a value when LearnedWords are read in from the wordlist
      {
         ; must update wordreplacement since SQLLite3 considers nulls unique
         g_WordListDB.Query("INSERT INTO words (wordindexed, word, count, wordreplacement) VALUES ('" . AddWordIndexTransformed . "','" . AddWordTransformed . "','" . LearnedWordsCount++ . "','');")
      } else {
         if (AddWordReplacement)
         {
            WordReplacementQuery := "'" . AddWordReplacementTransformed . "'"
         } else {
            WordReplacementQuery := "''"
         }
         
         if (AddWordDescription)
         {
            WordDescriptionQuery := "'" . AddWordDescriptionTransformed . "'"
         } else {
            WordDescriptionQuery := "NULL"
         }
         g_WordListDB.Query("INSERT INTO words (wordindexed, word, worddescription, wordreplacement) VALUES ('" . AddWordIndexTransformed . "','" . AddWordTransformed . "'," . WordDescriptionQuery . "," . WordReplacementQuery . ");")
      }
      
   } else if (prefs_LearnMode = "On" || ForceCountNewOnly == 1)
   { 
      ; If this is an on-the-fly learned word
      AddWordInList := g_WordListDB.Query("SELECT * FROM words WHERE word = '" . AddWordTransformed . "';")
      
      IF !( AddWordInList.Count() > 0 ) ; if the word is not in the list
      {
      
         IfNotEqual, ForceCountNewOnly, 1
         {
            IF (StrLen(AddWord) < prefs_LearnLength) ; don't add the word if it's not longer than the minimum length for learning if we aren't force learning it
               Return
            
            if AddWord contains %prefs_ForceNewWordCharacters%
               Return
                  
            if AddWord contains %prefs_DoNotLearnStrings%
               Return
                  
            CountValue = 1
                  
         } else {
            CountValue := prefs_LearnCount ;set the count to LearnCount so it gets written to the file
         }
         
         ; must update wordreplacement since SQLLite3 considers nulls unique
         g_WordListDB.Query("INSERT INTO words (wordindexed, word, count, wordreplacement) VALUES ('" . AddWordIndexTransformed . "','" . AddWordTransformed . "','" . CountValue . "','');")
      } else IfEqual, prefs_LearnMode, On
      {
         IfEqual, ForceCountNewOnly, 1                     
         {
            For each, row in AddWordInList.Rows
            {
               CountValue := row[3]
               break
            }
               
            IF ( CountValue < prefs_LearnCount )
            {
               g_WordListDB.QUERY("UPDATE words SET count = ('" . prefs_LearnCount . "') WHERE word = '" . AddWordTransformed . "');")
            }
         } else {
            UpdateWordCount(AddWord,0) ;Increment the word count if it's already in the list and we aren't forcing it on
         }
      }
   }
   
   Return
}

CheckValid(Word,ForceLearn=false){
   
   Ifequal, Word,  ;If we have no word to add, skip out.
      Return
            
   if Word is space ;If Word is only whitespace, skip out.
      Return
   
   if ( Substr(Word,1,1) = ";" ) ;If first char is ";", clear word and skip out.
   {
      Return
   }
   
   IF ( StrLen(Word) <= prefs_Length ) ; don't add the word if it's not longer than the minimum length
   {
      Return
   }
   
   ;Anything below this line should not be checked if we want to Force Learning the word (Ctrl-Shift-C or coming from wordlist.txt)
   If ForceLearn
      Return, 1
   
   ;if Word does not contain at least one alpha character, skip out.
   IfEqual, A_IsUnicode, 1
   {
      if ( RegExMatch(Word, "S)\pL") = 0 )  
      {
         return
      }
   } else if ( RegExMatch(Word, "S)[a-zA-Zà-öø-ÿÀ-ÖØ-ß]") = 0 )
   {
      Return
   }
   
   Return, 1
}

TransformWord(AddWord, AddWordReplacement, AddWordDescription, ByRef AddWordTransformed, ByRef AddWordIndexTransformed, ByRef AddWordReplacementTransformed, ByRef AddWordDescriptionTransformed){
   AddWordIndex := AddWord
   
   ; normalize accented characters
   AddWordIndex := StrUnmark(AddWordIndex)
   
   StringUpper, AddWordIndex, AddWordIndex
   
   StringReplace, AddWordTransformed, AddWord, ', '', All
   StringReplace, AddWordIndexTransformed, AddWordIndex, ', '', All
   if (AddWordReplacement) {
      StringReplace, AddWordReplacementTransformed, AddWordReplacement, ', '', All
   }
   if (AddWordDescription) {
      StringReplace, AddWordDescriptionTransformed, AddWordDescription, ', '', All
   }
}

DeleteWordFromList(DeleteWord){
   global prefs_LearnMode
   global g_WordListDB
   
   Ifequal, DeleteWord,  ;If we have no word to delete, skip out.
      Return
            
   if DeleteWord is space ;If DeleteWord is only whitespace, skip out.
      Return
   
   IfNotEqual, prefs_LearnMode, On
      Return
   
   StringReplace, DeleteWordEscaped, DeleteWord, ', '', All
   g_WordListDB.Query("DELETE FROM words WHERE word = '" . DeleteWordEscaped . "';")
      
   Return   
}

;------------------------------------------------------------------------

UpdateWordCount(word,SortOnly){
   global prefs_LearnMode
   global g_WordListDB
   ;Word = Word to increment count for
   ;SortOnly = Only sort the words, don't increment the count
   
   ;Should only be called when LearnMode is on  
   IfEqual, prefs_LearnMode, Off
      Return
   
   IfEqual, SortOnly, 
      Return

   StringReplace, wordEscaped, word, ', '', All
   g_WordListDB.Query("UPDATE words SET count = count + 1 WHERE word = '" . wordEscaped . "';")
   
   Return
}

;------------------------------------------------------------------------

CleanupWordList(LearnedWordsOnly := false){
   ;Function cleans up all words that are less than the LearnCount threshold or have a NULL for count
   ;(NULL in count represents a 'wordlist.txt' word, as opposed to a learned word)
   global g_ScriptTitle
   global g_WordListDB
   global prefs_LearnCount
   Progress, M, Please wait..., Cleaning wordlist, %g_ScriptTitle%
   if (LearnedWordsOnly) {
      g_WordListDB.Query("DELETE FROM Words WHERE count < " . prefs_LearnCount . " AND count IS NOT NULL;")
   } else {
      g_WordListDB.Query("DELETE FROM Words WHERE count < " . prefs_LearnCount . " OR count IS NULL;")
   }
   Progress, Off
}

;------------------------------------------------------------------------

MaybeUpdateWordlist(){
   global g_LegacyLearnedWords
   global g_WordListDB
   global g_WordListDone
   global prefs_LearnCount
   
   ; Update the Learned Words
   IfEqual, g_WordListDone, 1
   {
      
      SortWordList := g_WordListDB.Query("SELECT Word FROM Words WHERE count >= " . prefs_LearnCount . " AND count IS NOT NULL ORDER BY count DESC;")
      
      for each, row in SortWordList.Rows
      {
         TempWordList .= row[1] . "`r`n"
      }
      
      If ( SortWordList.Count() > 0 )
      {
         StringTrimRight, TempWordList, TempWordList, 2
   
         FileDelete, %A_ScriptDir%\Temp_WordlistLearned.txt
         FileAppendDispatch(TempWordList, A_ScriptDir . "\Temp_WordlistLearned.txt")
         FileCopy, %A_ScriptDir%\Temp_WordlistLearned.txt, %A_ScriptDir%\WordlistLearned.txt, 1
         FileDelete, %A_ScriptDir%\Temp_WordlistLearned.txt
         
         ; Convert the Old Wordlist file to not have ;LEARNEDWORDS;
         IfEqual, g_LegacyLearnedWords, 1
         {
            TempWordList =
            FileRead, ParseWords, %A_ScriptDir%\Wordlist.txt
            LearnedWordsPos := InStr(ParseWords, "`;LEARNEDWORDS`;",true,1) ;Check for Learned Words
            TempWordList := SubStr(ParseWords, 1, LearnedwordsPos - 1) ;Grab all non-learned words out of list
            ParseWords = 
            FileDelete, %A_ScriptDir%\Temp_Wordlist.txt
            FileAppendDispatch(TempWordList, A_ScriptDir . "\Temp_Wordlist.txt")
            FileCopy, %A_ScriptDir%\Temp_Wordlist.txt, %A_ScriptDir%\Wordlist.txt, 1
            FileDelete, %A_ScriptDir%\Temp_Wordlist.txt
         }   
      }
   }
   
   g_WordListDB.Close(),
   
}

;------------------------------------------------------------------------

; Removes marks from letters.  Requires Windows Vista or later.
; Code by Lexikos, based on MS documentation
StrUnmark(string) {
   global g_OSVersion
   global g_NormalizationKD
   if (g_OSVersion < 6.0)
   {
      return string
   }
   
   len := DllCall("Normaliz.dll\NormalizeString", "int", g_NormalizationKD, "wstr", string, "int", StrLen(string), "ptr", 0, "int", 0)  ; Get *estimated* required buffer size.
   Loop {
      VarSetCapacity(buf, len * 2)
      len := DllCall("Normaliz.dll\NormalizeString", "int", g_NormalizationKD, "wstr", string, "int", StrLen(string), "ptr", &buf, "int", len)
      if len >= 0
         break
      if (A_LastError != 122) ; ERROR_INSUFFICIENT_BUFFER
         return string
      len *= -1  ; This is the new estimate.
   }
   ; Remove combining marks and return result.
   string := RegExReplace(StrGet(&buf, len, "UTF-16"), "\pM")
   
   StringReplace, string, string, æ, ae, All
   StringReplace, string, string, Æ, AE, All
   StringReplace, string, string, œ, oe, All
   StringReplace, string, string, Œ, OE, All
   StringReplace, string, string, ß, ss, All   
   
   return, string  
   
}


#include ../lib
#Include _Struct.ahk
#Include Base.ahk
#Include ArchLogger.ahk
#Include MemoryBuffer.ahk
#Include Collection.ahk

; drivers / header definitions
#Include ADO.ahk
#Include SQLite_L.ahk
#Include mySQL.ahk


class DBA ; namespace DBA
{
   /*
   * All thefollowing included classes will be contained in the DBA namespace
   * which is actually just an encapsulating class
   *
   */
   
   ;base classes
   #Include DataBaseFactory.ahk
   #Include DataBaseAbstract.ahk
   

   ; Concrete SQL-Provider Implementations
   #Include DataBaseSQLLite.ahk
   #Include DataBaseMySQL.ahk
   #Include DataBaseADO.ahk
   
   #Include RecordSetSqlLite.ahk
   #Include RecordSetADO.ahk
   #Include RecordSetMySQL.ahk
}