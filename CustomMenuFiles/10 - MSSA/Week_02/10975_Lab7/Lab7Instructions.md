# Lab 7 - Inheritance and Polymorphism

In this lab, you're going to create a new program (you can use any starter code you've done previously as a guide).

The overall goal of this program is to:

- Utilize Object Inheritance
- Create a solution that lets users Create/Add/Update/Delete Items from a collection
- You will have multiple item types with common properties
- You will utilize inheritance to work with the different objects effectively
- You will Be able to interact indefinitely with the program
- Your code will be clean and reusable where possible
- All input from the user will be confirmed
- No hard-stop errors will occur for bad input in your code.

## Part 1: Create the Driving Logic

To get started, you need a menu.  The menu will run in a loop that needs to be able to print the menu each iteration, and you will need to take the user input to determine what action the user will want to perform.

1. Create the driver program

The most important thing to do is to get the driver program working so that the "shell" of the program is ready to go.

- Create a new solution in Visual Studio or Visual Studio Code.  This should be a console application.
- Call a method to print the menu, which returns an integer for choice
- Based on the choice of the user, call a method to perform the operation which simply states its nature (i.e. "Now running the add method...");
- Display the menu until the user wants to end the program

1. Make it look good. 

Ideally, decorate the menu so that it is clearly a menu, something like this or anything that clearly separates it:


    ************************************
    * Welcome to the XYZ Data Manager
    * What would you like to do today?
    * 1) Add an item
    * 2) Update an item
    * 3) Delete an item
    * 4) List Items
    ************************************

1. Create a class library project and reference it in your solution for Validation logic

    Instead of long methods in the same program file, create a Class library to perform validation on your solution.

    Have methods to:

    - Take User Input as String
    - Take User Input as Double
    - Other common validation and input logic

## Part Two Create your object hierarchy

You will likely be assigned or petition for a hierarchy.  This will be something like a library with media, having books, videos, and music, or it might be educational resources, with objects like Human, Instructor, and Student.  This could also be a car dealership with vehicles, cars, and motorcycles.  This could be Military, with Army, Navy, AF, Marines, Space Force, Coast Guard, etc.  

1. Create the base class

No matter what hierarchy you choose, you need to discern your common properties and create a base class

- Consider using interfaces and abstract classes when appropriate
- Implement common properties
- Implement common functionality
- At minimum, you should have 3-4 properties
- Create default and explicit constructors
- Create the ToString method to display "Namespace.Type -> Property1: <value> | Property2: <value> | ... | PropertyN: <value>"

1. Create at least two subclass objects that inherit from the base class

- Add any additional unique functionality to the classes
- Ensure that the subclass has correctly printed its values in the ToString
- Encapsulate any private data/algorithms

## Part three, use your objects in a solution

For this final part, you need to complete the solution.  This will take some time, and you have a number of problems to solve through the solution.

1. Implement an appropriate data structure to store a collection of your items using polymorphism

1. Create the Add Method

    Allow the user to input information to add a new item to the collection

1. List all Items

    Allow the user to view the items in the collection

1. Create the Delete method

    Allow a user to select an object for deletion

1. Create the Update method

    Create code that allows a user to select an item for update, then take information to update that item

1. Prove you have the ability to work with a more specific object

    Using polymorphism:  

    - prove that you can leverage classes appropriately as the less specific object  
    - prove that you can leverage classes appropriately as the more specific object

## Conclusion

In this lab, you created a program that manages data using object inheritance and polymorphism.  You've also had to utilize skills that you learned earlier to reinforce your learning.

