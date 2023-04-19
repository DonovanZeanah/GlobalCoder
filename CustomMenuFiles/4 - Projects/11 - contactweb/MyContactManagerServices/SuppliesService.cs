using ContactWebModels;
using Microsoft.EntityFrameworkCore;
using MyContactManagerRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerServices
{
  public class SuppliesService : ISuppliesService
  {
    private ISuppliesRepository _repository;
    public SuppliesService(ISuppliesRepository repository)
    {
      _repository = repository;
    }



    public async Task<List<Supply>> GetAllAsync(string userId)
    {
      var data = await _repository.GetAllAsync(userId);
      return data;
    }

    public async Task<Supply?> GetAsync(int id, string userId)
    {
      return await _repository.GetAsync(id, userId);

    }
    public async Task<int> AddOrUpdateAsync(Supply s, string userId)
    {
      return await _repository.AddOrUpdateAsync(s, userId);
    }

    public async Task<int> DeleteAsync(Supply s, string userId)
    {
      return await _repository.DeleteAsync(s, userId);
    }

    public async Task<int> DeleteAsync(int id, string userId)
    {
      return await _repository.DeleteAsync(id, userId);
    }

    public Task<bool> ExistsAsync(int id, string userId)
    {
      throw new NotImplementedException();
    }

    public Task<bool> IsStockLow(int id, string userId)
    {
      throw new NotImplementedException();
    }
  }
}



