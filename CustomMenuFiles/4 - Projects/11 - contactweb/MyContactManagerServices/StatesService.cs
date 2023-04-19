using ContactWebModels;
using MyContactManagerRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyContactManagerServices
{
  public class StatesService : IStatesService
  {
    private readonly IStatesRepository _statesRepository;

    public StatesService(IStatesRepository statesRepository)
    {
      _statesRepository = statesRepository;
    }

    public async Task<List<State>> GetAllAsync()
    {
      var states = await _statesRepository.GetAllAsync();
      return states.OrderBy(x => x.Name).ToList();
    }

    public async Task<State?> GetAsync(int id)
    {
      return await _statesRepository.GetAsync(id);
    }

    public async Task<int> AddOrUpdateAsync(State state)
    {
      return await _statesRepository.AddOrUpdateAsync(state);
    }

    public async Task<int> DeleteAsync(State state)
    {
      return await _statesRepository.DeleteAsync(state);
    }

    public async Task<int> DeleteAsync(int id)
    {
      return await _statesRepository.DeleteAsync(id);
    }

    public async Task<bool> ExistsAsync(int id)
    {
      return await _statesRepository.ExistsAsync(id);
    }
  }
}