using Microsoft.Extensions.Configuration;
using MovieDataModels;
using System.Data;

namespace WorkingWithADatabaseUsingADONet
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            var cnstr = _configuration["Database:ConnectionString"];
            Console.WriteLine($"Configuration: {cnstr}");

            //getall
            var di = new DatabaseInterop(cnstr);

            var allMovies = Movie.GetMoviesFromDataset(di.GetAllByProcedure());

            foreach (var movie in allMovies)
            {
                Console.WriteLine(movie);
            }
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
