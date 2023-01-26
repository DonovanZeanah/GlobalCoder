using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class Student : Person
    {
        public string Major { get; set; }

        public Student() : base()
        {
            
        }

        public Student(string name, string color, int age, string major) 
                : base(name, color, age)
        {
            this.Major = major;
        }

        public override string ToString()
        {
            return $"{base.ToString()} | Major: {Major}";
        }

        public override string PerformActionRun(double multiplier)
        {
            return $"{base.PerformActionRun()} {multiplier} times as fast because they are eager and ready to go!";
        }
    }
}
