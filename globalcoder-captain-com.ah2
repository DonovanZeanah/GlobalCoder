TraySetIcon "Shell32.dll", 14
tbl := TaskbarList()

activeHwnd := WinExist("A")

tbl.DeleteTab(activeHwnd)
Sleep 3000
tbl.AddTab(activeHwnd)

tbl := ""


class TaskbarList2 {
    static IID := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
    static CLSID := "{56FDF344-FD6D-11d0-958A-006097C9A090}"
    
    ; Called on startup to initialize the class.
    static __new() {
        ; Get the base object for all instances of TaskbarList.
        proto := this.Prototype
        
        ; Bound functions can be used to predefine parameters, making
        ; the methods more usable without requiring wrapper functions.
        ; HrInit itself has no parameters, so bind only the index,
        ; and the caller will implicitly provide 'this'.
        proto.HrInit := ComCall.Bind(3)
        
        ; Leave a parameter blank to let the caller provide a value.
        ; In this case, the blank parameter is 'this' (normally hidden).
        proto.AddTab := ComCall.Bind(4,, "ptr")
        
        ; An object or Map can be used to reduce repetition.
        for name, args in Map(
            "DeleteTab", [5,,"ptr"],
            "ActivateTab", [6,,"ptr"],
            "SetActiveAlt", [7,,"ptr"]) {
            proto.%name% := ComCall.Bind(args*)
        }
    }
    
    ; Called by TaskbarList() on the new instance.
    __new() {
        this.comobj := ComObject(TaskbarList.CLSID, TaskbarList.IID)
        this.ptr := this.comobj.ptr
        ; Request initialization via ITaskbarList.
        this.HrInit()
    }
}

;[]==============================[]=================================[]
word := ComObjActive("Word.Application")
if !word
    MsgBox "Word isn't open."
else
    MsgBox clipboard := word.ActiveDocument.FullName

   ; clipboard := word.ActiveDocument.FullName
    msgbox clipboard


FileName := FileSelect("S16",, "Create a new file:")
if FileName = ""
    return
