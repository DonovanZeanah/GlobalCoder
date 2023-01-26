using Microsoft.Extensions.Configuration;

namespace UnitTestingTraining
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            //take in two numbers
            double number1 = 0.0;
            double number2 = 0.0;

            bool success = false;
            while (!success)
            {
                Console.WriteLine("Please enter a number:");
                success = double.TryParse(Console.ReadLine(), out number1);
            }

            success = false;
            while (!success)
            {
                Console.WriteLine("Please enter a second number:");
                success = double.TryParse(Console.ReadLine(), out number2);
            }

            //add
            var result = Add(number1, number2);
            Console.WriteLine($"The result of adding {number1} to {number2} is {result}");

            //subtract

            //multiply

            //delete

            //output the results along the way
        }

        public static double Add(double n1, double n2)
        {
            return n1 + n2;
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
