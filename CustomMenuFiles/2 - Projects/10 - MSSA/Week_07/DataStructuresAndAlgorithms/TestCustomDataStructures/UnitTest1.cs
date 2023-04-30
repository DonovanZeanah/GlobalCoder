using CustomDataStructures;
using Xunit;
using Shouldly;

namespace TestCustomDataStructures
{
    public class UnitTest1
    {
        [Fact]
        public void TestArrayListAdd()
        {
            var list = new ArrayList<string>();
            list.Add("Mark");

            var nextItem = list[0];
            nextItem.ShouldBe("Mark");

            list.Add("Jim");
            nextItem = list[1];
            nextItem.ShouldBe("Jim");
        }

        [Fact]
        public void TestArrayListResize()
        {
            var list = new ArrayList<int>(20);

            for (int i = 0; i < 50; i++)
            { 
                list.Add(i);
            }

            list.Count.ShouldBe(50);
        }

        [Fact]
        public void TestRemoveGuard()
        { 
        
        }

        [Fact]
        public void TestRemoveAtIndex()
        {
            var testList = new ArrayList<int>();
            for (int i = 0; i < 10; i++)
            {
                testList.Add(i*2);
            }

            testList.RemoveAt(3);
            testList[3].ShouldBe(8);
        }

        //need to test default array size
        //need to test complex constructor
    }
}