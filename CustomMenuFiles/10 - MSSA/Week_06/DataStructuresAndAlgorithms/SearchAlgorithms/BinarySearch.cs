using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace SearchAlgorithms
{
    public class BinarySearch : ISearchAlgorithm
    {
        public int Search(int[] data, int target)
        {
            var index = BinarySearchAlgorithm(data, target, 0, data.Length - 1);
            return index;
        }

        public int BinarySearchAlgorithm(int[] data, int target, int start, int end)
        {
            if (start > end)
            {
                Console.WriteLine("not found");
                return int.MinValue;
            }

            int mid = (start + end) / 2;

            if (data[mid] == target)
            {
                return mid;
            }
            else if (data[mid] > target)
            {
                return BinarySearchAlgorithm(data, target, start, mid - 1);
            }
            else if (data[mid] < target)
            {
                return BinarySearchAlgorithm(data, target, mid + 1, end);
            }
             
            return int.MinValue;
        }
    }
}
