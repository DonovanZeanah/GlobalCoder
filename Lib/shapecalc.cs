using System; 

namespace AreaCalculator
{
    class Program
    {
        public abstract class Shape 
        {
            public abstract double Area();
        }
        public class Circle : Shape
        {
            public double Radius { get; set; }
            public override double Area()
            {
                return Math.PI * Math.Pow(Radius, 2); 
            }
        }
        public class Square : Shape
        {
            public double Side { get; set; }
            public override double Area()
            {
                return Math.Pow(Side, 2); 
            }
        }
        public class Triangle : Shape
        {
            public double Base { get; set; }