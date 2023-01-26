using ContactWebModels;

namespace MyContactManagerRepositories
{
  public interface ICategoriesRepository
  {
    Task<List<Category>> GetAllAsync();
    Task<Category> GetAsync(int id);
    Task<int> AddOrUpdateAsync(Category category);
    Task<int> DeleteAsync(int id);
    Task<int> DeleteAsync(Category category);
    Task<bool> ExistsAsync(int id);
  }
}