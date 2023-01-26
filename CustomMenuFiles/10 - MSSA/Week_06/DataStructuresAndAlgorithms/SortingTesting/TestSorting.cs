using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shouldly;
using SortAlgorithms;

namespace SortingTesting
{
    [TestClass]
    public class TestSorting
    {
        private int[] testArray = new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 };
        private int[] testArray2 = new int[] { 7, 6, 8, 4, 10, 2, 11, 5, 9, 1, 3 };
        [TestMethod]
        public void TestGetMinimum()
        {
            var sorter = new SelectionSort();
            var result = sorter.GetMinimumIndex(testArray);

            result.ShouldBe(5, "index 5 should be the minimum before sorting in test array 1");

            result = sorter.GetMinimumIndex(testArray2);
            result.ShouldBe(9, "index 9 should be the minimum before sorting in test array 2");
        }

        [TestMethod]
        public void TestSelectionSort()
        {
            var sorter = new SelectionSort();
            sorter.SortArray(testArray);

            testArray[0].ShouldBe(1);
            testArray[1].ShouldBe(2);
            testArray[2].ShouldBe(3);
            testArray[3].ShouldBe(4);
            testArray[4].ShouldBe(5);
            testArray[5].ShouldBe(6);
            testArray[6].ShouldBe(7);
            testArray[7].ShouldBe(8);
            testArray[8].ShouldBe(9);
            testArray[9].ShouldBe(10);
            testArray[10].ShouldBe(11);

            sorter.SortArray(testArray2);
            testArray2[0].ShouldBe(1);
            testArray2[1].ShouldBe(2);
            testArray2[2].ShouldBe(3);
            testArray2[3].ShouldBe(4);
            testArray2[4].ShouldBe(5);
            testArray2[5].ShouldBe(6);
            testArray2[6].ShouldBe(7);
            testArray2[7].ShouldBe(8);
            testArray2[8].ShouldBe(9);
            testArray2[9].ShouldBe(10);
            testArray2[10].ShouldBe(11);
        }
    }
}