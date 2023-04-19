using Microsoft.Extensions.Configuration;
using System.Xml.Linq;

namespace DataStructures
{
    public class Program
    {
        private static Random r = new Random();


        public static void Main(string[] args)
        {
            WorkingWithArrays();
            WorkingWithLists();
            WorkingWithStacks();
            WorkingWithQueues();
            WorkingWithDictionaries();
        }
        public static void WorkingWithArrays()
        {
            int[] myNumbers = new int[10];

            Console.WriteLine(new string('*', 80));
            Console.WriteLine("First Array");
            for (int i = 0; i < myNumbers.Length; i++)
            {
                myNumbers[i] = i * 2;
                Console.Write($"{myNumbers[i]}, ");
            }
            Console.WriteLine();
            Console.WriteLine(new string('*', 80));


            int[] actual = new int[] { 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 };
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("Second Array");
            for (int i = 0; i < actual.Length; i++)
            {
                Console.Write($"{actual[i]}, ");
            }
            Console.WriteLine();
            Console.WriteLine(new string('*', 80));

            //type matters
            //actual[7] = "value string";

            object[] myData = new object[5];
            myData[0] = "okay";
            myData[1] = 23;
            myData[2] = actual;
            myData[3] = "okay 2";
            myData[4] = 2322.23;

            for (int i = 0; i < myData.Length; i++)
            {
                Console.Write($"{myData[i]}, ");
            }
            Console.WriteLine();

            var myMDArray = new int[10,10];
            var counter = 0;
            for (int i = 0; i < myMDArray.GetLength(0); i++)
            {
                for (int j = 0; j < myMDArray.GetLength(1); j++)
                {
                    myMDArray[i, j] = counter++;
                    Console.Write($"{myMDArray[i, j]}, ");
                }
            }
            Console.WriteLine();

            dynamic[] myData2 = new dynamic[5];
            myData2[0] = "okay";
            myData2[1] = 23;
            myData2[2] = actual;
            myData2[3] = "okay 2";
            myData2[4] = 2322.23;

            for (int i = 0; i < myData2.Length; i++)
            {
                Console.Write($"Dynamic[{i}]:{myData2[i]}, ");
            }
            Console.WriteLine();
        }

        public static void WorkingWithLists()
        {

            Console.WriteLine();
            var myList = new List<int>();
            for (int i = 0; i < 10; i++)
            {
                myList.Add(i);
                Console.Write($"{myList[i]}, ");
            }
            Console.WriteLine();

            var myList2 = new List<int>()
            {
                  0, 1, 2, 3, 4, 5, 6, 7, 8, 9
            };
            for (int i = 0; i < 10; i++)
            {
                Console.Write($"{myList2[i]}, ");
            }
            Console.WriteLine();


            var myOrderedList = new LinkedList<int>();
            for (int i = 0; i < 10; i++)
            {
                myOrderedList.AddFirst(i);
            }

            foreach (var x in myOrderedList.Reverse())
            {
                Console.WriteLine($"List Next: {x}");
            }
        }

        public static void WorkingWithStacks()
        {
            Stack<int> myNumbers = new Stack<int>();

            for (int i = 0; i < 10; i++)
            {
                myNumbers.Push(r.Next(100));
            }

            var next = myNumbers.Peek();
            Console.WriteLine(next);

            while (myNumbers.Count > 0)
            {
                var nextValue = myNumbers.Pop();
                Console.WriteLine(nextValue);
            }
        }

        public static void WorkingWithQueues()
        { 
            Queue<int> myQueue = new Queue<int>();

            for (int i = 0; i < 10; i++)
            {
                myQueue.Enqueue(i + 1);
            }

            var next = myQueue.Peek();
            Console.WriteLine(next);

            while (myQueue.Count > 0)
            {
                var nextValue = myQueue.Dequeue();
                Console.WriteLine(nextValue);
            }

        }

        public static void WorkingWithDictionaries()
        {
            var myDictionary = new Dictionary<int, int>();

            for (int i = 1; i <= 10; i++)
            {
                myDictionary.Add(i, i * 2);
            }

            var next = myDictionary[7];
            Console.WriteLine(next);

            foreach (var data in myDictionary.Keys)
            {
                Console.WriteLine(myDictionary[data]);
            }

            var complexDictionary = new Dictionary<int, Dictionary<int, int>>();
            complexDictionary.Add(1, myDictionary);

        }
    }
}
