StdIn(max_chars=0xfff)
{
    static hStdIn=-1
    [color=orange]; The following is for vanilla compatibility
    ptrtype := (A_PtrSize = 8) ? "ptr" : "uint"[/color]

    if (hStdIn = -1)
    {
        hStdIn := DllCall("GetStdHandle", "UInt", -10[color=orange],  ptrtype[/color]) ; -10=STD_INPUT_HANDLE
        if ErrorLevel
            return 0
    }

    max_chars := VarSetCapacity(text, max_chars[color=orange]*(!!A_IsUnicode+1)[/color], 0)

    ret := DllCall("ReadFile"
        ,  [color=orange]ptrtype[/color], hStdIn        ; hFile
        ,  "Str", text          ; lpBuffer
        , "UInt", max_chars[color=orange]*(!!A_IsUnicode+1)[/color]     ; nNumberOfBytesToRead
        , "UInt*", bytesRead    ; lpNumberOfBytesRead
        ,  [color=orange]ptrtype[/color], 0)            ; lpOverlapped

    return text
}