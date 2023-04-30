using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;

namespace LiveFileDemo
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            var textFilePath = _configuration["DefaultPath:SimpleTextFile"];
            var anotherTextFile = _configuration["DefaultPath:AnotherTextFile"];
            var jsonTextFile = _configuration["DefaultPath:JsonFilePath"];

            Console.WriteLine(textFilePath);
            
            //single line of text to a file
            FileInterop.WriteTextToFileUsingFileObject("This is my first text file", textFilePath);
            Console.WriteLine($"File is written to {textFilePath}");

            //list of string to text file
            //write to text file
            var sampleText = new List<string>()
            {
                "Hello world!",
                "This is a new list of strings!",
                "One option is to do this in a group of lines",
                "Another is to do this line by line individually",
                "Send just one line with an append boolean to make it happen!"
            };

            FileInterop.WriteTextToFileUsingFileObject(sampleText, textFilePath);
            Console.WriteLine($"File is written (again) to {textFilePath}");

            FileInterop.WriteTextToFile(sampleText, anotherTextFile, false);
            Console.WriteLine($"File is written to {anotherTextFile}");


            //read from text file
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All Lines from text file");
            Console.WriteLine(new string('*', 80));
            var allLines = FileInterop.ReadAllLinesAsListUsingFile(textFilePath);
            foreach (var line in allLines)
            {
                Console.WriteLine(line);
            }
            Console.WriteLine(new string('*', 80));

            //read from text file using a stream
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All Lines from another file");
            Console.WriteLine(new string('*', 80));
            var allStreamLines = FileInterop.ReadAllLinesAsListUsingStream(anotherTextFile);
            foreach (var line in allStreamLines)
            {
                Console.WriteLine(line);
            }
            Console.WriteLine(new string('*', 80));

            var path = "C:\\MSSA_Content\\MSSA_CCAD8_LiveDemos\\Week_02\\LiveFileDemo\\LiveFileDemo\\Output\\textdata.txt";
            var nameData = FileInterop.ReadAllLinesAsListUsingStream(path);
            foreach (var line in nameData)
            {
                Console.WriteLine(line);
                var parts = line.Split('|');
                var person = new Person();
                int id = 0;
                int.TryParse(parts[0], out id);
                person.Id = id;
                person.FirstName = parts[1];
                person.LastName = parts[2];

                //var dataAsJson = person.ToJSON();
            }

            var thePeople = GetPeople();
            var dataString = JsonConvert.SerializeObject(thePeople);

            FileInterop.WriteTextToFileUsingFileObject(dataString, jsonTextFile);

            //restore
            Console.WriteLine(new string('*', 80));
            Console.WriteLine("All data as JSON restored to list:");
            Console.WriteLine(new string('*', 80));

            var jsonString = FileInterop.ReadAllTextUsingFile(jsonTextFile);
            var deserializedPeople = JsonConvert.DeserializeObject<List<Person>>(jsonString);
            foreach (var p in deserializedPeople)
            {
                Console.WriteLine("Person Restored from JSON List");
                Console.WriteLine(p);
            }
        }

        private static List<Person> GetPeople()
        {
            return new List<Person>() {
                new Person(){ Id = 1, FirstName = "Bill", LastName = "Gates" },
                new Person(){ Id = 2, FirstName = "Elon", LastName = "Musk" },
                new Person(){ Id = 3, FirstName = "Steve", LastName = "Jobs" },
                new Person(){ Id = 4, FirstName = "Jack", LastName = "Ma" },
            };
        }

        private static void BuildOptions()
        {
            var builder = new ConfigurationBuilder()
                                .SetBasePath(Directory.GetCurrentDirectory())
                                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            _configuration = builder.Build();
        }

    }

}