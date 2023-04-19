using SearchAlgorithms;
using Shouldly;
using System;
using Xunit;

namespace TestSearching
{
    public class TestSearchFunctionality
    {
        private static int[] testArray = new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 };
        private static int[] testArray2 = new int[] { 7, 6, 8, 4, 10, 2, 11, 5, 9, 1, 3 };
        
        [Fact]
        public void TestLinearSearch()
        {
            var searcher = new LinearSearch();

            var p1 = searcher.Search(testArray, 10);
            p1.ShouldBe(4);

            p1 = searcher.Search(testArray, 5);
            p1.ShouldBe(7);

            p1 = searcher.Search(testArray, 11);
            p1.ShouldBe(0);

            p1 = searcher.Search(testArray, 6);
            p1.ShouldBe(10);

            //handle exception:
            Assert.Throws<Exception>(() => searcher.Search(testArray, 130));

        }

        [Theory]
        [InlineData(new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 }, 10, 4)]
        [InlineData(new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 }, 5, 7)]
        [InlineData(new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 }, 11, 0)]
        [InlineData(new int[] { 11, 9, 3, 7, 10, 1, 4, 5, 8, 2, 6 }, 6, 10)]
        public void TestLinearSearchMultiple(int[] data, int target, int expected)
        {
            var searcher = new LinearSearch();

            var p1 = searcher.Search(data, target);
            p1.ShouldBe(expected);
        }
    }
}