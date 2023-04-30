if PixelSearch(&Px, &Py, 200, 200, 300, 300, 0x9d6346, 3)
    MsgBox "A color within 3 shades of variation was found at X" Px " Y" Py
else
    MsgBox "That color was not found in the specified region."
