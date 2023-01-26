# MSSA CCAD 7

Started on 10/24/2022
Week 7: 2022.11.14 - 2022.11.18

## Week 7 - Data Structures, Desktop Project, Starting HTML/JS/CSS

## Day 1 - 

Continued focus on data structures

1. What did you learn new/exciting?

    - Mark: Constructor Chaining
    - Greg: Unity Learning Path [making Rock Paper Scissors Lizard Spock 3D]
    - Jackson: Leet Code - Detect if string is valid `&#40;&#91;&#123;&#125;&#93;&#41;`

1. Challenge:

    - Write a console app
    - Create a method that takes a string
    - Determine if the input string has balanced parenthesis, square braces, and squiggley braces
    - If so, return true / If not return false
    - Unit test if time
    - Input will come in the form of a text file (eventually) and you will need to open and read each line and determine if each line is balanced output the line and the result for each line in the file to the screen  

1. Array List

    - Finish it

### Afternoon

1. Stack

1. Queue

## Conclusion

...

## Day 2

1. Challenge problem

    - Create an array of size 20
    - Add 20 random numbers
    - Use a sliding window to sum the element and it's next neighbor
    - print out all the results

    - loop back to the start on last entry (extra)
    - use a dictionary to store the entire result set and then print it out (extra)

1. Linked List

    - Double vs. Single Linked List

        - head
        - tail
        - next
        - prev

    - O(1) operations on add in place
        - this.previous = nodeToFollowAfter (sets this.previous = nodeToFollowAfter)
        - this.next = nodeThatFollows  (sets this.next = nodeThatFollows)
        - this.previous.next = this
        - this.next.previous = this

1. Worked with the linked list code Greg Found (awesome stuff)

    - video: https://www.youtube.com/watch?v=8TGFk_zUS9A

1. Implemented an iterator (Patrick with the assist again!)

    ```c#
    public IEnumerator<T> GetEnumerator()
    {
        Node<T> node = First;
        while (node.Next != null)
        {
            yield return node.Next.Data;
            node = node.Next;
        }
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
    ```  

### Afternoon

Splitting up

1. Advanced/Happy with your progress

    - Go to room A
    - Work on one of your projects
    - Work on some advanced concepts (write a linked-list for real)

1. Not happy with your progress/struggling

    - Come to main room
    - We're going to do a whirlwind review of things

## Conclusion

We completed our look at data structures.  Now we have a day to just get a couple people caught up and/or work on an individual project.

## Day 3

Working on Hangman

### Morning

Got the game working, including the ability to win and lose the game, ability to make the game fill in the blanks if you lose, and some coloring and resetting.

Word Loading

1. Use a separate class

### Afternoon

1. Modify the word loading to read from file

1. Modify the word loading to read from a web API

    - Write 50 words to file so don't keep hitting the endpoint
    - Only read from web if the file is not present

1. Strategy Design Pattern

    - LoadWords Strategy

## Conclusion

We are now done with the first part of our learning around C#!

## Day 4

Javascript/HTML/and CSS Day 1

## Morning

In the morning we attempted to use the official material.  It was a bust.

We pivoted to doing the HTML/JS/CSS Tutorials at W3 Schools

1. HTML [W3 Schools](https://www.w3schools.com/html/default.asp)

## Afternoon

Continued on HTML

1. HTML [W3 Schools](https://www.w3schools.com/html/default.asp)

1. Website from a Template & GitHub pages

    - We talked about Websites and using Templates
    - We did a brief demo using the template to create a GitHub pages site

## Conclusion

Another great week in the books.
