# Lab: Working with Algorithms and Data Structures

## Scenario  

You need to decide which courses you will take in the upcoming quarter. Thinking through the process of viewing and choosing courses, write the pseudocode steps that you would complete for reviewing and choosing courses and then adding them to a collection.  

In a situation where you are storing information in a computer program about courses that you are enrolled in, you will need to store many pieces of information. Some of this information will be of the same data type, while others will not be.  

In this lab, you will create some simple data structures to store similar data such as your grades for a course across the different assignments or tests associated with that course. You will also create a data structure to store information specific to the collection of courses you will take.

## Objectives  

After completing this lab, you will be able to:  

- Create pseudocode to represent problem solving logic that will be used to translate into 
programming code.  
- Create arrays to store collections of data.  
- Create a stack data structure in code.  
- Create a list type data structure.   

## Lab Setup  

Estimated Time: 90 minutes

### Exercise 1: Working with Pseudocode  

You need to decide which courses you will take in the upcoming quarter. Thinking through the process of viewing and choosing courses, write the pseudocode steps that you would complete for reviewing and choosing courses. In this exercise, you will complete the following tasks:

1. Write pseudocode. 

1. Translate pseudocode into programming code. 

#### Task 1: Write pseudocode  

Create a Word document containing pseudocode for the lab scenario.  Detail the steps you will need to take and the decisions you will need to make.

#### Task 2: Translate pseudocode into programming code  

Utilizing your word document, complete the following activities:

1. Create the high-level functions from pseudocode from Exercise 1. 

2. Create the logic inside the functions, (decision and loops), to provide the functionality from 
pseudocode. 

>**Hint:** Don’t worry about getting the exact code here. This is merely an exercise to help you think about 
converting pseudocode to working code.  

### Exercise 2: Creating Data Structures  

In a situation where you are storing information in a computer program about courses that you are enrolled in, you will need to store many pieces of information. Some of this information will be of the same data type, while others will not be. In this lab, you will create some simple data structures to store similar data such as your grades for a course across the different assignments or tests associated with that course. You will also create a data structure to store information specific to the collection of courses you will take.

The main tasks for this exercise are as follows:  

1. Create an array.  
2. Implement a stack.   
3. Implement a list.  

#### Task 1: Create an array

You will need to get the starter code for the lab from the repository and follow the instructions to complete the tasks listed below:

1. Open the starter code for this lab

    Get the files and open them in your local folder.  Make sure the project runs.  

1. Create an array of floating point values to represent a series of grades.  

    Utilize your learning to create an array.  

1. Add grades to the array.

    Use your imagination to create a series of grades.  

1. Read grades from the array.  

    Make sure you can output the grades to the console.  

####  Task 2: Implement a stack

In this task, you will implement the operations for working with the Stack data structure. 

1. Push values onto the stack.
    
    Implement code that works with the stack to push the values of the grades onto the stack.

    >**Hint:** You should not remove grades from the array during this operation.

1. Peek at the top value

    Implement code to peek at the top value on the stack.

    What does this do internally to the state of the stack?

1. Pop values from the stack.  

    Implement code that utilizes the pop operation to display the top grade in the stack. 

    What does this do to the state of the stack?

    Call the method a second time.

#### Task 3: Implement a list  

In this final task, you will use a list to store course objects

1. Create a new .Net SortedList object called myCourses.

1. Add the following values to the myCourses list.

    - CS101 Introduction to Computer Science
    - CS201 Algorithms and Data Structures
    - CS202 Data Structures and Algorithm Analysis
    - CS301 Introduction to Databases
    - CS401 Introduction to Object-Oriented Programming 
    - CS402 Web Development
    - CS403 Artificial Intelligence
    - CS404 Compiler Theory
    - CS405 Operating Systems 

1. Read values from the list using using a search string

    Implement the method so that a search term can be utilized to find any matching item(s)

1. Remove values from the list.  

    Remove values from the list using the title of the course

Question: What is the difference between a stack and a queue?
Question: Can the same array store a mixture of text and numbers
Question: Would there be a better data structure to store courses with the course ID and course Name?  What would it be?
