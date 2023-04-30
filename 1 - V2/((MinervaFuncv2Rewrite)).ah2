#warn all, off

;#include D:\(github)-MAINS\AHK-v2-libraries\Lib\Array.ahk

!n::{
    mymenu1.Show
}

capslock::Search("Google").Show()
;capslock::Search("Google").Show()

<^m:: mymenu.Menu.show ;().HandleKeyInput()
^+m::{

    anotherMenu.show(200,200)
    anotherMenu.HandleKeyInput()
}
^!m::{
    anotherMenu.HandleKeyInput()

}
;OnError LogError
;i := Integer("cause_error")


F1::{
    P := Path(Path.Documents())
    For Item in P.IterDir() {
        If Path(Item).IsSymLink {
            Folder := Path(Item)
            List .= Folder.Path "`n"
        }

    }
    MsgBox(List)
}


/*MsgBox String(Test1("Hello World"))

class Test1 {
    __New(What) {
        this.data := What
    }
    ToString() {
        return this.data
    }
}

instance := Test1("Hello World")

MsgBox instance.data
MsgBox String(instance)

class Test2 {
    __New(What) {
        this.data := What
    }
    ToString() {
        return this.data
    }
}*/








;mymenu := MyMenu()
/*anotherMenu := mymenu()

anotherMenu := mymenu(
    Map("More Option 1", anotherMenu.ItemAction,
        "More Option 2", anotherMenu.ItemAction,
        "More Option 3", anotherMenu.ItemAction
    )
)

anotherMenu.Add "Another Option", mymenu.ItemAction

anotherMenu.CreateItems(
    Map("More Option 4", anotherMenu.ItemAction,
        "More Option 5", anotherMenu.ItemAction,
        "More Option 6", anotherMenu.ItemAction
    )
)


anotherMenu := MyMenu(Map("More Option 1", anotherMenu.ItemAction, "More Option 2", anotherMenu.ItemAction, "More Option 3", anotherMenu.ItemAction))

msgbox "still executing..."
*/


MyMenu1 := Menu()
PrepareMenu("D:\(github)\GlobalCoder\gc\GlobalCoder\CustomMenuFiles", MyMenu1)
;PrepareMenu(A_ScriptDir "\singles")


/*anotherMenu := mymenu()

anotherMenu := mymenu(
    Map("More Option 1", anotherMenu.ItemAction,
        "More Option 2", anotherMenu.ItemAction,
        "More Option 3", anotherMenu.ItemAction
    )
)

anotherMenu.Add "Another Option", mymenu.ItemAction

anotherMenu.CreateItems(
    Map("More Option 4", anotherMenu.ItemAction,
        "More Option 5", anotherMenu.ItemAction,
        "More Option 6", anotherMenu.ItemAction
    )
)


anotherMenu := MyMenu(Map("More Option 1", anotherMenu.ItemAction, "More Option 2", anotherMenu.ItemAction, "More Option 3", anotherMenu.ItemAction))
*/

;## Create the popup menu by adding some items to it.
   ; MyMenu1 := Menu()
    /*MyMenu1.Add "Item 1", MenuHandler
    MyMenu1.Add "Item 2", MenuHandler
    MyMenu1.Add  ; Add a separator line.
    ;//
;## Create another menu destined to become a submenu of the above menu.
    Submenu1 := Menu()
    Submenu1.Add "Item A", MenuHandler
    Submenu1.Add "Item B", MenuHandler
;## Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
    MyMenu1.Add "My Submenu", Submenu1

    MyMenu1.Add  ; Add a separator line below the submenu.
    MyMenu1.Add "Item 3", MenuHandler  ; Add another menu item beneath the submenu.*/

return
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[Hotkeys]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]
;^!m:: mymenuI.Menu.show ;().HandleKeyInput()
;<^m:: mymenu.Menu.show ;().HandleKeyInput()
;<!m:: anotherMenu.show(200,200)



#z::
{
	;getcaret(&x,&y,&w,&h)
	MyMenu1.Show()  ; i.e. press the Win-Z hotkey to show the menu.
}

