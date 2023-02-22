; These functions and labels are related to sending the word to the program

SendKey(Key)
{
   if (Key = "$^Enter")
   {
      Key := "^{Enter}"
   } else    if (Key = "$^Space")
   { 
      Key := "^{Space}"
   } else {
      Key := "{" . SubStr(Key, 2) . "}"
   }
   
   SendCompatible(Key,1)
   Return
}

;------------------------------------------------------------------------
   
SendWord(WordIndex)
{
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
            
SendFull(SendValue,ForceBackspace:=false)
{
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
      if (1 = 1)
      {
         if ( RegExMatch(SubStr(g_Word, 1, 1), "S)\p{Lu}") > 0 )  
         {
            Capitalize := true
         }
      } else if ( RegExMatch(SubStr(g_Word, 1, 1), "S)[A-ZР-жи-п]") > 0 )
      {
         Capitalize := true
      }
      
      FirstLetter := SubStr(SendValue, 1, 1)
         SendValue := SubStr(SendValue, (1)+1)
      if (Capitalize) {
         FirstLetter := StrUpper(FirstLetter)
      } else {
         FirstLetter := StrLower(FirstLetter)
      }
      SendValue := FirstLetter . SendValue
   }
   
   ; if the user chose a word with accented characters, then we need to
   ; substitute those letters into the word
   StringCaseSenseOld := A_StringCaseSense
   ;REMOVED StringCaseSense, Locale
   if (!BackSpaceWord && !(SubStr(SendValue, 1, BackSpaceLen) = g_Word)) {
      BackSpaceWord := true
      
      SendIndex := 1
      WordIndex := 1
      NewSendValue := ""
      While (WordIndex <= BackSpaceLen) {
         SendChar := SubStr(SendValue, (SendIndex)<1 ? (SendIndex)-1 : (SendIndex), 1)
         WordChar := SubStr(g_Word, (WordIndex)<1 ? (WordIndex)-1 : (WordIndex), 1)
         SendIndex++
         
         if (SendChar = WordChar) {
            WordIndex++
            NewSendValue .= WordChar
         } else {
            
            SendCharNorm := StrUnmark(SendChar)
            ; if character normalizes to more than 1 character, we need
            ; to increment the WordIndex pointer again
            
            SendCharNormUpper := StrUpper(SendCharNorm)
            SendCharNormLower := StrLower(SendCharNorm)
            SendCharUpper := StrUpper(SendChar)
            SendCharLower := StrLower(SendChar)
            WordChar := SubStr(g_Word, (WordIndex)<1 ? (WordIndex)-1 : (WordIndex), StrLen(SendCharNorm))
            
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
      
      NewSendValue .= SubStr(SendValue, (SendIndex)<1 ? (SendIndex)-1 : (SendIndex), StrLen(SendValue) - SendIndex + 1)
      
      SendValue := NewSendValue
   }
   ;REMOVED StringCaseSense, %StringCaseSenseOld%
   
   ; If we are not backspacing, remove the typed characters from the string to send
   if !(BackSpaceWord)
   {
      SendValue := SubStr(SendValue, (BackSpaceLen)+1)
   }
   
   ; if autospace is on, add a space to the string to send
   if (prefs_AutoSpace = "On")
      SendValue .= A_Space
   
   if (prefs_SendMethod = 1)
   {
      ; Shift key hits are here to account for an occassional bug which misses the first keys in SendPlay
      sending := "{Shift Down}{Shift Up}{Shift Down}{Shift Up}"
      if (BackSpaceWord)
      {
         sending .= "{BS " . BackSpaceLen . "}"
      }
      sending .= "{Raw}" . SendValue
         
      SendPlay(sending) ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }

   if (BackSpaceWord)
   {
      sending := "{BS " . BackSpaceLen . "}{Raw}" . SendValue
   } Else {
      sending := "{Raw}" . SendValue
   }
   
   if (prefs_SendMethod = 2)
   {
      SendInput(sending) ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt)      
      Return
   }

   if (prefs_SendMethod = 3)
   {
      SendEvent(sending) ; First do the backspaces, Then send word (Raw because we want the string exactly as in wordlist.txt) 
      Return
   }
   
   ClipboardSave := ClipboardAll()
   A_Clipboard := ""
   A_Clipboard := SendValue
   Errorlevel := !ClipWait(0)
   
   if (BackSpaceWord)
   {
      sending := "{BS " . BackSpaceLen . "}{Ctrl Down}v{Ctrl Up}"
   } else {
   sending := "{Ctrl Down}v{Ctrl Up}"
   }
   
   if (prefs_SendMethod = "1C")
   {
      sending := "{Shift Down}{Shift Up}{Shift Down}{Shift Up}" . sending
      SendPlay(sending) ; First do the backspaces, Then send word via clipboard
   } else    if (prefs_SendMethod = "2C")
   {
      SendInput(sending) ; First do the backspaces, Then send word via clipboard
   } else    if (prefs_SendMethod = "3C")
   {
      SendEvent(sending) ; First do the backspaces, Then send word via clipboard
   } else {
      ActiveControl := ControlGetClassNN(ControlGetFocus("ahk_id " g_Active_Id))
      if (ActiveControl != "")
         ControlSend(sending, ActiveControl, "ahk_id " g_Active_Id)
   }
         
   A_Clipboard := ClipboardSave
   Return
}

;------------------------------------------------------------------------

SendCompatible(SendValue,ForceSendForInput)
{
   global g_IgnoreSend
   global prefs_SendMethod
   if (ForceSendForInput = 1)
   {
      g_IgnoreSend := ""
      SendEvent(SendValue)
      Return
   }
   
   SendMethodLocal := SubStr(prefs_SendMethod, 1, 1)
   IF ( ( SendMethodLocal = 1 ) || ( SendMethodLocal = 2 ) )
   {
      SendInput(SendValue)
      Return
   }

   IF ( ( SendMethodLocal = 3 ) || ( SendMethodLocal = 4 ) )
   {
      g_IgnoreSend := "1"
      SendEvent(SendValue)
      Return
   }
   
   SendInput(SendValue)
   Return
}

;------------------------------------------------------------------------