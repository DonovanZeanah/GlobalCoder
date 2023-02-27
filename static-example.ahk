html =
(
<!DOCTYPE html>
<html>
    <head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta charset="utf-8" />
	<title>HTMLFile</title>
    </head>
<body>
<canvas id="canvas"></canvas>
</body>
</html>
)

Gui, Add, ActiveX, w400 h400 vDoc, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
Doc.document.Open()
Doc.document.Write(html)
Doc.document.Close()
Gui, Show
canvas := Doc.document.getElementById("canvas")

canvas := Doc.document.getElementById("canvas")
ctx := canvas.getContext("2d")
ctx.fillRect(10, 10, 100, 100)
sq := new Square()
return

!i::sq.setColor("red")

Class Square {

	static sides := 4
	color := "green"
	
	setColor(__color) {
	global canvas
	ctx := canvas.getContext("2d")
	ctx.fillStyle := (this.color:=__color)
	ctx.fillRect(10, 10, 100, 100)
	}

}
