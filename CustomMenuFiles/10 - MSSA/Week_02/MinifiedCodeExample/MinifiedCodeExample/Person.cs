using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public class Person : ICommonPrint
    {
        //properties:
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Color { get; set; }
        public int Age { get; set; }

        private string _password = "234523*$N@FV)VKNWWP)!asdf";
        public string Password 
        {
            private get {
                return _password;
            }
            set {
                _password = value;
            }
        }

        public void SetFullName(string input)
        {
            var data = input.Split(' ');
            var first = data[0];
            var second = data[1];
            FirstName = first;
            LastName = second;
        }

        public string GetFullName() => $"{FirstName} {LastName}";

        //public string GetFullName()
        //{
        //    ....
        //    return FirstName + ' ' + LastName;
        //}


        //constructors [overload]
        public Person()
        {
                
        }

        public Person(string name, string color, int age)
        {
            FirstName = name;
            Color = color;
            Age = age;
        }

        //Make a shallow copy in new memory:
        public Person Clone()
        {
            return (Person)this.MemberwiseClone();
        }

        //methods [overide]
        public override string ToString()
        {
            return $"{base.ToString()} -> Name: {GetFullName()} | Color: {Color} | Age: {Age}";
        }

        //public string ToString(string someValues)
        //{
        //    return "";
        //}

        //overloading:
        public virtual string PerformActionRun()
        {
            return $"{GetFullName()} is running";
        }

        public virtual string PerformActionRun(double multiplier)
        {
            return $"{GetFullName()} is running {multiplier} times as fast";
        }

        public string PrintSomething()
        {
            return "I'm in the person hierarchy";
        }

        //abstract
        //public abstract string GiveMeAPassword();

        //signature is not different if the name and parameter type list are the same
        //public string PerformActionRun(double asdfasdf)
        //{
        //    return $"{Name} is running {asdfasdf} times as fast";
        //}


        //private string _name;


        //public string Name { 
        //    get 
        //    { 
        //        return _name; 
        //    } 
        //    set 
        //    { 
        //        _name = value; 
        //    } 
        //}
    }
}
