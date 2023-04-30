Haystack := "The quick brown fox jumps over the lazy dog."
RegExMatch(Haystack, "i)(The) (\w+)\b(?CCallout)")
Callout(m, *) {
    MsgBox "m[0]=" m[0] "`nm[1]=" m[1] "`nm[2]=" m[2]
    return 1
}