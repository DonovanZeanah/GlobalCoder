using System;
using System.Globalization;
using System.Text;

namespace TypesAndVariablesAndSyntax
{
    public enum DaysOfTheWeek
    { 
        Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    }

    public class Program
    {
        private const string myColor = "Blue";

        public static void Main(string[] args)
        {
            Console.WriteLine("Hello");

            //Car c = new Car();
            //c.VIN = "asdfasdfasf";

            var value = NumDaysEachMonth.numDaysSeptember;

            //numbers
            int x = 32;
            long y = 2435623523235;
            double j = 235235.23423;
            byte b = 255;

            Console.WriteLine(x + y + (j + b));

            //strings and chars
            string aFriend = "any text";
            string anyNumber = "234";
            string specialCharacters = "$^&\"*()";

            char quote = (char)34;
            char alsoQuote = Convert.ToChar(34);
            char unicodeValue = '\u0041';
            char unicodeValue2 = '\u0006';

            Console.WriteLine($"Special Characters: {specialCharacters}");
            Console.WriteLine(quote);
            Console.WriteLine(alsoQuote);
            Console.WriteLine(unicodeValue);
            Console.WriteLine(unicodeValue2);
            var s = "The quick brown fox jumps over the silver dog";

            Console.WriteLine(s);
            Console.WriteLine(s.ToUpper());
            Console.WriteLine(s.ToLower());
            Console.WriteLine(s.Length);
            Console.WriteLine(s.Substring(25));
            Console.WriteLine(s.Substring(10, 15));

            Console.WriteLine(myColor);

            //booleans
            var isAvailable = true;
            var isOpen = false;

            bool isSomething;
            int t2;
            double t3;
            string myName = "";
            string x2;

            int myFullNameLength = myName.Length;
            int day = 0;
            //int day = (int)DaysOfTheWeek.Sunday;
            if (day == (int)DaysOfTheWeek.Sunday)
            {
                isOpen = false;
                Console.WriteLine($"The store is not open because today is {DaysOfTheWeek.Sunday}");
            }

            day = 31;
            
            if (day > NumDaysEachMonth.numDaysSeptember)
            {
                Console.WriteLine("Invalid Date");
            }

        }


    }
}
