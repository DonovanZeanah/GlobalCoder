arr :=    ["jkl3()","def1()","abc4()","ghi2()"]

list :=    "Regular Sort`n`nOld order`tNew Order`n"
For each, item in sortArray(arr)
    list .=    "`n" arr[A_Index] "`t" item
MsgBox, %list%

list :=    "Reverse Position Sort`n`nOld order`tNew Order`n"
For each, item in sortArray(arr,"R P4")
    list .=    "`n" arr[A_Index] "`t" item
MsgBox, %list%

list :=    "Random Sort`n`nOld order`tNew Order`n"
For each, item in sortArray(arr,"Random")
    list .=    "`n" arr[A_Index] "`t" item
MsgBox, %list%

list :=    "Flip Sort`n`nOld order`tNew Order`n"
For each, item in sortArray(arr,"Flip")
    list .=    "`n" arr[A_Index] "`t" item
MsgBox, %list%
list :=    ""
return

sortArray(arr,options="") {    ; specify only "Flip" in the options to reverse otherwise unordered array items

    if    !IsObject(arr)
        return    0
    new :=    []
    if    (options="Flip") {
        While    (i :=    arr.MaxIndex()-A_Index+1)
            new.Insert(arr[i])
        return    new
    }
    For each, item in arr
        list .=    item "`n"
    list :=    Trim(list,"`n")
    Sort, list, %options%
    Loop, parse, list, `n, `r
        new.Insert(A_LoopField)
    return    new

}