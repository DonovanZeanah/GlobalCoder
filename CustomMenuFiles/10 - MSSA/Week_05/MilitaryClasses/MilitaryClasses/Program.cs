using Microsoft.Extensions.Configuration;
using MilitaryClassModels;

namespace MilitaryClasses
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            //BuildOptions();
            //Console.WriteLine("Hello World");

            //var configCheck = _configuration["SimpleKey:SimpleValue"];
            //Console.WriteLine($"Configuration: {configCheck}");

            //var today = new DateTime(2022, 11, 3);

            var dob = DateTime.Now.AddYears(-25);

            List<Person> people = new List<Person>() {
                new Servicemember(){FirstName = "Brian", LastName = "Braine", DateOfBirth = dob, Rank = "CMSAF", Branch = "Air Force", YearsOfService = 7},
                new Servicemember(){FirstName = "Bob", LastName = "Ross", DateOfBirth = dob, Rank = "MSgt", Branch = "Air Force", YearsOfService = 10},
                new Servicemember(){FirstName = "Emma", LastName = "Watson", DateOfBirth = dob, Rank = "SSGT", Branch = "Army", YearsOfService = 5},
                new Servicemember(){FirstName = "Bruce", LastName = "Willis", DateOfBirth = dob, Rank = "MGySgt", Branch = "Marines", YearsOfService = 20},
                new Servicemember(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob, Rank = "Captain", Branch = "Army", YearsOfService = 6},
                new Servicemember(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob, Rank = "Captain", Branch = "Army", YearsOfService = 6},
                new Servicemember(){FirstName = "Tom", LastName = "Hanks", DateOfBirth = dob, Rank = "CPO", Branch = "Navy", YearsOfService = 10},
                new Servicemember(){FirstName = "Hulk", LastName = "Hogan", DateOfBirth = dob, Rank = "WO1", Branch = "Navy", YearsOfService = 1},
                new Civilian(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob },
                new Civilian(){FirstName = "Greg", LastName = "John", DateOfBirth = dob },
                new Civilian(){FirstName = "Josh", LastName = "Benson", DateOfBirth = dob },
            };

            Person person = new Civilian();

            foreach (var p in people)
            {
                Console.WriteLine(p == person);
                Console.WriteLine(p);

                //person = p;
                if (p is Servicemember)
                {
                    var sm = (Servicemember)p;
                    Console.WriteLine(sm.Rank);
                }
                Console.WriteLine($"Result: {p.Calculate(2, 4)}");
            }
        
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
