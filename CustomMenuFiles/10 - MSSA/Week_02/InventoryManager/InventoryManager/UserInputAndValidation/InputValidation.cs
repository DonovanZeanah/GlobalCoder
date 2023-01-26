namespace UserInputAndValidation
{
    public static class InputValidation
    {
        public const int DEFAULT_LEN = 80;

        /// <summary>
        /// Get User Input as a String
        /// </summary>
        /// <param name="msg">Prompt to display to the user</param>
        /// <returns>A string entered and confirmed by the user</returns>
        public static string GetUserInputAsString(string msg, bool confirmInput = true)
        {
            bool isValid;
            string input;
            do
            {
                isValid = true;

                PrintStringToUser(msg);
                input = Console.ReadLine() ?? string.Empty;

                if (string.IsNullOrWhiteSpace(input))
                {
                    PrintStringToUser("Invalid Input. Please try again.");
                    continue;
                }
                
                if (confirmInput)
                {
                    isValid = ConfirmUserInput(input);
                    if (!isValid)
                    {
                        PrintStringToUser("Input value reset. Please try again.");
                    }
                }
            } while (!isValid);

            return input;
        }

        /// <summary>
        /// Get User Input as a Double
        /// </summary>
        /// <param name="msg">Prompt to display to the user</param>
        /// <returns>A double entered and confirmed by the user</returns>
        public static double GetUserInputAsDouble(string msg, bool confirmInput = true)
        {
            bool isValid;
            double input;
            do
            {
                isValid = false;
                PrintStringToUser(msg);
                bool success = double.TryParse(Console.ReadLine(), out input);
                if (!success)
                {
                    PrintStringToUser("Invalid Input. Please try again.");
                    continue;
                }

                if (confirmInput)
                {
                    isValid = ConfirmUserInput($"{input}");
                    if (!isValid)
                    {
                        PrintStringToUser("Input value reset. Please try again.");
                    }
                }

            } while (!isValid);

            return input;
        }

        /// <summary>
        /// Get User Input as an Integer
        /// </summary>
        /// <param name="msg">Prompt to display to the user</param>
        /// <returns>A double entered and confirmed by the user cast to an int</returns>
        public static int GetUserInputAsInteger(string msg, bool confirmInput = true)
        {
            return (int)GetUserInputAsDouble(msg, confirmInput);
        }

        public static MenuOption GetUserChoiceAsMenuOption(string msg, bool confirmInput = true)
        {
            var choice = GetUserInputAsInteger(msg, confirmInput);
            return (MenuOption)choice;
        }

        /// <summary>
        /// Get User Input as Bool
        /// </summary>
        /// <param name="msg">Prompt to display to the user</param>
        /// <returns>Yes or No based on their input</returns>
        public static bool GetUserInputAsBool(string msg)
        {
            bool isValid;
            bool input;
            do
            {
                isValid = false;
                PrintStringToUser(msg);
                bool success = bool.TryParse(Console.ReadLine(), out input);
                if (!success)
                {
                    PrintStringToUser("Invalid Input. Please try again.");
                    continue;
                }

                isValid = ConfirmUserInput($"{input}");
                if (!isValid)
                {
                    PrintStringToUser("Input value reset. Please try again.");
                }

            } while (!isValid);

            return input;
        }

        /// <summary>
        /// Confirm the input from the user is correct as collected
        /// </summary>
        /// <param name="data">The value to confirm</param>
        /// <returns>True if the user confirms the value, else false</returns>
        private static bool ConfirmUserInput(string data)
        {
            PrintStringToUser($"You entered: [{data}]. Is this correct [y/n]?");
            return Console.ReadLine()?.ToLower().StartsWith('y') ?? false;
        }

        /// <summary>
        /// Print a string of stars 
        /// </summary>
        /// <param name="num">The number of stars to print on the line</param>
        public static void PrintStars(int num = DEFAULT_LEN)
        {
            PrintStringToUser(new string('*', num));
        }

        /// <summary>
        /// Print any string to the user
        /// </summary>
        /// <param name="msg">What to print as a line</param>
        public static void PrintStringToUser(string msg)
        {
            Console.WriteLine(msg);
        }
    }
}