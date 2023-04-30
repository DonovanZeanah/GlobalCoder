using NumberGenerator;
using static System.Net.Mime.MediaTypeNames;

namespace ChallengeActivity0501
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //1 & 2
            //int x = 2;
            //int y = 3;
            //Console.WriteLine($"Result: {x + y}");

            //3 & 4
            //Console.WriteLine($"Result: {AddTwoNumbers(x, y)}");

            //5 & 6
            //int[] numbers = new int[100];
            //10 (changed to a list):
            //List<int> numbers = new List<int>();
            //for (int i = 1; i <= 100; i++)
            //{
            //    //numbers[i - 1] = i;
            //    numbers.Add(i);
            //}

            //13 changed to use a class
            //var sg = new SequenceGenerator();
            INumberGenerator ng = new SequenceGenerator();
            //var numbers = sg.GetSequence(0, 100);
            var numbers = ng.GenerateNumbers(100, 1);

            //7
            //var previous = 0;
            //var next = 0;
            //foreach (var n in numbers)
            //{
            //    next = n;
            //    Console.WriteLine($"n1: {previous} | n2: {next} | Result: {AddTwoNumbers(previous, next)}");
            //    previous = next;
            //}
            //extra credit refactoring
            AddAndPrintSequence(numbers);

            //8
            //var data = GetRandomData(100);
            //10 
            //var data = GetRandomDataAsList(100);
            //13 changed to use class
            //var rg = new RandomGenerator();
            //14 changed to use interface
            ng = new RandomGenerator();
            //var data = rg.GetSequence(100);
            var data = ng.GenerateNumbers(100);
            //11
            data.Sort((a, b) => b.CompareTo(a));
            //9
            //previous = 0;
            //next = 0;
            //foreach (var n in data)
            //{
            //    next = n;
            //    Console.WriteLine($"n1: {previous} | n2: {next} | Result: {AddTwoNumbers(previous, next)}");
            //    previous = next;
            //}
            //extra credit
            AddAndPrintSequence(data);
        }

        private static void AddAndPrintSequence(List<int> numbers)
        {
            var previous = 0;
            var next = 0;
            foreach (var n in numbers)
            {
                next = n;
                Console.WriteLine($"n1: {previous} | n2: {next} | Result: {AddTwoNumbers(previous, next)}");
                previous = next;
            }
        }

        //3 & 4
        public static int AddTwoNumbers(int x, int y)
        {
            return x + y;
        }

        //8
        public static int[] GetRandomData(int size)
        { 
            Random r = new Random();
            int[] numbers = new int[size];
            for (int i = 0; i < size; i++)
            {
                numbers[i] = r.Next();
            }
            return numbers;
        }

        //10
        public static List<int> GetRandomDataAsList(int size)
        {
            Random r = new Random();
            List<int> numbers = new List<int>();
            for (int i = 0; i < size; i++)
            {
                numbers.Add(r.Next(1, 10000));
            }
            return numbers;
        }
    }
    
}