using BalancedStringCheckUtility;
using Microsoft.Extensions.Configuration;
using System.Diagnostics.Metrics;

namespace _0701Challenge_MatchingParensPalindrome
{
    public class Program
    {
        private static IConfigurationRoot _configuration;
        public const string validChars = "(){}[]";

        public static void Main(string[] args)
        {
            Console.WriteLine("Hello World");

            var testStrings = new List<string>();
            foreach (string line in File.ReadLines(@"TestStrings.txt"))
            {
                Console.WriteLine($"Test Line: {line}");
                testStrings.Add(line);
            }

            var bsc = new BalancedStringCheck();

            foreach (var s in testStrings)
            {
                //var result = IsBalancedStringList(s);
                var result = bsc.IsBalancedStringList(s);
                var output = result ? "is balanced" : "is not balanced";
                Console.WriteLine($"String |{s}| {output}");
            }

            foreach (var s in testStrings)
            {
                //var result = IsBalancedStringStack(s);
                var result = bsc.IsBalancedStringStack(s);

                var outputString = string.Empty;
                if (result)
                {
                    outputString = "is balanced";
                }
                else
                {
                    outputString = "is not balanced";
                }

                var anotherOutput = "result was bad";
                anotherOutput = null;
                var output2 = (anotherOutput is null) ? "this" : anotherOutput;
                var output3 = anotherOutput ?? "this";

                var output = result ? "is balanced" : "is not balanced";
                Console.WriteLine($"String |{s}| {output}");
            }
        }

        private static bool IsBalancedStringList(string s)
        {
            List<char> input = new List<char>();

            foreach (var c in s)
            {
                if (validChars.Contains(c))
                { 
                    input.Add(c);
                }
            }
            char[] characters = new char[input.Count];
            
            input.CopyTo(characters);
            List<char> reversed = characters.ToList();
            reversed.Reverse();

            for (int i = 0; i < input.Count; i++)
            {
                var a = input[i];
                var b = reversed[i];
                if (!IsPartnerCharacter(a, b))
                {
                    return false;
                }
            }

            return true;
        }

        private static bool IsBalancedStringStack(string s)
        { 
            Stack<char> input = new Stack<char>();
            Stack<char> output = new Stack<char>();
            
            foreach (var c in s)
            {
                if (validChars.Contains(c))
                {
                    input.Push(c);
                }
            }

            //creates a stack in reverse order
            output = new Stack<char>(input);

            for (int i = 0; i < input.Count; i++)
            {
                var a = input.Pop();
                var b = output.Pop();

                if (!IsPartnerCharacter(a, b))
                {
                    return false;
                }
            }

            return true;
        }

        private static bool IsPartnerCharacter(char a, char b)
        {
            switch (a)
            {
                case '(':
                    return b.Equals(')');
                case '{':
                    return b.Equals('}');
                case '[':
                    return b.Equals(']');
                case ')':
                    return b.Equals('(');
                case ']':
                    return b.Equals('[');
                case '}':
                    return b.Equals('{');
                default:
                    return false;
            }
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
