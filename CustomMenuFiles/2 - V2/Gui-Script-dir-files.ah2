MyGui := Gui()
MyGui.Add("Text",, "Pick a file to launch from the list below.")
LB := MyGui.Add("ListBox", "w640 r10")
LB.OnEvent("DoubleClick", LaunchFile)
Loop Files, "C:\*.*"  ; Change this folder and wildcard pattern to suit your preferences.
    LB.Add([A_LoopFilePath])
MyGui.Add("Button", "Default", "OK").OnEvent("Click", LaunchFile)
MyGui.Show()

LaunchFile(*)
{
    if MsgBox("Would you like to launch the file or document below?`n`n" LB.Text,, 4) = "No"
        return
    ; Otherwise, try to launch it:
    try Run(LB.Text)
    if A_LastError
        MsgBox("Could not launch the specified file. Perhaps it is not associated with anything.")
}