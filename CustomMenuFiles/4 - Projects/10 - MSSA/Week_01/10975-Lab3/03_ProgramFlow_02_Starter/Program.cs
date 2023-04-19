
using static System.Net.Mime.MediaTypeNames;

namespace _03_ProgramFlow_02_Solution
{
    public class Program
    {
        private static List<double> grades = new List<double>();

        static async Task Main(string[] args)
        {
            Console.WriteLine("03 -> Program Flow");
            DisplayReminders();

            SetInstructorName("MSSA Instructor");
            
            //Create a nested if statement that checks if a class is in the program,
            //if it is required, and if it is an elective.
            //Then output the result text to the Console window. Call this function from within Main.
            SetCourseTitle("Math 101");
            SetCourseTitle("No");
            SetCourseTitle(new string('a', 51));
            SetCourseTitle("Math 800");

            //TODO: Take grades from the user
            bool continueGrading = false;
            do
            {
                var nextGrade = GetInputFromUserAsDouble("What is the next grade?");
                //TODO: Add them to the grades array
                grades.Add(nextGrade);

                PrintMessageToUser("Would you like to add more grades [y/n]?");
                //var result = Console.ReadLine() ?? string.Empty;
                var result2 = Console.ReadLine();

                //continueGrading = result.ToLower().StartsWith('y');
                continueGrading = result2?.ToLower().StartsWith('y') ?? false;
            } while (continueGrading);
            
            CalculateAverageGrade();
        }

        static async Task CalculateAverageGrade()
        {
            /*
             *  Create a for loop that iterates over an array of grades to calculate 
                the average. Use the following array of grades.
            */
            //0 => 89.2
            //1 => 98.7
            //2 => 99.4
            //3 => 91.5
            //4 => 95.2
            //double[] grades = new double[] { 89.2, 98.7, 99.4, 91.5, 95.2, 96.2 };
            //double[] grades2 = new double[grades.Length];
            //grades2[0] = 89.2;
            //grades2[1] = 98.7;
            //grades2[2] = 99.4;
            //grades2[3] = 91.5;
            //grades2[4] = 95.2;
            //grades2[5] = 96.2;

            //var x = grades.Sum();
            double accumulator = 0.0;

            for (int i = 0; i < grades.Count; i++)
            {
                PrintMessageToUser($"Next Grade: {grades[i]}");
                //PrintMessageToUser($"Next Grade: {grades2[i]}");
                //accumulator = accumulator + grades[i];
                accumulator += grades[i];
            }

            var avg = accumulator / grades.Count;
            //var avgString = string.Format("{0:0.00}", Math.Round(avg, 2));
            PrintMessageToUser($"The average grade is {Math.Round(avg, 2)}");
        }

        public static void SetInstructorName(string instructorName)
        {

        }

        private static List<string> GetValidClassNames()
        {
            //var l = new List<string>();
            //l.Add("Math 101");
            //l.Add("ITP 10975");
            //l.Add("English 101");
            //l.Add("Math 201");
            //l.Add("Physics 404");
            //return l;

            var l2 = new List<string>(){
                "Math 101",
                "ITP 10975",
                "English 101",
                "Math 201",
                "Physics 404"
            };
            return l2;

        }

        public static void SetCourseTitle(string courseTitle)
        {
            bool isValid = ValidationLogic.ValidateCourseTitle(courseTitle);
            var message = $"The course title  - {courseTitle} - is";
            
            if (isValid)
            {
                var courses = GetValidClassNames();
                if (courses.Contains(courseTitle))
                {
                    message = $"{message} valid and is part of the program";
                }
                else
                {
                    message = $"{message} not part of the program";
                }
                
            }
            else
            {
                message = $"{message} not valid due to length";
            }

            PrintMessageToUser(message);
        }

        private static void PrintMessageToUser(string message)
        {
            Console.WriteLine(message);
        }

        /*
         * 
         Create a function that uses a switch statement to display reminders on the console when a discussion 
post, quiz, or assignment is due. 
        Use the following logic: 
            Discussions on Wednesday, 
            Quiz on Friday, 
            and Assignment on Sunday.
         */

        public static void DisplayReminders()
        {
            var dt = DateTime.Now;
            switch (dt.DayOfWeek)
            {
                case DayOfWeek.Wednesday:
                    PrintMessageToUser("Discussion Due");
                    break;
                case DayOfWeek.Friday:
                    PrintMessageToUser("Quiz Time!");
                    break;
                case DayOfWeek.Sunday:
                    PrintMessageToUser("Assignment Due Today!");
                    break;
                default:
                    break;
            }
        }

        private static double GetInputFromUserAsDouble(string message)
        {
            double n1 = double.NaN;
            while (n1 is double.NaN)
            {
                PrintMessageToUser(message);
                var success = double.TryParse(Console.ReadLine(), out n1);
                if (!success)
                {
                    n1 = double.NaN;
                    continue;
                }

                bool correctValue = ValidateInput($"Is {n1} the correct value [y/n]?");
                if (!correctValue)
                {
                    n1 = double.NaN;
                    continue;
                }
            }
            return n1;
        }

        private static bool ValidateInput(string message)
        {
            PrintMessageToUser(message);
            var choice = Console.ReadLine();

            return choice != null && choice.ToLower().StartsWith('y');
        }
    }
}
