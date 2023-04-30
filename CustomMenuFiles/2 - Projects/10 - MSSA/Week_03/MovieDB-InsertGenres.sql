USE MoviesDB
GO

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Action'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Action')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Comedy'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Comedy')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Drama'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Drama')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Fantasy'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Fantasy')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Horror'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Horror')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Mystery'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Mystery')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Romance'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Romance')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Science Fiction'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Science Fiction')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Thriller'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Thriller')
END

IF (NOT EXISTS (SELECT * FROM Genre WHERE Genre = 'Western'))
BEGIN
    INSERT INTO Genre (Genre)
    VALUES ('Western')
END

SELECT * FROM Genre