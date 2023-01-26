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
  public class ContactsController : Controller
  {
    private readonly IContactsService _contactsService;
    private readonly IStatesService _statesService;
    private static List<State> _allStates;
    private static SelectList _statesData;

    public ContactsController(IContactsService contactsService, IStatesService statesService)
    {
      _contactsService = contactsService;
      _statesService = statesService;
      _allStates = Task.Run(async () => await _statesService.GetAllAsync()).Result;
      _statesData = new SelectList(_allStates, "Id", "Abbreviation");
      _statesService = statesService;
    }

    private async Task UpdateStateAndResetModelState(Contact contact)
    {
      ModelState.Clear();
      var state = _allStates.SingleOrDefault(x => x.Id == contact.StateId);
      contact.State = state;
      TryValidateModel(contact);
    }

    protected async Task<string> GetCurrentUserId()
    {
      var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
      return userId;
    }


    // GET: Contacts
    public async Task<IActionResult> Index()
    {
      var contacts = await _contactsService.GetAllAsync(await GetCurrentUserId());
      return View(contacts);
    }

    // GET: Contacts/Details/5
    public async Task<IActionResult> Details(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _contactsService.GetAllAsync(userId) == null)
      {
        return NotFound();
      }

      var contact = await _contactsService.GetAsync((int)id, userId);
      if (contact == null)
      {
        return NotFound();
      }

      return View(contact);
    }

    // GET: Contacts/Create
    public IActionResult Create()
    {
      //ViewData["StateId"] = new SelectList(_context.States, "Id", "Abbreviation");
      ViewData["StateId"] = _statesData;
      return View();
    }

    // POST: Contacts/Create
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Id,FirstName,LastName,Email,PhonePrimary,PhoneSecondary,Birthday,StreetAddress1,StreetAddress2,City,StateId,Zip")] Contact contact)
    {
      var userId = await GetCurrentUserId();
      contact.UserId = userId;
      UpdateStateAndResetModelState(contact);
      if (ModelState.IsValid)
      {
        await _contactsService.AddOrUpdateAsync(contact, await GetCurrentUserId());
        return RedirectToAction(nameof(Index));
      }
      //ViewData["StateId"] = new SelectList(_context.States, "Id", "Abbreviation", contact.StateId);
      ViewData["StateId"] = _statesData;
      return View(contact);
    }

    // GET: Contacts/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _contactsService.GetAllAsync(await GetCurrentUserId()) == null)
      {
        return NotFound();
      }

      var contact = await _contactsService.GetAsync((int)id, userId);
      if (contact == null)
      {
        return NotFound();
      }
      //ViewData["StateId"] = new SelectList(_context.States, "Id", "Abbreviation", contact.StateId);
      ViewData["StateId"] = _statesData;
      return View(contact);
    }

    // POST: Contacts/Edit/5
    // To protect from overposting attacks, enable the specific properties you want to bind to.
    // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,FirstName,LastName,Email,PhonePrimary,PhoneSecondary,Birthday,StreetAddress1,StreetAddress2,City,StateId,Zip")] Contact contact)
    {
      if (id != contact.Id)
      {
        return NotFound();
      }
      var userId = await GetCurrentUserId();
      contact.UserId = userId;
      UpdateStateAndResetModelState(contact);
      if (ModelState.IsValid)
      {
        try
        {
          await _contactsService.AddOrUpdateAsync(contact, await GetCurrentUserId());
        }
        catch (DbUpdateConcurrencyException)
        {
          if (!ContactExists(contact.Id))
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
      //ViewData["StateId"] = new SelectList(_context.States, "Id", "Abbreviation", contact.StateId);
      ViewData["StateId"] = _statesData;
      return View(contact);
    }

    // GET: Contacts/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
      var userId = await GetCurrentUserId();
      if (id == null || await _contactsService.GetAllAsync(userId) == null)
      {
        return NotFound();
      }

      var contact = await _contactsService.GetAsync((int)id, userId);
      if (contact == null)
      {
        return NotFound();
      }

      return View(contact);
    }

    // POST: Contacts/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
      var userId = await GetCurrentUserId();
      if (await _contactsService.GetAllAsync(userId) == null)
      {
        return Problem("Entity set 'MyContactManagerDbContext.Contacts'  is null.");
      }
      var contact = await _contactsService.GetAsync(id, userId);
      if (contact != null)
      {
        await _contactsService.DeleteAsync(contact, userId);
      }
      return RedirectToAction(nameof(Index));
    }

    private bool ContactExists(int id)
    {
      return Task.Run(async () => await _contactsService.ExistsAsync(id, await GetCurrentUserId())).Result;
    }
  }
}
