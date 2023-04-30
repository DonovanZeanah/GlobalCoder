using Microsoft.Extensions.Configuration;
using MilitaryClassModels;
using Newtonsoft.Json;
using System.Diagnostics.Metrics;
using System.Net;
using System.Xml.Serialization;
using System.Security.Cryptography;
using System.Text;

namespace MilitaryClasses
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static async Task Main(string[] args)
        {
            var p1 = new Point();
            p1.Lat = -47.234234;
            p1.Lon = 152.2626298234;

            var p2 = new Point(75.2352, -165.235);

            var geoFence = new Dictionary<string, Point>();
            geoFence.Add("North", p1);
            geoFence.Add("South", p2);

            foreach (var k in geoFence.Keys)
            {
                Console.WriteLine(k);
                Console.WriteLine(geoFence[k].Lon);
                Console.WriteLine(geoFence[k].Lat);
            }

            ////either a catch or finally
            //try
            //{
            //    //no matter what..
            //    //took input: asdf
            //    //took input: 32

            //    int x = Convert.ToInt32("asdf");
            //    int y = Convert.ToInt32("32");

            //    //possible error...
            //}
            //catch (ArgumentException aex)
            //{
            //    throw new Exception("another ex");

            //    try
            //    {
            //        throw new Exception("another ex 2");
            //    }
            //    catch (Exception ex)
            //    { 
            //        //squelch it
            //    }
                
            //}
            //catch (Exception ex)
            //{
            //    //...
            //}
            //finally
            //{
            //    //always
            //}

            //double.TryParse("asdfasf", out double v2);

            //double userInput1;
            //bool success = double.TryParse("asdf", out userInput1);
            //if (!success)
            //{ 
            //    //throw..get out or continue or repeat
            //}


            //BuildOptions();
            //Console.WriteLine("Hello World");

            //var configCheck = _configuration["SimpleKey:SimpleValue"];
            //Console.WriteLine($"Configuration: {configCheck}");

            //var today = new DateTime(2022, 11, 3);

            var dob = DateTime.Now.AddYears(-25);

            List<Person> people = new List<Person>() {
                new Servicemember(){FirstName = "Brian", LastName = "Braine", DateOfBirth = dob, Rank = "CMSAF", Branch = "Air Force", YearsOfService = 7},
                new Servicemember(){FirstName = "Bob", LastName = "Ross", DateOfBirth = dob, Rank = "MSgt", Branch = "Air Force", YearsOfService = 10},
                new Servicemember(){FirstName = "Emma", LastName = "Watson", DateOfBirth = dob, Rank = "SSGT", Branch = "Army", YearsOfService = 5},
                new Servicemember(){FirstName = "Bruce", LastName = "Willis", DateOfBirth = dob, Rank = "MGySgt", Branch = "Marines", YearsOfService = 20},
                new Servicemember(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob, Rank = "Captain", Branch = "Army", YearsOfService = 6},
                new Servicemember(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob, Rank = "Captain", Branch = "Army", YearsOfService = 6},
                new Servicemember(){FirstName = "Tom", LastName = "Hanks", DateOfBirth = dob, Rank = "CPO", Branch = "Navy", YearsOfService = 10},
                new Servicemember(){FirstName = "Hulk", LastName = "Hogan", DateOfBirth = dob, Rank = "WO1", Branch = "Navy", YearsOfService = 1},
                new Civilian(){FirstName = "Bat", LastName = "Man", DateOfBirth = dob },
                new Civilian(){FirstName = "Greg", LastName = "John", DateOfBirth = dob },
                new Civilian(){FirstName = "Josh", LastName = "Benson", DateOfBirth = dob },
            };

            Person person = new Civilian();

            foreach (string line in System.IO.File.ReadLines(@"soldiers.dat"))
            {
                var result = Servicemember.GetServicememberFromString(line);

                people.Add(result);
            }

            foreach (var p in people)
            {
                Console.WriteLine(p == person);
                Console.WriteLine(p);

                //person = p;
                if (p is Servicemember)
                {
                    var sm = (Servicemember)p;
                    Console.WriteLine(sm.Rank);
                }
                Console.WriteLine($"Result: {p.CalculatePay(2, 4)}");
            }

            Pair pair = new Pair();
            pair.PairKey = 1;
            pair.PairValue = "Banana";
            pair.PairKey = 2;
            pair.PairValue = "Apple";
            pair.PairKey = 3;
            pair.PairValue = "Orange";
            PairOfStrings pair2 = new PairOfStrings();
            pair2.PairKey = "asdg";
            pair2.PairValue = "Another string";
            PairOfPerson pair3 = new PairOfPerson();
            pair3.P1 = people[1];
            pair3.P2 = people[2];
            var pair4 = new GenericPair<int, string>();
            pair4.O1 = 4;
            pair4.O2 = "Kiwi";
            var pair5 = new GenericPair<string, string>();
            pair5.O1 = "car";
            pair5.O2 = "ferarri";
            var pair6 = new GenericPair<Person, GenericPair<int, string>>();
            Dictionary<int, Dictionary<string, string>> pair7 = new Dictionary<int, Dictionary<string, string>>();
            Dictionary<string, string> pair8 = new Dictionary<string, string>();
            pair7.Add(1, pair8);

            //using (var sw = new StreamWriter(@"C:\exports\ModifiedServicemembers.dat"))
            //{
            //    foreach (var p in people)
            //    {
            //        if (p is Servicemember)
            //        {
            //            await sw.WriteLineAsync(p.ToPipeDelimitedString());
            //        }
            //    }
            //}

            using (var sw = new StreamWriter(@"C:\exports\JsonServiceMembers.dat"))
            {
                foreach (var p in people)
                {
                    if (p is Servicemember)
                    {
                        await sw.WriteLineAsync(p.ToJSON());
                    }
                }
            }

            var serviceMembers = new List<Servicemember>();
            foreach (string line in System.IO.File.ReadLines(@"C:\exports\JsonServiceMembers.dat"))
            {
                var result = Servicemember.FromJSON(line);
                serviceMembers.Add(result);
            }

            foreach (var s in serviceMembers)
            {
                Console.WriteLine(s);
            }

            string path = @"C:\exports\JsonData";
            File.WriteAllText(path, JsonConvert.SerializeObject(serviceMembers));

            var text = File.ReadAllText(path);
            var newPeople = JsonConvert.DeserializeObject<List<Servicemember>>(text);

            foreach (var p in newPeople)
            {
                Console.WriteLine($"Next service Member: {p}");
            }


            //simple, not very good?
            File.Encrypt(path);

            //encrypt, but not able to decrypt:
            string path2 = @"C:\exports\JsonDataEncrypted";
            string data = JsonConvert.SerializeObject(serviceMembers);
            var dBytes = Encoding.ASCII.GetBytes(data);
            var hash = SHA256.Create().ComputeHash(dBytes);
            var output = Convert.ToBase64String(hash);
            File.WriteAllText(path2, output);

        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
