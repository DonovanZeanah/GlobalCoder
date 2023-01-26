using ContactWebModels;
using MyContactManagerRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerServices
{
  public class ContactsService : IContactsService
  {
    private IContactsRepository _repository;

    public ContactsService(IContactsRepository repository)
    {
      _repository = repository;
    }

    public async Task<List<Contact>> GetAllAsync(string userId)
    {
      var data = await _repository.GetAllAsync(userId);
      return data;
    }

    public async Task<Contact?> GetAsync(int id, string userId)
    {
      return await _repository.GetAsync(id, userId);
    }

    public async Task<int> AddOrUpdateAsync(Contact c, string userId)
    {
      return await _repository.AddOrUpdateAsync(c, userId);
    }

    public async Task<int> DeleteAsync(Contact c, string userId)
    {
      return await _repository.DeleteAsync(c, userId);
    }

    public async Task<int> DeleteAsync(int id, string userId)
    {
      return await _repository.DeleteAsync(id, userId);
    }

    public async Task<bool> ExistsAsync(int id, string userId)
    {
      return await _repository.ExistsAsync(id, userId);
    }
  }
}
