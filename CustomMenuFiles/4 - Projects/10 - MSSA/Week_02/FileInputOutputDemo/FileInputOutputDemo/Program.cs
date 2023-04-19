using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Runtime.Serialization.Formatters.Binary;

namespace FileInputOutputDemo
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World - File Demos");
            var fi = new FileInterop();

            var simpleTextFilePath = _configuration["DefaultPath:SimpleTextFile"];
            var anotherTextFilePath = _configuration["DefaultPath:AnotherTextFile"];
            var jsonTextFilePath = _configuration["DefaultPath:PeopleJSON"];
            var jsonTextFilePath2 = _configuration["DefaultPath:PeopleListJSON"];
            var binaryFilePath = _configuration["DefaultPath:PeopleListBinary"];

            //write to text file
            var sampleText = new List<string>()
            {
                "Hello world!",
                "This is a new list of strings!",
                "One option is to do this in a group of lines",
                "Another is to do this line by line individually",
                "Send just one line with an append boolean to make it happen!"
            };
            //write it
            fi.WriteTextToFile(sampleText, simpleTextFilePath, false);
            Console.WriteLine("File Written");

            //add another line
            fi.AppendTextToFile("This is another line, appended!", simpleTextFilePath);
            Console.WriteLine("Line appended");

            //another way to write it:
            fi.WriteTextToFileUsingFileObject(sampleText, anotherTextFilePath);

            //read from text file
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All Lines from another file");
            Console.WriteLine(new string('*', 80));
            var allLines = fi.ReadAllLinesAsListUsingFile(anotherTextFilePath);
            foreach (var line in allLines)
            {
                Console.WriteLine(line);
            }
            Console.WriteLine(new string('*', 80));

            //read from text file using a stream
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All Lines from simple file");
            Console.WriteLine(new string('*', 80));
            var allStreamLines = fi.ReadAllLinesAsListUsingStream(simpleTextFilePath);
            foreach (var line in allStreamLines)
            {
                Console.WriteLine(line);
            }
            Console.WriteLine(new string('*', 80));

            var people = GetPeople();
            //write objects as JSON to text file
            var allPeopleJson = new List<string>();
            foreach (var p in people)
            {
                allPeopleJson.Add(p.ToJSON());
            }
            fi.WriteTextToFile(allPeopleJson, jsonTextFilePath, false);

            //read objects as JSON from text file
            var allPeopleBack = fi.ReadAllLinesAsListUsingStream(jsonTextFilePath);
            foreach (var p in allPeopleBack)
            {
                var thePerson = Person.JSONToPerson(p);
                Console.WriteLine("Person Restored!");
                Console.WriteLine(thePerson);
            }

            var serializedPeople = JsonConvert.SerializeObject(people);
            fi.WriteTextToFileUsingFileObject(serializedPeople, jsonTextFilePath2);

            //restore
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All data as JSON restored to list:");
            Console.WriteLine(new string('*', 80));

            var jsonString = fi.ReadAllTextUsingFile(jsonTextFilePath2);
            var deserializedPeople = JsonConvert.DeserializeObject<List<Person>>(jsonString);
            foreach (var p in deserializedPeople)
            {
                Console.WriteLine("Person Restored from JSON List");
                Console.WriteLine(p);
            }

            Console.WriteLine(new string('*', 80));
            Console.WriteLine("Working with binary & serializable");
            Console.WriteLine(new string('*', 80));
            //Use Binary Serialization
            var peopleBytes = fi.GetListAsBytes(people);

            //write to file
            fi.WriteBytesToFile(peopleBytes, binaryFilePath);

            //read from file
            var binaryPeople = fi.ReadBinaryObjectFromFile(binaryFilePath);

            //deserialize bytes to List<T>
            var deserializedBinaryPeople = fi.GetBytesAsList<Person>(binaryPeople);

            foreach (var person in deserializedBinaryPeople)
            {
                Console.WriteLine("Binary data to person restored!");
                Console.WriteLine(person);
            }
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }

        private static List<Person> GetPeople() => new List<Person>()
        {
            new Person(){ Id = 1, FirstName = "Elon", LastName = "Musk" },
            new Person(){ Id = 2, FirstName = "Bill", LastName = "Gates" },
            new Person(){ Id = 3, FirstName = "Steve", LastName = "Jobs" },
            new Person(){ Id = 4, FirstName = "Jeff", LastName = "Bezos" },
            new Person(){ Id = 5, FirstName = "Jack", LastName = "Ma" }
        };
    }
}
