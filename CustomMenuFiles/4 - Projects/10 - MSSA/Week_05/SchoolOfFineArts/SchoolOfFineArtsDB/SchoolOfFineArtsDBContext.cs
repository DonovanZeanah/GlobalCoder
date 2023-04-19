using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SchoolOfFineArtsModels;
using SchoolOfFineArtsModels.DTOs;

namespace SchoolOfFineArtsDB
{
    public class SchoolOfFineArtsDBContext : DbContext
    {
        //put your datbase objects here:
        public DbSet<Teacher> Teachers { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<Course> Courses { get; set; }
        public DbSet<CourseInfoDTO> CourseInfoDTOs { get; set; }

        //add to allow migrations
        public SchoolOfFineArtsDBContext()
        {

        }

        //add to inject context options from app
        public SchoolOfFineArtsDBContext(DbContextOptions options)
                : base(options)
        {

        }

        //add to allow migrations when the context is not built
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var builder = new ConfigurationBuilder()
                                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

                var config = builder.Build();
                var cnstr = config["ConnectionStrings:SchoolOfFineArtsDB"];
                var options = new DbContextOptionsBuilder<SchoolOfFineArtsDBContext>().UseSqlServer(cnstr);
                optionsBuilder.UseSqlServer(cnstr);
            }
        }

        //Add to seed data:
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Teacher>(x =>
            {
                x.HasData(
                    new Teacher() { Id = 1, FirstName = "Anne", LastName = "Sullivan", Age = 27 },
                    new Teacher() { Id = 2, FirstName = "Maria", LastName = "Montessori", Age = 32 },
                    new Teacher() { Id = 3, FirstName = "William", LastName = "McGuffey", Age = 21 },
                    new Teacher() { Id = 4, FirstName = "Emma", LastName = "Willard", Age = 47 },
                    new Teacher() { Id = 5, FirstName = "Tom", LastName = "Hanks", Age = 64 },
                    new Teacher() { Id = 6, FirstName = "Tom", LastName = "Cruise", Age = 62 },
                    new Teacher() { Id = 7, FirstName = "Val", LastName = "Kilmer", Age = 57 },
                    new Teacher() { Id = 8, FirstName = "Geena", LastName = "Davis", Age = 48 },
                    new Teacher() { Id = 9, FirstName = "Chris", LastName = "Pratt", Age = 37 },
                    new Teacher() { Id = 10, FirstName = "Anne", LastName = "Hathaway", Age = 42 }
                );
            });

            var seedDate = new DateTime(1984, 1, 1);
            modelBuilder.Entity<Student>(x =>
            {
                x.HasData
                (
                    new Student() { Id = 1, FirstName = "Greg", LastName = "John", DateOfBirth = seedDate },
                    new Student() { Id = 2, FirstName = "Erik", LastName = "Tabaka", DateOfBirth = seedDate },
                    new Student() { Id = 3, FirstName = "Josh", LastName = "Benson", DateOfBirth = seedDate },
                    new Student() { Id = 4, FirstName = "Alex", LastName = "Robinson", DateOfBirth = seedDate },
                    new Student() { Id = 5, FirstName = "Mark", LastName = "Rimbaugh", DateOfBirth = seedDate },
                    new Student() { Id = 6, FirstName = "David", LastName = "Diaz Morales", DateOfBirth = seedDate },
                    new Student() { Id = 7, FirstName = "Andrew", LastName = "Nelson", DateOfBirth = seedDate },
                    new Student() { Id = 8, FirstName = "Brian", LastName = "Braine", DateOfBirth = seedDate },
                    new Student() { Id = 9, FirstName = "Donovan", LastName = "Zeanah", DateOfBirth = seedDate },
                    new Student() { Id = 10, FirstName = "Jackson", LastName = "Freiburg", DateOfBirth = seedDate },
                    new Student() { Id = 11, FirstName = "Joshua", LastName = "Benson", DateOfBirth = seedDate },
                    new Student() { Id = 12, FirstName = "Mursal", LastName = "Qaderyan", DateOfBirth = seedDate },
                    new Student() { Id = 13, FirstName = "Rohin", LastName = "Qaderyan", DateOfBirth = seedDate },
                    new Student() { Id = 14, FirstName = "Rico", LastName = "Rodriguez", DateOfBirth = seedDate },
                    new Student() { Id = 15, FirstName = "Tom", LastName = "Brady", DateOfBirth = seedDate },
                    new Student() { Id = 16, FirstName = "Aaron", LastName = "Rogers", DateOfBirth = seedDate },
                    new Student() { Id = 17, FirstName = "Dax", LastName = "Prescott", DateOfBirth = seedDate },
                    new Student() { Id = 18, FirstName = "Joe", LastName = "Burrow", DateOfBirth = seedDate },
                    new Student() { Id = 19, FirstName = "Trevor", LastName = "Lawrence", DateOfBirth = seedDate }
                );
            });

            modelBuilder.Entity<CourseInfoDTO>(x => {
                x.HasNoKey();
                x.ToView("CourseInfoDTOs");
            });
        }
    }
}