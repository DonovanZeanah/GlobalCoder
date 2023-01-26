using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class AdvancedRemote : BaseRemote
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
            Console.WriteLine("Putting into standby mode");
        }

        public override void TurnOnPower()
        {
            Console.WriteLine("Waking from standby mode");
        }
    }
}
