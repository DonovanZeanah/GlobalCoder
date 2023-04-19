CREATE DATABASE MoviesDB
GO

USE [MoviesDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Movies]    Script Date: 10/18/2022 4:43:41 PM ******/
CREATE TABLE [dbo].[Movies](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Title] [varchar](1000) NOT NULL,
    [RatingId] [int] NOT NULL,
    [ReleaseDate] [date] NOT NULL,
    [Length] [int] NOT NULL,
CONSTRAINT [PK_Movies] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/************************************************************************************/
/****** Object:  Table [dbo].[Movies]    Script Date: 10/18/2022 4:51:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Movies]') AND type in (N'U'))
DROP TABLE [dbo].[Movies]
GO

/****** Object:  Table [dbo].[Movies] => movie    Script Date: 10/18/2022 4:51:35 PM ******/

CREATE TABLE [dbo].[Movie](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Title] [varchar](1000) NOT NULL,
    [RatingId] [int] NOT NULL,
    [ReleaseDate] [date] NOT NULL,
    [Length] [int] NOT NULL,
CONSTRAINT [PK_Movies] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/***********************************************************************/
/****** Object:  Table [dbo].[Rating]    Script Date: 10/18/2022 4:49:04 PM ******/

CREATE TABLE [dbo].[Rating](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Rating] [varchar](10) NOT NULL,
    [Description] [varchar](250) NULL,
CONSTRAINT [PK_Rating] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/***********************************************************************/

/****** Object:  Table [dbo].[Genre]    Script Date: 10/18/2022 4:53:06 PM ******/
CREATE TABLE [dbo].[Genre](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Genre] [varchar](50) NOT NULL,
CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/**********************************************************************************/
/****** Object:  Table [dbo].[MovieGenre]    Script Date: 10/18/2022 4:56:53 PM ******/
CREATE TABLE [dbo].[MovieGenre](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [MovieId] [int] NOT NULL,
    [GenreId] [int] NOT NULL,
CONSTRAINT [PK_MovieGenre] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*************************************************************************************/
/**Relationships**/
ALTER TABLE [dbo].[Movie]  WITH CHECK ADD  CONSTRAINT [FK_Movie_Rating] FOREIGN KEY([RatingId])
REFERENCES [dbo].[Rating] ([Id])
GO

ALTER TABLE [dbo].[Movie] CHECK CONSTRAINT [FK_Movie_Rating]
GO

ALTER TABLE [dbo].[MovieGenre]  WITH CHECK ADD  CONSTRAINT [FK_MovieGenre_Genre] FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genre] ([Id])
GO

ALTER TABLE [dbo].[MovieGenre] CHECK CONSTRAINT [FK_MovieGenre_Genre]
GO

ALTER TABLE [dbo].[MovieGenre]  WITH CHECK ADD  CONSTRAINT [FK_MovieGenre_Movie] FOREIGN KEY([MovieId])
REFERENCES [dbo].[Movie] ([Id])
GO

ALTER TABLE [dbo].[MovieGenre] CHECK CONSTRAINT [FK_MovieGenre_Movie]
GO

ALTER TABLE MovieGenre
ADD UNIQUE (MovieId, GenreId);

/*
ALTER TABLE Rating
DROP COLUMN Desciption
GO
ALTER TABLE Rating
ADD Description VARCHAR(250)
GO

DBCC CHECKIDENT ('[TestTable]', RESEED, 0);
GO
*/