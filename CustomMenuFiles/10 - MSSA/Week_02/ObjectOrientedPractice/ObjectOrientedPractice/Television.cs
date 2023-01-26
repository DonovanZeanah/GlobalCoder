using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObjectOrientedPractice
{
    public class Television : IPowerable
    {
        public string TurnTVOn()
        {
            return "This is turning the TV on.";
        }
        public string TurnTVOff()
        {
            return "This is turning the TV off.";
        }
        public string ChangeChannel()
        {
            return "This is changing the channel.";
        }
        public string ChangeVolume()
        {
            return "This is changing the volume.";
        }

        public string TurnOn()
        {
            return TurnTVOn();
        }

        public string TurnOff()
        {
            return TurnTVOff();
        }
    }
}
