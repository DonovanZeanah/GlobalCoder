using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ContactWebModels;
using MyContactManagerRepositories;

namespace MyContactManagerServices
{
  public class CategoriesService : ICategoriesService
  {
    private readonly ICategoriesRepository _categoriesRepository;

    public CategoriesService(ICategoriesRepository categoriesRepository)
    {
      _categoriesRepository = categoriesRepository;
    }

    public async Task<List<Category>> GetAllAsync()
    {
      var categories = await _categoriesRepository.GetAllAsync();
      return categories.OrderBy(x => x.Name).ToList();
    }

    public async Task<Category?> GetAsync(int id)
    {
      return await _categoriesRepository.GetAsync(id);
    }
    public async Task<int> AddOrUpdateAsync(Category category)
    {
      return await _categoriesRepository.AddOrUpdateAsync(category);
    }
    public async Task<int> DeleteAsync(Category category)
    {
      return await _categoriesRepository.DeleteAsync(category);
    }
    public async Task<int> DeleteAsync(int id)
    {
      return await _categoriesRepository.DeleteAsync(id);
    }

    public async Task<bool> ExistsAsync(int id)
    {
      return await _categoriesRepository.ExistsAsync(id);
    }

    Task<Category> ICategoriesService.GetAsync(int id)
    {
      throw new NotImplementedException();
    }
  }
  

}