^!t::
{
	   for n in FibC()
	    if MsgBox("#" A_Index " = " n "`nContinue?",, "y/n") = "No"
	        break


	for n in FibF() ;val not enumerable
	    if MsgBox("#" A_Index " = " n "`nContinue?",, "y/n") = "No"
	        break


	windows := ""
	for window in ComObject("Shell.Application").Windows
	    windows .= window.LocationName " :: " window.LocationURL "`n"
	MsgBox windows

	colours := {red: 0xFF0000, blue: 0x0000FF, green: 0x00FF00}
	; The above expression could be used directly in place of "colours" below:
	s := ""
	for k, v in colours.OwnProps()
	    s .= k "=" v "`n"
	MsgBox s

	;//=====================================================
	myArray := ["apple", "banana", "cherry"]
	for index, value in myArray
	{
	    MsgBox "Index " index " contains " value
	}
	myMap := new Map()
	myMap.Set("key1", "value1")
	myMap.Set("key2", "value2")
	myMap.Set("key3", "value3")

	for key, value in myMap
	{
	    MsgBox "Key: " key ", Value: " value
	}
	myMap := {key1: "value1", key2: "value2"}
	if (IsObject(myMap))
	{
	    keyList := myMap.keys()
	    for key, value in keyList
	    {
	        MsgBox "Key: " key ", Value: " value
	    }
	}




	 ; Read the content of the input .ahk file
	content := FileRead("guiclass.ah2")
    msgbox content

	; Find and extract the classes
	ahclasses := []
	regex := "class\s+(\w+)\s*\{[\s\S]*?\}"
	pos := 1
	found := []

	while (pos := RegExMatch(content, regex, &found, pos)) {
	    class_name := found[1]
	    class_code := found[0]
	    ahclasses.push(class_name, class_code )
	    ;ahclasses["class_name"] := class_code
	    ;content := SubStr(content, found.Pos + found.Len)
	    pos += found.len - 1 ;strlen(found[0])
	}

	; Sort the classes
	sorted_classes := SortClasses(ahclasses)

	; Write the sorted classes to a new output .ahk file
	sorted_content := ""
	for _, class_code in sorted_classes {
	    sorted_content .= class_code "`n`n"
	}
	FileDelete("output.ahk")
	FileAppend("output.txt", sorted_content)
}

!x::
{
	 keys1 := map.keys(myMap)
	 values1 := Object.values(myMap)

	 for i, key in keys1 {
	     value1 := values[i]
	     MsgBox "Key: " key "`nValue: " value
	 }

	    myMap := {a: 1, b: 2, c: 3}
	 for key, value in myMap
	 {
	     MsgBox "Key " key " contains " value
	 }

	;//================
	 ; Read the content of the input .ahk file
	 content := FileRead("guiclass.ah2")

	 ; Find and extract the classes
	 ahclasses := {}
	 regex := "class\s+(\w+)\s*\{[\s\S]*?\}"
	 while RegExMatch(content, regex, found) {
	     class_name := found[1]
	     class_code := found[0]
	     ahclasses[class_name] := class_code
	     content := SubStr(content, found.Pos + found.Len)
	 }

	 ; Sort the classes
	 sorted_classes := ahSortClasses(ahclasses)

	 ; Write the sorted classes to a new output .ahk file
	 sorted_content := ""
	 for _, class_code in sorted_classes {
	     sorted_content .= class_code "`n`n"
	 }
	 FileDelete("output.ahk")
	 FileAppend("output.ahk", sorted_content)

	 ; Function to sort the classes by name
	 ahSortClasses(ahclasses) {
	     sorted := {}
	     for class_name, class_code in ahclasses {
	         sorted[class_name] := class_code
	     }
	     ; Sort dictionary keys
	     sorted_keys := Object()
	     for key in sorted {
	         sorted_keys.Insert(key)
	     }
	     sorted_keys.Sort()
	    
	     ; Create a new sorted dictionary
	     sorted_output := Object()
	     for key in sorted_keys {
	         sorted_output[key] := sorted[key]
	     }

	     return sorted_output

	}
		 loggerObj := Logger()
		 timelineObj := Timeline(loggerObj)

		 timelineObj.logEvents("First event")
		 sleep(1000)
		 timelineObj.logEvents("Second event")
		 timeline1 := Timeline(loggerobj)
		 timeline1.AddEvent("start", A_TickCount)
		 Sleep(1000)
		 timeline1.AddEvent("middle", A_TickCount)
		 Sleep(1000)
		 timeline1.AddEvent("end", A_TickCount)
		 timeline1.logevents()
		 ;timeline1.logeventsjson()
		 startTime := timeline1.GetEventTime("start")
		 middleTime := timeline1.GetEventTime("middle")
		 endTime := timeline1.GetEventTime("end")
		 MsgBox("Start time:" startTime "`nMiddle time:" middleTime "`nEnd time:" endTime)
		 return
}

/*
    This library contains multiple sorting algorithms and array-related functions to test them out
    You'll see the Big O notation for every sorting algorithm: worst, average and best case
    What each of those means in the context of the sorting algorithm will likely not be explicitly explained

    Some sorting algorithms will have been tested in terms of real time taken to sort 100000 indexes
    Take the time coming from the tests with a huge rock of salt, it's there simply to have a rough comparison between sorting algorithms

    Terms:
    Rising array   -- every index matches its value
    Shuffled array -- a shuffled rising array (Fisher-Yates shuffle)
    Random array   -- array filled with random numbers. the range of each number starts at 1 and ends at the length of the array multiplied by 7 (check the preset parameter of variation in GenerateRandomArray())

    The time it takes to sort 100k indexes is measured by sorting *shuffled* arrays
*/

ArrToStr(arrayObj, delimiter := ", ") {
    str := ""
    for key, value in arrayObj {
        if key = arrayObj.Length {
            str .= value
            break
        }
        str .= value delimiter
    }
    return str
}
Array.Prototype.DefineProp("toString", {Call: ArrToStr})

