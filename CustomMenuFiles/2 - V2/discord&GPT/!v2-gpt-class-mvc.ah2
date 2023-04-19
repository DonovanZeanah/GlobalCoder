; Example Usage
controller := TaskController()
view1 := TaskView(controller)

view1.AddTask("Task 1", "Description 1")
view1.AddTask("Task 2", "Description 2")
view1.AddTask("Task 3", "Description 3")

view1.DisplayTasks()


; Model
class Task {
    Name := ""
    Description := ""

    __New(name, description) {
        this.Name := name
        this.Description := description
    }
}

; Controller
class TaskController {
    TaskList := []

    AddTask(name, description) {
        task := TaskFactory.Create(name, description)
        this.TaskList.Push(task)
    }

    GetTasks() {
        return this.TaskList
    }
}

; View
class TaskView {
    Controller := ""

    __New(controller) {
        this.Controller := controller
    }

    AddTask(name, description) {
        this.Controller.AddTask(name, description)
    }

    DisplayTasks() {
        Gui1 := Gui()
        lv := Gui1.Add("ListView", {w: 400, h: 300}, "Name|Description")
        Gui1.OnEvent("Close", () => ExitApp())

        tasks := this.Controller.GetTasks()
        for task in tasks {
            lv.Add("", task.Name, task.Description)
        }

        Gui1.Show()
    }
}

; Factory
class TaskFactory {
    static __new(){
        return Task(name, description)
    }
    __new(){
            return Task(name, description)
        }
    static Create(name, description) {
        return Task(name, description)
    }
}




/*; Model
; Model
class Task {
    Name := ""
    Description := ""

    __New(name, description) {
        this.Name := name
        this.Description := description
    }
}

; Controller
class TaskController {
    TaskList := []

    AddTask(name, description) {
        task := TaskFactory.Create(name, description)
        this.TaskList.Push(task)
    }

    GetTasks() {
        return this.TaskList
    }
}

; View
class TaskView {
    Controller := ""

    __New(controller) {
        this.Controller := controller
    }

    AddTask(name, description) {
        this.Controller.AddTask(name, description)
    }

    DisplayTasks() {
        Gui, New
        Gui, Add, ListView, w400 h300, Name|Description

        tasks := this.Controller.GetTasks()
        for task in tasks {
            LV_Add("", task.Name, task.Description)
        }

        Gui, Show, , Task List
    }
}

; Factory
class TaskFactory {
    static Create(name, description) {
        return new Task(name, description)
    }
}

; Example Usage
controller := new TaskController()
view := new TaskView(controller)

view.AddTask("Task 1", "Description 1")
view.AddTask("Task 2", "Description 2")
view.AddTask("Task 3", "Description 3")

view.DisplayTasks()

GuiClose:
ExitApp

*/