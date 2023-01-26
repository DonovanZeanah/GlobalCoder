using ContactWebModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerServices
{
  public interface IContactsService
  {
    Task<List<Contact>> GetAllAsync(string userId);
    Task<Contact> GetAsync(int id, string userId);
    Task<int> AddOrUpdateAsync(Contact state, string userId);
    Task<int> DeleteAsync(int id, string userId);
    Task<int> DeleteAsync(Contact state, string userId);
    Task<bool> ExistsAsync(int id, string userId);
  }
}
