using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ContactWebModels;
using MyContactManagerData;
using Newtonsoft.Json;
using Microsoft.Extensions.Caching.Memory;
using ContactWebEFCore6.Models;
using MyContactManagerServices;
using Microsoft.AspNetCore.Authorization;

namespace ContactWebEFCore6.Controllers
{
  [Authorize(Roles = "SuperAdmin")]
  public class CategorysController : Controller
  {
    private readonly IMemoryCache _cache;
    private ICategorysService _categorysService;
    //    private readonly MyContactManagerDbContext _context;


    public CategorysController(MyContactManagerDbContext context, IMemoryCache cache, ICategorysService categorysService)
    {
      var _context = context;
      var _cache = cache;
      var _categorysService = categorysService;
    }

    // GET: Categorys
    public async Task<IActionResult> Index()
    {
      var categorys = await _categorysService.GetAllAsync();
      return View(categorys);
    }

    // GET: Categorys/Details/5
    public async Task<IActionResult> Details(int? id)
    {
      if (id == null)
      {
        return NotFound();
      }

      var category = await _categorysService.GetByIdAsync(id.Value);
      if (category == null)
      {
        return NotFound();
      }

      return View(category);
    }

    // GET: Categorys/Create
    public IActionResult Create()
    {
      return View();
    }

    // POST: Categorys/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to, for 
    // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Id,Name")] Category category)
    {
      if (ModelState.IsValid)
      {
        await _categorysService.AddAsync(category);
        return RedirectToAction(nameof(Index));
      }
      return View(category);
    }

    // GET: Categorys/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
      if (id == null)
      {
        return NotFound();
      }

      var category = await _categorysService.GetByIdAsync(id.Value);
      if (category == null)
      {
        return NotFound();
      }
      return View(category);
    }

    // POST: Categorys/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to, for 
    // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name")] Category category)
    {
      if (id != category.Id)
      {
        return NotFound();
      }

      if (ModelState.IsValid)
      {
        {
        }
      }
    }
  }
}
