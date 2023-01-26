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
  [Authorize(Roles = "Admin, SuperAdmin")]

  public class CategoriesController : Controller
    {
    private readonly IMemoryCache _cache;
    private ICategoriesService _categoriesService;

    public CategoriesController(ICategoriesService categoriesService, IMemoryCache cache)
    {
      _categoriesService = categoriesService;
      _cache = cache;
    }

    public async Task<IActionResult> Index()
    {
      //List<Category> categories = await GetCategoriesFromSession();
      var categories = await GetCategoriesFromCache();
      return View(categories);
    }

    private async Task<List<Category>> GetCategoriesFromSession()
    {
      var session = HttpContext.Session;
      var categoriesData = session.GetString(ContactCacheConstants.ALL_CATEGORIES_DATA_SESSION);
      if (!string.IsNullOrWhiteSpace(categoriesData))
      {
        return JsonConvert.DeserializeObject<List<Category>>(categoriesData);
      }

      var categories = await _categoriesService.GetAllAsync();
      session.SetString("CategoriesData", JsonConvert.SerializeObject(categories));
      return categories;
    }

    private async Task<List<Category>> GetCategoriesFromCache()
    {
      var categories = new List<Category>();
      if (!_cache.TryGetValue(ContactCacheConstants.ALL_CATEGORIES_DATA, out categories))
      {
        var allCategoriesData = await _categoriesService.GetAllAsync();

        _cache.Set(ContactCacheConstants.ALL_CATEGORIES_DATA, allCategoriesData, TimeSpan.FromDays(1));
        return allCategoriesData;
      }
      return categories;
    }

    // GET: Categories/Details/5
    public async Task<IActionResult> Details(int? id)
    {
      if (id == null || await _categoriesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var category = await _categoriesService.GetAsync((int)id);
      if (category == null)
      {
        return NotFound();
      }

      return View(category);
    }

    // GET: Categories/Create
    public IActionResult Create()
    {
      return View();
    }

    // POST: Categories/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Id,Name")] Category category)
    {
      if (ModelState.IsValid)
      {
        await _categoriesService.AddOrUpdateAsync(category);
        _cache.Remove(ContactCacheConstants.ALL_CATEGORIES_DATA);
        return RedirectToAction(nameof(Index));
      }
      return View(category);
    }

    // GET: Categories/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
      if (id == null || await _categoriesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var category = await _categoriesService.GetAsync((int)id);
      if (category == null)
      {
        return NotFound();
      }
      return View(category);
    }

    // POST: Categories/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name,Abbreviation")] Category category)
    {
      if (id != category.Id)
      {
        return NotFound();
      }

      if (ModelState.IsValid)
      {
        try
        {
          await _categoriesService.AddOrUpdateAsync(category);
          _cache.Remove(ContactCacheConstants.ALL_CATEGORIES_DATA);
        }
        catch (DbUpdateConcurrencyException)
        {
          if (!CategoryExists(category.Id))
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
      return View(category);
    }

    // GET: Categories/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
      if (id == null || await _categoriesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var category = await _categoriesService.GetAsync((int)id);
      if (category == null)
      {
        return NotFound();
      }

      return View(category);
    }

    // POST: Categories/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
      if (await _categoriesService.GetAllAsync() == null)
      {
        return Problem("Entity set 'MyContactManagerDbContext.Categories'  is null.");
      }
      await _categoriesService.DeleteAsync(id);

      //var category = await _categoriesService.GetAsync(id);
      //if (category != null)
      //{
      //    await _categoriesService.DeleteAsync(id);
      //}

      _cache.Remove(ContactCacheConstants.ALL_CATEGORIES_DATA);
      return RedirectToAction(nameof(Index));
    }

    private bool CategoryExists(int id)
    {
      return Task.Run(async () => await _categoriesService.ExistsAsync(id)).Result;
    }
  }
}
