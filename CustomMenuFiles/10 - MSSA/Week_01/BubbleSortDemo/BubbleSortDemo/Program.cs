using Microsoft.Extensions.Configuration;
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Numerics;

namespace BubbleSortDemo
{
    public class Program
    {
        public static void BubbleSort()
        {
            var myArray = new int[] { 1, 4, 7, 2, 8, 99, 17, 16, 15, 3, 9, 12 };

            //10
            //9
            var counter = 0;
            var swapPerformed = false;
            for (int iterationCount = 1; iterationCount < myArray.Length; iterationCount++)
            {
                swapPerformed = false;
                //Console.WriteLine($"Position {i} has data {myArray[i]}");

                for (int i = 0; i < (myArray.Length - 1); i++)
                {
                    //Console.WriteLine($"Position {j} has data {myArray[j]}");

                    if (myArray[i + 1] < myArray[i])
                    {
                        var temp = myArray[i];
                        myArray[i] = myArray[i + 1];
                        myArray[i + 1] = temp;
                        swapPerformed = true;
                        //Console.WriteLine($"Swap performed {myArray[j]} | {myArray[j + 1]}");
                    }
                }
                counter++;
                if (!swapPerformed)
                {
                    break;
                }
            }

            //Console.Write("{{");
            //foreach (var x in myArray)
            //{
            //    Console.Write($"{x},");
            //}
            //Console.WriteLine("}}");

            Console.WriteLine($"Iterated {counter} times");
        }

        public static void OtherBubbleSort()
        {
            var data = new int[] { 1, 4, 7, 2, 8, 99, 17, 16, 15, 3, 9, 12 };
            bool swapped;

            int iterationCount = 0;
            do
            {
                swapped = false;
                for (int i = 0; i < data.Count() - 1; i++)
                {
                    var currentData = data[i];
                    var nextData = data[i + 1];
                    //Console.WriteLine($"data[i] is: {currentData}");
                    //Console.WriteLine($"data[i + 1] is: {nextData}");

                    if (currentData > nextData)
                    {
                        int temp = currentData;
                        data[i] = nextData;
                        data[i + 1] = temp;

                        //Console.WriteLine("Swap performed...");
                        //Console.Write($"{{");
                        foreach (var value in data)
                        {
                            //Console.Write($"{value}, ");
                        }
                        //Console.WriteLine($"}}");
                        swapped = true;
                    }
                }
                iterationCount++;
            } while (swapped);
            Console.WriteLine($"This sort algorithm ran {iterationCount} times");
        }

        public static void Main(string[] args)
        {
            //BubbleSort();
            //OtherBubbleSort();
            BigOofOne();
            BigOLinear();
            BigOQuadratic();
            BigOCubic();
            BigOLogarithmic();
            
        }

        //Big O(1)
        public static void BigOofOne()
        {
            int x = 78;
            int y = 789457;
            var stringName = "aagaeddsga";
            var array = new int[] { 1, 3, 2, 7, 9 };
            array[2] = 2;
        }

        //Big O(n)
        public static void BigOLinear()
        {
            var array = new int[] { 1, 3, 5, 7, 9, 10, 11, 12, 13, 14 };
            for (int i = 0; i < array.Length; i++)
            {
                Console.Write($"{array[i]}");
            }
        }

        //Big O(n^2)
        public static void BigOQuadratic()
        {
            var array = new int[] { 1, 3, 5, 7, 9, 10, 11, 12, 13, 14 };

            for (int i = 0; i < array.Length; i++)
            {
                for (int j = 1; j < array.Length; j++)
                {
                    Console.Write($"{array[i]} | {array[j]}");
                }
            }
            
        }

        //Big O(n^3)
        public static void BigOCubic()
        {
            var array = new int[] { 1, 3, 5, 7, 9, 10, 11, 12, 13, 14 };
            for (int i = 0; i < array.Length; i++)
            {
                for (int j = 1; j < array.Length; j++)
                {
                    for (int k = 0; k < array.Length; k++)
                    {
                        Console.Write($"{array[i]} | {array[j]} | {array[k]}");
                    }
                }
            }
        }

        //Big O(log n)
        public static void BigOLogarithmic()
        {
            var array = new int[] { 1, 2, 3, 4, 5, 7, 9, 145, 11, 12, 72, 13, 14 };

            //while number not found
            //find the mid element
            //is the number ==
                //return the number
            //is the number >
                //take the left and recursively run your code
            //is the number <
                //take the right and recursively run your code
        }

    }
}
