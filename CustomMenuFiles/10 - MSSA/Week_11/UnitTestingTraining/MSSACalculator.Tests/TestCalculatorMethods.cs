using Shouldly;
using Xunit;

namespace MSSACalculator.Tests
{
    public class TestCalculatorMethods
    {
        private Calculator _calculator = new Calculator();
        private const double NUMBER2 = 2.0;
        private const double NUMBER4 = 4.0;

        [Fact]
        public void TestAddPositive()
        {
            //arrange
            //act
            var result = _calculator.Add(NUMBER2, NUMBER2);

            //assert
            result.ShouldBeEquivalentTo(NUMBER4);
        }

        [Fact]
        public void TestAddNegative()
        {
            //arrange
            double n1 = 2;
            double n2 = -2;

            //act
            var result = _calculator.Add(n1, n2);

            //assert
            result.ShouldBeEquivalentTo(0.0);
        }

        [Theory]
        [InlineData(1.0, 2.0, -1.0)]
        [InlineData(2.0, 2.0, 0.0)]
        [InlineData(4.0, 2.75, 1.25)]
        public void TestSubtract(double n1, double n2, double expectedVal)
        {
            var result = _calculator.Subtract(n1, n2);

            //assert
            result.ShouldBeEquivalentTo(expectedVal);
        }

        [Fact]
        public void TestMultiply()
        {
            //TODO: 1.4b Write the tests
        }

        [Fact]
        public void TestDivide()
        {
            //TODO: 1.5b Write the tests
        }
    }
}