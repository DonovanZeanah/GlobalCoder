; These functions and labels are related maintenance of the wordlist

ReadWordList()
{
   global g_LegacyLearnedWords
   global g_ScriptTitle
   global g_WordListDone
   global g_WordListDB
   ;mark the wordlist as not done
   g_WordListDone := "0"
   
   WordlistFileName := "wordlist.txt"
   
   Wordlist := A_ScriptDir . "\" . WordlistFileName
   WordlistLearned := A_ScriptDir . "\WordlistLearned.txt"
   
   MaybeFixFileEncoding(Wordlist,"UTF-8")
   MaybeFixFileEncoding(WordlistLearned,"UTF-8")

   g_WordListDB := DBA.DataBaseFactory.OpenDataBase("SQLite", A_ScriptDir . "\WordlistLearned.db" )
   
   if !g_WordListDB
   {
      MsgBox("Problem opening database '" A_ScriptDir "\WordlistLearned.db' - fatal error...")
      ExitApp()
   }
   
   g_WordListDB.Query("PRAGMA journal_mode = TRUNCATE;")
   
   DatabaseRebuilt := MaybeConvertDatabase()
         
   WordlistSize := FileGetSize(Wordlist)
   WordlistModified := FileGetTime(Wordlist, "M")
   WordlistModified := FormatTime(WordlistModified, "yyyy-MM-dd HH:mm:ss")
   
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
            LoadWordlist := ""
            CleanupWordList(true)
         }
      }
   } else {
      LoadWordlist := "Insert"
   }
   
   if (LoadWordlist) {
      ProgressGui := Gui("ToolWindow -Sysmenu"), ProgressGui.Title := g_ScriptTitle , ProgressGui.SetFont("Bold"), ProgressGui.AddText("x0 w200 Center", "Loading wordlist"), gocProgress := ProgressGui.AddProgress("x10 w180 h20"), ProgressGui.SetFont(""), ProgressGui.AddText("x0 w200 Center", "Please wait..."), ProgressGui.Show("")
      g_WordListDB.BeginTransaction()
      ;reads list of words from file 
      ParseWords := Fileread(Wordlist)
      Loop Parse, ParseWords, "`n", "`r"
      {
         ParseWordsCount++
      }
      Loop Parse, ParseWords, "`n", "`r"
      {
         ParseWordsSubCount++
         ProgressPercent := Round(ParseWordsSubCount/ParseWordsCount * 100)
         if (ProgressPercent <> OldProgressPercent)
         {
            gocProgress.Value := %ProgressPercent%
            OldProgressPercent := ProgressPercent
         }
         if (A_LoopField = "`;LEARNEDWORDS`;")
         {
            if (DatabaseRebuilt)
            {
               LearnedWordsCount := "0"
               g_LegacyLearnedWords := "1" ; Set Flag that we need to convert wordlist file
            } else {
               break
            }
         } else {
            AddWordToList(A_LoopField,0,"ForceLearn",LearnedWordsCount)
         }
      }
      ParseWords := ""
      g_WordListDB.EndTransaction()
      ProgressGui.Destroy
      
      if (LoadWordlist == "Update") {
         g_WordListDB.Query("UPDATE wordlists SET wordlistmodified = '" . WordlistModified . "', wordlistsize = '" . WordlistSize . "' WHERE wordlist = '" . WordlistFileName . "';")
      } else {
         g_WordListDB.Query("INSERT INTO Wordlists (wordlist, wordlistmodified, wordlistsize) VALUES ('" . WordlistFileName . "','" . WordlistModified . "','" . WordlistSize . "');")
      }
      
   }
   
   if (DatabaseRebuilt)
   {
      ProgressGui := Gui("ToolWindow -Sysmenu"), ProgressGui.Title := g_ScriptTitle , ProgressGui.SetFont("Bold"), ProgressGui.AddText("x0 w200 Center", "Converting learned words"), gocProgress := ProgressGui.AddProgress("x10 w180 h20"), ProgressGui.SetFont(""), ProgressGui.AddText("x0 w200 Center", "Please wait..."), ProgressGui.Show("")
    
      ;Force LearnedWordsCount to 0 if not already set as we are now processing Learned Words
      if (LearnedWordsCount = "")
      {
         LearnedWordsCount := "0"
      }
      
      g_WordListDB.BeginTransaction()
      ;reads list of words from file 
      ParseWords := Fileread(WordlistLearned)
      Loop Parse, ParseWords, "`n", "`r"
      {
         
         AddWordToList(A_LoopField,0,"ForceLearn",LearnedWordsCount)
      }
      ParseWords := ""
      g_WordListDB.EndTransaction()
      
      ProgressGui := Gui("ToolWindow -Sysmenu Disabled"), ProgressGui.Title := g_ScriptTitle , ProgressGui.SetFont("Bold"), ProgressGui.AddText("x0 w200 Center", "Converting learned words"), gocProgress := ProgressGui.AddProgress("x10 w180 h20"), ProgressGui.SetFont(""), ProgressGui.AddText("x0 w200 Center", "Please wait..."), ProgressGui.Show("")

      ;reverse the numbers of the word counts in memory
      ReverseWordNums(LearnedWordsCount)
      
      g_WordListDB.Query("INSERT INTO LastState VALUES ('tableConverted','1',NULL);")
      
      ProgressGui.Destroy
   }

   ;mark the wordlist as completed
   g_WordlistDone := "1"
   Return
}

