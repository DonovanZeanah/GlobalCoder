MyGui := Gui("+Resize")
MyBtn := MyGui.Add("Button", "default", "&Load New Image")
MyBtn.OnEvent("Click", LoadNewImage)
MyRadio := MyGui.Add("Radio", "ym+5 x+10 checked", "Load &actual size")
MyGui.Add("Radio", "ym+5 x+10", "Load to &fit screen")
MyPic := MyGui.Add("Pic", "xm")
MyGui.Show()

LoadNewImage(*)
{
    Image := FileSelect(,, "Select an image:", "Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)")
    if Image = ""
        return
    if (MyRadio.Value)  ; Display image at its actual size.
    {
        Width := 0
        Height := 0
    }
    else ; Second radio is selected: Resize the image to fit the screen.
    {
        Width := A_ScreenWidth - 28  ; Minus 28 to allow room for borders and margins inside.
        Height := -1  ; "Keep aspect ratio" seems best.
    }
    MyPic.Value := Format("*w{1} *h{2} {3}", Width, Height, Image)  ; Load the image.
    MyGui.Title := Image
    MyGui.Show("xCenter y0 AutoSize")  ; Resize the window to match the picture size.
}