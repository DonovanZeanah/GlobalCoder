using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class UniversalRemote : BaseRemote
    {
        public string ChangeChannel(int value)
        {
            throw new NotImplementedException();
        }

        public string ChangeVolume(int value)
        {
            throw new NotImplementedException();
        }

        public override void TurnOffPower()
        {
            Console.WriteLine("Turning off power from universal source");
        }

        public override void TurnOnPower()
        {
            Console.WriteLine("Turning on power from universal source");
        }
    }
}
