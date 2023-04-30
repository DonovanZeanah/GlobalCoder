using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace LiveFileDemo
{
    public class Person
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

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
