using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    public class Civilian : Person
    {
        public override double CalculatePay(double payRate, double hoursWorked)
        {
            var baseHours = 40;
            if (hoursWorked <= baseHours)
            {
                return hoursWorked * payRate;
            }
            var basePay = baseHours * payRate;
            var otPayHours = (hoursWorked - baseHours) * 1.5;
            var otPayAmount = otPayHours * payRate;
            return otPayAmount + basePay;
        }

        public override string ToString()
        {
            return base.ToString();
        }

        public override bool Equals(object? obj)
        {
            if (obj is not Civilian)
            {
                return false;
            }
            return base.Equals(obj);
        }
    }
}
