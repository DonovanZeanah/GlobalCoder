MyVar := "This`nis`nan`nexample`nstring`nto`nbe`nsorted"
MsgBox Sort(MyVar,, LengthSort)
LengthSort(a1, a2, *)
{
    a1 := StrLen(a1), a2 := StrLen(a2)
    return a1 > a2 ? 1 : a1 < a2 ? -1 : 0  ; Sorts according to the lengths determined above.
}

MyVar := "5,3,7,9,1,13,999,-4"
MsgBox Sort(MyVar, "D,", IntegerSort)
IntegerSort(a1, a2, *)
{
    return a1 - a2  ; Sorts in ascending numeric order. This method works only if the difference is never so large as to overflow a signed 64-bit integer.
}

MyVar := "1,2,3,4"
MsgBox Sort(MyVar, "D,", ReverseDirection)  ; Reverses the list so that it contains 4,3,2,1
ReverseDirection(a1, a2, offset)
{
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}

MyVar := "a bbb cc"
; Sorts in ascending length order; uses a fat arrow function:
MsgBox Sort(MyVar, "D ", (a,b,*) => StrLen(a) - StrLen(b))
