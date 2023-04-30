;Set the name of the placeholder Model
	;modelName := "MyModel"
	; modelName := inputbox()
	; if !modelName
		modelName := "MyModel"

  ;Create the template controller content
	;inputbox("Enter the name of the placeholder Model", "Placeholder Model Name", "MyModel")

  ;Create the template controller content

;#region Define the template controller content
	controllerTemplate := "
	(
	using System 

	using Microsoft.AspNetCore.Mvc 
	using System.Collections.Generic 
	using <YourProjectNamespace>.Models 

	namespace <YourProjectNamespace>.Controllers
	{
		public class %sController : Controller
		{
			public IActionResult Index()
			{
				var modelList = new List<%s>() 
				// Add code to fetch or create the model list
				return View(modelList) 
			}

			public IActionResult Details(int id)
			{
				var model = new %s() 
				// Add code to fetch the model by id
				return View(model) 
			}

			[HttpGet]
			public IActionResult Create()
			{
				return View() 
			}

			[HttpPost]
			[ValidateAntiForgeryToken]
			public IActionResult Create(%s model)
			{
				if (ModelState.IsValid)
				{
					// Add code to save the model
					return RedirectToAction(nameof(Index)) 
				}

				return View(model) 
			}

			[HttpGet]
			public IActionResult Edit(int id)
			{
				var model = new %s() 
				// Add code to fetch the model by id
				return View(model) 
			}

			[HttpPost]
			[ValidateAntiForgeryToken]
			public IActionResult Edit(int id, %s model)
			{
				if (ModelState.IsValid)
				{
					// Add code to update the model
					return RedirectToAction(nameof(Index)) 
				}

				return View(model) 
			}

			[HttpPost]
			[ValidateAntiForgeryToken]
			public IActionResult Delete(int id)
			{
				// Add code to fetch and delete the model by id
				return RedirectToAction(nameof(Index)) 
			}
		}
	}
	)"
	;#region End of template controller content
	;#endregion End of template controller content

  ;Replace the placeholders with the actual model name
controllerTemplate := StrReplace(controllerTemplate, "%s", modelName)

  ;Set the output file name
outputFileName := "TemplateController.cs"

  ;Create and write the controller template to the output file
File1 := FileOpen(outputFileName, "w")
File1.Write(controllerTemplate)
File1.Close()
MsgBox("Template controller file has been generated as " . outputFileName)


  
  
  ;Create an instance of the PlaceholderReplacer class
replacer := PlaceholderReplacer()

  ;Replace placeholders in the 'placeholderController.cs' file
replacer.ReplaceInFile("TemplateController.cs")

  ;AutoHotkey v2 script to replace case-sensitive instances of 'placeholder' in a file called 'placeholderController.cs'

class PlaceholderReplacer {
    static searchWord := "model"
    static replacementWord := "hippie"
   
    ReplaceInFile(filePath) {
        FileRead(this.content, filePath)
		;File1 := FileOpen(outputFileName, "w")
       
          ;Use RegExReplace to perform the case-sensitive replacement
        this.caseSensitiveContent := RegExReplace(this.content, "i)" . this.searchWord, this.replacementWord)
       
          ;Backup the original file by renaming it
        Filemove(filePath, filePath . "_backup")
       
          ;Save the modified content to the original file
        FileWrite(filePath, this.caseSensitiveContent)
       
        MsgBox("The replacement process is complete.")
    }
}








