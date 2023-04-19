# Lab 6 - Classes and Structs

In this lab, you will utilize your learning about classes and structs.

After completing this lab, you will be able to 

- Understand, Create, and Use structures
- Create and leverage classes in C#
- Know the difference between value and reference types

## Overview

The lab will consist of utilizing a struct and then moving to working with classes.  Building from the ground up, you'll see a couple of the differences between the two types.

During this lab, you will also be exploring the idea of value versus reference types.  

### Exercise 1: Working with Structures

In this first exercise, you will create a structure to model the data for storing course information.

#### Task 1: Create the structure

Open the starter project.  Utilize your learning to complete the following tasks.

1. Create a new structure called Course

    Use C# to create a structure that contains the following properties:

    - CourseNumber: string
    - Title: string
    - Credit Hours: integer
    - Program: string
    - Instructor: string

1. Use your struct to model three courses:

    Use the following information to create some courses:

    - CourseNumber: CS101
    - Title: Introduction to Computer Science
    - Credit Hours: 2
    - Program: COMSCI
    - Instructor: Turing  
      
    - CourseNumber: CS201
    - Title: Introduction to Programming with C#
    - Credit Hours: 4
    - Program: COMSCI
    - Instructor: Hejlsberg

    - CourseNumber: CS301
    - Title: Introduction to Databases
    - Credit Hours: 4
    - Program: COMSCI
    - Instructor: Chamberlin & Boyce

#### Task 2: Put your objects in a data structure

Choose the best data structure and utilize it in the following operations:

1. Create a collection of courses

    Utilize the best data structure for storing a collection of courses

1. Display the collection of courses

    Use your knowledge of C# to iterate your data structure storing your courses and print the details of each course in the collection

### Excercise 2: Create object classes

In this exercise, you will enhance your learning by creating and working with classes.

#### Task 1: Create a new class - Instructor

To get started, you will need an object class that will store information about an instructor.

1. Use your knowledge of creating classes to create a new Instructor class

    Add the following public properties to the Instructor class:

    - FirstName: string
    - LastName: string
    - Age: int
    - Program: string
    - Courses: List<Course>

    >**Hint:** The Instructor class should be in its own file

1. Create four instructors

    - FirstName: Alan
    - LastName: Turing
    - Age: 41
    - Program: COMSCI
    - Courses: List<Course>
        - add the CS101 course created above

    - FirstName: Anders
    - LastName: Hejlsberg
    - Age: 61
    - Program: COMSCI
    - Courses: List<Course>
        - add the CS201 course created above

    - FirstName: Raymond
    - LastName: Boyce
    - Age: 27
    - Program: COMSCI
    - Courses: List<Course>
            - add the CS301 course created above
        
    - FirstName: Donald
    - LastName: Chamberlin
    - Age: 77
    - Program: COMSCI
    - Courses: List<Course>
            - add the CS301 course created above


#### Task 2: Create a list of Instructors

In this task, you'll utilize a list to be able to manage your instructors

1. Create a List of instructors

    Use your knowledge of C# to create a List of Instructor

1. Add the four instructors to the list

    Add each instructor to the list

1. Display information about all Instructors

    Utilize a loop of your choice to display the information for each instructor, including the details about any courses they are teaching.

1. Thinking ahead

    - What happens if the instructor teaches more than one course?
    - Will your previous solution still work?

### Exercise 3: Value types versus Reference Types

Classes and structures both hold data in a way that lets you easily manage object properties.

1. Experiment with value types

    One of the more important call-outs from this training will be the utilization of memory by value types versus reference types.

    Which of the following are value types, and which are reference types?

    - int
    - string
    - double
    - bool
    - Course
    - Instructor
    - int[]
    - List<int>

    The best way to find out is to experiment (when you don't know for sure).

    The easiest way to prove if a type is a reference type or a value type is to pass it to a method and change (mutate) it in the method, then see if it is affected in the original calling stack.

    For example, the starter project has a method that takes an integer and changes it, then reviews the value.  As you can see, the original int is unaffected.  This is because the original integer is passed "by value" because it's a value type.

1. Create methods to test each of the types listed above.

    After completion, fill out this chart:

    | Type | IsValue | IsReference |
    |--|--|--|
    |int| Yes  | No |
    |string|  |  |
    |double|  |  |
    |bool|  |  |
    |Course|  |  |
    |Instructor|  |  |
    |int[]|  |  |
    |List<int>|  |  |

## Conclusion

You have now completed the lab. In this lab you explored working with structures, classes, and then experimented with the difference between reference and value types.