GenerateRandomArray(indexes, variation := 7) {
    arrayObj := []
    Loop indexes {
        arrayObj.Push(Random(1, indexes * variation))
    }
    return arrayObj
}

GenerateRisingArray(indexes) {
    arrayObj := []
    i := 1
    Loop indexes {
        arrayObj.Push(i)
        i++
    }
    return arrayObj
}

GenerateShuffledArray(indexes) {
    risingArray := GenerateRisingArray(indexes)
    shuffledArray := FisherYatesShuffle(risingArray)
    return shuffledArray
}

FisherYatesShuffle(arrayObj) {
    shufflerIndex := 0
    while --shufflerIndex > -arrayObj.Length {
        randomIndex := Random(-arrayObj.Length, shufflerIndex)
        if arrayObj[randomIndex] = arrayObj[shufflerIndex]
            continue
        temp := arrayObj[shufflerIndex]
        arrayObj[shufflerIndex] := arrayObj[randomIndex]
        arrayObj[randomIndex] := temp
    }
    return arrayObj
}
Array.Prototype.DefineProp("FisherYatesShuffle", {Call: FisherYatesShuffle})

/*
    O(n^2) -- worst case
    O(n^2) -- average case
    O(n)   -- best case
    Sorts 100k indexes in: 1 hour 40 minutes
*/
BubbleSort(arrayObj) {
    finishedIndex := -1
    Loop arrayObj.Length - 1 {
        swaps := 0
        for key, value in arrayObj {
            if value = arrayObj[finishedIndex]
                break
            if value <= arrayObj[key + 1]
                continue

            firstComp := arrayObj[key]
            secondComp := arrayObj[key + 1]
            arrayObj[key] := secondComp
            arrayObj[key + 1] := firstComp
            swaps++
        }
        if !swaps
            break
        finishedIndex--
    }
    return arrayObj
}
Array.Prototype.DefineProp("BubbleSort", {Call: BubbleSort})

/*
    O(n^2) -- all cases
    Sorts 100k indexes in: 1 hour 3 minutes
*/
SelectionSort(arrayObj) {
    sortedIndex := 0
    Loop arrayObj.Length - 1 {
        sortedIndex++
        NewMinInts := 0

        for key, value in arrayObj {
            if key < sortedIndex
                continue
            if key = sortedIndex
                min := {key:key, value:value}
            else if min.value > value {
                min := {key:key, value:value}
                NewMinInts++
            }
        }

        if !NewMinInts
            continue

        temp := arrayObj[sortedIndex]
        arrayObj[sortedIndex] := min.value
        arrayObj[min.key] := temp
    }
    return arrayObj
}
Array.Prototype.DefineProp("SelectionSort", {Call: SelectionSort})

/*
    O(n^2) -- worst case
    O(n^2) -- average case
    O(n)   -- best case
    Sorts 100k indexes in: 40 minutes
*/
InsertionSort(arrayObj) {
    for key, value in arrayObj {
        if key = 1
            continue
        temp := value
        prevIndex := 0
        While key + prevIndex - 1 >= 1 && temp < arrayObj[key + prevIndex - 1] {
            arrayObj[key + prevIndex] := arrayObj[key + prevIndex - 1]
            prevIndex--
        }
        arrayObj[key + prevIndex] := temp
    }
    return arrayObj
}
Array.Prototype.DefineProp("InsertionSort", {Call: InsertionSort})

/*
    O(n logn) -- all cases
    Sorts 100k indexes in: 4 seconds
*/
MergeSort(arrayObj) {
    Merge(leftArray, rightArray, fullArrayLength) {
        leftArraySize := fullArrayLength // 2
        rightArraySize := fullArrayLength - leftArraySize
        fullArray := []
        l := 1, r := 1

        While l <= leftArraySize && r <= rightArraySize {
            if leftArray[l] < rightArray[r] {
                fullArray.Push(leftArray[l])
                l++
            }
            else if leftArray[l] >= rightArray[r] {
                fullArray.Push(rightArray[r])
                r++
            }
        }
        While l <= leftArraySize {
            fullArray.Push(leftArray[l])
            l++
        }
        While r <= rightArraySize {
            fullArray.Push(rightArray[r])
            r++
        }
        return fullArray
    }

    arrayLength := arrayObj.Length

    if arrayLength <= 1
        return arrayObj

    middle := arrayLength // 2
    leftArray := []
    rightArray := []

    i := 1
    While i <= arrayLength {
        if i <= middle
            leftArray.Push(arrayObj[i])
        else if i > middle
            rightArray.Push(arrayObj[i])
        i++
    }

    leftArray := MergeSort(leftArray)
    rightArray := MergeSort(rightArray)
    return Merge(leftArray, rightArray, arrayLength)
}
Array.Prototype.DefineProp("MergeSort", {Call: MergeSort})

