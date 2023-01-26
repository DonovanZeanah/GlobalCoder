using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolOfFineArtsDB.Migrations
{
    public partial class updatecourseinfoview : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"CREATE OR ALTER VIEW [dbo].[vwCourseInfo]
AS
SELECT ce.StudentId,
       ce.CourseId,
       c.TeacherId,
       CONCAT(s.LastName, ',  ', s.FirstName) AS StudentName,
       c.[Name] AS CourseName,
       c.Abbreviation,
       c.Department,
       CONCAT(t.LastName, ', ', t.FirstName) AS TeacherName
FROM   CourseEnrollment AS ce
       INNER JOIN Courses AS c ON c.ID = ce.CourseId
       INNER JOIN Students AS s ON s.Id = ce.StudentId
       INNER JOIN Teachers AS t ON c.TeacherId = t.Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"CREATE OR ALTER VIEW vwCourseInfo AS
                SELECT ce.StudentId, ce.CourseId, c.TeacherId, CONCAT(s.LastName, ' ', s.FirstName) AS StudentName, c.[Name] AS CourseName, c.Abbreviation, c.Department, CONCAT(t.LastName, ' ', t.FirstName) AS TeacherName
                FROM CourseEnrollment ce
                JOIN Courses c ON c.ID = ce.CourseId
                JOIN Students s ON s.Id = ce.StudentId
                JOIN Teachers t ON c.TeacherId = t.Id");
        }
    }
}
