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

namespace SupplyWebEFCore6.Controllers
{
    public class SuppliesController : Controller
    {
    private readonly ISuppliesService _suppliesService;
    private readonly ICategoriesService _categoriesService;
    private static List<Category> _allCategories;
    private static SelectList _categoriesData;

    public SuppliesController(ISuppliesService suppliesService, ICategoriesService categoriesService)
    {
      _suppliesService = suppliesService;
      _categoriesService = categoriesService;
      _allCategories = Task.Run(async () => await _categoriesService.GetAllAsync()).Result;
      _categoriesData = new SelectList(_allCategories, "Id", "Name");
      _categoriesService = categoriesService;
    }

    private async Task UpdateCategoriesAndResetModelCategories(Supply supply)
    {
      ModelState.Clear();
      var category = _allCategories.SingleOrDefault(x => x.Id == supply.CategoryId);
      supply.Category = category;
      TryValidateModel(supply);
    }

    protected async Task<string> GetCurrentUserId()
    {
      var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
      return userId;
    }


    // GET: Supplies
    public async Task<IActionResult> Index()
    {
      var supplies = await _suppliesService.GetAllAsync(await GetCurrentUserId());
      return View(supplies);
    }

    // GET: Supplies/Details/5
    public async Task<IActionResult> Details(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _suppliesService.GetAllAsync(userId) == null)
      {
        return NotFound();
      }

      var supply = await _suppliesService.GetAsync((int)id, userId);
      if (supply == null)
      {
        return NotFound();
      }

      return View(supply);
    }

    // GET: Supplies/Create
    public IActionResult Create()
    {
      //ViewData["CategoriesId"] = new SelectList(_context.Categories, "Id", "Abbreviation");
      ViewData["CategoryId"] = _categoriesData;
      return View();
    }

    // POST: Supplies/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Id,Name,CategoryId")] Supply supply)
    {
      var userId = await GetCurrentUserId();
      supply.UserId = userId;
      UpdateCategoriesAndResetModelCategories(supply);
      if (ModelState.IsValid)
      {
        await _suppliesService.AddOrUpdateAsync(supply, await GetCurrentUserId());
        return RedirectToAction(nameof(Index));
      }
      //ViewData["CategoriesId"] = new SelectList(_context.Categories, "Id", "Abbreviation", supply.CategoriesId);
      ViewData["CategoryId"] = _categoriesData;
      return View(supply);
    }

    // GET: Supplies/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _suppliesService.GetAllAsync(await GetCurrentUserId()) == null)
      {
        return NotFound();
      }

      var supply = await _suppliesService.GetAsync((int)id, userId);
      if (supply == null)
      {
        return NotFound();
      }
      //ViewData["CategoriesId"] = new SelectList(_context.Categories, "Id", "Abbreviation", supply.CategoriesId);
      ViewData["CategoryId"] = _categoriesData;
      return View(supply);
    }

    // POST: Supplies/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name,CategoryId")] Supply supply)
    {
      if (id != supply.Id)
      {
        return NotFound();
      }
      var userId = await GetCurrentUserId();
      supply.UserId = userId;
      UpdateCategoriesAndResetModelCategories(supply);
      if (ModelState.IsValid)
      {
        try
        {
          await _suppliesService.AddOrUpdateAsync(supply, await GetCurrentUserId());
        }
        catch (DbUpdateConcurrencyException)
        {
          if (!SupplyExists(supply.Id))
          {
            return NotFound();
          }
          else
          {
            throw;
          }
        }
        return RedirectToAction(nameof(Index));
      }
      //ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Abbreviation", supply.CategoryId);
      ViewData["CategoryId"] = _categoriesData;
      return View(supply);
    }

    // GET: Supplies/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _suppliesService.GetAllAsync(userId) == null)
      {
        return NotFound();
      }

      var supply = await _suppliesService.GetAsync((int)id, userId);
      if (supply == null)
      {
        return NotFound();
      }

      return View(supply);
    }

    // POST: Supplies/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
      var userId = await GetCurrentUserId();
      if (await _suppliesService.GetAllAsync(userId) == null)
      {
        return Problem("Entity set 'MySupplyManagerDbContext.Supplies'  is null.");
      }
      var supply = await _suppliesService.GetAsync(id, userId);
      if (supply != null)
      {
        await _suppliesService.DeleteAsync(supply, userId);
      }
      return RedirectToAction(nameof(Index));
    }

    private bool SupplyExists(int id)
    {
      return Task.Run(async () => await _suppliesService.ExistsAsync(id, await GetCurrentUserId())).Result;
    }
  }
}