/*
    O(n + k) -- all cases
    Where "k" is the highest integer in the array
    The more indexes you want to sort, the bigger "thread delay" will have to be
    This sorting algorithm is *not* practical, use it exclusively for fun!
*/
SleepSort(arrayObj, threadDelay := 30) {
    sortedArrayObj := []

    _PushIndex(passedValue) {
        Settimer(() => sortedArrayObj.Push(passedValue), -passedValue * threadDelay)
    }

    for key, value in arrayObj {
        _PushIndex(value)
    }

    While sortedArrayObj.Length != arrayObj.Length {
        ;We're waiting for the sorted array to be filled since otherwise we immidiately return an empty array (settimers don't take up the thread while waiting, unlike sleep)
    }
    return sortedArrayObj
}
Array.Prototype.DefineProp("SleepSort", {Call: SleepSort})


;MyMenu1 := Menu()
;PrepareMenu("D:\(github)\GlobalCoder\gc\GlobalCoder\CustomMenuFiles", MyMenu1)
/*class Sort
{
    __New(compare:=""){
        if (!Array.Prototype.HasOwnMethod("swap"))
            Array.Prototype.DefineMethod("swap", (self, i, j)=>(t:=self[i], self[i]:=self[j], self[j]:=t))
        if Type(compare)="Func"
            this.DefineMethod("compare", compare)
    }

    bubbleSort(arr){
        this._bubbleSort(arr, 1, arr.Length)
    }

    insertSort(arr){
        this._insertSort(arr, 1, arr.Length)
    }

    QSort(arr){
        _sort(arr, 1, arr.Length)

        _sort(arr, l, h){
            if (n:=h-l+1, n<=20)
                return this._insertSort(arr, l, h)
            else if (n<=40)
                arr.swap(median3(arr, l, l+(n>>1), h), l)
            else
                eps:=n>>3, mid:=l+n>>1, arr.swap(median3(arr, median3(arr, l, l+eps, l+eps+eps),
                    median3(arr, mid-eps, mid, mid+eps), median3(arr, h-eps-eps, h-eps, h)), l)
            p:=i:=l, q:=j:=h+1, v:=arr[l]
            while (true){
                while (this.compare(arr[++i], v)>0&&i<h)
                    continue
                while (this.compare(v, arr[--j])>0&&j>l)
                    continue
                if (i=j&&this.compare(arr[i], v)=0)
                    arr.swap(++p, i)
                if (i>=j)
                    break
                arr.swap(i, j)
                if (this.compare(arr[i], v)=0)
                    arr.swap(++p, i)
                if (this.compare(arr[j], v)=0)
                    arr.swap(--q, j)
            }

            i:=j+1, k:=l
            while (k<=p)
                arr.swap(k, j--), k++
            k:=h
            while (k>=q)
                arr.swap(k, i++), k--
            _sort(arr, l, j), _sort(arr, i, h)
        }

        median3(arr, i, j, k){
            return this.compare(arr[i], arr[j])>0 ? (this.compare(arr[j], arr[k])>0 ? j : this.compare(arr[i], arr[k])>0 ? k : i)
                : (this.compare(arr[k], arr[j])>0 ? j : this.compare(arr[k], arr[i])>0 ? k : i)
        }
    }

    _bubbleSort(arr, l, h){
        i:=l
        while (i<h){
            j:=i+1
            while (j>l)
                (this.compare(arr[j], arr[j-1])>0)?(arr.swap(j, j-1),j--):j--
            i++
        }
    }

    _insertSort(arr, l, h){
        i:=l+1
        while (i<=h){
            t:=arr[i], ll:=l, hh:=i-1
            while (ll<=hh)
                m:=(ll+hh)>>1, (this.compare(t, arr[m])>0)?(hh:=m-1):(ll:=m+1)
            j:=i-1
            while (j>=hh+1)
                arr[j+1]:=arr[j], j--
            arr[j+1]:=t, i++
        }
    }

    compare(v, w){
        return v<w ? 1 : v==w ? 0 : -1
    }
}*/

ArrSort(oArray, compare:="asc"){
    static _fun_:=A_PtrSize=8?"M8CF0nQdZmYPH4QAAAAAAESNSAFEi8BBi8FGiQyBRDvKcu3D":"i1QkCDPAhdJ0E1aLdCQIkI1IAYkMhovBO8Jy9F7D",pF,___:=(DllCall("crypt32\CryptStringToBinary","str",_fun_,"uint",0,"uint",1,"Ptr",0,"uint*",_sz_:=0,"Ptr",0,"Ptr",0),pF:=DllCall("GlobalAlloc","uint",0,"Ptr",_sz_,"Ptr"),DllCall("VirtualProtect","Ptr",pF,"Ptr",_sz_,"uint",0x40,"uint*",_op_:=0),DllCall("crypt32\CryptStringToBinary","str",_fun_,"uint",0,"uint",1,"Ptr",pF,"uint*",_sz_,"Ptr",0,"Ptr",0))
    switch Type(compare)
    {
    case "Func", "BoundFunc":
        pFunc:=CallbackCreate(compare, "C")
    case "String":
        pFunc:=compare="desc"
            ?CallbackCreate((p1, p2)=>(v1:=oArray[NumGet(p1+0, "UInt")],v2:=oArray[NumGet(p2+0, "UInt")],v1<v2?1:v1>v2?-1:0), "C", 2)
            :CallbackCreate((p1, p2)=>(v1:=oArray[NumGet(p1+0, "UInt")],v2:=oArray[NumGet(p2+0, "UInt")],v1>v2?1:v1<v2?-1:0), "C", 2)
    default:
        pFunc:=CallbackCreate((p1, p2)=>(v1:=oArray[NumGet(p1+0, "UInt")],v2:=oArray[NumGet(p2+0, "UInt")],v1<v2?1:v1>v2?-1:0), "C", 2)
    }
    vCount := oArray.Length, vData:=Buffer(4*vCount), DllCall(pF, "Ptr", vData, "UInt", vCount, "Cdecl")
    ; Loop vCount
    ;   NumPut("UInt", A_Index, vData, offset), offset+=4
    DllCall("msvcrt\qsort", "Ptr", vData, "UInt", vCount, "UInt", 4, "Ptr", pFunc, "Cdecl")
    oArray2 := [], oArray2.Capacity:=vCount, offset:=0
    Loop vCount
        oArray2.Push(oArray[NumGet(vData, offset, "UInt")]), offset+=4
    CallbackFree(pFunc)
    return oArray2
}

