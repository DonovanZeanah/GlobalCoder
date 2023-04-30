using CustomDataStructures;
using Microsoft.Extensions.Configuration;
using SearchAlgorithms;
using SortAlgorithms;
using System.Collections;
using System.Collections.Immutable;

namespace DataStructuresAndAlgorithms
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            BuildOptions();
            bool shouldContinue;
            do
            {
                ArrayList<int> myNumbers = new ArrayList<int>();
                for (int i = 0; i < 50; i++)
                {
                    myNumbers.Add(i);
                }

                Console.WriteLine($"{myNumbers.Count}");

                //for (int i = 0; i < 50; i++)
                //{
                //    Console.WriteLine($"{myNumbers[i]}");
                //}

                foreach (int i in myNumbers)
                {
                    Console.WriteLine($"{i}");
                }

                Console.WriteLine($"{myNumbers.Count}");

                return;

                PrintMenu();
                var choice = ValidateUserInputInt("Enter your choice:", 1, 5);

                
                ISortAlgorithm sorter = new SelectionSort();
                ISearchAlgorithm searcher = new LinearSearch();
                bool isSearchRequest = false;
                //get sorter
                switch (choice)
                {
                    case 1:
                        Console.WriteLine("Selection Sort");
                        sorter = new SelectionSort();
                        break;
                    case 2:
                        Console.WriteLine("Linear Search");
                        searcher = new LinearSearch();
                        isSearchRequest = true;
                        break;
                    case 3:
                        Console.WriteLine("Bubble sort");
                        sorter = new BubbleSort();
                        break;
                    case 4:
                        Console.WriteLine("Merge sort");
                        sorter = new MergeSortSolution();
                        break;
                    case 5:
                        Console.WriteLine("Binary Search");
                        searcher = new BinarySearch();
                        isSearchRequest = true;
                        break;
                    default:
                        break;
                }

                //create array
                //int[] data = new int[] { 7, 2, 3, 1, 42, 61, 8, 10, 19, 25 };

                //int[] data = { 4, 9, 7, 6, 5, 3, 1 };

                int[] data = new int[100];
                Random rand = new Random();
                for (int i = 0; i < 100; i++)
                {
                    data[i] = rand.Next(5000);
                }

                if (isSearchRequest)
                {
                    try
                    {
                        var input = ValidateUserInputInt("What number do you want to search for?");
                        if (searcher is BinarySearch)
                        {
                            Array.Sort(data);
                        }
                        var position = searcher.Search(data, input);
                        if (position < 0)
                        {
                            Console.WriteLine($"Item has not been found in the data!");
                        }
                        else
                        {
                            var value = data[position];
                            Console.WriteLine($"Item Found at position: {position} with value {value}");
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
                else
                {
                    //sort
                    var success = sorter.SortArray(data);

                    //print
                    Console.WriteLine("Sorting completed");
                    if (success)
                    {
                        foreach (var n in data)
                        {
                            Console.Write($"{n}, ");
                        }
                        Console.WriteLine();
                    }
                    Console.WriteLine();
                }
                Console.WriteLine("Would you like to continue [y/n]?");
                shouldContinue = Console.ReadLine()?.ToLower().StartsWith('y') ?? false;

            } while (shouldContinue);

            Console.WriteLine("Program completed");
        }

        private static void PrintMenu()
        {
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("* What would you like to do today?".PadRight(79, ' ') + "*");
            Console.WriteLine("* 1) Selection Sort".PadRight(79, ' ') + "*");
            Console.WriteLine("* 2) Linear Search".PadRight(79, ' ') + "*");
            Console.WriteLine("* 3) Bubble Sort".PadRight(79, ' ') + "*");
            Console.WriteLine("* 4) Merge Sort".PadRight(79, ' ') + "*");
            Console.WriteLine("* 5) Binary Search".PadRight(79, ' ') + "*");
            Console.WriteLine(new string('*', 80));
        }

        private static int ValidateUserInputInt(string msg, int min = int.MinValue, int max = int.MaxValue)
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
                return ValidateUserInputInt(msg, min, max);
            }
            return requestNumber;
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
