/*class Task {
    Name := ""
    Duration := 0
    Value := 0

    __New(name, duration, value) {
        this.Name := name
        this.Duration := duration
        this.Value := value
    }

    Rank() {
        return this.Value / this.Duration
    }
}

class TaskList {
    Tasks := []

    AddTask(task) {
        this.Tasks.Push(task)
    }

    RankTasks() {
        this.Tasks.Sort((a, b) => b.Rank() - a.Rank())
    }

    DisplayTasks() {
        for task in this.Tasks {
            MsgBox "Task: " task.Name ", Duration: " task.Duration ", Value: " task.Value ", Rank: " task.Rank()
        }
    }
}

*/


class Task {
    Name := ""
    Duration := 0
    Value := 0

    __New(name, duration, value) {
        this.Name := name
        this.Duration := duration
        this.Value := value
    }

    Rank() {
        return this.Value / this.Duration
    }
}

class TaskList {
    Tasks := []

    AddTask(task) {
        this.Tasks.Push(task)
    }

    RankTasks() {
        this.Tasks.Sort((a, b) => b.Rank() - a.Rank())
    }

    DisplayTasks() {
        Gui, New
        Gui, Add, ListView, w400 h300, Task|Duration|Value|Rank

        for task in this.Tasks {
            LV_Add("", task.Name, task.Duration, task.Value, task.Rank())
        }

        Gui, Show, , Ranked Tasks
    }
}

; Create tasks
/*task1 := new Task("Task 1", 2, 30)
task2 := new Task("Task 2", 4, 50)
task3 := new Task("Task 3", 1, 10)

; Add tasks to a task list
taskList := new TaskList()
taskList.AddTask(task1)
taskList.AddTask(task2)
taskList.AddTask(task3)

; Rank tasks
taskList.RankTasks()

; Display tasks
taskList.DisplayTasks()

GuiClose:
ExitApp

*/
;
; Create tasks
task1 := Task("Task 1", 2, 30)
task2 := Task("Task 2", 4, 50)
task3 := Task("Task 3", 1, 10)

; Add tasks to a task list
taskList1 := new TaskList()
taskList1.AddTask(task1)
taskList1.AddTask(task2)
taskList1.AddTask(task3)

; Rank tasks
taskList1.RankTasks()

; Display tasks
taskList1.DisplayTasks()
