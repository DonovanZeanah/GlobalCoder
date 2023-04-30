namespace SortAlgorithms
{
    public class SelectionSort : ISortAlgorithm
    {
        public bool SortArray(int[] target)
        {
            //sort array
            for (int i = 0; i < target.Length; i++)
            {
                //left is smallest at start
                var smallestIndex = i;
                //currentSmallest value:
                var currentSmallest = target[i];

                //for the rest of the array
                for (int j = i + 1; j < target.Length; j++)
                {
                    //get next element:
                    var compareToSmallest = target[j];
                    //determine if smallest remaining element
                    if (compareToSmallest < currentSmallest)
                    {
                        //if so, set to the smallest current and mark the index for swap
                        currentSmallest = target[j];
                        smallestIndex = j;
                    }
                }

                //if left most index is not smallest, swap
                if (smallestIndex != i)
                {
                    Console.WriteLine($"Swapped [{i}]:{target[i]} with [{smallestIndex}]:{target[smallestIndex]}");
                    var temp = target[i];
                    target[i] = target[smallestIndex];
                    target[smallestIndex] = temp;
                }
            }

            return true;
        }

        public int GetMinimumIndex(int[] values)
        {
            int min = int.MaxValue;
            int minIndex = 0;
            for (int i = 0; i < values.Length; i++)
            {
                if (values[i] < min)
                { 
                    min = values[i];
                    minIndex = i;
                }
            }

            return minIndex;
        }
    }
}