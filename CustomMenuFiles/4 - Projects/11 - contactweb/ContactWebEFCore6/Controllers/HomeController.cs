using ContactWebEFCore6.Data;
using ContactWebEFCore6.Models;
using ContactWebModels.Data;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace ContactWebEFCore6.Controllers
{
  public class HomeController : Controller
  {
    private readonly ILogger<HomeController> _logger;
    private readonly IUserRolesService _userRolesService;

    public HomeController(ILogger<HomeController> logger, IUserRolesService userRolesService)
    {
      _logger = logger;
      _userRolesService = userRolesService;
    }

    public IActionResult Index()
    {
      return View();
    }

    public IActionResult Privacy()
    {
      return View();
    }

    public async Task<IActionResult> EnsureAdminSuperUser()
    {
      await _userRolesService.EnsureSuperUser();
      return RedirectToAction("Index");
    }


    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
      return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
  }
}