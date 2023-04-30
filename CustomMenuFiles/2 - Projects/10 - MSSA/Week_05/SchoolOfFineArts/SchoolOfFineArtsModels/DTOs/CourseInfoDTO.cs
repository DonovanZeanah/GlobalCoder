namespace SchoolOfFineArtsModels.DTOs
{
    public class CourseInfoDTO
    {
        public int StudentId { get; set; }
        public int TeacherId { get; set; }
        public int CourseId { get; set; }
        public string StudentName { get; set; }
        public string TeacherName { get; set; }
        public string CourseName { get; set; }
        public string Department { get; set; }
        public string Abbreviation { get; set; }
    }
}
