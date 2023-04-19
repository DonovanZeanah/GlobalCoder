using Newtonsoft.Json;
using System.Diagnostics;
using System.Runtime.Serialization;

namespace MilitaryClassModels
{
    [Serializable]
    public class Servicemember : Person
    {
        public string Branch { get; set; }
        public string Rank { get; set; }
        public int YearsOfService { get; set; }

        public Servicemember() : base()
        {

        }

        public Servicemember(string firstName, string lastName, DateTime dob, 
                                string branch, string rank, int yearsOfService)
                : base(firstName, lastName, dob)
        {
            Branch = branch;
            Rank = rank;
            YearsOfService = yearsOfService;
        }

        public override double CalculatePay(double payRate, double hoursWorked)
        {
            return payRate * 40;
        }

        public override string ToString()
        {
            return $"{base.ToString()} | Branch: {Branch} | Rank: {Rank} | YearsOfService: {YearsOfService}";
        }

        public override string ToPipeDelimitedString()
        {
            return $"{base.ToPipeDelimitedString()}|{Rank}|{Branch}|{YearsOfService}";
        }

        public virtual string ToJSON()
        {
            return JsonConvert.SerializeObject(this);
        }

        public static Servicemember FromJSON(string data)
        {
            return JsonConvert.DeserializeObject<Servicemember>(data);
        }

        public override bool Equals(object? obj)
        {
            if (obj is not Servicemember)
            {
                return false;
            }
            var s1 = (Servicemember)obj;
            if (this.YearsOfService != s1.YearsOfService)
            {
                return false;
            }
            if (this.Rank != s1.Rank)
            {
                return false;
            }
            if (this.Branch != s1.Branch)
            {
                return false;
            }
            return base.Equals(obj);
        }

        public static Servicemember GetServicememberFromString(string data)
        {
            var sm = new Servicemember();

            //parse the string into an array -> 
            //pipe delimited
            var parts = data.Split('|');
            //
            foreach (var part in parts)
            {
                Debug.WriteLine(part);
            }

            sm.FirstName = parts[0].Trim();
            sm.LastName = parts[1].Trim();

            var dateParts = parts[2].Trim().Split("-");
            var year = Convert.ToInt32(dateParts[0]);
            var month = Convert.ToInt32(dateParts[1]);
            var day = Convert.ToInt32(dateParts[2]);

            sm.DateOfBirth = new DateTime(year, month, day);
            
            sm.Rank = parts[3].Trim(); ;
            sm.Branch = parts[4].Trim(); ;
            sm.YearsOfService = Convert.ToInt32(parts[5].Trim());

            return sm;
        }
    }
}