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
  public class SuppliesRepository : ISuppliesRepository
  {
    private readonly MyContactManagerDbContext _context;
    //private object itemId;

    public SuppliesRepository(MyContactManagerDbContext context)
    {
      _context = context;
    }

    public async Task<List<Supply>> GetAllAsync(string userId)
    {
      var supplies = await _context.Supplies
                      .Include(x => x.Category)
                      .AsNoTracking()
                      .Where(x => x.UserId.ToUpper() == userId.ToUpper())
                      .OrderBy(x => x.Name)
                      .ToListAsync();
      return supplies;
    }

    public async Task<Supply> GetAsync(int id, string userId)
    {
      var supply = await _context.Supplies
                              .Include(x => x.Category)
                              .AsNoTracking()
                              .SingleOrDefaultAsync(x => x.Id == id && x.UserId == userId);
      return supply;
    }

    public async Task<int> AddorUpdateAsync(Supply s, string userId)
    {
      if (s.Quantity > 0)
      {
        return await Update(s, userId);
      }
      return await Insert(s, userId);
    }

    private async Task GetExistingCategoryReference(Supply supply)
    {
      var existingCategory = await _context.Categories.SingleOrDefaultAsync(x => x.Id == supply.CategoryId);
     // if (existingCategory is not null)
      if (existingCategory != null)
      {
        supply.Category = existingCategory;
      }
    }


    private async Task<int> Insert(Supply s, string userId)
    {
      await GetExistingCategoryReference(s);
      await _context.Supplies.AddAsync(s);
      await _context.SaveChangesAsync();
      return s.Id;
    }

    private async Task<int> Update(Supply s, string userId)
    {
      var existing = await _context.Supplies.SingleOrDefaultAsync(x => x.Id == s.Id && x.UserId == userId);
      if (existing is null) throw new Exception("Supply not found");

      existing.Name = s.Name;
      existing.CategoryId = s.CategoryId;
      existing.Price = s.Price;
      existing.Quantity = s.Quantity;
      existing.Sources = s.Sources;
      //existing.Sources = s.Sources;

      //existing.
      //existing.UserId = c.UserId;

      await _context.SaveChangesAsync();
      return existing.Id;
    }

    public async Task<int> DeleteAsync(Supply s, string userId)
    {
      return await DeleteAsync(s.Id, userId);
    }

    public async Task<int> DeleteAsync(int id, string userId)
    {
      var existingSupply = await _context.Supplies.SingleOrDefaultAsync(x => x.Id == id && x.UserId == userId);
      if (existingSupply is null) throw new Exception("Could not delete supply due to unable to find matching supply");

      _context.Supplies.Remove(existingSupply);
      await _context.SaveChangesAsync();
      return id;
    }
    public async Task<bool> ExistsAsync(int id, string userId)
    {
      return await _context.Contacts.AsNoTracking().AnyAsync(x => x.Id == id && x.UserId == userId);
    }

    public async Task<bool> isStockLow(int id, string userId)
    {
      var existingSupply = await _context.Supplies.SingleOrDefaultAsync(x => x.Id == id && x.UserId == userId);
      if (existingSupply.Quantity < 10)
      {
        return true;
      }
      return false;

    }

    public Task<int> AddOrUpdateAsync(Supply s, string userId)
    {
      throw new NotImplementedException();
    }

    public Task<bool> IsStockLow(int id, string userId)
    {
      throw new NotImplementedException();
    }
  }
}

   /* public Task<int> AddAsync(Supply s, string categoryId, int quantity)
    {
      throw new NotImplementedException();
    }

    public Task<int> SubtractAsync(Supply s, string categoryId, int quantity)
    {
      throw new NotImplementedException();
    }

    public Task<bool> IsStockLow(int id, int quantity)
    {
      throw new NotImplementedException();
    }

    public Task<int> AddOrUpdateAsync(Supply s, string categoryId, int quantity)
    {
      throw new NotImplementedException();
    }

    public Task<int> DeleteAsync(Contact state, string userId)
    {
      throw new NotImplementedException();
    }

    public Task<bool> IsStockLow(int id, string userId)
    {
      throw new NotImplementedException();
    }
  }
}*/
/*

Task<Supply> ISuppliesRepository.GetAsync(int id, string itemId)
{
throw new NotImplementedException();
}

public Task<int> Add(Supply itemId, string categoryId, int quantity)
{
throw new NotImplementedException();
}

public Task<int> Subtract(Supply itemId, string categoryId, int quantity)
{
throw new NotImplementedException();
}

public Task<bool> IsStockLow(int id, string itemId)
{
throw new NotImplementedException();
}

public Task<int> SubtractAsync(Supply itemId, string categoryId, int quantity)
{
throw new NotImplementedException();
}

public Task<int> AddAsync(Supply s, string categoryId, int quantity)
{
throw new NotImplementedException();
}
}*/

