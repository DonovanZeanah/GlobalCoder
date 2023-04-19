Contents := FileRead("C:\Address List.txt")
FileDelete "C:\Address List (alphabetical).txt"
FileAppend Sort(Contents), "C:\Address List (alphabetical).txt"
Contents := ""  ; Free the memory.