;------------------------------------------------------------------------

ReverseWordNums(LearnedWordsCount)
{
   ; This function will reverse the read numbers since now we know the total number of words
   global prefs_LearnCount
   global g_WordListDB

   LearnedWordsCount+= (prefs_LearnCount - 1)

   LearnedWordsTable := g_WordListDB.Query("SELECT word FROM Words WHERE count IS NOT NULL;")

   g_WordListDB.BeginTransaction()
   For each, row in LearnedWordsTable.Rows
   {
      SearchValue := row[1]
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      SearchValueEscaped := StrReplace(SearchValue, "'", "''")
      WhereQuery := "WHERE word = '" . SearchValueEscaped . "'"
      g_WordListDB.Query("UPDATE words SET count = (SELECT " . LearnedWordsCount . " - count FROM words " . WhereQuery . ") " . WhereQuery . ";")
   }
   g_WordListDB.EndTransaction()

   Return
   
}

;------------------------------------------------------------------------

AddWordToList(AddWord,ForceCountNewOnly,ForceLearn:=false, &LearnedWordsCount := false)
{
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
      SplitAddWord := StrSplit(AddWord,"|")
      
      if (SplitAddWord[2] = "D")
      {
         AddWordDescription := SplitAddWord[3]
         AddWord := SplitAddWord[1]
         if (SplitAddWord[4] = "R")
         {
            AddWordReplacement := SplitAddWord[5]
         }
      } else       if (SplitAddWord[2] = "R")
      {
         AddWordReplacement := SplitAddWord[3]
         AddWord := SplitAddWord[1]
         if (SplitAddWord[4] = "D")
         {
            AddWordDescription := SplitAddWord[5]
         }
      }
   }
         
   if !(CheckValid(AddWord,ForceLearn))
      return
   
   TransformWord(AddWord, AddWordReplacement, AddWordDescription, AddWordTransformed, AddWordIndexTransformed, AddWordReplacementTransformed, AddWordDescriptionTransformed)

   if (g_WordListDone = 0) ;if this is read from the wordlist
   {
      if (LearnedWordsCount != "")  ;if this is a stored learned word, this will only have a value when LearnedWords are read in from the wordlist
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
      
      IF !( AddWordInList.Count > 0 ) ; if the word is not in the list
      {
      
         if (ForceCountNewOnly != 1)
         {
            IF (StrLen(AddWord) < prefs_LearnLength) ; don't add the word if it's not longer than the minimum length for learning if we aren't force learning it
               Return
            
            if (AddWord ~= "i)(" RegExReplace(RegExReplace(prefs_ForceNewWordCharacters,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")")
               Return
                  
            if (AddWord ~= "i)(" RegExReplace(RegExReplace(prefs_DoNotLearnStrings,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")")
               Return
                  
            CountValue := "1"
                  
         } else {
            CountValue := prefs_LearnCount ;set the count to LearnCount so it gets written to the file
         }
         
         ; must update wordreplacement since SQLLite3 considers nulls unique
         g_WordListDB.Query("INSERT INTO words (wordindexed, word, count, wordreplacement) VALUES ('" . AddWordIndexTransformed . "','" . AddWordTransformed . "','" . CountValue . "','');")
      } else       if (prefs_LearnMode = "On")
      {
         if (ForceCountNewOnly = 1)
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

CheckValid(Word,ForceLearn:=false)
{
   
   if (Word = "")  ;If we have no word to add, skip out.
      Return
            
   if isSpace(Word) ;If Word is only whitespace, skip out.
      Return
   
   if ( SubStr(Word, 1, 1) = ";" ) ;If first char is ";", clear word and skip out.
   {
      Return
   }
   
   IF ( StrLen(Word) <= prefs_Length ) ; don't add the word if it's not longer than the minimum length
   {
      Return
   }
   
   ;Anything below this line should not be checked if we want to Force Learning the word (Ctrl-Shift-C or coming from wordlist.txt)
   If ForceLearn
      Return 1
   
   ;if Word does not contain at least one alpha character, skip out.
   if (1 = 1)
   {
      if ( RegExMatch(Word, "S)\pL") = 0 )  
      {
         return
      }
   } else if ( RegExMatch(Word, "S)[a-zA-Zà-öø-ÿÀ-ÖØ-ß]") = 0 )
   {
      Return
   }
   
   Return 1
}

TransformWord(AddWord, AddWordReplacement, AddWordDescription, &AddWordTransformed, &AddWordIndexTransformed, &AddWordReplacementTransformed, &AddWordDescriptionTransformed)
{
   AddWordIndex := AddWord
   
   ; normalize accented characters
   AddWordIndex := StrUnmark(AddWordIndex)
   
   AddWordIndex := StrUpper(AddWordIndex)
   
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   AddWordTransformed := StrReplace(AddWord, "'", "''")
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   AddWordIndexTransformed := StrReplace(AddWordIndex, "'", "''")
   if (AddWordReplacement) {
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      AddWordReplacementTransformed := StrReplace(AddWordReplacement, "'", "''")
   }
   if (AddWordDescription) {
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      AddWordDescriptionTransformed := StrReplace(AddWordDescription, "'", "''")
   }
}

DeleteWordFromList(DeleteWord)
{
   global prefs_LearnMode
   global g_WordListDB
   
   if (DeleteWord = "")  ;If we have no word to delete, skip out.
      Return
            
   if isSpace(DeleteWord) ;If DeleteWord is only whitespace, skip out.
      Return
   
   if (prefs_LearnMode != "On")
      Return
   
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   DeleteWordEscaped := StrReplace(DeleteWord, "'", "''")
   g_WordListDB.Query("DELETE FROM words WHERE word = '" . DeleteWordEscaped . "';")
      
   Return 
}

;------------------------------------------------------------------------

UpdateWordCount(word,SortOnly)
{
   global prefs_LearnMode
   global g_WordListDB
   ;Word = Word to increment count for
   ;SortOnly = Only sort the words, don't increment the count
   
   ;Should only be called when LearnMode is on  
   if (prefs_LearnMode = "Off")
      Return
   
   if (SortOnly = "")
      Return

   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   wordEscaped := StrReplace(word, "'", "''")
   g_WordListDB.Query("UPDATE words SET count = count + 1 WHERE word = '" . wordEscaped . "';")
   
   Return
}

;------------------------------------------------------------------------

CleanupWordList(LearnedWordsOnly := false)
{
   ;Function cleans up all words that are less than the LearnCount threshold or have a NULL for count
   ;(NULL in count represents a 'wordlist.txt' word, as opposed to a learned word)
   global g_ScriptTitle
   global g_WordListDB
   global prefs_LearnCount
   ProgressGui := Gui("ToolWindow -Sysmenu"), ProgressGui.Title := g_ScriptTitle , ProgressGui.SetFont("Bold"), ProgressGui.AddText("x0 w200 Center", "Cleaning wordlist"), gocProgress := ProgressGui.AddProgress("x10 w180 h20"), ProgressGui.SetFont(""), ProgressGui.AddText("x0 w200 Center", "Please wait..."), ProgressGui.Show("")
   if (LearnedWordsOnly) {
      g_WordListDB.Query("DELETE FROM Words WHERE count < " . prefs_LearnCount . " AND count IS NOT NULL;")
   } else {
      g_WordListDB.Query("DELETE FROM Words WHERE count < " . prefs_LearnCount . " OR count IS NULL;")
   }
   ProgressGui.Destroy
}

;------------------------------------------------------------------------

MaybeUpdateWordlist()
{
   global g_LegacyLearnedWords
   global g_WordListDB
   global g_WordListDone
   global prefs_LearnCount
   
   ; Update the Learned Words
   if (g_WordListDone = 1)
   {
      
      SortWordList := g_WordListDB.Query("SELECT Word FROM Words WHERE count >= " . prefs_LearnCount . " AND count IS NOT NULL ORDER BY count DESC;")
      
      for each, row in SortWordList.Rows
      {
         TempWordList .= row[1] . "`r`n"
      }
      
      If ( SortWordList.Count > 0 )
      {
         TempWordList := SubStr(TempWordList, 1, -1*(2))
   
         FileDelete(A_ScriptDir "\Temp_WordlistLearned.txt")
         FileAppendDispatch(TempWordList, A_ScriptDir . "\Temp_WordlistLearned.txt")
         FileCopy(A_ScriptDir "\Temp_WordlistLearned.txt", A_ScriptDir "\WordlistLearned.txt", 1)
         FileDelete(A_ScriptDir "\Temp_WordlistLearned.txt")
         
         ; Convert the Old Wordlist file to not have ;LEARNEDWORDS;
         if (g_LegacyLearnedWords = 1)
         {
            TempWordList := ""
            ParseWords := Fileread(A_ScriptDir "\Wordlist.txt")
            LearnedWordsPos := InStr(ParseWords, "`;LEARNEDWORDS`;", true, 1) ;Check for Learned Words
            TempWordList := SubStr(ParseWords, 1, LearnedwordsPos - 1) ;Grab all non-learned words out of list
            ParseWords := ""
            FileDelete(A_ScriptDir "\Temp_Wordlist.txt")
            FileAppendDispatch(TempWordList, A_ScriptDir . "\Temp_Wordlist.txt")
            FileCopy(A_ScriptDir "\Temp_Wordlist.txt", A_ScriptDir "\Wordlist.txt", 1)
            FileDelete(A_ScriptDir "\Temp_Wordlist.txt")
         }   
      }
   }
   
   g_WordListDB.Close()
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
   Loop{
      VarSetStrCapacity(&buf, len * 2) ; V1toV2: if 'buf' is NOT a UTF-16 string, use 'buf := Buffer(len * 2)'
      len := DllCall("Normaliz.dll\NormalizeString", "int", g_NormalizationKD, "wstr", string, "int", StrLen(string), "ptr", buf, "int", len)
      if (len >= 0)
         break
      if (A_LastError != 122) ; ERROR_INSUFFICIENT_BUFFER
         return string
      len *= -1  ; This is the new estimate.
   }
   ; Remove combining marks and return result.
   string := RegExReplace(StrGet(&buf, len, "UTF-16"), "\pM")
   
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   string := StrReplace(string, "ae", "ae")

   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   string := StrReplace(string, "ae", "AE")
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   string := StrReplace(string, "œ", "oe")
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   string := StrReplace(string, "oe", "OE")
   ; StrReplace() is not case sensitive
   ; check for StringCaseSense in v1 source script
   ; and change the CaseSense param in StrReplace() if necessary
   string := StrReplace(string, "b", "bb")
   
   return string  
   
}