; ; examples
; arr:=[], list:=""
; Loop 50
;   arr.Push(Random(1, 100000)), list.=arr[-1] " "
; MsgBox "数组初始化`n" list
; list:=""
; ; 升序
; ; Sort.New().QSort(arr)   ; 快排
; ; Sort.New().insertSort(arr)  ; 插入排序
; ; Sort.New().bubbleSort(arr)  ; 冒泡
; Array.Prototype.DefineMethod("sort", (a)=>Sort.New().QSort(a))    ; 定义Array对象 sort方法
; arr.sort()
; Loop arr.Length
;   list.=arr[A_Index] " "
; MsgBox "快排 升序`n" list
; list:=""
; ; 降序
; Sort.New((self,v,w)=>(v>w ? 1 : v==w ? 0 : -1)).QSort(arr)    ; 快排
; Loop arr.Length
;   list.=arr[A_Index] " "
; MsgBox "快排 降序`n" list
; list:=""
; ; 随机
; Sort.New((self,v,w)=>Random(-1,1)).QSort(arr) ; 快排
; Loop arr.Length
;   list.=arr[A_Index] " "
; MsgBox "快排 随机`n" list
; list:=""

; ; msvcrt qsort    c运行时 快排
; arr:=ArrSort(arr) ; 升序
; Loop arr.Length
;   list.=arr[A_Index] " "
; MsgBox "c运行时 快排 升序`n" list
; list:=""

; arr:=ArrSort(arr, "desc") ; 降序
; Loop arr.Length
;   list.=arr[A_Index] " "
; MsgBox "c运行时 快排 降序`n" list
; list:=""

; ; 对象排序
; objarr:=[]
; Loop 50
;   objarr.Push({k:"a" A_Index, v:t:=Random(1, 1000)}), list.="{k:'a" A_Index "',v:" t "} "
; MsgBox "对象数组初始化`n" list
; list:=""
; Sort.New((self,v,w)=>(v.v>w.v ? 1 : v.v==w.v ? 0 : -1)).QSort(objarr) ; 快排
; Loop objarr.Length
;   list.="{k:'" objarr[A_Index].k "',v:" objarr[A_Index].v "} "
; MsgBox "对象 快排 降序`n" list

