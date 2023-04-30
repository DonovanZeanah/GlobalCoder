using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class Worker : Person
    {
        public double Salary { get; set; }


        public Worker()
        {

        }

        public Worker(string name, string color, int age, double salary)
                : base(name, color, age)
        {
            this.Salary = salary;
        }

        public override string ToString()
        {
            return $"{base.ToString()} | Salary: {Salary}";
        }

        public override string PerformActionRun()
        {
            return $"{base.PerformActionRun()} can't run - too tired - overworked";
        }
    }
}
