; Generate the template controller file
;TemplateControllerGenerator.GenerateTemplateController()

; Replace the model name in the generated file
TemplateControllerGenerator.ReplaceModelNameInFile()


class TemplateControllerGenerator
{
    static modelName := "MyModel"

    static GenerateTemplateController()
    {
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

        ; Replace the placeholders with the actual model name. "%s" is an arbitrary placeholder for the model name, 
		;needs to be unique if changed to something else.
        controllerTemplate := StrReplace(controllerTemplate, "%s", TemplateControllerGenerator.modelName)

        ; Set the output file name
        outputFileName := "TemplateController_OutputFile.cs"
		
		while (FileExists(outputFileName))
		{
			outputFileName := InputBox("Enter the output file name:", "Output File Name")
		{

        ; Create and write the controller template to the output file
        File1 := FileOpen(outputFileName, "w")
        File1.Write(controllerTemplate)
        File1.Close()
        MsgBox("Template controller file has been generated as " . outputFileName)
		return outputFileName
		}
    }

    static ReplaceModelNameInFile()
    {
        ; Set the input and output file names
        inputFileName := "TemplateController_outputFile.cs"
        outputFileName2 := "TemplateController_OutputFile_Updated.cs"

        ; Prompt for a new model name
        newModelName := InputBox("Enter the new model name:", "Replace Model Name")

        ; Read the input file content
        inputFileContent := FileRead(inputFileName)

        ; Replace the original model name with the new model name
		msgbox(TemplateControllerGenerator.modelName)
        updatedFileContent := StrReplace(inputFileContent, TemplateControllerGenerator.modelName, newModelName.value)
		msgbox(updatedFileContent)

        ; Write the updated content to the output file
        File2 := FileOpen(outputFileName2, "w")
        File2.Write(updatedFileContent)
        File2.Close()
        MsgBox("The model name has been replaced and the updated file is saved as " . outputFileName2)
		return outputfilename2
    }

	__new(){
		this.files := {}
		this.files.push(TemplateControllerGenerator.GenerateTemplateController())
		this.files.push(TemplateControllerGenerator.ReplaceModelNameInFile())
	}
}


