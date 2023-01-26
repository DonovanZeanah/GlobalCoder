
namespace Week02Base
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var one = GetUserInputAsString("Please give me your name");
            var two = GetUserInputAsString("Plese tell me your favorite color");
            Console.WriteLine(one);
            Console.WriteLine(two);
            //ExtraStuff(one, two);

            var myPerson = new Person();
            Console.WriteLine(myPerson);
            Console.WriteLine(myPerson.ToString());
        }

        private static void ExtraStuff(string one, string two)
        {
            //if condition
            //string output = string.Empty;
            //if (one == two)
            //{
            //   output = "Your name is a color";
            //   ...
            //}
            //else
            //{
            //   output = "Your name is not a color";
            //}

            //ternary operator:
            var output = one == two ? "Your name is a color" : "Your name is not a color";
            Console.WriteLine(output);

            //preprocessor
            int x = 1;
            x++;
            ++x;
            var y = new int[10];
            for (int i = 0; i < 10; i++)
            {
                int j = 0;
                Console.WriteLine(i);
                y[j++] = 10;
            }
            for (int i = 0; i < 10; ++i)
            {
                int j = 0;
                Console.WriteLine(i);
                y[++j] = 10;
            }
        }

        private static string GetUserInputAsString(string message)
        {
            bool continueLooping = true;
            string input = string.Empty;
            while (continueLooping)
            {
                Console.WriteLine(message);
                input = Console.ReadLine() ?? string.Empty;
                
                Console.WriteLine(input);
                Console.WriteLine($"Is {input} what you intended to write?");

                string confirmation = Console.ReadLine() ?? string.Empty;

                if (confirmation.ToLower().StartsWith("y"))
                {
                    //Console.WriteLine($"You wrote {input}. So proud of you!");
                    continueLooping = false;
                }
                else if (confirmation.ToLower().StartsWith("n"))
                {
                    Console.WriteLine("Please try again");
                }
                else
                {
                    Console.WriteLine("Invalid input, please try again");
                }
            } while (continueLooping);

            return input;
        }
    }
}
