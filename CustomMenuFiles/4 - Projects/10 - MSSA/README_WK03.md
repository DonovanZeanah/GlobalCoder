# MSSA CCAD 8

Started on 10/3/2022
Week 3: 2022.10.17-2022.10.21

## Week 3 - Introduction to SQL Server and Database development

During week 3, we're going Work on learning how to work with relational databases.

## Day 1

First hour of Day 1 was C# review, then diving head first into SQL Server

### Morning

1. Create CRUD actions in C# against an in-memory list

    In this activity, we used the shell for the `Inventory Manager` program from week 2 and added operations around a list of Vehicles.

    We also saw a bit about creating a class library for Models.

    The main learning here was to solidify C# but also introduce data querying a bit using LINQ from C#

    - Get an entire list of data
    - Get a single item from a list
    - Disconnect the in-memory data from the dataset shown in the UI

    Start thinking about what it would take to complete the project and just the idea of working with the data to ensure the correct items and fields were updated

    Solidify knowledge around keeping methods simple and single-focused so that the code is easier to maintain and enhance in the future.

1.  Get started by setting up our machines

   Install and verify the following installations

    - [Install SQL Server developer edition](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)

    - Install SSMS [https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16]  

    - Restore AdventureWorksLT2019 from the backup file
        - [Direct download](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2019.bak)  
        - [All Databases](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms)  
    
    - Use the following images to help remember how to restore:

