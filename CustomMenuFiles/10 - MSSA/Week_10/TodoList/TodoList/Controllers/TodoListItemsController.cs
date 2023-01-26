using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TodoListData;
using TodoListModels;

namespace TodoList.Controllers
{
    public class TodoListItemsController : Controller
    {
        private readonly TodoListDataContext _context;

        public TodoListItemsController(TodoListDataContext context)
        {
            _context = context;
        }

        // GET: TodoListItems
        public async Task<IActionResult> Index()
        {
              return _context.ToDoItems != null ? 
                          View(await _context.ToDoItems.ToListAsync()) :
                          Problem("Entity set 'TodoListDataContext.ToDoItems'  is null.");
        }

        // GET: TodoListItems/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.ToDoItems == null)
            {
                return NotFound();
            }

            var todoListItem = await _context.ToDoItems
                .FirstOrDefaultAsync(m => m.Id == id);
            if (todoListItem == null)
            {
                return NotFound();
            }

            return View(todoListItem);
        }

        // GET: TodoListItems/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: TodoListItems/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,DetailText,IsCompleted,Status,CompletedDate,ModifiedByEmail")] TodoListItem todoListItem)
        {
            if (ModelState.IsValid)
            {
                _context.Add(todoListItem);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(todoListItem);
        }

        // GET: TodoListItems/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.ToDoItems == null)
            {
                return NotFound();
            }

            var todoListItem = await _context.ToDoItems.FindAsync(id);
            if (todoListItem == null)
            {
                return NotFound();
            }
            return View(todoListItem);
        }

        // POST: TodoListItems/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,DetailText,IsCompleted,Status,CompletedDate,ModifiedByEmail")] TodoListItem todoListItem)
        {
            if (id != todoListItem.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(todoListItem);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!TodoListItemExists(todoListItem.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(todoListItem);
        }

        // GET: TodoListItems/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.ToDoItems == null)
            {
                return NotFound();
            }

            var todoListItem = await _context.ToDoItems
                .FirstOrDefaultAsync(m => m.Id == id);
            if (todoListItem == null)
            {
                return NotFound();
            }

            return View(todoListItem);
        }

        // POST: TodoListItems/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.ToDoItems == null)
            {
                return Problem("Entity set 'TodoListDataContext.ToDoItems'  is null.");
            }
            var todoListItem = await _context.ToDoItems.FindAsync(id);
            if (todoListItem != null)
            {
                _context.ToDoItems.Remove(todoListItem);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool TodoListItemExists(int id)
        {
          return (_context.ToDoItems?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
