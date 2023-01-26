# MSSA CCAD 8

Started on 10/3/2022

## Week 1 - Introductions, Intro to GIT, Intro to Programming

The first week we got to know each other, set up our local machines, worked a bit with GIT, and started a deep dive into programming.

### Day 1

Info about GIT, Set up machines, did some introductions.

#### Programs installed

The following tools were installed on machines.  A few hoops had to be jumped through for Macs but most everyone got to the good end point.

- [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/downloads)

#### Commands covered  

Commands learned:

- cd/mkdir/ls/dir
- dotnet new console
- dotnet new gitignore
- git init
- git add . 
- git add Program.cs
- git commit -m "important information"

#### Review Questions

Use the skills learned and information above to answer the following questions:

1. What is the command to create a new repository?

1. What is the difference between Untracked and Modified?

1. What is the command to stage changes?

1. Give me an example of a command that stages all changes

1. Give me an example of a command that stages a single file named Program.cs

1. How do you make changes permanent in history?  What do you do to set the message?  Why is the message important?  

### Day 2

Day 2 covered modules 1-3 of the intro to programming material

#### Morning

1. Questions/Ask yesterday's final questions

1. Challenge:

    What number is missing in the following display?

    | ** Column A ** | ** Column B ** |
    |---|---|
    | 2 | 8 |
    | 4 | 9 |
    | 3 | 7 |
    | 6 | 9 |
    | 3 | 5 |
    | 7 | x |  

1. Types, Variables, and Syntax

- [Types, Variables, and Syntax Live Demo Code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/TypesAndVariablesAndSyntax)

#### Afternoon

Program Flow - part 1: Methods & Conditional Logic

- [Methods and Conditional Logic Live Demo Code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/MethodsDecisionsAndLoops)  

#### Additional Git Commands and Processes

Create a private repo at your own GitHub account and use the commands from the new repo to push your lab code from earlier in the day.

#### Review Questions

1. What type of variable should store the following values:  

    a. "Orange"  
    b. 26  
    c. "Yellow"  
    d. 52.3  
    e. -754.2  
    f. true  
    g. "38"  
    h. false  
    i. "{ \"Name\":\"MSSA\", "\Course":\"CCAD\", \"Iteration\": \"8\"}"  

1. How do you check for a condition to determine if a user wants to continue entering information?

1. How do you check for a condition where a user wants to confirm a value?

1. What is the type of loop that always runs at least once?

1. What is the type of loop designed to handle collections and datasets with known value lengths

1. What type of loop should you use that would possibly never iterate?

### Day 3

Day 3 starts off with Lab 3 and then team work to build some code using conditions, loops, and methods.

#### Morning

1. Questions

1. Git Repo: Get existing repository locally

    New commands:
    - git clone <url-of-the-repo>
        (Gets a referenced copy of the remote repository locally.  The main branch is automatically tracked so you don't have to manually set that like you do with a new repository)
    - git fetch 
        (remember that fetch is optional, checks to see if any changes exist but does not pull them locally)
    - git pull
        (fetches and pulls all changes from the remote repository into your local respository)

1. Lab 3: We worked through it together
    
    - [10975 Lab 3 code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/10975-Lab3)  

1. While we worked through code we also hit a couple of new concepts (we'll hit them again)

    - debugging
    - debugging with conditions
    - using the command window
        - ? => print
        - ? grades[2] => prints the value of what is in the grades array at index 2
    - using the quick watch
    - adding a persistent watch
    - Lists and Arrays
    - Amortized Time Complexity of ArrayList resizing wrapped array

#### Afternoon

Introduction to Algorithms and Data Structures

1. Pseudocode & Algorithms

1. Bubble Sort  

    [Demo And Live Code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/BubbleSortDemo)

1. Big O(n) Efficiency introduction  

    [Demo And Live Code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/BubbleSortDemo)  

1. Arrays/Stacks/Lists/Queues/Dictionaries  

    [Demo and Live Code](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/DataStructures)  

#### Review Questions

Review the following questions

1. What type of structure(s) can you use to manage a group of related objects?

1. What are the benefits of using an Array?

1. What are some scenarios where an Array is not the best choice?

1. What are the benefits of using a List?

1. What scenarios would require you to use a specific type of list?

1. Which type of object is a LIFO object?

1. Which type of object is a FIFO object?

1. Which structure lets me work efficiently at the front and back of the structure?

### Day 4: Last day of week 1

Today is the last day of the first week.  The day will begin as usual, proceed through lab 4, section 5 and possibly lab 5.

#### Morning

The following items are on the agenda for the morning

1. Questions

1. Challenge problem

1. Lab 4 - Student led

    For lab 4, you'll get the starter information and we'll have one person share and do the typing and the rest of us will do it along with them on our own machines.  

1. Section 5 slides

1. Demo Try..Catch..Finally 

    - [Try..Catch..Finally](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_01/TryCatchFinally)

#### Afternoon

We'll spend the rest of the day on the week 1 PIAT activity: Physics calculator!

1. Team activity

    Split into five teams of 3.  Spend the rest of the day building a new program as a team.

    [Week 1 PIAT: Physics Calculator](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_01/PIAT-PhysicsCalculator.md)

#### TODO: Review Questions

Coming soon...

#### TODO: Additional Homework

1. Random Name Generator

1. Rock Paper Scissors

## Conclusion

Week 1 was great!  Please use the daily logs above to review the materials and practice the concepts

## Additional Resources

- [Introduction to C#](https://learn.microsoft.com/en-us/shows/csharp-101/?wt.mc_id=educationalcsharp-c9-scottha)
- [Take your first steps with C#](https://learn.microsoft.com/en-us/training/paths/csharp-first-steps/)
