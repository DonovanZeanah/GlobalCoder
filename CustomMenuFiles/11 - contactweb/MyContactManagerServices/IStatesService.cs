using ContactWebModels;

namespace MyContactManagerServices
{
  public interface IStatesService
  {
    Task<List<State>> GetAllAsync();
    Task<State> GetAsync(int id);
    Task<int> AddOrUpdateAsync(State state);
    Task<int> DeleteAsync(int id);
    Task<int> DeleteAsync(State state);
    Task<bool> ExistsAsync(int id);
  }
}