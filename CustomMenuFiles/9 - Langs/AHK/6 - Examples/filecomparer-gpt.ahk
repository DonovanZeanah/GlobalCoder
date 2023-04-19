class FileComparer
{
    baseName := ""
    dir := ""
    differences := []

    FileComparer(baseName, dir)
    {
        this.baseName := baseName
        this.dir := dir
    }

    CompareFiles()
    {
        files := []
        Loop, %this.dir%\*.*, 1
        {
            if (RegExMatch(A_LoopFileName, "^" this.baseName "([\s|_|\d|a-zA-Z]+)\.\w{3}$"))
                files.Push(A_LoopFileFullPath)
        }
        if(!files.length()) return 
       
        for i, file1 in files
        {
            for j, file2 in files
            {
                if(i>=j)
                    continue
                
                file1Content := FileRead(file1)
                file2Content := FileRead(file2)
                if (file1Content != file2Content)
                {
                    this.differences.Push({file1:file1Content, file2:file2Content})
                }
            }
        }
    }
}