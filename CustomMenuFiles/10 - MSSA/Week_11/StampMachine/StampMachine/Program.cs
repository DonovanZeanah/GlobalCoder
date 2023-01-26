using Microsoft.Extensions.Configuration;
using System.Linq.Expressions;

namespace StampMachine
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            double stampPrice = 0.0;
            double amountPaid = 0.0;
            int numStamps = 0;

            var configStampPrice = _configuration["Settings:StampPrice"];
            bool success = double.TryParse(configStampPrice, out stampPrice);
            if (!success)
            {
                Console.WriteLine("The machine is currently out of order");
            }

            Console.WriteLine($"The current stamp price is: {stampPrice}");

            bool anotherOrder = true;
            do
            {
                success = false;
                while (!success)
                {
                    Console.WriteLine($"How many stamps do you want?");
                    success = int.TryParse(Console.ReadLine(), out numStamps);
                    if (!success)
                    {
                        Console.WriteLine($"Bad Input, try again");
                    }
                }

                double costOfOrder = Math.Round(numStamps * stampPrice, 2);
                Console.WriteLine($"The total cost of your order is {costOfOrder}");

                //todo accumulator to take coins and dollars for input:


                success = false;
                while (!success)
                {
                    Console.WriteLine($"How much cash did the user put in the machine [enter any cash amount]?");
                    success = double.TryParse(Console.ReadLine(), out amountPaid);
                    if (!success)
                    {
                        Console.WriteLine($"Bad Input, try again");
                    }
                }

                //determine change:
                /*
                    $1.00 - One Dollar
                    $0.50 - Half dollar
                    $0.25 - Quarter
                    $0.10 - Dime
                    $0.05 - Nickel
                    $0.01 - Penny
                */

                var changeResult = new Dictionary<double, int>();
                try
                {
                    changeResult = GetChange(costOfOrder, amountPaid);
                    Console.WriteLine("Change Dispensing: ");
                    foreach (var k in changeResult.Keys)
                    {
                        switch (k)
                        {
                            case 1.00:
                                Console.WriteLine($"{changeResult[k]} $1 coins");
                                break;
                            case 0.5:
                                Console.WriteLine($"{changeResult[k]} half dollars");
                                break;
                            case 0.25:
                                Console.WriteLine($"{changeResult[k]} quarters");
                                break;
                            case 0.10:
                                Console.WriteLine($"{changeResult[k]} dimes");
                                break;
                            case 0.05:
                                Console.WriteLine($"{changeResult[k]} nickels");
                                break;
                            case 0.01:
                                Console.WriteLine($"{changeResult[k]} pennies");
                                break;
                            default:
                                break;
                        }
                    }
                    Console.WriteLine("Would you like to do another order?");
                    anotherOrder = Console.ReadLine()?.ToLower().StartsWith('y') ?? false;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Amount paid was not enough to dispense stamps, please try again");
                }
            } while (anotherOrder);
        }

        private static Dictionary<double, int> GetChange(double costOfOrder, double amountPaid)
        {
            Dictionary<double, int> changeTracker = new Dictionary<double, int>();
            changeTracker.Add(1.00, 0);
            changeTracker.Add(0.5, 0);
            changeTracker.Add(0.25, 0);
            changeTracker.Add(0.10, 0);
            changeTracker.Add(0.05, 0);
            changeTracker.Add(0.01, 0);
            if (amountPaid < costOfOrder)
            {
                throw new Exception("Invalid input, order cost is more than paid");
            }

            double deficit = Math.Round(amountPaid - costOfOrder, 2);
            while (deficit > 0)
            {
                if (deficit >= 1)
                {
                    changeTracker[1.00] += 1;
                    deficit -= 1.0;
                }
                else if (deficit >= 0.5)
                {
                    changeTracker[0.5] += 1;
                    deficit -= 0.50;
                }
                else if (deficit >= 0.25)
                {
                    changeTracker[0.25] += 1;
                    deficit -= 0.25;
                }
                else if (deficit >= 0.10)
                {
                    changeTracker[0.10] += 1;
                    deficit -= 0.10;
                }
                else if (deficit >= 0.05)
                {
                    changeTracker[0.05] += 1;
                    deficit -= 0.05;
                }
                else if (deficit >= 0.01)
                {
                    changeTracker[0.01] += 1;
                    deficit -= 0.01;
                }
                deficit = Math.Round(deficit, 2);
            }

            return changeTracker;
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
