
PrepareMenu(PATH) {
    ; Define static URLs for various search types
    static urls := { 1: "https://www.google.com/search?hl=en&q="
    , 2: "https://www.google.com/search?site=imghp&tbm=isch&q="
    , 3: "https://www.google.com/maps/search/"
    , 4: "https://translate.google.com/?sl=auto&tl=en&text=" }
    ; GUI loading/progress bar
    Gui := Gui("+ToolWindow -MinimizeBox +Border")
    Progress := Gui.Add("Progress", "w200 vMyProgress range1-%items% 0")

    ; Add name, icon, and separating line for Google search
    PATH.Add("g&oogler", "googler") ; Regular search
    PATH.Add()

    ; Add custom items using algorithm
    LoopOverFolder(PATH)

    ; Add admin panel
    Sleep 200
    PATH.Add("&Admin", ":%PATH%\Admin")
    PATH.NewSub("&Admin")
    PATH.Add("&3 Restart", "ReloadProgram")
    PATH.Add("&2 Exit", "ExitApp")
    PATH.Add("&1 Go to Parent Folder", "GoToRootFolder")
    PATH.Add("&4 Add Custom Item", "GoToCustomFolder")
    PATH.EndSub()
    PATH.Add("&1 Admin", ":&Admin")
    PATH.Add("&2 New", ":&New")
    PATH.Add()
    PATH.Add("&" ScriptName " vers. " Version, "github")
    PATH.Add()

    ; Loading bar GUI is no longer needed, remove it from memory
    Gui.Destroy()
}

LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray := []
    ; Loop over all files and folders in input path, but do NOT recurse
    Loop, Files, %PATH%\*, DF
    {
        ; Determine whether current item is a directory or file
        if (FileExist(A_LoopFilePath) = "D")
            FolderArray.Push(A_LoopFilePath)
        else
            FileArray.Push(A_LoopFilePath)
    }

    ; Sort arrays for alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray
    {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Add folder as item to menu
        SplitPath, element, name, dir, ext, name_no_ext, drive
        dir.Add("&" name, ":" element)
    }

    ; Then add all files to folders
    for index, element in FileArray
    {
        ; Add file as item to menu
        SplitPath, element, name, dir, ext, name_no_ext, drive
        dir.Add(name, "MenuEventHandler")
}
