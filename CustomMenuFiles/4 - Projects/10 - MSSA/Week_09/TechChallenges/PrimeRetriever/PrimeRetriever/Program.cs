using Microsoft.Extensions.Configuration;

namespace PrimeRetriever
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            var configCheck = _configuration["SimpleKey:SimpleValue"];
            Console.WriteLine($"Configuration: {configCheck}");

            bool success = false;
            int lowestPossibleValue = 0;
            int numberOfPrimes = 0;
            //get input for a
            while (!success)
            {
                Console.WriteLine("Please enter the number to start at:");
                success = int.TryParse(Console.ReadLine(), out lowestPossibleValue);
            }
            Console.WriteLine($"All primes > {lowestPossibleValue} will be considered.");
            //get input for b
            do
            {
                Console.WriteLine("Please enter the number of primes to retrieve:");
                success = int.TryParse(Console.ReadLine(), out numberOfPrimes);
            } while(!success);
            Console.WriteLine($"Retriving {numberOfPrimes} where one of the digits is '3'");

            //list to hold primes
            List<int> results = new List<int>();

            //evalute each number starting with a to find if prime AND has a three in it list is count == b
            int i = lowestPossibleValue;
            int keyDigit = 3;
            while (results.Count() < numberOfPrimes)
            {
                //set number to check
                var checkPrime = i;

                //increment counter so can exit early
                i++;
                
                //check if i is prime
                success = IsPrime(checkPrime);

                //if not continue
                if (!success) continue;

                //if so, check if has a 3
                success = ContainsKeyDigit(checkPrime, keyDigit);
                //if not, continue
                if (!success) continue;
                //if so, add to list
                results.Add(checkPrime);
            }

            i = 1;
            foreach (var num in results)
            {
                Console.Write($"{num}");
                if (i != results.Count())
                {
                    Console.Write($",");
                }
                i++;
            }
            Console.WriteLine();
            Console.WriteLine("Program completed");
        }

        private static bool IsPrime(int i)
        {
            //if i / anything other than i or 1 % 0 == 0 then not prime
            //you can stop once the number goes more than half way on division
            //as all possible factors would be tested at that point
            for (int start = 2; start <= i / 2; start++)
            {
                if (i % start == 0)
                {
                    return false;
                }
            }
            return true;
        }

        private static bool ContainsKeyDigit(int test, int digit)
        {
            return test.ToString().Contains(digit.ToString());
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
