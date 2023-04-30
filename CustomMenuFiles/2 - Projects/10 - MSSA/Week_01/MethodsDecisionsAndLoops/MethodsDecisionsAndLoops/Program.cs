using Microsoft.Extensions.Configuration;

namespace MethodsDecisionsAndLoops
{
    public class Program
    {
        public static void Main(string[] args)
        {
            PrintMessageToUser("Hello World");

            //bool isValid = false;
            //0 to many iterations: maybe never/maybe forever/likely just a few
            //int i = 10;
            //while (i < 5)
            //{
            //    i++;
            //    PrintMessageToUser("Bad dudes");

            //    //if (i >= 5)
            //    //{
            //    //    isValid = true;
            //    //}

            //    PrintMessageToUser($"i = {i}");
            //}

            ////do..while 1 to many iterations: always once/maybe forever/likely just a few
            //do
            //{
            //    PrintMessageToUser("Good dudes");
            //} while (i < 5);

            //for loop: useful for collections with sizes
            //for (int i = 0; i < 10; i++)
            //{
            //    PrintMessageToUser($"i = {i}");
            //}

            //var theString = "Welcome to MSSA! It is awesome to use GIT!";
            //for (int i = 0; i < theString.Length; i++)
            //{
            //    PrintMessageToUser($"i = {i} | value = {theString[i]}");
            //}

            //Ask the user what they want to do?
            //(Add, Subtract, Multiply, Divide)

            //do all of this in a menu method
            //get the choice back
            //prevent bad input
            //present all options
            int choice = int.MinValue;
            do
            {
                PrintMenu();
                choice = GetUserMenuChoice();
                bool correctValue = ValidateInput($"Is {choice} the correct menu choice [y/n]?");
                if (!correctValue)
                {
                    choice = int.MinValue;
                }
            } while (choice == int.MinValue);
            
            //confirm choice?
            //if invalid -> automatically just print something and give them the menu again
            //if (choice == int.MinValue)
            //{
            //    PrintMessageToUser("Invalid Input [bad menu choice]", true);
            //    return;
            //}

            
            double number1 = GetInputFromUserAsDouble("Enter the first number:");
            //if (number1 is double.NaN)
            //{
            //    PrintMessageToUser("Invalid Input [bad number1 input]", true);
            //    return;
            //}

            double number2 = GetInputFromUserAsDouble("Enter the second number:");
            //if (number2 is double.NaN)
            //{
            //    PrintMessageToUser("Invalid Input [bad number2 input]", true);
            //    return;
            //}

            //change this if/else if to a switch
            double result = 0.0;

            switch (choice)
            {
                case 1:
                    //Add
                    PrintMessageToUser("Do the add here");
                    result = number1 + number2;
                    break;
                case 2:
                    //Sub
                    PrintMessageToUser("Do the subtract here");
                    result = number1 - number2;
                    break;
                case 3:
                    //Multiply
                    PrintMessageToUser("Do the multiply here");
                    result = number1 * number2;
                    break;
                case 4:
                    //Divide
                    PrintMessageToUser("Do the division here");
                    //prevent divide by 0
                    if (number2 == 0)
                    {
                        PrintMessageToUser("Invalid Input [divide by 0!]", true);
                        return;
                    }
                    result = number1 / number2;
                    break;
                default:
                    PrintMessageToUser("Invalid Input");
                    return;
            }

            PrintMessageToUser($"Result is: {result}", true);
        }

        private static void PrintMessageToUser(string message)
        {
            PrintMessageToUser(message, false);
        }

        private static void PrintMessageToUser(string message, bool logIt)
        {
            Console.WriteLine(message);
            //also log to a text file...
            if (logIt)
            {
                PrintMessageToUser("Uh Oh", false);
            }
        }

        private static double GetInputFromUserAsDouble(string message)
        {
            double n1 = double.NaN;
            while (n1 is double.NaN)
            {
                PrintMessageToUser(message);
                var success = double.TryParse(Console.ReadLine(), out n1);
                if (!success)
                {
                    n1 = double.NaN;
                    continue;
                }

                bool correctValue = ValidateInput($"Is {n1} the correct value [y/n]?");
                if (!correctValue)
                {
                    n1 = double.NaN;
                    continue;
                }
            }
            return n1;
        }

        private static void PrintMenu()
        {
            //Print Menu
            PrintMessageToUser(new string('*', 80));
            PrintMessageToUser("* What would you like to do today?");
            PrintMessageToUser("* 1] Add");
            PrintMessageToUser("* 2] Subtract");
            PrintMessageToUser("* 3] Multiply");
            PrintMessageToUser("* 4] Divide");
            PrintMessageToUser(new string('*', 80));
        }

        private static int GetUserMenuChoice()
        {
            //Get the user response
            //tryparse check if input can be converted/get a value
            int input1 = 0;
            bool success = int.TryParse(Console.ReadLine(), out input1);

            //Validate Choice Range
            if (!success || input1 < 1 || input1 > 4)
            {
                PrintMessageToUser("Invalid Input [bad choice]", true);
                return int.MinValue;
            }
            //return
            return input1;
        }

        private static bool ValidateInput(string message)
        {
            PrintMessageToUser(message);
            var choice = Console.ReadLine();
            
            return choice != null && choice.ToLower().StartsWith('y');

            //if (choice.ToLower().StartsWith('y'))
            //{
            //    return true;
            //}
            //else
            //{
            //    return false;
            //}
        }

    }
}
