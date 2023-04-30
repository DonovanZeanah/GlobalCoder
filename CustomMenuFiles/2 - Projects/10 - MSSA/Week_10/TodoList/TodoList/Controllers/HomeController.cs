using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Diagnostics;
using TodoList.Data;
using TodoList.Models;
using TodoListData;
using TodoListModels;

namespace TodoList.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IUserRolesService _userRoleService;
        private readonly IConfigurationRoot _configuration;
        private ApplicationDbContext _appDbContext;
        private TodoListDataContext _todoDbContext;

        public HomeController(ILogger<HomeController> logger, IUserRolesService userRolesService,
                                ApplicationDbContext applicationDbContext, 
                                TodoListDataContext todoDbContext)
        {
            _logger = logger;
            _userRoleService = userRolesService;
            _appDbContext= applicationDbContext;
            _todoDbContext= todoDbContext;
        }

        public IActionResult Index()
        {
            _logger.Log(LogLevel.Information, "It's working");
            return View();
        }

        public IActionResult DisplaySecret(string hash)
        {
            if (string.IsNullOrWhiteSpace(hash))
            {
                ViewBag.Secret = "You don't get to see the secret!";
                ViewData["Secret2"] = "You don't get to see the secret!";
            }
            else if (hash.Equals("brown"))
            {
                ViewBag.Secret = "It's a ViewBag secret";
                ViewData["Secret2"] = "It's a viewdata secret";
            }
            else
            {
                ViewBag.Secret = "You don't get to see the secret!";
                ViewData["Secret2"] = "You don't get to see the secret!";
            }
            
            return View();
        }

        public async Task<IActionResult> EnsureRolesAndUsers()
        { 
            await _userRoleService.EnsureAdminUserRole();
            return RedirectToAction("Index");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult MyFavoriteState()
        {
            var s = new State();
            s.Abbreviation = "IA";
            s.Name = "Iowa";
            s.Id = 16;

            return View(s);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}