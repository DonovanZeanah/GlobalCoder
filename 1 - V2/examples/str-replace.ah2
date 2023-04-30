
;remove cr-lf's

A_Clipboard := StrReplace(A_Clipboard, "`r`n")

;replace space with +
NewStr := StrReplace(OldStr, A_Space, "+")

;Removes all blank lines from the text in a variable.

Loop
{
    MyString := StrReplace(MyString, "`r`n`r`n", "`r`n",, &Count)
    if (Count = 0)  ; No more replacements needed.
        break
}