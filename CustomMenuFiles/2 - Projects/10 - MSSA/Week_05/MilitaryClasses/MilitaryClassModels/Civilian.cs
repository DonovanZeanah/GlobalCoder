using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    public class Civilian : Person
    {
        public override double Calculate(double x, double y)
        {
            return x + y;
        }

        public override string ToString()
        {
            return base.ToString();
        }
    }
}
