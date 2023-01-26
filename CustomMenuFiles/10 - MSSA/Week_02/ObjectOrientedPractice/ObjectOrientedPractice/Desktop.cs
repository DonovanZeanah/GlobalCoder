using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObjectOrientedPractice
{
    public class Desktop : Computer
    {
        public override string PerformOverclock()
        {
            return "Performing overclock to boost speed on the Desktop..";
        }
    }
}
