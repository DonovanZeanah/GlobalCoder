; Create an instance of Employee with age 25, name John and title Manager
emp1 := new Employee(25, "John", "Manager")

; Call ShowInfo method on emp1 object
emp1.ShowInfo()

MsgBox(emp1.age)

class Employee
{
    ; Constructor method
    __New(age, name, title)
    {
        this.age := age
        this.name := name
        this.title := title
    }

    ; Method to display employee info
    ShowInfo()
    {
        MsgBox ("Name: " . this.name . "`nAge: " . this.age . "`nTitle: " . this.title)
    }
    
}