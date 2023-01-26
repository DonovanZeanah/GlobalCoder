using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SchoolOfFineArtsDB;
using System.Configuration;
using System.Drawing;

namespace SchoolOfFineArts
{
    public static class Program
    {
        public static IConfigurationRoot _configuration;
        //bad form:
        //public static SchoolOfFineArtsDBContext _context;
        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void Main()
        {
            // To customize application configuration such as set high DPI settings or default font,
            // see https://aka.ms/applicationconfiguration.
            ApplicationConfiguration.Initialize();
            var builder = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            _configuration = builder.Build();

            //bad form:
            //var cnstr = Program._configuration["ConnectionStrings:SchoolOfFineArtsDB"];
            //var options = new DbContextOptionsBuilder<SchoolOfFineArtsDBContext>().UseSqlServer(cnstr);
            //_context = new SchoolOfFineArtsDBContext(options.Options);

            Application.Run(new Form1());
        }
    }
}