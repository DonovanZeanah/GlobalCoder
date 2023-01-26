using Microsoft.Extensions.Configuration;
using UserInputAndValidation;
using VehicleModels;

namespace InventoryManager
{
    public class Program
    {
        private static IConfigurationRoot _configuration;


        public static void Main(string[] args)
        {
            BuildOptions();
            bool completed = false;
            var itemsService = new ItemsService();

            while (!completed)
            {
                Menu.PrintMenu();

                var userChoice = InputValidation.GetUserChoiceAsMenuOption("What would you like to do today?");
                //perform operations based on menu options
                switch (userChoice)
                {
                    case MenuOption.Add:
                        Vehicle newVehicle = GetVehicleDetails();
                        itemsService.Add(newVehicle);
                        break;
                    case MenuOption.Update:
                        Vehicle existingVehicle = GetVehicleAndUpdate(itemsService.GetAllVehicles());
                        Console.WriteLine(itemsService.Update(existingVehicle));
                        break;
                    case MenuOption.Delete:
                        //prompt to get the vehicle to delete...
                        
                        //TODO: pass the id here:
                        //itemsService.Delete(25);
                        break;
                    case MenuOption.Load:
                        itemsService.Load();
                        break;
                    case MenuOption.List:
                        Console.WriteLine(itemsService.List());
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

        private static Vehicle GetVehicleDetails()
        {
            Vehicle v1 = new Vehicle();

            v1.Id = 0;

            v1.Year = InputValidation.GetUserInputAsInteger("What is the year of the vehicle");
            v1.VIN = InputValidation.GetUserInputAsString("What is the VIN");
            v1.Make = InputValidation.GetUserInputAsString("What is the Make");
            v1.Model = InputValidation.GetUserInputAsString("What is the Model");

            return v1;
        }

        private static Vehicle GetVehicleAndUpdate(List<Vehicle> allVehicles)
        {
            InputValidation.PrintStars();

            foreach (var v in allVehicles)
            {
                Console.WriteLine(v);
            }
            InputValidation.PrintStars();

            //Find vehicle
            int vehicleId = InputValidation.GetUserInputAsInteger("What is the Id of the vehicle you want to update?");
            var target = allVehicles.SingleOrDefault(x => x.Id == vehicleId);
            if (target == null)
            {
                throw new Exception("Invalid choice!");
            }

            //todo: get new input
            //var newYear = target.Year;
            //validate they want to change it

            //if want to change it:
            var changeYear = InputValidation.GetUserInputAsInteger("What is the new year?");
            target.Year = changeYear;

            //Return it
            return target;
        }
    }
}