PrepareMenu(PATH, menu1) {

    FileMenu := Menu()
    FileMenu.Add("Script Icon", MenuHandler)
    FileMenu.Add("Suspend Icon", MenuHandler)
    FileMenu.Add("Pause Icon", MenuHandler)
    FileMenu.SetIcon("Script Icon", A_AhkPath, 2) ; 2nd icon group from the file
    FileMenu.SetIcon("Suspend Icon", A_AhkPath, -206) ; icon with resource ID 206
    FileMenu.SetIcon("Pause Icon", A_AhkPath, -207) ; icon with resource ID 207

    MyMenuBar := MenuBar()
    MyMenuBar.Add("&File", FileMenu)

    MyGui := Gui()
    MyGui.MenuBar := MyMenuBar
    MyGui.Add("Button",, "Exit This Example").OnEvent("Click", (*) => WinClose())
    MyGui.Add("Button",, "try").OnEvent("Click", (*) => Wincust())
    MyGui.Add("Button",, "tried").OnEvent("Click", (*) => Wincust())

    wincust(*){
        msgbox "wincust"
    }


    MenuHandler(*) {
        ; For this example, the menu items don't do anything.
    }
    ;menu1 := menuin
   ; msgbox Type(menu1)
    ;msgbox Type(menuin)

    ; GUI loading/progress bar
    MyGui := Gui("+ToolWindow", A_ScriptName " is Loading") ; Adding title to progressbar
    MyGui.Add("Progress", "w200 vMyProgress range1-`%items% 0") ; Adding progressbar
    MyGui.Show() ; Displaying Progressbar

    ; Add Name, Icon and separating line
    Menu1.Add("g&oogler", googler)
    Menu1.Add

    googler(*){
        msgbox "placeholder"
    }
    ; Add all custom items using algorithm
    ;msgbox "Passing PATH to loopoverfolder: `n " . PATH
    LoopOverFolder(PATH, Menu1)

    ; Separating line
    Menu1.Add

    ; Add Admin Panel
    Sleep 200
    Menu1.Add({Type: "SubMenu", Name: "new", Text: "&n test"})
    Menu1.Add({Text: "&3 Restart", Func: "ReloadProgram", Parent: PATH . "\Admin"}) ; Add Reload option
    Menu1.Add({Text: "&2 Exit", Func: "ExitApp", Parent: PATH . "\Admin"}) ; Add Exit option
    Menu1.Add({Text: "&1 Go to Parent Folder", Func: "GoToRootFolder", Parent: PATH . "\Admin"}) ; Open script folder
    Menu1.Add({Text: "&4 Add Custom Item", Func: "GoToCustomFolder", Parent: PATH . "\Admin"}) ; Open custom folder

    ; Bottom sec
    Menu1.Add({Type: "SubMenu", Name: "Admin", Text: "&1 Admin", Parent: PATH})
    Menu1.Add({Type: "SubMenu", Name: "New", Text: "&2 New", Parent: PATH})
    Menu1.Add({Type: "Separator", Parent: PATH})
    Menu1.Add({Text: "&" ScriptName " vers. " Version, Func: "github", Parent: PATH}) ; Name
    Menu1.Add({Type: "Separator", Parent: PATH}) ; Adds Admin section

    MyGui.Show
    ; Loading bar GUI is no longer needed, remove it from memory
    ;Gui1.Destroy()
    ;return menu1
}
/*
;depthtrawler help
Files := []
Folders := []
SizeKB := 0

Loop Files, Path "\*", "DFR" {
    If !InStr(GetFileAttrib(A_LoopFileFullPath), "D") {
        SizeKB += A_LoopFileSizeKB
        Files.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
        Continue
    }
    Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
}

; The File/Folder arrays now contain objects that you can reference their names or paths
; Example

For File in Files {
    MsgBox("Path: " File.Path "`nName: " File.Name)
}
; Prevents having to use SplitPath later
*/

LoopOverFolder(PATH,menu1) {
    ;static menu1 ;:= menu
    ;global menu1
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []
   ; res := Type(menu1)
    ; Loop over all files and folders in input path, but do NOT recurse
    ;Loop, Files, % PATH . "\*", F
    Loop Files, PATH  . "\*", "FD" {

    {
       ; msgbox a_loopfilefullpath
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(A_LoopFileFullPath)

        ; Current item is a directory
        if (VALUE == "D") {
            FolderArray.Push(A_LoopFileFullPath)
        }
        ; Current item is a file
        else if (VALUE == "F") {
            FileArray.Push(A_LoopFileFullPath)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    ;FolderArray.Sort(ArraySortFunction)
    ;FileArray.Sort(ArraySortFunction)

    value := ""
    for index, element in FolderArray {
        value .= element "`n"
    }

    sort(value)

    value2 := ""
    for index, element in FileArray {
        value2 .= element "`n"
    }
    sort(value2)

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element, menu1)

        ; Then add it as item to menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
       ; Menu1.Add("&" name, ":" . element)
       menuname := menu()
        menuname.Add("&" . name, MenuEventHandler)

        ; Iterate loading GUI progress
        ;FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, &name, &dir, &ext, &name_no_ext, &drive)
        Menu1.Add("&" . name, MenuEventHandler)

        ; Iterate GUI loading
        FoundItem("File")
    }
}
;return menu1
}

MenuEventHandler(Item, *) {
    msgbox "you chose: " . Item
    ; Draw the rectangle, the hourglass and update the Window
    ;Gdip_FillRectangle(G, pBrush, 0, 0, A_ScreenWidth, A_ScreenHeight)
   ; Gdip_DrawImage(G, pBitmap, A_ScreenWidth/2 - 128, A_ScreenHeight/2 - 128, Width/2, Height/2, 0, 0, Width, Height)
    ;UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

    ; Get Extension of item to evaluate what handler to use
    WordArray := StrSplit(A_ThisMenuItem, ".")
    FileExtension := WordArray[WordArray.MaxIndex()]

    ; Get full path from Menu Item pass to handler
    FileItem := SubStr(A_ThisMenuItem, 2, StrLen(A_ThisMenuItem))
    FilePath := A_ThisMenu A_ThisMenuItem

    ; Run item with appropriate handler
    Switch FileExtension {
        case "rtf":
            Handler_RTF(FilePath)
        case "bat":
            Handler_LaunchProgram(FilePath)
        case "txt":
            Handler_txt(FilePath)
        case "lnk":
            Handler_LaunchProgram(FilePath)
        case "exe":
            Handler_LaunchProgram(FilePath)
        case "ahn":
            Handler_Note(FilePath)
        Default:
            Handler_Default(FilePath)
    }

    ; Clear the graphics and update thw window
    Gdip_GraphicsClear(G)                                 ;This sets the entire area of the graphics to 'transparent'
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)  ;This is what actually changes the display
}
Handler_RTF(FilePath) {
    ; Add your code to handle RTF files here
}

