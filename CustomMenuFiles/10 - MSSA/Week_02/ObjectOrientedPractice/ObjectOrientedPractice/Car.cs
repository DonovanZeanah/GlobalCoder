using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObjectOrientedPractice
{
    public class Car : IPowerable 
    {
        public Car()
        {
        }
        public string VIN()
        {
            return "The VIN is: A1B2C3";
        }
        public string StartEngine()
        {
            return "Starting the engine";
        }
        public string ShutOffEngine()
        {
            return "Shutting the engine off";
        }
        public string Drive()
        {
            return "Driving the car";
        }
        public string Park()
        {
            return "Parking the car";
        }

        public string TurnOn()
        {
            return StartEngine();
        }

        public string TurnOff()
        {
            return ShutOffEngine();
        }
    }
}
