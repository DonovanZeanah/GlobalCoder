#Warn All, OutputDebug
#ErrorStdOut






f24 & y::{
    tool_clock()
}


;counter := new SecondCounter
;counter.Start
;Sleep 5000
;counter.Stop
;Sleep 2000

Window_Discovery() {
    /*
        Usually you'd use the wintitle of ahk_id g_added.Hwnd, but just having a variable is 
        far easier to work with
        Using isStarted, I can Show and Destroy the gui with the same hotkey
    */
    static isStarted := False
    static var := 0 ;This is just a counter, since it's static it remembers its last value

    if isStarted { ;If the gui already exists, we just destroy it and do all the other things we need to do
        Destruction()
        return
    }

    onRightClick(*) {
        ControlClick_Here("ahk_exe sublime_text.exe", "R")
        var++
        g_added_text.Text := var
        if var >= 15 {
            Destruction()
            var := 0
        }
    }

    Destruction(*) {
        HotIfWinActive("ahk_exe Spotify.exe")
        Hotkey("RButton", "Off")
        Hotkey("Escape", "Off")
        g_added.Destroy()
        var := 0
        isStarted := False
    }

    static g_added ;We're making the gui object static so we can destroy it the next time we run the function
    g_added := Gui("AlwaysOnTop -caption")
    g_added.backColor := "171717"
    g_added.SetFont("s50 cC5C5C5", "Consolas")
    g_added_text := g_added.Add("Text", "W200 X0 Y60 Center", "0")
    g_added.Show("W200 H200 X0 Y0 NA")

    HotIfWinActive("ahk_exe Spotify.exe")
    Hotkey("RButton", _Discovery_RightClick.Bind(), "On")
    Hotkey("Escape", _Discovery_Destruction.Bind(), "On")
    g_added.OnEvent("Close", _Discovery_Destruction.Bind())
    g_added_text.OnEvent("Click", (*) => var := g_added_text.Text := g_added_text.Text - 1)
    g_added_text.OnEvent("DoubleClick", _Discovery_Destruction.Bind())

    isStarted := True ;We could technically update this variable above too, but it *feels* better in this place
}

AnimeDownload() {
    static NextEpisode := 0 

    r_AllFiles := []
    Loop Files Paths.OnePiece "\*.mp4" {
        r_AllFiles.Push(A_LoopFileName)
    }
    LastEpisode := StrReplace(r_AllFiles[-1], ".mp4", "")

    NextEpisode := LastEpisode + 1 ;We get the episode number that goes after the last downloaded episode

    RunLink("https://gogoanime.sk/one-piece-episode-" . NextEpisode) ;The last part of the link is just the episode number, so we can use this to run the link with the proper number

    PasteAndIncr := (*) => (
        ClipSend(NextEpisode), ;Clipsend is a better Send, essentially. It pastes the text instead of sending it, which is almost guaranteed to be faster. To check out the function, go to my Global library in Personal/Lib https://github.com/Axlefublr (if I just left a link to the lib, it could get outdated)
        NextEpisode++, ;This is the entire reason NextEpisode is static. Every time I download a new episode, I want the hotkey I define later to paste the *next* episode.
        /*
            So let's say the last downloaded episode is 402. I run the function and it opens the page of the 403 episode. I go on to download it and press capslock, that pastes 403. Then I download the following episode, which pastes 404. It goes on and on until one piece is finished
        */
        Send("{Enter}")
    )

    Destruction := (*) => (
        HotIfWinActive("Save As ahk_exe chrome.exe"),
        Hotkey("CapsLock", "Off"),
        HotIfWinActive("Google Chrome ahk_exe chrome.exe"),
        Hotkey("CapsLock", "Off"),
        HotIfWinActive(),
        Hotkey("Escape", "Off"),
        NextEpisode := 0,
        ToolPeek("One piece disabled")
    )
        

    HotIfWinActive("Save As ahk_exe chrome.exe")
    Hotkey("CapsLock", PasteAndIncr, "On")
    HotIfWinActive("Google Chrome ahk_exe chrome.exe")
    Hotkey("CapsLock", (*) => CloseTab(), "On")
    HotIfWinActive()
    HotIf()
    Hotkey("Escape", Destruction, "On")
    
}

