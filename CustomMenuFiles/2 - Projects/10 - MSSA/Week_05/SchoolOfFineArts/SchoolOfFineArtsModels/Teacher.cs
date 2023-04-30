using System.ComponentModel.DataAnnotations;

namespace SchoolOfFineArtsModels
{
    public class Teacher
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(50)]
        public string FirstName { get; set; }
        [Required, StringLength(50)]
        public string LastName { get; set; }
        [Required, Range(1, 130)]
        public int Age { get; set; }

        public string FriendlyName => $"{FirstName} {LastName}";

        public virtual List<Course> Courses { get; set; } = new List<Course>();

        public override string ToString()
        {
            return $"First Name: {FirstName}, Last Name: {LastName}, ID: {Id}, Age: {Age}";
        }
    }
}