using Microsoft.Extensions.Configuration;
using UserInputAndValidation;

namespace InventoryManager
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            BuildOptions();
            bool completed = false;

            while (!completed)
            {
                Menu.PrintMenu();

                var userChoice = InputValidation.GetUserChoiceAsMenuOption("What would you like to do today?");
                var itemsService = new ItemsService();
                //perform operations based on menu options
                switch (userChoice)
                {
                    case MenuOption.Add:
                        itemsService.Add();
                        break;
                    case MenuOption.Update:
                        itemsService.Update();
                        break;
                    case MenuOption.Delete:
                        itemsService.Delete();
                        break;
                    case MenuOption.List:
                        itemsService.List();
                        break;
                }

                var completedInput = InputValidation.GetUserInputAsString("Would you like to continue [y/n]?", false);
                completed = completedInput.ToLower().StartsWith('n');
            }

            Console.WriteLine("The program has completed!");
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
