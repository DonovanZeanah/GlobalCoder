#include <vis2>

OCR()              ; OCR to clipboard

Vis2.Graphics.Subtitle.Render("Press [Win] + [c] to highlight and copy anything on-screen.", "time: 30000 xCenter y92% p1.35% cFFB1AC r8", "c000000 s2.23%")
tr := Vis2.Graphics.Subtitle.Render("Processing test.jpg... Please wait", "xCenter y67% p1.35% c88EAB6 r8", "s2.23% cBlack")


tr.Destroy()
return