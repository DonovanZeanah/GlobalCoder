using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObjectOrientedPractice
{
    public abstract class Computer : IPowerable
    {
        public string LoadProgram()
        {
            return "This is loading a program";
        }
        public string RunProgram()
        {
            return "This is running a program";
        }
        public string PowerOn()
        {
            return "powering on";
        }
        public string PowerOff()
        {
            return "powering off";
        }
        public string OverClock()
        {
            return $"Performing Overclock, result: {PerformOverclock()}";
        }

        public string TurnOn()
        {
            return PowerOn();
        }

        public string TurnOff()
        {
            return PowerOff();
        }

        public abstract string PerformOverclock();
    }
}
