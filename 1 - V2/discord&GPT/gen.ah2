; Set the name of the placeholder Model
modelName := "placeholder"

; Define the template controller content
controllerTemplate := "
(
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using <YourProjectNamespace>.Models;

namespace <YourProjectNamespace>.Controllers
{
    public class %sController : Controller
    {
        public IActionResult Index()
        {
            var modelList = new List<%s>();
            // Add code to fetch or create the model list
            return View(modelList);
        }

        public IActionResult Details(int id)
        {
            var model = new %s();
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
        public IActionResult Create(%s model)
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
            var model = new %s();
            // Add code to fetch the model by id
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, %s model)
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
)"

; Replace the placeholders with the actual model name
controllerTemplate := StrReplace(controllerTemplate, "%s", modelName)

; Set the output file name
outputFileName := "TemplateController.cs"

; Create and write the controller template to the output file
File1 := FileOpen(outputFileName, "w")
File1.Write(controllerTemplate)
File1.Close()
MsgBox("Template controller file has been generated as " . outputFileName)

return