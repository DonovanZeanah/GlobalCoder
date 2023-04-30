using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    [Serializable]
    public abstract class Person
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DateOfBirth { get; set; }

        public Person()
        {

        }

        public Person(string firstName, string lastName, DateTime dob)
        {
            FirstName = firstName;
            LastName = lastName;
            DateOfBirth = dob;
        }
        public abstract double CalculatePay(double x, double y);
        public override string ToString()
        {
            return $"FirstName: {FirstName} | LastName: {LastName} | DateOfBirth: {DateOfBirth.ToString("yyyy.MM.dd")}";
        }

        public virtual string ToPipeDelimitedString()
        {
            return $"{FirstName}|{LastName}|{DateOfBirth.ToString("yyyy-MM-dd")}";
        }

        public virtual string ToJSON()
        {
            return JsonConvert.SerializeObject(this);
        }

        public static Person FromJSON(string data)
        {
            return JsonConvert.DeserializeObject<Person>(data);
        }

        public override bool Equals(object? obj)
        {
            if (obj == null) return false;
            if (obj is not Person) return false;
            Person p = (Person)obj;
            if (this.LastName != p.LastName)
            {
                return false;
            }
            if (this.FirstName != p.FirstName)
            {
                return false;
            }
            if (this.DateOfBirth != p.DateOfBirth)
            {
                return false;
            }

            return true;
        }

        //public override bool Equals(object? obj)
        //{
        //    //is the incoming object a Person?  if not, get out
        //    //is the incoming object null, get out
        //    if (obj is null || obj is not Person)
        //    {
        //        return false;
        //    }

        //    //type is person and obj is not null, convert it
        //    var person = (Person)obj;

        //    //compare properties

        //    //Firstname
        //    //FirstName == null && person.FirstName != null
        //    if (string.IsNullOrWhiteSpace(FirstName))
        //    {
        //        if (!string.IsNullOrWhiteSpace(person.FirstName))
        //        {
        //            return false;
        //        }
        //    }
        //    //Firstname != null && person.FirstName == null
        //    //FirstName != null && FirstName != person.FirstName
        //    else
        //    {
        //        if (!FirstName.Equals(person.FirstName))
        //        {
        //            return false;
        //        }
        //    }

        //    //LastName (same code path as FirstName)

        //    //DateOfBirth (same code path as FirstName, with dates)

        //    //if you make it here, you win
        //    return true;
        //}
    }
}
