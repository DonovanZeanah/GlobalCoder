using System.Security.Cryptography.X509Certificates;
using System.Text;

namespace Fibonacci
{
    public class Program
    {
        public static List<int> globalSequence = new List<int>();
        public static void Main(string[] args)
        {
            bool shouldContinue = true;
            do
            {
                int sequenceCounter = 0;
                Console.WriteLine("What number in the sequence would you like to find?:");
                bool success = int.TryParse(Console.ReadLine(), out sequenceCounter);
                while (!success)
                {
                    Console.WriteLine("Bad Input. What number in the sequence would you like to find?:");
                    int.TryParse(Console.ReadLine(), out sequenceCounter);
                }

                Console.WriteLine("Would you like to solve with Recursion [y/n]?");
                var useRecursion = Console.ReadLine().ToLower().StartsWith('y');
                int result = 0;
                string sequenceOutput = string.Empty;
                if (useRecursion)
                {
                    //recursion
                    globalSequence = new List<int>();
                    globalSequence.Add(1);
                    globalSequence.Add(1);
                    result = GetNumberInSequenceRecursive(sequenceCounter);

                    sequenceOutput = GetSequenceOutput(globalSequence);
                    Console.WriteLine($"Sequence: {sequenceOutput}");
                }
                else
                {
                    globalSequence = new List<int>();
                    result = GetNumberInSequence(sequenceCounter);
                    sequenceOutput = GetSequenceOutput(globalSequence);
                    Console.WriteLine($"Sequence: {sequenceOutput}");
                }

                Console.WriteLine($"The number in the sequence at position {sequenceCounter} is: {result}");

                Console.WriteLine("Would you like to run again [y/n]?");
                shouldContinue = Console.ReadLine().ToLower().StartsWith('y');
            }
            while (shouldContinue);
        }

        private static string GetSequenceOutput(List<int> sequence)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var s in sequence)
            {
                if (sb.Length > 0)
                {
                    sb.Append(", ");
                }
                sb.Append(s);
            }

            return sb.ToString();
        }

        public static int GetNumberInSequence(int numberInSequence)
        {
            var current = 1;
            var prev = 0;
            var nextPrevious = 0;

            globalSequence.Add(current);
            while (numberInSequence > 1)
            {
                nextPrevious = current;
                current = current + prev;
                globalSequence.Add(current);
                prev = nextPrevious;
                numberInSequence--;
            }
            return globalSequence.Last();
        }
    
        public static int GetNumberInSequenceRecursive(int number)
        {
            
            if (number <= 2)
            {
                return 1;
            }
            else
            {
                var n1 = GetNumberInSequenceRecursive(number - 1);
                var n2 = GetNumberInSequenceRecursive(number - 2);
                if (!globalSequence.Contains(n1))
                {
                    globalSequence.Add(n1);
                }
                if (!globalSequence.Contains(n2))
                {
                    globalSequence.Add(n2);
                }
                var result = n1 + n2;
                if (!globalSequence.Contains(result))
                {
                    globalSequence.Add(result);
                }
                return result;
            }

        }
    }
}