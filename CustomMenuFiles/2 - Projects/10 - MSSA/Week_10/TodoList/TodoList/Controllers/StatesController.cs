using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TodoList.Data;
using TodoListModels;

namespace TodoList.Controllers
{
    [Authorize(Roles = "Admin")]
    public class StatesController : Controller
    {
        public IActionResult Index()
        {
            var theStates = new List<State>() { 
                new State() { Id = 1, Name = "Alabama", Abbreviation = "AL"},
                new State() { Id = 2, Name = "Illinois", Abbreviation = "IL"},
                new State() { Id = 3, Name = "New Jersey", Abbreviation = "NJ"},
                new State() { Id = 4, Name = "Michigan", Abbreviation = "MI"},
                new State() { Id = 5, Name = "North Carolina", Abbreviation = "NC"},
            };

            return View(theStates);
        }

       
    }
}
