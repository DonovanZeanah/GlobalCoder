using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ValidationStub
{
    public class ValidationInterop
    {
        //-> //string
        public string GetInputFromUserAsString(string message, bool confirm = true)
        {
            bool isValid = false;
            string input = string.Empty;
            do
            {
                
                //display some message
                Console.WriteLine(message);

                //gather the input
                input = Console.ReadLine();
                if (string.IsNullOrWhiteSpace(input))
                {
                    Console.Write("Invalid input. Please try again.");
                    continue;
                }
                
                //ask for confirmation
                if (confirm)
                {
                    //is this what they intended
                    //display back
                    Console.WriteLine($"You entered ['{input}'].  Is this what you meant [y/n]?");

                    var confirmationText = Console.ReadLine();
                    var userConfirmed = confirmationText.ToLower().StartsWith('y');

                    //if not confirmed, --> invalid
                    if (!userConfirmed)
                    {
                        Console.Write("You cancelled the input.");
                        continue;
                    }
                }
                

                //is it valid in our system
                //check the input (valid number/valid choice/valid string/etc)....

                //...invalidate or validate

                //good get out
                isValid = true;
            } while (!isValid);

            return input;
        }
        //-> //double/int
        public double GetInputFromUserAsDouble(string message, bool confirm = true)
        {
            bool isValid = false;
            string input = string.Empty;
            double value = 0.0;
            do
            {

                //display some message
                Console.WriteLine(message);

                //gather the input
                input = Console.ReadLine();
                if (string.IsNullOrWhiteSpace(input))
                {
                    Console.Write("Invalid input. Please try again.");
                    continue;
                }

                //ask for confirmation
                if (confirm)
                {
                    //is this what they intended
                    //display back
                    Console.WriteLine($"You entered ['{input}'].  Is this what you meant [y/n]?");

                    var confirmationText = Console.ReadLine();
                    var userConfirmed = confirmationText.ToLower().StartsWith('y');

                    //if not confirmed, --> invalid
                    if (!userConfirmed)
                    {
                        Console.Write("You cancelled the input.");
                        continue;
                    }
                }


                //is it valid in our system
                //check the input (valid number/valid choice/valid string/etc)....
                var isDouble = double.TryParse(input, out value);

                //...invalidate or validate
                if (!isDouble)
                {
                    Console.Write("Invalid input. Please try again.");
                    continue;
                }

                //good get out
                isValid = true;
            } while (!isValid);

            return value;
        }

        public int GetInputFromUserAsInt(string message)
        {
            var value = (int)GetInputFromUserAsDouble(message);
            return value;
        }
        //-> //boolean
        public string GetInputFromUserAsBool(string message)
        {
            //...leave it
            return "";
        }
    }
}
