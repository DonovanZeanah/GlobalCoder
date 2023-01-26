using Microsoft.Extensions.Configuration;

namespace SequenceChallenge
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static List<int> globalSequence = new List<int>();

        /*
        OB1: Take input and get a number 1-50
        OB2: Print out the sequence from 1 to that number
        OB3: Print the sum of all the numbers in that sequence
        */
        public static void Main(string[] args)
        {
            BuildOptions();

            var requestNumber = 0;
            requestNumber = ValidateUserInput("Which number in the Fibonacci sequence do you want to see?", 1, 100);

            //globalSequence = new List<int>();
            var startTime = DateTime.Now;
            var value = GetFibonacciWithLoop(requestNumber);
            var endTime = DateTime.Now;
            Console.WriteLine($"ExecutionTime A: {endTime - startTime}");
            //globalSequence.ForEach(x => Console.Write($"{x}, "));
            Console.WriteLine();
            Console.WriteLine($"The value at index {requestNumber} is {value}");

            //globalSequence = new List<int>();
            //globalSequence.Add(1);
            //globalSequence.Add(1);
            startTime = DateTime.Now;

            value = GetFibonacciWithRecursion(requestNumber);
            endTime = DateTime.Now;
            Console.WriteLine($"ExecutionTime B: {endTime - startTime}");

            //globalSequence.ForEach(x => Console.Write($"{x}, "));
            Console.WriteLine();
            Console.WriteLine($"The value at index {requestNumber} is {value}");

            //requestNumber = ValidateUserInput("How many numbers do you want to show", 1, 50);

            //List<int> sequence = new List<int>();
            //for (int i = 1; i <= requestNumber; i++)
            //{
            //    sequence.Add(i);
            //}

            //Console.WriteLine("Sequence:");
            //sequence.ForEach(x => Console.Write($"{x}, "));
            //Console.WriteLine();

            //Console.WriteLine($"Sum: {sequence.Sum()}");

            //var root = @"C:\MSSA_Content";
            //var searchText = "SchoolOfFineArtsHierarchy.drawio";
            ////searchText = "TestJustClassLibrary.csproj";
            //var path = FindFilePath(root, searchText);
            //Console.WriteLine($"Path is: {path}");
        }

        private static int GetUserInputWithRange(string msg
                                                    , int min = int.MinValue
                                                    , int max = int.MaxValue)
        {
            int requestNumber = ValidateUserInput(msg, min, max);
            //while (!success)
            //{
            //    success = ValidateUserInput(msg, min, max, out requestNumber);
            //}

            //bool success = false;
            //do
            //{
            //    Console.WriteLine($"{msg} (enter {min}-{max})?");
            //    success = int.TryParse(Console.ReadLine(), out requestNumber);
            //    if (requestNumber < min || requestNumber > max)
            //    {
            //        Console.WriteLine($"Please enter a number between {min} and {max}");
            //        success = false;
            //    }
            //} while (!success);

            return requestNumber;
        }

        //start condition
        //continue condition
        //end condition = we have a valid path

        private static string FindFilePath(string root, string searchText)
        {
            var path = string.Empty;
            //start with root

            //find any directories
            var di = new DirectoryInfo(root);
            foreach (var d in di.GetDirectories())
            {
                //for each directory recurse
                Console.Write($"Searching..{d.FullName}");
                path = FindFilePath(d.FullName, searchText);

                if (!string.IsNullOrWhiteSpace(path))
                {
                    break;
                }
            }

            //find any files
            var files = di.GetFiles();
            foreach (var fi in files)
            {
                //if file matches: return path
                if (fi.FullName.Contains(searchText))
                {
                    path = fi.FullName;
                } 
            }

            return path;
        }

        private static int ValidateUserInput(string msg, int min, int max)
        {
            Console.WriteLine($"{msg} (enter {min}-{max})?");
            var requestNumber = 0;
            bool success = int.TryParse(Console.ReadLine(), out requestNumber);
            if (success && (requestNumber < min || requestNumber > max))
            {
                Console.WriteLine($"Please enter a number between {min} and {max}");
                success = false;
            }
            if (!success)
            {
                return ValidateUserInput(msg, min, max);
            }
            return requestNumber;
        }

        private static int GetFibonacciWithLoop(int index)
        {
            //1, 1, 2, 3, 5, 8, 13, 21, 34, ... , index 
            //1, 2, 3, 4, 5, 6, 7, 8

            var current = 1;
            var prev = 0;
            var nextPrevious = 0;

            //globalSequence.Add(current);
            
            while (index > 1)
            {
                nextPrevious = current;
                current = current + prev;
                //globalSequence.Add(current);
                prev = nextPrevious;
                index--;
            }

            return current;
            //return globalSequence.Last();
        }

        private static int GetFibonacciWithRecursion(int index)
        {
            if (index <= 2)
            {
                return 1;

            }
            else
            {
                //3 => 1 + 1 == 2
                //4 => 1 + 2 == 3
                //5 => 2 + 3 == 5
                //call for index -1 
                var n1 = GetFibonacciWithRecursion(index - 1);
                //call for index -2
                var n2 = GetFibonacciWithRecursion(index - 2);
                //add those together & return the value
                var result = n1 + n2;
                //if (!globalSequence.Contains(result))
                //{
                //    globalSequence.Add(result);
                //}
                return result;
            }
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
