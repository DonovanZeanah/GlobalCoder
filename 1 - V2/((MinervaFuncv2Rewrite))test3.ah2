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