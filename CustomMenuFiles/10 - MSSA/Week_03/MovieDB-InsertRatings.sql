IF (NOT EXISTS (SELECT * FROM Rating WHERE Rating = 'G'))
BEGIN
    INSERT INTO [dbo].[Rating]
           ([Rating]
           ,[Description])
     VALUES
           ('G','All ages admitted. Nothing that would offend parents for viewing by children.')
END

IF (NOT EXISTS (SELECT * FROM Rating WHERE Rating = 'PG'))
BEGIN
    INSERT INTO [dbo].[Rating]
           ([Rating]
           ,[Description])
     VALUES
           ('PG','Some material may not be suitable for children. Parents urged to give "parental guidance". May contain some material parents might not like for their young children.')
END

IF (NOT EXISTS (SELECT * FROM Rating WHERE Rating = 'PG-13'))
BEGIN
    INSERT INTO [dbo].[Rating]
           ([Rating]
           ,[Description])
     VALUES
           ('PG-13','Some material may be inappropriate for children under 13. Parents are urged to be cautious. Some material may be inappropriate for pre-teenagers.')
END

IF (NOT EXISTS (SELECT * FROM Rating WHERE Rating = 'R'))
BEGIN
    INSERT INTO [dbo].[Rating]
           ([Rating]
           ,[Description])
     VALUES
           ('R','Under 17 requires accompanying parent or adult guardian. Contains some adult material. Parents are urged to learn more about the film before taking their young children with them.')
END

IF (NOT EXISTS (SELECT * FROM Rating WHERE Rating = 'NC-17'))
BEGIN
    INSERT INTO [dbo].[Rating]
           ([Rating]
           ,[Description])
     VALUES
           ('NC-17','No One 17 and Under Admitted. Clearly adult. Children are not admitted.')
END
