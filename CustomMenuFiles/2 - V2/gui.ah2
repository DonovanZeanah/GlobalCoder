MyGui := Gui()
MyGui.Add("Text",, "Enter some Text and press Submit:")
MyGui.Add("Edit", "vMyEdit")
MyGui.Add("Button",, "Submit").OnEvent("Click", Submit)
MyGui.Show

Submit(*)
{
    Saved := MyGui.Submit(false)
    MsgBox "Content of the edit control: " Saved.MyEdit
}