using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public abstract class BaseRemote : IRemote
    {
        public string ChangeChannel(int value)
        {
            return "Changing Channel";
        }

        public string ChangeVolume(int value)
        {
            return "Changing Volume";
        }

        public string PowerOff()
        {
            TurnOffPower();
            return "Turning off the TV";
        }

        public string PowerOn()
        {
            TurnOnPower();
            return "Turning on the TV";
        }

        public abstract void TurnOffPower();
        public abstract void TurnOnPower();


        public string PrintSomething()
        {
            return "I'm a remote";
        }
    }
}
