Class App_Infos {
    static name := "The Application"
}


Class Model {

    __New(*) {
        this.button_times_clicked := 0
        this.edit_box_value := ""
    }
}


Class View Extends Gui {

    GUI_WIDTH := 400

    __New(controller_arg, win_title) {
        super.__New(, Title := win_title)
        super.Opt("+OwnDialogs")

        this.controller := controller_arg

        this.nice_btn := this.Make_Nice_Button()
        this.nice_edit := this.Make_Nice_Edit()

        super.Show("w" this.GUI_WIDTH)
        super.OnEvent("Close", this.Close_View)
        super.OnEvent("Escape", this.Close_View)
    }

    Make_Nice_Button() {
        control := super.Add("button", , "I'm a nice button")
        control.OnEvent("Click",this.Click_Nice_Button.Bind(this))
        ;this.Make_Nice_Edit()
        Return control
    }
    Make_Nice_Edit(){
        msgbox("Make_Nice_Edit() called")
        control := super.Add("edit", ,"I'm an edit")
        control.OnEvent("CLICK", this.Get_Nice_Edit.bind(this))
        return control
    }

    Click_Nice_Button(*) {
        this.controller.Click_Nice_Button()
        ;this.controller.Get_Nice_Edit()
    }
    Get_Nice_Edit() {
        this.controller.Get_Nice_Edit()
    }

    Close_View(*) {
        this.controller.Close_View()
    }
}


Class Controller {

    __New(model_arg) {
        this.model := model_arg
        this.view := View(this, App_Infos.name)
        this.is_done := false
    }

    Click_Nice_Button() {
        this.model.button_times_clicked += 1
        this.model.edit_box_value
        times := this.model.button_times_clicked
        Text := this.model.edit_box_value
        MsgBox "You clicked me " times " time(s) !`nThe" TEXT "IS THE VALUE OF BOX"
    }
    Get_Nice_Edit() {
        Text := this.model.edit_box_value
        msgbox "value is" Text "!"
    }

    Close_View() {
        this.is_done := true
        this.view.Destroy()
    }
}


my_model := Model()
my_app := Controller(my_model)

While not my_app.is_done {  ; Waits for the View to be closed.
}

times := my_model.button_times_clicked
MsgBox "This is done !`nThe nice button was clicked " times " time(s) !"
