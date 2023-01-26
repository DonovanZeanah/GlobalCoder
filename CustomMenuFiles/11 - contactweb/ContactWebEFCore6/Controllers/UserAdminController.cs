using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Net.Mime;
using System.Net;
using ContactWebEFCore6.Data;

namespace ContactWebEFCore6.Controllers
{
    [Authorize(Roles = "SuperAdmin")]
    public class UserAdminController : Controller
    {
        private readonly IUserRolesService _userRolesService;

        public UserAdminController(IUserRolesService userRolesService)
        {
            _userRolesService= userRolesService;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> CreateUser(string password, string passwordConfirmed)
        {
            
            await _userRolesService.CreateUser("email@somwhere.com", "email@somwhere.com", password, "123-456-7890");
            
            Response.StatusCode = (int)HttpStatusCode.OK;
            return Content("USER Created!", MediaTypeNames.Text.Plain);
        }
    }
}
