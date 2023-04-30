
ParentGui := ParentView(ParentController(ParentModel(300, 300, "Parent")))
ChildView(ChildController(ChildModel( 0,  0, 50, "Icon.ico", ParentGui)))
ChildView(ChildController(ChildModel(50,  0, 50, "Icon.ico", ParentGui)))
ChildView(ChildController(ChildModel( 0, 50, 50, "Icon.ico", ParentGui)))
ChildView(ChildController(ChildModel(50, 50, 50, "Icon.ico", ParentGui)))

class ViewModel extends View
{
    Prop1
    {
        get => this._text1.Text
        set => this._text1.Text := Value
    }

    __New() {
        super.__New()
        this._button.OnEvent("Click", ObjBindMethod(this, "ButtonClicked"))
    }

    ButtonClicked(*) {
        this.Prop1 := "Button Clicked"
    }
}

class View extends Gui
{
    __New() {
        super.__New("-DPIScale")
        this._text1 := super.Add("Text", "xm ym r1 w200")
        this._button := super.Add("Button", "xm y+m", "button")
        super.Show("w400 h400 Center")
    }
}



class ParentModel {
    __New(w, h, title) {
        this.w := w
        this.h := h
        this.title := title
   }
}
class ParentController {
    __New(model) {
        this.model := model
    }
    Gui_Close(Gui) {
        Gui.Destroy()
    }
}
class ParentView extends Gui {
    __New(controller) {
        super.__New(, controller.model.title)
        super.Show("w" controller.model.w " h" controller.model.h)
        super.OnEvent("Close",  ObjBindMethod(controller, "Gui_Close"))
        super.OnEvent("Escape", ObjBindMethod(controller, "Gui_Close"))
    }
}

class ChildModel {
    __New(x, y, w, icon, parent) {
        this.x := x
        this.y := y
        this.w := w
        this.h := w
        this.bar := {h:10, time:800, color:"White", backColor:"Gray"}
        this.icon := {w:36, h:36, file:icon}
        this.parent := parent
    }
}
class ChildController {
    __New(model) {
        this.model := model
    }
    LoadIcon(GuiCtrl, *) {
        if icon := FileSelect(3, "./" , "Select an Icon", "*.png; *.ico")
            GuiCtrl.Value := this.model.icon.file := icon
   }
}
class ChildView extends Gui {
    __New(controller) {
        super.__New("-Border -Caption -SysMenu +ToolWindow -0x800000 +E0x08000000 +Parent" controller.model.parent.hwnd)
        super.MarginX := (controller.model.w - controller.model.icon.w) // 2
        super.MarginY := (controller.model.h - controller.model.icon.h - controller.model.bar.h) // 2
        pic := super.Add("Picture", "xm ym w" controller.model.icon.w " h" controller.model.icon.h, controller.model.icon.file)
        bar := super.Add("Progress", "xm y" (controller.model.h - controller.model.bar.h) " w" controller.model.icon.w " h" controller.model.bar.h " c" controller.model.bar.color " Background" controller.model.bar.backColor)
        super.Show("x" controller.model.x " y" controller.model.y " w" controller.model.w " h" controller.model.h)
        pic.OnEvent("Click", ObjBindMethod(CoolDownTimer(controller.model.bar.time, bar), "Start"))
        pic.OnEvent("ContextMenu", ObjBindMethod(controller, "LoadIcon"))
   }
}

