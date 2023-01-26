using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    public abstract class Person
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DateOfBirth { get; set; }

        public abstract double Calculate(double x, double y);
        public override string ToString()
        {
            return $"FirstName: {FirstName} | LastName: {LastName} | DateOfBirth: {DateOfBirth.ToString("yyyy.mm.dd")}";
        }

        public override bool Equals(object? obj)
        {
            //is the incoming object a Person?  if not, get out
            //is the incoming object null, get out
            if (obj is null || obj is not Person)
            {
                return false;
            }

            //type is person and obj is not null, convert it
            var person = (Person)obj;

            //compare properties

            //Firstname
            //FirstName == null && person.FirstName != null
            if (string.IsNullOrWhiteSpace(FirstName))
            {
                if (!string.IsNullOrWhiteSpace(person.FirstName))
                {
                    return false;
                }
            }
            //Firstname != null && person.FirstName == null
            //FirstName != null && FirstName != person.FirstName
            else
            {
                if (!FirstName.Equals(person.FirstName))
                {
                    return false;
                }
            }

            //LastName (same code path as FirstName)

            //DateOfBirth (same code path as FirstName, with dates)

            //if you make it here, you win
            return true;
        }
    }
}
