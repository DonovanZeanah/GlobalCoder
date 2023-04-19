; Function to load the paths from a file
LoadPaths(filePath) {
    paths := []
    FileRead, contents, %filePath%
    Loop, Parse, contents, `n
    {
        paths.Insert(A_LoopField)
    }
    return paths
}

; Example usage:
paths := LoadPaths("C:\\path\\to\\saved_paths.txt")