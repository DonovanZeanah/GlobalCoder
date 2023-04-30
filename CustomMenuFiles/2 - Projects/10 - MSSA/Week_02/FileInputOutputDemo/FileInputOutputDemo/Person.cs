using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileInputOutputDemo
{
    [Serializable]
    public class Person
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public Person() { }
        public Person(int id, string firstName, string lastName)
        {
            Id = id;
            FirstName = firstName;
            LastName = lastName;
        }

        public override string ToString()
        {
            return $"Person [{Id}]: {FirstName} {LastName}";
        }

        public string ToJSON()
        {
            return JsonConvert.SerializeObject(this);
        }

        public static Person JSONToPerson(string jsonPerson)
        {
            return JsonConvert.DeserializeObject<Person>(jsonPerson);
        }
    }
}
