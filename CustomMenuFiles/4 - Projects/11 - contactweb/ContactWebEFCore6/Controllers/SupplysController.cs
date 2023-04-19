using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ContactWebModels;
using MyContactManagerData;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using MyContactManagerServices;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace ContactWebEFCore6.Controllers
{
  [Authorize]
    public class SupplysController : Controller
    {

    private readonly ISupplysService _supplyService;

    public SupplysController(ISupplysService supplysService)
    {
      
    }


    public IActionResult Index()
        {
            return View();
        }
    }
}