Handler_LaunchProgram(FilePath) {
    ; Add your code to handle launching programs here
    Run FilePath
}

Handler_txt(FilePath) {
    ; Add your code to handle TXT files here
}

Handler_Note(FilePath) {
    ; Add your code to handle AHN files here
}

Handler_Default(FilePath) {
    ; Add your code to handle other files here
}


; Define a custom function to sort an array
; Define a custom function to sort an array
ArraySortFunc(a, b) {
    ; Compare the two elements
    if (a < b) {
        return -1
    }
    else if (a > b) {
        return 1
    }
    else {
        return 0
    }
}

; Extend the Array object with a custom Sort() method


; Define the custom Sort() method
ArraySort(arr, fnFunc := ArraySortFunc) {
    ; Sort the array using the custom function
    for i, x in arr {
        for j, y in arr {
            if (fnFunc(x, y) < 0) {
                arr.Swap(i, j)
            }
        }
    }
}
/*; Define the custom Sort() method
ArraySort(arr, fnFunc := ArraySortFunc) {
    ; Sort the array using the custom function
    for i, x in arr {
        for j, y in arr {
            if (fnFunc(x, y) < 0) {
                arr.Swap(i, j)
            }
        }
    }
}*/

; Example usage of the custom Sort() method on an array



LoopOverFolderMY(PATH) {
    DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
    DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore := 0)
    Sleep 1000

    static passedPath := PATH
    ;msgbox "In Loopoverfolder func (as a closure?)" . PATH
    ; Prepare empty arrays for folders and files
    Folders := []
    Files   := []
    SizeKB := 0

    if (passedpath := "")
    {
        ;msgbox "not passed in"
        WhichFolder := DirSelect()  ; Ask the user to pick a folder.
        Loop Files, WhichFolder "\*", "DF" {
            If !InStr(FileGetAttrib(A_loopFileFullPath), "D" ) {
            SizeKb += A_LoopFileSizeKB
            Files.push({Path: A_LoopFileFullPath, Name: A_LoopFileName})
            continue
            ;FolderSizeKB += A_LoopFileSizeKB
            }
            Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
        }
        ;MsgBox "Size of " WhichFolder " is " FolderSizeKB " KB."
    }
    else 
    {
        ;FolderSizeKB := 0
       ;msgbox passedpath . "`n passedpath var in looperfunc"
       ;msgbox PATH

       Filelist := ""
       folderlist := ""

       Loop Files, passedPATH "\*", "FD" {
           If !InStr(FileGetAttrib(A_LoopFileFullPath), "D") {
               ;SizeKB += A_LoopFileSizeKB
               FileList .= A_LoopFileTimeModified "`t" A_LoopFileName "`n"
               Files.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
               Continue
           }
           folderList .= A_LoopFileTimeModified "`t" A_LoopFileName "`n"

           Folders.Push({Path: A_LoopFileFullPath, Name: A_LoopFilename})
       }
       DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)
       MsgBox "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000000 " s"

       FileList := Sort(FileList)  ; Sort by date.
       Loop Parse, FileList, "`n"
       {
           if A_LoopField = "" ; Omit the last linefeed (blank item) at the end of the list.
               continue
           FileItem := StrSplit(A_LoopField, A_Tab)  ; Split into two parts at the tab char.
           Result := MsgBox("The next file (modified at " FileItem[1] ") is:`n" FileItem[2] "`n`nContinue?",, "y/n")
           if Result = "No"
               break
       }
       folderList := Sort(folderList)  ; Sort by date.
       Loop Parse, folderList, "`n"
       {
           if A_LoopField = "" ; Omit the last linefeed (blank item) at the end of the list.
               continue
           folderItem := StrSplit(A_LoopField, A_Tab)  ; Split into two parts at the tab char.
           Result := MsgBox("The next file (modified at " FolderItem[1] ") is:`n" folderItem[2] "`n`nContinue?",, "y/n")
           if Result = "No"
               break
       }

       looper := 0

       for Folder in Folders {
        looper++
        ;looperpaths += Folders["Path"] ;.Path

       }
       msgbox looperpaths
       msgbox looper
       
       looper := 0

       For File in Files {
        looper++
    }
    msgbox looper
    msgbox folders[150000]
        looperpaths += File.Path
           ;MsgBox("Path: " File.Path "`nName: " File.Name)

      /* Loop Files, PATH "\*.*", "DR"
            FolderArray.push([a_loopfilefullpath])

        msgbox FolderArray.Length

        Loop FolderArray.Length
        {
            MsgBox FolderArray[A_Index]
            MsgBox FolderArray[2]
            MsgBox FolderArray[3]
        }*/
        }
    

       ;block1

    ; Sort arrays to get alphabetical representation in GUI menu
    Sort(Folders)
    Sort(Files)

    ; First add all folders, so files have a place to stay
    for index, element in Folders {
        ; Recurse into next folder
        LoopOverFolderMY(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add({Text: "&" name, Name: element, Parent: dir})

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add({Text: name, Func: "MenuEventHandler", Parent: dir})

        ; Iterate GUI loading
        FoundItem("File")
    }
}

