using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObjectOrientedPractice
{
    public class Laptop : Computer
    {
        public string HoursOfPowerAvailable()
        {
            return "There are about 20 ways";
        }

        public override string PerformOverclock()
        {
            return "Boosting clock speed on the Laptop";
        }
    }
}
