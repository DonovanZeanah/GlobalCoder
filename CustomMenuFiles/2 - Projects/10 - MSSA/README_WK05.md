# MSSA CCAD 8

Started on 10/24/2022
Week 5: 2022.10.31 - 2022.11.04

## Week 5 - Advanced C# with Desktop and Databases

During week 5 we're going to wrap up our second look at C# and cover a couple of remaining complex topics

## Day 1 

Day 1 will start with a challenge and pulse check

## Morning

Work individually to create a solution with requirements being given one step at a time.

1. Do the challenge (8-9:30)

1. Review the answer (9:45-12)

    - everyone builds it as we go
    - one person leading on a couple steps, rotate to another person

    - [Challenge Activity 05-01](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_05/ChallengeActivity0501)  

### Afternoon

Return to our school project

1. Learn how to leverage many-to-many relationships

    - associate students to courses
    - build out the form
    - use of check list box
    - use of another grid
    - another tab control to manage the associations add page

## Conclusion

Reviewed C# concepts we should know and had a couple of challenging problems to show how to utilize code

## Day 2

Adding complex objects to the database

### Morning

Lots of code fixes, bug fixes, discussion about inheritance

1. Greg's Lizard/Spock game and truth tables

    - MultiDimensional Arrays
    - Jagged Arrays

1. Fix up the method to associate students

    - Get the fields populated for the selected grid id and course name
    
1. Fix up some grids

    - Alex's code

1. Fix bugs

    - e.RowIndex &lt; 0 issue
    - wrong grid selected in the datagrid [dgvResults instead of dgvCourses]

1. Discussion on terms

    - private vs. public [apt building]
    - virtual vs. sealed [locking down from extension override]


### Afternoon

Continued work on the associations

1. Learned about checking for existence of objects

    ```c#
    //validate course exists
    var c = context.Courses.Include(x => x.CourseEnrollments).SingleOrDefault(c => c.Id == courseId);
    if (c == null)
    {
        MessageBox.Show($"Course {courseName} not found, cannot continue!"
                    , "No such course!"
                    , MessageBoxButtons.OK
                    , MessageBoxIcon.Error);
        return false;
    }
    ```  

1. Had to hydrate the course enrollments

    ```c#
    context.Courses.Include(x => x.CourseEnrollments).SingleOrDefault(c => c.Id == courseId);
    ```  

1. Make sure to only save changes when changes are needed


1. Exit loop statements

    - continue  
        Go to the next iteration
    - break  
        Exit the loop completely

1. Make sure to check the correct property Ids for mapping 

    - Association has three Ids:

        - Id [irrellevant]
        - CourseId [maps for existing Course.Id]
        - StudentId [maps for existing Student.Id]

    ```c#
    //check if already associated
    var courseExists = false;
    foreach (var enrollment in s.CourseEnrollments)
    {
        if (enrollment.CourseId.Equals(c.Id))
        {
            //already associated: Message user
            MessageBox.Show($"Course {courseName} already associated to student " +
                                $"{s.FriendlyName}, cannot continue!"
                        , "Already Associated"
                        , MessageBoxButtons.OK
                        , MessageBoxIcon.Information);
            //move to next student
            courseExists = true;
            break; //exit this for loop for course enrollments
        }
    }
    if (courseExists)
    {
        //move to next student (next loop iteration for students)
        continue;
    }
    ```  

1. Make sure that the save isn't saving duplicates.

    ```c#
    {
        //
        //...other code above this for finding if need to add
        //

        //not associated - create
        var ce = new CourseEnrollment();
        //ce.Student = s;
        ce.StudentId = s.Id;
        ce.CourseId = courseId;
        //ce.Course = c;
        //c.CourseEnrollments.Add(ce);
        s.CourseEnrollments.Add(ce);
        modified = true;
    }
    if (modified)
    {
        context.SaveChanges();
        MessageBox.Show($"Successfully associated students to {courseName}"
                        , "Success!"
                        , MessageBoxButtons.OK
                        , MessageBoxIcon.Information);
    }
    ```  

## Conclusion

During Day 2 we wired up the logic for working on the course associations and we got to the point where we could create student/course associations and not have any duplicates.

## Day 3

Continue with the Form for Student Course Associations

### Morning

1. Question about Anonymous types

    - Throw away class used temporarily in memory
    - Idea/Concept of DTO object or View Model to map data for UI View  differently than data for the database. 

1. Debugging for Mursal and Jackson

    - Form fields renamed
    - If statement in the wrong place
    - A couple of other logic errors

1. Added Unique Index to the database using a Migration

    - set the Index on the model class

1. Added view in database script

    - migrations
    - migrationBuilder script
    - ability to add/remove/update database migrations

1. Mapped the view as a DbSet<T> in the Context 

    - modelBuilder.Entity view info
    - added to context

1. Leveraged the view from the form

    - asSQL Raw

1. Created a grid to click on the selected course

1. Selected the course/student info and button to remove association

### Afternoon

Finish the form

1. Create the code to remove associations from the database  

## Conclusion

...

## Day 4

SQL Challenge redux & Class Hierarchy work

### Morning

SQL Challenge

1. Separate work

1. Walk through part 1

### Afternoon

1. Walk through part 2

1. Class hierarchy

1. Override Equals

## Conclusion

...

## Week 5 conclusion

...