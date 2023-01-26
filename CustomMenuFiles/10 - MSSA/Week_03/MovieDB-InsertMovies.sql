IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Titanic'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Titanic', 3, CAST('1997.01.01' AS DATE), 194)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'The Notebook'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('The Notebook', 3, CAST('2004.06.25' AS DATE), 124)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'John Wick'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('John Wick', 4, CAST('2014.01.01' AS DATE), 101)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Where the Red Fern Grows'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Where the Red Fern Grows', 2, CAST('2003.01.01' AS DATE), 97)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Grind'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Grind', 3, CAST('2003.01.01' AS DATE), 105)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Fight Club'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Fight Club', 3, CAST('1999.01.01' AS DATE), 139)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Game of Thrones'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Game of Thrones', 3, CAST('2011.01.01' AS DATE), 2000)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Interstellar'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Interstellar', 3, CAST('2014.01.01' AS DATE), 169)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Tombstone'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Tombstone', 3, CAST('1993.01.01' AS DATE), 130)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'The Fast and the Furious: Tokyo Drift'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('The Fast and the Furious: Tokyo Drift', 3, CAST('2006.01.01' AS DATE), 104)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Uncut Gems'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Uncut Gems', 3, CAST('2019.01.01' AS DATE), 135)
END

IF (NOT EXISTS (SELECT * FROM Movie WHERE Title = 'Spongebob'))
BEGIN
    INSERT INTO [dbo].[Movie]
           ([Title]
           ,[RatingId]
           ,[ReleaseDate]
           ,[Length])
     VALUES
           ('Spongebob', 2, CAST('2004.01.01' AS DATE), 87)
END
