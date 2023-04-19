#c:: ; Win+C
{
    A_Clipboard := "" ; Must be blank for detection to work.
    Send "^c"
    if !ClipWait(2)
        return
    MsgBox "Ready to be pasted:`n" Sort(A_Clipboard)
}