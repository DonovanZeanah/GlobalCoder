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
  public class CategoriesRepository : ICategoriesRepository
  {
    private readonly MyContactManagerDbContext _context;

    public CategoriesRepository(MyContactManagerDbContext context)
    {
      _context = context;
    }

    public Task<int> AddOrUpdateAsync(Category category)
    {
      throw new NotImplementedException();
    }

    public Task<int> DeleteAsync(int id)
    {
      throw new NotImplementedException();
    }

    public Task<int> DeleteAsync(Category category)
    {
      throw new NotImplementedException();
    }

    public Task<bool> ExistsAsync(int id)
    {
      throw new NotImplementedException();
    }

    public Task<List<Category>> GetAllAsync()
    {
      throw new NotImplementedException();
    }

    public Task<Category> GetAsync(int id)
    {
      throw new NotImplementedException();
    }
  }
}