GENERIC_WRITE := 0x40000000  ; Open the file for writing rather than reading.
CREATE_ALWAYS := 2  ; Create new file (overwriting any existing file).
hFile := DllCall("CreateFile", "Str", FileName, "UInt", GENERIC_WRITE, "UInt", 0, "Ptr", 0, "UInt", CREATE_ALWAYS, "UInt", 0, "Ptr", 0, "Ptr")
if !hFile
{
    MsgBox "Can't open '" FileName "' for writing."
    return
}
TestString := "This is a test string.`r`n"  ; When writing a file this way, use `r`n rather than `n to start a new line.
StrSize := StrLen(TestString) * 2
DllCall("WriteFile", "Ptr", hFile, "Str", TestString, "UInt", StrSize, "UIntP", &BytesActuallyWritten := 0, "Ptr", 0)
DllCall("CloseHandle", "Ptr", hFile)  ; Close the file.

; Now that the file was written, read its contents back into memory.
GENERIC_READ := 0x80000000  ; Open the file for reading rather than writing.
OPEN_EXISTING := 3  ; This mode indicates that the file to be opened must already exist.
FILE_SHARE_READ := 0x1 ; This and the next are whether other processes can open the file while we have it open.
FILE_SHARE_WRITE := 0x2
hFile := DllCall("CreateFile", "Str", FileName, "UInt", GENERIC_READ, "UInt", FILE_SHARE_READ|FILE_SHARE_WRITE, "Ptr", 0, "UInt", OPEN_EXISTING, "UInt", 0, "Ptr", 0)
if !hFile
{
    MsgBox "Can't open '" FileName "' for reading."
    return
}
; Allocate a block of memory for the string to read:
Buf := Buffer(StrSize)
DllCall("ReadFile", "Ptr", hFile, "Ptr", Buf, "UInt", Buf.Size, "UIntP", &BytesActuallyRead := 0, "Ptr", 0)
DllCall("CloseHandle", "Ptr", hFile)  ; Close the file.
MsgBox "The following string was read from the file: " StrGet(Buf)

;;[]==============================[]=================================[]


hModule := DllCall("LoadLibrary", "Str", "MyFunctions.dll", "Ptr")  ; Avoids the need for DllCall in the loop to load the library.
Loop Files, "C:\My Documents\*.*", "R"
    result := DllCall("MyFunctions\BackupFile", "Str", A_LoopFilePath)
DllCall("FreeLibrary", "Ptr", hModule)  ; To conserve memory, the DLL may be unloaded after using it.
;S↓


;Even faster performance can be achieved by looking up the function's address beforehand. For example:
; In the following example, if the DLL isn't yet loaded, use LoadLibrary in place of GetModuleHandle.
MulDivProc := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "kernel32", "Ptr"), "AStr", "MulDiv", "Ptr")
Loop 500
    DllCall(MulDivProc, "Int", 3, "Int", 4, "Int", 3)




;Use a Buffer to receive a string from an external function via DllCall.
max_chars := 11

; Allocate a buffer for use with the Unicode version of wsprintf.
bufW := Buffer(max_chars*2)

; Print a UTF-16 string into the buffer with wsprintfW().
DllCall("wsprintfW", "Ptr", bufW, "Str", "0x%08x", "UInt", 4919, "CDecl")

; Retrieve the string from bufW and show it.
MsgBox StrGet(bufW, "UTF-16")  ; Or just StrGet(bufW).

; Allocate a buffer for use with the ANSI version of wsprintf.
bufA := Buffer(max_chars)

; Print an ANSI string into the buffer with wsprintfA().
DllCall("wsprintfA", "Ptr", bufA, "AStr", "0x%08x", "UInt", 4919, "CDecl")

; Retrieve the string from bufA (converted to the native format), and show it.
MsgBox StrGet(bufA, "CP0")



Run "notepad.exe"
notepad_id := WinWait("Untitled - Notepad")
WinActivate notepad_id
WinMove 0, 0, A_ScreenWidth/4, A_ScreenHeight/2, notepad_id

Run "notepad.exe",,, &notepad_pid
if WinWait("ahk_pid " notepad_pid,, 5)
{
    WinActivate
    WinMove 0, 0, A_ScreenWidth/4, A_ScreenHeight/2
}


Run "notepad.exe",,, &notepad_pid
WinWait "ahk_pid " notepad_pid
WinActivate
WinMove 0, 0, A_ScreenWidth/4, A_ScreenHeight/2

Run "notepad.exe"
WinWait "ahk_exe notepad.exe"
WinActivate
WinMove 0, 0, A_ScreenWidth/4, A_ScreenHeight/2

Rect := Buffer(16)  ; Set capacity to hold four 4-byte integers.
NumPut( "Int", 0                  ; left
      , "Int", 0                  ; top
      , "Int", A_ScreenWidth//2   ; right
      , "Int", A_ScreenHeight//2  ; bottom
      , Rect)
hDC := DllCall("GetDC", "Ptr", 0, "Ptr")  ; Pass zero to get the desktop's device context.
hBrush := DllCall("CreateSolidBrush", "UInt", 0x0000FF, "Ptr")  ; Create a red brush (0x0000FF is in BGR format).
DllCall("FillRect", "Ptr", hDC, "Ptr", Rect, "Ptr", hBrush)  ; Fill the specified rectangle using the brush above.
DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)  ; Clean-up.
DllCall("DeleteObject", "Ptr", hBrush)  ; Clean-up.

;;[]==============================[]=================================[]
SetTimer WatchScrollBar, 100

WatchScrollBar()
{
    FocusedHwnd := 0
    try FocusedHwnd := ControlGetFocus("A")
    if !FocusedHwnd  ; No focused control.
        return
    ; Display the vertical or horizontal scroll bar's position in a tooltip:
    ToolTip DllCall("GetScrollPos", "Ptr", FocusedHwnd, "Int", 1)  ;  Last parameter is 1 for SB_VERT, 0 for SB_HORZ.
}


DetectHiddenWindows True
if not DllCall("IsWindowVisible", "Ptr", WinExist("Untitled - Notepad"))  ; WinExist returns an HWND.
    MsgBox "The window is not visible."


;//================
DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore := 0)
Sleep 1000
DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)
MsgBox "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000 " ms"

;//================
Run "Notepad"
WinWait "Untitled - Notepad"  ; This also sets the "last found window" for use with WinExist below.
Rect := Buffer(16)  ; A RECT is a struct consisting of four 32-bit integers (i.e. 4*4=16).
DllCall("GetWindowRect", "Ptr", WinExist(), "Ptr", Rect)  ; WinExist returns an HWND.
L := NumGet(Rect, 0, "Int"), T := NumGet(Rect, 4, "Int")
R := NumGet(Rect, 8, "Int"), B := NumGet(Rect, 12, "Int")
MsgBox Format("Left {1} Top {2} Right {3} Bottom {4}", L, T, R, B)
;[]==============================[]=================================[]
;Displays a summary of all top-level windows.
EnumAddress := CallbackCreate(EnumWindowsProc, "Fast")  ; Fast-mode is okay because it will be called only from this thread.

DetectHiddenWindows True  ; Due to fast-mode, this setting will go into effect for the callback too.

; Pass control to EnumWindows(), which calls the callback repeatedly:
DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)
MsgBox Output  ; Display the information accumulated by the callback.
    
EnumWindowsProc(hwnd, lParam)
{
    global Output
    win_title := WinGetTitle(hwnd)
    win_class := WinGetClass(hwnd)
    if win_title
        Output .= "HWND: " hwnd "`tTitle: " win_title "`tClass: " win_class "`n"
    return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}