;block1
    ;msgbox FolderArray.Length
    ;for k,v in FolderArray
      ;  msgbox v.value
       ;FolderSizeKB += A_LoopFileSizeKB
   ;MsgBox "Size of " WhichFolder " is " FolderSizeKB " KB."
;}
/*; Loop over all files and folders in input path, but do NOT recurse
FileSelectObj := FileSelect(PATH . "\*", "FD")

for index, file in FileSelectObj {
    ; Current item is a directory
    if (file IsDir) {
        FolderArray.Push(file.Path)
    }
    ; Current item is a file
    else {
        FileArray.Push(file.Path)
    }
}*/


/*PrepareMenu(PATH) {
    ; Create a new Menu object
    Menu1 := Menu()

    ; GUI loading/progress bar
    Gui1 := Gui("+ToolWindow", ScriptName " is Loading") ; Adding title to progressbar
    Gui1.Add("Progress", "w200 vMyProgress range1-`%items% 0") ; Adding progressbar
    Gui1.Show() ; Displaying Progressbar

    ; Add Name, Icon and separating line
    Menu1.Add("&googler", "googler")  ; Name
    Menu1.Add("")

    ; Add all custom items using algorithm
    LoopOverFolder(PATH)

    ; Separating line
    Menu1.Add("")

    ; Add Admin Panel
    Sleep 200
    Menu1.Add("", "", PATH . "\new")
    Menu1.Add("&n test", "ReloadProgram", PATH . "\new")                                                  ; Separating line
    Menu1.Add("&3 Restart", "ReloadProgram", PATH . "\Admin")             ; Add Reload option
    Menu1.Add("&2 Exit", "ExitApp", PATH . "\Admin")                          ; Add Exit option
    Menu1.Add("&1 Go to Parent Folder", "GoToRootFolder", PATH . "\Admin")    ; Open script folder
    Menu1.Add("&4 Add Custom Item", "GoToCustomFolder", PATH . "\Admin")      ; Open custom folder

    ; Bottom sec
    Menu1.Add("&1 Admin", "", PATH . "\Admin")                        ; Adds Admin section
    Menu1.Add("&2 New", "", PATH . "\New")
    Menu1.Add("")                                                           ; Separator
    Menu1.Add("&" ScriptName " vers. " Version, "github")               ; Name
    Menu1.Add("")                                                           ; Adds Admin section

    ; Loading bar GUI is no longer needed, remove it from memory
    Gui1.Destroy()
}*/

/*LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []

    ; Loop over all files and folders in input path, but do NOT recurse
    FileSelectObj := FileSelect(PATH . "\*", "F")
    for key, file in FileSelectObj {
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(file)

        ; Current item is a directory
        if (VALUE = "D") {
            ;~ MsgBox, % "Pushing to folders`n" A_LoopFilePath
            FolderArray.Push(file)
        }
        ; Current item is a file
        else {
            ;~ MsgBox, % "Pushing to files`n" A_LoopFilePath
            FileArray.Push(file)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    for k, v in FolderArray {
        value .= v "`n"
    }
    for k, v in FileArray {
        value2 .= v "`n"
    }

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add("&" name, ":" . element)

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add(name, "MenuEventHandler")

        ; Iterate GUI loading
        FoundItem("File")
    }
}*/


/*LoopOverFolder(PATH) {
    ; Prepare empty arrays for folders and files
    FolderArray := []
    FileArray   := []

    ; Loop over all files and folders in input path, but do NOT recurse
    for file in FileSelect(PATH . "\*", "F") {
        ; Clear return value from last iteration, and assign it to attribute of current item
        VALUE := ""
        VALUE := FileExist(file)

        ; Current item is a directory
        if (VALUE = "D") {
            ;~ MsgBox, % "Pushing to folders`n" A_LoopFilePath
            FolderArray.Push(file)
        }
        ; Current item is a file
        else {
            ;~ MsgBox, % "Pushing to files`n" A_LoopFilePath
            FileArray.Push(file)
        }
    }

    ; Arrays are sorted to get alphabetical representation in GUI menu
    Sort(FolderArray)
    Sort(FileArray)

    for k, v in FolderArray {
        value .= v "`n"
    }
    for k, v in FileArray {
        value2 .= v "`n"
    }

    ; First add all folders, so files have a place to stay
    for index, element in FolderArray {
        ; Recurse into next folder
        LoopOverFolder(element)

        ; Then add it as item to menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add("&" name, ":" . element)

        ; Iterate loading GUI progress
        FoundItem("Folder")
    }

    ; Then add all files to folders
    for index, element in FileArray {
        ; Add To Menu
        SplitPath(element, name, dir, ext, name_no_ext, drive)
        Menu1.Add(name, "MenuEventHandler")

        ; Iterate GUI loading
        FoundItem("File")
    }
}*/

