using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using <YourProjectNamespace>.Models;

namespace <YourProjectNamespace>.Controllers
{
    public class MyModelController : Controller
    {
        public IActionResult Index()
        {
            var modelList = new List<MyModel>();
            // Add code to fetch or create the model list
            return View(modelList);
        }

        public IActionResult Details(int id)
        {
            var model = new MyModel();
            // Add code to fetch the model by id
            return View(model);
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(MyModel model)
        {
            if (ModelState.IsValid)
            {
                // Add code to save the model
                return RedirectToAction(nameof(Index));
            }

            return View(model);
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            var model = new MyModel();
            // Add code to fetch the model by id
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, MyModel model)
        {
            if (ModelState.IsValid)
            {
                // Add code to update the model
                return RedirectToAction(nameof(Index));
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Delete(int id)
        {
            // Add code to fetch and delete the model by id
            return RedirectToAction(nameof(Index));
        }
    }
}