using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class Vehicle
    {
        //properties
        public string VIN { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }

        //constructors
        public Vehicle()
        {

        }

        public Vehicle(string vin, string make, string model)
        {
            VIN = vin;
            Make = make;
            Model = model;
        }

        //methods
        public override string ToString()
        {
            return $"VIN: {VIN} | Make: {Make} | Model: {Model}";
        }

        public string HonkTheHorn()
        {
            return "Hoooonnnnnkkkkkk!!!!!!!!".ToUpper();
        }

        public string HonkTheHorn(int intensity)
        {
            var honkSound = string.Empty;

            switch (intensity)
            {
                case 0:
                    honkSound = "beep!";
                    break;
                case 1:
                    honkSound = "beep!";
                    break;
                case 2:
                    honkSound = "beep!";
                    break;
                default:
                    honkSound = HonkTheHorn();
                    break;
            }
            return honkSound;
        }
    }
}
