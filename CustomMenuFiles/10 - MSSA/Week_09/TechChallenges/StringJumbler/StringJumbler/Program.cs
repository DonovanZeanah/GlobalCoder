using Microsoft.Extensions.Configuration;

namespace StringJumbler
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();

            //get input for a string to jumble
            Console.WriteLine("Please enter the string to jumble:");
            var originalString = Console.ReadLine();

            //Jumble it
            var output = JumbleString(originalString);

            Console.WriteLine(new string('*', 80));
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("The jumbled string is:");
            Console.WriteLine(new string('*', 80));
            Console.WriteLine($"{output}");
            Console.WriteLine(new string('*', 80));

            //undo it
            var unjumbled = JumbleString(output);

            Console.WriteLine(new string('*', 80));
            Console.WriteLine("The unjumbled string is:");
            Console.WriteLine(new string('*', 80));
            Console.WriteLine($"{unjumbled}");

        }

        private static string JumbleString(string originalString)
        {
            //take the first string and split into two strings on every other character
            List<char> originalLeftBehind = new List<char>();
            Stack<char> removedOriginal = new Stack<char>();
            for (int i = 0; i < originalString.Length; i++)
            {
                if (i % 2 == 0)
                {
                    originalLeftBehind.Add(originalString[i]);
                }
                else
                {
                    //reverse string two
                    removedOriginal.Push(originalString[i]);
                }
            }

            List<char> result = new List<char>();
            int left = 0;
            //compose with the every other character
            for (int i = 0; i < originalString.Length; i++)
            {
                if (i % 2 == 0)
                {
                    result.Add(originalLeftBehind[left++]);
                }
                else
                {
                    //reverse string two
                    result.Add(removedOriginal.Pop());
                }
            }

            string output = string.Empty;
            foreach (var c in result)
            {
                output = $"{output}{c}";
            }
            return output;
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
