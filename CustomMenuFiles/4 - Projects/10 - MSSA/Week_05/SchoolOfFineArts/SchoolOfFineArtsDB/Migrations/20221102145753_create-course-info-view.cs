using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolOfFineArtsDB.Migrations
{
    public partial class createcourseinfoview : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"CREATE OR ALTER VIEW vwCourseInfo AS
                SELECT ce.StudentId, ce.CourseId, c.TeacherId, CONCAT(s.LastName, ' ', s.FirstName) AS StudentName, c.[Name] AS CourseName, c.Abbreviation, c.Department, CONCAT(t.LastName, ' ', t.FirstName) AS TeacherName
                FROM CourseEnrollment ce
                JOIN Courses c ON c.ID = ce.CourseId
                JOIN Students s ON s.Id = ce.StudentId
                JOIN Teachers t ON c.TeacherId = t.Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"IF EXISTS (SELECT 1 FROM sys.views WHERE OBJECT_ID=OBJECT_ID('dbo.vwCourseEnrollments'))
BEGIN
    DROP VIEW dbo.vwCourseEnrollments
END");
        }
    }
}
