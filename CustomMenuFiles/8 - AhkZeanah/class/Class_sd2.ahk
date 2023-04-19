Class SD {
    __New() {
        this.items := {}
    }

    givevalues(item, x := 0) {
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
screwdriver.givevalues("bolts", 50)
screwdriver.givevalues("nuts", 250)
screwdriver.givevalues("screws", 100)

print(screwdriver["items"])