;[]==============================[]=================================[]
TextBackgroundColor := 0xFFBBBB  ; A custom color in BGR format.
TextBackgroundBrush := DllCall("CreateSolidBrush", "UInt", TextBackgroundColor)

MyGui := Gui()
Text := MyGui.Add("Text",, "Here is some text that is given`na custom background color.")

; 64-bit scripts must call SetWindowLongPtr instead of SetWindowLong:
SetWindowLong := A_PtrSize=8 ? "SetWindowLongPtr" : "SetWindowLong"

WindowProcNew := CallbackCreate(WindowProc)  ; Avoid fast-mode for subclassing.
WindowProcOld := DllCall(SetWindowLong, "Ptr", MyGui.Hwnd, "Int", -4  ; -4 is GWL_WNDPROC
    , "Ptr", WindowProcNew, "Ptr") ; Return value must be set to "Ptr" or "UPtr" vs. "Int".

MyGui.Show

WindowProc(hwnd, uMsg, wParam, lParam)
{
    Critical
    if (uMsg = 0x0138 && lParam = Text.Hwnd)  ; 0x0138 is WM_CTLCOLORSTATIC.
    {
        DllCall("SetBkColor", "Ptr", wParam, "UInt", TextBackgroundColor)
        return TextBackgroundBrush  ; Return the HBRUSH to notify the OS that we altered the HDC.
    }
    ; Otherwise (since above didn't return), pass all unhandled events to the original WindowProc.
    return DllCall("CallWindowProc", "Ptr", WindowProcOld, "Ptr", hwnd, "UInt", uMsg, "Ptr", wParam, "Ptr", lParam)
}
/*
  Methods in ITaskbarList ¬'s VTable:
    IUnknown:
      0 QueryInterface  -- use ComObjQuery instead
      1 AddRef          -- use ObjAddRef instead
      2 Release         -- use ObjRelease instead
    ITaskbarList:
      3 HrInit
      4 AddTab
      5 DeleteTab
      6 ActivateTab
      7 SetActiveAlt
*/
IID_ITaskbarList  := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
CLSID_TaskbarList := "{56FDF344-FD6D-11d0-958A-006097C9A090}"

; Create the TaskbarList object.
tbl := ComObject(CLSID_TaskbarList, IID_ITaskbarList)

activeHwnd := WinExist("A")

ComCall(3, tbl)                     ; tbl.HrInit ¬()
ComCall(5, tbl, "ptr", activeHwnd)  ; tbl.DeleteTab ¬(activeHwnd)
Sleep 3000
ComCall(4, tbl, "ptr", activeHwnd)  ; tbl.AddTab ¬(activeHwnd)

; When finished with the object, simply replace any references with
; some other value (or if its a local variable, just return):
tbl := ""

tbl := TaskbarList()

activeHwnd := WinExist("A")

tbl.DeleteTab(activeHwnd)
Sleep 3000
tbl.AddTab(activeHwnd)

tbl := ""


class TaskbarList {
    static IID := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
    static CLSID := "{56FDF344-FD6D-11d0-958A-006097C9A090}"
    
    ; Called on startup to initialize the class.
    static __new() {
        ; Get the base object for all instances of TaskbarList.
        proto := this.Prototype
        
        ; Bound functions can be used to predefine parameters, making
        ; the methods more usable without requiring wrapper functions.
        ; HrInit itself has no parameters, so bind only the index,
        ; and the caller will implicitly provide 'this'.
        proto.HrInit := ComCall.Bind(3)
        
        ; Leave a parameter blank to let the caller provide a value.
        ; In this case, the blank parameter is 'this' (normally hidden).
        proto.AddTab := ComCall.Bind(4,, "ptr")
        
        ; An object or Map can be used to reduce repetition.
        for name, args in Map(
            "DeleteTab", [5,,"ptr"],
            "ActivateTab", [6,,"ptr"],
            "SetActiveAlt", [7,,"ptr"]) {
            proto.%name% := ComCall.Bind(args*)
        }
    }
    
    ; Called by TaskbarList() on the new instance.
    __new() {
        this.comobj := ComObject(TaskbarList.CLSID, TaskbarList.IID)
        this.ptr := this.comobj.ptr
        ; Request initialization via ITaskbarList.
        this.HrInit()
    }
}
