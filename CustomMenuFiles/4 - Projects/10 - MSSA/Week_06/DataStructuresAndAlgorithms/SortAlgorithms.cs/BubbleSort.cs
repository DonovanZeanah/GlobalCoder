using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SortAlgorithms
{
    public class BubbleSort : ISortAlgorithm
    {
        public bool SortArray(int[] data)
        {
            bool swapped;
            do
            {
                swapped = false;

                for (int i = 0; i < data.Count() - 1; i++)
                {
                    var currentData = data[i];
                    var nextData = data[i + 1];
                    
                    if (currentData > nextData)
                    {
                        Console.WriteLine($"Swapping {currentData} with {nextData}");
                        int temp = currentData;
                        data[i] = nextData;
                        data[i + 1] = temp;
                        swapped = true;
                    }
                }

                if (swapped)
                {
                    Console.WriteLine("A swap has been performed. Loop will run again");
                }

            } while (swapped);

            return true;
        }
    }
}
