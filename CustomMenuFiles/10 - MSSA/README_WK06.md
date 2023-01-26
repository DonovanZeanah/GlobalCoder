# MSSA CCAD 8

Started on 10/24/2022
Week 6: 2022.11.07 - 2022.11.11

## Week 6 - Advanced C# with Unit Testing, Generics, FileIO

This week we'll dive into some unit testing, generics, IComparable, Equality and then we'll move into data structures.

## Day 1

### Morning

1. Interview Questions

    - Palindrome checker 

1. Polymorphism

    - Calculation method that varies for service members and civilians

1. Overriding Equals

1. Unit Testing with MS Test

    - AAA (Arrange/Act Assert)
    - Red/Green Refactor
        - Fail test
        - Pass Test
        - Refactor code to avoid repeating/hard-coded strings/values

### Afternoon

1. Calculation Method
    
    - Hourly vs. Salaried variance
    - Unit tests for both types and expected values

1. Generic Programming

    - Pair -&gt; int, string
    - Pair -&gt; string, string
    - Pair -&gt; Person, Persion
    - GenericPair&lt;T,S&gt; =&gt; T, S

1. Intro to Dictionaries

    - Generic Key/Value pairs

## Conclusion

Busy Monday! We learned about unit testing and that cleared up our look at overriding equals

We then touched a bit on generic programming and built a generic Pair class that can take two types and noted that the nature of generics is to just have any type so you can get some infinite (within reason) nesting of structures.

## Day 2

---

### Morning

---

### Afternoon

Work through some stuff, finish up File I/O with Json serialization

## Day 3

Coding challenge, data structures

### Morning

1. Coding Challenge

    - OBJ1: Take input and get a number 1-50
    - OB2: Print out the sequence from 1 to that number
    - OB3: Print the sum of all the numbers in that sequence

1. Recursion and Fibonacci

    - How to recurse
    - Recurse instead of loop on Taking input
    - Fibonacci with no recursion
    - Fibonacci with recursion

1. Growth Rate Discussion

    - O(n) => Linear => single loop
    - O(n^2) => Quadratic => nested loop
    - O(n^3) => ? => triple nested loop (x, y, z coordinates, get each point)
    - O(log n) => Logarithmic => Binary Search
    - O(n!) => Factorial => Encryption vs. Brute Force

    - Recursion vs loop
         - about 40 as the index where it's noticable
         - from 40-50 recursive algorithm starts to really bog down
         - after 50 runtime is excessive
    
### Afternoon

Algorithms and Data Structures

1. Sorting

    - Selection Sort
    - Bubble Sort

## Conclusion

Another long day with many important and difficult topics addressed.  We started with a quick challenge to generate a sequence and print it out.  We then moved into recursion, and finished up with some sorting things.

## Day 4

Continued journey into the Data Structures and Algorithms portion of the class

### Morning

1. Linear Search

1. Merge Sort

### Afternoon

1. Merge Sort

1. Quick look at Functional String from Array

1. Quick look at Fact/Theory XUnit Testing

## Conclusion

Honestly, today was not a good day.  Too many issues with getting the algorithm to work for MergeSort led to a poor learning experience and a lack of a feeling of accomplishment.  That's on me.

## Day 5

Day 5 is all about data structures.

### Morning  

1. Helped Josh with the class members/variables

    - Create a class
    - Add some methods
    - Use the class from the program

1. Binary Search

    - Much better than MergeSort
    - half the pain since we already had our mid calculation

1. Let's make an Array List

    - Discussion on efficiency inside the ArrayList data structure
    - Utilize our skills to create an implementation of IList that correctly
        works as an ArrayList
    - unit tests on the array list methods

### Afternoon

Continued Array List 

1. Let's make an Array List continued

    - Discussion on efficiency inside the ArrayList data structure
    - Utilize our skills to create an implementation of IList that correctly
        works as an ArrayList

    - Discussed opportunities for enhancing the efficiency

## Conclusion

...