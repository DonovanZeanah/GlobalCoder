# MSSA CCAD 8

Started on 10/3/2022
Week 2: 2022.10.10-2022.10.14

## Week 2 - Object-Oriented Programming

During week 2, we're going to cover the principals for Object-Oriented Programming

## Day 1 - Classes and Inheritance

During day 1, we'll dive into classes and interfaces.

### Morning

1. Questions

1. Open Book Quiz [Work together to create a program]

1. Learning about classes

    - [Base Object Class](https://learn.microsoft.com/en-us/dotnet/api/system.object?view=net-7.0)
    - [Constructors](https://learn.microsoft.com/en-us/dotnet/api/system.object.-ctor?view=net-7.0)
        - Default constructor
        - Explicit constructor
        - What happens when explicit constructor is used?
    - [Methods: ToString()](https://learn.microsoft.com/en-us/dotnet/api/system.object.tostring?view=net-7.0)
    - [Overriding ToString()](https://learn.microsoft.com/en-us/dotnet/api/system.object.tostring?view=net-7.0#overriding-the-objecttostring-method)
    - PerformActionRun() Custom method
    - Overloading
        - PerformActionRun(double multiplier) 
            Same as original name but has additional parameters
    
1. Class activity: Create an object and use it
    - Contains three properties (VIN, Make, Model)
    - Contains overloaded constructors (default/explicit)
    - Contains a special method (HonkTheHorn())
    - Overrides ToString (override string ToString())
    - Overloads the special method (HonkTheHorn(int intensity))

### Afternoon

This afternoon, now that we understand classes, we'll look at the following:

1. Structures
    - Build a simple lightweight object for use in our code
    - Affect Values in methods (by value vs. by reference)
    - By Value vs. By Reference in action (int, myKVP, Person)
    - MemberwiseClone versus new Person()

1. Inheritance
    - Build an advanced person/vehicle type
    - Utilize in code

1. Polymorphism
    - Use person/vehicle objects Polymorphically
    - Create a loop and iterate at the base level

### Questions

1. How do you implement an Object Inheritance Hierarchy?
1. Which complex type is stored "by value"?
1. Which complex type is stored "by reference"?
1. Which complex type is stored on the stack?
1. Which complex type is stored on the heap?
1. Why is polymorphism so powerful?
1. In your own words, give an example of polymorphism.
1. When do you not automatically get a default constructor?
1. What is a benefit of using a complex constructor?
1. Why might you implement a method that clones an object?
1. What does it mean to override a method?  Give an example.
1. What does it mean to overload a method?  Give an example.

### Day 2: Inheritance & Interfaces

Week 2 - Day 2 covers the more complex concepts of inheritance, including Interfaces and Abstract Classes.

1. Lab 6 

1. Interfaces and Abstract Classes 

    Define a couple of interfaces:

    ```c#
    public interface IRemote : ICommonPrint
    {
        string PowerOn();
        string PowerOff();
        string ChangeVolume(int value);
        string ChangeChannel(int value);
    }

    public interface ICommonPrint
    {
        string PrintSomething();
    }
    ```

    Define an abstract class (common functionality with delegation)

    ```c#
    public abstract class BaseRemote : IRemote
    {
        public string ChangeChannel(int value)
        {
            return "Changing Channel";
        }

        public string ChangeVolume(int value)
        {
            return "Changing Volume";
        }

        public string PowerOff()
        {
            TurnOffPower();
            return "Turning off the TV";
        }

        public string PowerOn()
        {
            TurnOnPower();
            return "Turning on the TV";
        }

        public abstract void TurnOffPower();
        public abstract void TurnOnPower();


        public string PrintSomething()
        {
            return "I'm a remote";
        }
    }
    ```  

    Define a couple of implementations:

    ```c#
    public class AdvancedRemote : BaseRemote
    {
        public string ChangeChannel(int value)
        {
            throw new NotImplementedException();
        }

        public string ChangeVolume(int value)
        {
            throw new NotImplementedException();
        }

        public override void TurnOffPower()
        {
            Console.WriteLine("Putting into standby mode");
        }

        public override void TurnOnPower()
        {
            Console.WriteLine("Waking from standby mode");
        }
    }

    public class UniversalRemote : BaseRemote
    {
        public string ChangeChannel(int value)
        {
            throw new NotImplementedException();
        }

        public string ChangeVolume(int value)
        {
            throw new NotImplementedException();
        }

        public override void TurnOffPower()
        {
            Console.WriteLine("Turning off power from universal source");
        }

        public override void TurnOnPower()
        {
            Console.WriteLine("Turning on power from universal source");
        }
    }
    ```  

### After Lunch Challenge:

Working with Interfaces, Abstract Classes, and Polymorphism.

For simplicity, in the methods below, just always return a string that says what the method is doing.

1. Create a new Class called Computer

    In the class, have methods for 

    - LoadProgram
    - RunProgram
    - PowerOn
    - PowerOff
    - Overclock

1. Create a new class called Laptop

    In the class have methods for

    - LoadProgram
    - RunProgram
    - PowerOn
    - PowerOff
    - Overclock
    - HoursOfPowerAvailable

1. Create a new class called Television

    In the class have methods for

    - TurnTVOn
    - TurnTVOff
    - ChangeChannel
    - ChangeVolume

1. Create a new class called Car

    In the class have methods for

    - VIN
    - StartEngine
    - ShutOffEngine
    - Drive
    - Park

1. Identify the common classes and build an inheritance tree.

1. Implement program.cs to iterate at all base type levels

    - List of Computer
    - List of Television
    - List of Car

1. Add an IPowerable interface with methods:

    - TurnOn()
    - TurnOff()

1. Implement the interface on all items using inheritance where possible

    - three places

1. Utilize mapping in each implementation to call the appropriate "Turn On" and "Turn Off" methods

1. Build one statement in the main program that creates a list with all IPowerable objects

1. Call the turn on method for all objects in one line of code

1. Convert computer to abstract

1. Create a Desktop implementation of Computer

1. Delegate a function called PerformOverclock from the base abstract class

1. Implement delegation in all the methods by overriding PerformOverclock

1. Use type-safe checking to convert computer objects and call to their OverClock method

### Team Challenge [started late, will continue into the day tomorrow]:

Please do the work individually on your own machine but work as a team to complete a solution for Lab 7.

### Extra stuff you can do at this point

For practice, if you want to try something.

1. Look around your room.  Find any object.  Define 4-10 properties for that object.  Model the object in code.  Use the object in a List.
1. Create a program that takes input and give output.  Validate responses.  Loop until complete.
1. Create an inheritance hierarchy for any objects in code.  Reuse common functionality at the base level.
1. Create an interface with common method definitions.  Create an abstract base class to implement them.  Create two or more implementations of the base class.  Enforce a method be written in the subclasses by defining an abstract method in the abstract class.

### Review Questions

1. What are some benefits of using an interface
1. Are the following code statements valid (yes or no)?

- int x = 32;
- double y = 32;
- string t = "the data";
- Computer computer = new Computer();  //assume Computer is an abstract class
- Computer computer = new Laptop();
- IPowerable computer = new IPowerable();
- List&lt;IPowerable&gt; computers = new List&lt;IPowerable&gt;();

1. How do you force methods to be implemented in a class hierarchy
1. What is the difference between an abstract class and an interface?

## Day 3 - File I/O

During day 3 of week 2, we'll complete lab 7 to wrap up our first look at inheritance.  We'll then dive into File I/O.

### Morning

1. Questions/Review

1. Lab 7 Teams through lunch (unless finished early)

### Afternoon

1 Git Demo (quick)

    - git checkout -b <branch-name>
    - git push -u origin <branch-name>
    - ...make some changes
    - commit locally
    - push to branch at github
    - create a pull request
    - merge the pull request
    - cleanup branch

1. File I/O demonstration and practice

- Read and write text files
- Object Serialization
- JSON Serialization
- Write JSON to file/Restore from file
- Read and write binary data to files

1. Lab 8 File I/O Integration

- Integrate learning from File I/O to write the data into a file and restore from file on load.

### Review questions

1. How do you read and write to text files?
1. What does it mean to "serialize" an object?
1. Is serialization limited to binary data?
1. How do you utilize binary serialization to write to a file?
1. How do you read an object from a file as binary data?
1. What is the purpose of a using statement?

## Day 4 - Wrap up on part 1

Day four of week two is the last day for the first part of our course.  We'll be moving into Data next week!

### Morning

1. Lingering questions

1. Programming Challenge #1 [Mortgage Calculator].

### Afternoon

1. Complete the challenge

1. Lab 8 if time, otherwise, lab 8 becomes additional practice.

### Conclusion

This week we completed our work on the first introduction to programming. This has been an intense two weeks but I'm extremely pleased with our progress to this point!

We get to move to data next week, but we'll keep working with our C# skills so they don't get too rusty!

## Additional Training

Complete the following learn modules:

1. [Take your first steps with C#](https://learn.microsoft.com/en-us/training/paths/csharp-first-steps/?WT.mc_id=dotnet-35129-website)
1. [Add logic to your applications with C#](https://learn.microsoft.com/en-us/training/paths/csharp-logic/?WT.mc_id=dotnet-35129-website)
1. [Work with data in C#](https://learn.microsoft.com/en-us/training/paths/csharp-data/?WT.mc_id=dotnet-35129-website)'
1. [Build .Net Applications](https://learn.microsoft.com/en-us/training/paths/build-dotnet-applications-csharp/)  

Watch all the following videos:

1. [C# for Beginners](https://www.youtube.com/watch?v=BM4CHBmAPh4&list=PLdo4fOcmZ0oVxKLQCHpiUWun7vlJJvUiN) 

Extrapolate:

1. Use your knowledge of what you've learned.
1. Find a problem that needs to be solved
1. Create code to solve the problem.

Examples:

1. Physics Calculations
1. Fitness Tracking (Athlete)
1. AutoLot (Vehicles)
1. Conference Manager (Tracks, Rooms, Speakers)
1. University Student Course Manager (Instructors, Students, Courses with Sections at different times, Schedule)