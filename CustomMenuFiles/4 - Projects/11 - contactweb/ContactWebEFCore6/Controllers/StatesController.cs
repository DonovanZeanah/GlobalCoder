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
  //only person that can access states are Admin User Roles
  [Authorize(Roles = "Admin, SuperAdmin")]
  public class StatesController : Controller
  {
    private readonly IMemoryCache _cache;
    private IStatesService _statesService;

    //public StatesController(MyContactManagerDbContext context, IMemoryCache cache)
    public StatesController(IStatesService statesService, IMemoryCache cache)

    {
      _statesService = statesService;
      _cache = cache;
    }

    // GET: States
    public async Task<IActionResult> Index()
    {
      //List<State> states = await GetStatesFromSession();
      var states = await GetStatesFromCache();
      return View(states);
    }

    private async Task<List<State>> GetStatesFromSession()
    {
      var session = HttpContext.Session;
      var statesData = session.GetString(ContactCacheConstants.ALL_STATES_DATA_SESSION);
      if (!string.IsNullOrWhiteSpace(statesData))
      {
        return JsonConvert.DeserializeObject<List<State>>(statesData);
      }

      var states = await _statesService.GetAllAsync();
      session.SetString("StatesData", JsonConvert.SerializeObject(states));
      return states;
    }

    private async Task<List<State>> GetStatesFromCache()
    {
      var states = new List<State>();
      if (!_cache.TryGetValue(ContactCacheConstants.ALL_STATES_DATA, out states))
      {
        var allStatesData = await _statesService.GetAllAsync();

        _cache.Set(ContactCacheConstants.ALL_STATES_DATA, allStatesData, TimeSpan.FromDays(1));
        return allStatesData;
      }
      return states;
    }

    // GET: States/Details/5
    public async Task<IActionResult> Details(int? id)
    {
      if (id == null || await _statesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var state = await _statesService.GetAsync((int)id);
      if (state == null)
      {
        return NotFound();
      }

      return View(state);
    }

    // GET: States/Create
    public IActionResult Create()
    {
      return View();
    }

    // POST: States/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Id,Name,Abbreviation")] State state)
    {
      if (ModelState.IsValid)
      {
        await _statesService.AddOrUpdateAsync(state);
        _cache.Remove(ContactCacheConstants.ALL_STATES_DATA);
        return RedirectToAction(nameof(Index));
      }
      return View(state);
    }

    // GET: States/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
      if (id == null || await _statesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var state = await _statesService.GetAsync((int)id);
      if (state == null)
      {
        return NotFound();
      }
      return View(state);
    }

    // POST: States/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name,Abbreviation")] State state)
    {
      if (id != state.Id)
      {
        return NotFound();
      }

      if (ModelState.IsValid)
      {
        try
        {
          await _statesService.AddOrUpdateAsync(state);
          _cache.Remove(ContactCacheConstants.ALL_STATES_DATA);
        }
        catch (DbUpdateConcurrencyException)
        {
          if (!StateExists(state.Id))
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
      return View(state);
    }

    // GET: States/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
      if (id == null || await _statesService.GetAllAsync() == null)
      {
        return NotFound();
      }

      var state = await _statesService.GetAsync((int)id);
      if (state == null)
      {
        return NotFound();
      }

      return View(state);
    }

    // POST: States/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
      if (await _statesService.GetAllAsync() == null)
      {
        return Problem("Entity set 'MyContactManagerDbContext.States'  is null.");
      }
      await _statesService.DeleteAsync(id);

      //var state = await _statesService.GetAsync(id);
      //if (state != null)
      //{
      //    await _statesService.DeleteAsync(id);
      //}

      _cache.Remove(ContactCacheConstants.ALL_STATES_DATA);
      return RedirectToAction(nameof(Index));
    }

    private bool StateExists(int id)
    {
      return Task.Run(async () => await _statesService.ExistsAsync(id)).Result;
    }
  }
}