Class SD {
    __New() {
       
        this.items := {}
    }

    givevalues(item, x := 0) {

         ; this.item lets me add a variable item to the insance of the class
        if !this.items.HasKey(item) {
            this.items[item] := x
            Msgbox % "First " x " " item " added"
        }
        else {
            this.items[item] += x
            Msgbox % x " " item " added"
        }
    }
}

screwdriver := new SD()
screwdriver.givevalues("screws", 100)
screwdriver.givevalues("screws", 100)
msgbox % screwdriver.items.screws