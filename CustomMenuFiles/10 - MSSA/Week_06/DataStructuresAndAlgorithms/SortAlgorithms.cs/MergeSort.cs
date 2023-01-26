using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SortAlgorithms
{
    public class MergeSort : ISortAlgorithm
    {
        public bool SortArray(int[] target)
        {
            //call the sort method that will ultimately split and recurse
            SplitArray(target, 0, target.Length - 1);

            return true;
        }

        public void Merge(int[] target, int start, int mid, int end)
        {
            int[] temp = new int[target.Length];

            //start = 0
            //end = 3 
            //mid = 1 
            //0 | 1          // 2 | 3
            //4 | 9             6 | 7
            
            int leftEnd = 0;
            int tmpPos = 0;
            
            leftEnd = mid - 1;
            tmpPos = start;
            

            //selecting smaller element from left sorted array or right sorted array and placing them in temp array.
            while ((start <= leftEnd) && (mid <= end))
            {
                if (target[start] <= target[mid])
                {
                    temp[tmpPos++] = target[start++];
                    //tmpPos++;
                    //start++;
                }
                else
                {
                    temp[tmpPos++] = target[mid++];
                    //tmpPos++;
                    //mid++;
                }
            }

            //placing remaining element in temp from left sorted array
            while (start <= leftEnd)
            {
                temp[tmpPos++] = target[start++];
                //tmpPos++;
                //start++;
            }

            //placing remaining element in temp from right sorted array
            while (mid <= end)
            {
                temp[tmpPos++] = target[mid++];
                //tmpPos++;
                //mid++;
            }

            //placing temp array to target
            int lengthOfTemp = end - start + 1;
            for (int i = 0; i < lengthOfTemp; i++)
            {
                target[end] = temp[end];
                Console.WriteLine($"target[{end}] = temp[{end}] | {target[end]} = {temp[end]}");
                end--;
            }
        }

        //at least one more method to split and recurse
        public void SplitArray(int[] target, int start, int end)
        {
            //split incoming in half
            if (end > start)
            {
                var mid = (end + start) / 2;     //0, 6 (3)    || 0 - 3 (1)
                SplitArray(target, start, mid);   //0 - 3   || 0-1
                SplitArray(target, mid + 1, end); //4 - 6   || 2-3
                //merge
                Merge(target, start, mid + 1, end);
            }

            if (end == start)
            {
                Console.WriteLine($"Value: {target[end]}");
            }
            if (end - 1 == start)
            {
                Console.WriteLine($"Value: {target[start]} - {target[end]}");
            }

            //var leftLength = mid - start;
            //var rightLength = end - mid + 1;
            //Console.WriteLine($"leftLength: {leftLength}");
            //Console.WriteLine($"rightLength: {rightLength}");



            //int[] left = new int[mid];
            //int[] right = new int[mid + remainder];

            //for (int i = 0; i < mid; i++)
            //{
            //    left[i] = target[i];
            //}
            //int j = 0;
            //for (int i = mid; i < mid + remainder; i++)
            //{
            //    right[j++] = target[i];
            //}

            //if (leftLength > 1)
            //{
            //    //find the mid
            //    //split again
            //    SplitArray(target, start, mid);
            //}
            //if (rightLength > 1)
            //{
            //    //find the mid
            //    //split again
            //    SplitArray(target, mid + 1, end);
            //}

            //for (int i = start; i < mid; i++)
            //{
            //    Console.Write($"LEFT[{i}: {target[i]} |");
            //}
            //Console.WriteLine();
            //for (int i = mid; i <= end; i++)
            //{
            //    Console.Write($"RIGHT[{i} {target[i]} |");
            //}
            //Console.WriteLine();
            //Console.WriteLine(new string('*', 80));
        }
    }
}
