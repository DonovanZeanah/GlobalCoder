; Input OutputVar, % Options, % EndKeys, % MatchList  ; v1
ih := InputHook(Options, EndKeys, MatchList)
ih.Start()
ErrorLevel := ih.Wait()
if (ErrorLevel = "EndKey")
    ErrorLevel .= ":" ih.EndKey
OutputVar := ih.Input