![](/Week_03/images/image0001-restoredatabase.png)  
![](/Week_03/images/image0002-restoredatabase_part2.png)  
![](/Week_03/images/image0003-restoredatabase-part3.png)  
![](/Week_03/images/image0004-restoredatabase-part4.png)  
![](/Week_03/images//image0005-restoredatabase-part5.png)  

    - Use the following images to help remember how to query the database

![](/Week_03/images/image0006-querydatabase-1.png)  
![](/Week_03/images/image0007-querydatabase2.png)  
![](/Week_03/images/image0008-querydatabase3.png)  
![](/Week_03/images/image0009-querymanagerreview.png)   

1. DP-080 Module

    We then went through the slides for the first module.

    During the slides, a number of things were presented live, including

    - Create a new database
    - Create a new Table
    - How relational data works
    - Schema and database name information
    - How Select queries work
    - [A number of select queries](Week_03/Module1.sql)

### Afternoon

In the afternoon we did individual work for the first part

1. DP-080 Module 1

    - [Introduction to Transact SQL](https://learn.microsoft.com/en-us/training/modules/introduction-to-transact-sql/)  
    - [Complete the lab](https://learn.microsoft.com/en-us/training/modules/introduction-to-transact-sql/6-exercise-work-with-select-statements)  

1. DP-080 Module 2

    - Work through the slides 
    - [Sort and filter results in T-SQL](https://learn.microsoft.com/en-us/training/modules/sort-filter-queries/)  

    --joining:
    /****** Script for SelectTopNRows command from SSMS  ******/
    SELECT product.[Name] as ProductName
		, productModel.[Name] as ProductModel
		, productCategory.[Name] as ProductCategory
    FROM [SalesLT].[Product] product
    INNER JOIN [SalesLT].[ProductModel] productModel ON product.ProductModelID = productModel.ProductModelID
    INNER JOIN [SalesLT].[ProductCategory] productCategory on product.ProductCategoryID = productCategory.ProductCategoryID   

### Conclusion

In todays learning, we took a deep dive into SQL Server and T-SQL.  We also spent a couple of minutes brushing up on C# together.

## Day 2

Joins and Subqueries

### Morning

1. Question on including projects/libraries in a solution

1. Question on Singletons

1. Question on Joins

1. [DP-080 Module 2 - MS Learn - Sort and Filter Results in T-SQL](https://learn.microsoft.com/en-us/training/modules/sort-filter-queries/)  

1. Module 3/4 Live/Slides

### Afternoon

1. [DP-080 Module 3 - MS Learn - Combine multiple tables with JOINs in T-SQL](https://learn.microsoft.com/en-us/training/modules/query-multiple-tables-with-joins/)

1. [DP-080 Module 4 - MS Learn - Write Subqueries in T-SQL](https://learn.microsoft.com/en-us/training/modules/write-subqueries/)

1. Build your own database activity

    - Movie Table
        [ID, Name]
    - MPAA Rating Table
        [ID, Rating]
    - Genre Table
        [ID, Genre]
    - Determine best solution for relationship between Movies and Ratings, Movies and Genres
    - What would it take to track actors and associate actors with movies
    - What would you need to do if users could rate movies?

### Conclusion

Today we completed Module 2 Labs, did the slides for Modules 3 and 4 and completed modules 3 and 4 in the MS Learn ecosystem.  We have two modules remaining for DP-080.

We took some time at the end of the day to build our own database from the ground up and saw how this could be done through the UI as well as via scripts. 

## Day 3

On Day 3 we wrapped up the official DP-080 material and took an unscripted look at Views.  We also spent some time building our Movie Database together.

### Morning

In the morning we looked at views and covered remaining slides for DP-080.  First we did views, then the slides and materials for the Functions and Grouping

1. Aliasing Conversation

    We had a question/request to review aliasing.  

    - [Aliasing Conversation](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/AliasingConversationComparison.sql)  
    - [Aliasing Conversation Spreadsheet](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/AliasingConversationComparison.xlsx)  

1. Views  

    We looked at using views and created a couple of scripts and utilized views  

    - [View Usage](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/ViewUsage.sql)  
    - [View vCustomerAddresses](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/view_vCustomerAddresses.sql)  
    - [View vProductSales](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/vProductSales.sql)  

1. Learn Module 5 - Built in Functions and GROUP BY

    - [DP-080 Module 5 - MS Learn - Use built-in functions and GROUP BY in Transact-SQL](https://learn.microsoft.com/en-us/training/modules/use-built-functions-transact-sql/)  

1. We then did the slides for the Insert/Update/Delete   

    We walked through using the Insert/Update/Delete commands  

    - INSERT INTO &lt;table&gt; (&lt;fields-list&gt;) VALUES (&lt;values data&gt;)
    - UPDATE &lt;table&gt; SET &lt;fields&gt; WHERE &lt;condition-predicate&gt;
    - DELETE FROM &lt;table&gt; WHERE &lt;condition-predicate&gt;
    - DELETE FROM &lt;table&gt;
    - TRUNCATE TABLE
    - DBCC CHECKIDENT ('[TableName]', RESEED, 0);

    We also looked at using transactions:

    - BEGIN TRAN
    - ROLLBACK TRAN
    - COMMIT TRAN

    - [Transactions](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/Transactions.sql)  

### Afternoon

In the afternoon we completed DP-080 and then worked together to build our database.

1. [Modify data with T-SQL](https://learn.microsoft.com/en-us/training/modules/modify-data-with-transact-sql/)

1. [MOVIE DB - Insert Genres](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/MovieDB-InsertGenres.sql)

1. [MOVIE DB - Insert Ratings](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/MovieDB-InsertRatings.sql)

1. [MOVIE DB - Insert Movies](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/MovieDB-InsertMovies.sql)

1. On our own, we just put the numbers in for the MovieGenre Associations

    Should do this as a script using variables

## Conclusion  

We had a busy day three this week.  We covered a lot of the remaining concepts for basic database interaction and were able to create data in our local databases for storing movies and associating them.  We could now use this as practice for our own learning, and can use it to test code in the future as well.

## Day 4  

We started day 4 with a brief discussion of the Liskov Substitution Principle.  We then moved into a couple of lightning demos on user-defined functions (scalar and table value).  In that we took a 50,000 foot view of common table expressions, but only because one was already written for us in the given table function `[dbo].[ufnGetAllCategories]`.  We then worked through Stored Procedures and took a look at what it might look like to get data using C# code

### Morning  

In the morning, we took a look at User-defined functions and stored procedures.

1. Liskov Substitution [https://dotnettutorials.net/lesson/liskov-substitution-principle/]

1. UDF and SPROC lightning demos

    - [ufnGetThreeNumbersDefinition](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/ufnGetThreeNumbersDefinition.sql)  
    - [ufnGetThreeNumbersTest](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/blob/main/Week_03/ufnGetThreeNumbersTest.sql)  

1. Learn: Stored procedures and user-defined functions

    - [Learn: Create stored procedures and user-defined functions](https://learn.microsoft.com/en-us/training/modules/create-stored-procedures-table-valued-functions/)  

1. Code example and (brief) learning about ADO.Net

    - [Reference the project](https://github.com/majorguidancesolutions-team/MSSA_CCAD8_LiveDemos/tree/main/Week_03/WorkingWithADatabaseUsingADONet)

### Afternoon

It's Challenge Time!

1. Complete the challenge

    This afternoon we'll be doing another challenge.

    - MSSQL Challenge: Restore Database and Create a Stored Procedure and a view (Opsgility Challenge Platform)

1. Use any additional time to review material from this week or do additional Learn Modules:

    - [Tables, Views, and Temporary Objects](https://learn.microsoft.com/en-us/training/modules/create-tables-views-temporary-objects/)
    - [Set Operators](https://learn.microsoft.com/en-us/training/modules/combine-query-results-set-operators/)  
    - [Get started with Transact-SQL programming](https://learn.microsoft.com/en-us/training/modules/get-started-transact-sql-programming/)
    - [Implement transactions with Transact-SQL](https://learn.microsoft.com/en-us/training/modules/implement-transactions-transact-sql/)
    - [Implement error handling with Transact-SQL](https://learn.microsoft.com/en-us/training/modules/implement-error-handling-transact-sql/)

### Additional things: 

- [SQL Joins as VENN](https://stackoverflow.com/questions/13997365/sql-joins-as-venn-diagram)  

- [SQL Joins Explained](https://www.youtube.com/watch?v=9yeOJ0ZMUYw)  

- [Regular Expressions](https://learn.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference)

- [Learn Regular Expressions in 20 minutes](https://www.youtube.com/watch?v=rhzKDrUiJVk)

- [Learn Regular Expressions (Regex) - Crash Course for Beginners](https://www.youtube.com/watch?v=ZfQFUJhPqMM)  

- [Solid Principles](https://www.educative.io/blog/solid-principles-oop-c-sharp?utm_campaign=systemdesign&utm_source=google&utm_medium=ppc&utm_content=display&eid=5082902844932096&utm_term=&utm_campaign=%5BNew%5D+System+Design+-Performance+Max&utm_source=adwords&utm_medium=ppc&hsa_acc=5451446008&hsa_cam=18511913007&hsa_grp=&hsa_ad=&hsa_src=x&hsa_tgt=&hsa_kw=&hsa_mt=&hsa_net=adwords&hsa_ver=3&gclid=Cj0KCQjwnbmaBhD-ARIsAGTPcfU-A4rOaEfEvOF9cVSFRkRqEV5SRy5jy2yVqGrr3TiSTwnwbrLXnoEaAmRYEALw_wcB)  

- [Dynamic SQL](https://www.sqlshack.com/dynamic-sql-in-sql-server/)  
