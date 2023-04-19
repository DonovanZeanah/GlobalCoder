using ContactWebModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerServices
{
    public interface ISuppliesService
    {
    Task<List<Supply>> GetAllAsync(string userId);
    Task<Supply> GetAsync(int id, string userId);
    Task<int> AddOrUpdateAsync(Supply category, string userId);
    Task<int> DeleteAsync(int id, string userId);
    Task<int> DeleteAsync(Supply category, string userId);
    Task<bool> ExistsAsync(int id, string userId);
    Task<bool> IsStockLow(int id, string userId);



  }
}