using ContactWebModels;
using Microsoft.EntityFrameworkCore;
using MyContactManagerData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerRepositories
{
  public class ContactsRepository : IContactsRepository
  {
    private readonly MyContactManagerDbContext _context;

    public ContactsRepository(MyContactManagerDbContext context)
    {
      _context = context;
    }

    public async Task<List<Contact>> GetAllAsync(string userId)
    {
      var contacts = await _context.Contacts
                      .Include(x => x.State)
                      .AsNoTracking()
                      .Where(x => x.UserId.ToUpper() == userId.ToUpper())
                      .OrderBy(x => x.LastName)
                      .ToListAsync();
      return contacts;
    }

    public async Task<Contact> GetAsync(int id, string userId)
    {
      var contact = await _context.Contacts
                              .Include(x => x.State)
                              .AsNoTracking()
                              .SingleOrDefaultAsync(x => x.Id == id && x.UserId == userId);
      return contact;
    }

    public async Task<int> AddOrUpdateAsync(Contact c, string userId)
    {
      if (c.Id > 0)
      {
        return await Update(c, userId);
      }
      return await Insert(c, userId);
    }

    private async Task GetExistingStateReference(Contact contact)
    {
      var existingState = await _context.States.SingleOrDefaultAsync(x => x.Id == contact.StateId);
      if (existingState is not null)
      {
        contact.State = existingState;
      }
    }



    
    private async Task<int> Insert(Contact c, string userId)
    {
      await GetExistingStateReference(c);
      await _context.Contacts.AddAsync(c);
      await _context.SaveChangesAsync();
      return c.Id;
    }

    private async Task<int> Update(Contact c, string userId)
    {
      var existing = await _context.Contacts.SingleOrDefaultAsync(x => x.Id == c.Id && x.UserId == userId);
      if (existing is null) throw new Exception("Contact not found");

      existing.FirstName = c.FirstName;
      existing.LastName = c.LastName;
      existing.Email = c.Email;
      existing.Birthday = c.Birthday;
      existing.PhonePrimary = c.PhonePrimary;
      existing.PhoneSecondary = c.PhoneSecondary;
      existing.StreetAddress1 = c.StreetAddress1;
      existing.StreetAddress2 = c.StreetAddress2;
      existing.StateId = c.StateId;
      existing.Zip = c.Zip;
      //existing.UserId = c.UserId;

      await _context.SaveChangesAsync();
      return existing.Id;
    }

    public async Task<int> DeleteAsync(Contact c, string userId)
    {
      return await DeleteAsync(c.Id, userId);
    }

    public async Task<int> DeleteAsync(int id, string userId)
    {
      var existingContact = await _context.Contacts.SingleOrDefaultAsync(x => x.Id == id && x.UserId == userId);
      if (existingContact is null) throw new Exception("Could not delete contact due to unable to find matching contact");

      _context.Contacts.Remove(existingContact);
      await _context.SaveChangesAsync();
      return id;
    }

    public async Task<bool> ExistsAsync(int id, string userId)
    {
      return await _context.Contacts.AsNoTracking().AnyAsync(x => x.Id == id && x.UserId == userId);
    }
  }
}
