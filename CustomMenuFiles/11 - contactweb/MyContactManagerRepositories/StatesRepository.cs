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
  public class StatesRepository : IStatesRepository
  {
    private readonly MyContactManagerDbContext _context;

    public StatesRepository(MyContactManagerDbContext context)
    {
      _context = context;
    }

    public async Task<List<State>> GetAllAsync()
    {
      var states = await _context.States.AsNoTracking().OrderBy(x => x.Name).ToListAsync();
      return states;
    }

    public async Task<State> GetAsync(int id)
    {
      var states = await _context.States.AsNoTracking().SingleOrDefaultAsync(x => x.Id == id);
      return states;
    }

    public async Task<int> AddOrUpdateAsync(State state)
    {
      if (state.Id > 0)
      {
        return await Update(state);
      }
      return await Insert(state);
    }

    private async Task<int> Insert(State state)
    {
      await _context.States.AddAsync(state);
      await _context.SaveChangesAsync();
      return state.Id;
    }

    private async Task<int> Update(State state)
    {
      var existingState = await _context.States.SingleOrDefaultAsync(x => x.Id == state.Id);
      if (existingState is null) throw new Exception("State not found");

      existingState.Abbreviation = state.Abbreviation;
      existingState.Name = state.Name;

      await _context.SaveChangesAsync();
      return state.Id;
    }

    public async Task<int> DeleteAsync(State state)
    {
      return await DeleteAsync(state.Id);
    }

    public async Task<int> DeleteAsync(int id)
    {
      var existingState = await _context.States.SingleOrDefaultAsync(x => x.Id == id);
      if (existingState is null) throw new Exception("Could not delete state due to unable to find matching state");

      _context.States.Remove(existingState);
      await _context.SaveChangesAsync();
      return id;
    }

    public async Task<bool> ExistsAsync(int id)
    {
      return await _context.States.AsNoTracking().AnyAsync(x => x.Id == id);
    }
  }
}