tool_RelativeCoordGetter() {
    static var := 0
    static initX
    static initY
    if !var {
        MouseGetPos(&locX, &locY)
        ToolTip("Initial position")
        initX := locX ;Example mentioned in the tutorial. We *remember* the X and Y with static, so the next time we run the function, we can use those X and Y
        initY := locY
        var := !var
        return
    }
    ToolTip()
    MouseGetPos(&loc1X, &loc1Y)

    relPosX := loc1X - initX
    relPosY := loc1Y - initY

    initX := 0
    initY := 0
    var := !var

    g_relative := Gui("AlwaysOnTop")
    g_relative.BackColor := "171717"
    g_relative.SetFont("s40 cC5C5C5", "Consolas")

    g_relative_textX := g_relative.Add("Text",, "Relative X: " relPosX)
    g_relative_textY := g_relative.Add("Text",, "Relative Y: " relPosY)

    topRightCorner := A_ScreenWidth / 8 * 5

    g_relative.Show("AutoSize NA y0 x" topRightCorner)

    Destruction := (*) => (
        Hotkey("Escape", "Off"),
        Hotkey("F1", "Off"),
        Hotkey("F2", "Off"),
        g_relative.Destroy()
    )

    toClip(text, *) {
        static var := 0 ;I will most likely only need to copy the value twice. One for X, second for Y. So if I copied two values, I'm most likely done. Now when I press *a* hotkey I implemented twice, the gui and all that is deleted
        var++
        A_Clipboard := text
        ToolPeek("copied " text)
        if var >= 2
            Destruction()
    }

    g_relative_textX.OnEvent("Click", toClip.Bind(relPosX))
    g_relative_textY.OnEvent("Click", toClip.Bind(relPosY)) 

    Hotkey("F1", toClip.Bind(relPosX), "On")
    Hotkey("F2", toClip.Bind(relPosY), "On")

    g_relative.OnEvent("Close", Destruction)
    Hotkey("Escape", Destruction, "On")

}
ClipSend(toSend, endChar := " ", isClipReverted := True, untilRevert := 100) {
    /*
        Because there's no way to know whether an application has received the input we sent it with ^v
        We revert the clipboard after a certain time (untilRevert)
        If we reverted the clipboard immidiately, we'd end up sending not "toSend", but the previous clipboard instead, because we didn't give the application enough time to process the action.
        This time depends on the app, discord seems to be one of the slowest ones (don't break TOS guys), but a safe time for untilRevert seems to be 50ms. This time might be lower or higher on your machine, configure as needed
    */
   if isClipReverted
      prevClip := ClipboardAll() ;We keep the previous clipboard

    A_Clipboard := "" ;We free the clipboard...
   A_Clipboard := toSend endChar ;Now the clipboard is what we want to send + and ending character. I often need a space after so I add a space by default, you can change what it is in the second parameter
    ClipWait(1) ;...so we can make sure we filled the clipboard with what we want before we send it
    Send("{ctrl down}v{ctrl up}") ;We send it. Not ^v because this variant is more consistent

   if isClipReverted
      SetTimer(() => A_Clipboard := prevClip, -untilRevert) ;We revert the clipboard in 50ms. This doesn't occupy the thread, so the clipsend itself doesn't take 50ms, only the revert of the clipboard does.
}
tool_Clock() {

    static clock_hwnd

    if IsSet(clock_hwnd) && WinExist(clock_hwnd) {
        ; win_MinMax(clock_hwnd) ;Same thing as the code below, but drier and more reliable. Dependency on Win.ahk (https://github.com/Axlefublr/Main/blob/main/Lib/Win.ahk)
        if WinActive(clock_hwnd)
            WinMinimize(clock_hwnd)
        else
            WinActivate(clock_hwnd)
        return
    }
    
    ;Get the time variables
    clock_Time   := FormatTime(, " HH:mm:ss")
    , clock_Week := FormatTime(, "dddd")
    , clock_Date := FormatTime(, "d MMMM")

    ;Create the gui
    g_Clock := Gui(, "Clock")
    g_Clock.BackColor := "171717"

    clock_hwnd := g_Clock.hwnd

    ;Add text
    g_Clock.SetFont("S40 cC5C5C5", "Consolas")
    g_Clock_Time := g_Clock.Add("Text", "w237 y-20", clock_Time) 

    g_Clock.SetFont("S30")
    g_Clock_Week := g_Clock.Add("Text", "w237 y+35 Center", clock_Week)

    g_Clock.SetFont("S26")
    g_Clock_Date := g_Clock.Add("Text", "w237 Center", clock_Date)
    
    ;The func obj is separate because we'll need to disable the timer outside of it
    timeCheck := () => (
        g_Clock_Time.Text := FormatTime(, " HH:mm:ss"),
        g_Clock_Week.Text := FormatTime(, "dddd"),
        g_Clock_Date.Text := FormatTime(, "d MMMM")
    )

    ;Change the time text every half a second for better accuracy
    SetTimer(timeCheck, 500)

    ;Takes care of all the trash
    Destruction := (*) => ( ;the * takes care of the required parameters for hotkey and onevent
        SetTimer(timeCheck, 0), ;Since it references a function object, it can be outside of the settimer's thread
        HotIfWinActive("ahk_id " clock_hwnd),
        Hotkey("Escape", "Off"),
        g_Clock.Destroy()
    )

    HotIfWinActive("ahk_id " clock_hwnd)
    Hotkey("Escape", Destruction, "On")
    g_Clock.OnEvent("Close", Destruction)

    g_Clock.Show("W350 H320 y0 x" A_ScreenWidth / 20 * 15.3)

}

; An example class for counting the seconds...
class SecondCounter {
    __New() {
        this.interval := 1000
        this.count := 0
        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        SetTimer this.timer, this.interval
        ToolTip "Counter started"
    }
    Stop() {
        ; To turn off the timer, we must pass the same object as before:
        SetTimer this.timer, "Off"
        ToolTip "Counter stopped at " this.count
    }
    ; In this example, the timer calls this method:
    Tick() {
        ToolTip ++this.count
    }
}