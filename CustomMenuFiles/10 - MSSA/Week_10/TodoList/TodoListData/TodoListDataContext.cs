using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using TodoListModels;

namespace TodoListData
{
    public class TodoListDataContext : DbContext
    {
        private static IConfigurationRoot _configuration;

        public DbSet<TodoListItem> ToDoItems { get; set; }
        //no state  => state not in database.

        public TodoListDataContext()
        {
            //leave this here for scaffolding, etc
            //this.ChangeTracker.LazyLoadingEnabled = false;
        }

        public TodoListDataContext(DbContextOptions options) 
            : base(options) 
        {
            //Note: I think adding base(options) is going to break something 
            //purposefully blank
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var builder = new ConfigurationBuilder()
                                .SetBasePath(Directory.GetCurrentDirectory())
                                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
                _configuration = builder.Build();
                var cnstr = _configuration.GetConnectionString("TodoListDatabaseConnection");
                optionsBuilder.UseSqlServer(cnstr);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //fluent api
            //seed data here

            //build additional relationships and such
        }
    }
}